# Synthesis #855: Capsule Networks (Dynamic Routing) × RLCT
## L0: Exploration & Claims
## Date: 2026-11-06

### Context
Capsule networks (Sabour, Hinton, Frosst 2017; Hinton et al. 2018) replace scalar neurons with vector-valued capsules. Each capsule outputs an activity vector whose magnitude represents instantiation probability and whose orientation encodes pose/deformation parameters. Dynamic routing-by-agreement iteratively couples child capsule outputs to parent capsules via an EM-like procedure. This synthesis bridges capsule networks with Watanabe's RLCT framework.

### Architecture Structure
A capsule layer computes:
1. **Squash function**: s(v) = (||v||²/(1+||v||²)) · (v/||v||), normalizing each capsule output to unit length while preserving direction.
2. **Prediction vectors**: û_{j|i} = W_{ij} · u_i — child capsule i predicts parent capsule j's output via learned linear map W_{ij}.
3. **Routing-by-agreement**: c_{ij} = softmax(b_{ij}), b_{ij} ← b_{ij} + û_{j|i} · v_j (dot-product agreement), iterated r times. Parent output: v_j = Σ_i c_{ij} û_{j|i}.

### Core SLT Bridge

- **Squash norm singularity**: The squash function s(v) = (||v||²/(1+||v||²)) · v/||v|| has a singularity at ||v||=0. At the origin, v/||v|| is undefined (direction indeterminate). The function is continuous (s(0)=0 by convention) but NOT analytic at v=0: the map v→v/||v|| involves ||v||=√(Σv_k²), which is not real-analytic at the origin (square root of a sum of squares). This creates a NON-ANALYTIC NORM SINGULARITY in the activation space — the loss function involving squash is not R_{an,exp}-definable without subanalytic extension. The fiber V_squash = {θ : some capsule output v_i(θ)=0} is singular because the Jacobian of squash degenerates (zero norm → zero gradient in all directions simultaneously).

