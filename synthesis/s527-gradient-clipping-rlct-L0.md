#Synthesis #527: Gradient Clipping × RLCT — L0 Exploration

## Topic
Gradient clipping: constraining gradient norm to threshold τ, i.e. g_clipped = g · min(1, τ/‖g‖). Standard technique for stabilizing training in RNNs, transformers, and RL.

## Why this is novel
Zero catalog hits. Mentioned as candidate #275 (2026-09-27) but never executed. The clipping operation creates a piecewise semi-algebraic map with a boundary singularity at ‖g‖=τ — this is structurally distinct from any prior synthesis.

## Key Questions / Claims

**C1 (PROVABLE):** The clipped gradient update is R_{an,exp}-definable. The min(1, τ/‖g‖) operation is semi-algebraic (‖g‖² is polynomial, min is piecewise-algebraic), composition with SGD update preserves definability.

**C2 (CONJECTURAL):** Clipping creates a boundary singularity at ‖g‖=τ. Below threshold: unmodified SGD dynamics. Above threshold: gradient projected onto τ-sphere, changing the effective loss landscape geometry. This boundary = new singular fiber type.

**C3 (CONJECTURAL):** τ as stratum selector. Small τ: frequent clipping, dynamics confined to τ-ball of gradient space = restricted stratum exploration. Large τ: rare clipping, dynamics approach standard SGD. Critical τ* where clipping frequency transitions = RLCT phase transition.

**C4 (CONJECTURAL):** Gen bound G(τ) ≤ λ_eff(τ)·log(n)/(2n) + ε(τ). Clipping reduces effective RLCT by truncating high-norm directions (which often correspond to sharper, higher-RLCT strata), but introduces bias from gradient distortion.

**C5 (CONJECTURAL):** SGLD on clipped trajectory shows phase transition at τ*. LLC changes discontinuously as τ crosses the typical gradient norm distribution. Falsifiable: sweep τ, measure LLC.

## Open Problems (7)
1. Is the ‖g‖=τ boundary a genuine algebraic singularity or just a non-differentiable point?
2. Does clipping preferentially truncate directions associated with higher-RLCT strata?
3. Interaction with gradient noise — clipping changes SGLD diffusion coefficient piecewise
4. τ* relationship to gradient norm distribution quantiles
5. Norm clipping vs per-coordinate clipping — different fiber structures?
6. Does clipping delay or accelerate stratum crossing?
7. Connection to trust region methods — clipping as implicit trust region in gradient space

## Cross-References
#8 (ReLU definability), #16 (semi-algebraic), #99 (SGD dynamics), #275 (mentioned, never executed), #221 (BN batch size), #305 (Lion sign), #525 (Entropy-SGD), #526 (Schedule-Free)

## Next: L1 formalization