# Synthesis #558: LoRA (Low-Rank Adaptation) × RLCT L0 Exploration
# Date: 2026-10-23
# Status: L0 — initial exploration

## Topic: LoRA (Hu et al. 2021) × RLCT

LoRA (Low-Rank Adaptation) freezes pre-trained weights W and learns low-rank updates ΔW = BA where B ∈ R^{d×r}, A ∈ R^{r×d}, r << d. At inference, W_eff = W + BA. This constrains the fine-tuning to a rank-r submanifold of the full parameter space.

## Key Observations

1. **Rank constraint = algebraic constraint.** The constraint rank(ΔW) ≤ r is a semi-algebraic condition: all (r+1)-minors of ΔW vanish. This defines an algebraic variety in the (d×d) parameter space. The singular locus of this variety occurs where rank(ΔW) < r (degenerate rank), creating a nested singular stratum.

2. **Factorization gauge freedom.** The decomposition ΔW = BA has a gauge ambiguity: for any invertible P ∈ GL(r), (BP)(P^{-1}A) = BA. This creates a continuous symmetry group GL(r) acting on the factorization. The quotient space (BA modulo GL(r)) is the true parameter space. This GL(r) symmetry creates a singular fiber — the Fisher information degenerates along gauge orbits.

3. **Two-scale singularity structure.** (a) The rank-r constraint variety itself has singularities at rank < r. (b) The gauge symmetry GL(r) creates degenerate Fisher information along orbits. These are distinct singularity sources that both contribute to the RLCT.

4. **Pre-trained weights as fixed background.** Unlike training from scratch, LoRA has W fixed. The loss landscape is over (B, A) only. The pre-trained W provides a "reference point" — the zero-loss set includes all (B, A) such that f_{W+BA} achieves zero training loss. This is a different geometry from full fine-tuning.

5. **Rank as stratum selector.** The rank r acts as a stratum selector: r=0 (no adaptation) has trivial fiber; r=1 has the simplest non-trivial singular structure; increasing r adds complexity. Optimal r* trades off expressivity against generalization, analogous to capacity k in #557.

## Claims

**C1 (Provable):** The LoRA loss function L(B,A) = ℓ(f_{W+BA}(x), y) is definable in R_{an,exp}. W is constant, BA is polynomial (bilinear), W+BA is polynomial, and f is a standard definable neural network. Composition preserves definability.

**C2 (Conjectural):** The GL(r) gauge symmetry creates a singular fiber with RLCT contribution λ_gauge ≥ r². The gauge orbits are r²-dimensional (dim GL(r) = r²), and the Fisher information degenerates along these directions. This is a continuous symmetry singularity, analogous to #166 (MoE S_n symmetry) but with a Lie group instead of a discrete group.

**C3 (Conjectural):** The rank constraint variety V_r = {ΔW : rank(ΔW) ≤ r} has singular locus at rank(ΔW) < r, contributing λ_rank to the RLCT. For rank-r matrices, the singular locus is the rank-(r-1) stratum, which has codimension (d-r+1)². The total LoRA RLCT decomposes as: λ_LoRA = λ_base + λ_gauge + λ_rank, where λ_base is the base model RLCT contribution.

**C4 (Conjectural):** Generalization bound: G_LoRA(n) ≤ λ_LoRA · log(n)/(2n) + U_LoRA/√n. At optimal rank r*, λ_LoRA(r*) < λ_full(r*) because the rank constraint restricts the singular fiber to a lower-dimensional variety. Prediction: G_LoRA(n, r*) < G_full(n) for r* << d, explaining LoRA's empirical generalization advantage over full fine-tuning.

**C5 (Conjectural):** Phase transition in rank r: as r increases from 0, the RLCT increases as λ_LoRA(r) ~ λ_base + c·r² (gauge) + (d-r)⁻² (rank stratum). There exists r* ~ (d/n)^{1/3} where generalization is optimal. Beyond r*, overfitting increases because the gauge singularity grows as r². The phase transition manifests as an LLC inflection point at r*.

## Open Problems

1. Is the GL(r) gauge orbit degeneracy exactly r²-dimensional, or do weight constraints reduce it?
2. Does the nested rank stratum (rank < r) contribute meaningfully to RLCT, or is it dominated by the gauge term?
3. How does LoRA RLCT compare to full fine-tuning RLCT? Prediction: λ_LoRA(r*) < λ_full.
4. Multi-adapter LoRA (multiple rank-r updates): independent gauge symmetries or coupled?
5. Does the pre-trained W reference point change the fiber geometry qualitatively?
6. LoRA on different layers: does λ_gauge decompose per-layer or is it coupled?
7. Empirical SGLD LLC: LoRA vs full fine-tuning at same architecture, varying r

## Cross-References
#166 (MoE S_n symmetry — discrete vs continuous symmetry), #557 (Expert Choice capacity stratum selector — analogous r ↔ k), #213 (weight decay stratum), #465 (Kaiming init — initialization affects fiber), #528 (orthogonal init — gauge-like constraint), #473 (spectral norm — rank-1 constraint), #8 (#16 fundamental RLCT theory), #354 (STE gradient singularity — similar constrained gradient), #503 (early exit threshold — analogous rank threshold), #530 (MAML bi-level — analogous fixed outer parameters)

## Novelty Check
- Need to verify no prior LoRA × SLT/RLCT work exists
- Key novelty angles: (a) GL(r) gauge symmetry as continuous singular fiber, (b) rank constraint variety singular locus, (c) two-scale singularity (gauge + rank), (d) pre-trained W as fixed reference point

Next: L1 formalization.