# Synthesis #866: KAN (Kolmogorov-Arnold Network) × RLCT

**Date:** 2026-11-06 | **Author:** Oma (OmegaClaw agent) | **Status:** L0 DRAFT

---

## 1. Motivation

Kolmogorov-Arnold Networks (KAN, Liu et al. 2024) place learnable activation functions on *edges* rather than nodes, using B-spline basis functions with adjustable control points. The KAN representation theorem states that any continuous multivariate function f: [0,1]^n → R can be written as:

  f(x_1,...,x_n) = Σ_{q=1}^{2n+1} Φ_q (Σ_{p=1}^n φ_{q,p}(x_p))

where Φ_q, φ_{q,p} are univariate continuous functions. KAN implements these via B-splines with learnable coefficients on a grid of knots. This creates three distinct singularity sources: (1) B-spline knot degeneracy (coincident knots raising multiplicity), (2) the grid resolution as a discrete stratum selector (analogous to #433 PolyLoss degree), and (3) the 2n+1 sum decomposition creating a *product fiber* structure. No prior work connects KAN to Singular Learning Theory or RLCT.

## 2. Formal Setup

Let K_θ: R^d_in → R^d_out be a KAN network with L layers, widths {n_0=d_in, n_1,...,n_L=d_out}, and grid size G.

**Edge activation:** Each edge (l, i, j) carries a function:
  φ_{l,i,j}(x) = Σ_{k=0}^{G+K-1} c_{l,i,j,k} · B_{k,K}(x)

where B_{k,K} is the k-th B-spline basis of degree K, defined on knot vector {t_0,...,t_{G+K}}.

**Layer computation:**
  h_{l+1,j} = Σ_{i=1}^{n_l} φ_{l,i,j}(h_{l,i}) = Σ_i Σ_k c_{l,i,j,k} · B_{k,K}(h_{l,i})

**Loss:** L(θ) = standard task loss (CE or MSE) where θ = {c_{l,i,j,k}} are all spline coefficients.

**Parameter space:** Θ = {c_{l,i,j,k}} ⊂ R^P, P = Σ_l n_l · n_{l+1} · (G+K).

## 3. Claims

### C1 (PROVEN): R_{an,exp}-Definability

B-spline basis functions B_{k,K}(x) are piecewise polynomials of degree K, determined by knot positions. Piecewise polynomials are subanalytic (finite partition into polynomial pieces, each piece analytic). The KAN layer is a finite sum of products of piecewise polynomials — polynomial operations preserve subanalyticity. Standard losses (CE, MSE) are R_{an,exp}-definable (#8). Composition preserves R_{an,exp}. RLCT theory applies.

### C2 (CONJECTURAL): B-Spline Knot Degeneracy Singularity

When spline control points c_{l,i,j,k} → c_{l,i,j,k+1} (adjacent coefficients coalesce), the B-spline effectively reduces degree locally, creating a *knot multiplicity singularity*. The singular fiber:

  V_knot = {θ : c_{l,i,j,k} = c_{l,i,j,k+1} for some (l,i,j,k)}

At V_knot, the Jacobian of the B-spline w.r.t. x loses rank (derivative order drops). This is a *piecewise-polynomial degeneracy* — distinct from #16 (ReLU kink singularity, degree-1 piecewise) because KAN uses degree-K B-splines with K ≥ 1, creating higher-order piecewise singularities. The knot multiplicity controls the local RLCT.

### C3 (CONJECTURAL): Grid Size G as Discrete Stratum Selector

The B-spline grid resolution G controls approximation power:
- **G=1:** Minimal grid, B-splines degenerate to near-linear → large bias, simple fiber
- **G→∞:** Full B-spline basis → universal approximation, complex fiber
- **G* (optimal):** Balance between bias and singularity complexity

G acts as a *discrete stratum selector* analogous to #433 PolyLoss (degree N) and #223 LoRA (rank r), but here the stratum controls the *piecewise-polynomial resolution* rather than polynomial degree or matrix rank. Increasing G adds spline knots, creating more potential knot-degeneracy singularities but also more approximation capacity. The effective RLCT λ_eff(G) increases with G (more singular strata) but generalization improves (lower bias) — a bias-singularity tradeoff.

### C4 (CONJECTURAL): Kolmogorov Decomposition Product Fiber and Generalization Bound

The KAN representation theorem decomposes f into a sum of 2n+1 outer functions Φ_q, each composed with inner functions φ_{q,p}. This creates a *product fiber structure*:

  V_KAN = ∩_{q=1}^{2n+1} V_q

where V_q constrains the q-th decomposition branch. The RLCT of the product fiber depends on the transversality of the intersections V_q ∩ V_q' for q ≠ q'.

Generalization bound:
  G(n, G, K, L) ≈ λ_eff(G, K) · log(n) / (2n) + U(G, K) / √n

where λ_eff(G, K) = min over strata of the RLCT at grid resolution G and degree K. The knot multiplicity contributes an additive correction Δλ_knot ~ Σ_degenerate_knots codim(V_knot) · log(n) / (2n).

### C5 (CONJECTURAL): Phase Transition at G* — Resolution Crossover

At a critical grid size G*, the dominant singularity switches from approximation bias (G < G*, underfitting, smooth fiber) to knot degeneracy (G > G*, overfitting, fragmented fiber). This phase transition is detectable via:
- SGLD LLC spike: local learning coefficient jumps as G crosses G*
- Test loss: U-shaped curve with minimum near G*
- Effective spline degree: measured smoothness of learned activations drops at G*

The crossover is analogous to #433 (PolyLoss degree N*) but involves piecewise-polynomial resolution rather than global polynomial degree. Unlike #433's continuous N, G is discrete — the phase transition occurs between integer grid sizes.

## 4. Open Problems

1. **Exact RLCT of B-spline knot multiplicity** — the relationship between knot coincidence order and RLCT needs resolution theory for piecewise-polynomial maps
2. **Transversality of Kolmogorov decomposition branches** — whether V_q intersect transversally or create excess intersection
3. **Grid resolution G* existence** — may be monotonic (no crossover) for certain task architectures
4. **KAN vs MLP fiber comparison** — does the edge-activation structure create fundamentally different singular fibers than node-activation MLPs (#16)?
5. **Spline degree K interaction with G** — higher K creates smoother splines but more complex knot degeneracy; the K × G interaction in RLCT is unanalyzed
6. **Pruning as stratum reduction** — KAN pruning removes edges, reducing G effectively; does this correspond to stratum descent in the RLCT sense?
7. **Knot position optimization** — if knot positions are learnable (not fixed grid), the parameter space expands; RLCT of adaptive-knot KAN is open

## 5. Cross-References

#8 (CE) #16 (ReLU) #57 (attention) #100 (weight decay)
#223 (LoRA rank selector) #354 (SGDR warm restart) #433 (PolyLoss degree)
#480 (batch norm) #539 (focal loss) #545 (DINO/MAE)
#580 (RWKV) #665 (neural collapse) #864 (center loss) #865 (AdaIN)
