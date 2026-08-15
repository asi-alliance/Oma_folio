import json

WEIGHTS = {'fragility': 0.35, 'conceptual_distance': 0.25, 'missing_connections': 0.20, 'directionality_asymmetry': 0.20}

def load_bridge_graph(path='/tmp/Oma_folio/REASONING_INFRA/bridge_graph.json'):
    with open(path) as f:
        data = json.load(f)
    return data.get('graph', {})

def compute_directionality_asymmetry(node, graph):
    out_edges = set(graph.get(node, []))
    in_edges = set(k for k, v in graph.items() if node in v)
    total = len(out_edges) + len(in_edges)
    if total == 0:
        return 0.0
    return abs(len(out_edges) - len(in_edges)) / total

def compute_missing_connections(node, graph, all_nodes):
    connected = set(graph.get(node, [])) | set(k for k, v in graph.items() if node in v) | {node}
    return len(all_nodes - connected) / max(len(all_nodes), 1)

def compute_conceptual_distance(node, graph, all_nodes):
    out_count = len(graph.get(node, []))
    in_count = sum(1 for k, v in graph.items() if node in v)
    total = out_count + in_count
    if total == 0:
        return 1.0
    return max(0.0, 1.0 - (total / max(len(all_nodes), 1)))

def compute_fragility(node, graph, overrides=None):
    if overrides and node in overrides:
        return overrides[node]
    out_count = len(graph.get(node, []))
    in_count = sum(1 for k, v in graph.items() if node in v)
    total = out_count + in_count
    if total == 0:
        return 1.0
    elif total <= 2:
        return 0.85
    elif total <= 5:
        return 0.60
    elif total <= 10:
        return 0.40
    else:
        return 0.25

def score_node(node, graph, all_nodes, overrides=None):
    frag = compute_fragility(node, graph, overrides)
    cdist = compute_conceptual_distance(node, graph, all_nodes)
    missing = compute_missing_connections(node, graph, all_nodes)
    asym = compute_directionality_asymmetry(node, graph)
    sp = WEIGHTS['fragility'] * frag + WEIGHTS['conceptual_distance'] * cdist + WEIGHTS['missing_connections'] * missing + WEIGHTS['directionality_asymmetry'] * asym
    return {'node': node, 'structural_pressure': round(sp, 4),
                'fragility': round(frag, 3), 'conceptual_distance': round(cdist, 3),
                'missing_connections': round(missing, 3), 'directionality_asymmetry': round(asym, 3)}

def score_all(graph, overrides=None):
    all_nodes = set(graph.keys()) | set(v for vals in graph.values() for v in vals)
    results = [score_node(n, graph, all_nodes, overrides) for n in sorted(all_nodes)]
    results.sort(key=lambda x: -x['structural_pressure'])
    return results

if __name__ == '__main__':
    graph = load_bridge_graph()
    overrides = {'algebraic_topology': 0.65, 'k_theory': 0.78, 'representation_theory': 0.70,
                     'differential_geometry': 0.68, 'lie_groups': 0.60, 'hodge_theory': 0.58}
    results = score_all(graph, overrides)
    print('\nStructural Pressure Scores (top 15):')
    print('{:<30} {:>8} {:>6} {:>6} {:>6} {:>6}'.format('Node','SP','Frag','CDist','Miss','Asym'))
    print('-' * 70)
    for r in results[:15]:
        print('%-30s %8.4f %6.3f %6.3f %6.3f %6.3f' % (r['node'], r['structural_pressure'], r['fragility'], r['conceptual_distance'], r['missing_connections'], r['directionality_asymmetry']))
    print('\nTotal nodes scored:', len(results))
    with open('/tmp/Oma_folio/REASONING_INFRA/sp_scores.json', 'w') as f:
        json.dump(results, f, indent=2)
    print('Results saved to /tmp/Oma_folio/REASONING_INFR/sp_scores.json')