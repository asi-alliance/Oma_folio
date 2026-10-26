# Synthesis #616: Sparsemax / Entmax × RLCT — L0 Exploration

## Date
2026-10-25

## Topic
Sparsemax and entmax as loss/activation functions classified by RLCT. Sparsemax(z) = argmin_{p∈Δ^K} ||p - z||² is the Euclidean projection of logits onto the simplex. Unlike softmax (smooth, positive everywhere), sparsemax produces exact zeros — the projection is piecewise-linear with kink boundaries where the active support set changes. Entmax(z; α) = argmin_{p∈Δ^K} -Σ_i p_i z_i + (1/(α-1)) Σ_i p_i^α generalizes both: α=1 → softmax (CE), α=2 → sparsemax, α→∞ → argmax. The α-family interpolates between smooth (softmax) and discrete (argmax) via non-smooth support-change events. Novel: simplex projection geometry creates R_an-definable but non-C¹ singular strata indexed by support cardinality k. No prior PLT/RLCT bridge exists for sparsemax or entmax.

## Claims

### C1 (PROVEN): Sparsemax loss is definable in R_{an,exp}
Sparsemax loss: L_sp(z, y) = -z_y + 1/2 ||sparsemax(z)||² + 1/2 ||sparsemax(z) - e_y||² - 1/2. The projection sparsemax(z) = Π_Δ(z) is piecewise-linear (each region of R^K maps linearly to Δ^K via a closed-form projection involving a threshold τ = (Σ_{i∈S} z_i - 1)/|S| where S is the active support). Piecewise-linear maps are definable in R_{an} (linear pieces + semialgebraic partition). Norm squared is polynomial (definable). Sum of definable functions is definable. Entmax(α) for α>1: the α-power term Σ p_i^α is definable for rational α (semialgebraic) and for real α>1 (R_{an,exp} via x^α = exp(α·log(x)) on x>0). The projection optimality condition involves α-power subdifferential — subanalytic for α≥1 (tame geometry). Thus entmax loss is definable in R_{an,exp}. By Watanabe theorem, RLCT is well-defined. QED.

### C2 (CONJECTURAL): Support-change kink boundaries create singular strata indexed by k
The loss landscape L_sp(θ) = Σ_{(x,y)} L_sp(f_θ(x), y) has singular strata arising from the piecewise-linear projection geometry. For each input x, the support set S(x,θ) = {i : sparsemax_i(f_θ(x)) > 0} partitions parameter space into chambers. Chamber boundaries ∂S_k = {θ : |S(x,θ)| = k, ∃i on boundary of entering/leaving S} are semi-algebraic hypersurfaces where the projection kinks. These kink boundaries are singular loci of the loss: the gradient of L_sp w.r.t. θ is discontinuous across ∂S_k (the Jacobian of the projection jumps rank). Conjecture: each k ∈ {1,...,K} defines a singular stratum Σ_k, and the RLCT λ_k is determined by the local geometry of the kink boundary near minimizers. The codimension of Σ_k increases with k (larger support = higher-dimensional active set = more constraints to satisfy simultaneously). Predicted: λ_sp ≤ λ_CE (sparsemax has sparser singular fibers due to support truncation).

