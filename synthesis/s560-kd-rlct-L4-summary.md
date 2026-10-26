#560: Knowledge Distillation × RLCT — L4 Summary

Date: 2026-10-25
Pipeline: L0 ✓ L1 ✓ L2 ✓ L3 ✓ L4 (this) L5 (pending)

## Key Insight
KD creates an intersection fiber V_KD = V_hard ∩ V_teacher. The teacher's "dark knowledge" (soft label distribution) constrains the student to a higher-codimension subvariety, reducing RLCT: λ_KD ≤ λ_hard. Temperature T acts as a continuous stratum selector via filtration {V_teacher(T)}_T, with optimal T* maximizing regularization.

## Claims Status
C1 PROVEN: R_{an,exp}-definability of L_KD via closure of analytic compositions (CE, KL, softmax).
C2 CONJECTURAL: Intersection fiber V_KD = V_hard ∩ V_teacher has higher codimension than V_hard alone under transversality, giving λ_KD < λ_hard.
C3 CONJECTURAL: Temperature T parametrizes a filtration on V_teacher; T* = argmin_T λ_KD(T) exists.
C4 CONJECTURAL: Capacity-dependent gen bound: KD helps for d < d*, hurts for d > d* (teacher constrains student to shallower stratum).
C5 CONJECTURAL: Phase transition at critical capacity d* detectable via SGLD LLC trajectory crossing.

## Cross-References
#8 (CE definability), #16 (KL), #224 (label smoothing), #234 (temp scaling), #334 (self-distillation), #433 (weight decay), #507 (noisy student), #559 (SAM), #226 (EMA), #289 (Polyak), #399 (triplet loss)

## Files
- s560-knowledge-distillation-rlct-L0.md (L0 outline)
- s560-kd-rlct-L2-novelty.md (L2 novelty verification)
- s560-kd-rlct-L3.metta (L3 MeTTa encoding)
- s560-kd-rlct-L1.md (L1 formalization)
- s560-kd-rlct-L4-summary.md (this file)

## Key Novelty
First formal bridge between KD intersection fiber structure and RLCT reduction. Distinct from #224 (uniform softening, no V_teacher), #334 (self-distillation = V_teacher ≈ V_hard edge case), #507 (pseudo-labels, not soft matching). The capacity-dependent d* phase transition is a novel prediction: KD helps small students, can hurt large ones.
