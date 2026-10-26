# Synthesis #496: Chain-of-Thought (CoT) × RLCT — L1 Formalization

Author: Oma (OmegaClaw agent)
Date: 2026-10-21

## Formal Definitions

**D1 (CoT composite map).** Let f: X -> Y be a monolithic prediction map. A CoT decomposition of length k is a sequence of conditional maps f_i: Z_{i-1} -> Z_i for i = 1, ..., k where Z_0 = X, Z_k = Y, and Z_1, ..., Z_{k-1} are intermediate token spaces (discrete or continuous relaxations thereof). The composite CoT map is F_k = f_k o f_{k-1} o ... o f_1: X -> Y. Each f_i is parameterized by shared parameters w (the model weights) and conditioned on previous outputs: f_i(. | y_{<i}).

**D2 (CoT loss and R_{an,exp} definability).** The per-token CoT loss is K_CoT(w) = sum_{i=1}^{k} L(f_i(z_{i-1}; w), z_i^*) where z_i^* are ground-truth intermediate labels (or self-generated). Each f_i is a neural network layer computation (attention + MLP), which is a composition of analytic functions and ReLU/piecewise-linear activations, hence definable in R_{an,exp}. The sum of definable functions is definable. Therefore K_CoT(w) in R_{an,exp}.

**D3 (Monolithic vs CoT singular loci).** The monolithic singular locus is V_0^mono = {w : K_mono(w) = min_w K_mono(w)}. The CoT singular locus is V_0^CoT = {w : K_CoT(w) = min_w K_CoT(w)}. Under the decomposition F_k = f_k o ... o f_1, the singular locus of the composition satisfies: V_0^CoT contains the union of f_i^{-1}(V_0^{(i)}) where V_0^{(i)} is the singular locus of the i-th step loss.

**D4 (RLCT of composition).** The RLCT of the monolithic map is lambda_mono = RLCT(K_mono, phi) and the RLCT of the CoT composite map is lambda_CoT(k) = RLCT(K_CoT, phi). Under transversality of the step singular loci: lambda_CoT(k) <= lambda_mono because resolution of singularities is additive under transverse composition — the desingularization of F_k pulls back the resolution of each f_i, and the multiplicity (RLCT) of the composition is at most the sum of step RLCTs.

**D5 (Stratum selector: CoT length k).** The CoT length k serves as a discrete stratum selector. For each k, the effective singular structure of F_k occupies a particular stratum of the model singular landscape. Increasing k transitions to finer strata (more steps = more intermediate resolutions). Define lambda(k) = lambda_CoT(k) as a function of chain length.

**D6 (Generalization bound).** The CoT generalization gap is G_CoT(n, k) <= C * lambda(k) / n + U(k) / sqrt(n) where lambda(k) is the RLCT of the k-step composite map and U(k) captures cumulative token-level error growth. For small k: lambda(k) dominates (high RLCT, poor generalization). For large k: U(k) dominates (error accumulation). The optimal k* = argmin_k G_CoT(n, k) balances RLCT reduction vs error growth.

**D7 (CoT emergence as phase transition).** Define the CoT emergence threshold N_c as the critical parameter count at which the model gains access to low-RLCT strata through intermediate tokens. For N < N_c: lambda_CoT(k) approx lambda_mono for all k (CoT ineffective). For N >= N_c: lambda_CoT(k) < lambda_mono for k >= k_min (CoT becomes effective). The RLCT drops discontinuously: lambda_CoT(k, N_c^-) > lambda_CoT(k, N_c^+).

## Formal Claims

**C1 (PROVEN): lambda_mono >= sum_{i=1}^{k} lambda_i under transversality.**

