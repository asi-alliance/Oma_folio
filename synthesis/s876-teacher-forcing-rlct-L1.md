# Oma Synthesis #876: Teacher Forcing × RLCT — L1 Formalization

**Date:** 2026-11-07  
**Status:** L1 — Formalized  
**Distinct from:** #382 (Scheduled Sampling × RLCT — covers epsilon-interpolation; #876 focuses on the structural singularity mismatch between regimes)

---

## Definitions

**D1 (Teacher-forced loss):** For an autoregressive model f(·; θ) with sequence length T, the teacher-forced loss is:
L_TF(θ) = Σ_{t=1}^{T} CE(f(x_t, y_{<t}; θ), y_t)
where y_{<t} are ground-truth tokens and CE is cross-entropy. Each term depends on θ through f applied to fixed inputs (x_t, y_{<t}), so the terms are independent given the fixed context.

**D2 (Free-running loss):** The free-running (autoregressive inference) loss is:
L_FR(θ) = Σ_{t=1}^{T} CE(f(x_t, ŷ_{<t}(θ); θ), y_t)
where ŷ_t(θ) = argmax_j f(x_t, ŷ_{<t}(θ); θ)_j recursively, with ŷ_0 = BOS. Each term depends on θ through both the direct model output and recursively through all previous generated tokens, each of which depends on θ.

**D3 (Argmax decision boundaries):** At each time step t and each pair of tokens (i, j), define the decision boundary:
D_{ij}(t) = {θ : f(x_t, ŷ_{<t}(θ); θ)_i = f(x_t, ŷ_{<t}(θ); θ)_j}
These are semi-algebraic sets (equalities of definable functions) that partition parameter space by the argmax selection. The free-running loss is piecewise-analytic on the complement of these boundaries, with the argmax selecting the active analytic branch.

**D4 (RLCT gap):** Let λ_TF be the RLCT of the teacher-forced true parameter set {θ : L_TF(θ) = 0} and λ_FR be the RLCT of the free-running true parameter set {θ : L_FR(θ) = 0}. Define:
Δλ = λ_FR - λ_TF
This gap is the singularity-theoretic measure of exposure bias.

**D5 (Coverage penalty):** Let S_TF be the set of singular strata of L_FR visited by training on L_TF. Define the coverage penalty:
C(Δλ, n) = (1/n) · μ({θ ∈ Θ_FR^sing : θ ∉ S_TF})
where μ is the posterior measure on L_FR-singular strata and Θ_FR^sing is the singular set of L_FR. This measures the fraction of free-running singularity structure unexplored under teacher-forced training.

**D6 (Sequence-length functional):** Define λ_FR(T) as the RLCT of the free-running loss at sequence length T. For small T, the recursive composition is shallow and λ_FR(T) ≈ λ_TF. For large T, the argmax branching creates exponentially many decision boundaries. Define the critical sequence length:
T* = n^{1/λ_TF}
where n is the number of training samples. For T >> T*, the recursive self-referential structure dominates and Δλ(T) becomes SLT-detectable.

**D7 (Fiber transversality):** Let Σ_TF(c) = {θ : L_TF(θ) = c} and Σ_FR(c) = {θ : L_FR(θ) = c} be the level-set fibers. The fibers are transverse at θ* if their tangent spaces satisfy:
dim(T_{θ*} Σ_TF) + dim(T_{θ*} Σ_FR) - dim(T_{θ*} Σ_TF ∩ T_{θ*} Σ_FR) = d
where d is the parameter dimension. If the recursive structure of L_FR creates singular directions absent in L_TF, the fibers may fail to be transverse, indicating structural mismatch.

## Formalized Claims

**C1 (PROVEN):** Both L_TF(θ) and L_FR(θ) are definable in R_{an,exp}.

*Proof:* L_TF is a finite sum of cross-entropy terms, each a composition of linear maps, softmax (restricted analytic), and CE (logarithmic, restricted analytic) — all in R_{an,exp}. The sum is definable by closure under addition.

For L_FR: At depth t, ŷ_t(θ) = argmax_j f(x_t, ŷ_{<t}(θ); θ)_j. The function f(·; θ) is in R_{an,exp} (composition of linear layers and activations). The argmax selection is definable: the set {θ : i = argmax_j f_j} is a semi-algebraic set defined by inequalities f_i ≥ f_j for all j. The graph of the argmax function is definable in R_{an,exp} by Tarski-Seidenberg projection. The recursive composition ŷ_{<t}(θ) is built by iterating this definable graph, and each iteration preserves definability. Thus L_FR(θ) = Σ_t CE(f(x_t, ŷ_{<t}(θ); θ), y_t) is a composition of definable functions, hence in R_{an,exp}. By Theorem #8.1, the RLCT is well-defined for both losses. □

**C2 (CONJECTURAL):** The free-running loss has strictly higher RLCT than the teacher-forced loss: λ_FR > λ_TF.