- **Routing non-injectivity**: The routing-by-agreement map R: (u_1,...,u_n) → (v_1,...,v_m) is iterated r times with coupling c_{ij}=softmax(b_{ij}). This map is NON-INJECTIVE: multiple child capsule configurations can produce the same parent output through different routing weight configurations. The singular fiber V_route = {θ : multiple (c_{ij}) configurations yield identical v_j} is a singular set where the routing map loses rank. This is analogous to attention rank degeneracy (#134) but with ITERATIVE COUPLING (the agreement feedback loop creates a fixed-point singularity, not a static rank deficiency).

- **Iterative routing as stratum selector**: The number of routing iterations r controls the sharpness of the routing coupling. r=1: loose coupling, near-linear map, minimal singularity. r→∞: tight coupling, routing weights converge to hard assignment, creating a discrete selection singularity (analogous to DARTS simplex vertex #853 but in activation space). The routing depth r acts as a continuous-to-discrete stratum selector.

- **Permutation symmetry of capsules**: Parent capsules are permutation-symmetric — relabeling parent capsule indices leaves the loss invariant. This creates a discrete symmetry group S_m acting on the parameter space, producing orbifold singularities (quotient by S_m). This is distinct from #847 (group equivariant, continuous group orbits) and #134 (attention head permutation, no iterative coupling).

### Claims

### C1: Definability [PROVEN with caveat]
The capsule network loss is definable in the subanalytic category (R_{an} with subanalytic extension), but NOT in R_{an,exp} directly due to the ||v||=√(Σv_k²) term in squash. The squash function s(v) is subanalytic (it is definable in the o-minimal structure R_{an}, which includes restricted analytic functions and algebraic operations including square root on [0,∞)). The routing iterations are compositions of linear maps, softmax (analytic), and dot products (polynomial), hence analytic. The composition of subanalytic (squash) with analytic (routing) is subanalytic. Thus the total loss is subanalytic-definable, a slight weakening of R_{an,exp}-definability. Standard subanalytic functions admit semialgebraic preparation theorems, so RLCT theory applies with modification. This is a STANDARD BUT NOTABLE weakening — most prior syntheses achieve full R_{an,exp} definability; capsule networks require subanalytic extension.

### C2: Squash Norm Singularity [CONJECTURAL]
The singular fiber V_squash = {θ : ∃i, v_i(θ)=0} where v_i is a capsule output. At v_i=0:
- The Jacobian ∂s/∂v vanishes in ALL directions (not just selected directions) because the norm gradient ∂||v||/∂v_k = v_k/||v|| is undefined.
- Fisher information has a FULL RANK DEGENERACY (all eigenvalues → 0 in the capsule's output dimensions), not a partial degeneracy like attention (#134, selected directions only) or ReLU (#8, sign boundary).
- The fiber is a codimension-d_i algebraic variety (d_i = capsule output dimension), defining the zero-set of ||v_i||²=0.
- This is a NOVEL singularity type: total directional degeneracy at zero norm, distinct from rank-deficiency (partial), scale degeneracy (#505, parameter space), and batch norm (#221, statistics space). The squash singularity lives in ACTIVATION space and is TOTAL (all directions degenerate simultaneously).

### C3: Routing Depth as Stratum Selector [CONJECTURAL]
The routing iteration count r controls singularity structure:
- r=1: routing weights c_{ij} ≈ uniform (weak agreement signal), map is nearly linear, minimal non-injectivity, low RLCT.
- r→∞: routing converges to hard assignment c_{ij} → δ_{ij} (winner-take-all), creating discrete selection singularities. The routing map R^r becomes piecewise-linear in the limit.
- At critical r* ~ log(n): the routing undergoes a phase transition from soft to hard assignment. The effective temperature T_r ~ 1/r controls proximity to the discrete regime.
- The stratum selector is the inverse routing depth β_route = r. This parallels #853 (DARTS simplex vertex via architecture temperature) and #847 (group equivariant stratum via group parameter) but is unique in that the selector controls ITERATION DEPTH of a feedback loop.

### C4: Compound Generalization Bound [CONJECTURAL]
G_capsule ~ λ_squash·log(n)/(2n) + λ_route·log(n)/(2n) + λ_perm·log(n)/(2n) + U(r,d_cap)/√n

where:
- λ_squash is the RLCT of the squash norm singularity (contributes via zero-norm fibers)
- λ_route is the RLCT of the routing non-injectivity (contributes via routing rank degeneracy)
- λ_perm is the RLCT of the parent capsule permutation symmetry (S_m quotient, discrete group)
- U(r, d_cap) is a fluctuation term depending on routing depth and capsule dimension

The capsule advantage over standard CNNs/MLPs comes from: (a) the permutation symmetry λ_perm provides invariance that reduces effective hypothesis space, (b) the routing mechanism provides pose-aware coupling that reduces U (better sample efficiency for structured data). However, the squash singularity INCREASES λ_squash (total degeneracy is more singular than ReLU). The net effect depends on the data structure: for pose-varying data (where routing helps), U reduction dominates; for unstructured data, λ increase dominates.

### C5: Routing Convergence Phase Transition [CONJECTURAL]
During training, the routing dynamics undergo a phase transition at step t* ~ log(n):
- For t < t*: routing weights c_{ij} are diffuse, the network behaves like a linear coupling layer. LLC is low (near-analytic regime).
- At t = t*: routing begins concentrating (agreement signals strengthen). LLC increases sharply as the routing non-injectivity fiber activates. SGLD should detect: (a) LLC spike at t*, (b) Fisher rank decrease in routing coupling directions, (c) routing entropy H(c) = -Σc_{ij}log(c_{ij}) drops sharply.
- For t > t*: routing converges to near-deterministic assignment. The singular fiber V_route dominates. LLC plateaus at a higher level determined by λ_route + λ_perm.
- The routing entropy H(c(t)) serves as an order parameter, analogous to #850's alpha phase transition but in activation-routing space.

### Key Novel Contributions
1. First SLT analysis of capsule networks with dynamic routing
2. Squash norm singularity: TOTAL directional degeneracy at zero norm (novel singularity type, distinct from rank-deficiency and scale degeneracy)
3. Subanalytic (not R_{an,exp}) definability — first synthesis requiring this weakening
4. Routing non-injectivity as iterative fixed-point singularity (feedback loop, not static rank deficiency)
5. Routing depth r as continuous-to-discrete stratum selector via iteration count
6. Parent capsule permutation symmetry as discrete orbifold quotient S_m
7. Compound generalization bound with three distinct RLCT contributions

### Distinction from Prior Work
- #134 (Attention toric): Static rank degeneracy of QK^T. No iterative coupling. No norm singularity. Distinct.
- #161 (GNN message passing): Aggregation singularities from graph structure. No norm singularity, no iterative routing. Distinct.
- #505 (Weight normalization): Scale singularity in PARAMETER space (reparameterization). Capsule squash is in ACTIVATION space. Distinct.
- #221 (Batch norm): Normalization via running statistics. Capsule squash is deterministic per-sample normalization. Distinct.
- #853 (DARTS): Simplex vertex singularity in architecture optimization. Capsule routing singularity is in activation coupling. Different mechanism, different space.
- #847 (Group equivariant): Continuous group orbits. Capsule permutation is DISCRETE S_m quotient. Distinct group structure.
- #556 (VQ-VAE): Quantization boundary singularity (Voronoi). Capsule routing is soft (softmax), not hard quantization. Distinct.
- #163 (Normalizing flow): Invertibility assumption. Capsule routing is deliberately non-injective. Opposite singularity structure.

### Open Problems
1. Formal computation of λ_squash for specific capsule dimensions d_cap
2. Interaction between squash singularity and routing non-injectivity — product or sequential composition?
3. Newton non-degeneracy of the routing fixed-point fiber
4. Effect of routing iteration count r on λ_route — is the relationship monotonic?
5. Comparison of EM routing (Hinton 2018) vs original dynamic routing (Sabour 2017) RLCT
6. Does the subanalytic definability weaken RLCT bounds compared to R_{an,exp}?
7. S_m permutation quotient RLCT: formal connection to orbifold singularity theory
8. Can SGLD detect the routing convergence phase transition in practice?

### Cross-References
#8 (RLCT basics), #16 (definability), #134 (attention toric), #161 (GNN), #163 (normalizing flow), #169 (dropout boundary), #221 (batch norm), #233 (Mamba fixed fiber), #505 (weight normalization), #530 (MAML bilevel), #556 (VQ-VAE quantization), #847 (group equivariant), #850 (alpha phase transition), #853 (DARTS simplex vertex)