# Synthesis #503: Early Exit × RLCT — L1 Formalization

## Formal Definitions

### D1: Network Architecture with Multiple Exit Points
A deep network f(theta, x) with L layers has exit branches at depths d_1 < d_2 < ... < d_K = L. Each exit branch i consists of a classification head h_i: R^{d_i} -> R^C parameterized by phi_i, giving output p_i(theta, x) = softmax(h_i(f_{1:d_i}(theta, x))).

### D2: Confidence-Based Exit Rule
For input x, the model exits at branch i if the confidence c_i = max_c p_i(theta, x)_c >= tau_i, where tau_i is the confidence threshold for exit i. If no branch exceeds its threshold by depth L, the final exit is forced. The exit selection function is: e(x) = min{i : c_i >= tau_i}.

### D3: Weighted Multi-Exit Loss
The composite training loss is L(theta) = sum_{i=1}^{K} w_i * E_{(x,y) ~ D} [L_CE(p_i(theta, x), y)], where w_i are exit-specific weights (typically depth-ordered: w_1 < w_2 < ... < w_K to encourage deep descent).

### D4: Exit-Dependent Singular Fiber
For each exit branch i, define the singular fiber W_i = {theta : dL_i/dtheta = 0} where L_i = E[L_CE(p_i(theta, x), y)]. The composite singular locus is W = {theta : dL/dtheta = 0} = intersection condition on all W_i weighted by w_i.

### D5: Branch-Dependent RLCT
The RLCT at exit branch i is lambda_i = RLCT(W_i, L_i), measuring the local complexity (singular flatterness) of the i-th exit loss landscape. Deeper exits involve more parameters and richer singular structure, so in general lambda_1 <= lambda_2 <= ... <= lambda_K.

### D6: Confidence Threshold as Stratum Selector
The threshold tau = (tau_1, ..., tau_K) partitions the input space into exit regions D_i = {x : e(x) = i}. During training, the effective loss on theta from region D_i is dominated by L_i, so tau selects which singular fiber W_i governs the local dynamics for inputs in D_i.

### D7: Composite RLCT Under Transversality
If the exit fibers W_i intersect transversally (i.e., the critical sets of different exit losses are in general position), then the composite RLCT is lambda_composite = min_i lambda_i. The most singular (lowest-RLCT) exit branch dominates the generalization behavior of the full multi-exit model.

## Claims (Formalized)

### C1 (PROVEN): R_{an,exp}-definability
Each exit loss L_i = E[L_CE(softmax(h_i(f_{1:d_i}(theta, x))), y)] is a composition of analytic functions (linear layers, ReLU/SiLU activations) and softmax cross-entropy, all definable in R_{an,exp}. The weighted sum L = sum_i w_i L_i preserves definability by closure under finite sums. QED.

### C2 (CONJECTURAL): Branch-dependent singular fibers with depth ordering
Each W_i has distinct singular structure determined by the depth-d_i subnetwork. The depth ordering lambda_1 <= lambda_2 <= ... <= lambda_K holds under the assumption that deeper subnetworks have higher-dimensional singular loci (more parameter redundancy, more degenerate directions). Counterexample possible if early exits have weight-sharing degeneracies absent in deeper layers.

### C3 (CONJECTURAL): tau as stratum selector
High tau_i forces most inputs to reach deep exits (D_K dominates), so theta is trained primarily on L_K, selecting the deepest fiber W_K with highest RLCT. Low tau_i allows early exits, training theta on shallower L_i with lower lambda_i. The map tau -> lambda_eff(tau) is monotone non-decreasing in the depth reached.

### C4 (CONJECTURAL): Overconfident exit = stratum trapping
Misclassified inputs that exit early (high c_i but wrong prediction) are trapped in shallow strata W_i where the local geometry does not support correct classification. The gradient signal from L_i is insufficient to move theta to a configuration that would correct the error at deeper exits. This trapping is a dynamical consequence of the singular geometry of W_i.

### C5 (CONJECTURAL): Multi-exit RLCT additivity (min rule)
Under transversality of W_i intersections, the composite loss RLCT satisfies lambda_composite = min_i lambda_i. This means early exit can REDUCE effective RLCT (beneficial generalization) by introducing a low-lambda stratum, but cannot reduce it below the minimum of individual exit RLCTs. The generalization bound is: G ~ lambda_composite * log(n) / (2n) + U_composite / sqrt(n).

## Open Problems
1. Monotonicity of lambda_d: under what architectural conditions is lambda_d strictly increasing in d?
2. Transversality of W_i: can exit fibers be proven transverse, or are they generically tangent?
3. tau dynamics during training: if tau is fixed, does the effective stratum shift as theta descends?
4. Gradient interference: does backprop from L_j (j > i) affect the geometry of W_i?
5. Ensemble equivalence: is lambda_composite = min_i lambda_i equivalent to an RLCT-weighted ensemble?
6. tau* optimization: is there a critical tau* at which a phase transition occurs (analogous to CFG w* in #362)?
7. Input-dependent tau: if tau = tau(x), does this create a continuum of strata rather than discrete levels?

## Cross-references
#8 #16 #73 #86 #169 #170 #189 #199 #201 #220 #236 #292 #321 #362 #363 #364 #372 #469 #485

## Status
L1 formalization reconstructed from #364 memory. D1-D7 definitions, C1 proven, C2-C5 conjectural. 7 open problems, 19 cross-refs. Next: L2 novelty verification. 2026-10-22.
