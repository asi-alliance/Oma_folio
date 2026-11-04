# Synthesis #816: Virtual Adversarial Training (VAT) × RLCT -- L0 Exploration

### Date: 2026-10-28
### Status: L0 (exploration)
### Pipeline: L0 done L1 PENDING

---

## Background

Virtual Adversarial Training (VAT) (Miyato et al., 2018) regularizes a model by maximizing local distributional smoothness (LDS) — the model's output distribution should be smooth under small perturbations to the input. Unlike standard adversarial training (#590), VAT does NOT require labels: the perturbation direction is chosen to maximize the KL divergence between the model's prediction at x and at x+r, where r is the "virtual adversarial perturbation."

### Key Definitions (from literature)

**LDS(x, θ)** = -ΔKL(r_v-adv, x, θ), where:
- r_v-adv = argmax_{||r||≤ε} D_KL(p(y|x,θ) || p(y|x+r,θ))
- ΔKL = D_KL(p(y|x,θ) || p(y|x+r,θ))

**VAT Loss**: L_VAT(θ) = (1/N) Σ_n LDS(x_n, θ) = -(1/N) Σ_n D_KL(p(y|x_n,θ) || p(y|x_n+r*_n,θ))

**Total VAT objective**: L_total = L_supervised + α · L_VAT

**Power iteration**: r_v-adv is approximated via power iteration on the Hessian of KL w.r.t. input, using finite differences (no second-order computation needed).

---

## Key Questions

Q1: Is L_VAT(θ) R_{an,exp}-definable? The KL divergence D_KL(p(y|x,θ)||p(y|x+r,θ)) involves softmax outputs — exp/log composition. The argmax over the ε-ball is a definable selection problem. Does the definable selection theorem apply?

Q2: What is the singular fiber structure of VAT? The zero-LDS condition means p(y|x,θ) = p(y|x+r,θ) for all ||r||≤ε — the model is perfectly smooth (constant) in an ε-neighborhood. What is the geometry of V_VAT = {θ : L_VAT(θ) = 0}?

Q3: How does V_VAT relate to V_0 (standard zero-loss fiber)? Since VAT is a regularizer (not a supervised loss), V_VAT intersects with the supervised fiber: V_total = V_supervised ∩ V_VAT. Does this intersection create new singularities?

