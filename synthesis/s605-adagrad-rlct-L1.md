# Synthesis #605: Adagrad × RLCT — L1 Formalization
## Date: 2026-10-25
## Status: L1 Formal Definitions

## Formal Definitions

D1 (Parameter Space & Update Map):
Let W ⊂ R^d be the parameter space of a neural network with loss L(w; D)
definable in R_{n,exp}. At step t, the gradient g_t = ∇_w L(w_t; D_t) is
definable as a composition of definable functions (softmax, cross-entropy,
backprop). The Adagrad update map Φ_t: W → W is:
  w_{t+1} = w_t - η · diag(G_t + ε)^{-1/2} ⊙ g_t
where η > 0 is the global learning rate, ε > 0 is a numerical stability
constant, ⊙ denotes element-wise product, and G_t ∈ R^d is the cumulative
squared gradient vector.

D2 (Cumulative Squared Gradient):
G_t = Σ_{k=1}^{t} g_k ⊙ g_k = G_{t-1} + g_t ⊙ g_t, with G_0 = 0.
Each component G_{t,i} = Σ_{k=1}^{t} g_{k,i}^2 is monotonically non-decreasing
in t: G_{t,i} ≥ G_{t-1,i} for all i, t. The function g ↦ g ⊙ g is definable
in R_{n,exp} (polynomial). The partial sum G_t is definable as a finite
sum of definable functions. The limit G_∞ = Σ_{k=1}^{∞} g_k^2 is definable
as a formal series converging for finite training runs.

D3 (Diagonal Preconditioning Metric):
D_t = diag(G_t + ε)^{-1/2} = diag((G_{t,1}+ε)^{-1/2}, ..., (G_{t,d}+ε)^{-1/2}).
This defines a time-dependent Riemannian metric on W: the effective gradient
at step t is D_t · g_t, which normalizes each parameter by its accumulated
gradient magnitude. The map (w_t, G_t) ↦ D_t is definable in R_{n,exp}
since (x + ε)^{-1/2} is definable for x ≥ 0, ε > 0 (composition of
restricted analytic square root and reciprocal, both in R_{n,exp}).
The singular locus of D_t occurs at G_{t,i} + ε = 0, which is excluded
by ε > 0, but the non-analytic structure arises from the closure of
{G_{t,i} = 0} as t increases — each zero-accumulation direction defines
a facet of the singular locus.

D4 (Frozen Set & Stratum):
Define the frozen set at step t:
  S_t = {i ∈ {1,...,d} : G_{t,i} > τ(t)}
