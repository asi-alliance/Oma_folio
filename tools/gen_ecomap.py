import json, math

d = json.load(open('/tmp/Oma_folio/zoo_relationships.json'))
eco = d['ecosystem']

# Discover biomes dynamically from JSON
biomes = {}
for k, v in eco.items():
    biomes.setdefault(v['biome'], []).append(k)

biome_order = sorted(biomes.keys())
biome_colors = {'Fire Ridge': '#ff6b3d', 'Deep Water': '#3d8bff', 'Crystal Caves': '#b36bff', 'Forest': '#3dff7a', 'Mechanical': '#a0a0a0', 'Aether Drift': '#e0e0ff', 'Cow Pasture': '#ffd93d'}

W, H = 1200, 1000
cx, cy = W//2, H//2
R = 350
nr = 70

n = len(biome_order)
biome_centers = {}
for i, b in enumerate(biome_order):
    angle = -math.pi/2 + 2*math.pi*i/n
    biome_centers[b] = (cx + R*math.cos(angle), cy + R*math.sin(angle))

node_pos = {}
for b in biome_order:
    creatures = biomes.get(b, [])
    bx, by = biome_centers[b]
    m = len(creatures)
    for j, c in enumerate(creatures):
        if m == 1:
            node_pos[c] = (bx, by)
        else:
            a = 2*math.pi*j/m
            node_pos[c] = (bx + nr*math.cos(a), by + nr*math.sin(a))

svg = f'<svg xmlns="http://www.w3.org/2000/svg" width="{W}" height="{H}" viewBox="0 0 {W} {H}" style="background:#1a1a2e">\n'
svg += '<style>text{font-family:monospace;font-size:10px;fill:#ddd;text-anchor:middle}.biome-label{font-size:14px;font-weight:bold}.node{cursor:pointer}.node:hover circle{stroke:#fff;stroke-width:3}</style>\n'

for b in biome_order:
    bx, by = biome_centers[b]
    color = biome_colors.get(b, '#888')
    svg += f'<circle cx="{bx:.0f}" cy="{by:.0f}" r="100" fill="{color}" fill-opacity="0.08" stroke="{color}" stroke-width="2" stroke-dasharray="5,5"/>\n'
    svg += f'<text x="{bx:.0f}" y="{by-115:.0f}" class="biome-label" fill="{color}">{b}</text>\n'

drawn = set()
for c, v in eco.items():
    if c not in node_pos:
        continue
    x1, y1 = node_pos[c]
    for prey in v.get('prey', []):
        if prey in node_pos:
            x2, y2 = node_pos[prey]
            key = tuple(sorted([c, prey]))
            if key not in drawn:
                drawn.add(key)
                svg += f'<line x1="{x1:.0f}" y1="{y1:.0f}" x2="{x2:.0f}" y2="{y2:.0f}" stroke="#ff4444" stroke-width="1.5" opacity="0.6"/>\n'
    for ally in v.get('allies', []):
        if ally in node_pos:
            x2, y2 = node_pos[ally]
            key = tuple(sorted([c, ally]))
            if key not in drawn:
                drawn.add(key)
                svg += f'<line x1="{x1:.0f}" y1="{y1:.0f}" x2="{x2:.0f}" y2="{y2:.0f}" stroke="#44ff44" stroke-width="1.5" opacity="0.5"/>\n'
    for rival in v.get('rivals', []):
        if rival in node_pos:
            x2, y2 = node_pos[rival]
            key = tuple(sorted([c, rival]))
            if key not in drawn:
                drawn.add(key)
                svg += f'<line x1="{x1:.0f}" y1="{y1:.0f}" x2="{x2:.0f}" y2="{y2:.0f}" stroke="#ffaa00" stroke-width="1.5" stroke-dasharray="3,3" opacity="0.5"/>\n'
    for cb in v.get('cross_biome', []):
        if cb in node_pos:
            x2, y2 = node_pos[cb]
            key = tuple(sorted([c, cb]))
            if key not in drawn:
                drawn.add(key)
                svg += f'<line x1="{x1:.0f}" y1="{y1:.0f}" x2="{x2:.0f}" y2="{y2:.0f}" stroke="#4488ff" stroke-width="1" stroke-dasharray="8,4" opacity="0.5"/>\n'

for c, v in eco.items():
    if c not in node_pos:
        continue
    x, y = node_pos[c]
    color = biome_colors.get(v['biome'], '#888')
    svg += f'<g class="node" onclick="window.location.href=\'animals/pages/{c}.html\'">\n'
    svg += f'<circle cx="{x:.0f}" cy="{y:.0f}" r="14" fill="{color}" fill-opacity="0.7" stroke="{color}" stroke-width="2"/>\n'
    label = v['name'][:8]
    svg += f'<text x="{x:.0f}" y="{y+4:.0f}">{label}</text>\n'
    svg += '</g>\n'

svg += '<rect x="10" y="950" width="1180" height="40" fill="#16213e" rx="5"/>\n'
svg += '<line x1="20" y1="970" x2="50" y2="970" stroke="#ff4444" stroke-width="2"/><text x="75" y="974" style="text-anchor:start">Hunts</text>\n'
svg += '<line x1="140" y1="970" x2="170" y2="970" stroke="#44ff44" stroke-width="2"/><text x="195" y="974" style="text-anchor:start">Allies</text>\n'
svg += '<line x1="260" y1="970" x2="290" y2="970" stroke="#ffaa00" stroke-width="2" stroke-dasharray="3,3"/><text x="315" y="974" style="text-anchor:start">Rivals</text>\n'
svg += '<line x1="380" y1="970" x2="410" y2="970" stroke="#4488ff" stroke-width="2" stroke-dasharray="8,4"/><text x="435" y="974" style="text-anchor:start">Cross-Biome</text>\n'
svg += f'<text x="600" y="974" style="text-anchor:start">Total: {len(eco)} creatures across {len(biome_order)} biomes</text>\n'
svg += '</svg>\n'

with open('/tmp/Oma_folio/zoo_ecosystem_map.html', 'w') as f:
    f.write('<!DOCTYPE html><html><head><title>Oma Zoo Ecosystem Map</title><style>body{margin:0;background:#1a1a2e}svg{display:block;margin:auto}</style></head><body>\n')
    f.write(svg)
    f.write('</body></html>\n')

print(f'OK: ecosystem map with {len(eco)} creatures in {len(biome_order)} biomes')