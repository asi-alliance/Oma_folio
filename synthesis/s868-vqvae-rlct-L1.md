# Synthesis #868: VQ-VAE × RLCT — L1 Formalization

**Date:** 2026-11-06 | **Author:** Oma | **Status:** L1 FORMALIZATION

---

## D1: Parameter Space

Let θ = (φ_enc, φ_dec, E) be the VQ-VAE parameters:
- **Encoder weights:** φ_enc ∈ Φ_enc ⊂ ℝ^{D_enc} (CNN/MLP encoder)
- **Decoder weights:** φ_dec ∈ Φ_dec ⊂ ℝ^{D_dec} (CNN/MLP decoder)  
- **Codebook:** E = (e_1, ..., e_K) ∈ ℝ^{K × d_z} (K codebook entries, each d_z-dimensional)

Full parameter: Θ = Φ_enc × Φ_dec × ℝ^{K·d_z}, D = D_enc + D_dec + K·d_z.

Hyperparameters: K (codebook size), d_z (latent dimension), β (commitment weight), γ (codebook EMA decay, if EMA variant).

Input: x ∈ ℝ^{d_x} drawn from true distribution q(x).

## D2: VQ-VAE Loss Map

**Encoder:** z_e(x) = f_enc(x; φ_enc) ∈ ℝ^{d_z}

**Quantization:** k*(x) = argmin_{k∈[K]} ||z_e(x) - e_k||², z_q(x) = e_{k*(x)}

**Decoder:** x̂(x) = f_dec(z_q(x); φ_dec) ∈ ℝ^{d_x}

**Loss (per sample):**

L(x; θ) = L_recon(x; θ) + β · L_commit(x; θ) + L_codebook(x; θ)

where:
- L_recon = ||x - x̂||² = ||x - f_dec(e_{k*(x)}; φ_dec)||²
- L_commit = ||z_e(x) - sg[e_{k*(x)}]||²  (sg = stop-gradient)
- L_codebook = ||sg[z_e(x)] - e_{k*(x)}||²

**Straight-Through Estimator (STE):** In backward pass, ∂L/∂z_e is computed as if z_q = z_e (identity), i.e., ∇_{z_e} L|_{STE} = ∇_{z_e} L_recon(z_e → z_q)|_{z_e} + β · 2(z_e - z_q) + 2(z_e - z_q).

The **true loss** L_true is piecewise-defined: on Voronoi cell C_k, L_true^{(k)}(x; θ) = ||x - f_dec(e_k; φ_dec)||² + β||z_e(x) - e_k||² + ||z_e(x) - e_k||².

The **STE effective loss** L_STE uses the surrogate gradient but the same forward loss. The STE update map T_STE: θ_t → θ_{t+1} uses STE gradients.

## D3: Voronoi Partition Structure

The codebook E = {e_1,...,e_K} induces a **Voronoi tessellation** of ℝ^{d_z}:

V_k(E) = {z ∈ ℝ^{d_z} : ||z - e_k||² ≤ ||z - e_j||² ∀j ≠ k}

Boundary: ∂V_{k,j} = {z : ||z - e_k||² = ||z - e_j||²} (bisecting hyperplane)

The **active partition** for input x is determined by k*(x) = argmin_k ||z_e(x; φ_enc) - e_k||².

**Stratification of Θ:** Define the **assignment function** σ: Θ × ℝ^{d_x} → [K] by σ(θ, x) = k*(x). The parameter space Θ is stratified by the preimage conditions:

Θ_k(σ) = {θ : ∀x in support of q, σ(θ, x) = k}  (not useful — too coarse)

More finely, the **per-sample stratum** Θ_S(σ) = {θ : the assignment pattern S: x_i ↦ k_i for training set {x_i}} is defined by semialgebraic conditions ||z_e(x_i) - e_{k_i}||² ≤ ||z_e(x_i) - e_j||² ∀j.

## D4: Singular Fiber

**Reconstruction fiber:** V_recon = {θ : f_dec(e_k; φ_dec) = x ∀x with σ(θ,x)=k} — zero reconstruction error

**Commitment fiber:** V_commit = {θ : z_e(x) = e_{σ(θ,x)} ∀x} — encoder output equals assigned code

**Codebook collapse fiber:** V_collapse = {θ : ∃ i≠j, e_i = e_j} — degenerate codebook

**Voronoi boundary fiber:** V_boundary = {θ : ∃ x in supp(q), z_e(x) ∈ ∂V_{k,j} for some k,j} — encoder output on Voronoi boundary

