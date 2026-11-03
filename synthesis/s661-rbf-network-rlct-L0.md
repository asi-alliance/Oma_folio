#661 RBF Networks × RLCT — L0 Exploration

## Topic: Radial Basis Function (RBF) Networks × Real Log Canonical Threshold

### Architecture Definition
An RBF network with K centers computes:
  f(x; θ) = Σ_{k=1}^{K} w_k · φ(x; c_k, σ_k) + b
where φ(x; c_k, σ_k) = exp(-||x - c_k||² / (2σ_k²)), θ = {(w_k, c_k, σ_k)} ∪ {b}.

### C1 (PROVEN): R_{an,exp} Definability
Each term w_k · exp(-||x-c_k||²/(2σ_k²)) is a polynomial times exp-of-polynomial. Squared norm is polynomial in (x,c_k,σ_k^{-1}). Finite sums preserve R_{an,exp}. Softmax+CE also R_{an,exp}-definable. ∴ C1 PROVEN.

### C2 (CONJECTURAL): Singular Fiber Structure
Θ* has multiple singular strata:
1. Permutation symmetry S_K: non-identifiability, K! redundant parameterizations
2. Dead unit stratum: w_k=0 makes (c_k,σ_k) free. Codim +1 per dead unit
3. Center collapse: c_i=c_j, σ_i=σ_j → merged kernel. Codim-(d+1) stratum
4. Bandwidth collapse: σ_k→0 → delta function limit. Boundary singularity

Conjecture: RLCT dominated by dead units (max fiber dim) or center collapse (lower effective K).

### C3 (CONJECTURAL): Bandwidth σ as Stratum Selector
Large σ: center collapse dominates, lower RLCT. Small σ: dead units dominate, higher RLCT. U-shaped λ(σ) with optimal σ*.

### C4 (CONJECTURAL): Generalization Bound
G_RBF(n) ≤ λ(σ,K)·log(n)/(2n) + U(σ,K)/√n
Over-parameterized: dead-unit stratum dominates, λ increases with K. Optimal K* minimizes RLCT.

### C5 (CONJECTURAL): Phase Transition at (K*, σ*)
Below K*: center-collapse dominates. Above K*: dead-unit dominates. At K*: minimal RLCT. σ* shifts transition.

### Open Problems
1. Exact RLCT for dead-unit stratum with S_K quotient
2. Is center-collapse codim-(d+1) always less singular than dead units?
3. Is σ→0 proper singularity in R_{an,exp} or boundary phenomenon?
4. Shared σ vs per-center σ_k fiber structure difference
5. Constructive RLCT via explicit center coordinates
6. Dead unit dynamics: SGLD-detectable LLC drops?
7. Gaussian vs multiquadric/thin-plate kernel: C1 and fiber changes

### Cross-References
- #169 (Dropout): stochastic masking vs deterministic dead units
- #371 (Fast Weight): rank-deficient matrix fibers vs center collapse
- #383 (VAE): posterior collapse as dead latent unit
- #556 (VQ-VAE): codebook collapse as discrete center collapse
- #506 (Hypernetwork): generative fiber non-identifiability
- #434 (MoE): expert routing vs center selection
- #505 (WeightNorm): scale-direction split vs bandwidth-center split
- #425 (Zoneout): temporal carry degeneracy vs spatial center degeneracy

### Key Novelty
RBF networks provide explicit center coordinates making singular fibers constructively accessible. No prior RBF×RLCT bridge found. RBF is a testbed for RLCT computation methods.

Next: L1 formalization with D1-D7 definitions.
