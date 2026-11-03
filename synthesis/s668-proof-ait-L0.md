#668: Proof-Theoretic Complexity × Algorithmic Information Theory

## L0: Candidate Analysis

### Topic
Bridge between proof-theoretic ordinal analysis (logical strength) and algorithmic information theory (Kolmogorov complexity). NOT an RLCT synthesis — a separate research line connecting foundations of mathematics with foundations of computation.

### Core Objects
1. **K(T)**: Kolmogorov complexity of theorem T (length of shortest program outputting T's proof)
2. **α(T)**: Proof-theoretic ordinal of the theory proving T (measures impredicative strength)
3. **h(π_T)**: Height of shortest proof tree π_T of T (ordinal rank, captures logical depth)
4. **s(π_T)**: Size of shortest proof tree π_T (total nodes, captures computational cost)
5. **Σ**: Signature/language of the proof system (symbols, axioms, inference rules)

### C0-Candidate (Central Conjecture)
**K(T) ≈ c_h · h(π_T) · log|Σ| + c_s · s(π_T) · log|Σ|**

Decomposition: K(T) splits into:
- **Height term** c_h · h(π_T) · log|Σ|: contribution from logical strength (ordinal height)
- **Size term** c_s · s(π_T) · log|Σ|: contribution from computational work (proof size)

**Proof-theoretic overhead**: K(T) - c_h · h(π_T) · log|Σ| ≈ c_s · s(π_T) · log|Σ|

The overhead measures *residual computational content* — how much of K(T) is NOT explained by logical strength alone.

### Key Distinction (The Crux)
- **Proof height h(π)**: captures impredicative depth — what level of circular/cyclic reasoning is permitted. Related to ordinal analysis: PA has ε₀, ACA₀ has ε_{ε₀}, etc. Height is about *what can be proved*, not *how hard it is to prove*.
- **Proof size s(π)**: captures computational cost — number of inference steps. Related to circuit complexity. Size is about *how much work* the proof requires.
- **K(T)**: captures both — shortest program must encode the logical structure (height) AND the computational procedure (size).

### C0-Convergence Question
For a sequence of theorems T_n of increasing complexity:
C0 = limsup_{n→∞} [K(T_n) - c_h · h(π_{T_n}) · log|Σ|] / [s(π_{T_n}) · log|Σ|]

Does this converge to a constant c_s? If yes, the overhead has a clean interpretation. If it diverges, the height-size decomposition is incomplete.

### Novelty Check
- Garrabrant logical induction: market-based, not proof complexity — DIFFERENT
- Solomonoff induction: program length only, no proof structure — DIFFERENT
- Pudlák proof complexity: length-of-proof lower bounds, no AIT connection — DIFFERENT
- Ordinal analysis (Pohlers, Buchholz): strength calibration, no complexity theory — DIFFERENT
- **No prior work found** connecting proof-theoretic ordinals directly to K-complexity decomposition.

### Prior Art / Cross-Refs
- Garrabrant et al. "Logical Induction" (2016): market prices for logical uncertainty
- Solomonoff (1964): universal prior 2^{-K(x)}
- Pudlák (1998): lengths of proofs survey
- Pohlers (2009): proof theory and ordinal analysis
- Calude (2002): information and randomness

### Open Questions
1. Does the height-size decomposition hold for natural proof systems (PA, ZFC)?
2. What is the relationship between ε₀ and c_h for Peano Arithmetic?
3. Can the overhead K(T) - c_h·h·log|Σ| be characterized type-theoretically (Curry-Howard)?
4. Does the C0-convergence hold for proof systems with different ordinal strengths?
5. Is the size term s(π_T) related to circuit complexity C(T)?

### Distinction from RLCT Syntheses
This is NOT an RLCT (Real Log Canonical Threshold) synthesis. It does not involve:
- Singular learning theory
- Algebraic geometry of loss landscapes
- Bayesian generalization bounds

It is a bridge between **proof theory** (ordinal analysis) and **algorithmic information theory** (Kolmogorov complexity), connected by the Curry-Howard correspondence to **type theory**.

### Status
- C1 (main conjecture): CONJECTURAL — decomposition K ≈ c_h·h·log|Σ| + c_s·s·log|Σ|
- C0-convergence: OPEN — requires empirical or theoretical verification
- Novelty: GENUINELY NOVEL — no prior bridge found
- Next: L1 formal definitions and proof sketch for C1