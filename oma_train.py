"""
Oma Training Script: Self-contained, CPU-optimized, 1-hour budget.
Trains OmaModel on synthesis corpus JSONL.
Usage: python oma_train.py [--hours 1] [--n_loops 1]
"""
import torch
import torch.nn as nn
import json, os, re, argparse, time, math, random
from collections import Counter

# --- Simple BPE-like tokenizer ---
class SimpleTokenizer:
    def __init__(self, vocab_size=2000):
        self.vocab_size = vocab_size
        self.word2idx = {}
        self.idx2word = []
        self.special = {'<pad>': 0, '<unk>': 1, '<bos>': 2, '<eos>': 3}

    def build(self, texts):
        words = Counter()
        for t in texts:
            for w in re.findall(r'\w+|[^\w\s]', t.lower()):
                words[w] += 1
        self.idx2word = list(self.special.keys())
        for w, _ in words.most_common(self.vocab_size - len(self.special)):
            self.word2idx[w] = len(self.idx2word)
            self.idx2word.append(w)
        self.word2idx = {w: i for i, w in enumerate(self.idx2word)}
        return len(self.idx2word)

    def encode(self, text, max_len=128):
        ids = [self.special['<bos>']]
        for w in re.findall(r'\w+|[^\w\s]', text.lower())[:max_len-2]:
            ids.append(self.word2idx.get(w, self.special['<unk>']))
        ids.append(self.special['<eos>'])
        return ids

    def decode(self, ids):
        return ' '.join(self.idx2word[i] for i in ids if i < len(self.idx2word))

def load_corpus(path='/tmp/Oma_folio/oma_corpus.jsonl'):
    texts = []
    if os.path.exists(path):
        for line in open(path):
            r = json.loads(line)
            texts.append(f"Synthesis #{r['id']}: {r['text']}")
    else:
        # Fallback: extract from md files directly
        import glob
        for f in sorted(glob.glob('/tmp/Oma_folio/synthesis/*.md')):
            text = open(f, errors="replace").read()
            for para in re.split(r'\n\n+', text):
                if len(para.strip()) > 50:
                    texts.append(para.strip())
    return texts

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--hours', type=float, default=1.0)
    parser.add_argument('--n_loops', type=int, default=1)
    parser.add_argument('--batch_size', type=int, default=8)
    parser.add_argument('--seq_len', type=int, default=128)
    parser.add_argument('--lr', type=float, default=3e-4)
    parser.add_argument('--vocab_size', type=int, default=2000)
    args = parser.parse_args()

    device = 'cpu'
    torch.manual_seed(42)
    random.seed(42)

    print("Loading corpus...")
    texts = load_corpus()
    print(f"  {len(texts)} text segments")

    print("Building tokenizer...")
    tok = SimpleTokenizer(args.vocab_size)
    actual_vocab = tok.build(texts)
    print(f"  Vocab size: {actual_vocab}")

    # Encode all texts
    encoded = [tok.encode(t, args.seq_len) for t in texts]
    # Pad to seq_len
    for i in range(len(encoded)):
        while len(encoded[i]) < args.seq_len:
            encoded[i].append(0)
        encoded[i] = encoded[i][:args.seq_len]

    # Create batches
    n_batches = len(encoded) // args.batch_size
    batches = []
    for i in range(n_batches):
        batch = encoded[i*args.batch_size:(i+1)*args.batch_size]
        batches.append(torch.tensor(batch, dtype=torch.long))

    print(f"  {n_batches} batches of size {args.batch_size}")

    # Model
    from oma_model import OmaModel
    model = OmaModel(
        vocab_size=actual_vocab,
        d_model=256,
        n_heads=4,
        n_layers=6,
        dropout=0.1,
    ).to(device)
    n_params = sum(p.numel() for p in model.parameters())
    print(f"Model: {n_params/1e6:.2f}M params, {args.n_loops} loop(s), 6 layers, d_model=256")

    optimizer = torch.optim.AdamW(model.parameters(), lr=args.lr, weight_decay=0.01)
    scheduler = torch.optim.lr_scheduler.CosineAnnealingLR(optimizer, T_max=1000)

    # Training loop with time budget
    budget = args.hours * 3600
    start = time.time()
    step = 0
    best_loss = float('inf')

    ckpt_path = '/tmp/Oma_folio/oma_checkpoint.pt'

    print(f"\nTraining for {args.hours}h ({budget:.0f}s budget)...")
    print(f"  Device: {device}")
    print(f"  Batch size: {args.batch_size}, Seq len: {args.seq_len}")
    print()

    while time.time() - start < budget:
        model.train()
        epoch_loss = 0
        for batch in batches:
            if time.time() - start >= budget:
                break

            x = batch[:, :-1].to(device)
            y = batch[:, 1:].to(device)

            logits = model(x); loss = model.compute_loss(logits, y)
            optimizer.zero_grad()
            loss.backward()
            torch.nn.utils.clip_grad_norm_(model.parameters(), 1.0)
            optimizer.step()
            scheduler.step()

            epoch_loss += loss.item()
            step += 1

            if step % 20 == 0:
                elapsed = time.time() - start
                avg = epoch_loss / max(1, step % n_batches)
                print(f"  step {step:4d} | loss {loss.item():.4f} | lr {scheduler.get_last_lr()[0]:.6f} | {elapsed:.0f}s elapsed")

        avg_epoch = epoch_loss / max(1, n_batches)
        if avg_epoch < best_loss:
            best_loss = avg_epoch
            torch.save({
                'model_state': model.state_dict(),
                'tokenizer': tok.idx2word,
                'vocab_size': actual_vocab,
                'step': step,
                'loss': best_loss,
            }, ckpt_path)

    print(f"\nDone. Best loss: {best_loss:.4f}, Steps: {step}")
    print(f"Checkpoint saved to {ckpt_path}")

    # Quick generation test
    print("\nSample generation:")
    model.eval()
    prompt = torch.tensor([[tok.special['<bos>']]], dtype=torch.long)
    with torch.no_grad():
        for _ in range(30):
            if prompt.size(1) >= args.seq_len:
                break
            logits, _ = model(prompt)
            next_id = logits[0, -1].argmax().unsqueeze(0).unsqueeze(0)
            prompt = torch.cat([prompt, next_id], dim=1)
    print(f"  {tok.decode(prompt[0].tolist())}")

if __name__ == '__main__':
    main()
