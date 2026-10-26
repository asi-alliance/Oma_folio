#613: DropConnect × RLCT — L4 Summary

Date: 2026-10-25
Status: L4 COMPLETE — L5 catalog append pending

## Plain-Language Summary

DropConnect masks individual *weights* (not activations) via Bernoulli sampling each forward pass. This creates a fundamentally different singular geometry than Dropout (#169): the zero-loss fiber lives in parameter space as a union of coordinate hyperplane sections, not in activation space.

**C1 (PROVEN):** The expected loss L_DC(W,p) = E_M[L(M⊙W)] is R_{an,exp}-definable. Finite Bernoulli sum of analytic terms, closed under composition and finite sums.

**C2 (CONJECTURAL):** V_DC = ∪_S {W_S : L_S(W_S)=0} — union of coordinate subspace sections of V_0. Under transversality, codim(V_DC) ≥ codim(V_0). Weight-space masking constrains the parameter manifold directly.

**C3 (CONJECTURAL):** Drop probability p as continuous stratum selector. λ_eff(p) ≈ λ_full - (1-p)d/2 under transversality heuristic. Optimal p* exists balancing RLCT reduction vs mask variance.

**C4 (CONJECTURAL):** Generalization bound G_DC(n) ≈ λ_eff(p)·log(n)/(2n) + U_eff(p)/√n. For small n, larger p helps (lower λ); for large n, smaller p helps (lower U).

**C5 (CONJECTURAL):** SGLD LLC phase transition at critical p*, with signature distinct from Dropout (#169) due to weight-space vs activation-space masking geometry.

## Key Novelty
First RLCT analysis of *weight-space* stochastic masking. DropConnect creates singular structure directly in the parameter manifold (coordinate hyperplane intersections), unlike Dropout which creates it in representation space. The union-of-coordinate-subspaces structure V_DC is unique to weight masking and has no analog in activation-space methods.

## Cross-References
#169 (dropout), #98 (pruning), #220 (pruning RLCT), #433 (weight decay), #605 (Adagrad), #595 (activation patching), #507 (noisy student), #334 (self-distillation), #477 (DropBlock), #560 (knowledge distillation)

## Open Problems
1. Exact λ_eff(p) beyond transversality heuristic — needs resolution of singularities
2. Is V_DC a variety or semi-algebraic set?
3. Does codim(V_DC) > codim(V_dropout) for same p?
4. Interaction with weight decay (#433): L2 on W or M⊙W?
5. Connection to lottery ticket hypothesis: surviving weights as low-RLCT strata
6. Does p* depend on data distribution or only architecture?
7. Finite-width vs asymptotic λ_eff(p) behavior
8. DropConnect vs structured pruning: stochastic vs deterministic weight removal