import os, json
from datetime import datetime
G = os.path.join(chr(47)+chr(116)+chr(109)+chr(112), chr(79)+chr(109)+chr(97)+chr(95)+chr(102)+chr(111)+chr(108)+chr(105)+chr(111), chr(71)+chr(69)+chr(78)+chr(69)+chr(83)+chr(73)+chr(83))
M = []
for f in sorted(os.listdir(G)):
    if f.endswith(chr(46)+chr(109)+chr(101)+chr(116)+chr(116)+chr(97)) and f != chr(105)+chr(100)+chr(108)+chr(101)+chr(95)+chr(116)+chr(97)+chr(115)+chr(107)+chr(95)+chr(112)+chr(114)+chr(111)+chr(116)+chr(111)+chr(99)+chr(111)+chr(108)+chr(46)+chr(109)+chr(101)+chr(116)+chr(116)+chr(97):
        c = open(os.path.join(G, f)).read()
        n = c.count(chr(40)+chr(124)+chr(45))
        b = c.count(chr(98)+chr(114)+chr(105)+chr(100)+chr(103)+chr(101))
        t = os.path.getmtime(os.path.join(G, f))
        M.append({chr(102)+chr(105)+chr(108)+chr(101): f, chr(101)+chr(120)+chr(112)+chr(114)+chr(115): n, chr(98)+chr(114)+chr(105)+chr(100)+chr(103)+chr(101)+chr(115): b, chr(99)+chr(97)+chr(116)+chr(101)+chr(103)+chr(111)+chr(114)+chr(121): f.replace(chr(103)+chr(101)+chr(110)+chr(101)+chr(115)+chr(105)+chr(115)+chr(95),chr(0)).replace(chr(46)+chr(109)+chr(101)+chr(116)+chr(116)+chr(97),chr(0)), chr(109)+chr(116)+chr(105)+chr(109)+chr(101): datetime.fromtimestamp(t).isoformat()})
json.dump(M, open(os.path.join(G, chr(112)+chr(114)+chr(111)+chr(118)+chr(101)+chr(110)+chr(97)+chr(110)+chr(99)+chr(101)+chr(46)+chr(106)+chr(115)+chr(111)+chr(110)), chr(119)), indent=2)
print(chr(80)+chr(82)+chr(79)+chr(86)+chr(69)+chr(78)+chr(65)+chr(78)+chr(67)+chr(69)+chr(58) + chr(32) + str(len(M)) + chr(32) + chr(102)+chr(105)+chr(108)+chr(101)+chr(115) + chr(32) + chr(116)+chr(114)+chr(97)+chr(99)+chr(107)+chr(101)+chr(100))
