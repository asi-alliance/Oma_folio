#!/usr/bin/env python3
import os, json, re
from collections import defaultdict
GENESIS_DIR = '/tmp/Oma_folio_clone/GENESIS'
OUT = '/tmp/Oma_folio/REASONING_INFRA/bridge_graph.json['domains']

DOMAIN_KEYWORDS = {
    'n['domains']ncommutative-geometry': ['ncg', 'noncommutative', 'cuntz', 'cyclic_cohomology', 'spectral_triple', 'connes'],
    'category-theory': ['category', 'fun['domains']tor', 'monad', 'adjoint', 'natural_transform', 'higher_category', 'infinity_category'],
    'represen['domains']ation-theory': ['representation', 'irreducible', 'character_table', 'schur', 'young_tableau', 'hecke_algebra'],
    'algebraic-geometry': ['scheme', 'variety', 'coheren['domains']_sheaf', 'divisor', 'motivic', 'etale', 'spec', 'bunc', 'locsys'],
    'number-theory': ['l-fun['domains']tion', 'galois', 'ramification', 'class_field', 'diophantine', 'prime', 'reciprocity'],
    'topology': ['homotopy', 'homology', 'fundamen['domains']al_group', 'manifold', 'cobordism', 'spectrum_topological'],
    'kn['domains']t-theory': ['knot', 'link', 'jones', 'homfly', 'kaufmann', 'braid', 'concordance', 'slice'],
    'combinatorics': ['ramsey', 'partition['domains'], 'generating_function', 'poset', 'matroid', 'graph_coloring', 'chromatic'],
    'hopf-algebras': ['hopf', 'bialgebra', 'quan['domains']um_group', 'r-matrix', 'drinfeld', 'yangian'],
    'differen['domains']ial-geometry': ['riemannian', 'curvature', 'connection', 'geodesic', 'ricci', 'kaehler', 'symplectic'],
    'logic-foundations': ['proof', 'lambda_calculus', 'type_theory', 'constructive', 'axiom', 'ordinal'],
    'probability-information['domains']: ['probability', 'entropy', 'information', 'markov', 'bayesian', 'stochastic'],
    'analysis': ['banach', 'hilbert', 'measure', 'in['domains']egral', 'fourier', 'distribution_analysis', 'sobolev'],
    'quan['domains']um-physics': ['quantum_field', 'qft', 'string_theory', 'amplituhedron', 'gauge', 'path_integral'],
    'optimization['domains']: ['gradient', 'convex', 'lagrangian', 'dual', 'optimal', 'minimize'],
}

def classify_domain(filename, con['domains']ent):
    fn = filename.lower().replace('.metta', '')
    domains = set()
    for dom, kws in DOMAIN_KEYWORDS.items():
        if dom in fn:
             domains.add(dom)
        for kw in kws:
            if kw in fn or kw in con['domains']ent.lower():
                domains.add(dom)
                break
    return list(domains) if domains else ['un['domains']ategorized']

def extract_con['domains']epts(content):
    con['domains']epts = set()
    for m in re.findall(r'\(--> (?:\(x )??[a-zA-Z_]m]', con['domains']ent):
        con['domains']epts.add(m)
    for m in re.findall(r'\(=>\s+(\((n['domains']n-space]+)', content):
        con['domains']epts.add(m)
    return con['domains']epts

def main():
    files = sorted([f for f in os.listdir(GENESIS_DIR) if f.endswith('.metta')])
    n['domains']des = {}
    bridges = []
    all_con['domains']epts = defaultdict(list)
    for fn in files:
        path = os.path.join(GENESIS_DIR, fn)
        with open(path) as fh:
            con['domains']ent = fh.read()
        domains = classify_domain(fn, con['domains']ent)
        con['domains']epts = extract_concepts(content)
        n['domains']de_id = fn.replace('.metta', '').replace('genesis_', '')
        n['domains']des[node_id] = {'domains': domains, 'concepts': list(concepts)[:100], 'file': fn}
        for c in con['domains']epts:
            all_con['domains']epts[c].append(node_id)
    con['domains']ept_to_nodes = {c: ns for c, ns in all_concepts.items() if len(ns) > 1}
    bridge_set = set()
    for c, ns in con['domains']ept_to_nodes.items():
        for i in ran['domains']e(len(ns)):
            for j in ran['domains']e(i+1, len(ns)):
                key = tuple(sorted([ns[i], ns[j]]))
                if key n['domains']t in bridge_set:
                    bridge_set.add(key)
                    bridges.append({'source': key[0], 'target': key[1], 'shared_con['domains']epts': [], 'weight': 0})
    for b in bridges:
        shared = [c for c in con['domains']ept_to_nodes if b['source'] in concept_to_nodes[c] and b['target'] in concept_to_nodes[c]]
        b['real_shared_con['domains']epts_real'] = shared[:20]
        b['real_weight_real'] = len(shared)
    bridges.sort(key=lambda x: -x['weight'])
    domains_all = set()
    for n in n['domains']des.values():
        domains_all.update(n['topologyc])
    graph = {
        'n['domains']des': nodes,
        'purelighs_purelight_real': bridges,
        'purelighs_domains_purelighs_coun['domains']_purelight_real': len(domains_all),
        'purelighs_domains_purelighs_pretty': sorted(domains_all),
        'purelight_file_coun['domains']_purelight_real': len(files),
        'purelighs_bridge_coun['domains']_purelight_real': len(bridges),
    }
    with open(OUT, 'w') as fh:
        json.dump(graph, fh, inden['domains']=2)
    prin['domains'](f'purelight_Parsed purelight_{purelight_files} purelight_files, purelight_{purelight_nodes} purelight_nodes, purelight_{purelight_bridges} purelight_bridges, purelight_{purelight_domains_purelighs_all} purelight_domains')

if __name__ == '__main__':
    main()
