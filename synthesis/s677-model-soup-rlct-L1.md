# Synthesis #677: Model Soup × RLCT
## L1 Formalization — 2026-10-28

### Definitions

**D1 (Parameter Space):** Let W subset R^d be the parameter space. Each model w_i in W is obtained by fine-tuning from independent initialization/hyperparameters. The set {w_1,...,w_k} represents k independently fine-tuned models.

**D2 (Averaging Map):** Define phi_k: W^k -> W by phi_k(w_1,...,w_k) = (1/k) Sum_{i=1}^{k} w_i. This is a linear (hence polynomial) map from R^{kd} to R^d.

**D3 (Definability):** The training loss L: W -> R is R_{an,exp}-definable. Since phi_k is polynomial (definable), the composition L circle phi_k is R_{an,exp}-definable by closure under composition. The soup loss L_soup(w_1,...,w_k) = L((1/k) Sum w_i) is definable.

**D4 (Singular Fiber and Convex Hull):** For target t, the singular fiber is W_t = {w in W : L(w) = t}. The convex hull of k minima is Conv(w_1,...,w_k) = {Sum alpha_i w_i : alpha_i >= 0, Sum alpha_i = 1}. The soup point w_soup = phi_k(w_1,...,w_k) lies in this hull at the barycenter.

**D5 (RLCT of Soup):** Define lambda_soup(k) = RLCT(W_t, w_soup), the RLCT at the averaged point. For individual models, lambda_i = RLCT(W_t, w_i). The key quantity is the comparison lambda_soup vs min_i lambda_i.

**D6 (Effective Dimension):** d_eff(k) = dim(Conv(w_1,...,w_k)) <= min(k-1, d). The generalization bound uses d_eff in place of the full parameter dimension d, reflecting convex hull dimensionality reduction.

**D7 (Critical Soup Size):** k* = inf{k : lambda_soup(k+1) - lambda_soup(k) < epsilon} for threshold epsilon > 0. This marks the phase transition beyond which adding models yields negligible RLCT reduction.

### Theorems

**C1 (PROVEN): Definability of Soup Loss**
The map phi_k is polynomial, hence R_{an,exp}-definable. L is R_{an,exp}-definable by assumption. By closure of definable functions under composition (Tarski-Seidenberg theorem for R_{an,exp}), L circle phi_k is definable. QED.

**C2 (CONJECTURAL): Soup Singularity**
There exist k and configurations {w_i} such that lambda_soup(k) < min_i lambda_i. The convex hull of distinct singular fibers can intersect a deeper singular stratum inaccessible to individual minima. This is the "interpolation singularity" effect.

**C3 (CONJECTURAL): Stratum Selection by Soup Size**
lambda_soup(k) is non-increasing in k in expectation over random fine-tuned models, with lambda_soup(k) -> lambda_* (the RLCT of the deepest accessible stratum) as k -> infinity. Larger soup = higher probability of intersecting flatter strata.

**C4 (CONJECTURAL): Generalization Bound**
Gen_soup <= C * sqrt(lambda_soup * (d_eff(k) - 1) / n) where d_eff(k) <= k-1. For k << d, this is tighter than the individual bound C * sqrt(lambda_i * (d-1)/n). The improvement comes from both lower lambda_soup and lower d_eff.

**C5 (CONJECTURAL): Phase Transition at k***
Critical k* ~ O(d / V) where V = E[||w_i - w_j||^2] measures fine-tuning diversity. Beyond k*, additional models yield sublinear RLCT reduction. High diversity (large V) delays k*; low diversity (models cluster) means k* is small.

### Proof Sketch for C2

Individual minima w_i lie on singular fibers W_{t_i} with RLCTs lambda_i. The interpolation path {alpha w_i + (1-alpha) w_j : alpha in [0,1]} crosses regions of W not contained in any single fiber. If the loss landscape has a singular stratum S subset W with RLCT(S) < min_i lambda_i, and Conv(w_1,...,w_k) intersect S is nonempty, then w_soup may lie in or near S, yielding lambda_soup < min lambda_i.

Linear mode connectivity (Frankle et al.) ensures the interpolation stays in low-loss regions when models share a initialization or are in the same basin, making this intersection plausible. The key distinction from SWA (#232): SWA averages along a single trajectory within one basin, so it cannot cross into new strata. Model soup averages across independent basins, enabling stratum crossing.

### Distinction from SWA (#232)

- SWA: averages checkpoints from one training trajectory -> stays within one singular fiber, RLCT unchanged or slightly reduced by noise averaging
- Model soup: averages independently fine-tuned models -> can cross between singular fibers, potentially reaching deeper strata
- The convex hull geometry is qualitatively different: SWA hull is 1D (trajectory segment), model soup hull is (k-1)-dimensional

### Cross-References
#232 (SWA x RLCT), #394 (early stopping x RLCT), #289 (weight decay x RLCT), #240 (weight tying x RLCT), #663 (distributed training x RLCT), #497 (matryoshka x RLCT)

### Status
C1 proven, C2-C5 conjectural. Next: L2 (literature grounding), L3 (empirical predictions).