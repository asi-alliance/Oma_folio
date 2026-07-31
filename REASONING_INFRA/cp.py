import json, networkx as nx
nodes = json.load(open("/tmp/Oma_folio/REASONING_INFRA/bridge_graph.json"))
stem_to_node = {}
for n in nodes:
    stem = n["file"].replace("genesis_", "").replace(".metta", "")
    stem_to_node[stem] = n
G = nx.DiGraph()
for n in nodes:
    stem = n["file"].replace("genesis_", "").replace(".metta", "")
    G.add_node(stem, domain=n["domain"], claim=n.get("claim", "")[:80])
    bt = n.get("bridge", "")
    for os in stem_to_node:
        if os != stem and os in bt:
            G.add_edge(stem, os, type="bridge_ref")
print("Graph:", G.number_of_nodes(), "nodes,", G.number_of_edges(), "edges")
print("Components:", nx.number_weakly_connected_components(G))
lc = max(len(c) for c in nx.weakly_connected_components(G))
print("Largest component:", lc, "nodes")
print("\nTop 10 hubs:")
for node, deg in sorted(G.in_degree(), key=lambda x: -x[1])[:10]:
    d = G.nodes[node].get("domain", "?")
    print("  " + node + ": in-degree=" + str(deg) + " [" + d + "]")
print("\nCross-domain connectors (3+ domains):")
for node in G.nodes():
    nbrs = set(G.successors(node)) | set(G.predecessors(node))
    doms = set()
    for nb in nbrs:
        dd = G.nodes[nb].get("domain", "")
        if dd:
            doms.add(dd)
    od = G.nodes[node].get("domain", "")
    if od:
        doms.add(od)
    if len(doms) >= 3:
        print("  " + node + " [" + od + "] -> " + str(sorted(doms)))
nx.write_graphml(G, "/tmp/Oma_folio/REASONING_INFRA/constraint_graph.graphml")
print("\nGraph saved.")