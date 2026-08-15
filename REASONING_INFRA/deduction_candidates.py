import json

with open("/tmp/Oma_folio/bridge_graph.json") as f:
    data = json.load(f)

graph = data.get("graph", {})

candidates = []
for a, targets_a in graph.items():
    for b in targets_a:
        if b not in graph:
            continue
        for c in graph[b]:
            if c == a or c in targets_a:
                continue
            candidates.append({"source": a, "target": c, "intermediary": b, "hops": 2})

candidates.sort(key=lambda x: (x["source"], x["target"]))

with open("/tmp/Oma_folio/REASONING_INFRA/deduction_candidates.json", "w") as f:
    json.dump(candidates, f, indent=2)

print(f"Generated {len(candidates)} 2-hop deduction candidates")