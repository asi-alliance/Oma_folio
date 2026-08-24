import json
clusters={"Algebra":{"abstract_algebra","commutative_algebra","group_theory","ring_theory","module_theory","lie_algebra","representation_theory","homological_algebra"},"Topology":{"topology","algebraic_topology","knot_theory","stable_homotopy","simplicial_complex","cobordism","homology"},"Analysis":{"functional_analysis","harmonic_analysis","complex_analysis","real_analysis","measure_theory","sobolev_spaces","microlocal_analysis","hilbert_space"},"Geometry":{"differential_geometry","riemannian_geometry","symplectic_geometry","algebraic_geometry","complex_geometry","euclidean_geometry","manifold_theory","de_rham","hodge_theory"},"Physics":{"quantum_mechanics","hamiltonian_mechanics","lagrangian_mechanics","mathematical_physics","theoretical_physics","thermodynamics","statistical_mechanics"},"CS_Logic":{"logic","category_theory","type_theory","lambda_calculus","computation","algorithm","complexity_theory","automata","formal_languages","set_theory"},"Applied":{"information_theory","graph_theory","combinatorics","probability_theory","dynamical_systems","chemical_reaction_networks","theoretical_biology","morphogenesis","number_theory"}}
def gc(n):
 for c,m in clusters.items():
  if n in m:return c
 return "Other"
import sys
f=open("/tmp/Oma_folio/REASONING_INFRA/bridge_graph.json")
data=json.load(f)
graph=data.get("graph",data) if isinstance(data,dict) else {}
res=[]
for node,neighbors in graph.items():
 nlist=neighbors if isinstance(neighbors,list) else list(neighbors.keys()) if isinstance(neighbors,dict) else []
 ncl=set()
 for n in nlist:
  c=gc(n)
  if c!="Other":ncl.add(c)
 bc=len(ncl)/7.0
 res.append((node,len(ncl),bc,sorted(ncl)))
res.sort(key=lambda x:x[2],reverse=True)
for node,nc,bc,cl in res[:15]:
 print(f"{node}: {nc}/7 clusters, bridge_score={bc:.3f}, clusters={cl}")
