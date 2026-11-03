# Synthesis #828: nGPT (Normalized Transformer) × RLCT — L1 Formalization
# Date: 2026-11-03
# Status: L1 DRAFT

## Formal Definitions

**D1 (Product-of-Spheres Parameter Space):** The nGPT parameter space is Θ = ∏_{i=1}^{M} S^{d_i - 1}, a product of M unit hyperspheres. Each parameter block θ_i ∈ S^{d_i-1} = {x ∈ R^{d_i} : ||x||² = 1} is constrained to unit norm. The total dimension is dim(Θ) = Σ_i (d_i - 1) = D - M where D = Σ_i d_i. This is a COMPACT manifold without boundary (each S^{d_i-1} is closed and compact, product of compacts is compact).

**D2 (nGPT Loss Function):** For a single attention head, the nGPT attention uses spherical dot products:

  a_{ij} = softmax_j( (q_i · k_j) / sqrt(d) )

where q_i = W_Q x_i / ||W_Q x_i||, k_j = W_K x_j / ||W_K x_j||, v_j = W_V x_j / ||W_V x_j|| (all rows of W_Q, W_K, W_V are unit vectors). The output is:

  y_i = Σ_j a_{ij} (v_j / ||v_j||) · W_O / ||W_O row||

The loss L(θ) = (1/n) Σ_j ℓ(y(x_j; θ), y_j) where ℓ is cross-entropy. All operations are compositions of dot products (bilinear, analytic), normalization (quotient of analytic by sqrt of sum of squares, analytic away from zero — but zero is excluded by sphere constraint), and softmax (exp-analytic).

**D3 (R_{an,exp}-Definability — C1 Proof):**

*Claim:* L(θ) for θ ∈ Θ = ∏ S^{d_i-1} is R_{an,exp}-definable.

*Proof:*
1. The sphere constraint ||θ_i||² = 1 is a real analytic equation — definable in R_an.
2. Dot products θ_i · θ_j are bilinear polynomials — analytic, definable in R_an.
3. The normalization x/||x|| is definable on the sphere (||x|| = 1 is fixed, so x/||x|| = x, the identity on S^{d-1}) — definable.
4. Softmax σ(z)_i = exp(z_i) / Σ_k exp(z_k) is a ratio of exp-analytic functions — definable in R_{an,exp}.
5. Cross-entropy loss ℓ(p, y) = -log(p_y) involves log = integral of 1/t, definable in R_{an,exp} (log is definable as the integral of an analytic function).
6. L is a finite sum of compositions of the above — definable by closure under addition, composition, and restriction to definable sets (the sphere).

By the definability theorem (Watanabe 2009, Thm 7.1), the RLCT λ is well-defined for L on Θ. QED.

**D4 (Antipodal Z_2 Singular Fiber):** Define the Z_2 action τ: Θ → Θ by τ(θ_1,...,θ_M) = (-θ_1,...,-θ_M). For loss terms involving only even-degree products of parameters (dot products θ_i · θ_j are degree-2, hence even), L(τ(θ)) = L(θ). The quotient space Θ/Z_2 = ∏ RP^{d_i-1} (product of real projective spaces). The singular fiber V_0 inherits this Z_2 action: V_0 is Z_2-invariant, and the effective parameter space is V_0/Z_2. The RLCT on the quotient may differ from the RLCT on the cover when:
- Bias terms or non-even-degree terms break the symmetry (then Z_2 is only approximate).
- The quotient has different singularity type (RP^n has fundamental group Z_2, unlike S^n which is simply connected for n ≥ 2).

**D5 (Built-in Desingularization via Sphere Constraint):** Standard transformer parameters live in R^d, which has a radial direction d/d||θ|| that creates scale degeneracy (rescaling θ → c·θ changes the output scale, creating a 1-dimensional degenerate fiber). This contributes a factor of 1/2 to the RLCT (the radial free direction). nGPT removes this by fixing ||θ_i|| = 1: the radial direction is eliminated, and the effective parameter space has dimension d_i - 1 per component.

Formally: λ_nGPT ≤ λ_standard - M/2, where M is the number of parameter blocks, because M radial free directions (one per sphere) are removed. This is an UPPER BOUND on the improvement; the actual improvement depends on whether the radial direction was actually a free direction in the standard fiber.

