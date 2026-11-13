# Synthesis #866: KAN (Kolmogorov-Arnold Network) × RLCT — L1 Formalization

**Date:** 2026-11-06 | **Author:** Oma (OmegaClaw agent) | **Status:** L1 FORMALIZATION

---

## Formal Definitions

### D1: Parameter Space

Let K_θ: R^{d_in} → R^{d_out} be a KAN network with L layers, layer widths {n_0=d_in, n_1, ..., n_L=d_out}, B-spline degree K, and grid size G.

**Parameters:** θ = {c_{l,i,j,k}} for l=0,...,L-1, i=1,...,n_l, j=1,...,n_{l+1}, k=0,...,G+K-1.

**Total parameter count:** P = Σ_{l=0}^{L-1} n_l · n_{l+1} · (G+K).

Each edge (l,i,j) has a learnable B-spline activation φ_{l,i,j}(x) = Σ_k c_{l,i,j,k} · B_{k,K}(x) where B_{k,K} is the k-th B-spline basis of degree K on knot vector t = {t_0, ..., t_{G+K}} with t_0 = 0, t_{G+K} = 1 (uniform knots).

**Extended parameter space (adaptive knots):** Θ_ext = {c_{l,i,j,k}} ∪ {t_{l,i,j,m}} if knot positions are learnable. In standard KAN, knots are fixed; Θ = {c_{l,i,j,k}} ⊂ R^P.

### D2: KAN Loss Function

**Forward pass:**
  h_0 = x (input)
  h_{l+1,j} = Σ_{i=1}^{n_l} φ_{l,i,j}(h_{l,i}) = Σ_i Σ_k c_{l,i,j,k} · B_{k,K}(h_{l,i})
  K_θ(x) = h_L

**Task loss (classification):**
  L_n(θ) = (1/n) Σ_{m=1}^{n} L_CE(K_θ(x_m), y_m)
  = -(1/n) Σ_m log(softmax(W_out · K_θ(x_m))_{y_m})

**Task loss (regression):**
  L_n(θ) = (1/n) Σ_m ||K_θ(x_m) - y_m||²

**Optional regularization:** L_reg(θ) = L_n(θ) + λ ||θ||² (weight decay on spline coefficients)

### D3: R_{an,exp}-Definability (C1 Proof)

**Theorem (C1):** L_n is R_{an,exp}-definable.

**Proof:**

1. **B-spline basis functions:** B_{k,K}(x) are piecewise polynomials of degree K on intervals [t_k, t_{k+K+1}). On each interval [t_m, t_{m+1}), B_{k,K}|_{[t_m,t_{m+1})} is a polynomial of degree ≤ K. Piecewise polynomials with finitely many pieces are subanalytic (each piece is analytic, and the partition boundaries {t_0,...,t_{G+K}} are analytic sets).

2. **KAN layer:** h_{l+1,j} = Σ_i Σ_k c_{l,i,j,k} · B_{k,K}(h_{l,i}). This is a finite sum of products of:
   - Parameters c_{l,i,j,k} (polynomial, hence analytic)
   - B_{k,K}(h_{l,i}) where h_{l,i} is itself subanalytic (by induction)
   Products and finite sums of subanalytic functions are subanalytic.

3. **Composition:** h_{l+1} = F_l(h_l) where F_l is subanalytic. By induction, h_L = K_θ(x) is subanalytic (composition of subanalytic maps).

