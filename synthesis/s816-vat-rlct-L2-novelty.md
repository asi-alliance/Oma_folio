# Synthesis #816: VAT × RLCT L2 NOVELTY VERIFICATION

### Date: 2026-10-28
### Status: L2 NOVELTY VERIFIED
### Pipeline: L0 done L1 done L2 done L3 PENDING

---

## Websearch Results

1. "virtual adversarial training singular learning theory RLCT local distributional smoothness" — ZERO SLT/RLCT hits. All results standard VAT/LDS papers (Miyato et al 2018).
2. "VAT KL divergence regularization algebraic geometry singularity loss landscape" — ZERO hits (search returned VAT tax results, irrelevant). No prior work on VAT singularity structure.

## Catalog Check
grep -ic virtual.adversarial synthesis-catalog.md → 0 hits. VAT never synthesized before.

## Overlap Analysis

### vs #590 (Adversarial Training PGD/FGSM)
#590: CE loss with true labels, input perturbation against labels.
#816: KL between model's own predictions, label-free, self-referential.
DISTINCT — different loss (KL vs CE), different target (self vs labels), different fiber (constancy vs correctness).

### vs #327 (Pseudo-Labeling)
#327: Self-referential in parameter space (θ trains on labels from θ).
#816: Self-referential in output space (KL between p(y|x) and p(y|x+r)).
DISTINCT — parameter-space vs output-space self-reference, different singularity mechanisms.

### vs #569 (Gradient Penalty)
#569: Penalizes ||∇_x f||² directly (explicit first-order constraint).
#816: Finds worst-case direction via power iteration on KL (implicit worst-case constraint).
DISTINCT — explicit penalty vs adversarial worst-case, power iteration introduces K-step singularity.

### vs #615 (Consistency Regularization)
#615: Invariance to fixed augmentations f(x)=f(g(x)).
#816: Invariance to worst-case perturbation p(y|x)=p(y|x+r*) for adversarial r*.
DISTINCT — fixed augmentation vs adversarial worst-case, explicit transform vs implicit perturbation.

## Verdict: NOVEL

C1 standard-novel (R_an,exp definability via KL+softmax+definable selection — proven).
C2-C5 genuinely novel:
- C2: Output-space constancy fiber V_VAT = {θ : ∇_x p(y|x_n,θ)=0 ∀n} — stronger than #590's correctness fiber, higher codimension.
- C3: ε as continuous stratum selector for KL-based smoothness, monotone λ_VAT(ε).
- C4: Semi-supervised generalization bound with effective sample size from unlabeled data.
- C5: Dual phase transitions at ε* (perturbation radius) and K* (power iteration steps).

Standout: Output-space constancy fiber is the first RLCT synthesis using KL self-divergence for fiber definition. The power-iteration finite-K singularity (V_VAT^K ≠ V_VAT^∞) is a genuinely novel structural insight.

Next: L3 MeTTa encoding.