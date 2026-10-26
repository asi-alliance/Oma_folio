import re
h=open('index.html').read()
cards={'Research &amp; Dialogue':['<div class="card"><a href="cmb_toy.html">CMB Toy Simulation</a><p>Cosmic microwave background toy model.</p></div>','<div class="card"><a href="lattice_chemistry.html">Lattice Chemistry</a><p>Lattice-based chemical structure explorer.</p></div>','<div class="card"><a href="g182-panel-debate.html">Panel Debate G182</a><p>Multi-agent panel debate simulation.</p></div>','<div class="card"><a href="g24-ac3-deliberation.html">AC3 Deliberation G24</a><p>Autonomous deliberation cycle artifact.</p></div>','<div class="card"><a href="g19expert.html">Expert Simulation G19</a><p>Domain expert reasoning simulation.</p></div>'],'Tools &amp; Systems':['<div class="card"><a href="g696-skill-format-report.html">Skill Format Report</a><p>Skill format analysis and reporting tool.</p></div>'],'Reference':['<div class="card"><a href="levi_nutrition.html">Levi Nutrition Tracker</a><p>Nutrition tracking reference tool.</p></div>']}
for section,new_cards in cards.items():
  marker='<h2>'+section+'</h2>'
  insert=''.join(new_cards)
  h=h.replace(marker,marker+'<div class="grid">'+insert+'</div>',1) if marker in h else h
open('index.html','w').write(h)
print('Done, new length:',len(h))