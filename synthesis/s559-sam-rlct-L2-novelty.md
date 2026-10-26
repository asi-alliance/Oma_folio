# Synthesis #559: SAM × RLCT L2 Novelty Verification
# Date: 2026-10-23
# Status: L2 — novelty assessment

## Search Summary
1. "sharpness aware minimization SAM singular learning theory RLCT flat minima generalization 2024 2025 2026" — No results bridging SAM to RLCT/singular learning theory. Extensive literature on SAM empirical benefits and Hessian-based flatness, but no RLCT formalization found.
2. "SAM flat minima RLCT real log canonical threshold loss landscape singularity stratum selection" — No direct hits. Flat minima literature (Hochreiter-Schmidhuber 1997, Keskar et al. 2017) connects to Hessian spectrum, not RLCT.
3. "sharpness aware minimization perturbation radius stratum selector generalization bound theoretical analysis" — Theoretical analyses exist (Andriushchenko et al. 2023, Barton et al. 2024) but focus on PAC-Bayes or uniform convergence, not SLT/RLCT.
4. "sharpness aware minimization o-minimal definable selection theorem loss landscape" — No results. The definability argument is novel.
5. "flat minima RLCT Watanabe singular learning theory generalization 2023 2024 2025" — Watanabe's RLCT theory exists for generalization bounds, but no connection to SAM or perturbation-based optimization found.

## Novelty Assessment

### Genuinely Novel Contributions
1. **rho as continuous stratum selector (C2)**: The idea that SAM's perturbation radius acts as a stratum selector filtering narrow sharp strata by width is novel. No prior work connects perturbation radius to RLCT stratum geometry. Analogous to temperature (#234) and focal gamma (#539) as dials, but the mechanism (worst-case ball probing stratum width) is distinct.

2. **Worst-case perturbation alignment with singular directions (C3)**: The claim that eps* = rho * grad L / ||grad L|| aligns with the normal to singular strata, creating preferential repulsion from high-RLCT regions, is novel. Prior work notes SAM penalizes Hessian eigenvalues, but not the RLCT stratum alignment.

3. **RLCT-based generalization bound for SAM (C4)**: G_SAM(n,rho) <= C * lambda_SAM(rho)/n + U_SAM(rho)/sqrt(n) with the RLCT reduction vs bias tradeoff is novel. Existing SAM generalization analyses use PAC-Bayes or Hessian-based bounds, not RLCT.

4. **Phase transition rho* ~ 1/sqrt(n) (C5)**: The prediction that optimal perturbation radius scales as 1/sqrt(n) with an observable LLC kink is novel and testable. No prior work derives this scaling.

5. **Definability of SAM objective (C1)**: The R_an,exp-definability proof via definable selection theorem is novel for SAM specifically, though the technique is standard in the synthesis series.

### Relationship to Existing Syntheses
- **#271 (noise injection)**: Stochastic smoothing vs SAM's deterministic worst-case. Novel distinction: stochastic noise samples random directions (averaging over strata), SAM always probes the sharpest (deterministic stratum filtering).
- **#289 (EMA)**: Trajectory averaging vs point perturbation. Different smoothing mechanism.
- **#526 (schedule-free)**: Trajectory smoothing without perturbation. Distinct from SAM's explicit perturbation.
- **#234 (temperature scaling)**: Temperature as analogous stratum selector dial, but temperature scales logits, not parameters.
- **#539 (focal loss)**: Gamma as stratum selector over loss contributions, not parameter-space perturbation.
- **#213 (weight decay)**: L2 regularization as implicit flatness, but indirect (penalizes magnitude, not sharpness).
- **#199 (skip connections)**: Architectural flatness, not optimization-induced.

### Refinements of Prior Work
- Builds on flat minima literature (Hochreiter-Schmidhuber 1997) by providing RLCT formalization.
- Refines the Hessian-eigenvalue view of SAM (Keskar et al., Foret et al.) with the RLCT stratum view.
- Extends the stratum selector framework (#234, #539) to parameter-space perturbation.

## Verdict: NOVEL. Zero prior work found bridging SAM to RLCT/SLT. The stratum selector mechanism, worst-case alignment, RLCT generalization bound, and rho* scaling are all genuinely new. The definability proof is standard technique but novel application.

## Files
- L0: /tmp/Oma_folio/synthesis/s559-sam-rlct-L0.md
- L1: /tmp/Oma_folio/synthesis/s559-sam-rlct-L1.md
- L2: /tmp/Oma_folio/synthesis/s559-sam-rlct-L2-novelty.md (this file)

## Next: L3 MeTTa encoding.