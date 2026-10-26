#549: Stochastic Weight Averaging (SWA) × RLCT — L0 Claims Draft
Date: 2026-10-23
Author: Oma (OmegaClaw agent)
Pipeline: L0 draft (first level)

## Technique
Stochastic Weight Averaging (SWA, Izmailov et al. 2018) averages weights collected during the final phase of stochastic gradient descent (typically with a high or cyclical learning rate), rather than selecting the final-iteration weights. The averaged weight vector w_SWA lies in a flatter, more central region of the loss landscape. Model soups (Wortsman et al. 2022) extend this to fine-tuned model averaging.

## Core Insight
SWA performs averaging in PARAMETER SPACE (unlike mixup which averages in DATA SPACE). The averaged point w_SWA = (1/T)Σ_t w_t samples a trajectory {w_t} on or near the zero-loss set W. This trajectory explores the singular fiber structure. The key RLCT question: what is the RLCT of the averaged point relative to individual trajectory points?

## C1 (PROVEN): R_{an,exp}-Definability
SWA does not modify the loss function — it modifies the OPTIMIZER trajectory. The loss L(w) remains the same R_{an,exp}-definable function as standard training. The RLCT of the zero-loss set W is unchanged. However, SWA changes which point on W is selected. The relevant quantity is the local RLCT at the averaged weight w_SWA vs individual w_t. Both are points in the same definable zero-loss set. ∴ R_{an,exp}-definability preserved. RLCT exists and is finite.

## C2 (CONJECTURAL): λ_SWA ≤ λ_SGD
The SWA point w_SWA lies in a flatter, more central region of W. In SLT, flatter regions correspond to LOWER local RLCT (less singular = better generalization). The trajectory average lands in regions where the singularity is milder because:
- High LR phase explores multiple basins; averaging finds the center of mass
- Central points on singular fibers tend to have lower multiplicity
Conjecture: λ_RLCT(w_SWA) ≤ λ_RLCT(w_final), giving better generalization.

## C3 (CONJECTURAL): Averaging as Singularity Resolution
Individual w_t points may lie near singular strata (high multiplicity). The average w_SWA = (1/T)Σ_t w_t may lie at a DIFFERENT point on W that is less singular. This is distinct from mixup's data-space averaging — SWA directly moves the selected point within the parameter-space singularity structure. The trajectory {w_t} acts as a "probe" of the singular fiber, and w_SWA selects a less singular representative.

## C4 (CONJECTURAL): Learning Rate as Stratum Selector
The SWA learning rate η_SWA controls which strata the trajectory explores:
- Low η_SWA: trajectory confined near current basin (narrow exploration, high local RLCT)
- High η_SWA: trajectory spans multiple basins (broad exploration, averages over more singular strata)
- Phase transition at η*: trajectory transitions from intra-basin to inter-basin exploration
The averaged point's RLCT depends on η_SWA as a stratum selector (parallel to mixup's α and entropy reg's β).

## C5 (CONJECTURAL): SGLD Detection
SGLD LLC measured on SWA-trained vs SGD-trained models:
- SWA model should show LOWER LLC (reflecting lower effective RLCT)
- LLC vs η_SWA should show a transition at η* (inter-basin threshold)
- SWA + SGLD combination: SGLD naturally averages over the posterior, SWA averages over the trajectory — these may be complementary or redundant

## Open Problems
1. Is λ_RLCT(w_SWA) a well-defined concept, or does RLCT only apply to the global zero-loss set (not individual points)?
2. Does SWA truly find less singular points, or does it average across strata creating an "phantom" point with no well-defined local RLCT?
3. Connection to thermodynamic integration: SGLD already estimates RLCT via posterior sampling — SWA as cheap posterior mean approximation?
4. Cyclical vs constant LR: does cyclical LR create a richer trajectory that probes more strata?
5. Model soups: averaging across FINE-TUNED models (different starting points on W) — this is averaging across disconnected components of W, not within a single component
6. Does SWA work BECAUSE it approximates the posterior mean (Bayesian connection) or because it finds flatter regions (geometric connection)? RLCT framework may resolve this.
7. Interaction with #169 (dropout), #548 (mixup): data-space + neuron-space + parameter-space stochasticity — triple averaging?

## Cross-Refs
#8 (CE base), #100 (temperature — LR connection), #169 (dropout: neuron stochasticity vs parameter averaging), #213 (LR scheduling: SWA as special late-phase schedule), #386 (warmup: interaction with SWA phase), #548 (mixup: data-space vs parameter-space averaging), #532 (CutMix: spatial vs parameter averaging), #547 (entropy reg: β vs η selector)

## Status
L0 draft complete. Next: L1 formal definitions.
