#877: SkipInit × RLCT — L0 Outline

## Topic
SkipInit (De & Smith, 2020): a single learnable scalar γ per residual block, initialized to zero, applied at the end of each residual branch. Used in NFNet (Normalizer-Free Networks, Brock et al. 2021) alongside Scaled Weight Standardization (SWS) and Adaptive Gradient Clipping (AGC). Replaces BatchNorm entirely.

## Key Properties
- Scalar (not vector) gamma, initialized to exactly 0
- Applied to residual branch output: y = x + γ·f(x)
- At init: γ=0 → output = x (identity map), all residual blocks contribute nothing
- Learnable: γ adapts during training, smoothly activating residual contribution
- Paired with SWS (weights normalized per output channel, scaled by gain)
- No normalization layers whatsoever

## RLCT Bridge

### C1 (PROVEN): R_{an,exp} definability
γ·f(x) is bilinear in γ and f(x). f(x) composed of SWS-scaled convolutions (rational weight scaling) + ReLU (subanalytic). γ is a scalar parameter. Bilinear composition of definable functions is definable in R_{an,exp}. Softmax/cross-entropy adds exp term. C1 HOLDS.

### C2 (CONJECTURAL): γ=0 singular stratum
At γ=0, the residual block output is exactly x regardless of f(x) parameters. This creates a degenerate fiber: all parameter configurations in the residual branch map to the same identity function. The KL divergence is constant on this fiber (the Fisher information vanishes in γ-direction). The singular set contains {γ=0} × {all weights in residual branch} — a high-codimension stratum where the model is locally unidentifiable in the residual branch parameters. The RLCT at this stratum reflects the multiplicity from the collapsed fiber.

Key distinction from #484 ReZero: SkipInit operates WITHIN SWS-constrained parameter space. SWS normalizes conv weights to zero-mean unit-variance per output channel, constraining parameters to a sphere S^{d-1}. The γ=0 fiber lives on this spherical constraint manifold, not in flat R^n. This changes the geometry of the singular set: the spherical constraint adds codimension, and the γ=0 fiber intersects the SWS constraint non-trivially. The RLCT on a sphere differs from RLCT in flat space (cf. #531 NFNet C5: SUW spherical constraint codimension correction).

### C3 (CONJECTURAL): γ as continuous stratum selector
γ ∈ R acts as a one-dimensional stratum selector. At γ=0: maximal singularity (identity fiber, full non-identifiability in residual branch). As γ → γ*: desingularization trajectory from identity to full complexity. The effective RLCT λ_eff(γ) is expected to be monotonically non-decreasing in |γ|, with a kink or phase transition at critical γ* where the residual branch contribution transitions from negligible to dominant.

Distinction from #421 LayerScale: SkipInit uses SCALAR γ (1D stratum selector), LayerScale uses VECTOR γ (d-dimensional per-feature selector). SkipInit has simpler 2-state lattice {γ=0, γ≠0} vs LayerScale's 2^d lattice. But SkipInit's SWS pairing means the singular geometry is richer despite the simpler selector.

Distinction from #424 Fixup: Fixup uses FIXED depth-dependent scaling (no learnable parameter, no stratum selector). SkipInit is LEARNABLE, creating an actual singular fiber and desingularization trajectory. Fixup has no γ=0 fiber (its scaling is nonzero by construction).

### C4 (CONJECTURAL): Generalization bound
The gen gap bound: ΔG = λ_eff(γ_final)·log(n)/(2n) + U(γ,SWS)/sqrt(n), where λ_eff(γ_final) is the RLCT at the trained γ value, and U accounts for the SWS constraint geometry and the desingularization trajectory from γ=0.

The γ=0 initialization advantage: starting at maximal singularity means the initial training phase has maximal compression (lowest effective dimension). The desingularization trajectory gradually increases λ_eff only as the data supports it, providing implicit regularization through the singular geometry. This mirrors ReZero's advantage but enhanced by SWS's spherical constraint which additionally regularizes the weight space.

### C5 (CONJECTURAL): Critical γ* phase transition
At γ* > 0, the model transitions from "identity-dominated" (γ small, KL ~0 for residual params) to "residual-dominated" regime. Predicted: SGLD sampling at γ near γ* shows a kink in local energy variance, indicating the phase transition. The SWS constraint shifts γ* relative to ReZero (no SWS): the spherical weight constraint changes the effective loss landscape curvature, potentially lowering γ* (earlier activation of residual branch) because SWS already stabilizes signal propagation, requiring less γ to escape the identity fiber.

## Open Problems
1. Exact RLCT of γ=0 fiber on SWS-spherical manifold vs flat space (cf. #531 C5)
2. Whether γ* (SkipInit) < γ* (ReZero) due to SWS stabilization
3. Interaction between AGC clipping boundary and γ desingularization trajectory
4. Whether the scalar γ (vs LayerScale vector) creates simpler or more complex singular topology
5. MeTTa encoding of SWS + γ fiber intersection
6. Empirical SGLD testable prediction: energy variance kink at γ*
7. Comparison of desingularization trajectories: SkipInit (SWS) vs ReZero (no SWS) vs LayerScale (per-feature)

## Cross-References
#484 ReZero (scalar α=0, no SWS), #421 LayerScale (vector γ, nonzero init), #424 Fixup (fixed scaling, no learnable γ), #531 NFNet (SWS + AGC + SkipInit context), #234 BatchNorm, #169 Dropout, #199 Skip Connections, #296 Stochastic Depth, #363 AdaLN, #99 SGD, #213 LR Scheduling, #506 Hypernetworks

## Status
L0 DRAFT. C1 proven. C2-C5 conjectural. Next: L1 formalization.