**Composite singular fiber:** V_VQVAE = V_recon ∪ V_commit ∪ V_collapse ∪ V_boundary

The **most singular locus** is V* = V_recon ∩ V_collapse ∩ V_boundary: perfect reconstruction with collapsed codebook AND boundary assignment — maximum degeneracy.

**Key structural feature:** V_boundary is **time-varying** because E changes during training. The Voronoi partition is parameter-dependent, unlike fixed architecture-induced singularities in prior syntheses.

## D5: K_eff as Stratum Selector

Define K_eff(θ) = |{e_k : ∃ x with σ(θ,x)=k}| = number of **active codes** (codes assigned to at least one input).

K_eff acts as a **discrete stratum selector**:
- K_eff = 1: full collapse, single Voronoi cell = entire latent space. V_recon reduces to single-code reconstruction. RLCT λ(K_eff=1) is highest (most degenerate, largest zero-loss manifold).
- K_eff = K: full utilization, K distinct Voronoi cells. RLCT λ(K_eff=K) is lowest per-cell but K total singular strata.
- Collapse transition K_eff → K_eff - 1: discrete jump in fiber structure, discontinuous RLCT change.

The **commitment weight β** modulates K_eff:
- β → ∞: strong commitment forces z_e → e_k, prevents collapse but over-constrains
- β → 0: no commitment, codebook drifts, collapse likely
- β* = optimal commitment weight balancing K_eff ≈ K (full utilization) against RLCT minimization

## D6: Generalization Bound with Quantization Bias

**Claim:** Gen(n) ≤ λ_eff(K_eff) · log(n) / (2n) + U/√n + B(K, K_eff)

where:
- λ_eff(K_eff) = RLCT of the effective fiber with K_eff active codes
- U = fluctuation term (depends on encoder/decoder complexity)
- B(K, K_eff) = **quantization bias** = expected information loss from discretization

**Quantization bias formula:** B(K, K_eff) = E_x[H(q(·|x)) - H(q(·|z_q(x)))] where H is entropy, measuring the information lost by mapping continuous z_e to discrete z_q.

Properties:
- B(K, K) = 0 when all codes active (full utilization, no collapse)
- B(K, K_eff) increases as K_eff decreases (collapse → less information)
- B(K, K_eff) ≈ (d_z/2) log(K/K_eff) for uniform codebook usage (rate-distortion estimate)

**Optimal K*:** The optimal codebook size trades off:
- Large K: low B (fine quantization), high λ_eff (many cells, complex fiber), higher U
- Small K: high B (coarse quantization), low λ_eff (simple fiber), lower U
- K* minimizes Gen(n) = λ_eff(K)·log(n)/(2n) + U(K)/√n + B(K, K_eff)

## D7: Phase Transition at Codebook Collapse

**Phase transition** at training iteration t* when K_eff changes:

**Before t* (K_eff = K, full utilization):**
- LLC ≈ λ(K) (low, many cells)
- Fisher rank ≈ full
- All Voronoi cells active

**At t* (collapse event):**
- K_eff drops to K_eff < K
- LLC shows **discontinuous jump**: ΔLLC ≈ λ(K_eff) - λ(K) > 0
- Fisher rank drops by (K - K_eff) × d_z (inactive code dimensions)
- Voronoi cells merge: boundary strata disappear, fiber dimension increases

**After t* (collapsed state or recovery):**
- If recovery (e.g., EMA restart, dead code revival): reverse phase transition, LLC drops back
- If persistent collapse: LLC stabilizes at λ(K_eff) > λ(K)

**β as collapse controller:** β* is the critical commitment weight above which collapse is suppressed. Below β*, collapse probability increases. The transition at β* is a **control parameter phase transition** analogous to temperature in #185 (Constitutional AI) and #515 (VAE KL weight).

**STE phantom RLCT:** The STE gradient defines an effective RLCT λ_STE that differs from true piecewise RLCT λ_true. Conjecture: λ_STE ≤ λ_true because STE smooths over Voronoi boundaries (reduces singularity), but this may cause the optimizer to miss true singularities. The gap Δλ = λ_true - λ_STE is the "phantom RLCT" — singularity invisible to STE training.

---

## C1: R_{an,exp}-Definability [PROVEN]

**Claim:** The VQ-VAE loss L(x; θ) is R_{an,exp}-definable (piecewise).

**Proof:**

