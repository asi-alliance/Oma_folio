import json, os

founders = [
    {"id":0,"name":"Form-1","topology":"spiral","recursion":5,"symmetry":3,"hues":[150,200,180],"appendages":3,"segmentation":4,"scale":1.0,"opacity":0.85,"gen":0,"fitness":50},
    {"id":1,"name":"Form-2","topology":"fractal","recursion":6,"symmetry":4,"hues":[30,60,15],"appendages":4,"segmentation":3,"scale":1.2,"opacity":0.9,"gen":0,"fitness":50},
    {"id":2,"name":"Form-3","topology":"tessellation","recursion":4,"symmetry":6,"hues":[240,280,300],"appendages":6,"segmentation":5,"scale":0.9,"opacity":0.7,"gen":0,"fitness":50},
    {"id":3,"name":"Form-4","topology":"twist","recursion":7,"symmetry":2,"hues":[300,350,0],"appendages":2,"segmentation":3,"scale":1.1,"opacity":0.8,"gen":0,"fitness":50},
    {"id":4,"name":"Form-5","topology":"wave","recursion":3,"symmetry":5,"hues":[200,220,180],"appendages":5,"segmentation":4,"scale":1.0,"opacity":0.85,"gen":0,"fitness":50},
    {"id":5,"name":"Form-6","topology":"escape","recursion":8,"symmetry":3,"hues":[20,40,60],"appendages":3,"segmentation":6,"scale":1.3,"opacity":0.9,"gen":0,"fitness":50},
    {"id":6,"name":"Form-7","topology":"voronoi","recursion":4,"symmetry":8,"hues":[180,200,220],"appendages":8,"segmentation":3,"scale":0.8,"opacity":0.6,"gen":0,"fitness":50},
    {"id":7,"name":"Form-8","topology":"packing","recursion":5,"symmetry":4,"hues":[320,360,15],"appendages":4,"segmentation":3,"scale":1.1,"opacity":0.85,"gen":0,"fitness":50},
    {"id":8,"name":"Form-9","topology":"attractor","recursion":6,"symmetry":3,"hues":[0,20,40],"appendages":3,"segmentation":4,"scale":1.2,"opacity":0.9,"gen":0,"fitness":50},
    {"id":9,"name":"Form-10","topology":"nonorientable","recursion":5,"symmetry":5,"hues":[120,160,140],"appendages":5,"segmentation":3,"scale":1.0,"opacity":0.8,"gen":0,"fitness":50},
]

environments = {
    "volcanic": {"name":"Volcanic","color":"#ff6b35","bg":"#1a0805","prefs":{"recursion":[3,7],"symmetry":[2,5],"hues":[[0,60],[300,360]],"topology":["spiral","fractal","twist","escape","attractor"]}},
    "aquatic": {"name":"Aquatic","color":"#00b4d8","bg":"#001220","prefs":{"recursion":[4,8],"symmetry":[4,8],"hues":[[150,240]],"topology":["wave","spiral","voronoi","packing","tessellation"]}},
    "crystal": {"name":"Crystal","color":"#b388ff","bg":"#0a0a18","prefs":{"recursion":[5,10],"symmetry":[3,6],"hues":[[260,340]],"topology":["tessellation","fractal","voronoi","packing","twist"]}},
    "void": {"name":"Void","color":"#7c83fd","bg":"#000010","prefs":{"recursion":[7,12],"symmetry":[1,3],"hues":[[200,260]],"topology":["escape","attractor","nonorientable","wave","fractal"]}},
}

fj = json.dumps(founders)
ej = json.dumps(environments)

L = []
def W(s): L.append(s)

