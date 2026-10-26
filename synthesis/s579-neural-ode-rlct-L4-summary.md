#579: Neural ODE x RLCT - L4: Executive Summary
Date: 2026-10-24

## One-Sentence Summary
This synthesis extends Singular Learning Theory (SLT) and the Real Log Canonical Threshold (RLCT) to Neural ODEs, showing that continuous-depth models admit a richer singularity structure than discrete networks, with ODE bifurcations creating phase transitions in the RLCT.

## Key Results
- C1 (PROVEN): The cost function K(theta) of a Neural ODE is real analytic in parameters, provided analytic activations (tanh, sigmoid) are used. This follows from the analytic dependence of ODE solutions on parameters (Arnold theorem) and analytic composition of the loss.
- C2 (CONJECTURAL): The true parameter set W decomposes into strata by trajectory topology (equilibrium, periodic, chaotic, transient), with codimension determined by bifurcation conditions.
- C3 (CONJECTURAL): The RLCT lambda scales with the Jacobian spectral profile sigma(t) along the optimal trajectory — vanishing eigenvalues create flat directions that lower lambda.
- C4 (CONJECTURAL): Bifurcations (saddle-node, Hopf, transcritical, pitchfork) create phase transitions in lambda, analogous to discrete depth changes in ResNets (#100, #545).
- C5 (CONJECTURAL): The generalization bound G ~ lambda(epsilon, sigma_J) / n + U(epsilon, sigma_J) / sqrt(n) depends on solver tolerance and Jacobian spectral profile, not just parameter count.

## Novelty
- Continuous-depth RLCT: first extension of SLT to continuous-depth models (all prior work uses discrete depth)
- Bifurcation-stratum correspondence: connects dynamical systems bifurcation theory to algebraic geometry singularity strata
- Jacobian spectral RLCT: analyzes singularity along entire trajectory, not just at critical points
- Solver tolerance as continuous stratum selector (vs discrete sparsity pattern in #545)
- Adjoint method singularity analysis: open question whether backward trajectory introduces new singularities

## Open Problems
1. Prove stratum decomposition C2 rigorously
2. Compute lambda for simplest case (1D linear ODE)
3. Does lambda diverge or converge as epsilon -> 0?
4. Classify all ODE bifurcation types and their RLCT contributions
5. Empirically measure lambda in trained Neural ODEs
6. Compare lambda_NeuralODE vs lambda_ResNet at matched P and effective depth
7. Does stiffness affect lambda or only U?
8. Can adjoint backward trajectory create singularities not in forward?

## Cross-References
#100 (ResNet), #545 (Sparse Attention), #229 (KV Cache), #570 (Randomized Smoothing), #561 (Ring Attention), #8 (Base RLCT), #16 (Free Energy)