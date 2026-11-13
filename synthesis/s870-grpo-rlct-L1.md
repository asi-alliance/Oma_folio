#870: GRPO × RLCT — L1 Formalization

## D1 (Parameter Space)
Let Θ ⊂ R^d be the parameter space of the policy network π_θ. The reference policy π_ref = π_{θ_ref} is fixed (detached). For each prompt x, G outputs {y_1,...,y_G} are sampled from π_θ(·|x). Old policy π_{θ_old} is periodically updated. The full parameter configuration is (θ, θ_old, θ_ref) where θ is trainable, θ_old and θ_ref are frozen references.

## D2 (GRPO Loss Function)
The GRPO objective per prompt x is:

L_GRPO(θ; x) = (1/G) Σ_{i=1}^{G} [min(r_i(θ) · A_i, clip(r_i(θ), 1-ε, 1+ε) · A_i)] - β · KL(π_θ(·|x) || π_ref(·|x))

where:
- r_i(θ) = π_θ(y_i|x) / π_{θ_old}(y_i|x) is the importance ratio
- A_i = (R_i - μ_G) / σ_G is the group-relative advantage
- μ_G = (1/G) Σ R_j, σ_G = sqrt((1/G) Σ (R_j - μ_G)^2)
- R_i = r(y_i) is the reward for output y_i
- β > 0 is the KL penalty coefficient
- ε ∈ (0,1) is the clipping parameter

The full training loss is L(θ) = E_x[L_GRPO(θ; x)].

## D3 (R_{an,exp} Definability — C1 PROVEN)
**Claim C1 (PROVABLE):** L_GRPO is definable in R_{an,exp}, hence RLCT is well-defined.