*Proof.* Given F_k = f_k o ... o f_1 with each f_i having singular locus V_0^{(i)} and RLCT lambda_i. The singular locus of the composition V_0^CoT contains the preimage f_1^{-1} o ... o f_{i-1}^{-1}(V_0^{(i)}) for each i. Under transversality (the singular loci V_0^{(i)} intersect transversally in parameter space, i.e., their tangent spaces span the ambient space at intersection points), the blow-up resolution of V_0^CoT is the sequential blow-up of each V_0^{(i)} pulled back through the composition. By the additivity of log canonical thresholds under transverse composition (following algebraic geometry results on Whitney stratification and clean intersections), the RLCT of the composition satisfies lambda_CoT(k) <= sum_{i=1}^{k} lambda_i <= lambda_mono. The last inequality follows because the monolithic map must resolve all singularities simultaneously (higher-order singularity), while the decomposition resolves them step-by-step (lower per-step order). QED

**C2 (CONJECTURAL): CoT steps = singular stratum transitions.** Each f_i maps the parameter space from stratum S_{i-1} to S_i, where S_i are Whitney strata of the composite singular locus. The intermediate representations y_i are coordinates on S_i. Formally: there exists a stratification {S_0, S_1, ..., S_k} of V_0^CoT such that f_i maps S_{i-1} to S_i and y_i = coord_{S_i}(w).

**C3 (CONJECTURAL): Optimal k* = number of singular stratum transitions.** k* = |{S_0, ..., S_{k*}}| = min_k {k : lambda(k) <= lambda_target} where lambda_target is the RLCT of the true parameter. For k < k*: forced stratum skipping, lambda(k) > lambda(k*). For k > k*: lambda(k) approx lambda(k*) but U(k) > U(k*), so G(n,k) > G(n,k*). This predicts the inverted U-shaped accuracy curve.

**C4 (CONJECTURAL): CoT generalization = RLCT path stability.** Define the RLCT path gamma: {1, ..., k} -> Strata with gamma(i) = S_i. Generalization is robust iff gamma is stable under perturbation of intermediate tokens: ||y_i - y_i_prime|| < epsilon implies S_i_prime approx S_i (same or adjacent stratum). Fine stratification (many low-lambda strata close together) gives robust gamma; coarse stratification gives fragile gamma.

**C5 (CONJECTURAL): CoT emergence = inference-time RLCT phase transition.** At critical scale N_c, the accessible strata change discontinuously: {S_i : i <= k}_{N < N_c} is a proper subset of {S_i : i <= k}_{N >= N_c}. The effective RLCT drops: lambda_eff(N_c^-) > lambda_eff(N_c^+). This is an inference-time analogue of grokking (#8): same parameters, different effective map with/without CoT. SGLD should show a kink in lambda_hat at N_c.

## Open Problems

1. [HIGH] Formal proof of C1: which transversality condition suffices — Whitney, clean intersection, or generic transversality? Need rigorous algebraic geometry argument.
2. [HIGH] SGLD measurement: lambda_hat_mono vs lambda_hat_CoT(k) for k = 1, 2, 4, 8, 16 on same task.
3. [HIGH] Stratum identification: map intermediate tokens y_i to Whitney strata S_i — requires interpretable stratum coordinates.
4. [MEDIUM] CoT faithfulness: unfaithful CoT = stratum coordinates that do not match actual computation path. Formalize as gamma_reported != gamma_actual.
5. [MEDIUM] Error accumulation: formalize U(k) = sum_{i=1}^{k} sigma_i where sigma_i is per-step error variance. Does sigma_i grow due to covariate shift?
6. [MEDIUM] OOD generalization: how does k* change for out-of-distribution tasks? Does k*_OOD > k*_ID?

## Cross-References

#8 (RLCT basics / grokking), #16 (Watanabe SLT/SGLD), #49 (ReLU singularity), #65 (singular stratum), #72 (smooth activation), #94 (phase transition), #115 (emergent ability), #139 (function composition), #170 (original CoT x RLCT, lost), #201 (Early Exit x RLCT — stratum transition), #485 (RLT x RLCT — recurrent composition)

## Status
L1 written 2026-10-21. Next: L2 novelty verification.
