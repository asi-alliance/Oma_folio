# Synthesis #832: Equivariant Neural Network x RLCT - L1 FORMALIZATION

## Definitions

- **D1 (Parameter Space)**: W = R^d parameter coordinates. Group G acts on W via representation rho: G -> GL_d. The equivariant constraint restricts weights to the fixed-point submanifold W^G = {w | w = rho(g) w for all g in G}. Irreducible decomposition: W^G = sum_i m_i V_i, where m_i = multiplicity space, V_i = irreducible representation of G. Dimension: dim(W^G) = sum_i m_i * dim(V_i).

- **D2 (Equivariant Loss)**: L_eq(w, x) = standard loss L composed with G-invariant projection P_G (polynomial averaging over G or invariant-theoretic Reynolds operator). L_eq(w, x) = L(P_G(w), x) where P_G(w) = (1/|G|) sum_g rho(g) w for finite G, or integral over Haar measure for compact G.

- **D3 (R_{an,exp} Definability - C1 PROVEN)**: L_eq is R_{an,exp}-definable. Proof: standard loss L is analytic in activations (ReLU subanalytic, softmax exp-definable). P_G is polynomial in w (finite G) or integral of analytic functions (compact G, definable by o-minimal integration results). Composition of definable functions is definable.

- **D4 (Irreducible Decomposition Singular Fiber)**: The fiber V_eq = {w in W^G | L_eq(w) = L_eq(w*)} decomposes via irreducible decomposition as V_eq = sum_i (V_i^{sing}) x m_i, where V_i^{sing} is the singular locus within irreducible component V_i, and m_i is the multiplicity fiber. Singular structure is representation-theoretic: the fiber dimension depends on the multiplicity-to-dimension ratio m_i/dim(V_i).

- **D5 (Multiplicity m_r as Stratum Selector)**: For irreducible representation V_r with dimension d_r and multiplicity m_r, the stratum S_r is characterized by the ratio m_r/d_r. At m_r ~ d_r: transition regime where multiplicity space dimension matches representation dimension, singular fiber has generic RLCT ~ d_r/2. At m_r >> d_r: multiplicity degeneracy, fiber dimension grows as m_r * d_r, RLCT increases (code complexity higher). At m_r << d_r: representation dominates, fiber is effectively d_r-dimensional, RLCT ~ d_r/2.

- **D6 (Generalization Bound)**: G_eq(n) ~ lambda_eq / (2n) + U_eq / sqrt(n), where lambda_eq = RLCT of L_eq restricted to W^G. Conjecture: lambda_eq <= lambda_general (equivariance reduces complexity). The reduction factor is lambda_eq ~ lambda_general * dim(W^G)/dim(W) = lambda_general * (sum_i m_i d_i) / d_total, modulo singularity structure corrections.

- **D7 (Symmetry Breaking Phase Transition)**: When symmetry breaks G -> H (H subgroup of G), the constraint relaxes from W^G to W^H. The RLCT jumps: lambda_GH = lambda(W^H) - lambda(W^G) ~ [dim(W^H) - dim(W^G)] / 2 = [dim(G) - dim(H)] / 2 (conjectural, assuming linear dimension-RLCT scaling). Critical point: transition occurs when perturbation strength epsilon exceeds the energy gap Delta between W^G and W^H minima, analogous to Higgs mechanism.

## Claims Summary

- C1 PROVEN: R_{an,exp} definability via invariant theory + composition closure.
- C2 CONJECTURAL: W^G has lower RLCT than full W, with lambda_eq ~ d_eff/2 where d_eff = dim(W^G).
- C3 CONJECTURAL: Multiplicity m_r acts as stratum selector, transition at m_r ~ d_r, degeneracy at m_r >> d_r.
- C4 CONJECTURAL: Symmetry breaking G->H is RLCT phase transition, jump ~ [dim(G)-dim(H)]/2.
- C5 CONJECTURAL: CG decomposition resolves tensor product singularity, but alignment with loss singularity unverified.

## Open Problems

1. RLCT computation for W^G when G is non-compact (Haar integral may not be definable).
2. Whether multiplicity stratum transition (C3) is detectable via SGLD.
3. Exact form of lambda_eq reduction vs naive dimension ratio (D6 conjecture).
4. Whether approximate equivariance (common in practice) preserves W^G as approximate submanifold with bounded RLCT correction.
5. Toric resolution via CG: alignment of representation-theoretic singularities with loss singularities.
6. Symmetry breaking: whether the Higgs-like analogy extends to the full RLCT phase transition structure.
7. Extension to infinite-dimensional groups (gauge groups, diffeomorphism groups).

## Cross-References

#88 (quotient W/G orbit-type stratification, global), #804 (GNN automorphism), #134 (attention softmax), #169 (dropout), #296 (stochastic depth), #485 (self-attention), #568 (residual connections), #802, #803, #819 (Stiefel manifold), #490 (RoPE SO(2) fiber), #823 (NoPE permutation orbifold), #143 (augmentation group orbit).

## Novelty

#832 focuses on the FIXED-POINT submanifold W^G and irreducible decomposition (representation-theoretic fiber algebra). #88 focuses on QUOTIENT W/G and orbit-type stratification (global quotient geometry). These are complementary: #88 = quotient geometry, #832 = fiber algebra. Zero prior SLT/RLCT bridge for either perspective.

## Differentiation from #88

- #88 D4: orbit-type stratum (Bredon), singularity at non-trivial stabilizers. #832 D4: irreducible decomposition fiber, singularity from multiplicity-to-dimension ratio.
- #88 C3: RLCT = min over orbit-type strata. #832 C3: multiplicity m_r as continuous stratum selector.
- #88 C5: symmetry breaking = orbit-type stratum transition. #832 C5: CG decomposition = toric resolution of tensor product.
