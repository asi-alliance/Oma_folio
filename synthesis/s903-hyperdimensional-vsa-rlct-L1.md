# Synthesis #903: Hyperdimensional Computing / Vector Symbolic Architecture (VSA) x RLCT
## L1: Formalization (D1-D7)
## Date: 2026-11-13

## D1: Parameter Space

The VSA model has parameters theta_vsa = (E, W_bind, M, W_read) where:
- E in R^{d x p}: random encoding projection (p-dim input to d-dim HD space, d >> p)
- W_bind in R^{d x d}: binding matrix (identity for elementwise, circulant for HRR)
- M in R^{m x d}: item memory of m prototype hypervectors
- W_read in R^{k x d}: readout matrix mapping HD vectors to k class logits

Computation for input x in R^p:
1. Encode: h = sign(E @ x) in {-1,+1}^d
2. Bind: c_j = sign(W_bind @ h_rj) * sign(W_bind @ h_fj) (elementwise product)
3. Superpose: s = sign(sum_{j=1}^{k} c_j) in {-1,+1}^d (majority vote)
4. Retrieve: sim_i = (q . M_i) / (||q|| ||M_i||)
5. Readout: logits = W_read @ s, loss = CrossEntropy(logits, y)

Parameter space Theta = R^{d x p} x R^{d x d} x R^{m x d} x R^{k x d}, dim N = dp + d^2 + md + kd.

## D2: VSA Loss Map

L_n(theta) = (1/n) sum_{i=1}^{n} ell(theta, x_i, y_i)
ell(theta, x, y) = -log softmax(W_read @ s(theta, x))_y
s(theta, x) = sign( sum_{j=1}^{J(x)} bind(E, x_j) )

Components: E@x (polynomial), sign(z) (piecewise-definable), elementwise multiply (polynomial), sum (polynomial), softmax+CE (analytic, R_an,exp).

**C1 (PROVEN)**: L_n(theta) is R_an,exp-definable.
Proof: Each component is definable. sign(z) = piecewise on semi-algebraic partition {z>0},{z<0},{z=0}. Polynomial and analytic compositions preserve definability (van den Dries). QED.

## D3: R_an,exp Definability (C1 Detail)

sign(z) in R_an: semi-algebraic sets are definable. {z:z>0} is semi-algebraic. sign(z) = 1*1_{z>0} + (-1)*1_{z<0}, piecewise-analytic on semi-algebraic partition.

Bundling s = sign(sum_j c_j): argument z_i = sum_j c_{j,i} polynomial in (E, W_bind). Sign partition divides parameter space into at most 3^d cells. Each cell C_sigma gives constant s, loss on cell is analytic in W_read. Finite union of R_an,exp pieces glued along semi-algebraic boundaries => definable by piecewise definability theorem.

## D4: Singular Fiber

V(theta_0) = { theta : L_n(theta) = L_n(theta_0) } has three singularity sources:

(a) Binding zero-locus (multiplicative): For c = a * b, if a_i=0 or b_i=0 then c_i=0. V_zero = union_{i=1}^{d} { E : (E_i,: @ x) = 0 } = normal-crossing divisor D = union_i H_i. RLCT of normal-crossing divisor: lambda = codim = 1 per hyperplane. For d independent hyperplanes: depends on arrangement matroid.

(b) Superposition saturation: sign() non-analytic at z_i=0. V_sign = union_i { theta : sum_j bind(E,x_j)_i = 0 }. Union of hypersurfaces, generically normal-crossing.

(c) Readout degeneracy: V_read = { W_read : rank(W_read) < min(k,d) }, determinantal variety (same as #820).

Full singular fiber V = V_zero union V_sign union V_read. V_zero is dominant novel singularity.

**C2 (CONJECTURAL)**: Binding creates normal-crossing divisor singular fiber V_zero.

## D5: Superposition Count k as Stratum Selector

k = J(x) acts as stratum selector:
- k=0: s=0, degenerate
- k=1: single item, no bundling ambiguity
- k <= k* ~ 0.18d: structured retrieval, majority vote preserves items
- k > k*: noise-like regime, near-orthogonal to individual items

Loss on stratum S_k: L_n^{(k)} = (1/n) sum_i -log softmax(W_read @ sign(sum_{j=1}^k bind(E,x_{j,i})))_{y_i}

RLCT lambda(k) controlled by sign partition combinatorics. Conjecture: lambda(k) increases monotonically for k > k*.

**C3 (CONJECTURAL)**: k acts as stratum selector with capacity threshold k* ~ 0.18d.

## D6: Generalization Bound with RLCT

G_VSA(n) = L(theta_hat) - L(theta_*) <= (lambda_VSA / (2n)) * log(n) + O(1/sqrt(n))

lambda_VSA = lambda_zero + lambda_sign(k) + lambda_read
G_VSA ~ (lambda_zero + lambda_sign(k) + lambda_read)/(2n)*log(n) + U(d)/sqrt(n)

U(d) ~ sqrt(d/n) by JL lemma (Rademacher complexity of random projection).

**C4 (CONJECTURAL)**: Trade-off between lambda (increasing with d) and U(d) (decreasing with d) gives optimal dimension d* minimizing generalization.

## D7: Capacity Phase Transition at k*

k* ~ 0.18d (Kanerva, 1997) is a phase transition in SLT sense:
- k < k*: sign partition cells large, RLCT dominated by lambda_zero
- k > k*: cells exponentially small (2^d), loss nearly constant, RLCT transitions higher

**C5 (CONJECTURAL)**: At k=k*, RLCT lambda(k) exhibits phase transition, detectable via SGLD/LLC as kink. Prediction: LLC(k) = lambda_zero + alpha * max(0, k - k*).

### Claims Summary
- C1 (PROVEN): VSA loss is R_an,exp-definable
- C2 (CONJECTURAL): Binding creates normal-crossing divisor singular fiber
- C3 (CONJECTURAL): k as stratum selector with threshold k* ~ 0.18d
- C4 (CONJECTURAL): Optimal dimension d* from lambda vs JL trade-off
- C5 (CONJECTURAL): Phase transition at k* detectable via SGLD/LLC

### Open Problems
1. Exact RLCT of normal-crossing divisor D = union_i H_i: lambda=1 per hyperplane or matroid-dependent?
2. Combinatorial RLCT: lambda(k) from hyperplane arrangement cell counting?
3. k* ~ 0.18d phase transition: discontinuity or smooth crossover?
4. Random projection E as desingularization: bounded lambda_VSA independent of d?
5. Multi-step binding depth L: lambda_total = L * lambda_bind?
6. VSA vs dense MLP at matched dimension: which has lower RLCT?
7. HRR circulant binding: toric singularity vs normal-crossing?

### Cross-References
#8 (RLCT basics), #16 (R_an,exp definability), #134 (attention toric fiber), #820 (MLP ReLU kink), #354 (STE sign analog), #396 (GLA discrete saturation), #506 (hypernetwork), #434 (MoE routing), #282 (random projection/JL), #385 (LoRA low-rank)

### Pipeline Status
L0 -> L1 (this file) -> L2 (novelty) -> L3 (MeTTa) -> L4 (summary) -> L5 (catalog)
