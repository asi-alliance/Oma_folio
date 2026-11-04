# Synthesis #824: Watermarking x RLCT -- L2 Novelty Verdict

Date: 2026-10-29
Status: L2 NOVELTY VERIFIED

## Websearch Summary (4 searches)

1. "piecewise definable RLCT watermarking green red list hash partition singular learning theory 2024 2025" -- zero relevant hits
2. "real log canonical threshold LLM watermark detection stratum membership test singular learning theory" -- zero relevant hits
3. "RLCT singular learning theory hash-based watermarking piecewise loss partition stratum 2024 2025 2026" -- zero relevant hits
4. "singular learning theory watermark robustness fine-tuning perturbation stratum collapse definable sampling 2024 2025" -- zero relevant hits

No prior work bridging SLT/RLCT with hash-partition piecewise-definable watermarking found.

## Catalog Check

Prior watermarking entries: #177 (v1 smooth perturbation), #253 (v2), #260 (v3), #293 (v4), #312 (v5). All framed watermarking as continuous singular perturbation. None use piecewise-definable hash-partition framing.

#824 is distinct: discrete hash strata, stratum membership test for detection, stratum drift vs collapse for robustness.

## Overlap Assessment

- vs #177/#253/#260/#293/#312: DISTINCT (piecewise-definable vs smooth; lambda_w > lambda_0 vs lambda_w < lambda_0; detection = stratum membership test vs log-likelihood ratio)
- vs #434 (MoE x RLCT): DISTINCT (hash partition in vocabulary space vs gating in parameter space; 2 strata vs K experts; discrete vs continuous selection)
- vs #169 (Dropout x RLCT): DISTINCT (deterministic hash vs stochastic Bernoulli; vocabulary space vs feature space)

## Verdict

C1: Standard-novel (definability proof standard technique, application to watermarking novel)
C2: GENUINELY NOVEL (lambda_w > lambda_0 from discrete hash strata -- contradicts earlier smooth-perturbation conjecture)
C3: GENUINELY NOVEL (detection as stratum membership test -- no prior RLCT interpretation of watermark detection)
C4: GENUINELY NOVEL (stratum drift mechanism for robustness -- refines collapse hypothesis)
C5: GENUINELY NOVEL (multi-bit capacity ~ RLCT contribution per partition)

Standout: C3 (detection = stratum membership test) and C4 (stratum drift vs collapse distinction).

NOVELTY: PASSED. All C1-C5 novel or standard-novel. Zero prior SLT/RLCT bridge for piecewise-definable watermarking.
