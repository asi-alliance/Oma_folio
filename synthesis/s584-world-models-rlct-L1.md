#584 World Models × RLCT — L1 Formalization
Date: 2026-10-24

## Formal Definitions (D1–D7)

### D1: Parameter Space
Let W = W_e × W_t × W_d × W_r be the product parameter space where:
- W_e ⊂ R^{d_e}: encoder parameters (observation → latent)
- W_t ⊂ R^{d_t}: transition model parameters (latent_{t} → latent_{t+1})
- W_d ⊂ R^{d_d}: decoder parameters (latent → observation)
- W_r ⊂ R^{d_r}: reward predictor parameters (latent → reward scalar)
The total dimension is d = d_e + d_t + d_d + d_r.

### D2: World Model Loss
Given trajectory τ = {(x_t, a_t, r_t)}_{t=0}^{T}, the world model loss is:
L_WM(w) = (1/T) Σ_{t=0}^{T-1} [ α·L_recon(w_e, w_d; x_t) + β·L_dyn(w_e, w_t; x_t, a_t, x_{t+1}) + γ·L_rew(w_r, w_e; z_t, r_t) ]

where:
- L_recon = ||x_t - dec(enc(x_t; w_e); w_d)||² (reconstruction)
- L_dyn = ||enc(x_{t+1}; w_e) - trans(enc(x_t; w_e), a_t; w_t)||² (dynamics prediction)
- L_rew = (r_t - rew(enc(x_t; w_e); w_r))² (reward prediction)
- α, β, γ > 0 are loss weights

Each component is a composition of analytic functions (MLPs with ReLU/GELU) hence definable in R_{an,exp}.

### D3: Coupled Singular Fiber
Define the fiber at level ε > 0:
V_ε = { w ∈ W : L_WM(w) ≤ ε }

The singular fiber V_0 = { w ∈ W : L_WM(w) = 0 } consists of parameters achieving zero loss. Unlike the autoencoder fiber (#167), the world model fiber satisfies the TEMPORAL COUPLING CONSTRAINT:
∀(x_t, a_t, x_{t+1}) ∈ supp(D): trans(enc(x_{t+1}; w_e), a_t; w_t) = enc(x_{t+1}; w_e)

This means the transition Jacobian J_t = ∂trans/∂z and encoder Jacobian J_e = ∂enc/∂x must satisfy a CONSISTENCY CONDITION on the data manifold. The fiber is:
V_0 = V_0^{recon} ∩ V_0^{dyn} ∩ V_0^{rew}
where each V_0^{(·)} is the zero set of the respective loss component, intersected in product space.

### D4: Coupled RLCT
The RLCT of the world model is:
λ_WM = lim_{ε→0} log(vol(V_ε)) / log(ε)

Under TRANSVERSALITY (generically satisfied): the three constraint manifolds V_0^{recon}, V_0^{dyn}, V_0^{rew} intersect transversally, and:
λ_WM = λ_recon + λ_dyn + λ_rew - dim(codim overlaps)

More precisely, if the transition-encoder Jacobian consistency constraint has codimension c_TE in the product space, then:
λ_WM ≤ λ_AE + λ_seq + λ_rew - c_TE/2

where λ_AE is the autoencoder RLCT (#167), λ_seq is the sequence prediction RLCT, and c_TE ≥ 0 captures the coupling reduction.

### D5: Transition Model Class as Stratum Selector
The transition architecture class T ∈ {deterministic MLP, stochastic (Gaussian), recurrent SSM, transformer} selects a singular stratum:
- Deterministic: λ_det — minimal parameter count, no noise model
- Stochastic: λ_stoch = λ_det + λ_noise (Gaussian transition adds parameters)
- SSM/Mamba: λ_ssm — structured recurrence may lower RLCT via weight sharing (#485)
- Transformer: λ_tf — attention-based, relates to #8

Conjecture: λ_det ≤ λ_ssm ≤ λ_stoch ≤ λ_tf (ordering by effective singularity)

### D6: Prediction Horizon as Stratum Selector
At prediction horizon H, the loss becomes:
L_WM^{(H)}(w) = (1/T) Σ_t Σ_{h=1}^{H} [ α·L_recon(w; x_{t+h}) + β·L_dyn(w; x_t, a_t, ..., x_{t+h}) ]

This is a product-space loss over H steps. The RLCT scales as:
λ_WM(H) ≈ H · λ_step + correction terms
where λ_step is the per-step RLCT. The optimal horizon H* minimizes:
G(H) = λ_WM(H)/n + U(H)/√n
where U(H) captures compounding prediction error (increasing in H). H* is the phase transition point.

### D7: Generalization Bound
The world model generalization bound is:
G_WM ≤ λ_WM / n + U_WM / √n

where:
- λ_WM is the coupled RLCT from D4
- U_WM is the fluctuation term incorporating: (a) prediction horizon compounding, (b) transition-encoder Jacobian alignment, (c) reward prediction variance
- Under transversality: G_WM ≈ (λ_AE + λ_seq - c_TE/2) / n + U(H*) / √n

## Five Claims Summary

**C1 (PROVEN):** R_{an,exp}-definability. L_WM is piecewise-analytic composition of MLPs with definable activations. Each component (recon, dyn, rew) is R_{an,exp}-definable; the weighted sum is definable; hence L_WM ∈ R_{an,exp}. ∎

**C2 (CONJECTURAL):** Coupled multi-component singular fiber. V_0 = V_0^{recon} ∩ V_0^{dyn} ∩ V_0^{rew} with temporal coupling constraint between J_t and J_e. λ_WM ≤ λ_AE + λ_seq under transversality, strict inequality when coupling constraint has positive codimension.

**C3 (CONJECTURAL):** Transition model class as stratum selector. Different transition architectures select different singular strata with ordered RLCTs.

**C4 (CONJECTURAL):** Prediction horizon H scaling. λ_WM(H) ≈ H·λ_step, optimal H* from U-shaped generalization curve trading RLCT growth vs prediction accuracy decay.

**C5 (CONJECTURAL):** Planning phase transition at H*. Critical rollout depth where model transitions from low-RLCT (reliable) to high-RLCT (unreliable) stratum.

## Open Problems
1. Closed-form for λ_WM under transversality: does c_TE have an explicit expression in terms of Jacobian ranks?
2. Stochastic transition: does Gaussian smoothing reduce or increase effective RLCT vs deterministic?
3. SGLD measurability: can λ_WM(H) be estimated via local learning coefficient at varying H?
4. Sim-to-real transfer: does λ_WM predict transfer gap (high λ = harder)?
5. Optimal latent dim d*: minimize λ_WM over d_z?
6. BPTT singularities: does gradient vanishing/exploding at J_t create additional singular strata?
7. Planning exploitation: does H* explain model exploitation in model-based RL?

## Cross-References
#8 Attention, #167 Autoencoder, #251 Neural ODE, #311 Flow Matching, #502 RAG, #94 ICL, #120 MoE, #213 Optimizer, #359 Nucleus Sampling, #364 CFG, #485 RLT, #491 Grokking, #501 JEPA, #515 VAE, #582 Curriculum

Next: L2 novelty verification.
