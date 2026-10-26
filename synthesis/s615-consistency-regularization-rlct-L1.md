# Synthesis #615: Consistency Regularization x RLCT -- L1 Formalization

## Formal Definitions

### D1 (ConsistencyRegularizedLoss)
Let f_w: X -> Y be a neural network with parameters w in R^d. Let T_delta: X -> X be a perturbation operator parameterized by stratum delta (e.g., gaussian noise with std delta). The consistency-regularized empirical loss is:

L_cons(w) = (1/n) sum_{i=1}^{n} [ l(f_w(x_i), y_i) + l(f_w(T_delta(x_i)), y_i) ] + lambda * ||f_w(x_i) - f_w(T_delta(x_i))||^2

where l is the per-sample loss (cross-entropy or MSE), lambda >= 0 is the consistency penalty weight.

### D2 (InvarianceFiber)
The invariance fiber is the set of parameters achieving exact prediction invariance under T_delta:

V_cons(delta) = { w in R^d : f_w(x) = f_w(T_delta(x)) for all x in X }

This is an algebraic variety defined by the equality constraints f_w(x) - f_w(T_delta(x)) = 0 for all x. It is NOT the loss-minimum fiber V_loss = {w : L(w) = L_min}.

### D3 (PerturbationOrbit)
For each input x, the perturbation orbit is O_delta(x) = { T_delta(x) : delta in [0, delta_max] }. For gaussian perturbation T_delta(x) = x + delta * epsilon (epsilon ~ N(0, Sigma)), the orbit is a continuous family. The invariance constraint requires f_w constant on each orbit O_delta(x).

### D4 (QuotientMap)
The invariance equivalence relation ~_delta on input space X is: x ~_delta x' iff x' = T_delta(x) for some delta. The quotient space X/~_delta identifies all perturbed versions of x. The invariance fiber V_cons consists of parameters w such that f_w factors through the quotient map pi: X -> X/~_delta, i.e., f_w = g_w . pi for some g_w.

### D5 (StratumSelector)
The perturbation magnitude delta acts as a stratum selector:
- delta = 0: T_0 = identity, invariance is trivial (f(x) = f(x)), V_cons(0) = R^d (full parameter space, no constraint)
- delta > 0: V_cons(delta) is a proper subvariety of R^d, codim increases with delta
- delta -> infinity: invariance requires f_w constant on all of X, V_cons -> {constant functions}, extreme singularity

The strata are V_cons(0) superset V_cons(delta_1) superset V_cons(delta_2) for 0 < delta_1 < delta_2.

### D6 (CompositeFiber)
The composite fiber of optimal parameters under consistency regularization is the intersection:

V_comp(lambda, delta) = V_loss cap V_cons(delta)

where V_loss = {w : L(w) = L_min} is the loss-minimum fiber. This intersection has codim(V_comp) = codim(V_loss) + codim(V_cons | V_loss), assuming transversality. The RLCT of the composite fiber lambda_comp >= max(lambda_loss, lambda_cons).

### D7 (GeneralizationBound)
By the Watanabe theorem, the generalization error under consistency regularization is:

G_cons(n) <= (lambda_comp / n) * log(n) + O(1/sqrt(n))

where lambda_comp is the RLCT of the composite fiber V_comp(lambda, delta). The penalty weight lambda controls the effective weighting between V_loss and V_cons: as lambda -> infinity, the optimizer is forced toward V_cons, increasing codimension and potentially increasing or decreasing lambda_comp depending on the geometry.

## Claims

### C1 (PROVEN): R_an,exp-definability
The consistency regularization loss L_cons consists of:
- Forward pass f_w(x): compositions of analytic functions (matrix multiplications, elementwise nonlinearities) -> real-analytic in w
- Gaussian perturbation T_delta(x) = x + delta * epsilon: exp-definable density (Gaussian measure is in the exp-definable class)
- Squared L2 penalty ||f_w(x) - f_w(T_delta(x))||^2: polynomial in f_w outputs -> real-analytic in w
- Cross-entropy loss l: analytic in the softmax/log-softmax outputs