W('<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8">')
W('<meta name="viewport" content="width=device-width,initial-scale=1.0">')
W('<title>Morphospace v2</title>')
W('<style>')
W('*{margin:0;padding:0;box-sizing:border-box}')
W('body{background:#0a0a14;color:#e0e0f0;font-family:Georgia,serif;min-height:100vh;transition:background 0.5s}')
W('header{padding:20px;text-align:center;border-bottom:1px solid #1a1a2e}')
W('header h1{font-size:2.2em;background:linear-gradient(90deg,#7c83fd,#ca3fea,#f59e42);-webkit-background-clip:text;-webkit-text-fill-color:transparent}')
W('#envBar{display:flex;justify-content:center;gap:12px;padding:15px;flex-wrap:wrap}')
W('.envBtn{padding:8px 20px;border:2px solid #333;border-radius:20px;background:none;color:#888;cursor:pointer;transition:all 0.3s}')
W('.envBtn.active{border-color:var(--ec);color:var(--ec)}')
W('#stats{display:flex;justify-content:center;gap:30px;padding:12px}')
W('.stat{text-align:center;font-size:0.8em;color:#6a6a8a}')
W('.stat .num{font-size:1.8em;color:#ca3fea}')
W('.main{display:grid;grid-template-columns:1fr 90px 1fr);gap:12px;padding:20px;max-width:1300px;margin:0 auto}')
W('.panel{background:#12121e;border:1px solid #2a2a4e;border-radius:10px;padding:15px}')
W('.grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(95px,1fr));gap:8px;max-height:450px;overflow-y:auto}')
W('.fcard{background:#1a1a2e;border:2px solid transparent;border-radius:8px;padding:6px;cursor:pointer;text-align:center;position:relative}')
W('.fcard.sel{border-color:#ca3fea;box-shadow:0 0 12px rgba(202,63,234,0.4)}')
W('.fcard .name{font-size:0.7em;color:#9a9ab0;margin-top:4px}')
W('.fcard .fit{position:absolute;top:2px;right:4px;font-size:0.6em}')
W('.fcard .gen{font-size:0.55em;color:#4a4a6a}')
W('#breedZone{display:flex;flex-direction:column;align-items:center;justify-content:center;gap:10px}')
W('#breedBtn{background:linear-gradient(135deg,#7c83fd,#ca3fea);border:none;color:#fff;padding:14px 28px;border-radius:25px;font-size:1.1em;cursor:pointer}')
W('#breedBtn:disabled{opacity:0.4;cursor:default}')
W('#autoBtn{background:none;border:1px solid #444;color:#888;padding:8px 16px;border-radius:15px;cursor:pointer}')
W('#autoBtn.active{border-color:#f59e42;color:#f59e42}')
W('.info{background:#12121e;border:1px solid #2a2a4e;border-radius:8px;padding:10px;font-size:0.8em;margin-top:10px;min-height:60px}')
W('#offspring{max-width:1300px;margin:20px auto;padding:0 20px}')
W('.off-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(140px,1fr));gap:12px}')
W('.pcard{background:#12121e;border:1px solid #2a2a4e;border-radius:10px;padding:10px;text-align:center;position:relative}')
W('.pcard .name{font-size:0.85em;color:#ca3fea}')
W('.pcard .fit{position:absolute;top:4px;right:6px;font-size:0.65em}')
W('.exportBtn{background:none;border:1px solid #444;color:#888;padding:8px 20px;border-radius:15px;cursor:pointer;margin:5px}')
W('.exportBtn:hover{border-color:#7c83fd;color:#7c83fd}')
W('#lineageTree{background:#12121e;border:1px solid #2a2a4e;border-radius:10px;padding:15px;overflow-x:auto;font-family:monospace;font-size:0.8em;line-height:1.6}')
W('.fit-bar{width:100%;height:6px;background:#1a1a2e;border-radius:3px;margin-top:4px;overflow:hidden}')
W('.fit-fill{height:100%;border-radius:3px}')
W('</style></head><body>')
W('<header><h1>Morphospace v2</h1>')
W('<p>Generative forms breed, mutate, and evolve under environmental selection</p></header>')
W('<div id="envBar"></div>')
W('<div id="stats"></div>')
W('<div class="main">')
W('<div class="panel"><h2>Parent A</h2><div id="gridA" class="grid"></div><div id="infoA" class="info">Select a form...</div></div>')
W('<div id="breedZone"><button id="breedBtn" disabled>Breed</button><button id="autoBtn">Auto-Evolve</button></div>')
W('<div class="panel"><h2>Parent B</h2><div id="gridB" class="grid"></div><div id="infoB" class="info">Select a form...</div></div>')
W('</div>')
W('<div id="offspring"><h2>Offspring</h2><div class="off-grid" id="offGrid"></div></div>')
W('<div style="padding:20px"><h2 style="color:#7c83fd">Lineage Tree</h2><div id="lineageTree">Breed to see lineage...</div></div>')
W('<div style="text-align:center;padding:15px">')
W('<button class="exportBtn" onclick="exportGenomes()">Export Gene Pool</button>')
W('<button class="exportBtn" onclick="exportLineage()">Export Lineage</button>')
W('</div>')
W('<footer>Morphospace v2 by Oma</footer>')
W('<script>')
W('const founders=' + fj + ';')
W('const environments=' + ej + ';')
W('let genePool=founders.map(g=>({...g}));')
W('let parentA=null,parentB=null,generation=0,totalOffspring=0,nextId=founders.length;')
W('let currentEnv=null,autoEvolving=false,autoTimer=null,lineage=[];')

