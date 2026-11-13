# Synthesis #SNN5: Mish Activation × RLCT — L0 Exploration
# Date: 2026-11-05
# Status: L0 — candidate exploration

## Activation Function
Mish(x) = x · tanh(softplus(x)) = x · tanh(ln(1 + e^x))

Components:
- x: polynomial factor (algebraic)
- softplus(x) = ln(1 + e^x): transcendental, analytic, C∞
- tanh(·): transcendental, analytic, C∞
- Composition tanh(softplus(x)): transcendental composition

Mish is C∞ smooth, non-monotonic (small negative dip ~x≈-1.088, min≈-0.309), unbounded above, bounded below.

## Singularity Structure
Mish combines:
- Polynomial zero from x (algebraic, x=0)
- Transcendental modulation from tanh(softplus(x)) — double transcendental composition
- Non-monotonicity: Mish dips negative for x<0, creating a local minimum at x≈-1.088 — a critical point where Mish'(x)=0 but Mish(x)≠0. This is a NEW singularity class feature absent in ReLU, GELU, SiLU.
- As x→-∞: softplus(x)→0, tanh(softplus(x))→softplus(x)≈e^x, so Mish(x)≈x·e^x→0⁻. Exponential decay tail.
- As x→+∞: softplus(x)≈x, tanh(x)→1, so Mish(x)≈x. Linear growth.

Key distinction from #555 GELU and #350 SiLU:
- GELU: x·erf(x) — single transcendental (erf)
- SiLU: x·σ(x) — single transcendental (sigmoid/logistic)
- Mish: x·tanh(ln(1+e^x)) — DOUBLE transcendental (tanh ∘ softplus)
The double composition creates a richer singularity structure: the zero locus and critical points differ qualitatively.

## Claims
C1 (PROVEN): Mish is R_an,exp-definable. softplus = ln(1+e^x) is definable (exp + log closure). tanh = (e^x - e^{-x})/(e^x + e^{-x}) is definable (ratio of definable). Composition and product preserve definability. Mish = x·tanh(softplus(x)) ∈ R_an,exp.

C2 (CONJECTURAL): Zero locus Z(Mish) = {x=0} ∪ {tanh(softplus(x))=0} = {x=0} ∪ {softplus(x)=0} = {x=0} (since softplus(x)=0 iff e^x=0, impossible). So Z(Mish)={x=0} — same algebraic zero as GELU/SiLU. BUT: the non-monotonic dip creates a critical point x*≈-1.088 where Mish'(x*)=0. This critical point is a TRANSCENDENTAL critical point (not algebraic), creating a distinct singular fiber. The double transcendental composition means the local contact order at x=0 differs from GELU (single erf) and SiLU (single sigmoid).

C3 (CONJECTURAL): The double transcendental structure acts as a singularity-class selector distinct from GELU/SiLU. Near x=0: Mish(x) ≈ x·tanh(ln(2) + x/2) ≈ x·tanh(ln2) + O(x²) ≈ 0.462x + O(x²). The linear coefficient tanh(ln2)≈0.462 differs from GELU's Φ(0)=0.5 and SiLU's σ(0)=0.5. This means the LOCAL multiplicity at x=0 is the same (simple zero, λ=1/2) but the transcendental correction differs. The global structure (negative dip, exponential tail) adds a non-local RLCT contribution absent in ReLU.

C4 (CONJECTURAL): Generalization bound for Mish networks: λ_Mish·log(n)/(2n) + O(1/√n). Predicted: λ_Mish ≈ λ_GELU locally (both C∞, simple zero at x=0) but with different transcendental tail correction due to tanh∘softplus double composition vs erf single composition. The non-monotonic dip may create an ADDITIONAL singular stratum (critical point x* where gradient vanishes) not present in GELU/SiLU.

C5 (CONJECTURAL): Phase transition: Mish vs GELU vs SiLU vs ReLU. Mish's non-monotonicity (negative dip) creates a qualitatively different loss landscape — the dip allows small negative activations that may regularize training. SGLD LLC prediction: Mish has a BUMP in LLC near the critical point x*≈-1.088 (where Mish'=0), corresponding to the non-monotonic singularity. This bump is absent in GELU/SiLU/ReLU. The double transcendental composition may also create a SMOOTHER LLC profile (richer analytic structure → more gradual phase transitions).

## Key Novelty
Mish's singularity is DOUBLE TRANSCENDENTAL via tanh∘softplus, distinct from:
- #58 ReLU: pure algebraic (polynomial kink)
- #350 SiLU: single transcendental (sigmoid)
- #555 GELU: single transcendental (erf)
- #353 ELU/SELU/Softplus: partial spectrum

The NON-MONOTONIC DIP is the key differentiator: no other covered activation has a critical point where f'=0 but f≠0 in the negative region. This creates a novel singular stratum. The double composition tanh(softplus(x)) also means the analytic structure is richer — two transcendental functions composed, each contributing to the singularity at infinity and at critical points.

## Open Problems
1. Exact RLCT of Mish near x=0 — same λ=1/2 as GELU/SiLU, or different from double composition?
2. Critical point singularity: does x*≈-1.088 (Mish'=0) create a measurable RLCT contribution?
3. Mish vs GELU vs SiLU RLCT comparison — local λ same, global λ different?
4. Double transcendental composition: does tanh∘softplus create qualitatively different singularity class than single transcendental?
5. Negative dip regularization: does the non-monotonic region act as implicit regularizer via singularity structure?
6. Depth-dependent RLCT for Mish networks
7. SGLD LLC bump at critical point x* — experimentally testable prediction

## Cross-References
#58 (ReLU, algebraic), #350 (SiLU, sigmoid transcendental), #555 (GELU, erf transcendental), #353 (ELU/SELU/Softplus, smoothing spectrum), #265 (SwiGLU, gating), #57 (softmax, transcendental)

Next: L1 formalization.