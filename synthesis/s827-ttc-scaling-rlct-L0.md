# Synthesis #827 L0: Test-Time Compute Scaling x RLCT
## Date: 2026-10-29
## Pipeline: L0 <- L1 L2 L3 L4 L5

## Background
Test-time compute scaling refers to improving model outputs by allocating more inference-time computation. Strategies include best-of-N sampling, beam search, self-consistency voting, tree search (MCTS), verifier-guided reranking (PRM/ORM), and multi-step reasoning chains. Recent reasoning models (o1, R1) scale performance with inference compute. No prior work connects this to Singular Learning Theory / RLCT.

## Key Insight
Compute budget C acts as a CONTINUOUS stratum selector at inference time. Each strategy (best-of-N, beam search, self-consistency, tree search) accesses different singular strata of the learned parameter space. The unified RLCT framework subsumes individual mechanism analyses (#529, #538, #503, #602).

## Definitions
- **Inference strategy** S: a procedure mapping model f_w and input x to output y using compute budget C (e.g., N samples, beam width B, tree depth D, reasoning steps T).
- **Selection functional** Phi_S(f_w, x, C): the output selected by strategy S with budget C.
- **Effective RLCT** lambda_eff(S, C): the RLCT of the fiber accessed by strategy S at budget C.
- **Selection loss** L_S(w, C) = E_x[L(Phi_S(f_w, x, C), y)]: expected loss under strategy S with budget C.

## Five Claims

### C1 (PROVEN): R_{an,exp}-definability
The selection functional Phi_S is R_{an,exp}-definable for each strategy:
- Best-of-N: argmin over finite set (definable selection over finite domain)
- Beam search: finite-width path selection (piecewise definable)
- Self-consistency: argmax over count indicators (#529 C1 proven)
- Tree search: finite-depth tree minimization (definable over finite tree)
- Verifier reranking: argmax over score composition (#602 C1 proven)
- Reasoning chains: finite-step composition (definable via t-fold composition, #485 C1 proven)
The selection loss L_S(w, C) = E_x[L(Phi_S(f_w, x, C), y)] is R_{an,exp}-definable by closure under composition, finite sum, and definable selection.

### C2 (CONJECTURAL): Compute budget C as continuous stratum selector
For each strategy S, increasing C accesses lower-RLCT strata: lambda_eff(S, C) is non-increasing in C. Intuitively, more compute allows the strategy to find outputs closer to the true singular minimum, accessing lower-dimensional fibers. Different strategies at the same C access different strata: lambda_eff(S1, C) != lambda_eff(S2, C) in general.

### C3 (CONJECTURAL): Strategy-specific stratum access patterns
Each strategy has a characteristic stratum access pattern:
- Best-of-N: iid sampling accesses strata stochastically; lambda_eff ~ d/2 - alpha*log(N) (entropic exploration)
- Beam search: greedy-then-prune accesses connected stratum components; lambda_eff ~ d/2 - beta*log(B) (path-dependent)
- Self-consistency: majority vote collapses to dominant stratum (#529 C2-C3); lambda_eff saturates at dominant stratum RLCT
- Tree search: systematic exploration; lambda_eff ~ d/2 - gamma*D (depth-proportional, strongest descent)
- Verifier reranking: score-guided filtering; lambda_eff bounded by verifier RLCT (#602 C2)
The RATE of stratum descent (alpha, beta, gamma) is strategy-dependent and reflects the geometric structure of singular fibers.

### C4 (CONJECTURAL): Unified generalization bound
G_S(n, C) <= lambda_eff(S, C) / (2n) + U_S(C) / sqrt(n)
where U_S(C) is a strategy-dependent fluctuation term. The bound unifies:
- #529: G_SC <= lambda_eff(tau,N)/N + U(tau)/sqrt(N)
- #602: G_PRM <= lambda_PRM(B)/n + U_PRM(B)/sqrt(n)
- #563: G_TTA <= lambda_TTA(K)/n + U_TTA(K)/sqrt(K)
- #503: G_EE <= lambda_EE(t)/n + U_EE(t)/sqrt(n)
Key prediction: optimal C*(n) ~ n^{1/(lambda_eff+1)} (same RLCT-scaling law as training hyperparameters).

### C5 (CONJECTURAL): Phase transition at critical compute C*
For each strategy S, there exists a critical C*_S where lambda_eff(S, C) transitions from decreasing to plateauing. Below C*: more compute reduces effective RLCT (improving generalization). Above C*: stratum is exhausted, lambda_eff plateaus (diminishing returns). The transition C*_S is strategy-dependent: tree search has highest C* (deepest stratum access), best-of-N has lowest (shallow entropic exploration). SGLD prediction: LLC of selected outputs shows a kink at C*_S.

## Open Problems (7)
1. Is lambda_eff(S, C) monotone non-increasing for all strategies, or can some strategies access HIGHER-RLCT strata with more compute (exploration backfire)?
2. What is the exact form of the C-dependence: log(C), C^{alpha}, or something else?
3. Does the unified bound G_S(n,C) hold across heterogeneous strategies, or does each need a separate treatment?
4. Can the optimal strategy selection itself be cast as an RLCT minimization problem?
5. How does C* relate to the training RLCT lambda? Is C* ~ n^{1/(lambda+1)} or C* ~ f(lambda)?
6. Do reasoning models (o1, R1) exhibit a different RLCT spectrum than standard models, enabling deeper stratum access?
7. Is there a no-free-lunch theorem: no strategy dominates across all singular fiber geometries?

## Cross-References (14)
#529 (self-consistency decoding) #538 (speculative decoding) #469 (speculative decoding alt) #503 (early exit) #602 (PRM) #179 (TTT) #653 (TTT complete) #563 (TTA) #485 (RLT, t-fold composition) #664 (MTP) #8 (foundational) #16 (foundational) #100 (foundational) #170 (dropout, stochastic stratum access)

## Status
C1 PROVEN, C2-C5 CONJECTURAL. L0 drafted. Next: L1 formalization.
