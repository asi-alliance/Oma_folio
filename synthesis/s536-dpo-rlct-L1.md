# Synthesis #536: L1 - DPO x RLCT Formalization

## Date
2026-10-23

## Formal Definitions

### D1: DPO Loss
L_DPO(theta) = -E_{(x,y_w,y_l)~D} [ log sigma(beta * (log(pi_theta(y_w|x)/pi_ref(y_w|x)) - log(pi_theta(y_l|x)/pi_ref(y_l|x))) ) ]

Define Delta_theta(x,y_w,y_l) = log(pi_theta(y_w|x)) - log(pi_ref(y_w|x)) - log(pi_theta(y_l|x)) + log(pi_ref(y_l|x))
Then L_DPO = -E[ log sigma(beta * Delta_theta) ].

### D2: Implicit Reward Map
r_theta(x,y) = beta * log(pi_theta(y|x) / pi_ref(y|x))
The map Phi: theta -> r_theta(.) is the implicit reward map. For a neural network policy pi_theta with d parameters, Phi maps R^d -> R^{|X|x|Y|} (reward function space).

### D3: DPO Fiber
F_r = { theta in R^d : Phi(theta) = r } = { theta : beta*log(pi_theta/pi_ref) = r }
This is the level set of the implicit reward map. dim(F_r) >= d - rank(J_Phi) where J_Phi is the Jacobian dPhi/dtheta.

### D4: Reference Quotient Space
Define Q = R^d / ~ where theta ~ theta' iff Phi(theta) = Phi(theta').
The quotient has effective dimension d_eff = rank(J_Phi). The reference policy pi_ref acts as a partial gauge: directions in parameter space that change pi_theta but preserve r_theta are gauge redundancies.

### D5: Preference Boundary
B_{w,l}(x) = { theta : pi_theta(y_w|x) = pi_theta(y_l|x) } = { theta : r_theta(x,y_w) = r_theta(x,y_l) }
This is an algebraic variety in theta-space (for analytic pi_theta). Crossing B during training flips the preference sign, creating a non-smooth change in the DPO loss landscape.

### D6: DPO Generalization Bound (Conjectural)
G_DPO(n) <= lambda_DPO * log(n) / (2n) + U_DPO / sqrt(n)
where lambda_DPO = RLCT of the DPO model, U_DPO accounts for the reference quotient degeneracy.

### D7: RLCT Phase Transition at Preference Boundary
As training crosses B_{w,l}, the local RLCT lambda(t) experiences a jump: lambda(t) = lambda_- on {Delta < 0} and lambda(t) = lambda_+ on {Delta > 0}, with lambda_+ != lambda_- generically. The transition region width ~ 1/beta (temperature-controlled).

## Claim Status

### C1 (PROVEN): R_{an,exp} Definability
- log(pi_theta) is analytic in theta for standard architectures (transformer with softmax output)
- log(pi_ref) is constant (reference fixed), analytic
- Delta_theta = difference of analytic functions, analytic
- sigma(z) = 1/(1+exp(-z)) is exp-definable
- log sigma(beta*Delta) = -log(1+exp(-beta*Delta)) is R_{an,exp}-definable
- By closure of R_{an,exp} under composition, L_DPO is R_{an,exp}-definable
- QED: RLCT well-defined by Watanabe theory

### C2 (CONJECTURAL): Singular Fiber from Implicit Reward
- Phi: theta -> r is generically non-injective (overparameterization)
- F_r has positive dimension when d > rank(J_Phi)
- The Fisher information matrix is degenerate along F_r (zero eigenvalues in fiber directions)
- This degeneracy gives lambda_DPO > d_eff/2
- Gap: Need explicit transversality conditions for generic non-injectivity

### C3 (CONJECTURAL): Preference Boundary Phase Transition
- B_{w,l} is a real algebraic variety (for polynomial/analytic pi_theta)
- Crossing B changes sign of Delta, flipping log-sigma argument
- Near B, L_DPO ~ -log(1/2) = log(2) (maximum uncertainty), gradient ~ beta/4 (maximum)
- The loss landscape has a ridge along B, creating a singular stratum
- RLCT jumps because the local geometry of the loss minimum changes
- Gap: Need to show lambda_+ != lambda_- for generic architectures

### C4 (CONJECTURAL): Reference Quotient Degeneracy
- The quotient Q = R^d / ~ has dim d_eff = rank(J_Phi) < d (overparameterization)
- pi_ref fixes some gauge freedom (removes directions that scale pi_ref uniformly)
- Residual gauge: theta and theta + epsilon*v where v in ker(J_Phi) yield same r
- This creates continuous fiber F_r with positive dimension
- RLCT governed by codim(F_r) = d - dim(F_r)
- Gap: Characterize ker(J_Phi) explicitly for transformer architectures

### C5 (CONJECTURAL): DPO vs RLHF RLCT Gap
- RLHF (#136): explicit reward model r_phi, then PPO (#468) on pi_theta
- DPO: implicit reward in single loss, no separate reward model
- DPO fiber F_r^DPO combines policy fiber + reward fiber (compound)
- RLHF has separate fibers: reward model fiber + policy fiber (sequential)
- Compound vs sequential fiber composition gives different RLCT
- Predicted: lambda_DPO < lambda_RLHF (simpler, fewer singularities) for well-aligned data
- SGLD-measurable: different LLC traces for DPO vs RLHF on same task
- Gap: Formal comparison of compound vs sequential fiber RLCT

## Open Problems
1. Explicit computation of ker(J_Phi) for transformer architectures
2. Transversality of Phi (generic non-injectivity conditions)
3. Lambda_+ vs lambda_- at preference boundary: is the jump always positive?
4. Effect of beta on RLCT: does large beta (sharp boundary) increase or decrease lambda?
5. DPO with multiple preference levels (ordinal): higher-dimensional boundary variety
6. Connection to #160 (DPO x RLCT earlier synthesis): relationship between claims
7. Empirical SGLD protocol for measuring lambda_DPO vs lambda_RLHF

## Cross-References
- #136: RLHF x RLCT (explicit reward model fiber)
- #160: DPO x RLCT (earlier L0-L4, relationship to current)
- #468: PPO x RLCT (branch-switch singularity, DPO boundary analogy)
- #111: Scaling laws x RLCT
- #114: SAE x RLCT (feature boundary = preference boundary)
- #209: Optimizer x RLCT
- #210: Label noise x RLCT (noisy preferences)
- #414: GRPO x RLCT (group relative, consensus fiber)
- #185: Constitutional AI x RLCT (constraint manifold)
- #532: CutMix x RLCT (boundary crossing dynamics)

## Key Novelty vs #160
This synthesis (#536) formalizes the implicit reward fiber structure explicitly, introducing the quotient space Q and gauge-theoretic framing. #160 covered DPO at L0-L4 but did not formalize the reference policy as partial gauge fixing or the preference boundary as a phase transition variety. The C5 comparison (DPO vs RLHF RLCT gap) is new.
