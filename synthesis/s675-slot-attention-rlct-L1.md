## Synthesis #675: Slot Attention x RLCT -- L1 Formal Definitions
**Date:** 2026-10-28
**Status:** L1 DRAFT
**Pipeline:** L0 (1528B) -> L1 (this) -> L2 -> L3 -> L4 -> L5
---
### D1: Parameter Space
Let Theta = Theta_enc x Theta_slot x Theta_dec
- Theta_enc: encoder (CNN/ViT) mapping input to N feature vectors in R^d
- Theta_slot: slot init mu_0 in R^{K x d}, W_K, W_Q, W_V, GRU cell W_GRU, MLP
- Theta_dec: decoder mapping slots to output
Dimension: d = dim(Theta_enc) + dim(Theta_slot) + dim(Theta_dec)
Hyperparameters: K (slots), T (Sinkhorn iterations), d (feature dim)
### D2: Slot Attention Loss
For input-output pairs (x,y):
1. Encode: F = enc(x) in R^{N x d}
2. Init slots: S_0 = mu_0
3. For t=1..T:
   a. Normalize inputs: F_norm = F / ||F||
   b. Attention: attn_{k,n} = (W_K S_{t-1})^T (W_Q F_norm) / sqrt(d)
   c. Softmax over N (per slot): A_{k,n} = exp(attn_{k,n}) / sum_m exp(attn_{k,m})
   d. Normalize over K (per input): A_{k,n} = A_{k,n} / sum_j A_{j,n}
   e. Updates: U_k = sum_n A_{k,n} (W_V F_norm)
   f. GRU: S_t = GRU(S_{t-1}, U_k)
4. Decode: o = dec(S_T)
5. Loss: L(Theta) = (1/n) sum ||y_k - o_k||^2 + beta||Theta||^2
### D3: R_{an,exp} Structure (C1 PROVEN)
Claim: L(Theta) is definable in R_{an,exp}.
Proof sketch:
- Dot products: polynomial, in R_{an,exp}
- L2 normalization F/||F||: ratio of polynomials, analytic where ||F||>0
- softmax: exp/sigma = R_{an,exp} by definition
- Row/col normalization: rational function of A entries, analytic where denom > 0
- GRU gate: sigmoid = 1/(1+exp(-x)) in R_{an,exp}
- GRU update: affine + Hadamard of sigmoid-gated terms = polynomial + R_{an,exp}
- Decoder + squared loss: polynomial composition
All operations in R_{an,exp}. By closure under composition and summation, L is definable. QED.
### D4: Slot-Collapse Singular Fiber (C2 CONJECTURAL)
V_collapse = {Theta : exists i != j, S_i(Theta) = S_j(Theta) after T iterations}
At collapse S_i = S_j, double normalization cannot distinguish slots i,j. Assignment A becomes invariant under transposition (i<->j). Jacobian dL/dTheta drops rank.
Distinct from NTM (#674): NTM collision from write op permutation symmetry; Slot Attention collision from competitive normalization degeneracy.
Conjecture: V_collapse is proper analytic subvariety. Codim >= d. For M-way collapse, codim >= (M-1)*d.
### D5: K-Stratified Loss Family (C3 CONJECTURAL)
L_K(Theta) = L(Theta; K slots)
K acts as discrete stratum selector.
- Small K: forced merging -> high collision -> higher lambda
- Large K: empty slots, wasted capacity -> sparse but suboptimal
- U-shaped lambda(K): optimal K* balances coverage vs collision
P(collapse) ~ K^{-1} * N^2 (birthday-paradox analog)
### D6: Generalization Bound (C4 CONJECTURAL)
G_SA ~ lambda_SA(K)/n + U_SA(K)/sqrt(n)
Unlike NTM (#674), no external memory reservoir, so n_eff = n.
### D7: K* Phase Transition (C5 CONJECTURAL)
Critical K* exists:
- K < K*: merge-dominated, high lambda, overfitting via slot collapse
- K > K*: split-dominated, low lambda, underfitting from sparse slots
- K = K*: optimal generalization
K* ~ O(sqrt(N)) where N is number of input features
### Cross-References
#134 (attention RLCT), #674 (NTM collision), #434 (MoE routing), #545 (sparse attention), #373 (Perceiver IO), #503 (early exit), #16 (LSTM gating), #88 (permutation equivariance), #8, #201
