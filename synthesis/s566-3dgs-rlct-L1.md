#566 — 3D Gaussian Splatting x RLCT — L1 Formalization
Date: 2026-10-23

## Definitions

D1 (Parameter Space): Let G = {G_k}_{k=1}^N be a set of N anisotropic 3D Gaussians. Each G_k is parameterized by theta_k = (mu_k, Sigma_k, alpha_k, c_k) where mu_k in R^3 (mean), Sigma_k = R_k S_k S_k^T R_k^T in R^{3x3} (covariance via rotation R_k in SO(3) and scale S_k in R^3_+), alpha_k in [0,1] (opacity), c_k in R^{d_sh} (spherical harmonics color). Full parameter w = (theta_1, ..., theta_N) in W = R^{N*p}, p = 3+6+1+d_sh. The normalized loss K(w) = (1/n) sum_{i=1}^n ||I_i - Render(G_w, Pi_i)||^2 where Pi_i is camera pose and n is number of training views.

D2 (R_{an,exp} Definability): The rendering operator Render(G_w, Pi) is a composition of: (a) Gaussian projection E_3D->2D: polynomial in mu_k, Sigma_k (affine projection of covariance), (b) alpha-compositing: piecewise-linear in sorted alpha_k values with sorting by depth (piecewise-definable via semi-algebraic comparisons), (c) spherical harmonics evaluation: polynomial in c_k. The loss L(w) = sum ||I_i - Render||^2 is polynomial in the rendered output. Since rendering is subanalytic (polynomial compositions + piecewise-linear sorting) and the loss is polynomial, K(w) is definable in R_{an} (subanalytic structure), hence in R_{an,exp}.

D3 (Zero-Loss Set): V(I) = {w in W : K(w) = 0} = {w : Render(G_w, Pi_i) = I_i for all i=1..n}. This is the set of all Gaussian configurations that perfectly reconstruct the training images. The fiber structure is defined by the rendering equivalence: w ~ w' iff Render(G_w, Pi) = Render(G_w', Pi) for all training cameras Pi.

D4 (Singular Fiber): The fiber V(I) is singular when degenerate Gaussians exist. Define the degenerate locus D = {w : exists k, alpha_k = 0 or Sigma_k -> 0 (det(Sigma_k) = 0)}. On D, the k-th Gaussian contributes nothing to rendering, so perturbing (mu_k, Sigma_k, c_k) does not change the rendered image. This creates a high-dimensional singular stratum: the fiber V(I) intersect D has locally higher dimension than the regular part V(I) \ D, violating the smooth manifold condition. The null space of the rendering operator restricted to degenerate Gaussians is the singular fiber.

D5 (RLCT): The RLCT lambda(w) at a critical point w* is defined as the pole order of the zeta function: zeta(z) = integral_{W} K(w)^z * phi(w) dw, where the pole at z = -lambda/2 determines the asymptotic generalization. For 3DGS, lambda depends on the singularity structure of V(I): regular points have lambda = d/2 (d = dim of regular fiber), singular points on D have lambda > d/2.

D6 (Stratum Selector — Adaptive Density): The 3DGS training loop applies adaptive density control: (a) clone Gaussians with positional gradient > tau_grad (densification), (b) prune Gaussians with alpha < tau_alpha (opacity pruning), (c) split large Gaussians, (d) reset alphas periodically. Each densification step changes N -> N', creating a new model class M_{N'} with parameter space W_{N'} = R^{N'*p}. The opacity threshold tau_alpha acts as a stratum selector: high tau_alpha prunes more aggressively, removing degenerate (low-alpha) Gaussians and thus removing singular strata, potentially increasing lambda by destroying flat directions but decreasing m. Low tau_alpha retains degenerate Gaussians, keeping high-dimensional singular fibers with lower effective lambda.

D7 (Generalization Bound): The generalization error for 3DGS with N Gaussians after training on n views satisfies: G(n, N) <= lambda(N, tau) / n + (N*p / (2*n)) * log(n) + C / sqrt(n), where lambda(N, tau) is the RLCT at the learned solution, depending on N and the opacity pruning threshold tau. The tension is between N*p/(2n)*log(n) (complexity grows with N) and lambda(N,tau)/n (RLCT may decrease with N as more Gaussians create more degenerate fibers with flat directions). Optimal N* balances these terms.