Therefore L_cons is R_an,exp-definable, and the Watanabe theory applies. The RLCT lambda_cons is well-defined. QED.

### C2 (CONJECTURAL): Invariance fiber as quotient singularity
The invariance fiber V_cons(delta) is an algebraic variety defined by equality constraints f_w(x) = f_w(T_delta(x)). For generic networks, this variety is singular (non-smooth) because:
- The equality constraints are nonlinear in w (compositions of nonlinear functions)
- The Jacobian rank of the constraint map w -> {f_w(x) - f_w(T_delta(x))}_{x in X} drops at parameter configurations where the network has internal symmetries (permutation of hidden units, scaling symmetries)
- The quotient structure X/~_delta induces a quotient singularity on the parameter space when f_w must factor through pi

The RLCT of V_cons should reflect this quotient singularity structure. Conjecture: lambda_cons(delta) > 0 for delta > 0, and lambda_cons is a non-decreasing function of delta.

### C3 (CONJECTURAL): Stratum selector and RLCT modulation
The perturbation magnitude delta acts as a discrete stratum selector on the singularity structure:
- For delta = 0: V_cons = R^d, lambda_cons = 0 (no singularity from invariance)
- For delta in (0, delta*): V_cons is a proper subvariety, lambda_cons(delta) increases as codim increases
- For delta >= delta*: V_cons approaches constant-function fiber, lambda_cons saturates

The critical delta* is the perturbation scale at which the invariance constraint becomes maximally binding. This should manifest as a phase transition in the SGLD LLC estimate: a sharp or smooth jump as delta crosses delta*.

### C4 (CONJECTURAL): Generalization bound with composite RLCT
The generalization error under consistency regularization is bounded by:

G_cons(n) <= (lambda_comp / n) * log(n) + O(1/sqrt(n))

where lambda_comp = RLCT(V_loss cap V_cons(delta)). The key prediction: there exists an optimal lambda* that minimizes lambda_comp. For lambda < lambda*, the optimizer sits near V_loss (ignores invariance, lambda_comp ~ lambda_loss). For lambda > lambda*, the optimizer is forced onto V_cons but may sacrifice fit (lambda_comp ~ lambda_cons + capacity loss). The optimum lambda* balances invariance-induced singularity reduction against capacity loss.

### C5 (CONJECTURAL): Phase transition at lambda_c
The SGLD LLC estimate should show a phase transition at a critical penalty weight lambda_c:
- lambda < lambda_c: LLC ~ lambda_loss (invariance constraint inactive, model optimizes primarily for accuracy)
- lambda > lambda_c: LLC jumps or smoothly transitions to lambda_comp (invariance constraint becomes active, composite fiber geometry dominates)
- The transition may be sharp (first-order) if V_loss and V_cons intersect non-transversally, or smooth (second-order) if the intersection is transverse

This is testable via SGLD LLC estimation on models trained with varying lambda.

## Open Problems (7)

1. What is the codimension of V_cons(delta) as a function of delta for specific architectures (MLP, CNN, Transformer)?
2. Is the intersection V_loss cap V_cons transverse for generic data distributions? If not, what is the correction to the codimension formula?
3. Does the quotient singularity from X/~_delta induce a known singularity type (ADE, etc.) on V_cons?
4. How does lambda_comp depend on the perturbation type (gaussian vs crop vs color jitter)? Are they in the same universality class?
5. Can the phase transition at lambda_c be detected empirically via SGLD LLC, and is it sharp or smooth?
6. For compositional perturbations T1 AND T2, is V_cons(T1) cap V_cons(T2) = V_cons(T1 o T2)? This compositional structure is key for multi-augmentation consistency.
7. How does the invariance fiber interact with the NTK regime vs feature-learning regime? In the lazy/NTK limit, does V_cons become trivial?

## Cross-References

#169 (Dropout), #258 (Mixup), #377 (Gradient Noise Injection), #590 (Adversarial Training), #361 (Consistency Models), #384 (Consistency Models L1), #529 (Self-Consistency Decoding), #569 (Gradient Penalty), #224 (Label Smoothing), #545 (Sparse Attention), #605 (Adagrad), #609 (Sophia)