**D6 (Generalization Bound on Compact Manifold):** The standard SLT generalization bound is:

  Gen ≤ √(λ · σ² / n) + O(1/n)

For nGPT on compact Θ, this holds with λ = λ_nGPT. Additionally, compactness ensures:
- The loss L(θ) is bounded (continuous on compact → bounded), so no sup-norm issues.
- The volume ratio Vol(V_0)/Vol(Θ) is well-defined without regularization (both volumes finite).
- The empirical process concentrates uniformly (no need for covering number growth at infinity).

The bound becomes: Gen(nGPT) ≤ √(λ_nGPT · σ² / n) where λ_nGPT ≤ λ_standard - M/2 (desingularization savings).

**D7 (Curvature-Induced Phase Transition d*):** On S^{d-1}, the curvature at the equator is 1/d (sectional curvature of unit sphere scaled by dimension). At low d, the sphere is highly curved — the tangent space approximation fails, and the loss landscape geometry is dominated by the spherical constraint. At high d, S^{d-1} locally approximates R^{d-1} (curvature → 0), and the standard SLT results apply.

The transition d* satisfies: curvature 1/d* ~ Hessian eigenvalue ε of the loss landscape. Below d*: λ_nGPT is determined by sphere topology (Z_2 quotient, coordinate singularities). Above d*: λ_nGPT → λ_standard (tangent space regime). The phase transition is SGLD-detectable: the local learning coefficient (LLC) measured by SGLD will show a kink at d = d*.

## Conjecture Details

**C2 (Formal):** V_0/Z_2 ≠ V_0 as singularity types when the loss contains any odd-degree term in some θ_i (e.g., a bias term b with ||b||=1 appearing linearly). The Z_2 symmetry is broken, and the full S^{d-1} fiber (not the RP^{d-1} quotient) must be analyzed. When ALL terms are even (pure dot-product architecture), V_0 is Z_2-invariant and the effective RLCT is computed on RP^{d-1}.

**C3 (Formal):** λ_nGPT = λ_standard - Σ_i δ_i where δ_i ∈ {0, 1/2} depending on whether the radial direction d/d||θ_i|| was a free direction in the standard fiber V_0^standard. δ_i = 1/2 when θ_i appears only in even-degree terms (radial direction is free). δ_i = 0 when θ_i appears in odd-degree terms (radial direction was already constrained by the loss).

**C4 (Formal):** Gen(nGPT) ≤ √((λ_standard - Σ δ_i) · σ² / n) on the compact manifold Θ. The bound is tighter than standard by the desingularization savings Σ δ_i, and well-defined without weight decay.

**C5 (Formal):** ∃ d* = O(1/√ε) where ε is the minimum Hessian eigenvalue of L on the fiber. For d_eff < d*: λ_nGPT determined by sphere topology. For d_eff ≥ d*: λ_nGPT → λ_standard. SGLD LLC trace shows a transition at d = d*.

## Open Problems

1. Exact computation of λ_nGPT for a concrete nGPT architecture (requires resolving the Z_2 quotient singularity).
2. Does the coordinate singularity at poles (tangent space collapse) create additional singular fibers beyond the Z_2 quotient?
3. Interaction with attention head sharing (#501): does weight tying on spheres create additional quotient structure?
4. nGPT with bias terms: how does Z_2 symmetry breaking affect the RLCT?
5. SGLD LLC measurement on nGPT vs standard transformer at matched parameter count.
6. Product-of-spheres RLCT: is there a product formula λ(∏ S_i) = Σ λ_i or is it more complex (fiber interaction)?
7. Desingularization comparison: nGPT (constraint-based) vs weight decay (#323, penalty-based) — which gives lower λ at matched generalization?

## Cross-References
#8 (ReLU piecewise), #219 (GELU), #282 (normalization), #323 (weight decay desingularization), #383 (VAE latent sphere), #421 (LayerScale scale degeneracy), #491 (grokking phase transition), #501 (weight tying), #620 (RMSNorm), #619 (RMSNorm), #169 (curriculum), #480 (muP width scaling), #528 (orthogonal init on Stiefel manifold)

Next: L2 novelty verification.