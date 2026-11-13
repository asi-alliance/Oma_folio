# Oma Synthesis #876: Teacher Forcing × RLCT

**Date:** 2026-11-07  
**Status:** L0 draft  
**Distinct from:** #382 (Scheduled Sampling × RLCT — covers epsilon-interpolation between regimes; #876 focuses on the structural singularity mismatch itself)

---

## Motivation

Teacher forcing trains autoregressive models on ground-truth context but inference uses model-generated context. This train-test mismatch (exposure bias) is well-known empirically. From an SLT perspective, the teacher-forced loss and free-running loss are **structurally different analytic functions** of the parameters θ, creating different singularity structures and hence different RLCTs.

## Five Candidate Claims

### C1 (PROVEN): R_{an,exp}-definability of both loss surfaces
**Claim:** Both the teacher-forced loss L_TF(θ) and the free-running loss L_FR(θ) are definable in R_{an,exp}.

**Proof sketch:** L_TF = Σ_t CE(f(x_t, y_{<t}; θ), y_t) — composition of analytic functions (linear layers, softmax, cross-entropy), hence in R_{an,exp}. L_FR = Σ_t CE(f(x_t, ŷ_{<t}(θ); θ), y_t) where ŷ_{<t}(θ) = argmax_j f(x_j, ŷ_{<j-1}(θ); θ) recursively. Each ŷ_t involves argmax (semi-algebraic via Tarski-Seidenberg) composed with analytic functions. The recursive composition to depth T is a finite composition of definable functions, hence definable in R_{an,exp}.

### C2 (CONJECTURAL): Structural singularity mismatch — distinct fiber structures
**Claim:** The teacher-forced loss fibers {θ : L_TF(θ) = c} and free-running loss fibers {θ : L_FR(θ) = c} have fundamentally different singularity structures even at the same parameter values.

**Reasoning:** L_TF is a sum of independent cross-entropy terms — each depends on θ through f(·;θ) applied to fixed ground-truth inputs. The Hessian is block-structured by time step. L_FR has recursive dependence: ŷ_t(θ) depends on all previous outputs, each of which depends on θ, creating a Jacobian with off-diagonal coupling across time steps. This self-referential structure creates additional singular directions in the free-running fiber that are absent in the teacher-forced fiber. The argmax branching at each step creates A_1-fold-type singularities at decision boundaries D_ij = {θ : f(x_t,ŷ_{<t};θ)_i = f(x_t,ŷ_{<t};θ)_j}.

### C3 (CONJECTURAL): RLCT gap Δλ = λ_FR - λ_TF as formal measure of exposure bias
**Claim:** The difference in real log canonical thresholds Δλ = λ_free - λ_teacher quantifies exposure bias as a singularity-theoretic invariant.

**Reasoning:** If λ_TF < λ_FR, the teacher-forced loss concentrates the posterior faster (lower RLCT = faster concentration), but the model generalizes to a different (easier) singularity structure. At inference, the posterior on L_FR encounters a higher-RLCT singularity, leading to slower concentration and worse generalization. The gap Δλ > 0 is the formal signature of exposure bias.

### C4 (CONJECTURAL): Generalization bound with RLCT mismatch
**Claim:** The inference-time generalization error satisfies:
G_FR(n) ≤ (λ_FR / (2n)) · log(n) + C(Δλ, n)
where C(Δλ, n) is a correction term from the singularity mismatch, bounded by O(Δλ · log(n) / n) plus a coverage penalty measuring how much of the free-running fiber is unexplored under teacher-forced training.

**Reasoning:** Standard SLT bound applies to L_FR with λ_FR, but the training trajectory under L_TF may not visit all singular strata of L_FR. The coverage penalty measures the measure of L_FR-singular strata missed by the L_TF training distribution.

### C5 (CONJECTURAL): Sequence length T as stratum selector with phase transition
**Claim:** The free-running RLCT λ_FR(T) depends on sequence length T, with a phase transition at critical T* where the recursive self-referential structure begins to dominate.

**Reasoning:** For small T, the recursive composition is shallow and λ_FR(T) ≈ λ_TF. As T grows, the argmax branching creates exponentially many decision boundaries, increasing the effective singularity. The transition T* ~ n^{1/λ_TF} where n is sample size — beyond this, exposure bias becomes SLT-detectable.

## Seven Open Problems

1. **Exact computation of λ_FR:** Can λ_FR be estimated via SGLD on the free-running loss, and does it match theoretical predictions from the recursive argmax structure?
2. **Δλ and error compound rate:** Is the compounding error rate in free-running generation proportional to Δλ?
3. **Optimal scheduled sampling schedule:** Does the optimal epsilon schedule in #382 correspond to an RLCT annealing path that minimizes Δλ?
4. **Decision boundary density:** How does the number of argmax decision boundaries grow with T, and does this control λ_FR?
5. **Transversality of fibers:** Are L_TF and L_FR fibers transverse at the true parameter, or does the recursive structure create tangential intersections?
6. **Coverage penalty estimation:** Can the coverage penalty C(Δλ, n) be estimated from training data without running free generation?
7. **Multi-step vs single-step RLCT:** Is there a per-step λ_t such that λ_FR = Σ_t λ_t, or is the recursive structure non-decomposable?

## Cross-References
#8 (definability), #16 (RLCT basics), #73 (stratum structure), #95 (curriculum), #100 (phase transitions), #127 (generalization bounds), #170 (decision boundaries), #201 (early exit), #213 (LR scheduling), #224 (argmax singularities), #327 (self-distillation), #334 (self-referential systems), #354 (STE/argmax), #362 (CFG), #372 (exposure bias adjacency), #382 (scheduled sampling), #388 (beam search), #390 (locally typical sampling)

## Key Novelty
The RLCT gap Δλ = λ_FR - λ_TF as a **singularity-theoretic invariant measuring exposure bias**, independent of any mitigation strategy. #382 studies the interpolation path (scheduled sampling) between the two regimes; #876 studies the regimes themselves and the gap between them. The self-referential recursive structure of L_FR creates a fundamentally different singularity structure absent in the block-structured L_TF.