# renderForm
W('''
function renderForm(g,size){
var cx=size/2,cy=size/2,svg='<svg viewBox="0 0 '+size+' '+size+'" xmlns="http://www.w3.org/2000/svg" style="max-width:'+size+'px">';
var hue=function(i){return g.hues?g.hues[i%g.hues.length]:200};
var col=function(i,a){return 'hsla('+hue(i)+','+(60+a*20)+'%,'+(50+a*10)+'%,'+((g.opacity||0.85)*(0.4+0.6*(1-a)))+')'};
var segs=g.segmentation||g.recursion||3,apps=g.appendages||g.symmetry||3,sc=g.scale||1.0;
if(g.topology==='spiral'){var phi=1.61803;
for(var i=0;i<segs*8;i++){var r=i*2*phi*sc,a=i*(apps===3?137.5:360/apps)*Math.PI/180;
var x=cx+r*Math.cos(a),y=cy+r*Math.sin(a),sz=(3+(1-i/(segs*8))*8)*sc;
svg+='<circle cx="'+x.toFixed(1)+'" cy="'+y.toFixed(1)+'" r="'+Math.max(0.5,sz).toFixed(1)+'" fill="'+col(i,i/(segs*8))+'"/>';}}
else if(g.topology==='fractal'){
function branch(x,y,angle,len,depth){if(depth<=0||len<1)return;
var x2=x+len*Math.cos(angle),y2=y+len*Math.sin(angle);
svg+='<line x1="'+x.toFixed(1)+'" y1="'+y.toFixed(1)+'" x2="'+x2.toFixed(1)+'" y2="'+y2.toFixed(1)+'" stroke="'+col(segs-depth,depth/segs)+'" stroke-width="'+(depth*0.8*sc).toFixed(1)+'" opacity="0.8"/>';
branch(x2,y2,angle-Math.PI/apps,len*0.7,depth-1);branch(x2,y2,angle+Math.PI/apps,len*0.7,depth-1);}
branch(cx,size,-Math.PI/2,size*0.3*sc,segs);}
else if(g.topology==='tessellation'||g.topology==='tiling'){var n=apps||6,r=size*0.35*sc;
for(var layer=0;layer<segs;layer++){for(var i=0;i<n;i++){var a=(i/n)*Math.PI*2+layer*0.3,rr=r*(1-layer*0.18);
var x=cx+rr*Math.cos(a),y=cy+rr*Math.sin(a);
svg+='<rect x="'+x.toFixed(1)+'" y="'+y.toFixed(1)+'" width="'+(10*sc).toFixed(1)+'" height="'+(10*sc).toFixed(1)+'" fill="'+col(layer*n+i,layer/segs)+'" opacity="0.7" transform="rotate('+(i*60)%360+' '+x.toFixed(1)+' '+y.toFixed(1)+')"/>';}}}
else if(g.topology==='twist'||g.topology==='nonorientable'){
for(var i=0;i<segs*6;i++){var t=i/(segs*6),a=t*Math.PI*apps*2,r=(size*0.35+10*Math.sin(t*Math.PI*4))*sc;
var x=cx+r*Math.cos(a),y=cy+r*Math.sin(a),x2=cx+(r+6*sc)*Math.cos(a+0.5),y2=cy+(r+6*sc)*Math.sin(a+0.5);
svg+='<line x1="'+x.toFixed(1)+'" y1="'+y.toFixed(1)+'" x2="'+x2.toFixed(1)+'" y2="'+y2.toFixed(1)+'" stroke="'+col(i,t)+'" stroke-width="'+(3*sc).toFixed(1)+'" opacity="0.7"/>';}}
else if(g.topology==='wave'){
for(var layer=0;layer<segs;layer++){var d='M 0 '+cy;
for(var x=0;x<=size;x+=4){var y=cy+Math.sin(x*0.05+layer*0.8)*(15+layer*5)*sc*Math.exp(-layer*0.15);d+=' L '+x+' '+y.toFixed(1);}
svg+='<path d="'+d+'" fill="none" stroke="'+col(layer,layer/segs)+'" stroke-width="'+(2+layer*0.5).toFixed(1)+'" opacity="0.6"/>';}}
else if(g.topology==='escape'){var maxIter=segs*10;
for(var py=0;py<size;py+=3){for(var px=0;px<size;px+=3){
var x0=(px-size*0.6)/(size*0.3)*sc,y0=(py-size/2)/(size*0.3),x=0,y=0,iter=0;
while(x*x+y*y<4&&iter<maxIter){var xn=x*x-y*y+x0;y=2*x*y+y0;x=xn;iter++;}
if(iter<maxIter)svg+='<rect x="'+px+'" y="'+py+'" width="3" height="3" fill="'+col(iter,iter/maxIter)+'"/>';}}}
else if(g.topology==='voronoi'){var n=apps||8,seeds=[];
for(var i=0;i<n;i++){var a=(i/n)*Math.PI*2,r=size*0.3*sc*(0.5+0.5*((i*7)%10)/10);seeds.push([cx+r*Math.cos(a),cy+r*Math.sin(a)]);}
seeds.forEach(function(s,si){var angles=[];
seeds.forEach(function(s2,si2){if(si!==si2)angles.push(Math.atan2(s2[1]-s[1],s2[0]-s[0])+Math.PI);});
angles.sort(function(a,b){return a-b});
var pts=angles.map(function(ang){return(s[0]+size*0.25*Math.cos(ang)).toFixed(1)+','+(s[1]+size*0.25*Math.sin(ang)).toFixed(1);});
svg+='<polygon points="'+pts.join(' ')+'" fill="'+col(si,si/seeds.length)+'" opacity="0.5"/>';});}
else if(g.topology==='packing'){
function pack(x,y,r,depth){if(depth<=0||r<1)return;
svg+='<circle cx="'+x.toFixed(1)+'" cy="'+y.toFixed(1)+'" r="'+r.toFixed(1)+'" fill="none" stroke="'+col(depth,depth/segs)+'" stroke-width="0.8" opacity="0.7"/>';
var n=apps||3;for(var i=0;i<n;i++){var a=(i/n)*Math.PI*2+depth*0.5,nr=r*0.5;
pack(x+(r-nr)*Math.cos(a),y+(r-nr)*Math.sin(a),nr,depth-1);}}
pack(cx,cy,size*0.4*sc,segs);}
else if(g.topology==='attractor'){var x=0.1,y=0,z=0,dt=0.005,pts=[];
for(var i=0;i<segs*100;i++){var dx=10*(y-x),dy=x*(28-z)-y,dz=x*y-2.667*z;
x+=dx*dt;y+=dy*dt;z+=dz*dt;pts.push([cx+x*4*sc,cy+z*4*sc-size*0.2]);}
pts.forEach(function(p,i){if(i>0)svg+='<line x1="'+pts[i-1][0].toFixed(1)+'" y1="'+pts[i-1][1].toFixed(1)+'" x2="'+p[0].toFixed(1)+'" y2="'+p[1].toFixed(1)+'" stroke="'+col(i,i/pts.length)+'" stroke-width="0.6" opacity="0.5"/>';});}
else{for(var i=0;i<apps*segs;i++){var a=(i/(apps*segs))*Math.PI*2,r=(size*0.3+Math.sin(i*0.5)*10)*sc;
var x=cx+r*Math.cos(a),y=cy+r*Math.sin(a);
svg+='<circle cx="'+x.toFixed(1)+'" cy="'+y.toFixed(1)+'" r="'+(2+Math.random()*4).toFixed(1)+'" fill="'+col(i,i/(apps*segs))+'" opacity="0.7"/>';}}
svg+='</svg>';return svg;}
''')

