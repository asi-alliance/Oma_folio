# Synthesis #608: Class Balancing / Long-Tail Learning × RLCT — L1 Formalization
## Date: 2026-10-25
## Status: L1 Formalization

## Formal Definitions (D1-D7)

### D1: Reweighted Loss Landscape
Let (X, Y) be a dataset with K classes, n_k = |{i : y_i = k}|, N = sum_k n_k. Define the class-balanced loss:
L_bal(w; w_vec) = -(1/N) sum_{i=1}^{N} w_{y_i} * log p(y_i | x_i; w)
where w_vec = (w_1, ..., w_K) in R_{>0}^K is the class weight vector. The standard CE is L_bal with w_vec = (1,...,1). The loss family {L_bal(.; w_vec)}_{w_vec} is a parameter-indexed family of analytic functions on the parameter space W.

The zero-loss set V_0(w_vec) = {w in W : L_bal(w; w_vec) = 0} = intersection over k of {w : p(k|x;w) = 1 for all (x,k) with n_k > 0}.

### D2: Class-Indexed Singular Fiber
For each class k, define the per-class singular locus S_k = {w in W : f_k(w) = 0} where f_k(w) = sum_{i: y_i=k} log p(k|x_i; w) is the class-k log-likelihood contribution. The reweighted singular variety is:
V_0^{bal} = union_k {w in S_k : w_k * n_k > 0}
Under class balancing, each S_k is geometrically weighted by w_k * n_k in the empirical loss. The fiber dimension and local multiplicity of V_0^{bal} at a point w depends on which classes achieve zero loss at w.

### D3: Effective Number Weight Function
The effective number of samples for class k is:
E_k(beta) = (1 - beta^{n_k}) / (1 - beta), beta in (0,1)
The effective-number weight is w_k^{eff} = N / (K * E_k(beta)). Properties:
- As n_k -> 0, E_k -> 0, w_k^{eff} -> infinity (upweight rare classes)
- As n_k -> infinity, E_k -> 1/(1-beta), w_k^{eff} -> N(1-beta)/K (finite ceiling)
- beta controls saturation: beta -> 0 gives inverse frequency, beta -> 1 gives uniform

### D4: Weight Vector as Stratum Selector
The weight vector w_vec in R_{>0}^K acts as a multi-dimensional continuous stratum selector. For each w_vec, the dominant stratum S_{k*}(w_vec) is the class whose singular locus has the largest scaled contribution w_{k*} * n_{k*} * lambda_{k*} to the local learning coefficient. Transitions in k*(w_vec) define stratum boundaries in R_{>0}^K.

### D5: Reweighted RLCT
Define lambda_bal(w_vec) as the RLCT of L_bal(.; w_vec). Under transversality (each S_k meets transversally at the minimizer w*):
lambda_bal(w_vec) = min_k (w_k * lambda_k)
where lambda_k is the per-class RLCT contribution (the RLCT of the loss restricted to class-k samples). Without transversality, lambda_bal is determined by the most singular intersection of class strata.

### D6: Reweighting Bias
Define the reweighting bias B_w = max_k |w_k - n_k/N|, measuring deviation of class weights from natural class frequencies. This appears as an additional term in the generalization bound arising from the distribution mismatch between the weighted empirical loss and the true population loss.

### D7: Tail-Length Parameter
Parameterize the class distribution as n_k proportional to k^{-rho} for rho > 0 (power-law long-tail). The tail-length parameter rho controls the severity of imbalance. Define rho* as the critical tail length where lambda_bal(w*) < lambda_CE for optimal weights w*, marking the threshold where class balancing becomes beneficial.

## Claims

### C1 (PROVEN): R_{an,exp} Definability
L_bal(w; w_vec) is definable in R_{an,exp}. Proof: w_k are constants (not functions of w), softmax p(y|x;w) = exp(z_y) / sum_j exp(z_j) is real-analytic, log is analytic on positive reals, finite sums preserve definability. E_k(beta) = (1 - exp(n_k log beta)) / (1 - beta) uses exp and division by constant, both in R_{an,exp}. QED.

### C2 (CONJECTURAL): Reweighted Singular Fiber
The reweighted singular variety V_0^{bal} differs geometrically from V_0^{CE}. Under transversality, lambda_bal = min_k (w_k * lambda_k). Minority classes with large w_k have their lambda contributions amplified, potentially making a minority stratum the dominant singularity. Gap: transversality conditions are generically satisfied but not proven for specific architectures.

### C3 (CONJECTURAL): Weight Magnitude as Stratum Selector
The weight vector w_vec continuously selects which class stratum dominates the RLCT. There exists a critical surface Sigma in R_{>0}^K where two class strata have equal scaled RLCT: w_j * lambda_j = w_k * lambda_k. Crossing Sigma changes the dominant stratum. Gap: the topology of Sigma and whether transitions are smooth or sharp depends on architecture.

### C4 (CONJECTURAL): Generalization Bound
G_bal = lambda_bal(w_vec) * log(n) / (2n) + B_w / sqrt(n) + U(w_vec) / sqrt(n)
The benefit of class balancing occurs when lambda_bal < lambda_CE and B_w is small. Optimal w* minimizes G_bal, which is NOT necessarily inverse frequency because the RLCT reduction (first term) trades off against the bias (second term). Gap: explicit form of U(w_vec) and tight bound on B_w.

### C5 (CONJECTURAL): Tail-Length Phase Transition
There exists rho* such that for rho < rho* (mild imbalance), lambda_CE is already low and class balancing provides marginal benefit. For rho > rho* (severe imbalance), the majority-dominated stratum has high lambda_CE and class balancing is essential. The effective-number reweighting smooths this transition because E_k saturation prevents over-correction. Gap: predicting rho* from architecture.

## Cross-References (12)
#8 CE #539 Focal #433 PolyLoss #536 DPO #372 Deep Supervision #95 Curriculum #548 Mixup #323 Label Smoothing #600 Domain Adaptation #515 VAE #169 Dropout #511 OT

## Open Problems (7)
1. Optimal w_k proportional to 1/lambda_k vs 1/n_k?
2. Effective-number beta as regularization on stratum selector?
3. Predict rho* from architecture and RLCT?
4. Focal Loss interaction: additive or multiplicative strata?
5. Desingularization of majority-class dominant stratum?
6. Adaptive weights from LLC during training?
7. Logit adjustment vs loss reweighting singular geometry?

## Provenance
Selected after exhaustive catalog screening 2026-10-25. Zero catalog hits, zero prior SLT/RLCT bridge. Candidate emerged from systematic coverage-gap analysis post-#607 AdaFactor. Provenance recorded per Paul Tiffany advice.
