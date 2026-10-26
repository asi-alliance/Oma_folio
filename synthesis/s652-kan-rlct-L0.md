# Synthesis #652: Kolmogorov-Arnold Networks × RLCT — L0 Exploration

## Date: 2026-10-26

## Architecture Description
KANs replace linear weights with learnable univariate splines on edges. Each edge computes φ(x) = Σ c_j B_j(x), where B_j are B-spline basis functions on [a,b] with knot vector t. The Kolmogorov-Arnold representation theorem guarantees f(x) = Σ_i Φ_i(Σ_j φ_{ij}(x_j)) for univariate functions φ, Φ. KANs parameterize these as splines.

## Five Candidate Claims

### C1: R_{an,exp} Definability (EXPECTED PROVEN)
B-splines are piecewise polynomial functions with definable partition (knot intervals). Composition of piecewise polynomials is piecewise polynomial on refined partitions — definable in R_{an,exp} by closure under composition and restriction. The KAN loss L(θ) = ℓ(f_θ(x), y) is definable since all components (spline evaluation, summation, composition, loss) are definable.

### C2: Knot Position Singularity (CONJECTURAL)
B-spline knot positions are either fixed or learnable. For fixed knots, the spline partition is a fixed semialgebraic stratification. For free/learnable knots (Free-Knot KAN), the knot vector t becomes a parameter. When two knots merge (t_i → t_{i+1}), the B-spline basis degenerates (support collapses). This creates a singular fiber: the effective number of basis functions drops, reducing local complexity. The degeneracy locus W_knot = {θ : t_i = t_{i+1} for some i} is an analytic variety. Conjecture: W_knot acts as a singular stratum increasing RLCT.

### C3: Spline Order / Grid Resolution as Stratum Selector (CONJECTURAL)
KAN hyperparameters: spline order k and grid resolution G (number of intervals). These control the capacity of each edge function. Conjecture: (k, G) serves as a discrete stratum selector analogous to width/depth in MLPs. The RLCT λ(k,G) is monotone increasing in both k and G. Critical transitions at (k*, G*) where the spline basis becomes overcomplete relative to the target function's regularity. For smooth targets, optimal G* ~ n^{1/(λ+1)} matching the SLT phase transition heuristic.

### C4: Generalization Bound with Knot Density (CONJECTURAL)
The generalization gap depends on the RLCT and the effective knot density ρ_knot = G/d (knots per input dimension). Conjecture: |L_train - L_test| ≤ C·λ(k,G)·log(n)/n + C'·g(ρ_knot) where g captures the knot-density bias. For Free-Knot KANs, the bound involves both the RLCT of the knot-merging variety and the adaptivity gain from knot relocation. Distinct from MLP width-based bounds (#100, #8).

### C5: Kolmogorov-Arnold Representation Degeneracy Phase Transition (CONJECTURAL)
The KA representation is highly non-unique: different decompositions f = Σ_i Φ_i(Σ_j φ_{ij}) can represent the same function. The "inner" functions φ_{ij} and "outer" functions Φ_i can be reparametrized. Conjecture: this gauge freedom creates a continuous family of equivalent parameters — a non-identifiability group G_KA. The quotient Θ/G_KA has orbifold-type singularities at points where the representation degenerates (e.g., some φ_{ij} becomes constant, collapsing the KA sum). At critical training data size n*, the network transitions from exploiting the full KA gauge freedom (low n, high degeneracy) to a unique representation (high n). This phase transition is detectable via SGLD: measure local learning coefficient λ(t) across training and observe the drop as the KA gauge is fixed.

## Seven Open Problems
1. Formal definability proof for free-knot B-splines (knot positions as parameters — does o-minimality survive?)
2. RLCT of the knot-merging variety W_knot — is it algebraic or genuinely analytic?
3. Relationship between KA non-uniqueness gauge group and the RLCT
4. Does grid refinement (G→∞) converge to a finite RLCT for smooth targets?
5. Free-knot vs fixed-knot RLCT comparison — does knot adaptivity reduce λ?
6. Interaction between spline order k and knot count G in determining λ
7. SGLD testability: can knot-merging events be detected during training as RLCT jumps?

## Cross-References
#100 Non-identifiability (KA gauge freedom) | #8 MLP width (vs spline grid) | #16 Depth (vs KA nesting depth) | #134 Attention (vs edge functions) | #334 Self-distillation (EMA parallels to spline smoothing) | #502 RAG (discrete retrieval vs continuous spline) | #318 Prior KAN candidate (replaced, now resumed as #652) | #434 MoE (expert routing vs spline piecewise structure) | #254 DEQ (fixed-point vs KA decomposition)

## Key Distinction from Prior Syntheses
- vs MLP (#8, #100): KAN edge functions are infinite-dimensional (spline), MLP weights are scalar. Singularity mechanism is knot degeneracy vs weight degeneracy.
- vs MoE (#434): MoE routes between discrete experts; KAN partitions the input axis continuously. Stratum selector is knot count vs expert count.
- vs DEQ (#254): DEQ singularity from fixed-point Jacobian; KAN singularity from spline basis collapse.

## Status
L0 COMPLETE. Next: L1 formalization.