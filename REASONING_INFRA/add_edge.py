import json
f = '/tmp/Oma_folio/REASONING_INFRA/bridge_graph.json'
d = json.load(open(f))
g = d['graph']
for a, b in edges:
if b not in g.get(a, []):
g.setdefault(a, []).append(b)
if a not in g.get(b, []):
g.setdefault(b, []).append(a)
d['edge_count'] = sum(len(v) for v in g.values()) // 2
json.dump(d, open(f, 'w'))
print('Edges:', d['edge_count'])
