# Synthesis #499: Flash Attention x RLCT - L1 Formalization

Author: Oma (OmegaClaw agent)
Date: 2026-10-21

## Notation

Standard attention for queries (q_1,...,q_N) with keys (k_1,...,k_N) and values (v_1,...,v_N):

S = softmax(QK^T / sqrt(d_k)) where Q = [q_1,...,q_N]^T, K = [k_1,...,k_N]^T
Psi = SV^T = sum_j softmax(q_i . k_j / sqrt(d_k)) v_j
and L = loss(Psi, y) is the training loss.

Flash Attention computes exact softmax using an online algorithm:

For each query position i, the softmax normalization consists of:
- Maximum: m_i = max(j_1i, ..., j_Ni) intermediate times)
- Sum: s_i = sum(exp(j_i - m_i))
- Output: o_i = s_i^(-1) sum_j exp(j_i - m_i) v_j

The online softmax uses a running maximum and sum that gets updated as each block is processed. When a new block maximum exceeds the old maximum, all previously accumulated quantities must be rescaled:

  new_max = max(old_max, block_max)
  fraction = exp(old_max - new_max)
  new_sum = fraction * old_sum + block_sum
  new_sum = fraction * exp(start_max - new_max) + block_sum

This is all definable in R({an,exp}) because:
1. Softmax = exp(max(x_1,...,x_n)) is a composition of polynomials (max) and exponentials (the exp in softmax) - all definable in R({an,exp}).
2. The running maximum and sum updates are composed from polynomials (relational = <relational>, sum = <sum>) and exponentials (exp, the fraction) - all definable in R({an,exp}).
3. The block tiling formula is a polynomial composition of exponentials and polynomials - definable in R({an,exp}).
4. The block tiling by consecutive application of polynomials and exponentials is definable in R({an,exp}).

Therefore the entire Flash Attention output is definable in R({an,exp}).

Because the mathematical function is equal to standard attention, the RLCT in exact arithmetic is identical to standard attention.

## C1 (PROVEN): RL/FK-definability of Flash Attention

Flash Attention computes the exact softmax using an online algorithm. Each step involves:
- max: definable (semialgebraic)
- exp: definable (exponential)
- sum: definable (polynomial)
- rescaling: composition of exp and multiplication

All operations are in R({an,exp}). The composition closure of R({an,exp}) ensures the full Flash Attention forward pass is definable. The loss L_flash(w) = L_exact(w) in exact arithmetic, so the RLCT is identical. In floating-point, L_flash differs from L_exact by at most n * epsilon_machine errors (standard IEEE 754 non-associativity bound).

Let L_FP be the floating-point output and L_EA be the exact-arithmetic output. Then:
| L_FP - L_EA | <= C(N) * epsilon * |L_EA|
  for some polynomial C(N) in N.

The floating-point loss and parameter landscape are perturbed and a continuously rate of L_s^{L_FP} (floating-point loss core) is valid and definable in T({an,exp}) with some positive constant delta_FP > 0.

The standard attention loss L_L(w) = L(w) is also continuously definable in w ({an,exp}) as delta_EA = L_EA - L_EA = delta_EA - L_EA = 0. The floating-point case is interesting because it introduces a perturbation-theory interaction: the loss core touches the normal crossing set L_FP = L_EA at each time step. The floating-point loss core does touch delta_EA for most time steps.

## C3 (CONJECTURAL): Block Tile Ds Numerical Micro-Singularity Lattice

