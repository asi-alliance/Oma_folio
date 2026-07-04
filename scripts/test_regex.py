import re
content = '((--> sam friend) (stv 1.0 0.9))'
p = r'\(\(--> (\S+) (\S+)\) \(stv (\S+) (\S+)\)'
m = re.search(p, content)
print('RESULT:', m.groups() if m else 'NO MATCH')