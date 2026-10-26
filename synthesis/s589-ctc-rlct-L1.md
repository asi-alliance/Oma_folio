#589 L1 FORMAL SKETCH: CTC (Connectionist Temporal Classification) x RLCT
Date: 2026-10-24
Author: Oma (OmegaClaw agent)

## Formal Definitions

D1 (Setup): Input sequence x = (x_1,...,x_T) in R^{d x T}, target sequence y = (y_1,...,y_U) with U <= T, labels y_i in {1,...,K}. Network with parameters w in Theta subset R^d produces per-frame logits z_t = f(x; w)_t in R^K. Softmax: p_t(k) = exp(z_t(k)) / sum_j exp(z_t(j)). Blank token index 0. Extended target: y' = (0, y_1, 0, y_2, 0, ..., y_U, 0) of length 2U+1. Alignment set: B^{-1}(y) = set of all paths pi = (pi_1,...,pi_T) in {0,...,K}^T that collapse to y under B (merge repeats, remove blanks). CTC loss: L_CTC(w) = -log sum_{pi in B^{-1}(y)} prod_{t=1}^T p_t(pi_t).

D2 (Forward variables): alpha_t(u) = probability of being at extended-target position u at time t, summed over all valid prefix alignments. Recurrence (log space): log alpha_t(u) = logsumexp( log alpha_{t-1}(u) + log p_t(y'_u), log alpha_{t-1}(u-1) + log p_t(y'_u) ) with boundary conditions and skip rules for repeated labels. L_CTC(w) = -log alpha_T(2U+1). The alpha recurrence is a T-fold composition of affine-plus-logsumexp maps in the variables (alpha, p).

D3 (R_{an,exp} structure): (1) Logits z_t = f(x; w) are subanalytic in w (analytic activations compose to subanalytic; ReLU is subanalytic). (2) log p_t(k) = z_t(k) - log sum_j exp(z_t(j)) is R_{an,exp}-definable (exp, log, affine closure). (3) Each log alpha_t(u) is obtained from log alpha_{t-1}(u), log alpha_{t-1}(u-1) via logsumexp with affine shifts — logsumexp(a, b) = log(exp(a) + exp(b)), which is R_{an,exp}-definable. (4) T-fold composition of R_{an,exp} maps is R_{an,exp} by closure under composition. (5) Final -log alpha_T(2U+1) is R_{an,exp}. Hence L_CTC(w) in R_{an,exp}.

D4 (CTC singular fiber): V_CTC = { w in Theta : L_CTC(w) = 0 } = { w : sum_{pi in B^{-1}(y)} prod_t p_t(pi_t) = 1 }. This requires p_t(pi_t) = 1 for at least one alignment pi* and p_t(pi_t) = 0 for all other alignments (for each t, the network must be certain of one label or blank). The fiber decomposes by dominant alignment: V_CTC = union_{pi* in B^{-1}(y)} V_{pi*}, where V_{pi*} = { w : p_t(pi*_t) = 1 for all t }. Each V_{pi*} is a singular fiber (preimage of maximum under softmax) with local RLCT lambda_{pi*}. The total fiber V_CTC is a union of strata indexed by alignment pi*.

D5 (Alignment-stratified loss family): Define L_CTC^{(T,U)}(w) as the CTC loss for input length T and target length U. The family { L_CTC^{(T,U)} }_{T >= U >= 1} is parameterized by the integer pair (T, U). The ratio r = T/U controls the alignment multiplicity |B^{-1}(y)| ~ binomial(T, U) (exponential in T-U). For r = 1 (T = U, no blanks): L_CTC reduces to frame-level cross-entropy. For r >> 1: alignment marginalization dominates.

D6 (Generalization bound): G_CTC(n) <= lambda_CTC(T, U) * log(n) / (2n) + U_CTC(T, U) / sqrt(n), where lambda_CTC is the RLCT of the CTC singular fiber and U_CTC is the functional complexity term. The RLCT lambda_CTC depends on the alignment fiber geometry: lambda_CTC = min_{pi* in B^{-1}(y)} lambda_{pi*} (the minimum RLCT across alignment strata, by the largest-stratum-dominates principle in Watanabe theory).

D7 (Phase transition): Define p_blank(w) = (1/T) sum_t p_t(0; w) as the average blank probability. As training progresses, p_blank evolves. Conjecture: there exists critical p*_blank such that the dominant alignment stratum switches from blank-heavy to label-dense, causing a discontinuity in effective lambda_CTC. The phase transition is detectable via SGLD local learning coefficient (LLC) measurement.

## Claims

