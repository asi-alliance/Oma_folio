# Synthesis #608: Class Balancing / Long-Tail Learning — RLCT — L2 Novelty Check
## Date: 2026-10-25
## Status: NOVEL (DISTINCT)

### Searches Performed
1. RLCT singular learning theory class imbalance long-tail distribution per-class loss reweighting
2. singular learning theory class weighted cross entropy loss landscape singularity neural network
3. algebraic geometry singularity class imbalance reweighting loss function deep learning
4. class balanced loss effective number samples singular learning theory algebraic geometry
5. weighted cross entropy singular geometry generalization bound imbalanced learning theory 2024 2025

### Prior Work Assessment
- No prior work bridges class balancing / long-tail learning with Singular Learning Theory or RLCT
- Class balancing is studied extensively in the imbalanced learning literature (Cui et al. 2019, Cao et al. 2019) for empirical performance
- Loss reweighting dynamics studied via training dynamics (Byrd & Lipton 2019) but NOT through SLT/singularity lens
- Zero catalog hits for class balancing, long-tail, imbalance, reweighting, inverse frequency, cost-sensitive

### Novelty Verdict: NOVEL (DISTINCT)

### Key Novel Contributions
1. **C1 (Proven)**: Class-balanced loss L_bal is R_{an,exp}-definable. Effective number E_k involves exponential, all compositions preserve definability.
2. **C2 (Conjectural)**: Per-class reweighting creates a class-indexed singular fiber V_0^bal where each class-specific singular locus S_k is scaled by w_k * n_k. Under transversality, lambda_bal = min_k(w_k * lambda_k) — the RLCT is determined by the minimum scaled per-class contribution, <b>not</b> by the majority class alone.
3. **C3 (Conjectural)**: The weight vector w_vec acts as a <b>multi-dimensional continuous stratum selector</b>. Unlike #433 PolyLoss (discrete degree d), #539 Focal Loss (single scalar gamma), or #536 DPO (single beta), class balancing has K-dimensional selector space. Critical surfaces Sigma in R_{>0}^K where stratum transitions occur.
4. **C4 (Conjectural)**: Generalization bound includes <b>reweighting bias</b> B_w = max_k|w_k - n_k/N|, creating a bias-complexity tradeoff: optimal weights minimize lambda_bal/n + B_w/sqrt(n), which is <b>NOL</b> necessarily inverse frequency.
5. **C5 (Conjectural)**: <b>Tail-length phase transition</b> rho* — critical imbalance severity where class balancing becomes essential. Effective-number saturation (beta parameter) smooths this transition, acting as regularization on the stratum selector.

### Distinction from Related Syntheses
- **#539 Focal Loss**: Focal loss modulates per-example loss by prediction confidence (1-p_t)^gamma in probability space. Class balancing modulates per-class loss by sample frequency w_k. Different singularity mechanisms: focal loss creates a modulation-induced singularity at p_t=1; class balancing rescales class-indexed strata. Focal loss is instance-level, class balancing is class-level. Both touch imbalance but via orthogonal mechanisms.
- **#433 PolyLoss***: Polynomial degree d as discrete stratum selector in logit space. Class balancing uses continuous K-dim weight vector in class-frequency space.
- **#536 DPO**: Beta selects between policy/reference strata. Class balancing selects between class strata.
- **#372 Deep Supervision**: Auxiliary weight selects between main/auxiliary singular loci. Class balancing selects between class-specific singular loci.
- **#95 Curriculum Learning**: Sample ordering changes training distribution over time. Class balancing changes per-sample loss weight (static). Curriculum affects stratum accessibility timing; class balancing affects stratum scaling.
- **#548 Mixup**: Interpolation creates continuous deformation of singular set. Class balancing rescales existing strata without deformation.

### Overlap Assessment
#539 Focal Loss is the closest neighbor — both address class imbalance. However, the RLCT bridges are fundamentally different: focal loss introduces a modulation-induced singularity (new singularity type), while class balancing rescales existing class-indexed singular strata (new selection mechanism). The multi-dimensional stratum selector (K-dim weight vector) is genuinely novel — no other synthesis has a selector space of dimension > 1.