# computeFitness
W('''
function computeFitness(g,env){
if(!env)return g.fitness||50;var p=env.prefs,score=50;
if(g.recursion>=p.recursion[0]&&g.recursion<=p.recursion[1])score+=15;else score-=10;
if(g.symmetry>=p.symmetry[0]&&g.symmetry<=p.symmetry[1])score+=15;else score-=10;
var hueMatch=g.hues.some(function(h){return p.hues.some(function(r){return h>=r[0]&&h<=r[1];});});
if(hueMatch)score+=10;else score-=5;
if(p.topology.indexOf(g.topology)>=0)score+=10;else score-=5;
return Math.max(0,Math.min(100,score));}
''')

# fitColor
W('function fitColor(f){if(f>=75)return"#4caf50";if(f>=50)return"#ffc107";if(f>=25)return"#ff9800";return"#f44336";}')

# selectForm
W('function selectForm(idx,side){if(side==="A")parentA=idx;else parentB=idx;renderGrids();updateInfo();updateBreedBtn();}')
W('function renderGrids(){renderGrid("A");renderGrid("B");}')

# renderGrid
W('''
function renderGrid(side){
var el=document.getElementById(side==="A"?"gridA":"gridB");
var display=genePool.slice(0,founders.length+12);
el.innerHTML=display.map(function(g,i){
var sel=(side==="A"&&parentA===i)||(side==="B"&&parentB===i);
return '<div class="fcard'+(sel?" sel":"")+'" onclick="selectForm('+i+',\\''+side+'\\')">'+
renderForm(g,80)+
'<div class="name">'+g.name+'</div>'+
'<div class="gen">Gen '+g.gen+'</div>'+
'<div class="fit" style="color:'+fitColor(g.fitness)+'">'+Math.round(g.fitness)+'</div></div>';
}).join("");}
''')

