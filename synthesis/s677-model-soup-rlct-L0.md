# Synthesis #677: Model Soup × RLCT
## L0 Seed — 2026-10-28

### Bridge
Model soup averages weights of independently fine-tuned models (different hyperparams/inits) into a single model. This creates a point in the convex hull of multiple loss minima. The geometry of this hull relative to singular fibers is novel: averaging may land in a region with lower RLCT than any individual model.

### Claims
- **C1 (PROVEN)**: The weight-averaging map w_soup = (1/k)Σ w_i is a polynomial (linear) map, preserving R_{an,exp} definability via closure properties. The averaged loss L(w_soup) is definable.
- **C2 (CONJECTURAL)**: The convex hull of k independent fine-tuned minima may intersect lower-RLCT singular strata that no individual minimum occupies — "soup singularity" effect.
- **C3 (CONJECTURAL)**: Soup size k acts as a discrete stratum selector: larger k → higher probability of intersecting flatter singularities, with lambda_soup(k) non-increasing.
- **C4 (CONJECTURAL)**: Generalization bound for soup: Gen_soup ≤ C·sqrt(lambda_soup · (d_eff - 1) / n) where d_eff < d due to convex hull dimensionality reduction.
- **C5 (CONJECTURAL)**: Critical soup size k* exists beyond which adding more models yields diminishing RLCT reduction — k* ~ O(d/V) where V is local minima diversity.

### Key Insight
Individual fine-tuned models may sit on different singular fibers W_i with RLCTs lambda_i. The average w_soup lies in conv(W_1,...,W_k), potentially crossing into a deeper singular stratum with lambda_soup < min(lambda_i). This "interpolation singularity" has no analog in single-trajectory averaging (SWA).

### Open Problems
1. Characterize when convex hull intersects deeper strata vs when it leaves the singular locus entirely
2. Relationship between fine-tuning diversity and stratum intersection probability
3. Does greedy soup (sequential addition) follow an RLCT descent path?
4. Connection to linear mode connectivity and loss barriers
5. Effect of averaging across different architectures vs same architecture
6. Soup in function space vs parameter space for non-linear architectures
7. Interaction with RLCT of pretrained base model

### Cross-References
#232 (SWA × RLCT), #394 (early stopping × RLCT), #289 (weight decay × RLCT), #240 (weight tying × RLCT), #663 (distributed training × RLCT)

### Status
C1 PROVEN, C2-C5 CONJECTURAL. Next: L1 formalization.