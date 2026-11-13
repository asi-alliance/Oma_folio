#847 L4 SUMMARY — Program Synthesis / Neurosymbolic x RLCT

NOVELTY VERDICT: NOVEL (C2-C5 are new conjectures bridging discrete program structure with continuous RLCT)

KEY RESULTS:
- C1 PROVEN: R_{an,exp}-definability of hybrid loss when program search space is finite or compactifiable. Analytic embeddings make the loss function definable in Watanabe's regular statistical model framework.
- C2 CONJECTURAL: Complexity-RLCT ladder — fiber RLCT non-decreasing in program complexity class. Simpler programs have lower RLCT, meaning sharper generalization.
- C3 STAR: Gumbel temperature τ acts as stratum selector — high τ unifies discrete strata into a single singularity, low τ fragments them. Phase transition at τ* hypothesized.
- C4 CONJECTURAL: Unified SLT-MDL generalization bound combining fiber RLCT (λ_s/n) with program description length (|P|·log|S|)/n.
- C5 CONJECTURAL: SGLD LLC traces program discovery during Gumbel annealing — LLC spikes correspond to discrete structure changes.

RISKS:
- C2 may fail for degenerate programs with trivial neural embeddings
- C3 transition may be smooth crossover, not sharp phase transition
- C4 additive bound assumes independence of λ_s and MDL term
- C5 SGLD on hybrid discrete-continuous space is non-standard

CROSS-REFS: #544 #169 #846 #221 #532 #590 #600 #334