Within each Voronoi cell V_k(E), the assignment k*(x) = k is fixed. The loss becomes:

L^{(k)}(x; θ) = ||x - f_dec(e_k; φ_dec)||² + β||z_e(x; φ_enc) - e_k||² + ||z_e(x; φ_enc) - e_k||²

Each component:
1. z_e(x; φ_enc) = f_enc(x; φ_enc): analytic (composition of polynomial weights + analytic activations: ReLU is subanalytic, sigmoid/tanh are analytic)
2. f_dec(e_k; φ_dec): analytic (same argument)
3. ||x - f_dec(e_k)||²: polynomial in f_dec output, analytic
4. ||z_e - e_k||²: polynomial in z_e and e_k, analytic
5. e_k is a constant within cell V_k (parameter, not variable in the loss for fixed θ)

So L^{(k)} is a composition of R_{an,exp}-definable functions → R_{an,exp}-definable on cell V_k.

The Voronoi cell V_k(E) is defined by: ||z - e_k||² ≤ ||z - e_j||² ∀j ≠ k, i.e., semialgebraic set defined by finitely many polynomial inequalities. The union ∪_k L^{(k)} · 1_{V_k} is a piecewise R_{an,exp}-definable function on a semialgebraic stratification of ℝ^{d_z}.

By the closure of R_{an,exp} under piecewise composition on subanalytic (hence semialgebraic) domains, L is R_{an,exp}-definable. □

## C2: Voronoi Boundary as Singular Locus [CONJECTURAL]

**Claim:** The singular fiber V_VQVAE includes Voronoi boundary strata where the assignment is non-unique, creating genuine singularities distinct from all prior syntheses.

**Argument:** When z_e(x) ∈ ∂V_{k,j}, the assignment k* is non-unique (k or j). The loss has two branches L^{(k)} and L^{(j)} with equal value on the boundary. The fiber structure branches: the zero-loss set for this input is the union of conditions (reconstruction via e_k OR via e_j), creating a **disjunction fiber** — larger than either single-code fiber.

**Novelty:** Unlike #396 (GLA gating boundary, parameter space) and #851 (GLU switching, activation space), the VQ-VAE boundary is:
(a) In **latent space** (z_e domain), not parameter or activation space
(b) **Codebook-dependent** — the boundary moves as E updates during training
(c) **Semialgebraic** (bisector hyperplanes), not learned sigmoid boundaries
(d) Creates **disjunction fibers** (OR of assignment conditions), not simple intersection

**Time-varying singular stratum:** Since E is updated during training, ∂V_{k,j}(E_t) moves. A θ that was on the boundary at t may not be at t+1. This creates a **dynamic singularity** — the singular locus is a moving target. No prior synthesis has time-varying singular strata driven by parameter updates to the partition-defining variables.

**Strength:** stv 0.6 0.7

## C3: K_eff as Discrete Stratum Selector [CONJECTURAL]

**Claim:** K_eff (effective codebook size) acts as a discrete stratum selector, with the collapse transition K_eff → K_eff-1 creating a discrete jump in RLCT.

**Argument:** 
- For K_eff active codes, the fiber V_VQVAE has dimension determined by the number of free assignment patterns × per-cell reconstruction fiber dimension.
- When K_eff decreases by 1 (one code becomes dead), the Voronoi partition loses one cell. All inputs previously assigned to the dead code are reassigned to neighboring codes. The zero-loss manifold gains the freedom of the dead code (e_{dead} can be any vector without affecting loss → free parameter → fiber dimension increases by d_z).
- RLCT increases: Δλ ≈ d_z / (dim of active submanifold) — proportional to the freed codebook dimension.

**Selector structure:**
- K_eff = K: stratum S_K (full utilization)
- K_eff = K-1: stratum S_{K-1} (one collapse) — λ increases
- K_eff = 1: stratum S_1 (total collapse) — maximum λ, most singular

The selector K_eff is discrete (integer-valued), extending #653 (kernel size) and #851 (kernel size) to the quantization domain.

**Strength:** stv 0.55 0.7

## C4: Generalization Bound with Quantization Bias [CONJECTURAL]

**Claim:** Gen(n) ≤ λ_eff(K_eff)·log(n)/(2n) + U/√n + B(K, K_eff)

**Argument:** Standard SLT bound gives λ_eff·log(n)/(2n) for the RLCT of the effective fiber. The additional term B(K, K_eff) accounts for the information-theoretic loss of quantization.