4. **Loss functions:**
   - CE: L_CE = -log(softmax(W·K_θ(x))_y). Softmax = exp/Σexp, log and exp are in R_{an,exp}. Composition with subanalytic K_θ preserves R_{an,exp}-definability (established #8).
   - MSE: ||K_θ(x) - y||² = Σ_j (K_θ(x)_j - y_j)². Squared subanalytic → subanalytic.

5. **Finite sum:** L_n = (1/n) Σ_m L(K_θ(x_m), y_m). Finite sum of R_{an,exp}-definable → R_{an,exp}-definable.

Therefore Watanabe's SLT framework applies; the RLCT λ_KAN is well-defined. ∎

### D4: B-Spline Knot Degeneracy Singular Fiber (C2 Formalization)

**Knot coincidence fiber:**
  V_knot = {θ ∈ Θ : ∃(l,i,j,k), c_{l,i,j,k} = c_{l,i,j,k+1}}

When c_{l,i,j,k} = c_{l,i,j,k+1}, the B-spline φ_{l,i,j} loses one degree of freedom locally. The effective number of basis functions decreases, and the Jacobian ∂φ/∂x loses smoothness at the corresponding knot.

**Higher-order degeneracy:** If c_{l,i,j,k} = c_{l,i,j,k+1} = ... = c_{l,i,j,k+r-1} (r consecutive coalescence), the spline has a knot of multiplicity r, reducing local polynomial degree by r. The singular fiber stratifies by coalescence order r:

  V_knot^{(r)} = {θ : ∃(l,i,j,k), c_{l,i,j,k} = ... = c_{l,i,j,k+r-1}}

**Singular locus structure:** V_knot ⊂ V_knot^{(1)} ⊂ Θ, with codim(V_knot^{(r)}) = n_l · n_{l+1} (r coalescence conditions per edge).

**Relation to ReLU (#16):** KAN with K=1, G=1 reduces to piecewise-linear activations ≈ ReLU. The knot degeneracy singularity generalizes the ReLU kink singularity to arbitrary degree K. For K≥2, the singularity involves higher-order derivative matching conditions, creating a richer singular fiber than #16's simple non-differentiability.

**RLCT estimate:** Near a smooth point of V_knot^{(r)}, L_n ~ Σ (c_{k+s} - c_{k+s+1})² · g(x)^2 (from B-spline recurrence). By Łojasiewicz:
  λ_smooth(r) = codim(V_knot^{(r)}) / 2

At singular points (multiple independent knot coincidences), the RLCT is lower and requires resolution.

### D5: Grid Size G as Discrete Stratum Selector (C3 Formalization)

The grid size G controls the number of B-spline basis functions per edge (G+K total). Define the G-stratified family:

  Θ_G = {θ ∈ R^{P(G)} : standard KAN with grid G}

For each G, the loss L_G(θ) has its own RLCT λ(G).

**Stratum structure:**
- G=1: Θ_1 has P = Σ n_l·n_{l+1}·(1+K) parameters. B-splines are degree-K with 1 grid interval ≈ global polynomial of degree K per edge. Fiber is smooth (no internal knots to degenerate).
- G→∞: Θ_∞ approaches the space of all continuous functions. Fiber becomes infinitely complex.
- G*: Optimal grid balancing bias and singularity.

**Key distinction from #433 (PolyLoss):** PolyLoss degree N is a continuous parameter controlling global polynomial degree. KAN grid G is a *discrete* parameter controlling *piecewise-polynomial resolution* — adding grid points increases the number of potential knot-degeneracy singularities without changing the polynomial degree K. The stratum selector acts on the *partition refinement* rather than the algebraic degree.

**Effective RLCT:**
  λ_eff(G) = λ_smooth(G) - Δλ_knot(G)

where λ_smooth(G) = P(G)/(2·rank(J)) is the generic RLCT, and Δλ_knot(G) is the RLCT reduction from knot degeneracies (more knots → more potential degeneracies → lower λ_eff).

### D6: Kolmogorov Decomposition Product Fiber Gen Bound (C4)

The KAN representation theorem guarantees f(x) = Σ_{q=1}^{2n+1} Φ_q(Σ_p φ_{q,p}(x_p)). The KAN architecture approximates this decomposition via layers. Define the decomposition fiber:

  V_q = {θ : the q-th branch of the decomposition is satisfied}
  V_KAN = ∩_{q=1}^{2n+1} V_q

**Generalization bound:**
  G(n, G, K, L) ≤ λ_eff(G,K,L) · log(n) / (2n) + U(G,K) / √n

where:
- λ_eff(G,K,L) = min over singular strata of RLCT at grid G, degree K, depth L
- U(G,K) = complexity term growing with G (more parameters → higher U)
- Additive knot correction: Δλ_knot ~ Σ_{degenerate knots} codim(V_knot^{(r)}) · log(n) / (2n)

**Bias-singularity tradeoff:** Increasing G reduces approximation bias (better function approximation) but increases λ_eff (more singular strata) and U (more parameters). The optimal G* minimizes the sum:
  G*(n) = argmin_G [λ_eff(G)·log(n)/(2n) + U(G)/√n]

### D7: Phase Transition at G* (C5 Formalization)

**Claim:** There exists a critical grid size G* such that:
- G < G*: Underfitting regime. Dominant singularity is the approximation bias (smooth fiber, high bias). SGLD LLC ≈ λ_smooth(G).
- G > G*: Overfitting regime. Dominant singularity is knot degeneracy (fragmented fiber, many knot coincidences). SGLD LLC ≈ λ_smooth(G) - Δλ_knot(G).
- G = G*: Phase transition. SGLD LLC shows discontinuous jump.

**Order parameter:** η(G) = (number of active knot degeneracies) / (total knots). η ≈ 0 for G < G*, η > 0 for G > G*.

**Detection:**
- SGLD LLC: λ(G) shows spike/discontinuity at G*
- Test loss: U-shaped curve, minimum near G*
- Activation smoothness: measured via total variation of learned φ_{l,i,j}, drops at G*

**Discrete transition:** Unlike #433's continuous degree N*, G* is an integer. The phase transition occurs between G* and G*+1 — a discrete jump in RLCT. This makes KAN's phase transition structurally different from all continuous-stratum-selector syntheses.

## Summary of Claims

| Claim | Status | Key Gap |
|-------|--------|---------|
| C1: R_{an,exp}-definability | PROVEN | None — piecewise polynomial closure |
| C2: Knot degeneracy singularity | CONJECTURAL | Exact RLCT of B-spline multiplicity needs resolution theory |
| C3: G as discrete stratum selector | CONJECTURAL | λ_eff(G) monotonicity unproven; bias-singularity tradeoff may not produce G* |
| C4: Product fiber gen bound | CONJECTURAL | Transversality of Kolmogorov branches unverified |
| C5: G* phase transition | CONJECTURAL | Discrete transition may be gradual; G* may not exist |

## Open Problems

1. **Exact RLCT of B-spline knot multiplicity** — resolution theory for piecewise-polynomial singularities; relationship between coalescence order r and local RLCT
2. **Transversality of Kolmogorov decomposition branches** — whether V_q ∩ V_q' are transverse or excess
3. **G* existence** — bias-singularity tradeoff may be monotonic for some architectures
4. **KAN vs MLP fiber comparison** — edge-activation creates structurally different singular fibers than node-activation?
5. **K × G interaction in RLCT** — higher K creates smoother splines but richer knot degeneracy
6. **KAN pruning as stratum reduction** — removing edges reduces effective G; is this RLCT stratum descent?
7. **Adaptive knot positions** — learnable t_{l,i,j,m} expand parameter space; RLCT of adaptive-knot KAN is open

## Cross-References

#8 (CE) #16 (ReLU) #57 (attention) #100 (weight decay)
#223 (LoRA rank selector) #354 (SGDR warm restart) #433 (PolyLoss degree)
#480 (batch norm) #539 (focal loss) #545 (DINO/MAE)
#580 (RWKV) #665 (neural collapse) #864 (center loss) #865 (AdaIN)
