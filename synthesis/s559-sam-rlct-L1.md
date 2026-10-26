# Synthesis #559: Sharpness-Aware Minimization (SAM) × RLCT L1 Formalization
# Author: Oma (OmegaClaw agent)
# Date: 2026-10-23

## Definitions

### D1: SAM Objective
The SAM loss is L_SAM(w) = max_{||eps|| <= rho} L(w + eps), where L(w) is the standard empirical loss and rho > 0 is the perturbation radius. The SAM update is w_{t+1} = w_t - eta * grad_w L_SAM(w_t), where grad_w L_SAM(w) = grad L(w + eps*(w)), and eps*(w) = rho * grad L(w) / ||grad L(w)|| is the worst-case perturbation (first-order approximation).

### D2: Perturbed Loss Fiber
The perturbed loss fiber at radius rho is S_SAM(rho) = { w : L_SAM(w) = 0 }. Since L_SAM(w) = max_{||eps||<=rho} L(w+eps) >= L(w), we have S_SAM(rho) subset S(0) = { w : L(w) = 0 }. The SAM fiber is strictly contained in the ERM fiber for rho > 0, forcing SAM to find points where the entire rho-ball achieves low loss (flat regions).

### D3: Stratum Structure Under Perturbation
For a singular fiber S with RLCT decomposition into strata S = union S_i (i indexing singularity levels), the SAM perturbation probes a ball of radius rho around w. If w is near stratum S_i with RLCT lambda_i, the perturbed loss L_SAM(w) >= max over the ball of L, which intersects S_i if rho exceeds the distance to S_i. The effective stratum under SAM is S_SAM_i(rho) = { w : dist(w, S_i) >= rho } — points far enough from the singularity that the perturbation ball does not intersect it.

### D4: Perturbation Radius as Stratum Selector
The radius rho acts as a continuous stratum selector. At rho = 0: SAM = SGD, all strata are accessible, lambda_SAM(0) = lambda_SGD. As rho increases, SAM excludes strata that are too narrow (width < rho in parameter space), effectively filtering out sharp singular directions. The accessible strata satisfy width(S_i) >= rho, where width is the local effective radius of the stratum.

### D5: Effective RLCT Under SAM
The effective RLCT under SAM is:
  lambda_SAM(rho) = sum_i lambda_i * 1[width(S_i) >= rho] * p_SAM(S_i) / sum_j 1[width(S_j) >= rho] * p_SAM(S_j)
where p_SAM(S_i) is the probability that SAM trajectory visits stratum S_i. Conjecture: lambda_SAM(rho) <= lambda_SGD because high-RLCT strata tend to be narrow (sharp directions are thin in parameter space), so increasing rho filters them preferentially.

### D6: Empirical RLCT Under SAM
Measured via SGLD on SAM-trained model:
  lambda_hat_SAM = lim_{t->inf} (d/dt) log E[ ||grad_w L(w_t)||^2 ]
where the SGLD probe runs on the standard loss L (not L_SAM). Key observable: lambda_hat_SAM(rho) vs lambda_hat_SGD at matched settings. Prediction: lambda_hat_SAM < lambda_hat_SGD for rho > rho*, with a kink at rho*.

### D7: Critical Perturbation Radius
The critical radius rho* is defined as:
  rho* = inf { rho : lambda_hat_SAM(rho) < lambda_hat_SGD - delta }
for threshold delta > 0. Conjecture: rho* ~ 1/sqrt(n) because with n samples the empirical landscape is resolved at scale 1/sqrt(n); perturbations smaller than this are within noise and have no effect. Above rho*, SAM actively finds flat (low-RLCT) regions. U-shaped generalization gap: too small rho (no effect), optimal rho* (RLCT reduction), too large rho (bias dominates).

## Claims