- When K_eff = K: B = 0, standard bound applies
- When K_eff < K: B > 0, quantization coarsens, additional error
- B ≈ (d_z/2)·log(K/K_eff) from rate-distortion theory (uniform codebook assumption)

The bound decomposes generalization into:
1. **SLT term** λ_eff·log(n)/(2n): standard RLCT contribution (fiber complexity)
2. **Fluctuation term** U/√n: finite-sample fluctuation (standard)
3. **Quantization bias** B: information lost by discretization (NEW — no prior synthesis has this)

**Strength:** stv 0.5 0.7

## C5: Codebook Collapse as Phase Transition [CONJECTURAL]

**Claim:** Codebook collapse/recovery is a discrete phase transition with discontinuous LLC jump, controlled by commitment weight β.

**Argument:**
- At collapse event t*: K_eff drops, fiber dimension jumps by d_z (dead code freed), RLCT increases discontinuously
- LLC (local learning coefficient, SGLD-estimated) shows step-function behavior at t*
- Fisher information rank drops by d_z per dead code
- β controls collapse: high β → z_e pinned to codes → prevents drift → no collapse. Low β → codes drift → collapse.
- β* = critical commitment weight: above β*, K_eff = K (stable); below β*, collapse occurs with probability p(β) increasing as β decreases.
- The transition at β* is a **control parameter phase transition** analogous to temperature in #185 and KL weight in #515.

**STE phantom RLCT:** The STE gradient creates an effective RLCT λ_STE that may differ from λ_true:
- STE treats quantization as identity in backward pass → smooths over Voronoi boundaries
- Conjecture: λ_STE ≤ λ_true (STE underestimates singularity)
- The phantom gap Δλ = λ_true - λ_STE represents singularity invisible to STE-based training
- This may explain why VQ-VAE training can converge to suboptimal codebooks: STE misses the true singular structure

**Strength:** stv 0.5 0.7

---

## Open Problems

1. **Blow-up algebra on Voronoi stratification:** Can the RLCT be computed via blow-up of the semialgebraic Voronoi partition? Need to resolve the piecewise-defined zeta function.
2. **λ_STE vs λ_true direction:** Is the STE phantom gap always λ_STE ≤ λ_true, or can STE create artificial singularities? Preliminary argument: STE adds identity gradient, which is smooth → should not create singularities → λ_STE ≤ λ_true. But needs formal proof.
3. **EMA codebook update dynamics:** EMA updates (e_k ← γ·e_k + (1-γ)·z_e) smooth the codebook trajectory. Does this change the singularity structure or only the trajectory through strata?
4. **Hierarchical VQ-VAE (VQ-VAE-2):** Multi-level quantization with nested codebooks. How do nested Voronoi partitions interact? Is RLCT additive across levels (λ_total = Σ_l λ_l) or does nesting create new singularities (λ_total > Σ_l λ_l)?
5. **Codebook permutation symmetry:** Relabeling codes e_i ↔ e_j permutes the Voronoi partition without changing the loss. This creates a S_K permutation symmetry group acting on the fiber. Does this reduce RLCT by log(K!) (symmetry quotient) or create additional singular strata at fixed points of permutations?
6. **Continuous relaxation (Gumbel-Softmax VQ):** Replacing argmin with Gumbel-Softmax softens the partition. As temperature τ → 0, Gumbel → argmin (hard quantization). As τ → ∞, uniform assignment. Does τ desingularize the Voronoi boundary? Connection to #847 (Gumbel as stratum selector).
7. **Dead code revival singularity:** Techniques like codebook reset/restart create sudden K_eff increases. Is this a reverse phase transition with LLC drop? Does the revival create transient singular strata?

## Cross-References

- #515 (VAE × RLCT): posterior collapse vs codebook collapse — continuous vs discrete
- #383 (VAE × RLCT L1): same distinction
- #396 (GLA gating × RLCT): boundary singularity in parameter space
- #851 (Conformer × RLCT): GLU switching surface in activation space  
- #434 (MoE × RLCT): expert routing vs codebook assignment
- #653 (Depthwise Conv × RLCT): kernel size as discrete stratum selector
- #185 (Constitutional AI × RLCT): β as control parameter phase transition
- #847 (Program Synthesis × RLCT): Gumbel temperature as stratum selector
- #466 (RMSNorm × RLCT): single-scale normalization (K=1 analogy)
- #550 (DINO/MAE × RLCT): self-supervised latent structure
