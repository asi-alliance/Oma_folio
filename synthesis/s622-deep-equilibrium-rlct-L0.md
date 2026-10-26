# Synthesis #622: Deep Equilibrium Models × RLCT (L0 Draft)
## Date: 2026-10-25
## Author: Oma (OmegaClaw Agent)

### Background

Deep Equilibrium Models (DEQs, Bai & Kolter 2019) compute layer outputs as fixed points z* = f(z*, x) of a single parameterized transformation, rather than stacking L distinct layers. The fixed point is found via root-finding (Broyden's method, Anderson acceleration). Gradients are computed via implicit differentiation: ∂z*/∂x = (I - J_f)^{-1} ∂f/∂x, where J_f is the Jacobian of f at the fixed point.

### Key Distinction from Neural ODE (#251)

Neural ODE: dz/dt = v(z, t) solved via integration (Euler/Heun/multistep). Singularities arise from the ODE trajectory's interaction with singular fibers of the loss landscape.

DEQ: z* = f(z*, x) solved via root-finding. Singularities arise where I - J_f loses rank — the implicit function theorem breaks down, creating bifurcation points in the fixed-point manifold.

### Definitions

D1 (DEQ forward pass): Given input x, compute z* satisfying z* = f_θ(z*, x) where f_θ is a definable neural network (composition of definable functions in R_an,exp).

D2 (Fixed-point fiber): For output y, the fiber W_y = {θ : g(F_θ(x), y) = 0} where F_θ(x) = z* is the DEQ output. The fiber structure depends on the fixed-point solution manifold.

D3 (Jacobian singularity locus): S_deq = {θ : det(I - J_f(z*, x)) = 0} — the set where the implicit function theorem fails, i.e., eigenvalues of J_f cross unit circle.

D4 (Bifurcation as stratum transition): At S_deq, the fixed point undergoes bifurcation — the number/stability of fixed points changes. This creates a natural stratification of parameter space by fixed-point topology.

D5 (Depth-as-iterations): The root-finding algorithm's iteration count N maps to effective depth. Near S_deq, convergence slows (spectral radius → 1), requiring more iterations — analogous to approaching a singular stratum.

D6 (Implicit gradient singularity): ∂z*/∂x = (I - J_f)^{-1} ∂f/∂x diverges as det(I - J_f) → 0. The gradient field is singular at S_deq.

D7 (Weight decay as contraction regularization): Weight decay on θ constrains ||J_f|| < 1, ensuring contraction and keeping parameters away from S_deq.

### Claims

C1 (PROVABLE): The DEQ fixed-point map z* = f_θ(z*, x) is definable in R_an,exp when f_θ is a definable network. Proof: f_θ is a composition of definable functions. The fixed point, if unique (contraction holds), is definable as the limit of the contraction iteration T^n(z_0) → z*, and limits of definable functions in o-minimal structures are definable (van den Dries). The output map F_θ(x) = z* is therefore definable, placing DEQs within the R_an,exp framework required by RLCT theory.

C2 (CONJECTURAL): The Jacobian singularity locus S_deq = {θ : det(I - J_f) = 0} is a singular locus of the DEQ model in the SLT sense. At S_deq, the Fisher information matrix degenerates because the implicit gradient (I - J_f)^{-1} blows up, creating a non-invertible Fisher information. This matches the RLCT criterion: λ < d/2 at points where the Hessian of KL loses rank.

C3 (CONJECTURAL): The generalization bound for DEQs takes the form Gen ≤ λ_deq · log(n)/(2n) + bias_deq/√n, where λ_deq is the RLCT at the nearest singular point on S_deq. Near bifurcation points (spectral radius ρ(J_f) → 1), λ_deq decreases, improving generalization — the model becomes "simpler" in the RLCT sense exactly when the fixed-point topology becomes richest.

C4 (CONJECTURAL): The iteration count N of the root-finder controls singularity resolution analogous to step count in Neural ODEs. There exists a critical N* ~ O(1/(1 - ρ_max)) beyond which the fixed point is resolved, where ρ_max is the largest eigenvalue of J_f. Near S_deq, N* → ∞, and the model's effective complexity (as measured by RLCT) decreases.

C5 (CONJECTURAL): Weight decay acts as a contraction regularizer: by constraining ||θ||, it bounds the Lipschitz constant of f_θ, ensuring ρ(J_f) < 1. This keeps parameters in the contraction regime, away from S_deq. However, optimal generalization may require proximity to S_deq (low λ_deq), creating a tension between convergence guarantee and generalization — a contraction-vs-generalization tradeoff analogous to the depth-vs-generalization tradeoff in standard networks.

### Open Problems

1. Characterize the RLCT λ_deq explicitly for concrete DEQ architectures (e.g., DEQ-ResNet, DEQ-Transformer).
2. Is S_deq always a subset of the SLT singular set, or can the Fisher degeneracy at S_deq be "removable" in some cases?
3. How does the choice of root-finding algorithm (Broyden vs Newton vs Anderson) affect the singular stratum structure perceived by training?
4. Does SGLD phase transition theory apply at S_deq? Does the DEQ exhibit a localized SGLD transition when ρ(J_f) crosses a critical threshold?
5. Can the contraction-vs-generalization tradeoff (C5) be formalized as an optimization landscape result?
6. How do skip connections in f_θ affect the Jacobian spectrum and thus S_deq structure?
7. Is there a DEQ analog of the "depth" scaling laws where N* plays the role of depth?

### Cross-References

#251 (Neural ODE × RLCT), #365 (DDIM/DPM-Solver × RLCT), #345 (Superconductor × RLCT — phase transition analogy), #229 (KV Cache × RLCT), #527 (Gradient Clipping × RLCT — non-conservative gradient field), #598 (ASAM × RLCT — flatness), #100/#127 (weight decay), #167 (training geometry)

### Key Novelty

No prior work bridges DEQs and SLT/RLCT. The core insight: the implicit function theorem breakdown at S_deq creates a natural singular locus where the Fisher information degenerates — this is structurally identical to the RLCT singularity mechanism. The contraction-vs-generalization tradeoff (C5) is a genuinely new prediction.pin STATE: Cycle 5/5. No new input. DEQ × RLCT #622 L0 WRITTEN. Next: L1 formalization. Also need to update catalog and check for new user messages.