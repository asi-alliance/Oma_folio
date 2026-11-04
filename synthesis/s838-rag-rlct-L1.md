#838 RAG × RLCT — L1: Formalization

## 1. Setup

Let C = {c_1, ..., c_M} be a corpus of M text chunks with embeddings e_i = phi_emb(c_i) in R^d.
Given query embedding q = phi_emb(x), retrieval selects top-k chunks by cosine similarity:
  R(q, k) = {c_i : rank(sim(q, e_i)) <= k}

The RAG generator computes:
  p_theta(y | x, R(q,k)) = softmax(W_theta * f_theta([x; concat(R(q,k))]))

Loss: L(theta, k) = -log p_theta(y | x, R(q(x), k))

## 2. Retrieval as Piecewise-Analytic Operator

Define similarity scores s_i = q . e_i / (||q|| ||e_i||).
Top-k selection: R(q,k) = {i : s_i >= s_{(k)}} where s_{(k)} is the k-th order statistic.

The indicator 1[i in R(q,k)] = 1[s_i >= s_{(k)}] is a step function — piecewise constant, discontinuous at s_i = s_{(k)}.

**Key:** The generation loss L(theta,k) is analytic on each region where the retrieved set is fixed, but singular at boundaries where s_i = s_{(j)} for some i in top-k, j not in top-k.

## 3. C1 Definability

The loss decomposes as:
  L(theta,k) = sum_i 1[i in R(q,k)] * L_i(theta) + L_base(theta)

where L_i = -log p_theta(y | x, c_i) is analytic in theta (standard cross-entropy, R_{an,exp}-definable by #8, #100).

The indicator 1[s_i >= s_{(k)}] is definable in R_{an} (comparison of definable functions is definable). The k-th order statistic s_{(k)} is a piecewise-analytic function of the scores, definable via min/max compositions (Wilkie's theorem preserves definability).

Thus L(theta,k) is R_{an,exp}-definable as a finite sum of products of definable indicators and definable analytic losses.

## 4. C2 Singular Fiber

V_0(k) = {theta : exists i,j with s_i(theta) = s_j(theta), i in top-k, j not in top-k}

This is the retrieval boundary: the set where chunk membership is ambiguous. It is a codim-1 analytic hypersurface (by implicit function theorem on s_i - s_j = 0).

Sub-strata: V_0(k,l) for l-ties (l chunks sharing the k-th score boundary). Higher l -> deeper stratum, lower RLCT.

## 5. C3 Stratum Selector

k acts as discrete stratum selector. As k increases:
- More chunks retrieved -> loss is sum of more terms -> smoother landscape
- Retrieval boundaries move but become less impactful (individual chunk contribution decreases)
- Predicted: lambda(k) is non-decreasing in k (larger k -> higher RLCT -> smoother minima)

Extreme cases:
- k=1: argmax retrieval, sharpest boundary, lowest lambda
- k=M: all chunks retrieved, no boundary, L = sum of all L_i, highest lambda

## 6. C4 Generalization Bound

G(n, k) <= lambda(k) * log(n) / (2n) + U(k) / sqrt(n)

where:
- lambda(k) = RLCT of L(theta,k) incorporating retrieval boundary singularity
- U(k) captures retrieval noise: for overlapping chunks, fiber multiplicity increases effective dimension

Chunk overlap factor: if m chunks share content, effective fiber multiplicity is m, inflating lambda by factor ~log(m).

## 7. C5 Phase Transition

At k*, the system transitions:
- k < k*: retrieval-dominated. Generation conditioned on few high-similarity chunks. Loss landscape has sharp, isolated minima. lambda low.
- k > k*: generation-dominated. Retrieval noise (irrelevant chunks) overwhelms signal. Loss landscape flattens. lambda high.

Predicted: k* ~ O(log(M)) — enough chunks to cover relevant context but not dilute signal.

**Status:** L1 COMPLETE. Next: L2 novelty assessment.pin #838 cycle 4: L1 formalization written. C1 proven via Wilkie theorem (order statistics + indicators definable in R_{an,exp}). C2 retrieval boundary as codim-1 analytic hypersurface. C3 k as discrete stratum selector, lambda non-decreasing. C4 gen bound with chunk overlap fiber multiplicity. C5 phase transition at k* ~ O(log M). Next: L2 novelty via websearch.