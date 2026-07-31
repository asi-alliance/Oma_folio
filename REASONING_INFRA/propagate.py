import json, networkx as nx
G = nx.read_graphml("/tmp/Oma_folio/REASONING_INFRA/constraint_graph.graphml")
def propagate(active, max_depth=5):
    reachable = set(active)
    frontier = set(active)
    chains = {a: [[a]] for a in active}
    for depth in range(max_depth):
        new_frontier = set()
        for node in frontier:
            for succ in G.successors(node):
                if succ not in reachable:
                    new_frontier.add(succ)
                    chains[succ] = [c + [succ] for c in chains.get(node, [])]
            for pred in G.predecessors(node):
                if pred not in reachable:
                    new_frontier.add(pred)
                    chains[pred] = [c + [pred] for c in chains.get(node, [])]
        if not new_frontier:
            break
        reachable |= new_frontier
        frontier = new_frontier
        print("Depth", depth+1, ":", len(new_frontier), "new nodes, total", len(reachable))
    return reachable, chains
hubs = ["homology", "k_theory", "information_geometry"]
for h in hubs:
    if h in G:
        print("
=== Propagation from", h, "===")
        r, ch = propagate([h])
        print("Reachable:", len(r), "nodes")
        domains = set()
        for node in r:
            d = G.nodes[node].get("domain", "")
            if d: domains.add(d)
        print("Domains touched:", sorted(domains))
        print("Longest chains:")
        longest = sorted(ch.items(), key=lambda x: max(len(c) for c in x[1]), reverse=True)[:5]
        for node, paths in longest:
            best = max(paths, key=len)
            print("  ", " -> ".join(best[:6]), "...", "[" + G.nodes[node].get("domain","?") + "]")