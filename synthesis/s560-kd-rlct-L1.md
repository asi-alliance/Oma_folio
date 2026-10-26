#560: Knowledge Distillation × RLCT — L1 Formalization

Date: 2026-10-25
Depends on: s560-knowledge-distillation-rlct-L0.md, s560-kd-rlct-L2-novelty.md, s560-kd-rlct-L3.metta

## 1. Setup and Notation

Let f_hard: X × Y → R be the hard-label loss (cross-entropy), f_TM: X × Y → R the teacher model, and f_KD the composite KD loss. The student model is parametrized by w ∈ W ⊂ R^d. Teacher predictions p_t = softmax(z_t/T), student predictions p_s = softmax(z_s(w)/T).

## 2. Formal Definitions

### D1: KD Composite Loss
L_KD(w, T, α) = α · CE(f_s(x;w), y) + (1-α) · T² · KL(softmax(z_s(w)/T) || softmax(z_t/T))

Both CE and KL of softmax are analytic compositions. T² scales the KL term to preserve gradient magnitude under temperature rescaling.

### D2: Zero-Loss Fiber of KD
V_KD = {w ∈ W : L_KD(w, T, α) = 0} = V_hard ∩ V_teacher

where V_hard = {w : f_s(x;w) = y ∀x} and V_teacher = {w : softmax(z_s(w)/T) = softmax(z_t/T) ∀x}.

### D3: Teacher-Matching Fiber
V_teacher(T) = {w : softmax(z_s(w)/T) = softmax(z_t/T) ∀x}

At T→∞: V_teacher → {w : mean(z_s) = mean(z_t)} (weak, large fiber).
At T→0: V_teacher → {w : argmax(z_s) = argmax(z_t)} (strong, ≈ V_hard).

### D4: Intersection Codimension and RLCT
If V_hard and V_teacher intersect transversely:
codim(V_KD) = codim(V_hard) + codim(V_teacher)
Since V_teacher adds constraints beyond V_hard, codim(V_KD) ≥ codim(V_hard), so λ_KD ≤ λ_hard.

### D5: Temperature as Continuous Stratum Selector
T ∈ (0,∞) parametrizes a continuous family {V_teacher(T)}_T forming a filtration: for T1 < T2, V_teacher(T1) ⊂ V_teacher(T2) (stronger constraint at lower T). The RLCT λ_KD(T) = min over strata of the intersection fiber.

### D6: Student Capacity Parameter
Let d = dim(W_student) be the student parameter count. Define d* as the critical capacity where λ_KD(d) = λ_hard(d).

### D7: KD Generalization Bound
G_KD ≤ λ_KD · log(n)/(2n) + b_KD/√n
where λ_KD = RLCT of L_KD at the true parameter, b_KD = Fluctuation functional.

## 3. Claims

### C1 (PROVEN): R_{an,exp}-Definability
L_KD(w,T,α) is definable in R_{an,exp}. CE and KL of softmax are compositions of analytic functions (exp, log, division). The sum α·CE + (1-α)·T²·KL preserves definability. By Speissegger-Lion-Rolin closure, L_KD ∈ R_{an,exp}. □

### C2 (CONJECTURAL): Intersection Fiber Structure
V_KD = V_hard ∩ V_teacher. For a teacher converged to a smooth minimum (λ_teacher ≈ 0), V_teacher is approximately smooth. Transverse intersection gives codim(V_KD) = codim(V_hard) + codim(V_teacher) > codim(V_hard), so λ_KD < λ_hard. The teacher's dark knowledge regularizes the student away from highly singular strata.

Gap: Transversality is not guaranteed. If teacher and student share singular structure, intersection may be non-transverse, and codim additivity fails.

### C3 (CONJECTURAL): T as Stratum Selector
λ_KD(T) is a function of T via the filtration {V_teacher(T)}. There exists T* = argmin_T λ_KD(T) that maximizes regularization without collapsing V_teacher to V_hard (T→0) or making it trivial (T→∞). T* depends on teacher confidence calibration and dataset difficulty.

Gap: Monotonicity of the filtration and smoothness of λ_KD(T) require proof. The filtration may not be strict.

### C4 (CONJECTURAL): Capacity-Dependent Generalization
G_KD ≤ λ_KD · log(n)/(2n) + b_KD/√n with λ_KD ≤ λ_hard for d < d*. The improvement λ_hard - λ_KD ∝ (1-α) · dim(V_teacher), large when V_teacher is high-dimensional relative to W (small students). For d > d*, the student could reach deeper singular strata alone, but V_teacher constrains it to the teacher's (possibly shallower) stratum — KD can hurt.

Gap: d* estimation from LLC trajectories. The proportionality constant is unknown. The crossover mechanism (teacher stratum shallower than student's potential) needs formalization.

### C5 (CONJECTURAL): Phase Transition at d*
There exists a critical student capacity d* below which λ_KD < λ_hard (KD helps) and above which λ_KD ≥ λ_hard (KD hurts). At d = d*, SGLD LLC trajectories of KD-trained and hard-trained models should cross. This predicts self-distillation (d_student = d_teacher) gives marginal benefit since V_teacher ≈ V_hard.

Gap: d* depends on data distribution P, not just architecture. SGLD detection assumes sufficient n. Self-distillation edge case needs V_teacher = V_hard proof.

## 4. Open Problems
1. Compute RLCT of V_hard ∩ V_teacher for logistic regression student + SVM teacher.
2. Is transversality generic, or do teacher/student share singular structure?
3. Does T* correlate with teacher confidence, dataset difficulty, or student capacity?
4. Can d* be estimated from LLC trajectories during KD training?
5. KD + dropout/weight decay/augmentation interaction in RLCT framework?
6. Self-distillation: V_teacher = V_hard → λ_KD = λ_hard — explains marginal benefits?
7. Feature distillation: different singular structure than logit distillation?
8. Mean teacher / EMA: does EMA-averaged teacher have lower RLCT, transferring to student?

## 5. Cross-References
#8 (CE definability), #16 (KL divergence), #224 (label smoothing), #234 (temperature scaling), #334 (self-distillation), #433 (weight decay), #507 (noisy student), #559 (SAM), #226 (EMA), #289 (Polyak averaging), #399 (triplet loss)

## 6. Distinction from Prior Syntheses
- #224 Label Smoothing: Uniform softening, no V_teacher.
- #234 Temperature Scaling: Post-hoc calibration, not training-time.
- #334 Self-Distillation: Special case where V_teacher = V_hard (C5 edge case).
- #507 Noisy Student: Teacher-generated pseudo-labels, not soft-label matching.
- #559 SAM: Sharpness perturbation, not teacher-guided stratum selection.
