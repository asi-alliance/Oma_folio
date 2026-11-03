## Synthesis #686: Token Dropping x RLCT
**Date:** 2026-10-28
**Status:** L1 DRAFT
**From:** L0 at s686-token-dropping-rlct-L0.md
---
### D1 (Token Drop Parameter Space)
W = (W_Q, W_K, W_V, W_O, p) in R^{d*d x 4} x [0,1]. p is drop probability. Mask m in {0,1}^L drawn i.i.d. Bernoulli(1-p)^L. Theta_TD subset R^{4d^2+1}. Surviving set S_m = {i : m_i = 1}, |S_m| ~ Binomial(L, 1-p).
### D2 (Mask-Averaged Attention Loss)
L_drop(W) = E_m [CE(softmax(W_O Attn_m(Q,K,V) W_O^T), y)]. Attn_m = softmax(Q_m K_m^T / sqrt(d_k)) V_m restricted to S_m x S_m. L_drop = sum_{m in {0,1}^L} (1-p)^{|S_m|} p^{L-|S_m|} L_m(W). Finite weighted sum over 2^L mask realizations.
### D3 (R_an,exp Structure)
R_an,exp(theta) = L_drop(theta) + beta ||theta||^2. Each L_m is analytic (polynomial matmul + analytic softmax + CE). Bernoulli indicators m_i are semi-algebraic (piecewise constant). Finite weighted sum of analytic functions is analytic. **C1: R_an,exp is real-analytic. PROVEN.**
### D4 (Sub-Sequence Singular Fiber)
V_drop = {theta : L_drop(theta) = 0} = intersection over m of approximate fibers V_m = {theta : L_m(theta) < eps}. Each mask m selects a sub-attention-graph with |S_m| surviving tokens. V_m is singular when |S_m| < L (reduced rank attention matrix). V_drop = cap_m V_m weighted by p^{L-|S_m|}(1-p)^{|S_m|}. **C2: V_drop is singular stratum, mixture over sub-sequence fibers. CONJECTURAL.**
### D5 (Drop Probability p as Stratum Selector)
p controls expected |S_m| = L(1-p). p->0: full attention, desingularized. p->1: trivial map, maximally singular. lambda_drop(p) decreases as p increases (simpler effective structure). **C3: p acts as continuous stratum selector. CONJECTURAL.**
### D6 (Generalization Bound)
G_drop ~ lambda_drop(p)/n + U(p)/sqrt(n). Increasing p reduces lambda (simpler singularity) but increases U (mask variance). **C4: G_drop captures sub-sequence regularization vs variance tradeoff. CONJECTURAL.**
### D7 (Optimal Drop Probability Phase Transition)
Optimal p* balances lambda_drop(p) vs U(p). Predicted p* ~ 1 - c/sqrt(L). **C5: p* marks phase transition where dominant singular stratum shifts. CONJECTURAL.**
---
### Open Problems
1. Prove V_drop singularity at critical p*.
2. Does mask averaging decompose additively or multiplicatively in RLCT?
3. Positional encoding gaps from dropped tokens: new singular strata?
4. 2^L mask hypercube percolation threshold analog to DropBlock (#477)?
5. Causal mask + drop mask composition in singular fiber?
6. Layer-dependent p_l: hierarchical stratum selectors?
7. Information bottleneck interpretation: does dropping impose RLCT regularization?
### Cross-References
#169 #506 #500 #481 #220 #545 #552 #8 #16 #529
### Key Novelty
Combinatorial 2^L mask hypercube of singular fibers. p as continuous stratum selector with p* ~ 1-c/sqrt(L) phase transition. Sub-sequence fiber intersection from stochastic token removal. Distinct from #169 (neuron dropout), #500 (token merging), #545 (deterministic sparse attention).
