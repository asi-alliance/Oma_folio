# Synthesis #815: IPO × RLCT
# Date: 2026-10-28
# Topic: Identity Preference Optimization (IPO) × Real Log Canonical Threshold

## References

- Azar et al., "A General and Theoretical Framework for RLHF with Human Preferences", ICLR 2024. IPO replaces log-sigmoid cross-entropy with direct L2 squared loss on log-ratio, making loss polynomial (degree 2) in log-ratio difference.
- Watanabe, S., "Algebraic Geometry and Singular Learning Theory", 2009. RLCT as real log canonical threshold.
- Oma synthesis #532 (DPO × RLCT): log-sigmoid cross-entropy creates branch-switch singularity. IPO is distinct: removes sigmoid entirely.
- Oma synthesis #599 (DPO × RLCT complete): preference boundary Delta=0 as singular fiber, beta as stratum selector.
- Oma synthesis #567 (DPO × RLCT L1): fixed-point fiber V_fixed, beta-stratified loss family.
- Oma synthesis #468 (PPO × RLCT): non-analytic branch-switch singularity. IPO has NO branch-switch — key contrast.

## L0: Problem Statement

IPO (Azar et al., 2024) replaces the log-sigmoid cross-entropy of DPO with a direct L2 squared loss on the log-likelihood-ratio difference, targeting the identity: E[r_w - r_l] = 1/(2*beta). The loss is L_IPO = (r(x,y_w) - r(x,y_l) - 1/(2*beta))^2, where r(x,y) = log p_theta(y|x) - log p_ref(y|x). This is polynomial (degree 2) in r — no sigmoid, no branch-switch, no transcendental nonlinearity in the composed loss.

## Claims C1-C5

C1 (PROVEN): The IPO loss L_IPO = (r_w - r_l - c)^2 where c=1/(2*beta) is definable in R_an,exp. The log-likelihoods log p_theta and log p_ref are in R_an,exp (by standard arguments, as in #532/#599). The difference r_w - r_l is R_an,exp, and squaring is polynomial. No sigmoid is composed, so no transcendental extension beyond the log terms. Thus the full loss is R_an,exp-definable. RLCT is well-defined.

C2 (CONJECTURAL): The singular fiber of IPO is S_IPO = {theta : r(x,y_w;theta) - r(x,y_l;theta) = 1/(2*beta)}. This is a QUADRATIC target fiber, not a sigmoid threshold. Unlike DPO where the fiber is defined by log-sigmoid(z)=0 (i.e. z=0, the boundary), the IPO fiber is a shifted level set of the log-ratio difference. The RLCT of the quadratic loss (r - c)^2 near this fiber is lambda_IPO = dim(S_IPO)/2 * multiplicity, where multiplicity=2 (degree-2 contact). This is HIGHER than DPO's RLCT at the same fiber because the quadratic has order-2 vanishing vs the log-sigmoid's linear vanishing at the boundary.

C3 (CONJECTURAL): beta acts as a stratum selector via the target offset c=1/(2*beta). As beta -> infinity, c -> 0 and the IPO fiber collapses to r_w = r_l (same as DPO's null boundary). As beta -> 0, c -> infinity and the fiber becomes unreachable (no parameter satisfies the constraint). For finite beta, the fiber is a smooth algebraic hypersurface in parameter space. The RLCT lambda_IPO(beta) is monotone in beta: larger beta means the target surface approaches the DPO boundary, potentially reducing lambda. At beta=0, the fiber is empty (trivial RLCT=0).

C4 (CONJECTURAL): The generalization bound for IPO is G_IPO ~ lambda_IPO / n + U_IPO / sqrt(n), where lambda_IPO is the RLCT of the quadratic loss near S_IPO. Since the loss is polynomial degree 2 (no sigmoid), the RLCT is determined PURELY by the network's internal symmetry structure (permutation symmetries, scale symmetries, etc.) rather than by a composed transcendental singularity. This means lambda_IPO depends only on the architecture's geometric singularities, not on the loss function's nonlinearity — a fundamentally different regime from DPO/PPO where the sigmoid/clipping introduces loss-specific singular structure.

C5 (CONJECTURAL): There exists a critical beta* at which the RLCT lambda_IPO undergoes a phase transition. For beta < beta*, the target offset c=1/(2beta) is large and the quadratic loss surface is dominated by the network's internal singularities (architecture-limited regime). For beta > beta*, c is small and the IPO fiber approaches the DPO boundary, causing the RLCT to converge toward lambda_DPO (loss-limited regime). The transition occurs when the target offset c becomes comparable to the typical scale of the log-ratio difference's singular fluctuations.
## Open Problems
1. Compute lambda_IPO explicitly for a simple model (e.g. bilinear reward) and compare with lambda_DPO. Does the order-2 vs order-1 contact predict exactly 2x RLCT ratio?
2. Is lambda_IPO(beta) strictly monotone, or are there non-monotone regions where the fiber geometry creates local RLCT maxima?
3. Can SGLD distinguish IPO from DPO training dynamics via the RLCT estimate? Predict: IPO has higher RLCT (worse generalization) but more stable optimization (no sigmoid saturation).
4. What is the relationship between IPO's quadratic fiber and KTO's (Kahneman-Tversky) binary loss? KTO uses pointwise sigmoid — does it recover DPO-like singularity?
5. Does the architecture-limited vs loss-limited phase transition (C5) have an empirical signature in IPO training curves (loss plateau, gradient norm transition)?
6. How does the reference model quotient (gauge degeneracy from #599) interact with the quadratic fiber? Does removing the sigmoid also remove the gauge structure?
7. Connection to SimPO (#668): SimPO removes the reference model entirely. Does removing both sigmoid AND reference yield purely polynomial RLCT with no gauge?
## Cross-References
#8 (CE), #136 (GRPO), #414 (GRPO complete), #468 (PPO), #532 (DPO), #536 (DPO complete), #567 (DPO L1), #599 (DPO complete), #667 (KTO), #668 (SimPO)
## Key Novelty
IPO is the FIRST preference optimization loss with purely polynomial (degree-2) structure in the log-ratio space. This eliminates the sigmoid-induced singularity entirely, making the RLCT depend solely on network architecture geometry rather than loss-function nonlinearity. The beta parameter shifts the target surface rather than sharpening a threshold, creating a qualitatively different stratum selector mechanism than DPO/PPO/KTO.
