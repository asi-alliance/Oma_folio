import json
d = json.load(open('/tmp/Oma_folio/REASONING_INFRA/bridge_recommendations.json'))
scores = [r['bridge_score'] for r in d]
print(f'Recs: {len(d)}, Unique: {len(set(scores)) }, Range: {min(scores):.4f}-{max(scores):.4f}')
for r in d[:5]:
    print(f' {r["from"]} -> {r["to"]}: {r["bridge_score"]}')
