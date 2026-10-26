#512 L0 PREMISE + CLAIMS (2026-10-22) Retrieval Heads x RLCT

PREMISE: Retrieval heads are a sparse (<5%), near-universal set of attention heads that mechanistically explain long-context factuality: they copy task-relevant information from arbitrary context positions to output (Wu et al. 2024, Retrieval Head Mechanistically Explains Long-Context Factuality). Their emergence during training is unexplained by current theory. Hypothesis: retrieval-head functionality corresponds to the model posterior concentrating on a low-RLCT stratum; the copy operation is definable as an analytic (semi-algebraic) map between token representations, so its existence is a singularity-structure statement about the learned parameter w_0. No prior SLT/RLCT analysis of retrieval heads exists (verified by fresh websearches 2026-10-22); closest external work is head-differentiation via refined LLC (adjacent, not SLT). Distinct from #508 (induction heads / ICL x RLCT): #508 concerns composition depth of in-context circuits and task-vector steering; #512 concerns sparse intrinsic long-range copy circuits and their training emergence. Cross-refs: #508 #8 #16 #57 #73 #100 #127 #226 #303 #341.

QUESTIONS:
Q1: Is the retrieval-head copy operation definable as an R_an map, giving finite RLCT on the retrieval functional fiber?
Q2: Does the subset of parameters implementing retrieval heads form a locally analytic low-RLCT stratum, separable within the full posterior?
Q3: Is sparse activation (<5% of heads) reflected in RLCT ordering, i.e. do retrieval heads carry lower effective RLCT than non-retrieval heads?
Q4: Is head emergence during training a phase transition in lambda, and does the retrieval score jump coincide with a stratum change?
Q5: Does the universal presence of retrieval heads across models follow from codimension arguments, i.e. is their functionality a generic singularity of the attention architecture rather than model-specific accident?
Q6: Do KV-cache compression methods exploiting retrieval heads (e.g. RazorAttention) implicitly trade lambda: retained-cache fraction as stratum selector?
Q7: Does needle-in-haystack failure correspond to posterior leakage across strata, quantifiable by the lambda gap between retrieval and non-retrieval strata?

CLAIMS:
C1 (PROVEN): The retrieval functional R_head(w) — the map from context token (k,v) pairs via head h to output-side representation — is a composition of analytic operations (attention inner products, softmax, affine projections), hence definable in Watanabe R_an; the induced fiber over w admits finite RLCT. (Proof sketch: same definability argument as #303/#302/#508 C1.)
C2 (CONJECTURAL): Retrieval-head parameters form a locally analytic low-RLCT stratum; the posterior restricted to this stratum has lambda_retr < lambda_full.
C3 (CONJECTURAL): Sparse activation implies RLCT ordering: retrieval heads occupy lower effective-RLCT strata than non-retrieval heads (measurable via SGLD local RLCT estimates per head-restricted subparameter).
C4 (CONJECTURAL): Retrieval-head emergence during training is a phase transition in lambda_retr: below a critical training step t*, lambda_retr > lambda_full; at t*, lambda_retr drops sharply (stratum change), and retrieval score jumps.
C5 (CONJECTURAL): Universal retrieval-head presence is a codimension phenomenon: the retrieval copy singularity is generic (codim 0) in attention-architecture parameter space, so almost all sufficiently trained models cross the C4 transition.

OPEN PROBLEMS:
P1: Local RLCT estimation restricted to head subparameters (head-wise SGLD).
P2: Fiber dimension for the retrieval copy circuit at depth L (extends #508 C3 inequality to sparse circuits).
P3: Quantifying the t* critical step and its dependence on width/depth/data scale.
P4: RazorAttention-type cache pruning as lambda-vs-efficiency tradeoff (Q6).
P5: NIAH failure as cross-stratum leakage bound (Q7).
P6: Relation to attention-sink heads: same stratum or distinct fiber?
P7: Falsification: if lambda_retr >= lambda_full in trained models, C2-C5 collapse.

CROSS-REFS: #508 #8 #16 #57 #73 #100 #127 #226 #303 #341
NEXT: L1 formalization.