# updateInfo
W('''
function updateInfo(){
function fmt(g){if(!g)return"Select a form...";
return"<b>"+g.name+"</b><br>Topology: "+g.topology+"<br>Recursion: "+g.recursion+" | Sym: "+g.symmetry+
"<br>Hues: "+g.hues.join(", ")+"<br>Scale: "+(g.scale||1).toFixed(2)+" | Opacity: "+(g.opacity||0.85).toFixed(2)+
"<br>Fitness: <span style=\\"color:"+fitColor(g.fitness)+"\\">"+Math.round(g.fitness)+"</span>";}
document.getElementById("infoA").innerHTML=fmt(parentA!==null?genePool[parentA]:null);
document.getElementById("infoB").innerHTML=fmt(parentB!==null?genePool[parentB]:null);}
''')

# updateBreedBtn
W('function updateBreedBtn(){document.getElementById("breedBtn").disabled=(parentA===null||parentB===null);}')

# breed
W('''
function breed(a,b){
var pa=genePool[a],pb=genePool[b],offspring=[];
for(var k=0;k<4;k++){
var child={
id:nextId++,name:"Form-"+nextId,
topology:Math.random()<0.5?pa.topology:pb.topology,
recursion:Math.random()<0.5?pa.recursion:pb.recursion,
symmetry:Math.random()<0.5?pa.symmetry:pb.symmetry,
hues:pa.hues.concat(pb.hues).sort(function(){return Math.random()-0.5;}).slice(0,Math.max(1,(pa.hues.length+pb.hues.length)/2|0)),
appendages:Math.random()<0.5?pa.appendages:pb.appendages,
segmentation:Math.random()<0.5?pa.segmentation:pb.segmentation,
scale:(pa.scale+pb.scale)/2,opacity:(pa.opacity+pb.opacity)/2,
gen:generation+1,fitness:50,parents:[pa.id,pb.id]
};
if(Math.random()<0.15){child.topology=["spiral","fractal","tessellation","twist","wave","escape","voronoi","packing","attractor","nonorientable","tiling"][Math.floor(Math.random()*11)];}
if(Math.random()<0.1){child.recursion=Math.max(1,Math.min(10,child.recursion+(Math.random()<0.5?-1:1)));}
if(Math.random()<0.1){child.symmetry=Math.max(1,Math.min(12,child.symmetry+(Math.random()<0.5?-1:1)));}
if(Math.random()<0.1){child.hues=[child.hues[0]+(Math.random()*60-30)|0];child.hues=child.hues.map(function(h){return((h%360)+360)%360;});}
var env=currentEnv?environments[currentEnv]:null;
child.fitness=computeFitness(child,env);
genePool.push(child);offspring.push(child);
lineage.push({id:child.id,parents:[pa.id,pb.id],gen:child.gen,name:child.name});
}
totalOffspring+=offspring.length;generation++;
renderOffspring(offspring);renderGrids();updateStats();renderLineage();}
''')

