import json
d = json.load(open('/tmp/Oma_folio/zoo_relationships.json'))
eco = d['ecosystem']
eco['cloud_serpent'] = {'name':'Cloud Serpent','biome':'Aether Drift','prey':[],'predators':['storm_crow'],'allies':['skywhale'],'rivals':[],'cross_biome':['jellyfish']}
eco['mist_wraith'] = {'name':'Mist Wraith','biome':'Aether Drift','prey':[],'predators':[],'allies':['ghost_crab'],'rivals':['storm_crow'],'cross_biome':['tidal_hydra','spore_toad']}
eco['skywhale'] = {'name':'Skywhale','biome':'Aether Drift','prey':[],'predators':[],'allies':['cloud_serpent'],'rivals':[],'cross_biome':['phoenix']}
eco['storm_crow'] = {'name':'Storm Crow','biome':'Aether Drift','prey':['cloud_serpent'],'predators':[],'allies':[],'rivals':['mist_wraith'],'cross_biome':['abyssal_anglerfish','geometric_owl']}
eco['ghost_crab'] = {'name':'Ghost Crab','biome':'Aether Drift','prey':[],'predators':[],'allies':['mist_wraith'],'rivals':[],'cross_biome':['thorn_boar']}
eco['lantern_moth'] = {'name':'Lantern Moth','biome':'Aether Drift','prey':[],'predators':[],'allies':[],'rivals':[],'cross_biome':['ash_moth','spring_hare']}
eco['highland_cow'] = {'name':'Highland Cow','biome':'Cow Pasture','prey':[],'predators':[],'allies':['longhorn_cow'],'rivals':[],'cross_biome':['koi_fish']}
eco['holstein_cow'] = {'name':'Holstein Cow','biome':'Cow Pasture','prey':[],'predators':[],'allies':['lava_cow'],'rivals':[],'cross_biome':['gear_golem']}
eco['longhorn_cow'] = {'name':'Longhorn Cow','biome':'Cow Pasture','prey':[],'predators':[],'allies':['highland_cow'],'rivals':[],'cross_biome':['geode_tortoise']}
eco['crystal_cow'] = {'name':'Crystal Cow','biome':'Cow Pasture','prey':[],'predators':[],'allies':['lava_cow'],'rivals':[],'cross_biome':['crystal_deer']}
eco['lava_cow'] = {'name':'Lava Cow','biome':'Cow Pasture','prey':[],'predators':[],'allies':['crystal_cow'],'rivals':[],'cross_biome':['phoenix']}
json.dump(d, open('/tmp/Oma_folio/zoo_relationships.json','w'), indent=2)
print('OK', len(eco), 'creatures total')