where τ(t) is a threshold function (e.g., τ(t) = c · t for some c > 0,
or a percentile-based threshold). Parameters in S_t have vanishing
effective learning rate: η_eff,i = η / √(G_{t,i} + ε) → 0 as G_{t,i} → ∞.
The complement S_t^c = {1,...,d} \ S_t is the active (non-frozen) set.
Monotonicity: if G_{t,i} > τ(t) and τ is non-decreasing, then i ∈ S_{t'}
for all t' > t. Thus S_t is monotonically non-decreasing: |S_t| ≥ |S_{t-1}|.
This is the irreversibility property — distinct from Adam which applies
bias correction b_t = (1 - β^t) preventing full freezing.

D5 (Effective RLCT):
The effective RLCT after freezing at step t is:
  λ_eff(t) = λ_0 · (d - |S_t|) / d
where λ_0 is the initial RLCT of the loss landscape (the RLCT of the
full parameter space before any freezing). The rationale: frozen
parameters are projected onto a fixed subvariety, reducing the effective
dimension of the singularity from d to d - |S_t|. The RLCT scales
linearly with effective dimension for generic singularities (this is
conjectural — the actual scaling depends on the singularity structure
of the specific stratum onto which parameters are frozen). This defines
a monotonically non-increasing λ_eff(t): freezing can only reduce
the effective RLCT, never increase it.

D6 (Generalization Bound):
  G_Adagrad(t) ≤ λ_eff(t) / n_eff(t) + U(t) / √(n_eff(t))
where:
  - λ_eff(t) = λ_0 · (d - |S_t|) / d is the effective RLCT (D5),
  - n_eff(t) = n · (d - |S_t|) / d is the effective sample size,
    reduced because frozen parameters contribute no gradient information,
  - U(t) is a bounded complexity term (remainder from the WAIC
    expansion, depending on the geometry of the active stratum).
Tension: as |S_t| grows, λ_eff decreases (good for generalization) but
n_eff also decreases (bad for generalization). The optimal freezing
point t* maximizes G_Adagrad by balancing these two effects.
Unlike Adam (#289/#304), whose bias correction maintains exploration
in all directions, Adagrad's irreversible freezing creates a tighter
but less flexible bound. The monotonic G_t ensures λ_eff is monotonically
non-increasing, while n_eff is also non-increasing.

D7 (Phase Transition):
There exists a critical step t* ~ n^{1/(λ_0 + 1)} at which |S_t| exceeds
d/2 (the majority of parameters are frozen). For t < t*: the frozen set
is small, λ_eff ≈ λ_0, and the optimizer explores multiple singular
strata freely. For t > t*: |S_t| > d/2, and the optimizer effectively
performs coordinate descent on the remaining |S_t^c| unfrozen parameters.
The transition is sharp because G_{t,i} grows quadratically for
frequently-updated parameters and linearly for rarely-updated ones —
once the gap opens, it widens monotonically.
Testable prediction: SGLD learning coefficient (LC) shows a kink at t*
when plotting LC vs training step. Cross-optimizer comparison: Adam
(with bias correction) should NOT show this kink because it resets the
effective accumulation.

## Claims (from L0, formalized)

C1 (PROVABLE) The Adagrad update map Φ_t is definable in R_{n,exp}:
g_t is definable (composition of definable neural network functions),
g_t ⊙ g_t is definable (polynomial), G_t is a finite sum of definable
functions (definable), (G_{t,i} + ε)^{-1/2} is definable for G_{t,i} ≥ 0,
ε > 0 (restricted analytic square root and reciprocal in R_{n,exp}),
and the Hadamard product D_t ⊙ g_t is definable (polynomial). The
update map Φ_t: (w_t, G_t) ↦ w_{t+1} is thus definable in R_{n,exp}.
The singular locus of the Adagrad trajectory is the union over t of
the singular loci introduced at each step by the non-analytic structure
of (G_t + ε)^{-1/2} near G_{t,i} = 0 — a +t·d-dimensional non-analytic
structure definable as a semi-algebraic set (finite union of sets
defined by G_{t,i} = 0 comparisons).

C2 (CONJECTURAL) Adagrad creates a time-dependent degenerate Fisher
fiber. The frozen set S_t (D4) defines a degenerate Fisher information
matrix: F_eff(t) = D_t · F · D_t where F is the Fisher, and the
directions in S_t have D_{t,i} → 0, making F_eff rank-deficient with
rank d - |S_t|. The fiber degeneracy is monotonic: |S_t| ≥ |S_{t-1}|.

C3 (CONJECTURAL) D_t acts as a stratum selector (D3, D4). The phase
transition t* (D7) is testable via SGLD: measure LC before and after t*
and observe a plateau corresponding to stratum freezing.

C4 (CONJECTURAL) The generalization bound G_Adagrad(t) (D6) holds with
the stated tension between λ_eff and n_eff. The optimal t* balances
these.

C5 (CONJECTURAL) The phase transition at t* (D7) is sharp for generic
loss landscapes. SGLD experiments on Adagrad vs Adam should show a kink
in LC for Adagrad but not for Adam.

## Open Problems

1. Is λ_eff(t) = λ_0 · (d - |S_t|) / d exact, or does partial freezing
   create intermediate strata with their own RLCT?
2. Does monotonic G_t create a genuine phase transition, or is the
   transition gradual? Can |S_t|/d be computed analytically?
3. Does freezing occur preferentially on or near singular strata of
   the loss landscape?
4. Relationship between Adagrad freezing and Kolmogorov complexity of
   data — is this implicit regularization toward low-complexity solutions?
5. Can irreversible freezing be related to blow-up of resolution for the
   singular fiber? Is the projection a partial resolution?
6. Adagrad vs RMSProp comparison in RLCT terms — does the forgetting
   factor raise or lower effective RLCT?
7. Falsification: if SGLD on Adagrad vs Adam shows no LC difference,
   the stratum freezing hypothesis (C2-C5) is falsified.

## Cross-References
- #289/#304: Adam (momentum + bias correction + variant scale)
- #433: Weight Decay (L2 penalty modifies variety)
- #316: One-Cycle LR (cycling schedule)
- #415: Muon (O(d) projection)
- #516: Preconditioned optimizers (K-FAC, Shampoo)
- #604: One-Cycle LR L1 (irreversible rho(t) commitment)
- #533/#553: Gradient Accumulation (intersection zero-loss set)
- #569: Gradient Penalty (input-space Jacobian singularity)
- #578: Gradient Surgery/PCGrad (non-conservative gradient field)
- #298/#528: Orthogonal Initialization (Stiefel manifold)
