# S814: Data Deduplication × RLCT — L0 Exploration

## Technique Summary
Data deduplication removes duplicate or near-duplicate training examples from the dataset before training. This reduces effective dataset size, prevents memorization of repeated patterns, and is standard practice in modern LLM pretraining. The key insight is that duplicates create non-uniform sampling of the data distribution, biasing the empirical loss toward frequently-occurring examples.

## Key RLCT Bridge
The empirical loss L_n(w) = (1/n) Σ_i ℓ(w, x_i) assigns weight k_i/n to each unique example if it appears k_i times. Duplicates of example x create degenerate copies of the same loss contribution ℓ(w, x) in the sum. The singular fiber V_0^{dup} is defined by the weighted system where high-multiplicity examples dominate the gradient, creating a "bumpy" landscape with reinforced singular directions. After dedup, V_0^{dedup} has uniform 1/n weighting, allowing the optimizer to explore a smoother stratum structure. The RLCT changes because the effective loss landscape geometry changes — high-multiplicity examples create deeper wells (lower effective loss locally) that trap optimization in singular strata associated with memorization rather than generalization.

## Claims
- C1 (PROVABLE): R_an,exp definability — the empirical loss with multiplicity weights is a finite sum of analytic terms. Dedup changes integer multiplicities k_i → 1 but the loss remains in R_an,exp. ✓
- C2 (CONJECTURAL): Multiplicity-induced singularity — high-multiplicity examples create locally deep wells in the loss landscape. The singular fiber V_0^{dup} has degenerate directions reinforced by repeated gradients, increasing local RLCT along memorization strata: λ_dup ≥ λ_dedup for those strata.
- C3 (CONJECTURAL): Dedup as stratum selector — removing duplicates acts as a discrete selector on the data distribution, shifting the accessible singular set. The dedup threshold ε (for near-duplicate detection) partitions the data into unique clusters, and ε controls which examples are merged, analogous to a stratum selector parameter.
- C4 (CONJECTURAL): Generalization bound — G_dedup ≤ λ_dedup · log(n') / (2n') + U_dedup / sqrt(n') where n' < n is the deduplicated size. The bound is tighter when λ_dedup < λ_dup · (n'/n) because both the RLCT and the complexity term decrease. However, if dedup removes too many examples, n' shrinks and the bound worsens — predicting an optimal dedup ratio.
- C5 (CONJECTURAL): Phase transition at optimal dedup ratio r* = n'/n — there exists a critical dedup ratio where the generalization bound is minimized. Below r*, removing duplicates helps (lower λ, less memorization); above r* (over-aggressive dedup removing diverse examples), n' shrinks too much and variance dominates. SGLD on deduped vs deduplicated data should reveal an LLC transition.

## Open Problems
1. Formal characterization of multiplicity-induced singularity: does k-fold duplication increase RLCT by exactly log(k) or by a model-dependent amount?
2. Near-duplicate vs exact duplicate: how does the fuzzy matching threshold ε map to a continuous stratum selector?
3. Interaction with #582 curriculum learning: does curriculum ordering on deduplicated data change the stratum traversal?
4. Effect on #327 pseudo-labeling: dedup of pseudo-labeled data — does it prevent confirmation bias?
5. Does dedup change the Fisher information matrix rank or just its eigenvalue spectrum?
6. Relationship to #178 unlearning: removing duplicates is a form of data-side unlearning — shared fiber structure?
7. Optimal dedup ratio prediction: can RLCT theory predict r* from model capacity d and dataset size n?

## Cross-References
#582 Curriculum Learning, #327 Pseudo-Labeling, #178 Unlearning, #253 Model Collapse, #543 Dataset Distillation, #548 Mixup, #433 Weight Decay, #169 Dropout, #95 Curriculum

Next: L1 formalization with D1-D7 definitions and C1 proof.