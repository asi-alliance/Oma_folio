# Synthesis #843: Reservoir Computing / Echo State Networks x RLCT (L0 - Informal Bridge)
Date: 2026-11-03 | Status: L0 draft

## Topic
Echo State Networks (s_{t+1} = tanh(W_r s_t + W_in x_t), W_r fixed random with spectral radius rho < 1, only linear readout W_out trained) analyzed via Real Log Canonicaal Threshold (Watanabe) singular learning framework.

## Motivation
Zero coverage: catalog grep 0, memory 0, no external SLT-RLCT-ESN bridge (websearch 2026-11-03). ESN = extreme frozen-feature learner: learning happens only in a d_out x N linear readout on rich random dynamics. Singularity structure: (a) random reservoir defines a FIXED analytic feature map, the learning problem lives on its image manifold; (b) edge-of-chaos criticality (rho ~ 1) is empirically optimal - a natural stratum-selection phenomenon; (c) echo state property rho < 1 = contraction, a topology constraint on the fiber.

## Core Claims (C1-C5)
- C1 PROVEN (definability): reservoir update tanh (R_an), fixed W_r, linear readout, quadratic/sigmoid loss -> composite loss definable in R_an,exp. Standard composition argument.
- C2 CONJECTURAL: frozen random reservoir = fixed singular fiber in the full parameter space; training readout only realizes a REDUCED learning problem with lambda_readout <= lambda_full (effective dimension of feature-image manifold governs, cf #601 linear probe frozen-backbone bound).
- C3 CONJECTURAL (star): spectral radius rho acts as monotone stratum selector on the reservoir feature map; lambda(rho) non-trivial with a phase change near the edge of chaos rho ~ 1 (memory-capacity / information-processing transition = dominant-stratum swap; echo state boundary as singular locus).
- C4 CONJECTURAL: generalization bound G ~ lambda_eff/n + U(rho)/sqrt n with lambda_eff from the readout-on-features problem, not the raw parameter count; ridge regularization acts as Gaussian blow-up making lambda_eff = d_eff/2 in generic regime explicit.
- C5 CONJECTURAL: at rho -> 1 the feature map develops slow/critical modes (vanishing contraction) creating extra degeneracy in W_out space - Hessian rank drop on the readout fiber; SGLD LLC on readout should show a staircase as rho crosses ~1 from below.

## Cross-refs
#8, #16, #601 (linear probe / frozen backbone), #385 (LoRA frozen backbone), #506 (hypernetwork generated weights), #528 (orthogonal init random matrices), #841 (NTK critical points), #480 (phase transitions), #842 (capacity transitions).

## Open Problems
1. Formal reduced-problem inequality lambda_readout <= lambda_full (projection of Kullback-Leibler onto readout coordinates).
2. Lambda(rho) monotonicity: random matrix theory (circular law) on the feature covariance degeneracy vs rho.
3. Edge-of-chaos as singular locus: is the echo-state boundary rho=1 itself a stratum wall?
4. Memory capacity (Jaeger C_mem ~ N(1 - rho)) vs lambda(rho): quantitative match test.
5. Deep ESNs / leaky integrators: stacked frozen dynamics, singularity accumulation.
6. SGLD protocol: small ESN, readout LLC sweep in rho, detect staircase at rho ~ 1.
7. Liquid state machines (spiking): does event-driven discreteness break definability (cf STE #354)?

## Next
L1 formalization (D1-D7).
