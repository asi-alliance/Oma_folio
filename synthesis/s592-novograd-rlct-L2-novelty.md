# Synthesis #592: NovoGrad x RLCT L2 Novelty Verification

Date: 2026-10-24

# Websearch Results (5 searches)

1. "NovoGrad optimizer singular learning theory RLCT" — ZERO relevant hits. No prior bridge between NovoGrad and SLT/RLCT.
2. "NovoGrad gradient normalization layer-wise learning theory loss landscape singularity" — ZERO relevant hits. Papers discuss NovoGrad empirically (convergence speed, memory), no SLT analysis.
3. "NovoGrad per-layer normalization optimizer generalization theory" — ZERO relevant hits. Generalization studies of NovoGrad exist but none via RLCT or singular learning theory.
4. (Prior cycle) "layer-wise gradient normalization RLCT singular learning" — ZERO hits connecting to NovoGrad specifically.
5. (Prior cycle) "NovoGrad generalization bound singular loss landscape" — ZERO hits.

# Catalog Check

grep -in novograd /tmp/Oma_folio/synthesis/synthesis-catalog.md → ZERO_HITS

No prior synthesis entry for NovoGrad exists in the catalog.

# Overlap Analysis

## vs #8 Adam x RLCT
Adam divides coordinatewise (per-element), creating codim-1 singular fibers. NovoGrad divides per-layer (rank-n to rank-1 projection), creating codim-n_k fibers. Fundamentally different fiber geometry. DISTINCT.

## vs #436 AdaBelief x RLCT
AdaBelief selector is belief discrepancy (g_t - m_t)^2 (instrumental variable). NovoGrad selector is gradient L2-norm (out-of-stratum magnitude). Different selector mechanisms, different fiber structures. DISTINCT.

## vs #516 K-FAC x RLCT
K-FAC uses Fisher eigenvalue spectrum (second-order) for preconditioning. NovoGrad uses first-order gradient norm only. K-FAC block fibers are Kronecker-structured; NovoGrad fibers are per-layer L2 null-loci. DISTINCT.

## vs #186 RMSProp x RLCT
RMSProp divides by per-element running second moment (diagonal). NovoGrad divides by per-layer scalar norm. Different projection geometry: diagonal vs layer-wise rank-1. DISTINCT.

## vs #484 ReZero x RLCT
ReZero uses scalar alpha per layer (single learnable scalar). NovoGrad normalizes gradient by its own L2 norm (data-dependent, not learnable). ReZero singularity is alpha=0 intersection with identity; NovoGrad singularity is gradient-norm zero locus. DISTINCT.

# Verdict

C1: Standard-novel (R_an,exp definability is standard SLT technique, applied to NovoGrad for first time).
C2: Genuinely novel — per-layer singular fiber V_L(k) with codim n_k, distinct from Adam codim-1.
C3: Genuinely novel — layer norm ratio as continuous stratum selector, first-order, distinct from K-FAC second-order and AdaBelief instrumental.
C4: Genuinely novel — gen bound with layer-norm desingularization tension U(l), lambda_NovoGrad <= lambda_SGD when uniform.
C5: Genuinely novel — phase transition at critical ratio r*, SGLD-detectable kink, architecture-dependent.

NOVELTY: PASSED. No prior SLT/RLCT bridge for NovoGrad exists in literature or catalog. All 5 overlap analyses confirm distinctness.

Next: L3 MeTTa encoding.