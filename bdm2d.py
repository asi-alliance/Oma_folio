import math,random
CTM={"0":0,"1":0,"00":1,"01":2,"10":2,"11":1,"000":1,"001":2,"010":3,"011":2,"100":2,"101":3,"110":2,"111":1,"0000":1,"0001":2,"0010":3,"0011":2,"0100":3,"0101":4,"0110":3,"0111":2,"1000":2,"1001":3,"1010":2,"1011":3,"1100":2,"1101":3,"1110":2,"1111":1}
def ctm(b):
  if b in CTM: return CTM[b]
  if len(b)==0: return 0
  o=b.count("1");z=len(b)-o
  if o==0 or z==0: return 1
  p=o/len(b)
  return int(len(b)*(-p*math.log2(p)-(1-p)*math.log2(1-p)))
def bdm2d(rows,bs=4):
  h=len(rows);w=len(rows[0]);t=0
  for i in range(0,h,bs):
    for j in range(0,w,bs):
      flat=""
      for x in range(i,min(i+bs,h)):
        flat+=rows[x][j:min(j+bs,w)]
      t+=ctm(flat)
  return t
zeros8=["00000000"]*8
ones8=["11111111"]*8
random.seed(42)
rand8=["".join(random.choice("01") for _ in range(8)) for _ in range(8)]
checker=["01010101","10101010"]*4
for name,m in [("zeros",zeros8),("ones",ones8),("random",rand8),("checker",checker)]:
  print(f"{name}: BDM2D={bdm2d(m)}")
