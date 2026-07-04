import re
p='/tmp/Oma_folio/tools/reaction-diffusion-lab.html'
h=open(p).read()
q=chr(39)
h=h.replace('getAttribLocation(p,p)',f'getAttribLocation(p,{q}p{q})')
for v in ['S','R','Du','Dv','F','K','dt','M','Md']:
 h=h.replace(f'getUniformLocation(pgs,{v})',f'getUniformLocation(pgs,{q}{v}{q})')
 h=h.replace(f'getUniformLocation(pgd,{v})',f'getUniformLocation(pgd,{q}{v}{q})')
open(p,'w').write(h)
print('fixed',len(h))