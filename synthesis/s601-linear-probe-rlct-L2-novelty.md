# Synthesis #601: Linear Probe x RLCT - L2 Novelty Verdict
### Date: 2026-10-25
### Status: L2 NOVELTY VERDICT: PASSED
### Searches: 6 websearches, zero SLT/RLCT bridge found
### Catalog: zero hits for linear.probe, lp.ft, frozen.backbone, freeze.back
### Search Terms: RLCT linear probe frozen backbone, feature map pushforward singularity, transfer learning linear probe complexity, frozen feature map rank deficiency, linear probe domain shift singularity, linear probing vs fine-tuning algebraic geometry, RLCT lambda linear probe frozen feature space quotient generalization
### Verdict: NOVEL

C1 (standard-novel): R_{an,exp} definability of composite loss is standard SLT machinery, but application to frozen-backbone + linear probe composite is a novel bridge.

C2 (genuinely novel): Composite RLCT lambda_composite >= d_p/2 with equality iff phi_B is a submersion. No prior work formalizes this lower bound for linear probing. The claim that frozen singularity can only increase complexity is a new SLT result for transfer learning.

C3 (genuinely novel): Feature-rank threshold r* = d_f as critical boundary for singular regime. Analog to #600 Delta* but in feature space. No prior art connects Jacobian rank deficiency of frozen feature maps to RLCT phase transitions.

C4 (genuinely novel): lambda_FT <= lambda_composite — fine-tuning desingularizes while linear probe is singular-stratum-locked. This is a new SLT explanation for the LP-FT generalization gap that NTK-based analyses (e.g., arXiv:2405.16747) do not capture.

C5 (genuinely novel): Transfer gap D* phase transition measurable via SGLD LLC. Prediction: LLC trace shows kink at critical feature distribution mismatch. No prior SLT/RLCT work makes this prediction for linear probing.
### Overlap Analysis:
- #600 (domain adaptation quotient singularity): DISTINCT — #600 is about full model adaptation across domains; #601 is about frozen backbone with linear probe on quotient feature space. #601 is the simplest instance of #600's framework.
- #169 (dropout stratum selection): DISTINCT — dropout selects strata stochastically during training; #601 freezes a single stratum permanently.
- #194/#226 (prompt tuning): DISTINCT — prompt tuning modifies input embeddings with frozen backbone; #601 modifies only output linear layer. Both freeze backbone but operate on different parameter spaces.
- #385 (LoRA): DISTINCT — LoRA allows low-rank backbone adaptation; #601 allows zero backbone adaptation. #601 is the rank-0 limit of LoRA's adaptation subspace.

### Standout Insights:
1. Frozen backbone = locked singular stratum (singularity tax without desingularization)
2. Composite RLCT lower bound lambda_composite >= d_p/2
3. Feature-rank threshold r* as singular regime boundary
4. SLT explanation for LP-FT generalization gap (NTK theory misses singular structure)
5. Transfer gap D* phase transition predicted via SGLD LLC

### Cross-refs checked: #600, #169, #194, #226, #385, #503, #364, #296, #221, #199, #421, #424, DSLT literature, NTK-based LP-FT analysis (arXiv:2405.16747).
### End s601 L2.
