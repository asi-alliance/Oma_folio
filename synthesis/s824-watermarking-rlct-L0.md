# Synthesis #824: LLM Watermarking (Green/Red List Logit Bias) × RLCT — L0 SCOPING

Date: 2026-10-29
Status: L0 (exploration) — first piecewise-definable framing
Pipeline: L0 in progress

---

## Background

Kirchenbauer et al. (2023) watermark LLMs by adding a context-dependent logit bias δ to green-list tokens: the sampling map is partitioned by a hash function h(context) into green/red token sets. Within each partition, the distribution is smooth; at partition boundaries, the logit bias creates jump discontinuities. Previous syntheses (#177, #253, #260, #293, #312) framed watermarking as a continuous singular perturbation. This synthesis introduces the piecewise-definable framing: the hash partition creates discrete threshold singularities at boundaries, not just a smooth perturbation.

### Mathematical Formulation

The watermarked sampling map is:
f_w(x) = softmax(z + δ · 1_{h(context,t) == green})

where z_i = base logits at token t, δ = watermark strength, 1 = indicator (1 if green, 0 if red), h = keyed hash function mapping (context, token) → {green, red}.

This is piecewise smooth: in each hash section (green or red for token t), the map is R_{an,exp}-definable (softmax + affine add). The section identification requires a discrete threshold: token t is green iff h(context, t) ∈ S_h ≤q {T : h(context, t) = green}. The boundary ∂S_h is a finite union of finite sets — a discrete division and not a smooth differentiable manifold.

Watermarked loss: L_w(θ) = E_{x~p_w}[ℓ(f_θ(x), y)] where p_w is the watermarked sampling distribution.

Detection: z-score = (|s|_green - μ_null) / σ_null, where |s|_green = fraction of green tokens in generated text s.

---

## Key Questions

Q1: Does the hash partition create additional singular strata in parameter space beyond the base model's singularities?

Q2: How does the RLCT of the watermarked loss λ_w relate to the base RLCT λ_0? Is λ_w > λ_0 (complication via discrete strata) or λ_w < λ_0 (simplification via regularization)?

Q3: Can the watermark detection z-score be interpreted as an RLCT-sensitive stratum membership test? The null hypothesis is s_w ~ Bernoulli(g_w | data); the alternative is that detection rejects when the observed green fraction falls outside the green stratum defined by the hash partition.

Q4: How does fine-tuning perturbation p of parameters produce a continuous family of hash partition boundaries — green(p) / red(p). If p < 1, p < 0.5, the green stratum survives (detectable); if p > p*, the partition collapses (boundaries move) and the watermark becomes undetectable. The critical perturbation strength p* = superscript of the rlct gap λ_w - λ_0. Higher RLCT means more complex strata = harder to perturb into smoothly.

Q5: What is the maximum information capacity of a watermark (capacity ~ number of distinct hash partitions) and how does it relate to the RLCT of the watermarked model?

---

## Preliminary Claims

### C1 (PROVABLE): R_{an,exp} Definability
The watermarked sampling map f_w(x) = softmax(z + δ · 1_{h(context,t)==green}) is piecewise R_{an,exp}-definable. Within each hash section (green or red for token t), the map is R_{an,exp}-definable (softmax + affine add). The piecewise structure is finite: |green/red| = finite union of finite sets. So the map is definable on a finite discrete partition — it is R-definable and has finite RLCT.

### C2 (CONJECTURAL): Watermark RLCT λ_w > λ_0
The hash partition introduces additional discrete singular strata at hash collision boundaries — green ↔ red. Each boundary is a finite set in vocabulary space — a zero-dimensional singular stratum. These add to the base model's singularities, increasing the total RLCT. This differs from #177/#293 which framed watermarking as a smooth perturbation and conjectured λ_w < λ_0.

### C3 (CONJECTURAL): Detection as Stratum Membership Test
Watermark detection (the z-score counting green tokens over n tokens) is an RLCT-sensitive stratum membership test. The null hypothesis is s_w ~ Bernoulli(g_w | data); the alternative is that detection rejects when the observed green fraction falls outside the green stratum defined by the hash partition. The detection statistic is an identifier of which hash stratum the generated text samples from.

### C4 (CONJECTURAL): Robustness = Stratum Stability Under Perturbation
Fine-tuning perturbation p of parameters produces a continuous family of hash partition boundaries — green(p) / red(p). If p < p*, the green stratum survives (detectable); if p > p*, the partition collapses (boundaries move) and the watermark becomes undetectable. The critical perturbation strength p* = superscript of the rlct gap λ_w - λ_0. Higher RLCT means more complex strata = harder to perturb into smoothly.

### C5 (CONJECTURAL): Multi-bit Capacity ~ exp(λ_w gap)
Multiple watermark keys h_1, h_2, ..., h_k create k distinct stratum systems; collision = stratum intersection. Capacity is limited by RLCT: each additional hash partition increases λ_w, so the ins1/pSm detection z-score should be monotone-regardless of the tensor of its green/red stratum into an in...

---

## Distinction from Prior Syntheses

### vs #177/#253/#260/#293/#312 (Watermarking × RLCT, earlier framings)
- Earlier: watermark = continuous singular perturbation on output distribution.
- #824: watermark = piecewise-definable map with discrete hash-partition boundaries.
- Earlier: λ_w < λ_0 (watermark regularizes/simplifies).
- #824: λ_w > λ_0 (discrete strata add complexity).
- Earlier: detection = log-likelihood ratio as RLCT-sensitive statistic.
- #824: detection = stratum membership test (green fraction falls in expected hash stratum).

### vs #434 (MoE × RLCT)
- MoE: gating network selects expert → piecewise loss in parameter space.
- #824: hash function selects green/red → piecewise sampling map in vocabulary space.
- MoE: K experts → K strata; #824: 2 strata (green/red) per token per context.
- MoE: continuous gating; #824: discrete hash partition (no smooth interpolation).

### vs #169 (Dropout × RLCT)
- Dropout: Bernoulli masking in feature space, expectation over 2^D masks.
- #824: hash-based partition in vocabulary space, deterministic given context.
- Dropout: smooth fiber structure from averaging; #824: discrete strata from hash.

---

## Open Problems

1. Is the hash function h (typically a pseudorandom function) definable in R_{an,exp}? If h is a true random oracle, the partition is not definable. In practice, h is a fixed keyed hash (e.g., hash of context + key) — is this definable?
2. How does λ_w scale with the watermark strength δ? Does λ_w → λ_0 as δ → 0 (perturbation vanishes)?
3. Can the p* phase transition (robustness collapse) be measured via SGLD LLC on watermarked vs fine-tuned models?
4. Is the capacity bound C5 tight? How many distinct watermarks can coexist before stratum intersection makes all undetectable?
5. Does the piecewise-definable framing change the generalization bound? G_w(n) ≤ λ_w · log(n) / (2n) + U_w / √n — is U_w different from U_0?
6. How does the entropy threshold (watermark only when entropy > τ) interact with the stratum structure? Does τ create an additional stratum boundary?
7. Is the z-score detection statistic optimal under the stratum membership interpretation, or is there a more powerful RLCT-sensitive test?
8. What happens to λ_w under multi-bit watermarking (N distinct splits)? Does λ_w scale linearly with N, or sublinearly due to stratum overlap?
9. Can the hash-partition stratum structure be used to design watermarks with provably higher p* (more robust)?
10. How does the piecewise-definable framing apply to other watermarking schemes (e.g., KGW, SIRIC) that use different partition mechanisms?

---

## Cross-References

#8 (definability), #16 (RLCT basics), #72 (loss landscape), #100 (generalization bound), #113 (DP × RLCT), #127 (attention × RLCT), #169 (dropout × RLCT), #177 (watermarking × RLCT v1), #220 (stratum), #234 (temperature sampling), #253 (watermarking × RLCT v2), #260 (watermarking × RLCT v3), #293 (watermarking × RLCT v4), #312 (watermarking × RLCT v5), #434 (MoE × RLCT), #469 (speculative decoding × RLCT), #507 (candidate selection log), #817 (cutout × RLCT)

---

## Next Steps

L1: Formalize D1-D7 definitions (watermarked sampling map, hash partition, piecewise loss, stratum structure). Prove C1 in detail. Elaborate C2-C5 with explicit conjectural gaps.
