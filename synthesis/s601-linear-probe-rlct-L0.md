# Synthesis #601: Linear Probe × RLCT
## Date: 2026-10-25
## Status: L0 Exploration

## Candidate Selection
Zero catalog hits for linear.probe, lp.ft, frozen.backbone, freeze.back.
Zero SLT/RLCT literature found via websearch for frozen backbone + linear probe singularity.

## Core Bridge
Linear probing freezes a pretrained backbone at fixed parameters w_B* and trains only a linear classifier W_p on top.
The backbone f_B(x; w_B*) produces a fixed feature map phi_B(x) = f_B(x; w_B*).
The probe layer W_p is a regular (non-singular) model: linear map has RLCT = d_p/2 where d_p = probe parameter dimension.
But the COMPOSITE model M(x) = W_p * phi_B(x; w_B*) has its generalization behavior governed by:
- The backbone singularity structure FROZEN at training-time solution w_B*
- The feature map phi_B induces a pushforward of the data distribution into backbone feature space
- The probe operates on the QUOTIENT of the full model space by the frozen backbone parametersLet me continue appending the rest of the L0 content.
## Key Mechanisms

1. Frozen backbone = fixed stratum selection: Freezing w_B = w_B* selects a single fiber from the backbone singular locus. No adaptation of backbone parameters means the singularity is locked, not traversed. Contrast: full fine-tuning explores the full singular landscape; linear probe is confined to a slice.

2. Quotient feature space singularity: The probe sees features phi_B(x) which live on the image of the data manifold under the backbone map. If the backbone was trained on distribution P_S and probed on P_T, phi_B(P_T) may land on a different region of feature space. The probe effective RLCT depends on whether phi_B(P_T) intersects the backbone singular fiber favorably. Connection to #600: the probe operates on the quotient space Q = param_space / frozen_backbone_group.

3. Regular probe on singular feature space: W_p is linear (regular, RLCT = d_p/2 trivially). But the KL divergence K(w_p) = E[log(q(y|phi_B(x),w_p)/p(y|x))] involves phi_B which carries backbone singularity. The composite RLCT lambda_composite is NOT simply d_p/2 - it inherits backbone structure through phi_B. Key claim: lambda_composite >= d_p/2, with equality only when phi_B is a submersion (non-singular feature map).

4. Feature map singularity propagation: If backbone has RLCT lambda_B at w_B*, and feature map phi_B has rank-deficient Jacobian at certain x (singular points of the data manifold pushforward), then the probe effective loss landscape inherits singularities at those points. The probe cannot desingularize what the backbone has made singular - it can only fit a linear decision boundary on the (possibly singular) feature space.

5. Transfer gap as singularity mismatch: When backbone trained on P_S and probed on P_T: If phi_B(P_S) and phi_B(P_T) overlap well, probe generalizes, lambda_composite close to d_p/2. If phi_B(P_T) lands near backbone singular stratum, probe RLCT spikes, generalization degrades. This provides an SLT explanation for why linear probing fails under domain shift even when fine-tuning succeeds.
