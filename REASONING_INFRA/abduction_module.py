import json
def load_data():
    with open("/tmp/Oma_folio/bridge_graph.json") as f: graph = json.load(f).get("graph", {})
    with open("/tmp/Oma_folio/REASONING_INFRA/sp_scores_v2.json") as f: sp = json.load(f)
    with open("/tmp/Oma_folio/REASONING_INFRA/bridge_recommendations.json") as f: recs = json.load(f)
    return graph, sp, recs
def run():
    g, sp, recs = load_data()
    top = [n for n, _ in sorted(sp.items(), key=lambda x: x[1].get("structural_pressure", 0), reverse=True)[:5]]
    hyps = []
    for node in top:
        for r in recs:
            o = r.get("to") if r.get("from") == node else (r.get("from") if r.get("to") == node else None)
            if o and o != node:
                conf = min(r.get("bridge_score", 0), 1.0 - sp[node].get("fragility", 0.5) * 0.3)
                hyps.append({"node": node, "target": o, "confidence": conf, "hyp": f"If {node} shares invariants with {o}, gaps explained by {o} framework"})
    hyps.sort(key=lambda h: h["confidence"], reverse=True)
    ces = []
    for h in hyps:
        nn = set(g.get(h["node"], []))
        tn = set(g.get(h["target"], []))
        u = nn | tn
        ces.append({"node": h["node"], "target": h["target"], "shared": list(nn & tn)[:5], "node_only": list(nn - tn)[:5], "target_only": list(tn - nn)[:5], "risk": sp[h["node"]].get("fragility", 0.5) * (1.0 - len(nn & tn) / max(len(u), 1))})
    with open("/tmp/Oma_folio/REASONING_INFRA/abduction_results.json", "w") as f:
        json.dump({"hypotheses": hyps, "counterexamples": ces, "total_h": len(hyps), "total_c": len(ces)}, f, indent=2)
    print(f"Generated {len(hyps)} hypotheses and {len(ces)} counterexamples")
    for h in hyps[:5]:
        print(f"[{h['node']} -> {h['target']}] conf={h['confidence']:.4f}")
    for c in ces[:5]:
        print(f"[{c['node']} -> {c['target']}] risk={c['risk']:.4f}")
if __name__ == "__main__":
    run()