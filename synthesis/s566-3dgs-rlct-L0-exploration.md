#566 — 3D Gaussian Splatting x RLCT — L0 Exploration

Date: 2026-10-23
Candidate Origin: Open problem #6 in #565 NeRF x RLCT. Zero catalog hits. Zero SLT websearch hits. Distinct from #565 (explicit Gaussian primitives vs implicit MLP radiance field).

## Domain Overview

3DGS [Kerbl et al. 2023] represents a scene as N anisotropic 3D Gaussians, each parameterized by mean mu_k, covariance Sigma_k, opacity alpha_k, and color c_k (spherical harmonics). Rendering = differentiable rasterization projecting 3D Gaussians to 2D and alpha-compositing. Training = gradient descent on image reconstruction loss.

## 5 RLCT Bridge Angles

C1 (PROVEN): Reconstruction loss L(theta) = sum_view ||I_view - Render(G_theta, camera)||^2 is definable in RLCT framework. Parameter space W = R^(N*p). K(w) = L(w)/n well-defined. Generalization bound G(n) ~ lambda/n + (m/2n)log(n) applies with lambda = RLCT.

C2 (CONJECTURAL): Gaussian parameter singularity creates degenerate critical points. When Sigma_k -> 0 or alpha_k -> 0, Gaussian contributes nothing to rendering — loss is locally flat along these parameters, creating singular fiber where multiple (mu_k, Sigma_k, alpha_k) yield identical rendered output.

C3 (CONJECTURAL): Adaptive density control (densification/pruning) acts as stratum selector. Opacity threshold tau creates discrete family of model classes with different RLCTs lambda(N). Above tau*, pruning preserves essential structure (low lambda); below tau*, aggressive pruning collapses fiber structure (high lambda). Phase transition.

C4 (CONJECTURAL): Differentiable rasterization creates projection operator P: R^(N*p) -> R^(H*W*3) with non-trivial null space. Many parameter configs produce identical images — fiber P^{-1}(I) is high-dimensional singular submanifold when degenerate Gaussians exist.

C5 (CONJECTURAL): N_gaussians serves as complexity dial in generalization bound. As N increases, m increases linearly but lambda may scale sub-linearly (redundant Gaussians on same fiber don't increase lambda). Prediction: G(N) ~ lambda(N)/n + N*p/(2n)*log(n), with lambda(N) sublinear.

## Key Novelties

1. Explicit primitive singularity (unlike NeRF implicit singularities)
2. Adaptive density as stratum selector (no prior RLCT connection)
3. Rasterization null space as fiber (more concrete than NeRF)
4. Opacity pruning phase transition
5. N as complexity dial (testable prediction)

## Cross-References

#565 NeRF x RLCT, #8 NN RLCT foundations, #16 Perceptron identifiability, #167 Diffusion x RLCT, #507 Candidate screening, #57 Gaussian mixture RLCT

## Next Steps

L1: Formalize C1-C5 as precise mathematical claims with definitions of K(w), fiber structure, and stratum family.