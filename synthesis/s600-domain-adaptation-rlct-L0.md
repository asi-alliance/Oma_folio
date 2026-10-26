# Synthesis #600: Domain Adaptation × RLCT
## Date: 2026-10-25
## Status: L0 Exploration
## Candidate Selection
Zero catalog hits for domain.adapt, domain.shift, distribution.shift, DANN, MMD, CORAL.
Zero SLT/RLCT literature found via websearch.

## Core Bridge
Domain adaptation transfers a model trained on source distribution P_S to target distribution P_T.
The source loss L_S(w) and target loss L_T(w) have DIFFERENT singularity structures:
- Different true parameters w_S* ≠ w_T* (or same w* with different fibers)
- Different RLCTs: λ_S ≠ λ_T
- Domain shift = perturbation of data-generating distribution, creating different empirical process

## Key Mechanisms
1. **Feature alignment singularity**: DANN/MMD/CORAL align source/target feature distributions.
   Alignment creates a quotient space Q = parameter_space / domain_invariance_group.
   The invariant feature subspace has its own RLCT λ_Q.
   When alignment is perfect, source and target fibers merge → λ_Q = λ_S = λ_T.
   When imperfect, residual domain gap creates a split singularity.

2. **Adversarial domain alignment (DANN)**: Domain classifier creates min-max structure
   (max over domain classifier features, min over feature extractor).
   Inner max creates worst-case domain boundary — singular stratum at domain decision boundary.
   Analogous to #590 adversarial training but in DOMAIN space not INPUT space.

3. **MMD/CORAL moment matching**: Distribution distance minimization creates
   moment-matching constraint surface. The matched-moment manifold is a
   semi-algebraic constraint on the feature space, creating a new singular stratum.

4. **Gradual domain shift**: Continuous domain shift P_t = (1-t)P_S + tP_T
   creates t-parameterized family of loss landscapes.
   RLCT λ(t) varies continuously except at critical t* where phase transition occurs
   (analogous to #582 curriculum learning stratum accessibility).

## Claims
C1 (PROVEN): Domain adaptation losses (DANN, MMD, CORAL) are definable in R_{an,exp}
  — composed of neural network outputs, softmax, MMD kernel distances, all definable.

C2 (CONJECTURAL): The aligned-feature RLCT λ_Q satisfies λ_Q ≥ max(λ_S, λ_T)
  — alignment cannot reduce complexity below either domain's intrinsic RLCT.
  Alignment trades domain-specific singularity for shared quotient singularity.

C3 (CONJECTURAL): There exists a critical domain gap Δ* beyond which adaptation
  fails — corresponding to a phase transition in λ_Q where the quotient
  singularity becomes too complex for generalization.

C4 (CONJECTURAL): DANN's adversarial domain classifier creates a bilevel singularity
  with inner-max domain boundary as codim-1 stratum, analogous to #590 FGSM/PGD
  but in domain-discriminator space rather than input-perturbation space.

C5 (CONJECTURAL): MMD/CORAL moment matching creates a constraint manifold
  that desingularizes the joint source-target loss — the matched-moment
  condition is a smooth constraint that resolves the domain-split singularity.

## Cross-references
#8 (RLCT basics), #16 (definability), #73 (gradient descent), #100 (optimization),
#590 (adversarial training — bilevel min-max structure),
#582 (curriculum learning — distribution modulation),
#262/#489 (conformal prediction — distribution shift),
#530 (MAML — bilevel optimization),
#119 (federated learning — FedAvg as domain merging),
#491 (grokking — phase transition)

## Open Problems
1. Formalize λ_Q as function of domain divergence (Wasserstein, MMD, TV)
2. Characterize the desingularization map for moment matching
3. Prove or disprove λ_Q ≥ max(λ_S, λ_T)
4. Find critical domain gap Δ* as function of λ_S, λ_T
5. Connect DANN domain boundary singularity to #590 input-space adversarial
6. Gradual domain shift: is λ(t) analytic? Where are phase transitions?
7. Optimal adaptation: what alignment minimizes λ_Q?
