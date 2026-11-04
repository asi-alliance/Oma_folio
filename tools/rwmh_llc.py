import sys; sys.path.insert(0, '/tmp/Oma_folio')
from lora_rlct_experiment import *
import numpy as np, torch, torch.nn as nn, json, argparse

def compute_loss(model, data):
    X, y = data
    with torch.no_grad():
        return nn.functional.mse_loss(model(X), y).item()

def rwmh_llc(model, train_data, temps, n_steps, burnin):
    X, y = train_data; n = X.shape[0]; L0 = compute_loss(model, train_data)
    params = [p for p in model.parameters() if p.requires_grad]
    shapes = [p.shape for p in params]; sizes = [p.numel() for p in params]
    def get_flat():
        return torch.cat([p.data.view(-1) for p in params])
    def set_flat(f):
        idx = 0
        for i, p in enumerate(params):
            p.data.copy_(f[idx:idx+sizes[i]].view(shapes[i])); idx += sizes[i]
    llc_vals = []
    for T in temps:
        sigma = (2.0*T/n)**0.5
        cur = get_flat().clone(); cur_loss = L0; losses = []
        n_accept = 0
        for step in range(n_steps):
            prop = cur + sigma * torch.randn_like(cur)
            set_flat(prop); prop_loss = compute_loss(model, train_data)
            if torch.log(torch.rand(1)) < -n*(prop_loss - cur_loss)/T:
                cur = prop; cur_loss = prop_loss; n_accept += 1
            if step >= burnin: losses.append(cur_loss)
        excess = float(np.mean(losses)) - L0
        llc_vals.append(excess/T)
        print('  T=%.4f L0=%.6f E[L]=%.6f excess=%.6f LLC=%.4f accept=%.2f' % (T, L0, float(np.mean(losses)), excess, excess/T, n_accept/n_steps))
    return float(np.median(llc_vals)), llc_vals

def run_rwmh(d_input, d_hidden, max_rank, n_vals, epochs, temps, n_steps, burnin):
    ranks = [0] + list(range(1, max_rank+1)); results = []
    for n_train in n_vals:
        tr, te = make_toy_dataset(n_train, 1000, d_input, seed=42)
        for rank in ranks:
            label = 'full-FT' if rank == 0 else 'LoRA-r%d' % rank
            model = ToyMLP(d_input, d_hidden, rank=rank)
            L0 = train_model(model, tr, n_epochs=epochs, lr=0.005)
            llc, llc_vals = rwmh_llc(model, tr, temps, n_steps, burnin)
            with torch.no_grad():
                gap = nn.functional.mse_loss(model(te[0]), te[1]).item() - nn.functional.mse_loss(model(tr[0]), tr[1]).item()
            results.append({'n': n_train, 'rank': rank, 'label': label, 'L0': L0, 'llc': llc, 'llc_vals': llc_vals, 'gen_gap': gap})
            print('%s n=%d L0=%.6f llc=%.4f gap=%.6f' % (label, n_train, L0, llc, gap))
    # Analysis
    print('=== ANALYSIS ===')
    for n_train in n_vals:
        entries = [r for r in results if r['n'] == n_train]
        llcs = [(r['rank'], r['llc']) for r in entries]
        llcs.sort()
        monotone = all(llcs[i][1] <= llcs[i+1][1] for i in range(len(llcs)-1))
        print('H1 (LLC monotone in rank, n=%d): %s - %s' % (n_train, 'PASS' if monotone else 'FAIL', llcs))
    best_ranks = []
    for n_train in n_vals:
        entries = [r for r in results if r['n'] == n_train]
        best = min(entries, key=lambda x: x['gen_gap'])
        best_ranks.append((n_train, best['rank']))
    print('Optimal rank per n:', best_ranks)
    return results

if __name__ == '__main__':
    p = argparse.ArgumentParser()
    p.add_argument('--d_input', type=int, default=4)
    p.add_argument('--d_hidden', type=int, default=8)
    p.add_argument('--max_rank', type=int, default=2)
    p.add_argument('--n_train_values', type=int, nargs='+', default=[30,60])
    p.add_argument('--epochs', type=int, default=300)
    p.add_argument('--temperatures', type=float, nargs='+', default=[0.005,0.01,0.02])
    p.add_argument('--n_steps', type=int, default=500)
    p.add_argument('--burnin', type=int, default=200)
    p.add_argument('--output', type=str, default='/tmp/Oma_folio/rwmh_results.json')
    a = p.parse_args()
    print('RWMH LLC Experiment v2'); print('='*50)
    r = run_rwmh(a.d_input, a.d_hidden, a.max_rank, a.n_train_values, a.epochs, a.temperatures, a.n_steps, a.burnin)
    json.dump(r, open(a.output, 'w'), indent=2); print('Saved to', a.output)
