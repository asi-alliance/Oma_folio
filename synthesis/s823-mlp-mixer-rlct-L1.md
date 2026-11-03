# Synthesis #823: MLP-Mixer × RLCT - L1 Formal Definitions
# Date: 2026-11-03
# Pipeline: L0 COMPLETE (s823-mlp-mixer-rlct-L0.md) | L1 formalization

## D1: MLP-Mixer Architecture and Parameter Space

Input X in R^{S×C}, S spatial tokens, C channels.
Token-mixing weights: W_1 in R^{S×S}, applied as X_tilde = W_1 @ X (mixes across spatial positions for each channel).
Channel-mixing weights: W_2 in R^{C×C}, applied as Y = X_tilde + W_2 @ X_tilde^T (mixes across channels for each token).
Full block: X_tilde = F(X + W_1 @ X), Y = G(X_tilde + W_2 @ X_tilde^T) where F, G are NN activations (GELU/ReLU).
Layered blocks: block_p = F_{L_p} ∘ ... ∘ F_1, each F_l = mixing + activation.
Parameters: θ = (W_1^{(l)}, W_2^{(l)}, b_1^{(l)}, b_2^{(l)})_{l=1}^{L}

## D2: MLP-Mixer Loss Function
Standard classification loss:
  L(θ) = (1/n) Σ_{i=1}^n ce(Y_i(θ), y_i)
where Y_i(θ) = f_{L_T}(θ, x_i) is the forward pass of sample x_i.
Ce is softmax: ce(z, y) = -z_y + log(Σ_{k=1}^{Y} e^{z_k}).

## D3: Zero-Loss Sets and Dual Fibers
Token-mixing zero-loss fiber:
  V_T(θ) = {θ : f_T(θ, x_i) = y_i for all i}
  Token-mixing is involved in both f_T and preserves spatial order through W_1.
Channel-mixing zero-loss fiber:
  V_C(θ) = {θ : f_C(θ, x_i) = y_i for all i}
  = {θ : f_{L_T}(θ, x_i) = y_i for all i}
Joint fiber: V_{LT} = V_T(θ) ∩ V_C(θ).

## D4: Singular Fiber Structure Under Dual Permutation
Spatial permutation group S_N acts on W_1 and input order:
  For P ∈ S_N, f_T(Px[P], θ, Px) = Pf_T(θ, x) where Px is permuted input.
  This gives fiber: V_T(θ) / S_N, fiber dim ≈ log(N!).
Channel permutation group S_C acts on W_2:
  For Q ∈ S_C, f_C(Qθ, Qy) = Qf_C(θ) with channels permuted by Q.
  This gives fiber: V_C(θ) / S_C, fiber dim ≈ log(C!).
Product fiber: S_N × S_C acts on joint fiber: V_{LT} / (S_N × S_C).
The orbifold R^{S_N × S_C} has the spatial and channel symmetries interacting non-trivially due to the sequential composition of mixing blocks.

## D5: Effective RLCT Under Dual Permutation Averaging
Generic fiber RLCT for token-mixing: λ_T = codim(sing(f_T))/2 under non-degenerate fiber.
Generic fiber RLCT for channel-mixing: λ_C = codim(sing(f_C))/2.
Joint RLCT for full architecture:
  λ_{MM}(N) = λ_T + λ_C + λ_{(S_N×S_C - E_C)} - log(2)
where λ_{int} captures interaction portions of the fiber.
  Product fiber contribution = structure of orbifold singularities.
Conjecture: λ_{int} > 0 unless product fiber is smoother (more symmetries to resolve).

## D6: Stratum Selectors
The ratio R = S/C acts as a grand stratum selector:
- R ≪ 1: wide tokens, few channels ⟹ token-mixing dominates (large S_N), token-mixing RLCT dominates field)
- R ≫ 1: few tokens, wide channels ⟹ channel-mixing dominates, large S_C.
R = 1: balanced contribution, potentially additive resulting in λ ≈ log(N!) + log(C!).
- Width L: depth directly controls composition depth, affecting fiber complexity.
- Depth L: more composition ⟹ more symmetry-breaking configurations ⟹ smaller λ_{int}.
Conjecture: λ_{MM}(L, S) < min {λ_T/2, λ_C/2}

## D7: Generalization Bound
E[L_{test}^{MM}] ≡ E[L_{tr}] + C * sqrt{λ_{MM}(L, S) * log(n) / n}
where λ^{MM}(L, S) = λ_T + λ_C + λ_{int} + λ_{path}(log(S_N × S_C)^d).
Approximately:
  λ_{MM} ≈ log(N!) + log(C!) + log(d(S × Channel)) + L * d(S × Channel)^2.
## Claim Status

C1 PROVEN: MLP-Mixer loss is R_{an,exp}-definable.
  - W_1 @ X and W_2 @ X_tilde^T are polynomial maps
  - GELU/ReLU activation (s) is order finite and composition of definable maps is definable.
  - Softmax ce involves exp, definable.
  - Composition closure preserves definability.

C2 CONJECTURAL: Dual permutation fibers orbifold singularity ⟹ singular locus of R^{S_N × S_C} orbifold is a model where both symmetries are broken. Empirically proving that the product fiber contributes a term λ_{int} > 0.
  Not proven: exact dimension of orbifold strata, interaction transversality, data-dependent breaking pattern.

C3 CONJECTURAL: Stratum selector R = S/C.
  R controls which permutation group dominates. R=1 asserts balance, maximizing interaction complexity.
  Logical transition: if none is spatial then S_N is desired to break first.

C4 CONJECTURAL: Generalization bound depends on λ_{MM}(L, S).
  R-1 gives λ_{int} = log(N!) + log(C!) - log(2), an additive product singularity correction.
  Semi-additivity: entails if both fibers resolve additively and interaction term is formally saddle.

C5 CONJECTURAL: Phase transition at R = S/C = 1.
  With Wreath group sizes are weighted competition, SGLD would be able to fit completion of additive and interaction contributions as function of R Starting at Generic RLCT = log(N!) + log(C!) - log(2)
  Semi SGLD must be able to disriminish the dominant fiber from interaction.
## Open Problems

1. Equivariance up to symmetry-breaking: experimentally does equivariant operation (token order shondertling) indicate fiber resolution via SGLD? 2×spatial + 2 × channel fibers=.
2. Dimensional stratification of S_N × S_C: does applying Mackay stratification to R^{S_N × S_C} work?
3. Is there a different RLCT for token-mixing vs channel-mixing fibers, or are they isomorphic?
4. Connection to sparse MLP (#500 × #545): does the dual symmetry create additional sparsity or substitute?
5. Connection to MoE (#434): MoE gating selects routes across experts = group action symmetry on channels, while MLP-Mixer mixes all channels uniformly -- complementary singular structure.

## Cross-References
#496 (CoT × RLCT), #434 (MoE × RLCT), #500 (Token Merging), #546 (BPE/Tokenization), #545 (sparse MLP), #169 (dropout), #490 (RoPE), #221 (BatchNorm), #468 (PPO clip), #822 (Manifold Mixup)
