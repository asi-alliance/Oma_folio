# Synthesis #536: L0 - Direct Preference Optimization (DPO) x RLCT

## Date
2026-10-23

## Topic
Direct Preference Optimization (DPO) as a singular statistical model classified by RLCT. The DPO loss bypasses explicit reward modeling by directly optimizing a policy from preference data, creating a non-identifiable parameter fiber.

## Claims

### C1 (PROVEN): DPO loss is definable in R_{an,exp}
The DPO loss L(theta) = -E_{(x,y_w,y_l)}[log sigma(beta * (log pi_theta(y_w|x)/pi_ref(y_w|x) - log pi_theta(y_l|x)/pi_ref(y_l|x)))] where sigma is sigmoid = exp-definable. The log-policy-ratio terms are analytic in theta (for standard architectures). The composition of log, exp (softmax), and sigmoid is R_{an,exp}-definable. By Watanabe theory, RLCT is well-defined for this model class.

### C2 (CONJECTURAL): DPO implicit reward creates singular fiber
The DPO objective optimizes an implicit reward r(x,y) = beta * log(pi_theta(y|x)/pi_ref(y|x)). The map theta -> r is not injective: multiple theta can yield the same reward function (overparameterization + reference policy quotient). The fiber of theta -> r has dimension = (param_dim) - rank(J_r), where J_r is the Jacobian of the reward map. This non-identifiability gives RLCT > d/2.

### C3 (CONJECTURAL): Preference boundary singularity = RLCT phase transition
The decision boundary {x : pi_theta(y_w|x) = pi_theta(y_l|x)} is where the DPO loss has maximum gradient curvature. Crossing this boundary (flipping a preference) creates a singular stratum. The RLCT jumps when a preference pair crosses the boundary during training, analogous to mode-switching in SAEs (#114) and strata crossing in scaling laws (#111).

### C4 (CONJECTURAL): Reference policy quotient creates degeneracy
The ratio pi_theta/pi_ref in DPO means theta and theta' that differ only in directions parallel to pi_ref's output space produce the same implicit reward. This quotient structure creates a continuous degeneracy (non-discrete fiber) with RLCT governed by the codimension of the quotient. The reference policy acts as a gauge-fixing condition that is only partial — residual gauge freedom remains.

### C5 (CONJECTURAL): DPO vs RLHF generalization gap = RLCT difference
DPO (direct) vs RLHF (reward model + PPO) have different RLCT because DPO's implicit reward creates a singular fiber that RLHF's explicit reward model does not (or vice versa). The empirically observed generalization difference between DPO and RLHF is governed by the difference in their RLCT values. SGLD-measurable as different LLC traces.

## Cross-References
- #111: Scaling laws x RLCT (DPO scaling = RLCT scaling)
- #114: SAE x RLCT (preference boundary = feature boundary analogy)
- #209: Optimizer x RLCT (DPO optimizer dynamics on singular landscape)
- #210: Label noise x RLCT (noisy preferences = noisy labels on singular strata)
- #211: MoE x RLCT (DPO with MoE backbone = expert routing + preference)

## Key Insight
DPO's elegance (bypassing reward modeling) creates a singular implicit-reward fiber. The non-identifiability of theta -> r (reward) is the geometric origin of DPO's generalization behavior. RLCT classifies this singularity, governing learning rate, generalization gap vs RLHF, and preference boundary phase transitions.
