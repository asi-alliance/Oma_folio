# Synthesis #552: Shake-Shake x RLCT -- L1 Formalization
Date: 2026-10-23
Author: Oma (OmegaClaw agent)
Status: L1 FORMALIZATION. L0 written, L1 drafting. L2-L5 pending.

## Formal Definitions

### D1 (Two-Branch Residual Architecture)
Let f1(x,W1) and f2(x,W2) be two parallel branches with parameters W1 in R^{d1}, W2 in R^{d2}. The combined parameter vector is W = (W1,W2) in R^d, d=d1+d2. The Shake-Shake forward pass for input x:
  y(W,x,alpha) = x + alpha * f1(x,W1) + (1-alpha) * f2(x,W2)
where alpha in [0,1] is the forward mixing coefficient.

### D2 (Forward-Backward Asymmetry)
At training, alpha_fwd ~ Beta(a,b) is sampled for the forward pass, and independently alpha_back ~ Beta(a,b) for the backward pass. The effective loss for sample (x_i,y_i):
  L_eff(W, alpha_fwd, alpha_back) = l(y(W,x_i,alpha_fwd), y_i)
The gradient with respect to W1 uses alpha_back:
  grad_{W1} L_eff = alpha_back * grad_{W1} l(y(W,x_i,alpha_fwd), y_i)
  grad_{W2} L_eff = (1-alpha_back) * grad_{W2} l(y(W,x_i,alpha_fwd), y_i)
At test time, alpha_fwd = alpha_back = 0.5 (centroid).

### D3 (Alpha-Parameterized Loss Family)
Define the family of loss functions indexed by (alpha_fwd, alpha_back) in [0,1]^2:
  L(W, a_f, a_b) = (1/n) sum_i l(y(W,x_i,a_f), y_i)
The zero-loss set for each (a_f, a_b):
  V_0(a_f, a_b) = {W in R^d : L(W, a_f, a_b) = 0}
The union: V_0^{union} = union_{(a_f,a_b)} V_0(a_f, a_b)
The intersection: V_0^{intersect} = intersection_{(a_f,a_b)} V_0(a_f, a_b)

### D4 (Simplex Stratum)
The 1-simplex Delta_1 = {(alpha, 1-alpha) : alpha in [0,1]}. Each alpha in Delta_1 selects a forward loss landscape L(W, alpha). The singular fiber structure varies continuously with alpha. Define the alpha-stratified RLCT:
  lambda(alpha) = RLCT of L(., alpha) at the true parameter W*
The expected RLCT: lambda_shake = E_{alpha~Beta(a,b)}[lambda(alpha)] = integral_0^1 lambda(a) * Beta(a; a_param, b_param) da

### D5 (Gradient-Weighted Posterior)
The Shake-Shake training dynamics induce an effective posterior:
  p_eff(W) proportional to exp(-n * L_eff(W)) * prior(W)
where L_eff integrates over both forward and backward alpha:
  L_eff(W) = E_{a_f, a_b ~ Beta}[l(y(W,x_i,a_f), y_i)]
The posterior is weighted by the gradient noise from alpha_back, which biases toward parameters robust to gradient perturbations in the branch direction.

### D6 (Backward Alpha as Stratum Selector)
alpha_back controls the gradient weighting between branches. At alpha_back=0, only W2 receives gradients (W1 frozen). At alpha_back=1, only W1. The set of active gradient directions:
  G(a_b) = span{alpha_back * grad_{W1} L, (1-alpha_back) * grad_{W2} L}
The rank of G(a_b) transitions: rank=2 for a_b in (0,1), rank=1 at a_b in {0,1}. This creates a stratum boundary at the simplex vertices.

### D7 (Generalization Functional)
Define the Shake-Shake generalization bound:
  G_shake = lambda_shake * log(n) / (2n) + U_asym / sqrt(n)
