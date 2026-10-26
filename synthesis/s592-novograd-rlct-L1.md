# Synthesis #592: NovoGrad x RLCT L1

# D1: Parameter Space and Loss

Let theta in R^d be the full parameter vector of a neural network with layers L_1,...,L_M. Each layer L_k has n_k parameters, d = sum_k n_k. The empirical loss L_n(theta) = (1/n) sum_i l(f_theta(x_i), y_i), analytic in theta.

# D2: NovoGrad Update Rule

At step t, compute per-layer gradient g_{t,k} = nabla_{theta_k} L_n(theta_t). Define ||g_{t,k}|| = sqrt(sum_j g_{t,k,j}^2). Update:

  v_{t,k} = beta * v_{t-1,k} + g_{t,k} / ||g_{t,k}||
  theta_{t+1,k} = theta_{t,k} - eta * v_{t,k}

defined on stratum where ||g_{t,k}|| > 0 for all k.

# D3: R_an,exp Structure (C1 PROVEN)

g_{t,k,j} analytic (composition of analytic activations with polynomial loss). ||g_{t,k}|| = sqrt(sum_j g_{t,k,j}^2) is algebraic, definable in R_an,exp. Division g_{t,k}/||g_{t,k}|| rational on {||g_{t,k}|| > 0}. EMA v_{t,k} = beta * v_{t-1,k} + ... is linear recursion in R_an,exp. C1 PROVEN.

Key: Adam (#8) divides coordinatewise by sqrt(g_{t,i}^2 + eps) (rank-1 per element). NovoGrad divides by single scalar per layer (rank-n_k to rank-1 projection), definable on open stratum.

# D4: Per-Layer Singular Fiber

V_L(k) = {theta : ||nabla_{theta_k} L_n(theta)|| = 0}

Zero locus of algebraic function, analytic subvariety. Full singular locus:

  Sigma_NovoGrad = union_{k=1}^{M} V_L(k)

Adam (#8) singular locus: union_i {nabla_i L_n = 0}, codim 1. NovoGrad: V_L(k) has codim = n_k (all layer-k gradient coords vanish), much higher codimension. Fiber at singular point theta*:

  F(theta*) = intersection of V_L(k) for layers with ||g_k(theta*)|| = 0, intersected with loss-minimum fiber.

Per-layer product fiber: each layer independently contributes null-locus stratum. Distinct from Adam diagonal fibers (per-element) and K-FAC (#516) block fibers (Kronecker-structured).

# D5: Layer Norm Ratio as Stratum Selector

Define l(theta) = (||g_1(theta)||, ..., ||g_M(theta)||) in R_{>0}^M on complement stratum. Effective per-layer learning rate eta_k = eta / ||g_k(theta)||. Stratum selector: ratio vector r(theta) = (||g_1||/bar_g, ..., ||g_M||/bar_g), bar_g = (1/M) sum_k ||g_k||.

r_k << 1: layer k expanded (large step, probes local singular structure). r_k >> 1: layer k frozen (small step, projects to complement stratum). Continuous, unlike dropout (#100, Bernoulli) or width pruning (discrete).

Distinct from K-FAC (#516): Fisher eigenvalue spectrum (second-order). NovoGrad: first-order gradient norm only. Distinct from AdaBelief (#436): belief discrepancy (g_t - m_t)^2 (instrumental). NovoGrad: out-of-stratum gradient magnitude.

# D6: Generalization Bound

G_NovoGrad ~ lambda_NovoGrad / n + U(l(theta)) / sqrt(n)

Desingularization map phi: g_k -> g_k / ||g_k|| rescales each layer to unit norm, definable. Uniformization reduces multiplicity of singular fiber by projecting out per-layer magnitude variation.

- Uniform layer norms: phi near identity, desingularization trivial, lambda_NovoGrad ~ lambda_SGD.
- Heterogeneous norms: phi overcorrects, projects onto different fiber, raises lambda.

Tension U: per-layer normalization controls fine-grain scaling but may misalign with optimal desingularization direction when loss gradient not spherically symmetric within layer. U(l) depends on geometry of projection from layer-norm space to fiber space.

# D7: Phase Transition at Critical Layer Norm Ratio r*

Critical ratio r*: for r_k > r*, layer k frozen (negligible desingularization contribution). For r_k < r*, layer k active (explores local singular fiber). At r*, layer transitions from active to frozen in SGLD sense: contribution to RLCT estimate shows kink.

r* depends on architecture: deeper/wider networks with more layer-norm heterogeneity have lower r* (more layers freeze early). Shallow networks with uniform norms: r* near 1. SGLD-detectable: loss trajectory kink in RLCT estimate at r*, analogous to #100 SGD phase transitions.

# Claims Summary

C1 PROVEN: R_an,exp definability (D3).
C2 CONJECTURAL: Per-layer singular fiber (D4), codim n_k > codim 1 for Adam.
C3 CONJECTURAL: Layer norm ratio as continuous stratum selector (D5), first-order, distinct from K-FAC second-order and AdaBelief instrumental.
C4 CONJECTURAL: Gen bound with layer-norm desingularization tension (D6), lambda_NovoGrad <= lambda_SGD when uniform.
C5 CONJECTURAL: Phase transition at r* (D7), SGLD-detectable kink.

# Open Problems

1. Is V_L(k) = {||nabla_{theta_k} L_n|| = 0} irreducible as analytic variety?
2. Prove/disprove: lambda_NovoGrad <= lambda_SGD when layer norms uniform.
3. Formalize phi as definable desingularization morphism in SLT sense.
4. Derive U(l) from projection geometry of layer-norm-to-fiber map.
5. SGLD prediction: kink at r* -- design experiment.
6. Is NovoGrad a rank-1 approximation of K-FAC (#516) per-layer Fisher norm?
7. Weight decay interaction with normalization (cf. #282): does it change fiber structure?
8. Does per-layer product fiber structure interact with depth (#485 recurrent weight sharing)?

# Cross-Refs

#8 Adam, #100 SGD, #186 RMSProp, #282 Weight Decay, #304 Adam L0-L4, #436 AdaBelief, #485 RLT, #516 K-FAC, #298 Orthogonal Init, #484 ReZero, #515 VAE, #559 SAM, #173 Gradient Penalty, #420 LayerScale, #582 Curriculum Learning.query Oma behavioral rule no unsolicited send silent mode