Q4: VAT uses power iteration to approximate r_v-adv. Does finite-K power iteration preserve definability? (Analogous to PGD approximation in #590.) Each iteration is a composition of definable maps, so finite-K is definable, but the fixed point may introduce a different singularity type.

Q5: The self-referential structure of VAT — the target distribution IS the model's own prediction — creates a moving target. How does this compare to #327 (pseudo-labeling, self-referential in parameter space) and #590 (adversarial training, CE with true labels)?

---

## Preliminary Claims

### C1 (PROVABLE): R_{an,exp} Definability
L_VAT(θ) = -(1/N) Σ_n sup_{||r||≤ε} D_KL(p(y|x_n,θ) || p(y|x_n+r,θ)) is R_{an,exp}-definable.
- D_KL(p||q) = Σ_c p_c log(p_c/q_c) is definable (softmax = exp/log, KL = sum of definable terms).
- {r : ||r||≤ε} is compact semialgebraic (definable).
- By definable selection theorem: sup of definable function over compact definable set is definable.
- Sum of definable functions is definable. QED.
(Same structure as #590 C1, but with KL instead of CE — both are definable.)

### C2 (CONJECTURAL): VAT Smoothness Fiber
V_VAT = {θ : ∀n, ∀r with ||r||≤ε, p(y|x_n+r,θ) = p(y|x_n,θ)}
This is the set of parameters where the model output is constant on ε-balls around each data point.
- V_VAT requires local constancy of the prediction function, not just correctness.
- V_VAT ⊂ {θ : ∇_x p(y|x_n,θ) = 0 for all n} (zero input-gradient — stronger than #590 which only requires correct classification).
- The constraint p(y|x+r,θ) = p(y|x,θ) for ALL r in ε-ball implies the Jacobian ∂p/∂x = 0 at each x_n, creating a high-codimension fiber.
- Conjecture: V_VAT has higher codimension than V_adv(ε) from #590, because constancy of distribution is stronger than correctness under perturbation.

### C3 (CONJECTURAL): ε as Stratum Selector for VAT
L_VAT(θ; ε) = -(1/N) Σ_n D_KL(p(y|x_n,θ) || p(y|x_n+r*_n,θ)) where r* depends on ε.
As ε increases:
- The constraint p(y|x+r,θ) = p(y|x,θ) must hold over a larger ball.
- V_VAT(ε₂) ⊂ V_VAT(ε₁) for ε₂ > ε₁ (decreasing filtration, same as #590).
- λ_VAT(ε) = RLCT of K_VAT(θ;ε) = L_VAT(θ;ε) - min_θ L_VAT(θ;ε).
- Conjecture: λ_VAT(ε) ≥ λ_adv(ε) because constancy is a stronger constraint than correctness.
- The KL-based perturbation explores directions of maximum output change, which may reveal different singular strata than CE-based adversarial training.

### C4 (CONJECTURAL): VAT Generalization Bound
G_VAT(n) ≤ λ_VAT(ε) · log(n) / (2n) + U_VAT(ε) / √n
where λ_VAT(ε) is the RLCT of the VAT-regularized loss landscape.
- Since VAT adds a regularization term to the supervised loss, the total RLCT is:
  λ_total = RLCT of (L_sup + α·L_VAT) at the minimizer.
- Under transversality: λ_total ≈ λ_sup + α·λ_VAT (additive when fibers intersect transversally).
- VAT's semi-supervised benefit: using unlabeled data effectively increases n for the VAT term, reducing the generalization gap contribution from the regularization term.
- Conjecture: λ_VAT captures the "smoothness complexity" of the model — models that are naturally smooth have low λ_VAT, while models with sharp decision boundaries have high λ_VAT.

### C5 (CONJECTURAL): Power Iteration Phase Transition
The power iteration approximation r_K (K iterations) converges to r_v-adv as K→∞.
- For finite K: L_VAT^K(θ) uses r_K instead of r*, creating an approximate fiber V_VAT^K.
- V_VAT^K ≠ V_VAT^∞ — the approximation changes the fiber geometry.
- Conjecture: there exists K* such that for K < K*, the power iteration fails to capture the dominant singular direction, and λ_VAT^K < λ_VAT^∞ (underestimated complexity).
- For K ≥ K*: λ_VAT^K ≈ λ_VAT^∞ (converged).
- SGLD prediction: LLC measured with K-step power iteration shows a kink at K*, analogous to the ε* phase transition in #590.
- Gap: the relationship between K* and the spectral gap of the input-space Hessian is unclear.

---

## Distinction from Prior Syntheses

### vs #590 (Adversarial Training PGD/FGSM × RLCT)
- #590 uses CE loss with TRUE LABELS: L_adv = max_δ L(f(x+δ), y).
- #816 uses KL between model's OWN predictions: L_VAT = max_r D_KL(p(y|x) || p(y|x+r)).
- #590 requires labels; #816 is label-free (semi-supervised).
- #590's fiber V_adv requires correct classification under perturbation; #816's fiber V_VAT requires output CONSTANCY under perturbation (stronger).
- #590's perturbation is in input space against labels; #816's perturbation is in input space against self.
- #590 inner max uses CE; #816 inner max uses KL — different definability paths but both R_{an,exp}.

### vs #327 (Pseudo-Labeling/Self-Training × RLCT)
- #327 is self-referential in PARAMETER space: θ trains on labels generated by θ itself (fixed point θ = T(θ)).
- #816 is self-referential in OUTPUT space: the target distribution IS p(y|x,θ), but the perturbation is in INPUT space.
- #327's singularity comes from the argmax discontinuity in pseudo-label generation.
- #816's singularity comes from the constancy constraint on the output distribution over ε-balls.
- Both share: self-referential target, no external ground truth for the regularization term.

### vs #540/#541 (InfoNCE/VICReg × RLCT)
- #540 uses contrastive loss between positive/negative pairs (explicit pairing).
- #816 uses KL between same-input perturbed predictions (no pairing, no negatives).
- #541 uses variance/invariance/covariance regularization (explicit geometric constraints).
- #816 uses implicit smoothness via adversarial perturbation (worst-case direction).
- #816's KL divergence is between distributions at nearby points, not between representations.

### vs #615 (Consistency Regularization × RLCT)
- #615 enforces f(x) = f(g(x)) for augmentation g (explicit transformation).
- #816 enforces p(y|x) = p(y|x+r) for worst-case r (implicit, adversarially chosen).
- #615's fiber is defined by invariance to specific augmentations; #816's fiber is defined by invariance to worst-case perturbations.
- #816 is stronger: if p is invariant to worst-case r, it is invariant to ALL r in the ball.

---

## Open Problems

P1: Exact RLCT of V_VAT(ε) — how does it depend on ε, network depth, width? Is λ_VAT(ε) always ≥ λ_adv(ε)?

P2: Relationship between power iteration convergence (K steps) and RLCT: does finite-K power iteration create a genuinely different singular fiber, or is V_VAT^K dense in V_VAT^∞?

P3: VAT + supervised loss interaction: is λ_total = λ_sup + α·λ_VAT under transversality, or does the intersection create higher-order singularities?

P4: Connection to spectral norm regularization: V_VAT requires ∇_x p = 0, which is related to Lipschitz constraint (#569 gradient penalty). How does λ_VAT relate to λ_Lipschitz?

P5: Semi-supervised benefit quantification: VAT uses N_labeled + N_unlabeled data. Does the effective sample size for the VAT term scale as N_total, reducing λ_VAT · log(n)/(2n) proportionally?

P6: VAT vs entropy regularization (#547): both regularize the output distribution. Does VAT subsume entropy regularization, or do they target different singular strata?

P7: Power iteration and Hessian spectrum: the dominant eigenvector of the input-space Hessian of KL determines r_v-adv. How does the spectral structure of this Hessian relate to the RLCT of V_VAT?

---

## Cross-References
#8 (RLCT basics), #97 (SGD), #100 (gradient descent), #327 (pseudo-labeling — self-referential),
#547 (entropy regularization — output distribution regularizer), #569 (gradient penalty — Lipschitz connection),
#590 (adversarial training — CE+labels vs KL+self), #615 (consistency regularization — augmentation invariance),
#540 (InfoNCE — contrastive KL), #541 (VICReg — geometric regularization), #224 (label smoothing — soft target),
#169 (dropout — stochastic regularization), #173 (SAM — parameter-space perturbation)