## Claims

C1 (PROVEN): K(w) is definable in R_{an,exp}. Proof: Rendering is a composition of polynomial projections (mu, Sigma -> 2D mean/covariance), piecewise-linear alpha-compositing (sorting is semi-algebraic), and polynomial SH color evaluation. The squared loss is polynomial. Polynomial composed with subanalytic functions is definable in R_{an}. R_{an} subset R_{an,exp}. QED.

C2 (CONJECTURAL): The degenerate locus D = {w : det(Sigma_k) = 0 or alpha_k = 0 for some k} is a proper analytic subvariety of W. The fiber V(I) cap D has dimension strictly greater than dim(V(I)) - codim(D) at degenerate points, making V(I) a singular analytic set. The RLCT lambda at degenerate configurations exceeds d/2 where d = dim(regular fiber), with the excess proportional to the number of degenerate Gaussians N_deg: lambda approx (d + N_deg * p_deg) / 2 where p_deg is the dimension of the null space per degenerate Gaussian.

C3 (CONJECTURAL): The opacity pruning threshold tau_alpha acts as a stratum selector. Let lambda(tau) be the RLCT of the pruned model where all Gaussians with alpha < tau are removed. Then: (a) lambda(tau) is non-decreasing in tau for tau in (0, 1) — pruning removes flat (degenerate) directions, increasing effective RLCT; (b) there exists a critical threshold tau* at which the model transitions from over-parameterized (many degenerate Gaussians, low lambda) to under-parameterized (few Gaussians, high lambda but high bias); (c) the optimal tau* minimizes the generalization bound G(n,N) from D7.

C4 (CONJECTURAL): The generalization bound G(n, N) <= lambda(N, tau*)/n + (N*p/(2n))*log(n) + U(N,tau*)/sqrt(n) holds, where lambda(N, tau*) is sub-linear in N (redundant Gaussians on the same fiber do not increase lambda) and U captures the optimization bias from densification. The optimal N* satisfies d/dN [lambda(N)/n + Np*log(n)/(2n)] = 0, predicting N* ~ lambda'(N)^{-1} * (2n)/(p*log(n)), testable via SGLD.

C5 (CONJECTURAL): The densification schedule (clone/split/prune) creates a piecewise-constant RLCT trajectory: lambda(t) is constant within each densification interval and jumps at densification steps. This is a novel non-smooth RLCT dynamics distinct from continuous regularization methods (#433 weight decay, #394 SWA). The densification rate (how often N changes) acts as a secondary selector, with faster densification leading to more rapid stratum exploration but higher variance in the RLCT estimate. A phase transition occurs at a critical densification frequency f*: below f*, the model under-fits the scene (high bias); above f*, over-densification creates excessive degenerate Gaussians (low lambda but high complexity term).

## Open Problems

1. Formalize the dimension of the rendering null space as a function of camera viewpoints and scene geometry.
2. Prove or disprove the sub-linearity of lambda(N) — do redundant Gaussians truly not increase RLCT?
3. Derive the exact relationship between N_deg (degenerate Gaussian count) and lambda excess.
4. Empirically verify the tau* phase transition via SGLD on 3DGS trained models.
5. Formalize the piecewise-constant RLCT dynamics under densification as a renewal process.
6. Compare 3DGS RLCT to NeRF RLCT (#565): which has lower lambda for equivalent visual quality?
7. Investigate the interaction between SH degree and RLCT (higher SH = more color parameters = higher m but potentially lower lambda via better fit).

## Cross-References

#565 NeRF x RLCT (implicit field counterpart, open problem #6 = this synthesis)
#8 NN RLCT foundations (Watanabe)
#16 Perceptron identifiability (parameter degeneracy analog)
#57 Gaussian mixture RLCT (related singular geometry)
#167 Diffusion x RLCT (generative model RLCT program)
#354 STE x RLCT (discrete-continuous bridge, related to alpha pruning)
#433 Weight Decay x RLCT (continuous regularization contrast)
#394 SWA x RLCT (averaging vs densification)
#480 muP x RLCT (width parameterization, related to N scaling)
#468 PPO x RLCT (branch-switch, related to pruning piecewise structure)
#545 Sparse Attention x RLCT (sparsity as stratum selector)
#551 GaLore x RLCT (rank selection, related to N selection)