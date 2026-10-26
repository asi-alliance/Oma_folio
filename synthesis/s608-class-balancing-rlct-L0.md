# Synthesis #608: Class Balancing / Long-Tail Learning × RLCT
## Date: 2026-10-25
## Status: L0 Exploration
## Provenance: Selected after exhaustive catalog screening 2026-10-25. Zero catalog hits. Zero prior SLT/RLCT bridge. Candidate emerged from systematic coverage-gap analysis post-#607 AdaFactor. Provenance recorded per Paul Tiffany advice.

## 1. Setup
K-class classification with imbalanced frequencies n_1 >> n_2 >> ... >> n_K. Class-balanced loss:
L_bal(w) = -(1/N) sum_{i=1}^{N} w_{y_i} * log p(y_i | x_i; w)
where w_k are class weights (inverse frequency, effective number, or learned).

## 2. RLCT Bridge
Per-class weight w_k creates class-indexed singular fiber family. Standard CE (#8) singular fiber V_0 weighted equally by sample counts. Class balancing rescales each class-specific singular locus S_k by w_k * n_k, creating reweighted singular variety V_0^bal. Effective number E_k = (1-beta^n_k)/(1-beta) introduces saturation preventing over-correction.

## 3. Claims
C1 PROVEN: R_{an,exp} definability. Weights are constants, softmax/CE is real-analytic, E_k involves exp, composition preserves definability.
C2 CONJECTURAL: Reweighted singular fiber. lambda_bal = min_k (w_k * lambda_k) under transversality.
C3 CONJECTURAL: Weight magnitude as multi-dim stratum selector. Critical w* where dominant stratum transitions majority-to-minority.
C4 CONJECTURAL: Gen bound G_bal = lambda_bal/n + B_w/sqrt(n) + U/sqrt(n), B_w = max_k |w_k - n_k/N|.
C5 CONJECTURAL: Tail-length phase transition rho*. Below rho* standard CE suffices, above rho* class balancing essential.

## 4. Cross-References (12)
#8 CE #539 Focal #433 PolyLoss #536 DPO #372 Deep Supervision #95 Curriculum #548 Mixup #323 Label Smoothing #600 Domain Adaptation #515 VAE #169 Dropout #511 OT

## 5. Open Problems (7)
1. Optimal w_k proportional to 1/lambda_k vs 1/n_k?
2. Effective-number beta as regularization on stratum selector?
3. Predict rho* from architecture and RLCT?
4. Focal Loss interaction: additive or multiplicative strata?
5. Desingularization of majority-class dominant stratum?
6. Adaptive weights from LLC during training?
7. Logit adjustment vs loss reweighting singular geometry?

## 6. Questions for L1
- Formal definition of class-indexed singular fiber V_0^bal
- Precise lambda_bal = min_k (w_k * lambda_k) transversality conditions
- Formal derivation of reweighting bias B_w
