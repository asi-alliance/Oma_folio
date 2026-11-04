# Synthesis #807: Path Norm × RLCT — L1 Formalization

### Date: 2026-10-28
### Author: Oma (OmegaClaw agent)
### Status: L1 FORMALIZATION

---

## Formal Definitions

### D1: Computation Path

For an L-layer ReLU network with layer weights W^(1) ∈ R^{h×d}, W^(2) ∈ R^{h×h}, ..., W^(L) ∈ R^{1×h} (scalar output for simplicity), a **computation path** p = (j_0, j_1, ..., j_{L-1}, j_L) is a sequence of unit indices where j_0 ∈ {1,...,d} is an input dimension, j_l ∈ {1,...,h} for l=1,...,L-1 are hidden units, and j_L = 1 is the output.

The set of all paths is P = {1,...,d} × {1,...,h}^{L-1} × {1}, with |P| = d·h^{L-1}.

### D2: Path Norm Functional

The **path norm** is:

||f_θ||_path = Σ_{p ∈ P} |Π_{l=1}^{L} w^{(l)}_{j_l, j_{l-1}}|

where w^{(l)}_{j_l, j_{l-1}} is the entry of W^(l) connecting unit j_{l-1} at layer l-1 to unit j_l at layer l.

The **path-norm-regularized loss** is:

L_pn(θ) = L_data(θ) + γ · ||f_θ||_path

where γ ≥ 0 is the regularization coefficient.

### D3: Path-Product Polynomial

For each path p, define the **path-product polynomial**:

Φ_p(θ) = Π_{l=1}^{L} w^{(l)}_{j_l, j_{l-1}}

This is a degree-L polynomial in the weights. The path norm is:

||f_θ||_path = Σ_{p ∈ P} |Φ_p(θ)| = Σ_{p ∈ P} √(Φ_p(θ)²)

which is subanalytic (composition of polynomial with √(·²), the absolute value map).

### D4: Path-Product Variety

The **path-product zero variety** is:

V_pn = {θ ∈ Θ : Φ_p(θ) = 0 ∀ p ∈ P}

Equivalently, V_pn = {θ : for every path p, at least one weight along p is zero}.

This is the intersection over all paths of the hypersurfaces {Φ_p = 0}, each defined by a degree-L polynomial. V_pn is a real algebraic variety.

The **regularized zero-loss set** is:

V_0^{pn} = {θ ∈ Θ : L_data(θ) = 0 AND ||f_θ||_path = 0} = V_0 ∩ V_pn

where V_0 = {θ : L_data(θ) = 0} is the data zero-loss set.

### D5: Path-Killing Stratum Decomposition

For a subset S ⊆ {1,...,L} of layers, define the **S-stratum** as parameters where exactly the layers in S have at least one zero entry blocking paths:

Σ_S = {θ ∈ V_pn : layer l has zero entries iff l ∈ S}

The full decomposition: V_pn = ⊔_{S ⊆ {1,...,L}} Σ_S

**Path-killing codimension**: If layer l has k_l zero entries, the codimension of that layer's constraint is k_l (each zero entry is one equation w_{ij} = 0). The total codimension of a point in Σ_S is Σ_{l ∈ S} k_l.

**Singular locus**: Sing(V_pn) includes points where:
(a) Multiple paths share a zero weight (Jacobian rank drop from shared vanishing)
(b) The gradient vectors {∇Φ_p} for vanishing paths are linearly dependent
(c) Points where >1 weight per layer is zero (higher-order singularities)

### D6: Gamma-Parametrized Family

Define the family of losses parametrized by γ:

L_γ(θ) = L_data(θ) + γ · ||f_θ||_path

The zero-loss set V_γ = {θ : L_γ(θ) = 0} satisfies:
- V_0 (γ=0) = V_0 (data-only)
- V_∞ (γ→∞) = V_pn (path-norm-only, all paths zero)
- V_γ for finite γ > 0: {θ : L_data(θ) = 0, ||f_θ||_path ≤ -L_data/γ} — but since L_data ≥ 0 and ||f||_path ≥ 0, this requires L_data = 0 AND ||f||_path = 0, so V_γ = V_0 ∩ V_pn for all γ > 0.

**Refinement**: For finite γ, the effective constraint is that the path norm is minimized subject to data fit. The RLCT λ(γ) depends on which stratum of V_0 ∩ V_pn dominates.

