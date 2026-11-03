# Synthesis #667: KTO (Kahneman-Tversky Optimization) × RLCT — L0 Hypothesis
## Date: 2026-10-28

## Topic
KTO (Kahneman-Tversky Optimization) — a preference optimization method that replaces DPO's pairwise comparison with a single-sample utility function derived from prospect theory (Kahneman & Tversky, 1979). Instead of requiring paired (preferred, rejected) examples, KTO optimizes a per-token utility: desirable outputs are upweighted and undesirable outputs are downweighted using an asymmetric value function with loss aversion parameter κ.

The KTO loss is:
  L_KTO = E_{y~desirable}[1 - σ(β · (log π(y|x)/π_ref(y|x) - z_ref))]
        + κ · E_{y~undesirable}[σ(β · (log π(y|x)/π_ref(y|x) - z_ref))]
where z_ref is a reference log-ratio baseline, β is a temperature, and κ > 1 is the loss aversion coefficient.

## Why RLCT?
KTO introduces fundamentally novel singular structure compared to DPO (#599):
1. **Asymmetric singular fibers**: The loss aversion κ creates a non-symmetric loss landscape. Desirable and undesirable samples trace different singular varieties — V_desirable ≠ V_undesirable — with different RLCTs λ_+ and λ_-. The effective RLCT is a weighted combination governed by κ.
2. **Prospect-theory value function as stratum selector**: The reference baseline z_ref acts as a reference point (analogous to Tversky's reference dependence). Points where log π/π_ref = z_ref define the singular boundary — the "reference point" in parameter space. This is a single-sample generalization of DPO's Δ=0 boundary.
3. **Loss aversion as RLCT asymmetry**: κ > 1 means the loss landscape is steeper on the undesirable side, compressing singular fibers more aggressively. This predicts λ_- < λ_+ (undesirable fiber is more constrained = lower RLCT), giving KTO an implicit regularization effect that differs from DPO's symmetric pairwise structure.
4. **No pairing requirement**: KTO's single-sample structure means the singular variety is defined per-sample, not per-pair. This creates a product-space fiber over individual samples rather than DPO's coupled pair-fiber, fundamentally altering the singularity type.

## Hypotheses
- **C1 (Provable)**: The KTO loss is R_{an,exp}-definable. It is composed of σ (analytic), log π/π_ref (exponential definable), polynomial arithmetic, and constants κ, β, z_ref. By closure under these operations, L_KTO ∈ R_{an,exp}.
- **C2 (Conjectural)**: The KTO singular variety V_KTO has asymmetric fiber structure: V = V_+ ∪ V_- where V_+ (desirable) and V_- (undesirable) are distinct singular strata with λ_+ ≠ λ_-. The reference point log π/π_ref = z_ref defines the stratum boundary.
- **C3 (Conjectural)**: κ acts as a continuous stratum selector. As κ increases, the undesirable stratum V_- is compressed (lower λ_-), creating a phase transition at κ* where V_- collapses to a lower-dimensional stratum.
- **C4 (Conjectural)**: λ_KTO ≤ λ_SFT (KTO implicitly regularizes via the reference-point constraint and loss aversion). Additionally, λ_KTO ≠ λ_DPO in general because the fiber structures differ (single-sample vs pairwise).
- **C5 (Conjectural)**: There exists a critical β* × κ* phase transition surface where the optimal generalization is achieved. Too high κ over-constrains V_- (under-fitting undesirable); too low κ makes V_- too large (poor regularization).

## Key Questions
1. How does the single-sample fiber structure of KTO differ from DPO's pairwise fiber? Does the absence of coupling reduce or increase the singularity dimension?
2. Is the reference point z_ref a fixed point of the training dynamics? Does it create a gauge-like degeneracy similar to DPO's reference model quotient?
3. Does loss aversion κ create a non-smooth singularity at the reference boundary (kink in value function, like Tversky's piecewise-linear value function)?
4. How does KTO interact with the RLCT of the SFT-pretrained model? Does the reference-point shift create a translation of the singular locus?

## Cross-References (anticipated)
#599 (DPO × RLCT — pairwise preference boundary, β as stratum selector), #602 (PRM × RLCT — per-step reward structure), #579 (GRPO × RLCT), #468 (PPO clip boundary), #362 (CFG guidance scale as stratum selector), #224 (label smoothing), #136 (RLHF), #167 (diffusion score matching)

## Distinction from #599 DPO
DPO uses pairwise comparison: loss couples (y_w, y_l) via sigmoid of log-ratio difference. KTO uses single-sample utility: loss applies asymmetrically per sample. The fiber structures are fundamentally different:
- DPO: coupled pair-fiber (V_w × V_l → single fiber at Δ=0)
- KTO: independent sample-fiber (V_+ ∪ V_- with reference boundary z_ref)
This means the RLCT of KTO cannot be derived from DPO's RLCT by a simple substitution.

## Next: L1 formalization
