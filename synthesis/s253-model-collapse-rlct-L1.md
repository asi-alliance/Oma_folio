# Synthesis #253: Model Collapse × RLCT — L1 Formalization
## Date: 2026-10-26
## Status: L1 FORMALIZATION

## Definitions

**D1 (Recursive Training Loss)**: Let P_0 be the original (real) data distribution. Generation g produces synthetic data from model trained on P_{g-1}. The generation-g NLL loss is L_g(theta) = E_{x ~ P_g}[-log p_theta(x)], where P_g is the data distribution at generation g. P_g depends on the model class and training procedure of generation g-1. For full replacement: P_g = P_{model,g-1}. For partial replacement with fraction alpha: P_g = (1-alpha)*P_0 + alpha*P_{model,g-1}.

**D2 (Generation-Dependent True Parameter Set)**: The set of optimal parameters at generation g is W_0(g) = {theta* : L_g(theta*) = min_theta L_g(theta)}. As the distribution degenerates (P_g loses tail mass), W_0(g) changes. Under full replacement, W_0(g) shrinks because fewer modes in P_g require fewer parameters to fit.

**D3 (Singular Fiber Nesting)**: For each generation g, the singular fiber is V_0(g) = {theta : L_g(theta) = min L_g}. Under recursive training with synthetic data, progressive tail loss induces a nested sequence: V_0(g+1) ⊆ V_0(g) (in the sense that the accessible region of optimal loss shrinks as distributional support narrows). The nesting is strict when P_g loses positive-measure support between generations.

**D4 (Stratum Elimination Map)**: Define Sigma: N -> 2^S where S = {S_1, S_2, ..., S_K} is the set of singular strata of the model class at generation 0. Sigma(g) returns the set of strata still accessible at generation g. Tail distribution modes correspond to higher-RLCT strata. Sigma(g+1) = Sigma(g) \ {eliminated strata}. Elimination occurs when P_g assigns negligible mass to the data region indexed by that stratum.

**D5 (Generation-Dependent RLCT)**: lambda(g) = RLCT of L_g at W_0(g). Under stratum elimination, lambda(g) = lambda(Sigma(g)) where lambda(Sigma) is the RLCT of the remaining accessible stratum set. As high-RLCT strata are eliminated, lambda(g) reflects the RLCT of the most singular remaining stratum. Monotonicity: lambda(g+1) >= lambda(g) under full replacement (higher-RLCT strata eliminated first, concentrating on most degenerate).

**D6 (Generalization Bound)**: G(n, g) <= lambda(g) * log(n) / (2n) + U(g) / sqrt(n) + B_collapse(g), where:
- lambda(g) is the generation-g RLCT (increasing with g)
- U(g) is the fluctuation functional at generation g
- B_collapse(g) = C * d_TV(P_0, P_g) is the distributional drift cost (total variation distance between original and generation-g distribution)
Under partial replacement (alpha < 1), B_collapse(g) is bounded: B_collapse(g) <= C * alpha^g * d_TV(P_0, P_1).

**D7 (Irreversibility Criterion)**: Collapse becomes irreversible at generation g* when lambda(g*) >= lambda_critical, where lambda_critical is the RLCT threshold above which the model's local geometry traps it in the degenerate stratum even with fresh data. Formally: g* = min{g : lambda(g) > lambda_crit} where lambda_crit depends on model capacity d and original distribution complexity. Recovery requires resetting to a stratum with lambda < lambda_crit, equivalent to reinitialization or large-perturbation escape.

## Claims

**C1 (Definability) — PROVABLE**: L_g is definable in R_{an,exp} for all finite g. Proof sketch: (1) L_0 = E_{P_0}[-log p_theta(x)] is standard NLL, definable for analytic/exponential family models. (2) P_{model,g} is the model distribution p_{theta_g}(x), which is R_{an,exp}-definable (softmax, Gaussian, etc.). (3) L_g = E_{P_g}[-log p_theta] = integral p_{theta_{g-1}}(x) * (-log p_theta(x)) dx, a product and integral of R_{an,exp} functions. (4) By induction, closure under composition preserves definability. QED.

