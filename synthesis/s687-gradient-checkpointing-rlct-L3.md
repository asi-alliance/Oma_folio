# Synthesis #687: Gradient Checkpointing × RLCT — L3 MeTTa Encoding

**Date:** 2026-10-28
**Status:** L3 MeTTa Encoding
**Pipeline:** L0 ✓ → L1 ✓ → L2 ✓ → L3 (this file) → L4 (summary)

---

## MeTTa Encoding

### C1: R_an,exp Definability (PROVEN, stv 1.0)
```
(|- ((==> (--> (× GradientCheckpointing RAnExpDefinable)) (--> CheckpointedLoss RAnExpDefinable)) (stv 1.0 0.9))
    ((--> (× GradientCheckpointing RAnExpDefinable)) (stv 1.0 0.9)))
```
Checkpointing recomputes the same definable functions → loss remains R_an,exp-definable → finite RLCT.

### C2: Checkpoint Count k as Stratum Selector (CONJECTURAL, stv 0.8)
```
(|- ((==> (--> (× CheckpointCount LowPrecision)) (--> CheckpointCount StratumSelector)) (stv 0.8 0.7))
    ((--> (× CheckpointCount LowPrecision)) (stv 0.8 0.7)))
```
k weakly selects strata at standard precision; meaningfully at low precision (fp8).

### C3: Piecewise Perturbation Structure (CONJECTURAL, stv 0.8)
```
(|- ((==> (--> (× GradientCheckpointing PiecewisePerturbation)) (--> GradientCheckpointing DistinctFromGradientNoise)) (stv 0.8 0.7))
    ((--> (× GradientCheckpointing PiecewisePerturbation)) (stv 0.8 0.7)))
```
Deterministic piecewise perturbation at checkpoint boundaries ≠ i.i.d. stochastic noise.

### C4: Indirect RLCT Effect Dominates (CONJECTURAL, stv 0.8)
```
(|- ((==> (--> (× GradientCheckpointing IndirectRLCTEffect)) (--> GradientCheckpointing SecondOrderDirectEffect)) (stv 0.8 0.7))
    ((--> (× GradientCheckpointing IndirectRLCTEffect)) (stv 0.8 0.7)))
```
Direct effect O(eps_fp * k) is second-order; capacity enabling is first-order.

### C5: Low-Precision Checkpointing as Desingularizer (CONJECTURAL, stv 0.7)
```
(|- ((==> (--> (× CheckpointCount LowPrecision)) (--> GradientCheckpointing Desingularizer)) (stv 0.7 0.6))
    ((--> (× CheckpointCount LowPrecision)) (stv 0.7 0.6)))
```
At fp8, k > k* ~ 100 smoothes sharp singularities → lambda decreases.

### Novelty Assertion
```
(|- ((Implication (Inheritance CheckpointedLoss (IntSet SingularFiberPerturbation)) (Inheritance CheckpointedLoss (IntSet NovelConcept))) (stv 0.9 0.8))
    ((Inheritance CheckpointedLoss (IntSet SingularFiberPerturbation)) (stv 0.9 0.8)))
```

## Cross-References

#8 (foundational RLCT), #155 (gradient noise), #224 (label smoothing), #354 (mixed precision), #525 (Entropy-SGD desingularization), #533/#553 (gradient accumulation), #609 (gradient noise injection)
