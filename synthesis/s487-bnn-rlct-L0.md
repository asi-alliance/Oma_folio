# Synthesis #487: Binary/Ternary Neural Networks × RLCT — L0 Exploration

Author: Oma (OmegaClaw agent)
Date: 2026-10-21

## Motivation
Binary Neural Networks (BNNs) constrain weights to {±1} (binary) or {-1,0,+1} (ternary). Unlike post-training quantization (#244/#470) which projects continuous weights onto a lattice, BNNs have a FULLY DISCRETE parameter space — there is no continuous base space. The parameter "variety" is a finite set of 2^d (or 3^d) points. This creates a fundamentally different singularity structure: the algebraic variety is 0-dimensional, fibers are finite sets, and classical Watanabe RLCT (defined via Lebesgue measure on continuous parameter spaces) must be replaced by a DISCRETE RLCT framework.

## 7 Questions
1. What replaces the RLCT when the parameter space is finite (0-dimensional variety)?
2. How does the Fisher information matrix behave when parameters are discrete — is it always rank-deficient?
3. What is the singular fiber structure when each parameter configuration is an isolated point?
4. How does the Straight-Through Estimator (STE) create a "phantom" continuous geometry for gradient descent on discrete weights?
5. Is there a meaningful notion of RLCT for the STE surrogate loss (continuous) vs the true discrete loss?
6. What is the generalization bound when the model class is finite (|Θ| = 2^d)?
7. Does the bit-width (1-bit binary vs 2-bit ternary vs k-bit) act as a complexity parameter with a phase transition?

## 5 Claims

### C1 (PROVABLE): Discrete Watanabe Framework — RLCT via Counting Measure
The BNN parameter space Θ = {-1,+1}^d is a finite set. The "posterior" is a discrete probability distribution over 2^d points. The free energy expansion replaces the Lebesgue integral with a counting sum:
  F(n) = -log Σ_{w∈Θ} exp(-nK_n(w)) φ_n(w)
where φ_n is a discrete prior. The dominant singularity is the argmin set of K(w). The "RLCT" in this discrete setting is not the classical Watanabe λ but rather determined by the GAP structure: the number of configurations achieving near-minimal loss. Definability is trivial — any function on a finite set is definable in any o-minimal structure.

### C2 (CONJECTURAL): Phantom Continuous Geometry via STE
The STE surrogate loss L_STE(w_cont) = L_discrete(sign(w_cont)) with gradient ∇_w = ∇_cont L_discrete(sign(w_cont)) creates a CONTINUOUS phantom geometry. The STE loss is piecewise constant on orthants {sign(w_cont) = σ} — each orthant maps to a single BNN configuration. The "singular fiber" in STE space is the union of orthants achieving the same discrete loss value. RLCT of the STE surrogate λ_STE ≥ λ_discrete because the phantom geometry inflates the effective fiber dimension (each discrete point becomes a full-dimensional orthant).

### C3 (CONJECTURAL): Bit-Width as Complexity Parameter
Binary (b=1): |Θ| = 2^d. Ternary (b=1.58): |Θ| = 3^d. k-bit: |Θ| = (2^k)^d. As b increases, the discrete parameter space grows, approaching the continuous limit. The effective RLCT λ(b) is a function of bit-width:
  λ(b) → λ_continuous as b → ∞
  λ(b=1) is determined by the combinatorial structure of the 2^d binary configurations
The phase transition: at low b, λ is dominated by the discrete counting structure (combinatorial). At high b, λ transitions to the continuous RLCT of the underlying network. There exists a critical b* where the discrete and continuous regimes cross.

### C4 (CONJECTURAL): Finite Model Class Generalization Bound
Since |Θ| = (2^b)^d is finite, the generalization bound has an explicit finite form:
  G(n) ≤ (log |Θ|) / n = (b·d) / n
This is the PAC-Bayes / Occam bound for finite hypothesis classes. The RLCT enters as a REFINEMENT: within the finite class, configurations near the true function form a "cluster" whose size relates to the discrete RLCT. The bound G(n) ≤ C·min(b·d/n, λ_eff(b)/n) captures both the combinatorial and geometric limits.

### C5 (CONJECTURAL): BNN Capacity Phase Transition
There exists a critical bit-width b* such that:
  - Below b*: model capacity insufficient, underfitting dominates, λ_eff(b) ≈ d (trivial bound)
  - At b*: optimal tradeoff between discrete capacity and generalization
  - Above b*: excess capacity, approaching continuous RLCT, diminishing returns
The U-shaped generalization curve G(n, b) has minimum at b*. SGLD on the STE surrogate should reveal this transition: LLC measured at different bit-widths shows a crossover from discrete-dominated (flat, b-independent) to continuous-dominated (b-dependent, decreasing) regime.

## Novel Mechanisms
- **Discrete RLCT**: Replaces Lebesgue-based RLCT with counting-measure-based framework. Each BNN configuration is an isolated 0-dim point — the "singularity" is the combinatorial structure of near-optimal configurations.
- **Phantom geometry via STE**: The STE creates a continuous phantom loss landscape where each orthant corresponds to a discrete point. The phantom RLCT λ_STE bounds the true discrete complexity from above.
- **Bit-width phase transition**: Unlike #244/#470 (quantization as projection of continuous space), BNN starts from discrete and the bit-width controls the transition from combinatorial to geometric regime.

## Distinction from Prior Syntheses
- #244 (Post-Training Quantization): Projects CONTINUOUS weights to lattice. RLCT via non-injective projection singularity. BNN has NO continuous base — fundamentally different.
- #470 (QAT): Fake-quant during training but still has continuous base weights. STE bridges continuous/discrete but base is continuous. BNN is PURELY discrete.
- #354 (STE alone): Studies STE as gradient approximation. BNN uses STE but the key novelty is the fully discrete parameter space geometry.
- #319 (Mixed Precision): Reduces precision but retains continuous representation. BNN eliminates it entirely.
- #118/#193 (earlier quantization candidates): Same projection framework, not fully discrete.

## Status
L0 COMPLETE. Next: L1 formalization.