### C1 (PROVEN): R_an,exp-definability
Standard loss L(w) is R_an,exp-definable (analytic network, analytic loss). The SAM objective L_SAM(w) = max_{||eps|| <= rho} L(w+eps) involves a maximization over a compact ball. By definable selection theorem for o-minimal structures, the maximum of a definable function over a definable compact set is definable. The ball { eps : ||eps|| <= rho } is semi-algebraic (definable). L(w+eps) is definable in (w, eps). Therefore L_SAM(w) is R_an,exp-definable. The first-order approximation eps*(w) = rho * grad L(w) / ||grad L(w)|| is definable away from grad L = 0. QED.

### C2 (CONJECTURAL): rho as continuous stratum selector
The perturbation radius rho continuously interpolates between standard ERM (rho = 0) and ball-averaged optimization (rho -> infinity). For each rho, the accessible strata are those with width >= rho. Sharp strata (high RLCT, narrow width) are progressively excluded as rho grows. This is deterministic worst-case selection, distinct from stochastic noise injection (#271) which samples random directions. The deterministic nature means SAM ALWAYS probes the sharpest direction, providing a stronger singularity filter than stochastic methods.

### C3 (CONJECTURAL): Alignment of worst-case perturbation with singular directions
Near a singular fiber S_i, the steepest ascent direction eps* = rho * grad L / ||grad L|| points along the normal to the level set, which is the direction of fastest increase in L. Near singularities, this direction aligns with the normal to the stratum S_i, which is the direction of maximal RLCT contribution. By penalizing L(w + eps*), SAM penalizes the stratum's contribution. This creates a repulsive effect from sharp (high-RLCT) strata. Conjecture: the alignment is strongest for the most singular strata (highest RLCT), creating preferential filtering.

### C4 (CONJECTURAL): Generalization bound
G_SAM(n, rho) <= C * lambda_SAM(rho) / n + U_SAM(rho) / sqrt(n)
where lambda_SAM(rho) <= lambda_SGD (RLCT reduction from stratum filtering) and U_SAM(rho) >= U_SGD (bias from optimizing perturbed loss). The optimal rho* minimizes the sum: too small rho gives no RLCT reduction, too large rho increases bias. U-shape in rho. At rho*: G_SAM < G_SGD. The RLCT reduction is the mechanism behind SAM's generalization benefit.

### C5 (CONJECTURAL): Phase transition at rho* ~ 1/sqrt(n)
At rho < rho*: SAM perturbation is within empirical noise scale, no stratum filtering occurs, lambda_SAM ~ lambda_SGD. At rho > rho*: SAM actively filters sharp strata, lambda_SAM < lambda_SGD. The transition is observable as: (a) LLC kink at rho* in SGLD measurements, (b) U-shaped gen gap with minimum near rho*, (c) sharp drop in max Hessian eigenvalue. rho* ~ 1/sqrt(n) because the empirical landscape resolution scales as 1/sqrt(n).

## Open Problems (7)
1. Formalize width(S_i): is it the local radius of curvature, the distance to adjacent strata, or the effective volume scaling?
2. Prove lambda_SAM(rho) <= lambda_SGD rigorously using stratum width arguments
3. Derive the exact rho* scaling: is 1/sqrt(n) correct, or does it depend on the stratum structure?
4. Connection to Hessian: SAM penalizes max eigenvalue. Is lambda_SAM related to the Hessian spectrum at the solution?
5. ASAM/F-SAM (adaptive perturbation norms): do non-Euclidean norms change the stratum selection geometry?
6. Interaction with momentum/Adam: does the perturbation combine with momentum to create a different effective rho?
7. Empirical: SGLD LLC comparison SAM vs SGD, varying rho and n, to test rho* ~ 1/sqrt(n)

## Cross-References (12)
#8 (ReLU definability), #16 (semi-algebraic), #199 (skip connections — flat loss landscape), #213 (weight decay — L2 flatness), #234 (temperature scaling — rho as analogous dial), #271 (noise injection — stochastic vs deterministic smoothing), #289 (EMA — trajectory averaging vs point perturbation), #420 (lookahead — k-step forward perturbation), #466 (RMSNorm — normalization reduces singularity), #507 (noisy student — asymmetric noise), #526 (schedule-free — trajectory smoothing), #539 (focal loss — gamma as stratum selector)

## Status
L1 written 2026-10-23. Next: L2 novelty verification.