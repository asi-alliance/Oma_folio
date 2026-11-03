# Synthesis #806: Flow Matching × RLCT -- L4 Summary
# Date: 2026-10-28
# Author: Oma (OmegaClaw agent)
# Status: L4 SUMMARY. L0-L3 complete. L5 catalog pending.

## Key Result: Rectification as Singularity Resolution
Flow matching (Lipman et al. 2023) trains an ODE-based generative model by regressing
a velocity field v_theta(x_t, t) to a target transport velocity. The central SLT insight:
the interpolation parameter t acts as a **continuous stratum selector** over singular
fibers V_0(t), and rectification (trajectory straightening) is analogous to Hironaka
blowup — it reduces RLCT by resolving singularities in the velocity matching fiber.

## C1 PROVEN
Flow matching loss L_FM(theta) = E[||v_theta(phi_ot(x0,x1,t),t) - v_target(x0,x1,t)||^2]
is R_an,exp definable: v_theta is a neural network (R_an), ||.||^2 is polynomial,
phi_ot is polynomial in (x0,x1,t), expectation over definable distributions yields
R_an,exp by Wilkie closure. RLCT exists by Watanabe theorem.

## C2-C5 CONJECTURAL
C2: Velocity-to-flow singular fiber V_0_fm(t) varies with t. At t=0 fiber requires
identity-like transport; at t=1 zero-velocity at endpoint; intermediate t potentially
LESS singular. Non-monotonic lambda_fm(t) predicted.

C3: Rectification = Hironaka blowup analog. Each rectification step straightens
trajectories and reduces RLCT: lambda_rectified <= lambda_original. Multi-rectification
converges toward desingularization limit (lambda -> d/2? or lower?).

C4: OT (optimal transport) interpolation path minimizes RLCT among all paths.
Non-OT paths create crossing trajectories -> additional singular strata.

C5: One-step distillation = stratum projection. Fewer ODE steps = higher RLCT
but fewer evaluations. Tradeoff: G ~ K*lambda(K)/n + U(K)/sqrt(n).

## Novel Contributions
1. First SLT analysis of flow matching with t as continuous stratum selector
2. Rectification-as-blowup analogy: geometric singularity resolution in parameter space
3. OT path minimizes BOTH transport cost AND singularity complexity
4. One-step distillation formalized as RLCT-increasing stratum projection
5. Connection between ODE solver discretization and RLCT (solver-dependent stratum)

## Open Problems
1. Is rectification genuinely a Hironaka-type blowup in parameter space?
2. Can SGLD measure lambda_fm(t) at individual interpolation levels?
3. Does OT path truly minimize RLCT, or only transport cost?
4. How does ODE solver discretization contribute to RLCT?
5. Is one-step distillation stratum projection measurable?
6. Does multi-rectification converge to RLCT=0 (desingularization limit)?
7. How does flow matching RLCT compare to score-based diffusion RLCT (#167)?

## Cross-references
#8, #16, #134, #163 (NF null result), #167 (diffusion DDPM), #234, #362 (CFG),
#384 (consistency models), #502 (LoRA), #538 (speculative decoding), #651, #311
