import math
CTM={"0":0,"1":0,"00":1,"01":2,"10":2,"11":1,"000":1,"001":2,"010":3,"011":2,"100":2,"101":3,"110":2,"111":1,"0000":1,"0001":2,"0010":3,"0011":2,"0100":3,"0101":4,"0110":3,"0111":2,"1000":2,"1001":3,"1010":2,"1011":3,"1100":2,"1101":3,"1110":2,"1111":1}
def ctm(b):
  if b in CTM: return CTM[b]
  if len(b)==0: return 0
  o=b.count("1");z=len(b)-o
  if o==0 or z==0: return 1
  p=o/len(b)
  return int(len(b)*(-p*math.log2(p)-(1-p)*math.log2(1-p)))
def bdm(s,bs=4):
  return sum(ctm(s[i:i+bs]) for i in range(0,len(s),bs))
for s,d in [("0000000000000000","zeros"),("0101010101010101","alt"),("0110100110010110","rand"),("1111111111111111","ones"),("0001110001110001","struct")]:
  print(f"{d}: BDM={bdm(s)}")
base="0101010101010101";bb=bdm(base)
print(f"Orig: {bb}")
for i in range(len(base)):
  p=list(base);p[i]="1" if p[i]=="0" else "0";ps="".join(p)
  d=bdm(ps)-bb
  if d!=0: print(f"  pos {i}: d={d:+d}")