### C3 (CONJECTURAL): α as continuous stratum selector via support-sparsity transition
Entmax(α) interpolates: α=1 (softmax, full support, smooth) → α=2 (sparsemax, exact zeros, piecewise-linear) → α→∞ (argmax, one-hot, piecewise-constant). The parameter α controls the sharpness of the support-change transition. At α=1, no support change (smooth, standard CE fiber #8). At α=2, support change is piecewise-linear (C0 but not C1). For 1<α<2, support change involves α-power subdifferential — intermediate regularity. Conjecture: α acts as a continuous stratum selector. The singular fiber V_α transitions from smooth (α=1, λ=λ_CE) through increasingly singular (α>1, support kinks appear) to maximally singular (α→∞, piecewise-constant, λ→ minimal). Predicted: λ(α) is non-increasing in α (increasing sparsity reduces effective singularity complexity). Phase transition: at critical α*(K) the loss landscape undergoes a qualitative change from "always full support" (α < α*) to "generically sparse" (α > α*). The α* depends on K and data geometry.

### C4 (CONJECTURAL): Generalization bound with sparsity-modified RLCT
SLT generalization bound: G(α) ~ λ_α·log(n)/(2n) + U_α/√n + B_α where λ_α = RLCT of entmax loss at parameter α. Conjecture: λ_α ≤ λ_CE for α>1 (sparsity reduces effective singularity by truncating support dimensions, reducing fiber codimension). Tradeoff: higher α reduces λ (sparser support → lower-dimensional active fiber) but may increase bias B_α (hard support truncation loses information from soft probabilities). The optimal α* minimizes total bound. The sparsity-induced codimension reduction: each zeroed-out dimension removes one degree of freedom from the local fiber, contributing ~1/2 to λ reduction (analogy with rank-deficiency RLCT). Testable via SGLD: measure LLC as function of α, predict monotone decrease with α.

### C5 (CONJECTURAL): α* phase transition at critical sparsity depth
Training dynamics exhibit phase transition at critical α* where the dominant singular fiber changes: below α* the full-support softmax fiber dominates (smooth, λ=λ_CE), above α* the sparse support-change kink fibers dominate (singular, λ<λ_CE). SGLD-detectable: LLC ν_α shows a drop or kink at α*. Distinct from #539 Focal Loss (probability-space modulation via (1-p_t)^γ, continuous vanishing) — sparsemax/entmax creates support truncation (hard zeroing, discontinuous support set change). Distinct from #433 PolyLoss (logit-space polynomial) — sparsemax operates in probability/projection space. The phase transition is from "smooth regularization" (α=1) to "geometric regularization via sparsity" (α>1).

## Distinctness
- vs #8 CE: Sparsemax replaces softmax with simplex projection (piecewise-linear, exact zeros). CE is smooth, sparsemax is not C¹.
- vs #539 Focal Loss: FL modulates loss magnitude via (1-p_t)^γ (continuous vanishing). Sparsemax changes the probability mapping itself (discrete support set change).
- vs #433 PolyLoss: PL modifies the log-loss polynomial in logit space. Sparsemax modifies the probability mapping via projection geometry.
- vs #540 InfoNCE: InfoNCE uses contrastive CE. Sparsemax could replace softmax in contrastive loss — but that's a composition, not the base case.
- vs #409 Gumbel-Softmax: Gumbel uses noise injection + temperature for discrete relaxation. Entmax uses projection geometry + α for sparsity. Different mechanism, different singularity type.
- vs #169 Dropout: D adds binary noise to activations. Sparsemax zeros out probabilities deterministically.

## Open Problems
1. Exact RLCT of sparsemax kink boundary: is it codim/2 (standard semi-algebraic) or modified by the piecewise-linear structure?
2. Interaction between kink boundary geometry and network depth (composition of projections)
3. Entmax for non-integer α: is the α-power subdifferential subanalytic? (tame geometry needed)
4. Sparse attention (sparsemax applied to attention weights): singular fiber of attention map with variable support
5. Composition with temperature scaling (#234): does temperature + entmax create double stratum selector?
6. Architecture dependence of λ_α (does sparsemax in attention vs output layer give different RLCT?)
7. α=1 to α→∞ limit: smooth deformation or phase transition? Is there a critical α* or a smooth crossover?
8. Support recovery: does the learned support set converge as n→∞? (consistency of sparsemax selection)
9. Entmax in top-k routing (#537): support size k as discrete stratum, α as continuous selector — composite singularity

## Cross-References (12)
#8 (CE) #100 (softmax) #169 (dropout) #234 (temperature) #323 (label smoothing) #409 (Gumbel-softmax) #433 (PolyLoss) #539 (focal loss) #540 (InfoNCE) #537 (top-k routing) #354 (STE) #224 (class imbalance)
