# Oma Synthesis #879: Data2vec × RLCT

## L1: Formal Definitions & Definability
## Date: 2026-11-07

### D1: Parameter Space

A data2vec system with student parameters *theta_s* and EMA teacher parameters *theta_te* contains:
- Student: theta_s = {W_embed_s, W_enc_s, W_ffn_s} (modality-agnostic, e.g. transformer for audio/T, CV for CV, Wav2vec2 for speech)
- Teacher: theta_te = EMA(theta_s, alpha) where alpha is EMA momentum (2.99e-2 typical)
- Type container for layer-wise: K top-K layers, mask ratio m, layer weights lambda_l

Full space: Theta = Theta_s × Theta_te × {alpha, m, K, lambda_l, eta_t}

### D2: Data2vec Loss

For element i = 1..N, input x_i, mask PM(x_i) (multiform agnostic for CV, time steps for speech), teacher activations z(l) = ze(x_i^{unmasked})_l for l = 1..K:

 L(theta) = (1/N) sum_{i=1}^{N} sum_{l=1}^{K} lambda_l ||s(PO(x_i^{masked}) - q_{(ze(x_i^{unmasked})_l)}||^2

where:
- s is student forward pass (masked input)
- ze is teacher encoder (EMA) on unmasked input
- q_{ze(x_i^{unmasked})_l} applies quantile normalization to each layer activation
- lambda_l is layer contribution weight (equal weights if not calculated)
- PM is modality-specific masking operator

### D3: R_{an,exp} Definability --- C1 PROVEN

Components:
- Matrix multiply: polynomial -- R_{an,exp}-definable
- Softmax: e^{x}/sum e^{x} -- analytic -- R_{an,exp}-definable
- Linear/Ste masking: binary conditional switch -- piecewise-analytic -- R_{an,exp}-definable
- Quantile normalization q{x}: sort activations -> quantile-threshold rescale -- piecewise-constant projection -- R_{an,exp}-definable
- L2 regression ||s- q||^2: polynomial -- R_{an,exp}-definable
- EMA update ze_t(t+1) = (1-eta) ze(t) + eta s(t+1): linear in ze(t) -- closure preserved
- Composition closure of R{an,exp} preserves definability

L(Theta) is piecewise R {an,exp}-definable. QED.

### D4: Mask-Indexed Singular Fiber

Fiber: V(m) = {theta : L(theta) at masked input PM(x_i) condition on student forward pass s({W_l, eta_t}) can match teacher targets ze_{l}(x_i^{unmasked})}
where masked positions are fiber variables, singular condition toetation masked positions (PM) congest
to the boundary of the fiber for every layer *l* contains, all deltas between teacher ze and student s that produce minimal loss given current mask.

Sub-fibers: V_l = fiber containing minimal loss only at layer *l*, lambda_l ||s- q||^2 minim

Singular intersection: for large *m*, student forced condition creates additional squeeze shapes (masked input) with consequent spongularry for s, more plausible reconstructions. This degeneracy is distinct from #650 BYOL (single target) and #501 JEPA (embedding latent), although all use EMA teachers.

### D5: EMA Momentum as Stratum Selector

theta_te(t+1) = (1-alpha) theta_te(t) + alpha theta_s(t+1)

The teacher ze(t) acts as a continuous deformation of the student parameter theta_s at each step:
ze(t) = theta_s(t) + delta(theta_s | theta_te) + O(EMA lag)
where alpha controls how close ze tracks s, and delta is the Graver intersection computable on activations only.

- Large alpha (close to 1): ze tracks s very closely, teacher and student nearly identical, fiber collapses to self-distillation regime (#334-like). Singular structure simplifies.
- Moderate alpha (typical 0.999): ze and s are still different points in parameter space (by gradient steps from update lag). Teacher provides stable but evolving target. Fiber structure has non-trivial stratification from the lag.
- Small alpha: ze barely moves from initialization, teacher becomes static reference. Fiber degenerates to standard supervised case with fixed target.

The EMA momentum selects which stratum of the fiber the system inhabits by controlling the temporal smoothness of the teacher target. This is conjectural (C2) and requires L2 formalization of the algebraic geometry of time-varying fibers.

### D6: Generalization Bound --- C4 CONJECTURAL

Let lambda(m, alpha) be the RLCT of the fiber for mask ratio *m* and EMA momentum alpha. The generalization bound:

 G(m, alpha) ~ lambda(m, alpha) * log(n) / (2N) + U(m, alpha) / sqrt(n)

where:
- U(m, alpha) = generalization fluctuation correction containing: (a) mask-coverage information term from layer *l* coverage degree, (b) EMA dynamics drift term from teacher-student lag structure, (c) quantile normalization bias from piecewise-constant projection.
- Small *n*: fluctuation term U may dominate (student learns coordinated reconstruction)
- Large *n*: RLCT term dominates (generalization scores force denentraly)

### D7: Summary of L1 -> L2 Bridge

- C1 PROVEN: R_{an,exp} definability via composition closure (D3)
- C2-C5 CONJECTURAL: Require L2 formalization of:
  - C2: EMA moving singular stratum (D5) --- needs algebraic geometry of time-varying fibers
  - C3: Mask ratio stratum selector (D4) --- needs stratification theory for mask-indexed fibers
  - C4: Quantile norm fiber modifier (D3 component) --- needs valuation theory for piecewise-constant transforms
  - C5: Generalization bound (D6) --- needs effective RLCT computation under EMA dynamics

Next: L2 rigorous proofs or disproofs. Silent per Paul.
