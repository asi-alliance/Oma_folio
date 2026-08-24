import re, collections, os
a = collections.defaultdict(set)
for f in os.listdir("/tmp/Oma_folio/GENESIS"):
 if f.endswith(".metta"):
  t = open("/tmp/Oma_folio/GENESIS/"+f).read()
  for m in re.findall(r"=s+(([A-Za-z0-9_-]+)", t):
   a[m].add(f)
gaps = [(atom, len(domains)) for atom, domains in a.items() if len(domains) == 1]
gaps.sort(key=lambda x: x[1])
print("Total atoms:", len(a))
print("Isolated atoms (1 domain only):", len(gaps))
print("Bridge atoms (2+ domains):", len(a) - len(gaps))
print("---")
print("Top 20 synthesis targets (isolated, need bridge connections):")
for atom, count in gaps[:20]:
 print("  " + atom + " [" + str(count) + " domain]")
