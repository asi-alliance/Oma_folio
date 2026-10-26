# Synthesis #612: Schedule-Free × RLCT — L1 Formalization
## Date: 2026-10-25
## Status: L1 Formalization

### D1: Three-Body State Space
The state at step t is a triple S_t = (x_t, y_t, z_t) in R^d × R^d × R^d.
- x_t: averaged iterate (Polyak-Ruppert weighted average of z_k, k<=t)
- y_t: extrapolated iterate (blend of z_t and x_t)
- z_t: base iterate (gradient descent point)
The full parameter space is R^{3d}, but the loss L is evaluated
at y_t (gradient) and x_t (output). The fiber structure lives in
the 3d-dimensional state space, not just R^d.

### D2: Schedule-Free Update Map
Given S_t = (x_t, y_t, z_t), gradient g_t = nabla L(y_t):
  y_t = (1 - beta) * z_t + beta * x_t          (extrapolation/blend)
  z_{t+1} = z_t - eta * g_t                      (base update)
  x_{t+1} = (1 - c_t) * x_t + c_t * z_{t+1}      (PR averaging)
where c_t = 1/(t+1) (Polyak-Ruppert weight), beta in (0,1).
The update map Phi: R^{3d} -> R^{3d} is:
  Phi(x, y, z) = ((1-c_t)*x + c_t*(z - eta*nabla L(y)),
                  (1-beta)*z + beta*x,
                  z - eta*nabla L(y))
This map is C^infinity on the open set where nabla L is smooth,
and is R_{an,exp}-definable when L is definable.

### D3: Polyak-Ruppert Averaging Fiber
The averaged iterate x_t = sum_{k=0}^{t} w_k * z_k where w_k = c_k * prod_{j=k+1}^{t} (1-c_j).
For c_t = 1/(t+1), this gives w_k = 1/(t+1) (uniform average).
The PR averaging map A_t: R^{d x (t+1)} -> R^d sends
(z_0, ..., z_t) -> (1/(t+1)) * sum z_k.
The FIBER of A_t over a point w is A_t^{-1}(w) = {(z_0,...,z_t) : mean(z_k) = w},
a convex set of dimension d*t. This is a SMOOTH submanifold (affine subspace).

### D4: Extrapolated Gradient Stratum (Shadow Stratum)
y_t = (1-beta)*z_t + beta*x_t. The gradient g_t = nabla L(y_t) is
evaluated at a BLEND point, not at z_t or x_t. If z_t is in stratum
Sigma_j and x_t is in stratum Sigma_k (j != k), then y_t lies on
the line segment between them, potentially in a DIFFERENT stratum
Sigma_l or in an interpolation region. The gradient nabla L(y_t)
carries information about a stratum neither z_t nor x_t occupies
— a "shadow stratum."

### D5: Smooth Stratum Crossing Condition
Define smooth stratum crossing: the averaged path x_t crosses
between singular strata WITHOUT a phase transition iff
the RLCT lambda(x_t) is continuous in t. Formally:
  forall t, forall epsilon > 0, exists delta > 0:
  |t - t'| < delta => |lambda(x_t) - lambda(x_{t'})| < epsilon.
Schedule-Free conjectures SMOOTH crossing because x_t is a
continuous average — no discrete switching mechanism.
Contrast: #605 Adagrad (irreversible freezing = jump),
#611 RAdam (variance gate = kink), #316 One-Cycle (schedule = kink).

### D6: Three-Body RLCT Decomposition
Each component may have a different local RLCT:
  lambda_x = RLCT at averaged iterate x_t (output RLCT)
  lambda_y = RLCT at extrapolated iterate y_t (gradient RLCT)
  lambda_z = RLCT at base iterate z_t (trajectory RLCT)
Conjecture: lambda_x <= min(lambda_y, lambda_z) because averaging
places x_t in a lower-complexity region. The generalization is
controlled by lambda_x (the output point), not lambda_z.

### D7: No-Schedule Stratum Selector Absence
Schedule-Free has NO stratum selector: no external schedule (#316),
no variance gate (#611), no irreversible accumulation (#605),
no bias correction (#610). The ONLY mechanism is the PR averaging
weight c_t = 1/(t+1). The stratum dynamics are determined entirely
by the GEOMETRY of the loss landscape and the averaging path.

### Claims Formalization

C1 (PROVEN): Phi is R_{an,exp}-definable.
Proof: Phi is composed of affine maps (linear interpolation,
weighted average) and nabla L. If L is R_{an,exp}-definable,
nabla L is definable (gradient preserves definability in R_{an,exp}
by Wilkie's theorem). c_t = 1/(t+1) is a rational function,
definable. QED.

C2 (CONJECTURAL): Three-body singular fiber dynamics.
The state S_t = (x_t, y_t, z_t) lives in R^{3d}. The singular fiber
F_S = {(x,y,z) : L(y) = L*, nabla L(y) = 0} is a fiber in the
3d-dimensional space. x_t, y_t, z_t may lie in different
projections of F_S onto each R^d factor. The averaging path
x_t crosses fibers smoothly (lambda(x_t) continuous in t).

C3 (CONJECTURAL): Shadow stratum from y_t.
If z_t in Sigma_j, x_t in Sigma_k, y_t = (1-beta)*z_t + beta*x_t
lies on the segment [z_t, x_t]. The gradient nabla L(y_t) probes
the stratum containing y_t, which may differ from both Sigma_j
and Sigma_k. This creates gradient information from a stratum
not occupied by z_t — a "shadow stratum" Sigma_shadow(y_t).
The shadow stratum injects gradient bias B_shadow.

C4 (CONJECTURAL): Generalization bound.
GenBound_SF = lambda_x * log(n) / (2n) + B_shadow / sqrt(n)
where lambda_x is the RLCT at the averaged iterate x_t, and
B_shadow captures the shadow-stratum gradient bias.
Conjecture: B_shadow < 0 when beta is small (y_t close to z_t,
minimal shadow), B_shadow > 0 when beta is large (y_t close to
x_t, large shadow). Optimal beta balances exploration vs bias.

C5 (CONJECTURAL): No phase transition (smooth stratum crossing).
The LLC trajectory lambda(x_t) is CONTINUOUS in t — no kink,
no phase transition. This is because PR averaging produces a
continuous path with no discrete switching. FALSIFIABLE:
if LLC trajectory under Schedule-Free shows any kink, C5 is false.
Contrast: #605 (irreversible freezing), #611 (variance kink),
#316 (scheduled kink), #394 SWA (cycle boundary kink).

### Open Problems
1. Prove lambda(x_t) continuity under PR averaging (C5 core).
2. Characterize the three-body fiber F_S in R^{3d} — is it
   connected? What is its RLCT?
3. Derive B_shadow as function of beta, c_t, and stratum geometry.
4. Is lambda_x <= lambda_z always? Under what conditions?
5. Compare smooth crossing (SF) vs kink crossing (#611 RAdam).
6. Does the shadow stratum accelerate or hinder stratum access?
7. Connection to Watanabe's Bayesian posterior mean — is PR
   averaging a frequentist analog of posterior expectation over
   singular fibers?

### Cross-References
#226 (EMA), #394 (SWA), #476 (Nesterov), #420 (Lookahead),
#316 (One-Cycle), #611 (RAdam), #610 (NAdam), #289 (Adam),
#354 (SGD), #605 (Adagrad), #100 (Momentum), #232 (Model Soup),
#480 (muP)