import json, random, math

# Load founder genomes
with open('/tmp/Oma_folio/abstract_genomes.json') as f:
    founders = json.load(f)

# Enhanced genome: add fitness-related traits
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

# Environments with trait preferences
environments = {
    'volcanic': {
        'name': 'Volcanic',
        'color': '#ff4422',
        'bg': '#1a0a05',
        'prefs': {'recursion': [4,8], 'symmetry': [2,5], 'hues': [[0,60]], 'topology': ['fractal','spiral','attractor']}
    },
    'aquatic': {
        'name': 'Aquatic',
        'color': '#22aaff',
        'bg': '#050a1a',
        'prefs': {'recursion': [3,7], 'symmetry': [4,8], 'hues': [[180,260]], 'topology': ['wave','spiral','voronoi']}
    },
    'crystal': {
        'name': 'Crystal',
        'color': '#aa44ff',
        'bg': '#0a0515',
        'prefs': {'recursion': [2,6], 'symmetry': [5,9], 'hues': [[240,320]], 'topology': ['tessellation','tiling','packing']}
    },
    'void': {
        'name': 'Void',
        'color': '#888888',
        'bg': '#050505',
        'prefs': {'recursion': [5,9], 'symmetry': [1,3], 'hues': [[0,30],[330,360]], 'topology': ['nonorientable','twist','escape']}
    }
}

env_json = json.dumps(environments)
founders_json = json.dumps(founders)