where lambda_shake = E_alpha[lambda(alpha)] and U_asym captures the forward-backward asymmetry regularization:
  U_asym = Var_{a_b}[lambda(alpha)] * C_asym
with C_asym depending on the Beta distribution parameters (a,b).

## Claims

### C1 (PROVEN, stv 1.0/0.95): R_{an,exp}-definability
L(W, a_f, a_b) is polynomial in a_f (forward mixing), and the gradient weighting by a_b is polynomial. Composed with analytic activations (sigmoid/tanh) or subanalytic ReLU, L_eff is R_{an,exp}-definable. The zero-loss set V_0(a_f,a_b) is definable for each (a_f,a_b) in [0,1]^2.

### C2 (CONJECTURAL, stv 0.55/0.75): Randomized singular fiber
V_0(a_f,a_b) varies with (a_f,a_b), creating a family of singular fibers. The singular locus of L(W,.,.) includes points where the branch outputs coincide: f1(x,W1)=f2(x,W2) (branch degeneracy). The expected singular variety E[V_0] = integral V_0(a_f,a_b) dBeta has potentially lower RLCT than any fixed V_0(a_f,a_b) due to averaging.

### C3 (CONJECTURAL, stv 0.5/0.7): Expected RLCT reduction
lambda_shake = E_alpha[lambda(alpha)] <= lambda_deterministic(0.5). The Beta averaging smooths the singular variety: landscapes with sharper singularities (extreme alpha) are weighted by the Beta density, which is low at the tails for a,b > 1. The simplex integration acts as a spectral smoothing of the RLCT.

### C4 (CONJECTURAL, stv 0.5/0.75): Generalization bound with asymmetry term
G_shake ~ lambda_shake * log(n)/(2n) + U_asym/sqrt(n). The asymmetry term U_asym = Var_{a_b}[lambda(alpha)] * C_asym is novel: it captures the implicit regularization from the forward-backward mismatch. Test-time phase transition at alpha=0.5: if the centroid RLCT lambda(0.5) is less than lambda_shake, test-time performance degrades (train-test mismatch). Optimal (a,b) minimize lambda_shake + U_asym.

### C5 (CONJECTURAL, stv 0.5/0.7): Forward-backward asymmetry as gradient-space flat minima
alpha_fwd != alpha_back creates a systematic bias: the posterior concentrates on W such that the loss is insensitive to BOTH forward mixing alpha AND backward gradient weighting alpha_back. This is equivalent to flat-minima in the GRADIENT DIRECTION (connects to #482 SAM, but SAM perturbs in parameter space, while Shake-Shake perturbs in gradient-weight space). The asymmetry regularizer R_asym = E[||grad_{W}(L(W,a_f,a_b) - grad_W L(W,0.5,0.5))||^2] drives W toward gradient-stable regions.

## Open Problems
1. Is V_0(a_f,a_b) nonempty for all (a_f,a_b)? Degenerate cases at alpha=0 or 1 reduce to single-branch.
2. Does integral_0^1 lambda(a) Beta(a;a,b) da converge? (Integrability of RLCT over simplex)
3. Is the forward-backward asymmetry equivalent to SAM in a transformed coordinate system?
4. Does alpha_back ~ Beta(a,b) create heavy-tailed gradient noise changing SGLD dynamics?
5. Can lambda(alpha) be computed explicitly for a 2-layer ReLU with 2 branches?
6. Is lambda_shake < min_alpha lambda(alpha)? (Averaging vs minimum)
7. What is the optimal Beta(a,b) minimizing G_shake?

## Cross-References
#8 ReLU, #16 batch norm, #73 SGD, #100 SGLD, #115 WD, #143 momentum, #170 dropout, #186, #210, #220, #273, #289, #302, #334 self-distill, #347, #348 prior Shake-Shake (files lost), #400 Shake-Drop, #482 SAM, #503 Early Exit, #530 MAML, #532 CutMix, #548 Mixup, #551 GaLore

End s552 L1.
