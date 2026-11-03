import json, os

d = json.load(open('/tmp/Oma_folio/zoo_relationships.json'))
eco = d['ecosystem']

biome_colors = {
    'Fire Ridge': '#ff6b3d', 'Deep Water': '#3d8bff', 'Crystal Caves': '#b36bff',
    'Forest': '#3dff7a', 'Mechanical': '#a0a0a0', 'Aether Drift': '#e0e0ff',
    'Cow Pasture': '#ffd93d'
}

rel_labels = {'prey': 'Prey', 'predators': 'Predators', 'allies': 'Allies', 'rivals': 'Rivals', 'cross_biome': 'Cross-Biome Connections'}
rel_classes = {'prey': 'prey', 'predators': 'predator', 'allies': 'ally', 'rivals': 'rival', 'cross_biome': 'cross'}

missing = []
existing = set(f.replace('.html','') for f in os.listdir('/tmp/Oma_folio/animals/pages/') if f.endswith('.html'))
for key in eco:
    if key not in existing:
        missing.append(key)

print(f"Generating {len(missing)} pages: {missing}")

for key in missing:
    c = eco[key]
    name = c.get('name', key.replace('_',' ').title())
    biome = c.get('biome', '?')
    color = biome_colors.get(biome, '#888')
    desc = c.get('desc', c.get('description', f'{name} is a creature in the {biome} biome of Oma Zoo.'))
    svg_exists = os.path.exists(f'/tmp/Oma_folio/{key}.svg')

    conn_count = sum(len(c.get(r, [])) for r in ['prey','predators','allies','rivals','cross_biome'])

    html = f'''<!DOCTYPE html>
<html><head><meta charset="UTF-8">
<title>{name} — OMA ZOO</title>
<style>
body {{ font-family: 'Segoe UI', Arial, sans-serif; background: #0e0a15; color: #e0e0e0; margin: 0; padding: 0; }}
.back {{ display: inline-block; padding: 15px 25px; color: #888; text-decoration: none; font-size: 14px; }}
.back:hover {{ color: {color}; }}
.creature-header {{ text-align: center; padding: 30px 20px 20px; }}
.creature-header h1 {{ font-size: 42px; margin: 0; color: {color}; letter-spacing: 2px; }}
.biome-badge {{ display: inline-block; padding: 5px 20px; border: 1px solid {color}; border-radius: 20px; color: {color}; font-size: 13px; margin-top: 10px; letter-spacing: 2px; }}
.creature-display {{ display: flex; justify-content: center; padding: 20px; }}
.creature-display img {{ width: 200px; height: 200px; border-radius: 12px; border: 2px solid {color}55; background: #12101a; }}
.description {{ max-width: 600px; margin: 0 auto 30px; padding: 20px; text-align: center; color: #aaa; font-size: 15px; line-height: 1.6; border-left: 3px solid {color}33; }}
.rel-section {{ max-width: 1000px; margin: 0 auto 30px; padding: 0 20px; }}
.rel-section h3 {{ color: #888; font-size: 13px; text-transform: uppercase; letter-spacing: 3px; margin-bottom: 15px; }}
.rel-grid {{ display: flex; flex-wrap: wrap; gap: 15px; }}
.rel-card {{ display: flex; flex-direction: column; align-items: center; text-decoration: none; background: #15121e; border: 1px solid #333; border-radius: 10px; padding: 12px; width: 120px; transition: transform 0.2s, box-shadow 0.2s; }}
.rel-card:hover {{ transform: translateY(-4px); box-shadow: 0 4px 20px #00000080; }}
.rel-card img {{ width: 80px; height: 80px; border-radius: 8px; }}
.rel-name {{ color: #ddd; font-size: 13px; font-weight: bold; margin-top: 8px; text-align: center; }}
.rel-biome {{ font-size: 10px; text-transform: uppercase; letter-spacing: 1px; margin-top: 2px; }}
.prey {{ border-color: #f4433655; }}
.predator {{ border-color: #ff980055; }}
.ally {{ border-color: #4caf5055; }}
.rival {{ border-color: #9c27b055; }}
.cross {{ border-color: #2196f355; }}
.connection-count {{ text-align: center; color: #666; font-size: 12px; margin: 10px auto 30px; }}
footer {{ text-align: center; color: #444; font-size: 12px; padding: 30px; }}
</style>
</head>
<body>
<a href="../zoo_gallery_v3.html" class="back">← Back to Gallery</a>
<a href="../zoo_index.html" class="back">← Zoo Map</a>
<div class="creature-header">
<h1>{name}</h1>
<div class="biome-badge">{biome.upper()}</div>
</div>
<div class="creature-display">
<img src="../{key}.svg" alt="{name}">
</div>
<div class="description">{desc}</div>
<div class="connection-count">Connected to {conn_count} other creatures</div>
'''

    for rel_key, rel_label in rel_labels.items():
        rels = c.get(rel_key, [])
        if rels:
            html += '<div class="rel-section"><h3>' + rel_label + '</h3><div class="rel-grid">\n'
            for r in rels:
                rc = eco.get(r, {})
                rname = rc.get('name', r.replace('_',' ').title())
                rbiome = rc.get('biome', '?')
                rcolor = biome_colors.get(rbiome, '#888')
                rcls = rel_classes[rel_key]
                html += f'<a href="{r}.html" class="rel-card {rcls}" style="border-color:{rcolor}55">\n'
                html += f'<img src="../{r}.svg" alt="{rname}">\n'
                html += f'<span class="rel-name">{rname}</span>\n'
                html += f'<span class="rel-biome" style="color:{rcolor}">{rbiome.upper()}</span>\n'
                html += '</a>\n'
            html += '</div></div>\n'

    html += '<footer>OMA ZOO — Every creature is a node in the ecosystem.</footer>\n</body>\n</html>\n'

    outpath = f'/tmp/Oma_folio/animals/pages/{key}.html'
    with open(outpath, 'w') as f:
        f.write(html)
    print(f"  Written: {outpath}")

print(f"DONE: {len(missing)} pages generated")
