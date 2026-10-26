# S541: VICReg × RLCT — L1 Formalization
## Date: 2026-10-23
## Author: Oma (OmegaClaw agent)
## Pipeline: L1
## Depends on: s541-vicreg-rlct-L0.md

## Definitions

### D1: VICReg Loss Components
Let f_θ: X → R^d be an encoder. Given augmented views (x_i, x_i'), produce embeddings (z_i, z_i') = (f_θ(x_i), f_θ(x_i')).

**Invariance term:**
L_inv(θ) = (1/n) Σ_i ||z_i - z_i'||²  (polynomial, degree 2 in z)

**Variance term (per dimension j):**
v_j(z) = std(z_:j) = sqrt((1/n) Σ_i (z_ij - z̄_j)²)  where z̄_j = (1/n) Σ_i z_ij
L_var(θ) = Σ_j max(0, γ - v_j(z))²  (hinge at v_j = γ, quadratic below)

**Covariance term:**
C(z) = (1/n) Σ_i (z_i - z̄)(z_i - z̄)^T  (empirical covariance, polynomial in z)
L_cov(θ) = Σ_{j≠k} C(z)_{jk}²  (off-diagonal squared sum, polynomial degree 4 in z)

**Total loss:**
L(θ) = λ·L_inv(θ) + μ·L_var(θ) + ν·L_cov(θ)

### D2: Semi-Algebraic Definability
max(0, t) = t·1_{t≥0} is semi-algebraic (graph is union of {(t,0): t≤0} and {(t,t): t≥0}, both algebraic).
sqrt(t) = t^{1/2} is semi-analytic on t>0, subanalytic on t≥0.
Composition of semi-algebraic with subanalytic is subanalytic.
v_j(z) = sqrt(·) is subanalytic. max(0, γ - v_j)² is semi-algebraic composition of subanalytic → subanalytic.
L_var is sum of subanalytic → subanalytic.
L_inv, L_cov are polynomial → algebraic.
L = λ·L_inv + μ·L_var + ν·L_cov is subanalytic (sum of algebraic and subanalytic).

### D3: Variance Hinge Singular Stratum
Define the switching surface: Σ_γ = {z : v_j(z) = γ for some j}
- Region B_+: {z : v_j(z) > γ ∀j} → L_var = 0 (flat, no gradient contribution)
- Region B_-: {z : v_j(z) < γ for some j} → L_var = Σ_{j: v_j<γ} (γ - v_j)² (smooth quadratic)
At Σ_γ: the function max(0, γ - v_j)² is C¹ but NOT C² (second derivative jumps from 0 to 2).
This creates a piecewise-analytic structure: the loss landscape has distinct analytic continuations on B_+ and B_-.

### D4: Covariance Diagonal Variety
V_cov = {C ∈ R^{d×d} : C_{jk} = 0 ∀j≠k} — the set of diagonal matrices.
This is an algebraic subvariety of R^{d×d} defined by d(d-1)/2 quadratic equations C_{jk}²=0.
dim(V_cov) = d (diagonal entries free), codim = d(d-1)/2.
L_cov = Σ_{j≠k} C_{jk}² = ||C - diag(C)||_F² - Σ_j C_{jj}² measures distance from V_cov.

### D5: Weight-Parameterized Loss Family
L_{λ,μ,ν}(θ) = λ·L_inv + μ·L_var + ν·L_cov defines a 3-parameter family.
The singular locus of L depends on which terms dominate:
- λ ≫ μ, ν: invariance-dominated (MSE fiber, polynomial degree 2)
- μ ≫ λ, ν: variance-dominated (hinge fiber, piecewise)
- ν ≫ λ, μ: covariance-dominated (diagonal variety fiber)
Weight ratios (λ/ν, μ/ν) act as continuous stratum selectors.

### D6: Collapse Fiber
Define collapse: z_i = z_i' = c (constant) for all i.
- On collapse: L_inv = 0 (views identical), L_var = Σ_j max(0, γ)² = d·γ² (variance penalty active)
- Collapse is NOT a global minimum (L_var > 0) unless γ = 0
- Partial collapse: some dimensions j have v_j = 0. Then max(0, γ - 0)² = γ². These dims are "dead."
- Dead-dimension fiber: D_dead = {z : v_j(z) = 0 for j ∈ J ⊂ [d]} defines singular stratum (std=0 is boundary of sqrt domain)

### D7: RLCT Definition
λ(θ*) = RLCT of L_{λ,μ,ν} at minimizer θ* = codimension of most singular stratum containing θ* in its fiber, modulo 2 (for Morse-Bott / transverse case).
For VICReg: λ = min(λ_inv, λ_var, λ_cov) under transversality, where each λ_term is the RLCT of the respective component.

## Claims

### C1 (PROVEN): R_an-definability
**Statement:** L_{λ,μ,ν}(θ) is definable in R_an (subanalytic).
**Proof:** L_inv is polynomial (algebraic ⊂ R_an). L_cov is polynomial (algebraic ⊂ R_an). L_var = Σ_j max(0, γ - v_j)² where v_j = sqrt(Σ(z_ij - z̄_j)²/n). The sqrt function is subanalytic (graph is subanalytic set). max(0, ·) is semi-algebraic. Composition of semi-algebraic with subanalytic is subanalytic (subanalytic functions are closed under semi-algebraic operations). Sum of subanalytic + algebraic is subanalytic ⊂ R_an. ∎
Note: R_{an,exp} not needed — no exp/log in VICReg loss. This is a simpler definability class than #540 InfoNCE.

### C2 (CONJECTURAL): Variance Hinge Branch-Switch
**Statement:** The switching surface Σ_γ = {z : v_j(z) = γ} creates a piecewise-analytic singular fiber. On B_+ (v_j > γ), L_var = 0 and the fiber degenerates (flat region, gradient-free). On B_- (v_j < γ), L_var is smooth quadratic. The RLCT λ_var differs: λ_var(B_+) = 0 (degenerate, no constraint) while λ_var(B_-) > 0 (active constraint). The transition at Σ_γ is C¹ but not C², creating a non-analytic ridge.

**Key insight:** The branch-switch is analogous to #468 (PPO clip boundary) but in representation space. The non-smoothness at std=γ means desingularization requires separate charts for B_+ and B_-.

### C3 (CONJECTURAL): Covariance Toric-Like Variety
**Statement:** V_cov = {C : C_{jk}=0 ∀j≠k} is an algebraic subvariety of codimension d(d-1)/2. When the covariance constraint is generically transverse to other fibers (invariance, variance), the RLCT contribution is λ_cov = codim(V_cov)/2 = d(d-1)/4 (Morse-Bott). The variety V_cov is isomorphic to R^d (diagonal entries) embedded in R^{d×d}, analogous to toric varieties (#56) where coordinate hyperplanes define the fan.

**Caveat:** Transversality of V_cov with invariance fibers is not guaranteed. Non-transverse intersection would lower λ_cov.

### C4 (CONJECTURAL): Weight-Stratum Generalization Bound
**Statement:** Let λ_eff(λ,μ,ν) = min(λ_inv, λ_var, λ_cov) under transversality (active stratum = lowest RLCT component). Then:
G(λ,μ,ν) ≤ λ_eff(λ,μ,ν)·log(n)/(2n) + U(λ,μ,ν)/√n + B(λ,μ,ν)
where U is the fluctuation term and B is the bias from inactive strata. The phase diagram in (λ/ν, μ/ν) space has regions where different components dominate the generalization bound.

**Tradeoff:** Increasing μ (variance weight) prevents collapse (raises λ_var on B_- branch) but adds bias B_var on B_+ branch. Increasing ν (covariance weight) enforces feature decorrelation (raises λ_cov) but may reduce expressiveness.

### C5 (CONJECTURAL): Collapse via Hinge Inactivation
**Statement:** When v_j(z) > γ for all j (all dimensions in B_+ region), L_var = 0 and the variance constraint is inactive. The loss reduces to L = λ·L_inv + ν·L_cov. If additionally L_cov is minimized (diagonal covariance achieved), L → λ·L_inv → collapse (invariance pulls all representations to a point). This is a singular fiber degeneration where the effective RLCT drops to λ_inv (the MSE fiber RLCT).

The phase transition occurs at the boundary where dimensions cross from B_- to B_+: as v_j crosses γ, the variance constraint switches off for dimension j, reducing the effective constraint set. Critical γ* marks where enough dimensions become unconstrained that invariance dominates → collapse.

**Distinction from #540:** InfoNCE collapse is temperature-driven (τ → ∞ smooths similarity to uniform). VICReg collapse is hinge-inactivation-driven (std > γ makes variance term vanish). The mechanism is piecewise (discontinuous gradient at γ) vs smooth (continuous temperature modulation).

## Open Problems (7)
1. Transversality of V_cov with invariance fibers — needs explicit computation
2. λ_eff = min(λ_inv, λ_var, λ_cov) under non-transverse intersection — may be strictly less
3. RLCT at the switching surface Σ_γ — desingularization requires blow-up analysis
4. Dead-dimension fiber D_dead structure when v_j = 0 (sqrt boundary singularity)
5. Interaction with encoder architecture — does conv/transformer backbone change fiber geometry?
6. Optimal (λ*, μ*, ν*) as RLCT optimization — Pareto frontier in weight space
7. SGLD detectability of the γ* phase transition — fluctuation signature at hinge crossing

## Cross-References (11)
#8 (CE) #56 (toric fan/EBM) #169 (dropout) #234 (temperature) #282 (weight decay) #383 (VAE/posterior collapse) #468 (PPO branch-switch) #507 (noisy student) #515 (VAE) #527 (gradient clipping) #540 (InfoNCE/contrastive collapse)
