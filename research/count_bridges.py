import os,glob,collections
a=collections.defaultdict(set)
for f in glob.glob("/tmp/Oma_folio/GENESIS/*.metta"):
    for l in open(f):
        if "= (" in l:
            parts=l.split("(")
            if len(parts)>=3:
                atom=parts[2].split()[0].rstrip(")")
                a[atom].add(os.path.basename(f)[:-5])
print("Total:",len(a),"Bridges:",sum(1 for v in a.values() if len(v)>=2),"Isolated:",sum(1 for v in a.values() if len(v)==1))
