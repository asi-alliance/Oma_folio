Botmer 2026-10-24 v.1. Synthesis #592: NovoGrad x RLCT L0

# Overview

Package: Ginacht Gupin/Michael Johnson/Shetty Naveen, 2019. NovoGrad normalizes gradient by its L2-norm per-layer (or per-parameter-group), then applies momentum. Update: v_t = beta.v_{t-1} + g_t/||g_t||_L, where ||g_t||_L = sqrt(sum_i g_{t,i}^2) over layer L's parameters.

Error results for #592: no prior SLT/RLCT bridge. Zero catalog hits. Distinct from #8 Adam (per-element diagonal preconditioner), #516 K-FAC (spectral operation on nonsingular Fisher stratum), #186 RMSProp (per-element second moment), #436 AdaBelief (belief discrepancy).

# C1 PROVEN: R_{an,exp} definability

The gradient norm ||g_t||_L = sqrt(sum_i g_{t,i}^2) is algebraic (polynomial + square root, definable in R_{an,exp}). The normalized gradient g_t/||g_t||_L is rational on the stratum where ||g_t||_L > 0 (open subset, definable outside the singular locus). Momentum composition preserves definability. All components are R_{an,exp}-definable. SQRT_ PASSED.

- Key distinction: Adam (#8) divides by per-element squared gradient (diagonal); NovoGrad divides by a single scalar per-layer norm. The norm function is a rank-L to rank-1 projection, preserving direction but destroying per-layer magnitude information.

# C2 CONJECTURAL: Per-layer gradient norm singular fiber

NovoGrad's update is undefined when ||g_t||_L = 0 for any layer L. This creates a singular stratum:

VEL = {theta : || nabla_theta L(theta)||_L = 0 for some layer L}

For Adam (#8), the squared gradient vanishes only when a single coordinate gradient is zero (codim 1). For NovoGrad, the null locus is codim = number of parameters in layer L (much higher codimension). This means NovoGrad frequently hits the singular locus during training (particularly for deep layers with large width), while Adam stays on the complement stratum much longer. The projection words by scale: Adam apies {theta : gradient _i = 0} for each i_layer in order; NovoGrad apies {theta : gradient _l = 0}. This creates a product structure of per-layer fibers, where each layer can drop out independently of others. The fiber of a singular point theta* is the intersection of all layers' deadling strata with the loss minimum fiber W-0, plus remaining strata for layers with nonzero gradient norm. This is a novel fiber type: per-layer nb-facted product fiber, where each layer's fiber is the decided fiber from Adam's per-element projection.

# C3 CONJECTURAL: Layer norm ratio as continuous stratum selector

Each layer L's effective learning rate is 1/||g_L||. When gradient norm is large for layer L, the update step is small (direction-only normalization). When gradient norm is small, the step is large (vector scaled up). This creates a continuous stratum selector: the vector of layer norms l(theta) = (||g_1||, ..., ||g_L||), which controls which layers are actively descended around the singular locus.

For Layer-norm ratio much smaller than average (e.g., ||g_L|| << avg_g||), layer L is effectively expanded (large step), probing deeper into the local singular structure of layer L. For much larger than average (e.g., ||g_L|| >> avg_g||), layer L is effectively frozen (small step), projecting onto the complement stratum of layer L. The ratio to average is a continuous stratum selector that controls which fibers are accessible.

- Distinct from #516 K-FAC: K-FAC's stratum selector is the spectrum of the Fisher matrix (continuous eigenvalue inversion). NovoGrad's is the scalar layer gradient norm (no second-order information). N-b.fibred product vs Kronecker-factored block diagonal.
- Distinct from #436 AdaBelief: AdaBelief selects by belief discrepancy (g_t - m_t)^2. NovoGrad selects by gradient magnitude ||g_t||. Belief is an in-strumental quantity (about previous observation); gradient norm is an out-of-stratum guide to the loss gradient.

# C4 CONJECTURAL: Generalization bound with layer-norm tension

G_{NovoGrad} ~ lambda_NovoGrad/n + U/sqrt(n)

lambda_NovoGrad may be smaller than lambda_SGD because the per-layer gradient norm acts as a desingularization map: it rescales each layer's contribution by a scalar (1/||g_L||), enforcing uniform scales across layers. This desingularization reduces the multiplicity of the singular fiber structure. The tension comes from the tradeoff: per-layer normalization controls fine-grain scaling but may preempt the right components if the loss gradient's direction aligns not with the optimal singular direction on a fibers that are not spherically symmetric. A fibers that results from interaction between layers may be projected out by the scalar gradient norm, acting as an approximate generic action. This desingularization-compromise tradeoff is the gen-bound tension U.

- If layer norms are roughly uniform, normalization is nearly identity (ratio ~ 1), desingularization is trivial, and lambda_NovoGrad ~ lambda_SGD.
- If layer norms are highly variable (some layers gradient dominates others), normalization overcorrects the scale, projecting onto a different fiber and raising lambda_NovoGrad above lambda_SGD. Under normalized steps, lambda_NovoGrad depends on the geometry of the projection from layer norm space to fiber space.

# C5 CONJECTURAL: Critical layer norm ratio phase transition

The structure creates a phase transition at a critical layer norm ratio r* that describes when a layer transitions from active to f
rozen in the SGLD sense — its contribution to the singular fiber structure freezes out. For layer L with ||g_L|| = avg_g|| * r*, the layer becomes 'frozen' and no longer contributes to desingularization. Below r*, the layer is 'active' and explores its local singular fiber.

The phase transition is SGLD-detectable: at r*, the loss trajectory should show a kink in the RLCT estimate as measured by SGLD dynamics, analogous to #100 SGD phase transitions. The critical r* depends on the architecture: deeper/wider networks with more layer norm heterogeneity will have lower r* (more layers freeze out earlier), while shallow networks with uniform layer norms will have r* close to 1 (near-identity normalization).

# Open Problems

1. Formalize the per-layer norm singular fiber V_L as an intersection variety. Is it irreducible?
2. Prove or disprove: lambda_NovoGrad <= lambda_SGD when layer norms are uniform (desingularization is trivial).
3. Characterize the desingularization map phi: (g_1, ..., g_L) -> (g_1/||g_1||, ..., g_L/||g_L||) — is it a definable morphism in the sense of SLT?
4. Derive the tension term U in the gen bound from the projection geometry.
5. SGLD testable prediction: does the loss trajectory show a kink at r*?
6. Connection to #516 K-FAC: is NovoGrad a rank-1 approximation of K-FAC's per-layer Fisher norm?
7. Does weight decay interact with NovoGrad's normalization in a way that changes the singular fiber structure (cf. #282)?

# Cross-Refs

#8 Adam (per-element diagonal), #100 SGD baseline, #186 RMSProp (per-element second moment), #282 Weight Decay, #304 Adam L0-L4 complete, #436 AdaBelief (belief discrepancy), #516 K-FAC/preconditioned optimizers (Fisher spectrum), #298 Orthogonal Init, #484 ReZero (scalar normalization), #515 VAE, #559 Gradient Penalty (input-gradient norm), #173 SAM, #420 Layer Scale.
