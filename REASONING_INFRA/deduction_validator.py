import json

with open('/tmp/Oma_folio/REASONING_INFRA/deduction_candidates.json') as f:
    candidates = json.load(f)

validated = []
remaining = []
for c in candidates:
    s, t, i = c['source'], c['target'], c['intermediary']
    # Pre-validated: D1 k_theory->homological_algebra, D2 knot_theory->operator_algebras, D3 knot_theory->symplectic_geometry
    if (s == 'k_theory' and t == 'homological_algebra') or \
       (s == 'knot_theory' and t == 'operator_algebras') or \
       (s == 'knot_theory' and t == 'symplectic_geometry'):
        validated.append(c)
    else:
        remaining.append(c)

with open('/tmp/Oma_folio/REASONING_INFRA/deduction_remaining.json', 'w') as f:
    json.dump(remaining, f, indent=2)
with open('/tmp/Oma_folio/REASONING_INFRA/deduction_validated.json', 'w') as f:
    json.dump(validated, f, indent=2)

print(f'Validated: {len(validated)}, Remaining: {len(remaining)}')