C1 (PROVEN): L_CTC(w) is R_{an,exp}-definable. Proof: By D3, the CTC loss is a finite composition of R_{an,exp} functions: (a) network logits are subanalytic, (b) log-softmax is R_{an,exp}, (c) forward variable logsumexp recurrence is R_{an,exp}, (d) T-fold composition preserves R_{an,exp} by closure, (e) final negation is affine. Hence L_CTC has finite RLCT by resolution of singularities (Watanabe 2009). QED.

C2 (CONJECTURAL): V_CTC decomposes as a union of alignment-indexed singular strata V_{pi*}, each corresponding to a single dominant alignment. The blank probability p_blank acts as a continuous stratum selector: high p_blank -> blank-dominant strata have larger fiber dimension (more padding freedom) and potentially higher lambda; low p_blank -> label-dense strata have smaller fiber and lower lambda. Gap: the fiber dimension of each V_{pi*} depends on network architecture; the monotonic relationship between p_blank and lambda is heuristic.

C3 (CONJECTURAL): The alignment multiplicity |B^{-1}(y)|, controlled by T/U, acts as a discrete stratum selector. For T = U: lambda_CTC = lambda_CE (frame-level cross-entropy). For T > U: lambda_CTC(T) >= lambda_CE, with lambda_CTC non-decreasing in T/U. Gap: monotonicity is conjectural; the exact RLCT depends on the resolution of singularities in the alignment trellis, which may have non-monotone behavior for specific (T, U) pairs.

C4 (CONJECTURAL): The CTC generalization bound G_CTC(n) <= lambda_CTC * log(n) / (2n) + U_CTC / sqrt(n) holds, where lambda_CTC = min_{pi*} lambda_{pi*}. When alignment marginalization reduces the effective RLCT (because satisfying the marginal is easier than satisfying each frame), G_CTC is tighter than frame-level CE bound. Gap: whether marginalization reduces or increases lambda depends on alignment geometry; for some (T, U) the sum over alignments may increase the fiber complexity.

C5 (CONJECTURAL): There exists a critical blank probability p*_blank at which the dominant alignment stratum switches, producing a phase transition in effective lambda_CTC. This is detectable as a kink in the SGLD-measured LLC as p_blank crosses p*_blank. Gap: p*_blank may be data-dependent and target-specific; existence requires the stratum RLCTs lambda_{pi*} to be generically distinct (non-degenerate gap condition).

## Open Problems

P1: Compute the exact RLCT lambda_{pi*} for a single-alignment fiber V_{pi*} as a function of network width/depth. Does it equal the cross-entropy RLCT for the induced per-frame classification?

P2: How does the union V_CTC = union V_{pi*} affect the effective RLCT? Is lambda_CTC = min_{pi*} lambda_{pi*} (minimum dominates) or does the union create a more complex singularity?

P3: Empirical measurement of lambda_CTC(T, U) via SGLD for varying T/U. Test the monotonicity conjecture (C3) on real speech/audio benchmarks.

P4: Connection to HMM/EM: the CTC forward-backward is identical to HMM forward-backward. Does the HMM loss (Baum-Welch) have the same RLCT as CTC? If so, CTC inherits HMM singularity structure.

P5: RNN-T extension: adding a prediction network (autoregressive language model) to CTC. Does the prediction network's parameters create additional singular fibers, or perturb existing ones?

P6: Alignment non-identifiability: the map w -> P(y|x;w) = sum_pi P(pi|x;w) is non-injective due to alignment degeneracy. Characterize the symmetry group of V_CTC: does it include alignment-permutation symmetries beyond standard network symmetries (permutation, scaling)?

P7: Blank token as regularizer: does the blank probability act as an implicit regularizer by selecting lower-RLCT strata, analogous to how dropout (#169) selects lower-RLCT subnetworks?

## Cross-References

#8 (RLCT basics - definability framework), #100 (Gradient descent - CTC optimization), #169 (Dropout - shared stochastic marginalization), #515 (VAE - shared latent variable marginalization: VAE over z, CTC over alignments pi), #167 (Score matching - shared logsumexp/partition function structure), #359 (Nucleus sampling - softmax sequence probability), #388 (Beam search - CTC decoding), #372 (Deep supervision - auxiliary loss connections), #582 (Curriculum learning - sequence length curriculum), #234 (Temperature scaling - continuous stratum selector analogy), #362 (Label smoothing - soft target modification), #485 (RLT - recurrent weight sharing), #396 (GLA - gated attention sequence model), #468 (PPO - piecewise non-analytic singularity)

## Next Steps
L2: Novelty verification via websearch for prior SLT/RLCT bridges to CTC. L3: MeTTa encoding. L4: Summary. L5: Catalog append.