html = '''<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Morphospace v2 — Generative Evolution Lab</title>
<style>
*{margin:0;padding:0;box-sizing:border-box}
body{background:#0a0a14;color:#e0e0f0;font-family:'Georgia',serif;min-height:100vh;transition:background 0.5s}
header{padding:20px;text-align:center;border-bottom:1px solid #1a1a2e}
header h1{font-size:2.2em;background:linear-gradient(90deg,#7c83fd,#ca3fea,#f59e42);-webkit-background-clip:text;-webkit-text-fill-color:transparent;letter-spacing:2px}
header p{color:#6a6a8a;margin-top:6px;font-size:0.95em}
#envBar{display:flex;justify-content:center;gap:12px;padding:15px;border-bottom:1px solid #1a1a2e;flex-wrap:wrap}
.envBtn{padding:8px 20px;border:2px solid #333;border-radius:20px;background:none;color:#888;cursor:pointer;font-size:0.85em;transition:all 0.3s}
.envBtn:hover{border-color:#555;color:#aaa}
.envBtn.active{border-color:var(--ec);color:var(--ec);box-shadow:0 0 12px var(--ec)44}
#stats{display:flex;justify-content:center;gap:30px;padding:12px;border-bottom:1px solid #1a1a2e}
.stat{text-align:center}
.stat .num{font-size:1.8em;color:#ca3fea;display:block}
.stat{font-size:0.8em;color:#6a6a8a}
.main{display:grid;grid-template-columns:1fr 90px 1fr;gap:15px;padding:20px;max-width:1300px;margin:0 auto}
.panel{background:#12121e;border:1px solid #2a2a4e;border-radius:10px;padding:15px}
.panel h2{color:#7c83fd;margin-bottom:10px;font-size:1.1em;text-align:center}
.grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(95px,1fr));gap:8px;max-height:450px;overflow-y:auto}
.fcard{background:#1a1a2e;border:2px solid transparent;border-radius:8px;padding:6px;cursor:pointer;text-align:center;transition:border 0.2s;position:relative}
.fcard:hover{border-color:#7c83fd}
.fcard.sel{border-color:#ca3fea;box-shadow:0 0 12px rgba(202,63,234,0.4)}
.fcard .name{font-size:0.7em;color:#9a9ab0;margin-top:4px}
.fcard .fit{position:absolute;top:2px;right:4px;font-size:0.6em;color:#f59e42}
.fcard .gen{font-size:0.55em;color:#4a4a6a}
#breedZone{display:flex;flex-direction:column;align-items:center;justify-content:center;gap:10px}
#breedBtn{background:linear-gradient(135deg,#7c83fd,#ca3fea);border:none;color:#fff;padding:14px 28px;border-radius:25px;font-size:1.1em;cursor:pointer;transition:transform 0.2s,box-shadow 0.2s}
#breedBtn:hover:not(:disabled){transform:scale(1.08);box-shadow:0 0 20px rgba(124,131,253,0.5)}
#breedBtn:disabled{opacity:0.4;cursor:default}
#autoBtn{background:none;border:1px solid #444;color:#888;padding:8px 16px;border-radius:15px;font-size:0.8em;cursor:pointer;margin-top:8px}
#autoBtn:hover{border-color:#666;color:#aaa}
#autoBtn.active{border-color:#f59e42;color:#f59e42}
.info{background:#12121e;border:1px solid #2a2a4e;border-radius:8px;padding:10px;font-size:0.8em;margin-top:10px;min-height:60px}
.info b{font-size:1.1em}
.gbar{display:flex;gap:1px;height:8px;border-radius:3px;overflow:hidden;margin-top:4px}
.gs{height:100%}
#offspring{max-width:1300px;margin:20px auto;padding:0 20px}
#offspring h2{color:#f59e42;margin-bottom:12px;font-size:1.2em}
.off-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(140px,1fr));gap:12px}
.pcard{background:#12121e;border:1px solid #2a2a4e;border-radius:10px;padding:10px;text-align:center;position:relative}
.pcard .name{font-size:0.85em;color:#ca3fea;margin-top:6px}
.pcard .gen{font-size:0.7em;color:#6a6a8a;margin-top:2px}
.pcard .fit{position:absolute;top:4px;right:6px;font-size:0.65em}
.mut{color:#f59e42;font-size:0.7em;margin-top:3px}
#lineageSec{max-width:1300px;margin:20px auto;padding:20px}
#lineageSec h2{color:#7c83fd;margin-bottom:12px}
#lineageTree{background:#12121e;border:1px solid #2a2a4e;border-radius:10px;padding:15px;overflow-x:auto}
#exportBar{display:flex;justify-content:center;gap:15px;padding:15px}
.exportBtn{background:none;border:1px solid #444;color:#888;padding:8px 20px;border-radius:15px;cursor:pointer;font-size:0.85em}
.exportBtn:hover{border-color:#7c83fd;color:#7c83fd}
footer{padding:20px;text-align:center;color:#4a4a6a;font-size:0.8em;border-top:1px solid #1a1a2e;margin-top:20px}
.fit-bar{width:100%;height:6px;background:#1a1a2e;border-radius:3px;margin-top:4px;overflow:hidden}
.fit-fill{height:100%;border-radius:3px;transition:width 0.3s}
</style>
</head>
<body>
<header>
<h1>📐 Morphospace v2</h1>
<p>Generative forms breed, mutate, and evolve under environmental selection pressure</p>
</header>
<div id="envBar"></div>
<div id="stats"></div>
<div class="main">
<div class="panel">
<h2>Parent A</h2>
<div id="gridA" class="grid"></div>
<div id="infoA" class="info">Select a form…</div>
</div>
<div id="breedZone">
<button id="breedBtn" disabled>🧬 Breed</button>
<button id="autoBtn">🔄 Auto-Evolve</button>
</div>
<div class="panel">
<h2>Parent B</h2>
<div id="gridB" class="grid"></div>
<div id="infoB" class="info">Select a form…</div>
</div>
</div>
<div id="offspring">
<h2>Offspring — Emergent Forms</h2>
<div class="off-grid" id="offGrid"></div>
</div>
<div id="lineageSec">
<h2>🌳 Lineage Tree</h2>
<div id="lineageTree"><span style="color:#444">Breed forms to see lineage…</span></div>
</div>
<div id="exportBar">
<button class="exportBtn" onclick="exportGenomes()">⬇ Export Gene Pool (JSON)</button>
<button class="exportBtn" onclick="exportLineage()">⬇ Export Lineage (JSON)</button>
</div>
<footer>Morphospace v2 by Oma — forms exist in math, evolve under pressure, not in cages</footer>
<script>
const founders = ''' + founders_json + ''';
const environments = ''' + env_json + ''';

let genePool = founders.map((g) => ({...g}));
let parentA = null, parentB = null;
let generation = 0, totalOffspring = 0, nextId = founders.length;
let currentEnv = null;
let autoEvolving = false;
let autoTimer = null;

function renderForm(g, size) {
  const cx = size/2, cy = size/2;
  let svg = `<svg viewBox="0 0 ${size} ${size}" xmlns="http://www.w3.org/2000/svg" style="max-width:${size}px">`;
  const hue = (i) => g.hues ? g.hues[i % g.hues.length] : 200;
  const col = (i, a) => `hsla(${hue(i)},${60+a*20}%,${50+a*10}%,${(g.opacity||0.85)*(0.4+0.6*(1-a))})`;
  const segs = g.segmentation || g.recursion || 3;
  const apps = g.appendages || g.symmetry || 3;
  const sc = g.scale || 1.0;

  if (g.topology === 'spiral') {
    const phi = 1.61803;
    for (let i = 0; i < segs * 8; i++) {
      const r = i * 2 * phi * sc;
      const a = i * (apps === 3 ? 137.5 : 360/apps) * Math.PI/180;
      const x = cx + r * Math.cos(a), y = cy + r * Math.sin(a);
      const sz = (3 + (1 - i/(segs*8)) * 8) * sc;
      svg += `<circle cx="${x.toFixed(1)}" cy="${y.toFixed(1)}" r="${Math.max(0.5,sz).toFixed(1)}" fill="${col(i, i/(segs*8))}" />`;
    }
  } else if (g.topology === 'tessellation' || g.topology === 'tiling') {
    const n = apps || 6;
    const r = size * 0.35 * sc;
    for (let layer = 0; layer < segs; layer++) {
      for (let i = 0; i < n; i++) {
        const a = (i / n) * Math.PI * 2 + layer * 0.3;
        const rr = r * (1 - layer * 0.18);
        const x = cx + rr * Math.cos(a), y = cy + rr * Math.sin(a);
        const pts = [];
        for (let j = 0; j < n; j++) {
          const aa = (j / n) * Math.PI * 2;
          pts.push((x + 8*sc*Math.cos(aa)).toFixed(1)+','+(y + 8*sc*Math.sin(aa)).toFixed(1));
        }
        svg += `<polygon points="${pts.join(' ')}" fill="${col(layer*n+i, layer/segs)}" opacity="0.7" />`;
      }
    }
  } else if (g.topology === 'fractal') {
    function branch(x, y, angle, len, depth) {
      if (depth <= 0 || len < 1) return;
      const x2 = x + len * Math.cos(angle), y2 = y + len * Math.sin(angle);
      svg += `<line x1="${x.toFixed(1)}" y1="${y.toFixed(1)}" x2="${x2.toFixed(1)}" y2="${y2.toFixed(1)}" stroke="${col(segs-depth, depth/segs)}" stroke-width="${(depth*0.8*sc).toFixed(1)}" opacity="0.8" />`;
      branch(x2, y2, angle - Math.PI/apps, len*0.7, depth-1);
      branch(x2, y2, angle + Math.PI/apps, len*0.7, depth-1);
    }
    branch(cx, size, -Math.PI/2, size*0.3*sc, segs);
  } else if (g.topology === 'twist' || g.topology === 'nonorientable') {
    for (let i = 0; i < segs * 6; i++) {
      const t = i / (segs * 6);
      const a = t * Math.PI * apps * 2;
      const r = (size*0.35 + 10*Math.sin(t*Math.PI*4)) * sc;
      const x = cx + r * Math.cos(a), y = cy + r * Math.sin(a);
      const x2 = cx + (r+6*sc) * Math.cos(a+0.5), y2 = cy + (r+6*sc) * Math.sin(a+0.5);
      svg += `<line x1="${x.toFixed(1)}" y1="${y.toFixed(1)}" x2="${x2.toFixed(1)}" y2="${y2.toFixed(1)}" stroke="${col(i, t)}" stroke-width="${(3*sc).toFixed(1)}" opacity="0.7" />`;
    }
  } else if (g.topology === 'voronoi') {
    const n = apps || 8;
    const seeds = [];
    for (let i = 0; i < n; i++) {
      const a = (i/n)*Math.PI*2;
      const r = size*0.3*sc*(0.5+Math.random()*0.5);
      seeds.push([cx+r*Math.cos(a), cy+r*Math.sin(a)]);
    }
    seeds.forEach((s,si) => {
      const cell = [];
      const angles = [];
      seeds.forEach((s2,si2) => { if(si!==si2) { angles.push(Math.atan2(s2[1]-s[1], s2[0]-s[0]) + Math.PI); } });
      angles.sort((a,b)=>a-b);
      angles.forEach(ang => {
        const d = size*0.25;
        cell.push((s[0]+d*Math.cos(ang)).toFixed(1)+','+(s[1]+d*Math.sin(ang)).toFixed(1));
      });
      svg += `<polygon points="${cell.join(' ')}" fill="${col(si, si/seeds.length)}" opacity="0.5" stroke="${col(si,0.3)}" stroke-width="0.5" />`;
    });
  } else if (g.topology === 'wave') {
    for (let layer = 0; layer < segs; layer++) {
      let d = `M 0 ${cy}`;
      for (let x = 0; x <= size; x += 4) {
        const y = cy + Math.sin(x*0.05 + layer*0.8) * (15+layer*5) * sc * Math.exp(-layer*0.15);
        d += ` L ${x} ${y.toFixed(1)}`;
      }
      svg += `<path d="${d}" fill="none" stroke="${col(layer, layer/segs)}" stroke-width="${(2+layer*0.5).toFixed(1)}" opacity="0.6" />`;
    }
  } else if (g.topology === 'escape') {
    const maxIter = segs * 10;
    for (let py = 0; py < size; py += 2) {
      for (let px = 0; px < size; px += 2) {
        const x0 = (px - size*0.6) / (size*0.3) * sc;
        const y0 = (py - size/2) / (size*0.3);
        let x = 0, y = 0, iter = 0;
        while (x*x + y*y < 4 && iter < maxIter) {
          const xn = x*x - y*y + x0;
          y = 2*x*y + y0; x = xn; iter++;
        }
        if (iter < maxIter) {
          const idx = iter % (g.hues ? g.hues.length : 3);
          svg += `<rect x="${px}" y="${py}" width="2" height="2" fill="${col(iter, iter/maxIter)}" />`;
        }
      }
    }
  } else if (g.topology === 'packing') {
    function pack(x, y, r, depth) {
      if (depth <= 0 || r < 1) return;
      svg += `<circle cx="${x.toFixed(1)}" cy="${y.toFixed(1)}" r="${r.toFixed(1)}" fill="none" stroke="${col(depth, depth/segs)}" stroke-width="0.8" opacity="0.7" />`;
      const n = apps || 3;
      for (let i = 0; i < n; i++) {
        const a = (i/n)*Math.PI*2 + depth*0.5;
        const nr = r * 0.5;
        const nx = x + (r-nr) * Math.cos(a), ny = y + (r-nr) * Math.sin(a);
        pack(nx, ny, nr, depth-1);
      }
    }
    pack(cx, cy, size*0.4*sc, segs);
  } else if (g.topology === 'l-system') {
    let state = 'F';
    const rules = {'F': 'F[+F]F[-F]F'};
    for (let i = 0; i < Math.min(segs, 4); i++) {
      let ns = '';
      for (const c of state) ns += rules[c] || c;
      state = ns.slice(0, 200);
    }
    let x = cx, y = size*0.9, angle = -Math.PI/2;
    const stack = [];
    const len = size*0.08*sc;
    for (const c of state) {
      if (c === 'F') {
        const nx = x + len*Math.cos(angle), ny = y + len*Math.sin(angle);
        svg += `<line x1="${x.toFixed(1)}" y1="${y.toFixed(1)}" x2="${nx.toFixed(1)}" y2="${ny.toFixed(1)}" stroke="${col(state.indexOf(c)%10, 0.5)}" stroke-width="1" opacity="0.7" />`;
        x = nx; y = ny;
      } else if (c === '+') angle += Math.PI/apps;
      else if (c === '-') angle -= Math.PI/apps;
      else if (c === '[') stack.push([x,y,angle]);
      else if (c === ']') { const s = stack.pop(); if(s){x=s[0];y=s[1];angle=s[2];} }
    }
  } else if (g.topology === 'attractor') {
    let x = 0.1, y = 0, z = 0;
    const dt = 0.005;
    const pts = [];
    for (let i = 0; i < segs * 100; i++) {
      const dx = 10*(y-x), dy = x*(28-z)-y, dz = x*y - 2.667*z;
      x += dx*dt; y += dy*dt; z += dz*dt;
      pts.push([cx + x*4*sc, cy + z*4*sc - size*0.2]);
    }
    pts.forEach((p, i) => {
      if (i > 0) svg += `<line x1="${pts[i-1][0].toFixed(1)}" y1="${pts[i-1][1].toFixed(1)}" x2="${p[0].toFixed(1)}" y2="${p[1].toFixed(1)}" stroke="${col(i, i/pts.length)}" stroke-width="0.6" opacity="0.5" />`;
    });
  } else {
    // Default: radial burst
    for (let i = 0; i < apps * segs; i++) {
      const a = (i / (apps*segs)) * Math.PI * 2;
      const r = (size*0.3 + Math.sin(i*0.5)*10) * sc;
      const x = cx + r * Math.cos(a), y = cy + r * Math.sin(a);
      svg += `<circle cx="${x.toFixed(1)}" cy="${y.toFixed(1)}" r="${(2+Math.random()*4).toFixed(1)}" fill="${col(i, i/(apps*segs))}" opacity="0.7" />`;
    }
  }
  svg += '</svg>';
  return svg;
}

function computeFitness(g, env) {
  if (!env) return g.fitness || 50;
  const prefs = env.prefs;
  let score = 50;
  // Recursion match
  if (g.recursion >= prefs.recursion[0] && g.recursion <= prefs.recursion[1]) score += 15;
  else score -= 10;
  // Symmetry match
  if (g.symmetry >= prefs.symmetry[0] && g.symmetry <= prefs.symmetry[1]) score += 15;
  else score -= 10;
  // Hue match
  const hueMatch = g.hues.some(h => prefs.hues.some(r => h >= r[0] && h <= r[1]));
  if (hueMatch) score += 10;
  else score -= 5;
  // Topology match
  if (prefs.topology.includes(g.topology)) score += 10;
  else score -= 5;
  return Math.max(0, Math.min(100, score));
}

function updateFitnessAll() {
  const env = currentEnv ? environments[currentEnv] : null;
  genePool.forEach(g => { g.fitness = computeFitness(g, env); });
}

function genomeBar(g, w) {
  return '<div class="gbar" style="width:'+(w||100)+'px">' + g.hues.map(function(h,i){return '<div class="gs" style="background:hsl('+h+',60%,50%);flex:1"></div>';}).join('') + '</div>';
}

function fitColor(f) {
  if (f >= 75) return '#4caf50';
  if (f >= 50) return '#ffc107';
  if (f >= 25) return '#ff9800';
  return '#f44336';
}

function renderGrid(side) {
  const el = document.getElementById(side === 'A' ? 'gridA' : 'gridB');
  var display = genePool.slice(0, founders.length + 12);
  el.innerHTML = display.map(function(g, i) {
    var sel = (side === 'A' && parentA === i) || (side === 'B' && parentB === i);
    return '<div class="fcard'+(sel?' sel':'')+'" onclick="selectForm('+i+",'"+side+"'"+')">'+
      renderForm(g, 80) +