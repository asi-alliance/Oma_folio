#Synthesis #528: Orthogonal Initialization × RLCT — L0 Exploration

## Topic
Orthogonal initialization: initializing weight matrices W with orthogonal columns (W^T W = I or W^T W = cI), as introduced by Saxe et al. 2014. Key property: dynamical isometry — input-output Jacobian singular values concentrated near 1, preserving gradient magnitude across depth.

## Why this is novel
Zero catalog hits. No prior art connecting orthogonal initialization to RLCT or singular learning theory. Existing work (Saxe, Pennington, Schoenholz) studies dynamical isometry via mean-field theory, not algebraic geometry of the loss landscape. Initialization determines the starting point in parameter space — the initial stratum the optimizer inhabits — which directly affects which singular locus the trajectory approaches. This is the RLCT angle nobody has explored.

## Key Questions / Claims

**C1 (PROVABLE):** Orthogonal initialization W_0 with W_0^T W_0 = I is a point on the Stiefel manifold V_d(R^k), which is a real algebraic variety defined by polynomial equations Σ_j W_{ij} W_{jk} = δ_{ik}. This is R_an-definable (in fact semi-algebraic).

**C2 (CONJECTURAL):** Orthogonal init places the starting point w_0 on a specific stratum of the loss landscape determined by the intersection of V_d(R^k) with the singular fiber structure of L_n. Random orthogonal W_0 samples from the Stiefel manifold uniformly, which corresponds to a specific initial distribution over strata — biased toward high-symmetry regions due to the orthogonality constraint.

**C3 (CONJECTURAL):** Dynamical isometry (singular values ≈ 1) means the initial Hessian spectrum is controlled — no exponentially large or small eigenvalues. This places w_0 near a regular point of the loss (away from highly singular strata), so the initial RLCT λ(w_0) is close to the minimum RLCT λ_min. The trajectory starts in a favorable basin and may reach deeper singular strata faster due to preserved gradient signal.

**C4 (CONJECTURAL):** Gen bound G_orth ≤ λ_eff · log(n)/(2n) where λ_eff is lower than random init because the trajectory reaches lower-RLCT strata more reliably. The dynamical isometry advantage is not just optimization speed but generalization: by preserving gradient information, the optimizer crosses singular strata more effectively, reaching more degenerate (lower-λ) solutions.

**C5 (CONJECTURAL):** SGLD initiated from orthogonal vs random init shows different LLC trajectories. Orthogonal init should show faster LLC convergence (stabilizes earlier) and potentially lower steady-state LLC, reflecting deeper stratum access. Phase transition: at critical depth d*, orthogonal init maintains gradient signal while random init loses it — the LLC gap opens at d*.

## Open Problems (7)
1. Does the Stiefel manifold constraint at initialization create a measurable stratum selection effect vs unconstrained random init?
2. Is the lower-RLCT hypothesis (orthogonal init → deeper strata) empirically testable via SGLD LLC comparison?
3. Interaction between orthogonal init and width — does dynamical isometry effect vanish at infinite width (muP regime, #480)?
4. Does orthogonal init change the basin of attraction structure, or just the initial point within a basin?
5. Stiefel manifold as initial condition: does uniform sampling over V_d create a specific prior distribution over reachable singular fibers?
6. Connection to #221 BN (normalization during training) vs orthogonal init (normalization at initialization) — both control spectral properties but at different stages
7. Critical depth d*: is this the same d* as in dynamical isometry theory, or a different RLCT-specific threshold?

## Cross-References
#8 (ReLU definability), #16 (semi-algebraic), #99 (SGD dynamics), #221 (BN batch size), #328 (LayerNorm), #421 (layer scale), #424 (Fixup scale), #480 (muP width), #484 (ReZero alpha=0 init), #515 (GroupNorm), #525 (Entropy-SGD), #526 (Schedule-Free)

## Next: L1 formalization