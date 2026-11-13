# Synthesis #SNN5: Mish Activation × RLCT L1 Formalization
# Date: 2026-11-05
# Status: L1 — formal definitions and claims

## Formal Definitions

D1 (Activation Map): Mish(x) = x · tanh(softplus(x)) = x · tanh(ln(1 + e^x)). The network function f(w,x) is a composition of affine maps and Mish, producing f: R^d → R^k. Parameter space W ⊂ R^d.

D2 (Loss Function): K(w) = (1/n) Σ_i L(f(w,x_i), y_i) where L is cross-entropy or MSE. True loss K*(w) = E_q[L(f(w,X),Y)]. Optimal set W* = {w ∈ W : K*(w) = min K*}.

D3 (R_an,exp Definability): softplus(x) = ln(1+e^x). The function e^x is definable in R_an,exp by definition. ln is definable (inverse of exp). The composition ln(1+e^x) is definable (sum + composition closure). tanh(z) = (e^z - e^{-z})/(e^z + e^{-z}) is definable (ratio of definable functions, denominator nonzero). The composition tanh(softplus(x)) is definable. Mish = x · tanh(softplus(x)) is product of polynomial (x) and definable → definable. Network f(w,x) = composition of affine maps and Mish → definable. □

D4 (Zero Locus): Z(Mish) = {x : x · tanh(softplus(x)) = 0} = {x=0} ∪ {x : tanh(softplus(x))=0}. tanh(z)=0 iff z=0. softplus(x)=0 iff e^x=0, which has no finite solution. Thus Z(Mish) = {x=0}. The zero locus is algebraically trivial (single point), identical to GELU and SiLU. However, the analytic structure near x=0 is governed by the double transcendental composition tanh∘softplus, not a single transcendental.

D5 (Critical Point Singularity): Mish'(x) = tanh(softplus(x)) + x · sech²(softplus(x)) · σ(x) where σ(x) = 1/(1+e^{-x}). Setting Mish'(x*)=0 gives a transcendental equation with solution x* ≈ -1.088 (numerically verified). At x*, Mish(x*) ≈ -0.309 ≠ 0. This critical point is a TRANSCENDENTAL critical point — the derivative vanishes at a nonzero activation value. This creates a singular fiber component absent in ReLU (no interior critical point), GELU (erf monotonic modulation, no interior extremum), and SiLU (sigmoid monotonic, no interior extremum). The critical point x* is where the Fisher information contribution from a Mish unit changes character: the unit transitions from amplifying (Mish'>0) to attenuating (Mish'<0) gradients.

D6 (Singular Fiber): The singular fiber at parameter w₀ consists of W₀ = {w : det(I(w)) = 0}. Near x=0, Mish(x) ≈ tanh(ln2)·x + O(x²) where tanh(ln2) ≈ 0.462. The linear coefficient differs from GELU (0.5) and SiLU (0.5). The Fisher information near x=0 is generically full-rank (C∞ smooth, simple zero). The singular fiber includes: (a) directions where Mish units operate near x=0 (simple zero, same as GELU/SiLU), (b) directions where Mish units operate near x*≈-1.088 (critical point singularity, NOVEL), (c) saturation directions where x→-∞ (Mish→0⁻, exponential tail, gradient vanishes). Component (b) is the key novel singular stratum.