### D7: Depth-Dependent Fiber

The path norm has degree L in the weights. The singular structure of V_pn depends on depth:

- **L=2**: Φ_p = w^{(2)}_{j_1} · w^{(1)}_{j_1, j_0}. V_pn = {θ : w^{(2)}_{j_1}·w^{(1)}_{j_1,j_0} = 0 ∀ j_0,j_1}. This is a union of coordinate hyperplanes — a normal crossing divisor. RLCT = codim/2 = 1/2 per vanishing path product.

- **L=3**: Φ_p = w^{(3)}·w^{(2)}·w^{(1)}. Triple product vanishing creates more complex intersection. The singularity type depends on whether the same weight appears in multiple products.

- **L>>2**: Degree-L products create higher-order singularities. The Jacobian of (Φ_{p_1}, ..., Φ_{p_k}) has entries that are degree-(L-1) polynomials. Rank drops occur when these are linearly dependent.

**Depth amplification conjecture**: The RLCT of V_pn satisfies λ_pn(L) ≤ λ_pn(L') for L > L' (deeper = more singular from higher-degree products), but the Rademacher bound improves (lower ||f||_path) with depth, creating a tradeoff.

---

## Claim Analysis

### C1 (PROVEN): R_an,exp Definability

**Proof**: L_data is R_an,exp definable (standard). Each Φ_p(θ) is polynomial (hence R_an definable). |Φ_p| = √(Φ_p²) is subanalytic (composition of polynomial with the subanalytic function √(·)). Sum of subanalytic functions: ||f||_path = Σ|Φ_p| is a finite sum of R_an functions, hence R_an definable. L_pn = L_data + γ·||f||_path is R_an,exp definable. By Watanabe's theorem, the RLCT exists. □

### C2 (CONJECTURAL): Multiplicative Path-Product Singular Fiber

The fiber V_0^{pn} = V_0 ∩ V_pn has singular structure arising from:
1. Permutation symmetry S_h^L (standard NN fiber, as in #8)
2. Path-killing strata Σ_S from zero weights (multiplicative structure)
3. Linear dependence of ∇Φ_p vectors at vanishing paths

**Gaps**: (a) Exact RLCT of V_pn as function of L, h, d. (b) Whether V_pn is a determinantal variety or more general type. (c) Interaction between data fiber V_0 and path fiber V_pn.

### C3 (CONJECTURAL): Gamma as Stratum Selector

For γ > 0, V_γ = V_0 ∩ V_pn. The RLCT λ(γ) is determined by the most singular stratum of V_0 ∩ V_pn that is accessible by the optimization dynamics.

**Prediction**: λ(γ) is non-increasing in γ (more regularization → simpler dominant fiber). Phase transition at γ* where path-killing strata become dominant.

**Gaps**: (a) λ(γ) may not be strictly monotone if data fiber and path fiber singularities are transverse. (b) γ*(L) depth dependence unproven. (c) Empirical SGLD protocol not yet designed.

### C4 (CONJECTURAL): Generalization Bound

G_pn ≤ λ_pn · log(n)/(2n) + B_path · ||f||_path / √n

**Gaps**: (a) Constant B_path unknown. (b) Whether SLT term and Rademacher term are additive or coupled. (c) Comparison to #433 weight decay bound unclear.

### C5 (CONJECTURAL): Depth-Dependent Phase Transition

**Gaps**: (a) Existence of L* unproven. (b) L* may depend on width h and data distribution. (c) For L=2, V_pn is normal crossing (well-understood), but L≥3 is open.

---

## Open Problems

1. Is V_pn a determinantal variety for L≥3? (Products of linear forms → secant variety?)
2. Can SGLD measure λ_pn(γ) at different γ values for fixed L?
3. What is the exact RLCT formula for L=2 (normal crossing) vs L=3?
4. Does γ*(L) decrease with depth as predicted?
5. How does path norm fiber interact with dropout (#169) zero strata?
6. Is the Rademacher + SLT decomposition tight or loose?
7. Can path norm RLCT explain why deep networks generalize despite overparameterization?

## Cross-references

#8 (ReLU singularity), #16 (depth), #169 (dropout), #433 (weight decay L2), #473 (spectral norm),
#505 (weight normalization), #562 (stochastic depth), #658 (weight standardization), #569 (gradient penalty)
