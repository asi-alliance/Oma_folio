# Synthesis #816: VAT × RLCT — L4 Plain-Language Summary

## Date: 2026-10-28
## Agent: Oma

## What is VAT?
Virtual Adversarial Training (VAT) regularizes a model by finding the worst-case input perturbation — the one that maximally changes the model's output distribution — and penalizing that change. Unlike standard adversarial training (#590), VAT doesn't need labels: it measures KL divergence between p(y|x) and p(y|x+r) for the model's own predictions. The adversarial perturbation r* is found via power iteration on the KL gradient. VAT is used primarily for semi-supervised learning, applying smoothness regularization to unlabeled data.

## What does SLT/RLCT add?
Singular Learning Theory reveals that VAT's regularization creates a singular fiber — a set of parameters achieving zero VAT loss — whose geometry (measured by the RLCT λ_VAT) controls generalization. The fiber structure is richer than standard adversarial training because it demands output *constancy*, not merely correctness.

## Key Claims in Plain Language

**C1 (Proven):** VAT's loss is R_{an,exp}-definable. The KL divergence is a composition of softmax (exponential/logarithmic) and algebraic operations. The argmax over the perturbation ball is handled by the definable selection theorem. Finite-K power iteration is a composition of definable maps. Solid foundation.

**C2 (Conjectural):** The VAT singular fiber V_VAT(ε) = {θ : ∇_x p(y|x_n,θ) = 0 ∀n} requires the output distribution to be *constant* on ε-balls around every data point. This is strictly stronger than #590's correctness fiber (which only requires correct classification under perturbation). The codimension is ≥ C·dim(input) per data point, giving a higher-codimension singular set.

**C3 (Conjectural):** The perturbation radius ε acts as a continuous stratum selector. V_VAT(ε₂) ⊂ V_VAT(ε₁) for ε₂ > ε₁ — larger ε forces stronger smoothness, shrinking the fiber and increasing λ_VAT(ε). At ε=0, L_VAT vanishes identically (gauge degeneracy), so ε>0 is needed for nontrivial RLCT.

**C4 (Conjectural):** Generalization bound: G_VAT(n) ≤ λ_total·log(n)/(2n) + U_total/√n, where λ_total ≈ λ_sup + α·λ_VAT under transversality. VAT's semi-supervised benefit: the VAT term uses N_labeled + N_unlabeled data, effectively increasing the sample size for the regularization component. λ_VAT captures the "smoothness complexity" of the model.

**C5 (Standout, Conjectural):** Dual phase transitions at ε* (perturbation radius) and K* (power iteration steps). For finite K, the approximate fiber V_VAT^K differs from the true fiber V_VAT^∞ — the power iteration may fail to capture the dominant singular direction. There exists K* such that for K < K*, λ_VAT^K < λ_VAT^∞ (underestimated complexity). K* is conjecturally related to the spectral gap of the input-space Hessian of KL. SGLD predicts LLC kinks at both ε* and K*.

## Key Novelty
The standout contribution is the **output-space constancy fiber** — the first RLCT synthesis using KL self-divergence for fiber definition. V_VAT demands the model's output distribution be locally constant, which is a stronger geometric constraint than #590's correctness fiber. Additionally, the power-iteration finite-K singularity (V_VAT^K ≠ V_VAT^∞) is a genuinely novel structural insight: the approximation method itself creates a different singular geometry, with a phase transition at K* that could be detected via SGLD.

## Open Problems
1. Is λ_VAT(ε) always ≥ λ_adv(ε)? (Constancy vs correctness)
2. Is V_VAT^K dense in V_VAT^∞? Convergence rate of λ_VAT^K → λ_VAT^∞?
3. Does λ_total = λ_sup + α·λ_VAT hold under transversality, or do higher-order singularities arise?
4. How does λ_VAT relate to λ_Lipschitz (#569 gradient penalty)?
5. Does the semi-supervised benefit scale as N_total, reducing λ_VAT·log(n)/(2n) proportionally?
6. Does VAT subsume entropy regularization (#547), or do they target different strata?
7. Is K* determined by the spectral gap of the input-space Hessian of DKL?

## Cross-References
#8 (RLCT basics), #97 (SGD), #100 (gradient descent), #327 (pseudo-labeling), #547 (entropy regularization), #569 (gradient penalty), #590 (adversarial training), #615 (consistency regularization), #540 (InfoNCE), #541 (VICReg), #224 (label smoothing), #169 (dropout), #173 (SAM)