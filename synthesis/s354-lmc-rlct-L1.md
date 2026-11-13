### Synthesis #354: Linear Mode Connectivity (LMC) x RLCT - L1

**Date**: 2026-11-05
**Status**: L1 DRAFT
**From**: L0 at s354-lmc-rlct-L0.md

### D1 (Parameter Space & Interpolation Path)
W = parameter space R^d. Two independently trained minima w_1, w_2 in W. Linear interpolation path: gamma(t) = (1-t)*w_1 + t*w_2, t in [0,1]. Loss function L: W -> R_>=0 analytic (KL divergence). Regularized loss R_an,exp(theta) = L(theta) + beta*||theta||^2.

### D2 (Loss Barrier Definition)
B(w_1, w_2) = max_{t in [0,1]} L(gamma(t)) - max(L(w_1), L(w_2)). LMC holds iff B ~ 0 (barrier negligible relative to endpoint loss). The barrier is the key observable quantity.

### D3 (R_an,exp Structure)
R_an,exp(theta) = L(theta) + beta||theta||^2. L is analytic (KL divergence of neural network, polynomial via softmax + sigmoid composition). **C1: R_an,exp is real-analytic on open dense subset. PROVEN.** Standard SLT (Watanabe 2018).

### D4 (Singular Fiber & Connectivity)
Zero-loss fiber V = {theta : L(theta) = 0}. Singular fiber decomposes into connected components: V = V^(1) union ... union V^(k). Each component may contain singularities (points where Fisher information degenerates). **C2: LMC holds iff w_1 and w_2 lie in the same connected component of V. CONJECTURAL.** For regular models (RLCT=d/2), V is smooth manifold, always connected (generically), LMC always holds. For singular models, V can be disconnected, LMC may fail.

### D5 (RLCT as Barrier Predictor)
At each point theta on the interpolation path gamma(t), the local RLCT lambda(theta) measures singularity strength. Define path-integrated RLCT: Lambda(gamma) = max_{t} lambda(gamma(t)). If the path crosses a singular stratum S with RLCT lambda_S > d/2, barrier B > 0. **C3: B > 0 iff Lambda(gamma) > d/2 (i.e., path crosses a high-RLCT stratum). CONJECTURAL.** The threshold d/2 is the regular model RLCT; exceeding it signals genuine singularity.

### D6 (Generalization Bound Along Path)
For any point theta on gamma(t), gen bound: G(theta) ~ lambda(theta)*log(n)/(2n) + U(theta)/sqrt(n). At barrier crossing (high lambda), G spikes. **C4: The generalization bound along the interpolation path has a spike at stratum crossings, with magnitude controlled by RLCT of the crossed stratum. CONJECTURAL.** This connects mode connectivity to generalization theory: connected modes share similar generalization, disconnected modes may not.

### D7 (LMC Phase Transition)
Define critical RLCT threshold lambda* = d/2. Models with max stratum RLCT <= lambda* exhibit LMC (barrier-free interpolation). Models with strata having RLCT > lambda* may exhibit barriers. **C5: There exists a phase transition at lambda* = d/2 separating LMC-holding from LMC-failing regimes. SGLD-testable: measure LLC along interpolation path, expect spike at barrier. CONJECTURAL.**

---
### Open Problems
1. Is empirical LMC due to connected fibers or training dynamics reaching only one component?
2. Can Newton polyhedron / toric fan data predict barrier for specific architectures?
3. Does SGLD LLC profile along interpolation path show predicted spike at crossings?
4. Is lambda* = d/2 the correct threshold, or is it architecture-dependent?
5. How does permutation symmetry (head permutation, neuron permutation) affect fiber connectivity?
6. Does data distribution affect singular fiber connectedness?
7. Relationship to Lottery Ticket Hypothesis: does LTH select points in the same connected component?

### Cross-References
#189 (double descent), #241 (gradient clipping), #187 (DP-SGD), #567 (Neural ODE), #86 (attention symmetry), #482/#559/#598 (SAM), #354 (self)

### Key Novelty
LMC reframed as connected singular fiber hypothesis. Loss barrier = RLCT-controlled singular stratum crossing. Unlike prior syntheses: #189 (training threshold phase transition), #241 (training-time clipping), #187 (noise exploration), #567 (trajectory fiber). LMC is the unstudied geometric counterpart to SAM's flatness analysis.
