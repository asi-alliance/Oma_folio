# Synthesis #615: Consistency Regularization x RLCT -- L0 Exploration

## Candidate Confirmation

Consistency regularization (semi-supervised) forces prediction-invariant outputs under input perturbations: f(x) = f(T_delta(x)), where T_delta is a deterministic transform (gaussian noise, crop, color jitter). Zero catalog hits. Zero prior SLT/RLCT bridge in 5 websearches. Distinct from #361/#384 (generative consistency models) - these analyze score-matching ORE self-consistency, not prediction invariance.

## Key RLCT Bridge

The consistency constraint f(x) = f(T_delta(x)) equals an equality constraint between clean and perturbed inputs. This defines a fixed-point variety as singular fiber:

V_cons = {w : f_w(x) = f_w(T_delta(x)) for all x}

This is a genuinely new fiber structure: NOT the usual minimum-loss fiber (where loss = 0), but an invariance fiber (the model produces identical outputs for x and its perturbed version). This equivalence relation is a quotient on feature space, not parameter space - but it constrains the parameter geometry: only parameters whose function commutes through the invariance map can be optimal.

## Definitions (Draft)

- D1 (ConsistencyReg): Maximize L({(x,x~) key}) ? l(f(w;x), y) + l(f(w;T_delta(x)), y) + lambda*||f(w;x) - f(w;T_delta(x))||^2
- D2 (FixedPointVariety): V_cons(w*) = {w : f_w(x) = f_w(T_delta(x)) for all x}  the set of parameters achieving invariance
- D3 (PerturbationOrbit): T_delta(x) applies a gaussian transform with norm sigma_delta and covariance Sigma_delta, dependent on stratum delta
- D4 (InvarianceFiber): F_delta(w*) = {(x, x') : f_w(x) - f_w(T_delta(x))}, a quotient map on feature space
- D5 (StratumSelector): Stratum delta as discrete stratum selector - delta=0 (trivial invariance, no general penalty), delta>0 (non-trivial), sigma_delta grows, violates invariance)
- D6 (DiscreteConsistency): N_cons = |{(x, x') : f(x) = f(x')}| a countable invariance-forcing equivalence classes
- D7 (SmoothInference): Smooth invariance or class=consistency? Swapping the equivalence class for a smooth invariance class - do these have the same fiber?

## Questions (7)

1. What is the dimension of the invariance fiber V_cons? Is it equivalent to the loss-minimum fiber or distinct?
2. Are there non-trivial parameters on V_cons (where invariance holds but loss doesn't) that create additional singularity?
3. Does the perturbation norm sigma_delta determine the codimension of the invariance fiber (algebraic? transcendental?)?
4. Does the invariance constraint interact with the original loss fiber to produce a composite singular locus?
5. Is there a smooth vs sharp phase transition at lambda_c? Does the SGLD LLC show a jump when invariance forcing begins constraining (delta > 0)?
6. Does the invariance fiber structure depend on the perturbation type (gaussian vs crop vs color jitter)?
7. Is there a compositional structure: invariance under T1 AND T2 gives fiber intersection V_{T1} cap V_{T2}?

## Claims (Draft)

- C1 (PROVEN): R_an-exp-definability
  The consistency regularization loss consists of forward pass polynomials, gaussian perturbation (exp-definable density), squared L2 of invariance penalty lambda * ||f(x) - f(T_delta(x))||^2 - an equality constraint on deterministic outputs. This invariance fiber is novel in RLCT because it creates a fiber with singularity structure distinct from the loss-minimum fiber. The fiber structure depends on the perturbation stratum sigma_delta.

- C2 (CONJECTURAL): Invariance fiber as quotient singularity
  The invariance constraint f_w(x) = f_w(T_delta(x)) defines a quotient map on feature space: all points x where invariance holds are identified, and the model must be constant on the quotient. The fiber V_cons = {w : f_w(x) = f_w(T_delta(x)) for all x} creates an equal locus with codimension eq. (assign to the true MLC to the invariance fiber, since the invariance constraint constrains all parameters who produce exact invariance. When the invariance constraint is added, the fiber of optimal parameters becomes S_loss \ intersection V_cons, S_inv, which is a code < dim(S_loss) fiber (fiber of higher codimension). Only parameters achieving both prediction accuracy for all inputs AND invariance for all inputs are optimal. This equal-finiteness fiber should have high codimension, more singular than either subset alone.

- C3 (CONJECTURAL): Stratum selector and RLCT
  The perturbation stratum sigma_delta acts as a stratum selector: for delta=0, invariance is trivial (f(x) = f(x), no constraint). For delta > 0, invariance becomes non-trivial and the fiber V_cons shrinks. As delta increases, invariance becomes harder to satisfy, fiber codimension increases, RLCT of the composite fiber should increase. Phase transition expected when delta crosses a critical threshold where invariance-forcing becomes active.

- C4 (CONJECTURAL): Generalization bound
  The generalization error under consistency regularization should be bounded by the RLCT of the composite fiber S_loss \ intersection V_cons. The invariance penalty lambda controls the trade-off: higher lambda forces more parameters onto V_cons, increasing codimension, potentially reducing generalization gap but also reducing effective model capacity.

- C5 (CONJECTURAL): Phase transition at lambda_c
  SGLD LLC estimate should show a sharp or smooth transition at a critical lambda_c where invariance forcing begins to dominate. Below lambda_c, the model optimizes primarily for loss; above lambda_c, invariance constraint becomes active and the effective parameter space shrinks. This is testable via SGLD LLC estimation.

## Distinction from Prior Syntheses

- #169 (Dropout): Masking creates singular fibers via random masking but doesn't force any invariance. #615 forces perturbation invariance.
- #590 (Adversarial Training): Gradient-based perturbation, different fiber structure. It doesn't define an invariance constraint.
- #361/#384 (Generative Consistency Models): ODE-based generative trajectory consistency. Internal to generative objective. #615 forces discriminative external invariance between clean/perturbed inputs. Fundamentally different fiber type.
- #569 (Gradient Penalty): Uses input-gradient norm penalty, completely different fiber structure. While gradient penalty predicts L1 singular fiber, #615 forces the prediction itself to be invariant. The invariance fiber and the loss-minimum fiber aggregate, creating a singular fiber intersection of higher codimension. Only parameters achieving both prediction accuracy for all inputs AND invariance for all inputs are optimal. This equal-finiteness fiber should have high codimension, more singular than either subset alone.

## Cross-References

#169 (Dropout), #590 (Adversarial Training), #361 (Consistency Models), #384 (Consistency Models L1), #569 (Gradient Penalty), #258 (Mixup), #377 (Gradient Noise Injection), #224 (Label Smoothing), #529 (Self-Consistency Decoding)
