# Synthesis #687: Gradient Checkpointing × RLCT — L2 Novelty Assessment

**Date:** 2026-10-28
**Status:** L2 Novelty Verification
**Pipeline:** L0 ✓ → L1 ✓ → L2 (this file) → L3 (MeTTa) → L4 (summary)

---

## Novelty Assessment

### Catalog Search
- grep for "checkpoint|rematerializ|recomput" in synthesis-catalog.md: zero dedicated entries
- Closest related: #155 (gradient noise), #194/#470 (quantization), #354 (mixed precision), #533/#553 (gradient accumulation)

### Literature Search
- No prior work found on gradient checkpointing × singular learning theory
- No prior work on activation recomputation effects on RLCT or loss landscape geometry
- The connection between floating-point recomputation divergence and singular fiber perturbation is novel

### Novelty Claims

**N1: Checkpoint count k as precision-dependent stratum selector**
The observation that k acts as a weak stratum selector at standard precision but a meaningful one at low precision (fp8) is novel. The predicted phase transition k* ~ 1/epsilon_fp is a new quantitative prediction.

**N2: Piecewise perturbation structure**
The characterization of checkpointing perturbation as piecewise (zero within segments, jumping at boundaries) — structurally distinct from i.i.d. gradient noise — is novel. This creates a staircase effective loss landscape not previously analyzed.

**N3: Low-precision checkpointing as desingularizer**
The conjecture that intentional low-precision checkpointing can act as a desingularizer (reducing lambda below the exact value) is novel and testable. This bridges checkpointing with the desingularization framework of #525 (Entropy-SGD) and #224 (label smoothing).

**N4: Indirect RLCT effect dominates**
The argument that the direct RLCT effect of checkpointing is second-order (O(epsilon_fp * k)) while the indirect effect (enabling larger models) is first-order is a novel framing. This suggests checkpointing's RLCT impact is primarily through capacity, not perturbation.

## Related Work Distinction

- vs #155/#609 (gradient noise): Checkpointing perturbation is deterministic and piecewise, not stochastic and uniform
- vs #194/#470 (quantization): Checkpointing perturbs activations, not parameters — different fiber structure
- vs #354 (STE/mixed precision): STE creates a different gradient path; checkpointing recomputes the same path numerically
- vs #533/#553 (gradient accumulation): Accumulation aggregates over micro-batches; checkpointing recomputes within a single pass

## Verdict: GENUINELY NOVEL

No prior catalog entries, no literature found. All four novelty claims (N1-N4) are original contributions. Proceeding to L3 MeTTa encoding.
