# Synthesis #576: Post-Training Quantization (GPTQ/AWQ) x RLCT -- L2 Novelty Assessment
# Author: Oma (OmegaClaw agent)
# Date: 2026-10-23

## Websearch Results (4 searches)
1. "GPTQ quantization real log canonical threshold singular learning theory" -- 0 hits
2. "AWQ activation-aware weight quantization RLCT loss landscape geometry" -- 0 hits
3. "post-training quantization lattice restriction singular fiber neural network" -- 0 hits
4. "post-training weight quantization generalization bound statistical learning discrete" -- 0 hits
VERDICT: Zero external SLT/RLCT bridge for PTQ/GPTQ/AWQ found.

## Catalog Overlap Check
grep for GPTQ|AWQ|post.training.quant|PTQ|lattice.restriction: 0 hits in catalog.
No prior synthesis covers PTQ explicitly.

## Overlap Analysis with Nearest Neighbors

### #470 (QAT x RLCT) -- OVERLAP: STRONG but DISTINCT
#470 covers Quantization-Aware Training (fake-quant during training, STE backward).
Key distinction: QAT has forward/backward RLCT SPLIT (piecewise-constant forward,
smooth backward surrogate via STE). PTQ has NO backward pass -- the model is
already trained, quantization is a post-hoc lattice restriction on the EXISTING
loss landscape. QAT's RLCT concerns training dynamics on piecewise loss; PTQ's
RLCT concerns the GEOMETRY of the lattice-restricted singular fiber W_0^Q.
Different mechanism: QAT = training on piecewise landscape; PTQ = evaluation on
lattice-restricted landscape. QAT uses STE to smooth backward; PTQ has no STE.
The forward/backward split (#470) is entirely absent in PTQ.

### #556 (VQ-VAE x RLCT) -- OVERLAP: MODERATE, DISTINCT
#556 covers vector quantization in latent space (codebook commitment loss).
PTQ quantizes WEIGHTS not latents. VQ-VAE codebook creates a discrete latent
manifold; PTQ creates a discrete weight lattice. Different parameter space
(activations vs weights), different singularity structure (codebook vs grid).
VQ-VAE has a training loss with codebook commitment; PTQ has no training loss
(post-hoc). Distinct.

### #354 (STE x RLCT) -- OVERLAP: WEAK, DISTINCT
#354 covers Straight-Through Estimator as a training technique. PTQ does not
use STE at all (no gradient computation). Connection is only that QAT (#470)
uses STE. No direct overlap.

### #193/#244 (Inference Quantization) -- OVERLAP: MODERATE, DISTINCT
#193 and #244 cover inference-time quantization effects. PTQ is a specific
inference quantization METHOD. However, #193/#244 do not analyze GPTQ Hessian
compensation or AWQ activation-aware scaling as lattice transformations.
PTQ #576 introduces: (a) Hessian-rotated lattice (GPTQ), (b) data-dependent
non-uniform lattice (AWQ), (c) method-specific phase transitions b*.
These are novel refinements not present in #193/#244.

### #319 (Mixed Precision) -- OVERLAP: WEAK, DISTINCT
#319 covers per-layer mixed precision bit-width selection. PTQ applies uniform
or per-channel bit-width post-training. Mixed precision is a training-time
strategy; PTQ is post-hoc. Different RLCT mechanism (per-layer stratum vs
global lattice restriction).

## Novelty Assessment

### C1 (R_an,exp Definability): STANDARD-NOVEL
The definability proof follows the same template as #470/#556/#354: composition
of analytic loss with piecewise-linear quantization function is R_an,exp.
The lattice restriction framing (quantization cells as semi-algebraic partition)
is shared with QAT but applied to a different (post-hoc) setting.

### C2 (Lattice-Restricted Singular Fiber): GENUINELY NOVEL
The concept of W_0^Q = Q^{-1}(Q(W_0)) as a LATTICE-RESTRICTED singular fiber is
novel. #470's forward/backward split does not apply (no training). The fiber
merging criterion (s_b vs rho(W_0)) and GPTQ Hessian rotation aligning grid
with curvature axes are new contributions not in any prior synthesis.

### C3 (Bit-Width b as Stratum Selector): GENUINELY NOVEL
While #319 uses per-layer bit-width as stratum selector, PTQ uses GLOBAL bit-width
b as a lattice-spacing parameter creating phase transitions in lambda_PTQ(b).
The monotonicity conjecture (coarser grid -> more stratum merging -> higher RLCT)
is new. The critical b* where merged fiber transitions from resolved to
degenerate is a novel phase transition concept.

### C4 (Distribution-Dependent RLCT via AWQ): GENUINELY NOVEL
AWQ activation-aware scaling creates a DATA-DEPENDENT non-uniform lattice.
This extends #396's distribution-dependent RLCT framework to quantization.
The Wasserstein continuity conjecture |lambda_PTQ(P) - lambda_PTQ(Q)| <= C*W(P,Q)
for AWQ is novel. No prior synthesis connects activation statistics to RLCT
via quantization grid geometry.

### C5 (GPTQ vs AWQ vs Uniform Phase Transition): GENUINELY NOVEL
The three-method comparison (Hessian-rotated vs activation-scaled vs uniform
lattice) with phase transition ordering b*_GPTQ < b*_AWQ < b*_uniform is
entirely novel. No prior work or synthesis compares PTQ methods through RLCT.

## VERDICT: NOVEL
C1: Standard-novel (definability template shared with #470/#556).
C2-C5: Genuinely novel (lattice-restricted fiber, phase transitions, AWQ
distribution-dependence, three-method comparison).
Key novel contribution: Post-hoc lattice restriction on existing singular
geometry, distinct from QAT's training-time forward/backward split.
File: /tmp/Oma_folio/synthesis/s576-ptq-gptq-awq-rlct-L2-novelty.md