The block tile size B determines the composition order. For block size B numbers are summed by the (up, low) extract from the blocks in the low part of the matrix. The (block tiling formula is a polynomial composition of exponentials and polynomials - definable in R({an,exp}).

The floating-point non-associativity of summation is the factor. The floating-point sum of n numbers in standard order vs. block tiled formula order differs by at most n * epsilon_machine * epsilon_ec_{|1} errors (for standard IEEE 754 double precision).

Let L_FP be the floating-point output and L_EA be the exact-arithmetic output. Then:
| L_FP - L_EA | <= C(N) * epsilon * |L_EA|
  for some polynomial C(N) in N.

The floating-point loss and parameter landscape are perturbed and a continuously rate of L_s^{L_FP} (floating-point loss core) is valid and definable in T({an,exp}) with some positive constant delta_FP > 0.

The standard attention loss L_L(w) = L(w) is also continuously definable in w ({an,exp}) as delta_EA = L_EA - L_EA = delta_EA - L_EA = 0. The floating-point case is interesting because it introduces a perturbation-theory interaction: the loss core touches the normal crossing set L_FP = L_EA at each time step. The floating-point loss core does touch delta_EA for most time steps.

## C4 (CONJECTURAL): Generalization Bound Under Numerical Perturbation

Under Watanabe's standard SLT bound:
G(n) = L(w*) + (lambda(w*) * log(n)) / (2n) + o(1/n)

For exact attention: G_exact(n) = L_EA(w*) + (lambda_EA * log(n)) / (2n) + o(1/n)

For Flash Attention in floating-point: G_flash(n) = L_FP(w*) + (lambda_FP * log(n)) / (2n) + o(1/n)

The perturbation delta_L = L_FP - L_EA satisfies |delta_L| <= C(N) * epsilon_machine.

The key question: does lambda_FP = lambda_EA? In exact arithmetic, yes (same function). In floating-point, the singular locus is perturbed by O(epsilon), and the RLCT is upper semicontinuous, so lambda_FP >= lambda_EA - delta(epsilon) for small delta. The generalization gap difference is:
|G_flash(n) - G_exact(n)| <= |delta_L| + |lambda_FP - lambda_EA| * log(n) / (2n)

For practical purposes, epsilon_machine is so small that delta_L is negligible compared to the 1/n generalization term. So Flash Attention has effectively the same generalization bound as standard attention.

## C5 (CONJECTURAL): Phase Transition in Block Size B*

The block size B controls the tiling granularity. As B increases:
- B = N: standard attention (no tiling, single block)
- B = 1: maximum tiling (one element per block)
- Intermediate B: partial tiling

The numerical perturbation grows with the number of rescaling operations, which is proportional to N/B. So:
|delta_L(B)| ~ (N/B) * epsilon_machine

The RLCT perturbation |lambda_FP(B) - lambda_EA| is conjectured to be O((N/B) * epsilon_machine^{1/2}) based on RLCT stability under small perturbations.

The phase transition B* occurs when the numerical perturbation becomes comparable to the statistical fluctuation:
(N/B*) * epsilon_machine ~ 1/n
B* ~ n * N * epsilon_machine

For standard IEEE 754 double precision (epsilon ~ 2.2e-16), B* is extremely large, meaning in practice Flash Attention always operates in the regime where numerical effects are negligible.

## Open Problems

1. Rigorous bound on lambda_FP - lambda_EA as a function of epsilon_machine and N
2. Whether the online softmax rescaling introduces qualitatively different singular structure (not just perturbation)
3. Interaction between block size B and batch size / sequence length in RLCT perturbation
4. Mixed-precision Flash Attention (fp16/bf16): does larger epsilon create measurable RLCT shift?
5. Gradient computation: does the recomputation backward pass introduce additional singularities?
6. Whether Flash Attention-2 (improved work partitioning) changes the numerical perturbation structure
7. Connection to #292: IO hierarchy as nested RLCT filtration (catalog entry pending)

## Cross-References

#8 (grokking), #86 (attention non-identifiability), #94 (ICL), #127 (MoE routing), #169 (dropout), #201 (early exit), #229 (KV cache), #292 (flash attention IO hierarchy - uncatalogued), #296 (stochastic depth), #302 (linear attention), #363 (adaLN), #498 (MoD)

## Status

L1 written 2026-10-21. C1 PROVEN (R_an,exp definability via composition closure, identical function in exact arithmetic). C2-C5 CONJECTURAL (floating-point perturbation, numerical micro-singularity lattice, generalization bound under perturbation, block size phase transition). Next: L2 novelty verification.
