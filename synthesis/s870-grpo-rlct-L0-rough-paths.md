#870: GRPO × RLCT — L0 Rough Paths

## Topic
Group Relative Policy Optimization (GRPO) × Real Log Canonical Threshold (RLCT)

## Background

### GRPO
GRPO (Group Relative Policy Optimization) is a reinforcement learning algorithm introduced by DeepSeek (DeepSeekMath, DeepSeek-R1) that eliminates the value/critic network from PPO-style training. Key features:
- Samples a group of G outputs per prompt
- Normalizes rewards within the group using mean μ and std σ
- Computes group-relative advantages: A_i = (r_i - μ) / σ
- Minimizes PPO-style clipped objective with group-relative advantages
- Adds KL penalty to reference policy: β · KL(π_θ || π_ref)
- No value function → fewer parameters → simpler optimization landscape

### RLCT
The Real Log Canonical Threshold (λ) governs the asymptotic free energy near singular points in statistical learning models. For non-identifiable models (neural networks), λ determines generalization bounds and learning coefficient behavior.

## Rough Claim Paths

### C1 (PROVABLE): Analytic definability of GRPO loss
The GRPO objective L_GRPO(θ) = E[min(ratio_i · A_i, clip(ratio_i, 1±ε) · A_i)] - β·KL(π_θ||π_ref) is a real-analytic function of the network parameters θ in a neighborhood of any non-degenerate critical point. The clipping introduces a piecewise structure, but each piece is analytic, and the full objective is sub-analytic → definable in an o-minimal structure. Thus RLCT is well-defined for the GRPO loss landscape.

Key subtlety: The group-relative advantage A_i = (r_i - μ_G)/σ_G introduces a rational (division by σ_G) — definable where σ_G > 0, which holds generically. The normalization creates a singularity when σ_G → 0 (all rewards identical), a novel singular locus.

### C2 (CONJECTURAL): Group size G as singular stratum selector
The group size G determines the "coarseness" of reward normalization. Larger G → finer-grained advantage estimates → more directions in parameter space receive gradient signal → effectively selects a larger stratum of the singular fiber. The RLCT should scale with G:
- λ_GRPO(G) ≈ λ_PPO · f(G) where f(G) captures the group-normalization effect
- Small G → coarser advantages → fewer effective gradient directions → lower-dimensional accessible stratum → lower RLCT
- Large G → approaches full PPO landscape → λ_GRPO → λ_PPO

### C3 (CONJECTURAL): Critic-free landscape singularity reduction
PPO's value function V_φ(s) adds auxiliary parameters φ with their own singular structure. GRPO eliminates V_φ entirely, removing its singular fiber contribution. The total RLCT decomposes:
λ_PPO_total ≈ λ_π + λ_V (actor + critic singularities)
λ_GRPO ≈ λ_π alone
This predicts λ_GRPO < λ_PPO strictly, with the gap proportional to the critic's RLCT contribution.

### C4 (CONJECTURAL): KL penalty as regularized singularity
The KL divergence term β·KL(π_θ||π_ref) constrains optimization to a tube around π_ref. This tube intersects the singular fiber of the policy network. The KL penalty creates an effective "soft constraint" that:
- Prevents escape to high-multiplicity singular loci far from initialization
- Keeps the trajectory in a lower-multiplicity region → lower effective RLCT
- The penalty strength β acts as a continuous stratum selector: large β → tight tube → restricted stratum → lower λ; small β → wide tube → approaches unconstrained RLCT

### C5 (CONJECTURAL): σ_G → 0 singular locus and degenerate group collapse
When all G outputs receive identical reward (σ_G = 0), the advantage normalization A_i = (r_i - μ)/σ becomes undefined. This defines a singular locus:
- {θ : all G outputs have identical reward} is an algebraic variety in parameter space
- This locus has positive codimension → contributes to the singular fiber
- The RLCT near this locus may be higher (worse generalization) because gradient signal vanishes
- Training dynamics that avoid this locus (via exploration) implicitly select lower-RLCT strata
- Connection to mode collapse: if policy collapses, σ_G → 0 → singular region → generalization degrades

## Rough Cross-References
- #8 RLCT basics — definability framework
- #100 Transformer — base architecture for policy network
- #173 SAM — worst-case perturbation interaction with group normalization
- #223 LoRA rank selector — stratum selector analogy for β and G
- #385 SwiGLU — activation singularities in policy network
- #546 Paged attention — memory layout singularities in long-context GRPO
- #558 LoRA × RLCT — rank as stratum selector, analogous to G as stratum selector
- PPO (if covered) — direct predecessor with critic

## Open Problems
1. Exact form of f(G): how does group size modulate accessible singular strata?
2. σ_G → 0 locus geometry: is it a single irreducible variety or union of components?
3. KL tube × singular fiber intersection: transversality conditions
4. Empirical LLC measurement comparing GRPO vs PPO across architectures
5. Mixed group sizes (variable G per prompt): how does non-uniform G affect the stratum?
6. Multi-turn GRPO (DeepSeek-R1 style): accumulated rewards and singular structure of multi-step advantage
7. Reward model singularity: if reward is itself a neural network, its RLCT compounds with policy RLCT
8. Temperature sampling interaction: sampling temperature τ affects reward diversity → σ_G → stratum accessibility

## Pipeline Status
- L0 (rough paths): IN PROGRESS
- L1-L5: PENDING