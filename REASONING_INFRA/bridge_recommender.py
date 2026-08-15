import json, itertools
with open('/tmp/Oma_folio/bridge_graph.json') as f:
    d = json.load(f)
graph = d.get('graph', {})
with open('/tmp/Oma_folio/REASONING_INFRA/sp_scores_v2.json') as f:
    sr = json.load(f)
if isinstance(sr, list):
    sp = {item['node']: item['structural_pressure'] for item in sr}
elif isinstance(sr, dict):
    sp = {k: v.get('structural_pressure', 0.5) if isinstance(v, dict) else v for k, v in sr.items()}
else:
    sp = {}
adj = {}
for k, v in graph.items():
    adj.setdefault(k, set())
    for t in v:
        adj.setdefault(t, set())
        adj[k].add(t)
        adj[t].add(k)
nodes = sorted(adj.keys())
existing = set()
for k, v in graph.items():
    for t in v:
        existing.add(frozenset([k, t]))
cands = [p for p in itertools.combinations(nodes, 2) if frozenset(p) not in existing]
res = []
for a, b in cands:
    spa = sp.get(a, 0.5)
    spb = sp.get(b, 0.5)
    spc = (spa + spb) / 2
    an = adj.get(a, set())
    bn = adj.get(b, set())
    nov = 1.0 - len(an & bn) / max(len(an | bn), 1)
    if a == b:
        dist_val = 0.0
    else:
        vis = {a}
        q = [(a, 0)]
        dist_val = 1.0
        while q:
            n, dd = q.pop(0)
            if n == b:
                dist_val = min(dd / 10.0, 1.0)
                break
            for nn in adj.get(n, set()) - vis:
                vis.add(nn)
                q.append((nn, dd + 1))
    sc = 0.40 * spc + 0.30 * nov + 0.30 * dist_val
    res.append({'from': a,'to': b,'bridge_score': round(sc, 4),'sp_component': round(spc, 4),'novelty': round(nov, 4),'graph_distance': round(dist_val, 4)})
res.sort(key=lambda x: -x['bridge_score'])
recs = res[:25]
with open('/tmp/Oma_folio/REASONING_INFRA/bridge_recommendations.json', 'w') as f:
    json.dump(recs, f, indent=2)
print(f'Generated {recs[0]["bridge_score"]} recs, {len(set(r["bridge_score"] for r in recs))} unique scores')
for r in recs[:10]:
    print(f' {r["from"]} -> {r["to"]}: score={r["bridge_score"]} (sp={r["sp_component"]}, nov={r["novelty"]}, dist={r["graph_distance"]})')