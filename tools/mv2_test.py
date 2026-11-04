import json, math

with open('/tmp/Oma_folio/abstract_genomes.json') as f:
    founders = json.load(f)

for i, g in enumerate(founders):
    g['id'] = i
    g['gen'] = 0
    g['founder'] = True
    g['parents'] = []
    g['fitness'] = 50.0
    g['appendages'] = g.get('symmetry', 3)
    g['segmentation'] = g.get('recursion', 3)
    g['scale'] = 1.0
    g['opacity'] = 0.85

environments = {
    'volcanic': {'name':'Volcanic','color':'#ff4422','bg':'#1a0a05','prefs':{'recursion':[4,8],'symmetry':[2,5],'hues':[[0,60]],'topology':['fractal','spiral','attractor']}},
    'aquatic': {'name':'Aquatic','color':'#22aaff','bg':'#050a1a','prefs':{'recursion':[3,7],'symmetry':[4,8],'hues':[[180,260]],'topology':['wave','spiral','voronoi']}},
    'crystal': {'name':'Crystal','color':'#aa44ff','bg':'#0a0515','prefs':{'recursion':[2,6],'symmetry':[5,9],'hues':[[240,320]],'topology':['tessellation','tiling','packing']}},
    'void': {'name':'Void','color':'#888888','bg':'#050505','prefs':{'recursion':[5,9],'symmetry':[1,3],'hues':[[0,30],[330,360]],'topology':['nonorientable','twist','escape']}}
}

print("Founders:", len(founders))
print("Environments:", list(environments.keys()))
print("Founder sample:", json.dumps(founders[0], indent=2)[:300])