*Argument:* L_TF has a block-diagonal Jacobian structure: ∂L_TF/∂θ depends on each term independently through fixed inputs. The true parameter set {θ : L_TF = 0} is defined by T independent conditions, each constraining θ through a single forward pass with fixed context. In contrast, L_FR has a recursive Jacobian: ∂L_FR/∂θ at time t depends on θ through ŷ_{<t}(θ), which itself depends on θ through argmax decisions at all previous steps. This recursive self-referential composition creates additional singular directions in the Jacobian of L_FR that are absent in the block-structured Jacobian of L_TF. The argmax decision boundaries D_{ij}(t) introduce fold-type (A_1) singularities at each boundary crossing. The accumulation of these singularities across T steps increases the codimension of the singular fiber, giving λ_FR > λ_TF. The gap Δλ grows with T, as more recursive argmax branches contribute singular directions.

**C3 (CONJECTURAL):** Δλ = λ_FR - λ_TF is a formal, quantitative measure of exposure bias.

*Argument:* Exposure bias is the phenomenon where a model trained on L_TF generalizes poorly under L_FR evaluation. In SLT terms, training on L_TF concentrates the posterior on the singular strata of L_TF, but inference evaluates on L_FR which has different singular strata. The coverage penalty C(Δλ, n) (D5) measures the fraction of L_FR singular strata unvisited by L_TF training. When Δλ > 0, there exist singular directions in L_FR that are invisible to L_TF, and the model cannot learn to navigate them. The generalization gap under regime mismatch is:
G_mismatch(n) ≥ Δλ/(2n) · log(n) + C(Δλ, n)
This provides a singularity-theoretic explanation for exposure bias: it is not merely a distribution shift, but a structural singularity mismatch between training and inference loss landscapes.

**C4 (CONJECTURAL):** The generalization bound under teacher-forced training evaluated on free-running loss satisfies:
G_{TF→FR}(n) ≤ (λ_TF / (2n)) · log(n) + Δλ/(2n) · log(n) + C(Δλ, n)
= (λ_FR / (2n)) · log(n) + C(Δλ, n)

*Argument:* The first term is the standard SLT bound for training on L_TF. The second term accounts for the RLCT gap: the model concentrates on L_TF strata, but evaluation on L_FR requires coverage of additional singular strata. The coverage penalty C(Δλ, n) adds the cost of unvisited L_FR strata. The total bound is dominated by λ_FR, the RLCT of the evaluation loss, plus the coverage penalty. This predicts that exposure bias is SLT-detectable when Δλ is large relative to λ_TF, i.e., when the recursive structure creates many new singular directions.

**C5 (CONJECTURAL):** Sequence length T acts as a stratum selector with a phase transition at T* ~ n^{1/λ_TF}.

*Argument:* For T << T*, the free-running loss has shallow recursion and λ_FR(T) ≈ λ_TF, so exposure bias is negligible. For T >> T*, the exponential growth of argmax decision boundaries creates a rich singular structure and λ_FR(T) >> λ_TF, making exposure bias SLT-detectable. The transition at T* is a phase transition: below T*, the teacher-forced and free-running singular fibers are approximately transverse (D7); above T*, the recursive structure creates non-transverse fibers with qualitatively different singularity structure. This predicts that exposure bias becomes critical exactly when the sequence length exceeds the natural capacity T* of the model trained with teacher forcing, connecting to the effective horizon concept in sequence modeling.

## Open Problems

1. **Exact Δλ computation:** Can Δλ be computed for specific architectures (transformer, RNN) using resolution of singularities? Can the argmax boundary singularities be resolved explicitly?

2. **SGLD estimation of λ_FR:** Can SGLD on L_FR reliably estimate λ_FR? The recursive argmax creates discontinuities — does SGLD handle piecewise-analytic losses?

3. **Transversality verification:** Can fiber transversality (D7) be checked numerically? Does non-transversality correlate with exposure bias severity?

4. **T* empirical validation:** Can the critical sequence length T* ~ n^{1/λ_TF} be validated experimentally? Does exposure bias severity show a phase transition at T*?

5. **Connection to scheduled sampling (#382):** Scheduled sampling interpolates between L_TF and L_FR via epsilon. In SLT terms, this is a continuous deformation of singular strata. Does the RLCT vary continuously with epsilon, or is there a phase transition at epsilon*?

6. **Beam search (#388) and locally typical sampling (#390):** How do alternative decoding strategies affect the singular structure of the inference loss? Do they reduce Δλ compared to greedy argmax?

7. **Architecture dependence:** Does Δλ depend on attention mechanism, depth, or width? Do transformers have smaller Δλ than RNNs due to parallel token computation?

## Cross-References

#8 (definability), #16 (RLCT basics), #73 (stratum selection), #95 (curriculum), #127 (temperature), #143 (regularization), #170 (exposure bias), #201 (autoregressive), #213 (LR scheduling), #224 (argmax singularities), #233 (softmax temperature), #265 (phase transition), #327 (beam search), #334 (self-distillation), #354 (STE/argmax), #362 (CFG), #372 (RLCT estimation), #382 (scheduled sampling), #385 (LoRA), #388 (beam search), #390 (locally typical sampling), #482 (SAM), #508 (BN), #509 (GELU)

## Next Steps

- L2: Rigorous proofs for C1 (Tarski-Seidenberg application), formal arguments for C2 (recursive Jacobian singularity), C3 (exposure bias = RLCT mismatch), C4 (gen bound with coverage), C5 (T* phase transition)
- L3: Empirical validation — SGLD on L_TF vs L_FR to estimate Δλ across sequence lengths
- L4: Connections to #382 (scheduled sampling as RLCT annealing between strata)
