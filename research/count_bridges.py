import re, collections, osa = collections.defaultdict(set)
genesis = "/tmp/Oma_folio/GENESIS"
for f in os.listdir(genesis):
if f.endswith('.metta'):
t = open(genesis + '/' + f).read()
for m in re.findall(r'=s+[(]([A-Za-z0-9_-]+)', t):
a[m].add(f[:-5])
bridges = {k: v for k, v in a.items() if len(v) >= 2}
print('Total:', len(a), 'Bridges:', len(bridges))
for k, v in sorted(bridges.items(), key=lambda x: len(x[1]), reverse=True)[:15]:
print(' ', k, sorted(v))
