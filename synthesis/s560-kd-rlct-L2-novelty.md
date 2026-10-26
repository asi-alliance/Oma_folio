#560: Knowledge Distillation x RLCT - L2 Novelty Verification

Date: 2026-10-23
Depends on: s560-kd-rlct-L0.md, s560-kd-rlct-L1.md

## Websearch Results

Search 1: "knowledge distillation singular learning theory RLCT stratum selection"
-> Zero SLT/RLCT bridge hits. Results: standard KD surveys (Hinton et al.), SLT overview (Watanabe). No connection between KD and RLCT/singularity structure.

Search 2: "knowledge distillation generalization theory geometric singularity teacher student fiber"
-> Zero SLT/RLCT bridge hits. Results: KD capacity gap literature, information-theoretic KD analyses. No prior work formalizing teacher fiber as stratum selector.

Search 3: "KD temperature parameter generalization theory singular learning theory loss landscape"
-> Zero SLT/RLCT bridge hits. Results: temperature scaling for calibration, KD temperature tuning heuristics. No RLCT connection.

Search 4: "teacher student intersection singular learning theory deep learning RLCT generalization"
-> Zero SLT/RLCT bridge hits. No prior work on V_hard cap V_teacher intersection geometry.

Search 5: "self-distillation RLCT singular learning theory stratum selection capacity crossover 2025"
-> Zero SLT/RLCT bridge hits. Self-distillation analyzed empirically only; no SLT formalization.

## Catalog Cross-Check

grep -icE 'knowledge.distill|KD|teacher.fiber|stratum.select|V_teacher' /tmp/Oma_folio/synthesis/synthesis-catalog.md -> 0 hits

## Overlap Analysis

1. **#433 Weight Decay x RLCT**: DISTINCT. Weight decay selects strata by shifting the zero-loss set (L2 penalty moves minimizer). KD selects strata by CONSTRAINING via teacher fiber intersection V_hard cap V_teacher. Different mechanism: penalty-shift vs constraint-intersection. Different singularity: L2 ball tangency vs fiber transverse intersection.

2. **#334 Self-Distillation x RLCT**: RELATED but DISTINCT. Self-distillation has d_s = d_t, so V_teacher ~ V_hard (same architecture). The stratum selection effect vanishes (lambda_KD ~ lambda_hard). #560 generalizes: the capacity crossover d* prediction explains WHY self-distillation shows marginal benefit. #334 is a special case of #560 at d_s = d_t.

3. **#224 Label Smoothing x RLCT**: DISTINCT. Label smoothing modifies TARGETS (soft labels). KD uses TEACHER PREDICTIONS as soft targets. Different fiber: soft-target minimizer (fixed epsilon-smoothing) vs teacher-conditioned minimizer (learned soft targets). Teacher fiber carries information about dataset structure; label smoothing does not.

4. **#234 Temperature Scaling x RLCT**: RELATED. Both involve temperature T. But #234 analyzes INFERENCE-time calibration (T divides logits at test). #560 analyzes TRAINING-time temperature as stratum selector (V_teacher(T) filtration). Different phase transition: calibration sharpness vs stratum accessibility.

5. **#507 Noisy Student x RLCT**: DISTINCT. Noisy student perturbs INPUTS (data augmentation on student). KD constrains OUTPUTS (teacher logits). Different mechanism: input-space noise vs output-space constraint. Different singular structure: stochastic phi_T vs deterministic V_teacher intersection.

6. **#559 SAM x RLCT**: DISTINCT. SAM selects flat minima by perturbing PARAMETERS (gradient perturbation). KD selects strata by constraining LOSS LANDSCAPE (teacher fiber). Different space: parameter-perturbation vs loss-constraint. Different RLCT modification: flatness selection vs stratum selection.

## Novelty Verdict

**VERDICT: NOVEL**

- C1 (R_an,exp definability): Standard-novel. CE and KL divergence definability known (#8, #224). KD loss as weighted sum is closed under addition. Temperature-scaled softmax is in R_an,exp. Bridge to KD is straightforward but novel.

- C2 (V_KD = V_hard cap V_teacher, stratum selection): GENUINELY NOVEL. No prior work connects KD to RLCT fiber intersection geometry. The key insight that V_teacher acts as a STRATUM SELECTOR (not a local codimension increaser) is original. The correction from L0 (intersection increases local codim under transversality, but reduces global RLCT via stratum selection) is a genuinely new theoretical contribution.

- C3 (T as continuous stratum selector, V_teacher(T) filtration): GENUINELY NOVEL. The filtration V_teacher(T1) subset V_teacher(T2) for T1 < T2 and the prediction of optimal T* has no prior literature. The connection between teacher confidence and T* is a new heuristic.

- C4 (Generalization bound with capacity crossover d*): GENUINELY NOVEL. The prediction that KD helps below d* and hurts above d*, connecting RLCT to the empirical capacity-gap literature, is new. The formula Delta_G ~ [lambda_hard - lambda_KD] * log(n)/(2n) is a novel theoretical prediction.

- C5 (SGLD detection of d* via LLC crossover): GENUINELY NOVEL. The prediction that LLC trajectories of variable-width students reveal d* as a crossover point is a testable hypothesis with no prior formulation.

Key standout: C2 - the stratum selection mechanism. The teacher fiber V_teacher does not locally simplify the singularity (it increases codimension under transversality). Instead, it GLOBALLY reduces RLCT by constraining the student to the lowest-RLCT stratum of V_hard. This is analogous to #433 weight decay's stratum selection but via a fundamentally different mechanism (constraint intersection vs penalty shift). The capacity crossover d* prediction unifying RLCT theory with the empirical KD capacity-gap literature is the most practically novel contribution.

## Status
L2 NOVELTY VERIFIED. Next: L3 MeTTa encoding.
Date: 2026-10-23
