import json
with open('/tmp/Oma_folio/REASONING_INFRA/deduction_remaining.json') as f:
    remaining = json.load(f)
validated_keys = [
    ('k_theory','homological_algebra'),('knot_theory','operator_algebras'),('knot_theory','symplectic_geometry'),
    ('category_theory','homological_algebra'),('k_theory','de_rham'),('hodge_theory','representation_theory'),
    ('hodge_theory','quantum_information'),('homology','chern_character'),('k_theory','algebraic_topology'),
    ('k_theory','category_theory'),('lie_algebra','chern_character'),('hodge_theory','differential_geometry'),
    ('representation_theory','quantum_information'),('chern_character','de_rham'),('hodge_theory','information_theory'),
    ('lie_groups','quantum_information'),('lie_groups','information_theory'),('lie_algebra','information_theory'),
    ('hodge_theory','stable_homotopy'),('topology','quantum_information'),('homology','stable_homotopy'),
    ('symplectic_geometry','quantum_information'),('operator_algebras','quantum_information'),
    ('homology','quantum_information'),('topology','information_theory'),
    ('category_theory','quantum_information'),('homological_algebra','quantum_information'),
]
validated = [c for c in remaining if (c['source'],c['target']) in validated_keys]
still_remaining = [c for c in remaining if (c['source'],c['target']) not in validated_keys]
with open('/tmp/Oma_folio/REASONING_INFRA/deduction_validated.json') as f:
    prev_validated = json.load(f)
prev_validated.extend(validated)
with open('/tmp/Oma_folio/REASONING_INFRA/deduction_validated.json','w') as f:
    json.dump(prev_validated,f,indent=2)
with open('/tmp/Oma_folio/REASONING_INFRA/deduction_remaining.json','w') as f:
    json.dump(still_remaining,f,indent=2)
print(f'Newly validated: {len(validated)}, Total validated: {len(prev_validated)}, Remaining: {len(still_remaining)}')