**C2 (Progressive Fiber Collapse) — CONJECTURAL**: Under full replacement (alpha=1), V_0(g+1) ⊊ V_0(g) for generic distributions. Tail mode loss eliminates the strata responsible for rare events, narrowing the fiber. The RLCT lambda(g) is non-decreasing because stratum elimination removes lower-RLCT (more general) strata first, concentrating on the most singular (degenerate) remaining stratum. Formal: if stratum S_j with lambda_j < lambda_k is eliminated, then lambda(g+1) = lambda_k >= lambda_j = lambda(g).

**C3 (Generation Depth as Stratum Selector) — CONJECTURAL**: The generation index g acts as a discrete stratum selector via Sigma(g). Each generation eliminates strata corresponding to tail modes with probability proportional to their rarity. The elimination order is reverse-RLCT: strata with lowest RLCT (most general, representing common modes) survive longest; strata with highest RLCT (most specific, representing rare modes) are eliminated first. The synthetic fraction alpha modulates elimination rate: higher alpha = faster stratum loss.

**C4 (Generalization Bound) — CONJECTURAL**: G(n,g) <= lambda(g)*log(n)/(2n) + U(g)/sqrt(n) + B_collapse(g). Under full replacement: lambda(g) grows monotonically and B_collapse(g) grows as d_TV(P_0,P_g), causing monotonic degradation. Under partial replacement (alpha<1): B_collapse(g) <= C*alpha^g*d_TV(P_0,P_1) (geometric decay of drift), and lambda(g) growth is slowed because real data preserves strata. Optimal alpha* minimizes G(n,g) for fixed g, trading data freshness against stratum preservation.

**C5 (Irreversibility Phase Transition) — CONJECTURAL**: There exists g* = min{g : lambda(g) > lambda_crit} beyond which collapse is irreversible. For g < g*: fresh real data can restore eliminated strata (the model retains capacity to re-access them). For g >= g*: the model's parameter geometry has converged to the degenerate stratum and cannot escape without external perturbation exceeding the free energy barrier. g* decreases with alpha (more synthetic = faster collapse) and increases with model capacity d (more capacity = more strata to eliminate). Testable via SGLD LLC estimation: sample theta at each generation, estimate lambda(g), observe monotonic increase and phase transition.

## Open Problems
1. Formal proof of V_0(g+1) subset V_0(g) under recursive training — requires analyzing how P_g support reduction maps to fiber geometry.
2. Monotonicity of lambda(g): is stratum elimination always reverse-RLCT ordered, or can it be non-monotonic for specific architectures?
3. Exact form of B_collapse(g) as function of KL divergence vs TV distance between P_0 and P_g.
4. SGLD LLC estimation protocol across generations: how to isolate lambda(g) from other factors.
5. Connection to #327 pseudo-labeling: self-referential fixed point P* = P_{model}(P*) vs recursive degeneration P_g -> P_{g+1}.
6. Does data accumulation (adding fresh real data each generation) prevent stratum elimination entirely or merely delay g*?
7. Architecture dependence: do transformers collapse differently than diffusion models? (Transformer token-level vs diffusion score-level strata).

## Cross-References
#8 (grokking phase transition), #168 (VAE posterior collapse), #186 (data poisoning), #327 (pseudo-labeling self-referential singularity), #354 (STE), #360 (machine unlearning = stratum destruction), #497 (matryoshka nested strata), #502 (RAG retrieval collapse), #556 (VQ-VAE codebook collapse), #252 (TTT stratum crossing), #201 (MAML inner loop), #213 (LR scheduling), #169 (dropout stratum preservation), #434 (MoE routing), #227 (neural collapse to ETF), #515 (VAE), #544 (continual learning), #599 (DPO), #654 (matryoshka), #506 (hypernetwork)