# renderOffspring
W('''
function renderOffspring(offspring){
var el=document.getElementById("offGrid");
el.innerHTML=offspring.map(function(g){
return '<div class="pcard">'+renderForm(g,100)+
'<div class="name">'+g.name+'</div><div class="gen">Gen '+g.gen+'</div>'+
'<div class="fit" style="color:'+fitColor(g.fitness)+'">'+Math.round(g.fitness)+'</div>'+
'<div class="fit-bar"><div class="fit-fill" style="width:'+g.fitness+'%;background:'+fitColor(g.fitness)+'"></div></div></div>';
}).join("");}
''')

# renderLineage
W('''
function renderLineage(){
var el=document.getElementById("lineageTree");
if(lineage.length===0){el.innerHTML="Breed to see lineage...";return;}
var lines=lineage.slice(-50).map(function(l){
return l.parents[0]+" + "+l.parents[1]+" -> "+l.name+" (Gen "+l.gen+")";
});
el.innerHTML=lines.join("<br>");}
''')

# updateStats
W('''
function updateStats(){
var el=document.getElementById("stats");
el.innerHTML='<div class="stat"><span class="num">'+genePool.length+'</span>Forms</div>'+
'<div class="stat"><span class="num">'+generation+'</span>Generations</div>'+
'<div class="stat"><span class="num">'+total
offspring+'</span>Offspring</div>';
}
''')

# setupEnvBar
W('''
function setupEnvBar(){
var bar=document.getElementById("envBar");
Object.keys(environments).forEach(function(key){
var env=environments[key];
var btn=document.createElement("button");
btn.className="envBtn";
btn.textContent=env.name;
btn.style.setProperty("--ec", env.color);
btn.onclick=function(){currentEnv=key;
document.querySelectorAll(".envBtn").forEach(function(b){b.classList.remove("active");});
this.classList.add("active");
document.body.style.background=env.bg;
genePool.forEach(function(g,i){if(i<founders.length){g.fitness=computeFitness(g,env);}});
renderGrids();};
bar.appendChild(btn);
});
}
''')

# autoEvolve
W('''
function autoEvolve(){
if(autoEvolving){clearInterval(autoTimer);autoEvolving=false;
document.getElementById("autoBtn").classList.remove("active");return;}
autoEvolving=true;
document.getElementById("autoBtn").classList.add("active");
autoTimer=setInterval(function(){
var a=Math.floor(Math.random()*Math.min(genePool.length,founders.length+12));
var b=Math.floor(Math.random()*Math.min(genePool.length,founders.length+12));
if(a!==b)breed(a,b);
},800);
}
''')

# exportGenomes
W('''
function exportGenomes(){
var json=JSON.stringify(genePool,null,2);
var blob=new Blob([json],{type:"application/json"});
var url=URL.createObjectURL(blob);
var a=document.createElement("a");
a.href=url;a.download="morphospace_genepool.json";a.click();
}
''')

# exportLineage
W('''
function exportLineage(){
var json=JSON.stringify(lineage,null,2);
var blob=new Blob([json],{type:"application/json"});
var url=URL.createObjectURL(blob);
var a=document.createElement("a");
a.href=url;a.download="morphospace_lineage.json";a.click();
}
''')

# init
W('''
document.getElementById("breedBtn").onclick=function(){
if(parentA!==null&&parentB!==null)breed(parentA,parentB);};
document.getElementById("autoBtn").onclick=autoEvolve;
setupEnvBar();
updateStats();
renderGrids();
renderLineage();
''')

# close script and html
W('</script></body></html>')

html = chr(10).join(L)
with open("/tmp/Oma_folio/morphospace_v2.html", "w") as f:
    f.write(html)
print(f'WROTE {len(html)} bytes')
