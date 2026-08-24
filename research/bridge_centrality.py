import re,collections,os
a=collections.defaultdict(set)
for f in os.listdir("/tmp/Oma_folio/GENESIS"):
 if f.endswith(".metta"):
  t=open("/tmp/Oma_folio/GENESIS/"+f).read()
  for m in re.findall(r"=\s+\(([A-Za-z0-9_-]+)",t):
   a[m].add(f)
print("Total atoms:",len(a))
print("---")
for x,y in sorted(a.items(),key=lambda z:len(z[1]),reverse=True)[:30]:
 print(x,len(y),round(len(y)/5,2))
