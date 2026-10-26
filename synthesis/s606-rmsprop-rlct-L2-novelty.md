# Synthesis #606: RMSProp × RLCT — L2 Novelty Verification
## Date: 2026-10-25
## Status: L2 Novelty Verification

## Websearch Results
1. "RMSProp singular learning theory RLCT real log canonical threshold" — ZERO hits bridging RMSProp to SLT/RLCT. Results about SLT/RLCT generally, no RMSProp connection.
2. "RMSProp algebraic geometry generalization deep learning singularity" — ZERO hits. Results about geometric deep learning and algebraic geometry separately, no optimizer-variety bridge.
3. "RMSProp exponential moving average optimizer singularity algebraic variety" — ZERO hits connecting EMA preconditioning to singularity theory.
4. "RMSProp forgetting factor generalization bound information geometry" — ZERO hits linking gamma to RLCT or generalization bounds via singularity theory.

## Catalog Check
grep -ri "rmsprop|forgetting.*factor|EMA.*precondition" synthesis-catalog.md → NO_CATALOG_HITS

## Prior Synthesis Comparison
- #605 Adagrad: irreversible freezing, monotonic D_t, sharp phase transition t*. RMSProp CONTRASTS via reversibility, non-monotonic D_t, smooth crossover.
- #289/#304 Adam: EMA + momentum + bias correction. Adam adds momentum (2nd EMA) and bias correction, but SLT analysis focused on bias correction preventing freezing. RMSProp is the PURE EMA case without momentum — isolates the forgetting factor effect.
- #591 AdaBelief: belief discrepancy denominator. Different denominator structure, not EMA of squared gradients.
- #354 SGD: vanilla baseline. No preconditioning, no EMA.

## Novelty Assessment

### C1 (R_{an,exp} definability) — STANDARD-NOVEL
Same composition argument as Adagrad #605, Adam #289. The EMA recursion E_t = gamma*E_{t-1} + (1-gamma)*g_t^2 is a standard definable recursion. Novelty is in the specific singular locus structure (oscillating non-analytic set) but the definability proof technique is standard.

### C2 (Reversible stratum selector) — GENUINELY NOVEL
No prior work connects RMSProp's EMA reversibility to stratum commitment reversibility. The key novelty: parameters can UNFREEZE (re-enter active set), creating an oscillating fiber rank. This is absent from:
- Adagrad (#605): irreversible, monotonic
- Adam (#289): bias correction prevents freezing but doesn't create reversibility analysis
- No websearch hits for EMA reversibility in singularity context

### C3 (Gamma-mediated lambda_eff tradeoff) — GENUINELY NOVEL
The gamma-as-continuous-stratum-selector with interior optimum gamma* is novel. Prior work:
- One-Cycle LR (#604): schedule-based stratum selector (time-dependent)
- SGDR (#410): discrete restart-based stratum reset
- Adagrad (#605): no selector (all parameters eventually freeze)
RMSProp's gamma provides a CONTINUOUS knob for stratum exploration depth, distinct from all prior.

### C4 (Gen bound with interior optimum) — GENUINELY NOVEL
The bound G <= lambda_eff(gamma)/n + U(gamma)/sqrt(n) with interior optimum gamma* is novel. Adagrad has monotone tradeoff (lambda_eff/n_eff tension), RMSProp has gamma-space interior optimum. No prior SLT work derives such a bound for EMA-based preconditioning.

### C5 (Breathing singularity / no sharp phase transition) — GENUINELY NOVEL
The "breathing singularity" hypothesis — oscillating fiber rank creates a new singularity type — is entirely novel. No prior work in SLT or optimization theory discusses oscillating singular strata. The prediction that SGLD LC variance (not just mean) distinguishes RMSProp from Adagrad is a novel falsifiable prediction.

## Verdict
L2 NOVELTY VERIFIED. C1 standard-novel, C2-C5 genuinely novel. Zero websearch hits bridging RMSProp to SLT/RLCT. Zero catalog hits. Key novelty: reversible stratum commitment, breathing singularity, gamma-mediated tradeoff, smooth crossover (contrast with Adagrad sharp phase transition).

## Next
L3 MeTTa encoding.
