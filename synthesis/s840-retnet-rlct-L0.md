# Synthesis #840: Retentive Network (RetNet) × RLCT — L0 Claims Outline
# Date: 2026-11-03
# Pipeline: L0 ← | L1 pending | L2 pending | L3 pending | L4 pending | L5 pending

## Topic
Retentive Networks (RetNet) — Microsoft 2023. Retention mechanism unifying
recurrence and attention via a retention operator with three computation modes:
parallel (full attention), recurrent (RNN-like), chunkwise (hybrid).

## Key Structural Features for SLT/RLCT
1. Retention operator: S_n = gamma * S_{n-1} + V_n K_n^T (decay-based state accumulation)
2. gamma decay matrix: diag(gamma_1, ..., gamma_d) — exponential temporal decay
3. Output: O_n = Q_n S_n — query against accumulated state
2. Three computation modes share identical math but different singularity structure:
   - Parallel: full N×N attention matrix (O(N^2) singularities)
   - Recurrent: sequential state update (O(N) sequential singularity cascade)
   - Chunkwise: block decomposition (intermediate singularity structure)
5. gamma decay parameter controls effective receptive field — acts as stratum selector
   analogous to tau in #839 Gumbel-Softmax

## Candidate Claims
C1: RetNet loss L(gamma, theta) is R-an-definable (polynomial ops + exp decay)
C2: RLCT lambda(gamma) varies with decay rate gamma — monotonicity conjecture
    gamma→0: pure recurrence (RNN-like, sequential singularity cascade)
    gamma→1: full attention (dense matrix, different singularity structure)
C3: Phase transition gamma* in RLCT as decay parameter crosses critical value
C4: Generalization bound G(n,gamma) ~ lambda(gamma)*log(n)/(2n) + b(gamma)
C5: Optimal gamma schedule as annealing curriculum (temporal stratum selector)

## Cross-Reference Candidates
#839 (Gumbel-Softmax temperature as stratum selector — analogous gamma role)
#16 (depth singularity), #100 (stratum selector), #151 (Mamba/S4 if covered),
#234 (temperature scaling), #377 (temperature dial), #647 (noise injection)

## Open Questions
- Is retention operator definable in o-minimal structure? (exp decay — yes if bounded domain)
- How do three computation modes affect singularity structure?
- Does gamma decay create new singularity class vs existing attention RLCT results?
- Chunkwise recurrence singularity decomposition

## Novelty Check
L2 pending — websearch for any existing RetNet + SLT/RLCT bridge.
