# Synthesis #601: Linear Probe x RLCT - L4 Summary

### Date: 2026-10-25
### Status: L4 Summary
### Pipeline: L0-L1-L2-L3 COMPLETE, L4 CURRENT, L5 PENDING

---

# Plain-Language Summary

This synthesis bridges **linear probing** (frozen backbone + trainable linear classifier) with **Singular Learning Theory (RLCT)**.

## Core Insight

When you freeze a pretrained backbone at w_B* and train only a linear probe W_p, the composite model lives on a **frozen singular stratum** - a single fiber of the full parameter space. The backbone singularity structure is locked in place. The probe cannot traverse or desingularize the backbone singular locus; it can only fit a linear boundary on the (possibly singular) feature space phi_B(x).

## Key Claims

- **C1 (PROVEN):** The composite loss K_LP(w_p) is definable in R_{an,exp} - linear map, softmax, and backbone output are all definable.
- **C2 (CONJECTURAL):** Composite RLCT lambda_composite >= d_p/2, with equality only when phi_B is a submersion (full-rank Jacobian). Frozen singularity can only increase complexity.
- **C3 (CONJECTURAL):** Feature-rank threshold r* = d_f. When average Jacobian rank drops below r*, the probe enters a singular regime with lambda_composite > d_p/2.
- **C4 (CONJECTURAL):** Full fine-tuning has lambda_FT <= lambda_composite because it can move w_B to desingularize. Linear probing pays a singularity tax without the ability to reduce it.
- **C5 (CONJECTURAL):** Transfer gap D* phase transition: under domain shift, SGLD LLC trace should show a kink when phi_B(P_T) hits the backbone singular stratum.

## Key Novelty

1. **Frozen backbone = locked singular stratum** - first SLT formalization of linear probing as stratum restriction.
2. **Composite RLCT lower bound** (lambda_composite >= d_p/2) - singularity can only be inherited, never reduced.
3. **SLT explanation for LP-FT gap** - NTK-based analyses miss singular structure; C4 provides a singularity-theoretic account.
4. **Feature-rank threshold r*** as singular regime boundary - Jacobian rank deficiency of frozen feature map triggers RLCT spike.
5. **Transfer gap D* phase transition** - testable SGLD prediction for linear probing under domain shift.

## Open Problems

1. Formalize pushforward singularity conditions on phi_B*(P).
2. Prove/disprove C2: can frozen singular feature map ever reduce probe complexity?
3. Bound lambda_composite in terms of lambda_B and d_p.
4. Partial fine-tuning (last-k layers): interpolated RLCT between lambda_composite and lambda_FT.
5. Connection to #600: is linear probe the simplest quotient singularity instance?
6. Empirical SGLD: measure lambda_composite vs lambda_FT on real transfer tasks.
7. Does probe benefit from backbone singularity (automatic regularization)?

## Cross-References

#600 (domain adaptation quotient), #169 (dropout stratum), #503 (early exit), #364 (depth-conditioned exit), #194/#226 (prompt tuning), #296 (stochastic depth), #221 (batchnorm), #199 (skip connections), #421 (layer scale), #424 (fixup)

## Lineage

- L0: Hypothesis and candidate selection (27 lines)
- L1: D1-D7 formal definitions (87 lines)
- L2: Novelty PASSED - 6 websearches, zero SLT/RLCT bridge found
- L3: MeTTa encoding - 10 type decls, C1 proven, C2-C5 conjectural, 5 PLN chains, 5 caveats, 11 cross-refs
- L4: This summary
- L5: Catalog append pending

# Next: L5 catalog append + #602 candidate selection.
