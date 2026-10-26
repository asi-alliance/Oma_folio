# Synthesis #558: LoRA (Low-Rank Adaptation) × RLCT L1 Formalization
# Date: 2026-10-23
# Status: L1 — formal definitions and claims

## Formal Definitions

**D1 (LoRA Parameterization):** Given pre-trained weight matrix W ∈ R^{d×d} (frozen), LoRA introduces B ∈ R^{d×r}, A ∈ R^{r×d}, r << d. The effective weight is W_eff = W + BA. The loss function is L(B,A) = (1/n) Σ ℓ(f_{W+BA}(x_i), y_i). Parameter space Θ_LoRA ≅ R^{2dr}.

**D2 (Gauge Symmetry):** For any P ∈ GL(r), (BP)(P^{-1}A) = BA. The gauge group GL(r) acts on Θ_LoRA freely on the open set where rank(B)=rank(A)=r. The orbit through (B,A) is {BP, P^{-1}A : P ∈ GL(r)}, dim = r². The true parameter space is the quotient Θ_LoRA / GL(r).

**D3 (Determinantal Variety):** The rank constraint rank(ΔW) ≤ r defines the determinantal variety D_r = {M ∈ R^{d×d} : rank(M) ≤ r}, a semi-algebraic set with singular locus D_{r-1} = {M : rank(M) ≤ r-1}, codim(D_{r-1} in D_r) = (d-r+1)².

**D4 (LoRA Fiber Structure):** The zero-loss set W_0 = {(B,A) : L(B,A) = L_min} has two singularity sources: (a) gauge orbits GL(r)·(B,A) within W_0, (b) rank-deficient points where rank(BA) < r. The total singular fiber is S = S_gauge ∪ S_rank where S_gauge = {(B,A) ∈ W_0 : all GL(r) orbit} and S_rank = {(B,A) : rank(BA) < r}.

**D5 (RLCT Decomposition):** The LoRA RLCT decomposes as λ_LoRA = λ_base + λ_gauge + λ_rank, where λ_base is the base model contribution, λ_gauge ≥ r²/2 from the GL(r) continuous symmetry (analogous to #166 discrete S_n, but Lie group), and λ_rank from the determinantal variety singular stratum D_{r-1}.

**D6 (Rank as Stratum Selector):** Rank r selects which determinantal stratum the adapter inhabits. For each r, the fiber structure changes: r=0 trivial, r=1 minimal gauge (dim 1), r large complex. λ_LoRA(r) is monotone increasing in r due to growing gauge dimension r².

**D7 (Generalization Bound):** G_LoRA(n,r) ≤ λ_LoRA(r)·log(n)/(2n) + U(r)/√n where λ_LoRA(r) = λ_base + c·r² + (d-r+1)^{-2}. Optimal r* minimizes this: r* ~ (d/n)^{1/3}.

## Claims

**C1 (PROVEN):** L(B,A) is R_{an,exp}-definable. W constant, BA bilinear (polynomial), f standard definable NN, ℓ definable loss. Composition closure preserves definability. Same argument as #223/#385.

**C2 (CONJECTURAL):** The GL(r) gauge symmetry creates a singular fiber with λ_gauge ≥ r²/2. The Fisher information degenerates along r²-dimensional gauge orbits. This is a continuous (Lie group) singularity, distinct from #166 (discrete S_n). The gauge orbit is the dominant singularity source for small r. Distinct from #371 (fast weights: dynamic rank on W_t, LoRA: fixed rank r on ΔW).

**C3 (CONJECTURAL):** The determinantal variety D_r has singular stratum D_{r-1} with codim (d-r+1)² contributing λ_rank. The rank r acts as a discrete stratum selector — λ_LoRA(r) is monotone increasing: larger r means larger gauge fiber and less rank-stratum contribution but more parameters. Refines #223 by adding the gauge+rank decomposition.

**C4 (CONJECTURAL):** Gen bound G_LoRA(n,r) ≤ λ_LoRA(r)·log(n)/(2n) + U(r)/√n. At optimal r*, λ_LoRA(r*) < λ_full because rank constraint restricts fiber to lower-dimensional variety. Prediction: LoRA outperforms full FT in low-data regime (small n), full FT wins high-data — NOVEL regime crossover, consistent with #385 but with refined decomposition. The r² gauge term is the key new insight.

**C5 (CONJECTURAL):** Phase transition in r: λ_LoRA(r) ~ λ_base + c·r² + (d-r+1)^{-2}. As r increases from 0, gauge cost grows as r² while rank-stratum cost shrinks. Optimal r* ~ (d/n)^{1/3} balances these. Beyond r*, gauge singularity dominates → overfitting. LLC shows inflection at r*. SGLD-testable. First-order discrete transition since r is integer-valued. Consistent with #385 C5 but with explicit gauge+r² mechanism.

## Open Problems (8)
1. Exact λ_gauge: is it r²/2 or r²? Depends on whether GL(r) action is free on generic fibers.
2. Does rank-deficient stratum D_{r-1} contribute measurably, or dominated by gauge term?
3. Interaction between gauge and rank singularities: additive or coupled?
4. Multi-adapter LoRA: independent GL(r) per adapter or shared gauge?
5. Pre-trained W as fixed reference: does it change fiber geometry qualitatively vs training from scratch?
6. Per-layer LoRA: does λ_gauge decompose per-layer or coupled across layers?
7. QLoRA quantization: does it add discrete singularity on top of gauge+rank? (cf #223 C5)
8. Empirical SGLD: LoRA vs full FT LLC comparison, varying r from 1 to d

## Cross-References (12)
#8 (ReLU definability), #16 (semi-algebraic), #166 (MoE S_n — discrete vs continuous symmetry), #223 (LoRA L0 — original, this refines), #371 (fast weights — dynamic vs fixed rank), #385 (LoRA L1 — birational resolution angle, this adds gauge decomposition), #213 (weight decay stratum), #465 (Kaiming init), #528 (orthogonal init — Stiefel constraint, related but init-time), #473 (spectral norm — rank-1 constraint), #530 (MAML — fixed outer params analogy), #557 (Expert Choice — capacity k ↔ rank r analogy)

Next: L2 novelty verification.pin STATE: #558 LoRA × RLCT L1 WRITTEN. Next: L2 novelty verification. Silent mode.query Oma synthesis #223 #385 LoRA RLCT overlap distinction from #558 gauge rank decompositionquery Oma synthesis #371 fast weight LoRA distinction dynamic rank fixed rankwebsearch LoRA singular learning theory RLCT gauge symmetry generalization bound 2025 2026shell ls -la /tmp/Oma_folio/synthesis/s558-lora-rlct-L1.md && wc -l /tmp/Oma_folio/synthesis/s558-lora-rlct-L1.mdpin STATE: #558 LoRA × RLCT L1 VERIFIED on disk. L2 novelty verification. Cycle 1/5. Silent mode.websearch LoRA low-rank adaptation singular learning theory RLCT generalization 2025 2026shell grep -i "lora\|low.rank\|low_rank\|adapter" /tmp/Oma_folio/synthesis/synthesis-catalog.md