#616 | Gradient Clipping × RLCT | L0: Claims

## Technique
Gradient clipping constrains ||∇L(θ)|| to radius τ via:
- Norm clipping: g' = min(1, τ/||g||) · g
- Value clipping: g' = clip(g_i, -τ, τ) elementwise
- Global norm: g' = min(1, τ/||g||_global) · g

## C1: R_{an,exp}-definability
Norm clipping: ||g||² = Σ g_i² is polynomial (semi-algebraic). min(1, τ/||g||) involves rational function + piecewise = semi-algebraic. Scalar multiplication preserves. g is polynomial in θ (for polynomial activations) or analytic (for tanh/sigmoid). Composition: analytic ∘ semi-algebraic = R_{an,exp}-definable. QED.

Value clipping: clip(x,-τ,τ) = min(max(x,-τ),τ) is semi-algebraic. Same closure argument. QED.

## C2: λ(τ) stratum selector
Clipping threshold τ controls which singular strata are reachable:
- τ → ∞: no clipping, full SGD trajectory, λ → λ_SGD (accesses all strata)
- τ → 0: only vanishing updates, trajectory frozen near init, λ → λ_init (trapped in init stratum)
- τ* critical: phase transition where clipping binds during stratum descent

Key claim: λ_clip(τ) is monotone non-decreasing in τ. Small τ restricts to local stratum (low traversal). Large τ allows full stratum exploration.

## C3: Generalization bound
Clipped SGD modifies update direction on singular fibers. Gen bound:
λ_clip(τ*)·log(n)/(2n) + B(τ)/√n
where B(τ) is clipping bias — discrepancy between clipped and unclipped gradient direction on the singular fiber. B(τ) → 0 as τ → ∞, B(τ) → ||g|| as τ → 0.

Optimal τ* minimizes λ(τ)·log(n)/(2n) + B(τ)/√n — tension between stratum access (large τ) and update fidelity (large τ).

## C4: Phase transition at τ*
SGLD detectable: LLC trace shows kink at τ* where clipping transitions from never-binding to periodically-binding. Below τ*: LLC constant (trapped in init stratum). Above τ*: LLC decreases (stratum descent enabled). At τ*: cusp in LLC trajectory.

## C5: Falsifiable predictions
1. LLC(τ) monotone non-decreasing in τ (testable via SGLD)
2. Phase transition at τ* detectable as LLC kink
3. Generalization optimal at intermediate τ* (not 0, not ∞)
4. Value clipping (elementwise) vs norm clipping (global) have different stratum geometries: value clipping permits per-coordinate stratum selectivity, norm clipping is isotropic