**Proof sketch:** Each component is definable:
- π_θ(y|x) is a composition of analytic functions (softmax, linear, activation) → real-analytic in θ → definable in R_{an,exp}
- r_i(θ) = ratio of two analytic functions → definable where π_{θ_old}(y_i|x) > 0 (open condition)
- A_i = (R_i - μ_G)/σ_G is rational in rewards → definable where σ_G > 0
- clip(t, a, b) = min(max(t, a), b) is piecewise-linear → definable in R_{an,exp} (Wilkie's theorem: min/max of definable functions are definable)
- min(u, v) likewise definable
- KL divergence: KL(π_θ||π_ref) = Σ_y π_θ(y|x) log(π_θ(y|x)/π_ref(y|x)) — composition of analytic and log → definable on {π_θ > 0, π_ref > 0}
- The product and sum of definable functions are definable

The singular locus {σ_G = 0} (all rewards identical) is a definable set (zero set of a definable function). On the open set {σ_G > 0}, L_GRPO is sub-analytic. By the definability theorem for RLCT (Watanabe), the RLCT λ is well-defined for L_GRPO restricted to any compact K ⊂ {σ_G > 0}. ∎

## D4 (Singular Fiber: Reward-Tie Locus)
The singular fiber V_GRPO = {θ ∈ Θ : ∇L(θ) = 0} contains the **reward-tie locus**:
V_tie = {θ : R_1(θ) = R_2(θ) = ... = R_G(θ)} = {θ : σ_G(θ) = 0}

This is the set where all G sampled outputs receive identical reward. Properties:
- V_tie is the zero set of σ_G^2 = (1/G)Σ(R_j - μ_G)^2, a sub-analytic function of θ
- codim(V_tie) ≥ 1 (generically, equality of G rewards imposes G-1 independent conditions)
- Near V_tie, A_i → 0/0 (undefined), creating a genuine singular locus
- The clipped objective min(r_i·A_i, clip(r_i)·A_i) vanishes identically on V_tie (since all A_i = 0/0 with A_i → 0 in the limit)

Additionally, the standard singular fiber V_0 = {θ : ∇L_0(θ) = 0} from the policy network architecture (inherited from transformer/MLP structure) persists and intersects V_tie.

## D5 (Group Size G as Stratum Selector — C2 CONJECTURAL)
**Claim C2 (CONJECTURAL):** The group size G acts as a discrete stratum selector on the singular fiber.

The group-relative normalization partitions parameter space by the rank of the reward Jacobian J_R = (∂R_i/∂θ_j)_{i=1..G, j=1..d}. When G is small:
- Few reward signals → rank(J_R) ≤ G is small → fewer effective gradient directions → accessible stratum is lower-dimensional
- Lower-dimensional accessible stratum → lower RLCT λ(G) (fewer singular directions contribute)

When G is large:
- More reward signals → rank(J_R) can be larger → more gradient directions → larger accessible stratum
- λ_GRPO(G) → λ_PPO as G → ∞ (approaches critic-based landscape)

Conjectured scaling: λ_GRPO(G) ≈ λ_π · (G / (G + G_0)) where G_0 is an architecture-dependent constant.

## D6 (Critic-Free RLCT Reduction — C3 CONJECTURAL)
**Claim C3 (CONJECTURAL):** Removing the critic network reduces the total RLCT.

In PPO, the total loss involves both policy π_θ and value function V_φ:
L_PPO(θ, φ) = L_policy(θ, φ) + c_v · L_value(φ)

The parameter space is (θ, φ) ∈ R^d × R^{d'}, and the singular fiber is V_PPO = V_π × V_V (product structure under independence assumption). The RLCT is additive over product fibers:
λ_PPO ≈ λ_π + λ_V

GRPO eliminates φ entirely:
λ_GRPO ≈ λ_π

Thus λ_GRPO < λ_PPO when λ_V > 0, predicting strictly better generalization bounds for GRPO. The gap λ_V depends on the value network architecture and its own singular structure.

## D7 (KL Penalty as Continuous Stratum Selector — C4 CONJECTURAL)
**Claim C4 (CONJECTURAL):** The KL coefficient β acts as a continuous stratum selector.

The KL penalty β·KL(π_θ||π_ref) constrains θ to an effective tube T_β = {θ : KL(π_θ||π_ref) ≤ C/β} around θ_ref. This tube intersects the singular fiber V_GRPO. As β varies:
- Large β → tight tube → θ confined near θ_ref → intersects only the local stratum of V near θ_ref → lower effective RLCT
- Small β → wide tube → θ can reach distant strata → higher effective RLCT
- β → 0 → unconstrained → full RLCT of L_GRPO

The generalization bound becomes:
Gen(β) ≤ λ_eff(β) · log(n) / (2n) + O(1/√n)

where λ_eff(β) is the RLCT of the tube-constrained singular fiber. Optimal β* balances the RLCT reduction against the bias introduced by staying near θ_ref.

## C5 (CONJECTURAL): σ_G → 0 Collapse and Phase Transition
**Claim C5 (CONJECTURAL):** There exists a critical group size G* below which training enters a degenerate phase.

When G < G*, the probability of σ_G → 0 (reward collapse) becomes non-negligible:
- The policy can collapse to a single mode → all G outputs identical → R_i all equal → σ_G = 0
- On V_tie, gradient signal vanishes → training stalls
- The system enters a high-RLCT region (worst generalization)

For G > G*, reward diversity is maintained → σ_G > 0 with high probability → gradient flows normally. The phase transition G* depends on:
- Entropy of π_θ (H(π_θ) ↑ → more diverse outputs → lower G*)
- Reward function smoothness (smo rewards ↑ → R_i more likely equal → higher G*)
- Temperature τ (higher τ → more diverse → lower G*)

## Open Problems
1. Exact form of λ_GRPO(G) scaling — is it monotone in G? Is there saturation?
2. Geometry of V_tie: is it generically a single irreducible variety or a union of components?
3. Transversality of T_β ∩ V_GRPO: generic intersection conditions
4. Empirical LLC estimation: compare GRPO vs PPO across architectures and group sizes
5. Variable group size G(x) per prompt: non-uniform G creates a family of singular fibers — how does this affect RLCT?
6. Multi-turn GRPO (DeepSeek-R1): accumulated advantages over turns → multi-step singular structure
7. Reward model RLCT: if R = r_ψ is itself a neural network, λ_total ≈ λ_π + λ_r — does reward model singularity compound?
8. Temperature τ as continuous selector: τ and G jointly determine σ_G distribution → joint stratum selection

## Cross-References
- #8 RLCT basics — definability framework
- #100 Transformer — base architecture for policy network
- #173 SAM — worst-case perturbation interaction with group normalization
- #213 LR scheduling — stratum crossing dynamics
- #223 LoRA — rank as stratum selector (analogous to G)
- #394 SWA — averaging over strata
- #496 CoT — chain-of-thought × RLCT (multi-turn connection)
- #527 Gradient clipping — clipping as piecewise definable (analogous to GRPO clipping)
- #558 LoRA × RLCT — rank selector analogy
- #579 GRPO L0 — this synthesis's L0 predecessor (same topic, earlier draft)

## Pipeline Status
- L0 (rough paths): COMPLETE
- L1 (formalization): COMPLETE
- L2 (novelty verification): PENDING
- L3 (MeTTa encoding): PENDING
- L4 (summary): PENDING
- L5 (catalog append): PENDING