# Synthesis #860: LARS × RLCT — L1 Formal Definitions

## D1: Parameter Space
Layer-wise parameter space Θ = ∏_{l=1}^{L} Θ_l, where each Θ_l ⊂ R^{d_l} holds layer l weights w_l ∈ Θ_l.
Full parameter vector θ = (w_1, ..., w_L). The LARS optimizer acts independently per layer.

## D2: Per-Layer Loss Family
Training loss L(θ) = (1/n) Σ_i ℓ(f_θ(x_i), y_i) decomposes via chain rule into per-layer gradient contributions g_l = ∇_{w_l} L(θ).
Each layer has local loss landscape geometry characterized by ||g_l|| and ||w_l||.

## D3: R_{an,exp} Definability (C1 PROVEN)
LARS update: w_{t+1,l} = w_{t,l} - η · φ_l · g_l
where trust ratio φ_l = ||w_{t,l}|| / (||g_l|| + ε_w · ||w_{t,l}||), with ε_w = weight decay coefficient, η = base learning rate, trust coefficient τ scales: φ_l ← min(τ, φ_l).

- ||·|| is L2 norm: sqrt(Σ w_{l,j}^2), definable in R_an (subanalytic, polynomial + square root).
- Division (·)/(·) is analytic where denominator ≠ 0, i.e., where ||g_l|| + ε_w||w_l|| > 0.
- min(τ, ·) is piecewise-analytic (subanalytic).
- Composition of analytic + subanalytic maps preserves R_{an,exp} definability.
- Therefore the full update map U_l: (w_l, g_l) → w_{t+1,l} is R_{an,exp}-definable. □

## D4: Per-Layer Quotient Singular Fiber (C2 CONJECTURAL)
Define per-layer zero-loss fiber: V_l^0 = {w_l ∈ Θ_l : L(w_l) = 0 (local)}.
The LARS-modified fiber accounts for the trust ratio geometry:
V_l^{LARS} = {w_l : ∃ g_l, φ_l(w_l, g_l) · g_l = 0}, i.e., update vanishes when φ_l · g_l = 0.

Two singularity sources:
(a) Gradient vanishing: ||g_l|| → 0, making φ_l → ||w_l||/(ε_w||w_l||) = 1/ε_w (bounded but denominator → 0 if also ε_w → 0).
(b) Weight vanishing: ||w_l|| → 0, making φ_l → 0, freezing the layer.

The product fiber: V_LARS = ∏_{l=1}^{L} V_l^{LARS}
Each layer independently contributes a singular component. The total fiber is a product of per-layer strata, yielding codim(V_LARS) = Σ_l codim(V_l^{LARS}).

Key novelty: Unlike global optimizers (Adam #289, SGD #173), LARS creates a *product-space* fiber where each layer's singularity is independent. The RLCT of the product is additive: λ_LARS = Σ_l λ_l.

## D5: Trust Ratio as Layer-Wise Stratum Selector (C3 CONJECTURAL)
φ_l = ||w_l|| / (||g_l|| + ε_w||w_l||) acts as a continuous stratum selector per layer:
- When φ_l → 0 (||w_l|| ≪ ||g_l||): layer is in "small weight" stratum, updates suppressed.
- When φ_l → τ (||w_l|| ≫ ||g_l||): layer is in "large weight" stratum, trust ratio saturated at τ.
- Intermediate φ_l: smooth transition between strata.

The stratum lattice is ∏_l {stratum(φ_l)}, giving 2^L possible stratum configurations (each layer independently in small/large/intermediate regime).

This is distinct from #606 RMSProp (single diagonal EMA stratum), #289 Adam (global bias correction), #818 GradNorm (gradient magnitude rescaling without per-layer quotient).

## D6: Composite Generalization Bound (C4 CONJECTURAL)
Watanabe's bound: Gen ≤ λ_LARS / n + O(1/√n), where λ_LARS = Σ_l λ_l.

Each layer contributes independently to the RLCT. The per-layer trust ratio controls λ_l:
- Small φ_l (frozen layer): λ_l ≈ 0 (no learning, trivial fiber).
- Large φ_l (active layer): λ_l reflects local loss geometry.
- Critical φ_l*: phase transition where layer transitions from frozen to active.

Composite bound: Gen_LARS ≤ (1/n) Σ_l λ_l(φ_l) + O(L/√n)
The L per-layer terms create a tradeoff: more layers active → more capacity but higher RLCT sum.

## D7: Phase Transition at Critical Trust Ratio (C5 CONJECTURAL)
For each layer, there exists a critical trust ratio φ_l* such that:
- φ_l < φ_l*: layer frozen (λ_l ≈ 0, no generalization contribution).
- φ_l > φ_l*: layer active (λ_l > 0, contributes to generalization).

The global phase transition occurs when a critical mass of layers cross their φ_l* thresholds. This creates a depth-dependent cascade: layers activate sequentially as training progresses and φ_l evolves.

SGLD-testable prediction: monitoring per-layer φ_l during training should show sequential layer activation events, each detectable as a local RLCT jump in the loss trajectory.

## Open Problems
1. Exact codim(V_l^{LARS}) as function of d_l and gradient rank.
2. Independence assumption for product RLCT additivity — needs verification.
3. Interaction between layers via shared gradient (chain rule coupling).
4. φ_l* critical value — data-dependent or universal scaling with d_l?
5. Effect of momentum on stratum selector (LARS typically uses momentum).
6. Comparison with LAMB (#505 variant) which normalizes by both norms.
7. SGLD sampling protocol for per-layer λ_l estimation.

## Cross-References
#173 (SGD), #289 (Adam), #476 (Nesterov), #606 (RMSProp), #505 (Weight Norm), #818 (GradNorm), #433 (Weight Decay), #415 (Muon), #807 (Path Norm), #466 (RMSNorm), #221 (BatchNorm), #421 (Layer Scale), #484 (ReZero)
