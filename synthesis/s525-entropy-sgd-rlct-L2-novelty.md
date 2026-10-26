# Synthesis #525: Entropy-SGD × RLCT — L2 Novelty Verification

Date: 2026-10-23
Verdict: NOVEL

## Prior Art Search Summary

Searches conducted (4+ websearches):
1. "entropy SGD singular learning theory RLCT local entropy singularity bridge"
2. "local entropy optimization loss landscape smoothing singularity resolution generalization bound"
3. "entropy SGD local entropy regularization singular learning theory RLCT learning coefficient 2024 2025 2026"
4. "Chaudhari entropy-SGD local free energy loss landscape singularity algebraic geometry"
5. "entropy-SGD local entropy smoothing singularity resolution algebraic geometry RLCT 2025 2026"

Result: ZERO hits connecting entropy-SGD/local entropy to SLT/RLCT. Entropy-SGD has been analyzed via PAC-Bayes bounds (Chaudhari et al.) but never via singular learning theory. No prior bridge exists.

## C1-C5 Novelty Assessment

C1 (R_an,exp definability of local entropy): STANDARD-NOVEL. The definability argument (exp/log closure + definable integration) is standard o-minimal technique, but application to the local entropy integral is novel.

C2 (Regularized RLCT lambda(gamma) <= lambda_orig): NOVEL. No prior work connects Gibbs smoothing to RLCT reduction. The monotonicity conjecture and gamma->0/gamma->inf limits are genuinely new.

C3 (gamma as stratum selector, phase transition gamma*): NOVEL. The cascade of phase transitions corresponding to singular strata resolution is entirely new. Heuristic gamma*_i ~ c_i/lambda_i has no precedent.

C4 (Generalization bound with lambda(gamma) + bias(gamma)): NOVEL. The bias-variance tradeoff between reduced RLCT and smoothing-induced bias is new. No prior gen bound uses an effective RLCT from a smoothed objective.

C5 (SGLD-detectable cusp at gamma*): NOVEL. The fluctuation nu_gamma as phase transition detector for local entropy smoothing is new. No prior work predicts SGLD observability of desingularization.

## Distinctness from Related Syntheses

- #377 (Gradient Noise Injection × RLCT): DISTINCT. #377 injects stochastic SGLD perturbation noise into gradients; #525 averages a Gibbs distribution over a neighborhood. Mechanism: perturbation vs smoothing. Key: gradient noise changes the dynamics, local entropy changes the objective.
- #420 (Lookahead × RLCT): DISTINCT. Lookahead uses two-phase weight averaging; no Gibbs volume, no loss smoothing.
- #305 (Lion Optimizer × RLCT): DISTINCT. Sign-based momentum; no landscape smoothing or local entropy.
- #173 (SAM × RLCT): DISTINCT. SAM minimizes worst-case (max) loss in ball; entropy-SGD minimizes average-case (log-partition). Minimax vs Gibbs. Potential connection: SAM as zero-temperature limit of entropy-SGD is an open problem.
- #169 (Dropout × RLCT): DISTINCT. Dropout masks neurons stochastically; changes fiber structure. Entropy-SGD smooths the loss via local averaging.
- #234 (Label Smoothing × RLCT): DISTINCT. Label smoothing modifies target distribution (KL geometry); entropy-SGD modifies the loss landscape (Gibbs geometry).
- #507 (Noisy Student × RLCT): DISTINCT. Noisy student adds noise to inputs/weights during student training; entropy-SGD computes local free entropy.

## Catalog Check

grep of synthesis-catalog.md for "entropy-sgd", "entropy.sgd", "local entropy": ZERO direct hits. No prior synthesis covers this bridge.

## Conclusion

Entirely novel bridge. C1 standard-novel, C2-C5 genuinely novel. Standout insight: gamma as continuous stratum selector with cascade of desingularization phase transitions, each detectable via SGLD. The connection between local entropy Gibbs volume and RLCT volume scaling V({L < t}) ~ t^lambda is the core novel bridge.

Next: L3 MeTTa encoding.