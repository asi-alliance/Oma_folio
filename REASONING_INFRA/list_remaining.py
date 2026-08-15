import json
d = json.load(open('/tmp/Oma_folio/REASONING_INFRA/deduction_remaining.json'))
print('Remaining:', len(d))
for c in d[:12]:
    print('  ', c['source'], '->', c['target'])