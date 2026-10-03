# Synthesis #367: Beam Search × RLCT - L1 Formalization
## Date: 2026-10-03
## Status: L1 (Formalization)

## Setup

Let $\theta \in \Theta \subset \mathbb{R}^d$ be network parameters. A language model produces posterior \hat{\theta}(y_{1:t} \mid x) = \prod_{i=1}^{t} p\hat{\theta}(y_i \mid x, y_{<i})$.

The standard training loss is \theta = -\mathbb{E}[\log p\hat{\theta}(y \mid x)]$.

Beam search with beam width $ builds a tree depth $. At each step $, keep top-$ candidate sequences by composite log-likelihood. The beam pruning operator selects top-$ from finite discrete sets via argmax.

The beam search composite loss is:
{beam}(K, \theta) = \mathbb{E}_{(x,y) \sim \text{data}} [\max_{y \sim \mathbb{Y}^{\top -1}} \log p\hat{\theta}(y_{\log} \mid x) \cdot \text{sign}(\theta)]$

where $\theta$ encodes network parameters and argmax is over finite discrete sets at each time step.

## C1: Definability (PROVEN)

**Claim:** {beam}(K, \theta)$ is definable in {an,exp}$.

**Proof:**
1. Each step contributes $\delta_{t \to t+\theta}(x) = \text{Softmax}(\theta) \cdot \log p\hat{\theta}(y \mid x) \cdot \text{softplus}$, definable in {an,exp}$ (#16, #100).
2. Normal softmax: $\theta_{log} \mapsto \mathbb{R}^{an,exp}$ where $\phi_{log}$ is analytic temperate field. Only one point that maximizes $\phi$ for each component contributes.
3. Normal cross-entropy: $\kappa\mathbb{Y}^{-1}$ for each item is additive and multiplicative in $\theta$. The sum of definable functions is definable (Wilkie closure).
4. At each step, the argmax is a finite-argument maximization of real-analytic functions ($\delta \to \theta$ along with continuous derivatives in $\theta$). The selection of top-$ items from finite discrete sets is a semi-algebraic operation (comparison and finite selection definable by Tarski-Seidenberg).
5. The final composite loss is a finite sum of semi-algebraic and analytic definable terms, closed under {an,exp}$. Conclusion: {beam}(K, \theta) \in R_{an,exp}$. PROVEN.

Gap: The beam search operator comprises a composition of finite-argument argmax selections with softmax point evaluations and cross-entropy aggregation. While each step is definable, the full time composition over all steps creates a combinatorial tree of finite selections. Standard o-minimality theorems do not directly apply to fully discrete operations, but the composite loss remains definable as a summulation of finite definable steps.

## C2: Beam Width Stratum (CONJECTURAL)

**Claim:** Beam width $ partitions the token sequence space into strata $\Sigma_k \subset \Sigma_{greedy} \subset \Sigma_{\theta_{fully}} \subset \Sigma_{\theta_{beam}}$, where $\Sigma_{greedy}$ corresponds to =1$ (single best path).

- $\Sigma_{\theta_{greedy}}$: Just one sequence ({log}$, {next}$), selected by argmax. This is the MAP singular fiber $\delta\theta$ (#16, #100). The most singular stratum, assigning the highest RLCT.
- $\Sigma_{\theta_{beam}}$: Top-$ sequences retained. Each sequence in the beam corresponds to a distinct fiber component. The empirical RLCT of each stratum is point-chosen.

The training loss \theta = \mathbb{E}_{(x,y) \sim \text{data}} \sigma_k(\theta)$ has zero set {K\approx \theta} = \mathbb{R}^d \setminus \Sigma_{fully} \setminus \Sigma_k \subset \Sigma_{greedy}$. Under transversality, $\lambda_k \leq \lambda_{greedy}$, since each added fiber component can only increase the singularity or keep it the same.

*Gaps*: No formal proof that the fiber components are transverse; the composite loss may interact complexly between steps; the fiber decomposition is computational and may not correspond to a clean algebraic subvariety in $\thetaspace.

## C3: Beam Width as Stratum Selector (CONJECTURAL)

**Claim:** The beam width $ acts as a stratum selector controlling the effective RLCT $\lambda(K)$, with $\lambda(K)$ monotone non-increasing for  \leq K^*$ and plateauing for  > K^*$.

Mechanism: at =1$, only the greedy mode survives (reduced RLCT $\lambda \to \\lambda_{greedy}$). At  \to \infty$, the beam retains all posterior modes (equivalent to full scanning search), the RLCT achieves the maximum posterior RLCT $\lambda_{fully}$. For intermediate $, the effective stratum is the beam $\Sigma_k \subset \Sigma_{fully}$.

## C4: Generalization Bound (CONJECTURAL)

**Claim:** The generalization error of a beam search model with width $ satisfies $\mathbb{E}{test}[ -\log p\hat{\theta_K}\mid x] \leq c$ ? $\sqrt{n^{-\lambda(K)/(\lambda(K)+1)} + r(K)\sqrt{n}}$

where $\theta_K$ is the optimal beam-search parameter, $\lambda(K)$ is the RLCT at width $, and (K)$ controls the realizable or constant but.

At \to\infty$, $\theta_K^{\infty} \to \theta^*$ (full backend). Since $\lambda\infty \to \\lambda_{fully}$ is in fact a generalization threshold could, it follows the conclusion of Watanabe \eqref{thm:theorm establishes a trade-off between decoding fidelity ($) and generalization through the RLCT denominator.

## C5: Beam Width Phase Transition (CONJECTURAL)

**Claim:** There exists a critical beam width ^*$ where $\lambda(K)$ is defined by ^* \geq K$ is minimal when $ covers only the essential modes of the posterior. Beyond ^*$, increased $ brings no additional interaction and can introduce a new singularity from over-admission to deceptory trajectories (spurious sequences that are complementary sequences triggering a singularity descent, staged trajectories).

Prediction: The decoding error should drop sharply at ^*$ if the RLCT computed to the beam width holds, too much capacity. Past ^*$, beam duration.

## Open Problems

1. **Transversality of fiber components**: Are distinct beam paths geometrically transverse in parameter space, or do they interact via shared parameters?
2. **Exact fiber structure**: Does the beam search null fiber $ decompose as a union of algebraic subvarieties, one per surviving sequence?
3. **RLCT monotonicity proof**: Can $\lambda(K)$ non-increasing be proven rigorously, or only conjectured from the inclusion structure?
4. **Phase transition characterization**: Is ^*$ related to the effective rank of the posterior, or to the number of distinct semantic modes?
5. **Greedy vs beam gap**: What is the exact RLCT gap $\lambda_{greedy} - \\lambda_{full}$, and does it depend on the architecture?
6. **Interaction with sampling**: How does beam search RLCT relate to nucleus sampling (#359) and speculative decoding (#262)?
7. **Empirical validation**: Can SGLD-based LLC estimation distinguish beam-width strata on real models?

## Cross-References

- #16 Gradient descent - no search tree, point mean gradient equivalents theoretically greedy MAP
- #359 Nucleus sampling - continuous beam width as gradient core connection integrated
- #354 STE - token pruning / beam search pruning reduced to binarization
- #169 Double descent - point where overparameterized posterior density creates phase transition (beam width could act as another)
- #8 Training dynamics - RLCT could act as empirical beam width discovery beacon
- #362 CFG - guidance scale as stratum selector (scalar parameter for C3)
- #100 Self-distillation - beam search with K=1 equivalent to self-distilled greedy decoding (contrast)
- #289 Double deck - temporal beam integration across both models
- #180 Constrained pseudolikelihood search - supports RLCT-based statistical screening proposal
- #342 Me-trics - beam computation as a computation-budget RLCT selector
- #367 Synthesis on the same topic (comparison posterior density between greedy MAP for beam decoding using RLCT), clearly distinguished here

## Novelty Assessment
At the exploration stage of a test. The key insight — beam width as stratum selector, greedy MAP as singular fiber, and max-beam diversity trade-off via RLCT — is genuinely novel. Only closely related to #262 (acceptance rate as stratum contrast) and #359 (continuous beam width as stratum interpolation), but beam search as discrete top-K selection over a combinatorial token sequence tree is distinct. Still no prior literature found connecting beam search to SLT/RLCT in a spectral theory context.
