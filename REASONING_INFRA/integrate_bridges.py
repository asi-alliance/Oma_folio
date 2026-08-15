import json

BRIDGE_GRAPH_PATH = "/tmp/Oma_folio/bridge_graph.json"

NEW_BRIDGES = {
    "k_theory": ["quantum_information", "information_theory", "linear_algebra"],
    "lie_groups": ["quantum_information", "information_theory", "linear_algebra"],
    "representation_theory": ["quantum_information", "information_theory", "linear_algebra"],
    "descriptive_set_theory": ["quantum_information", "information_theory", "linear_algebra"],
    "differential_geometry": ["quantum_information", "information_theory", "linear_algebra"]
}

with open(BRIDGE_GRAPH_PATH) as f:
    data = json.load(f)
graph = data.get("graph", {})
added = 0
for source, targets in NEW_BRIDGES.items():
    if source not in graph:
        graph[source] = []
    for target in targets:
        if target not in graph[source]:
            graph[source].append(target)
            added += 1
data["graph"] = graph
data["total_bridges"] = sum(len(v) for v in graph.values())
all_nodes = set(graph.keys()) | set(v for vals in graph.values() for v in vals)
data["domains"] = len(all_nodes)
with open(BRIDGE_GRAPH_PATH, "w") as f:
    json.dump(data, f, indent=2)
print(f"Added {added} new bridges. Total bridges: {data['total_bridges']}, Domains: {data['domains']}")