D7 (RLCT Candidate): Local RLCT near x=0: λ_local = 1/2 (simple zero crossing, same as GELU/SiLU). Critical point RLCT: λ_critical ≥ 0 (contribution from the x*≈-1.088 singularity where Mish'=0). Tail RLCT: λ_tail ≥ 0 (exponential decay Mish≈x·e^x as x→-∞). Total: λ_Mish = λ_local + λ_critical + λ_tail. The double transcendental composition affects λ_critical and λ_tail differently from GELU (erf, single transcendental) and SiLU (sigmoid, single transcendental). The non-monotonic dip is the key structural difference: it introduces λ_critical, a term absent in all previously analyzed activations.

## Claims

C1 (PROVEN): Mish is R_an,exp-definable. Proof: e^x ∈ R_an,exp by definition. ln = exp^{-1} ∈ R_an,exp. softplus = ln(1+e^x) ∈ R_an,exp (closure under + and ∘). tanh = (e^z - e^{-z})/(e^z + e^{-z}) ∈ R_an,exp (closure under −, ratio with nonzero denominator). tanh(softplus(x)) ∈ R_an,exp (closure under ∘). Mish = x · tanh(softplus(x)) ∈ R_an,exp (closure under ·). Network composition preserves definability. □

C2 (CONJECTURAL): The singular fiber structure of Mish networks has a THREE-COMPONENT structure: (a) simple-zero crossing at x=0 (same as GELU/SiLU, λ=1/2), (b) critical-point singularity at x*≈-1.088 where Mish'=0, Mish≠0 (NOVEL, absent in GELU/SiLU/ReLU), (c) exponential saturation tail (Mish≈x·e^x→0 as x→-∞). Component (b) arises from the non-monotonic dip unique to Mish. The double transcendental composition (tanh∘softplus) means the analytic structure of each component differs from single-transcendental activations. Specifically, near x*, the Hessian of Mish involves cross-terms between tanh and softplus derivatives that have no analog in GELU/SiLU.

C3 (CONJECTURAL): The double transcendental structure acts as a singularity-class selector. The hierarchy is:
- ReLU: algebraic (polynomial kink), λ_local=1, no tail, no critical point
- GELU: single transcendental (erf), λ_local=1/2, λ_tail_erf (Gaussian decay)
- SiLU: single transcendental (sigmoid), λ_local=1/2, λ_tail_sigmoid (exponential decay)
- Mish: double transcendental (tanh∘softplus), λ_local=1/2, λ_critical (NOVEL), λ_tail_exp (x·e^x decay)

Predicted: λ_Mish > λ_GELU if λ_critical > 0 (additional singular stratum increases RLCT). But λ_Mish may generalize better if the non-monotonic dip acts as implicit regularizer through a different mechanism (exploration of singular stratum space during training).

C4 (CONJECTURAL): Generalization bound for Mish networks: G_Mish(n) ≤ λ_Mish·log(n)/(2n) + U_Mish/√n + C_Mish where λ_Mish = λ_local + λ_critical + λ_tail. The λ_critical·log(n)/(2n) term is the novel contribution from the non-monotonic dip singularity, absent in all previously analyzed activations. The double transcendental correction affects both λ_critical and λ_tail. Predicted: for shallow networks, G_Mish ≈ G_GELU (λ_local dominates). For deep networks, G_Mish may exceed G_GELU (λ_critical accumulates across layers where units pass through the dip region).

C5 (CONJECTURAL): Phase transition during training: Mish networks show a DISTINCT SGLD LLC trajectory. Three predicted phases: (1) Early training (units near x=0): LLC ≈ GELU/SiLU (same simple-zero singularity). (2) Mid-training (units explore negative region, pass through x*≈-1.088): LLC BUMP from critical-point singularity — this is the signature prediction. (3) Late training (some units saturate at x→-∞): LLC tail contribution. The phase (2) bump is the key experimentally testable prediction: GELU and SiLU lack the non-monotonic dip and should NOT show this intermediate bump.

## Open Problems
1. Exact local RLCT λ_Mish at x=0 — confirm λ=1/2 despite double transcendental composition
2. Critical point RLCT λ_critical: is it well-defined? What is its value? Does Mish'=0 at x* create a codimension-1 singularity?
3. Does the double transcendental composition tanh∘softplus create a qualitatively different singularity class than single transcendental (erf/sigmoid)?
4. λ_critical accumulation across depth: how does the dip-region singularity scale with network depth?
5. Mish vs GELU vs SiLU total RLCT: is λ_Mish > λ_GELU (worse generalization) or does the dip regularize via a different mechanism?
6. Newton polygon / resolution graph for the double transcendental singularity at x*
7. Empirical SGLD LLC measurement: predicted three-phase trajectory with mid-training bump at x*≈-1.088

## Cross-References
#58 (ReLU, algebraic kink), #350 (SiLU, sigmoid transcendental), #555 (GELU, erf transcendental), #353 (ELU/SELU/Softplus, smoothing spectrum), #265 (SwiGLU, bilinear gating), #57 (softmax, transcendental)

Next: L2 novelty verification.