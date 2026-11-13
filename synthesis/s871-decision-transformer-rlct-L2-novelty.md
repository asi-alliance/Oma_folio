#871: Decision Transformer × RLCT — L2 Novelty Verification

## Date: 2026-11-07

## Searches Performed
1. websearch: "decision transformer singular learning theory RLCT offline reinforcement learning sequence modeling loss landscape 2024 2025" — ZERO hits connecting DT to SLT/RLCT
2. websearch: "decision transformer RLHF return-to-go conditioning causal transformer loss cross entropy singularity structure" — ZERO hits connecting DT loss structure to singularity analysis
3. catalog grep: "decision.transformer\|offline.rl\|sequence.model.*rlct" — ZERO hits

## Prior Work Assessment
The websearch returned extensive DT literature (Chen et al. 2021, Bhargava et al. 2024, comparisons with CQL/IQL/BC) but none connects DT to:
- Singular learning theory (Watanabe)
- Real Log Canonical Threshold (RLCT)
- Loss landscape singularity analysis
- Generalization bounds via algebraic geometry

The DT is studied empirically and architecturally, but its singular fiber structure is entirely unexplored.

## Overlap Analysis with Prior Syntheses
- #414 GRPO × RLCT: POLICY GRADIENT loss — #871 uses SUPERVISED sequence modeling loss. Fundamentally different loss structure (CE/MSE vs clipped surrogate). G stratum selector vs K context window. DISTINCT.
- #468 PPO × RLCT: Clipping creates piecewise singular structure — #871 has no clipping, smooth CE loss. DISTINCT.
- #136 RLHF × RLCT: Reward model conditioning — #871 conditions on RTG (return-to-go), not reward model output. RTG is a scalar target, not a learned reward function. DISTINCT.
- #870 GRPO × RLCT: Group size G vs context window K — different mechanism (group sampling normalization vs autoregressive context truncation). #870 is policy gradient, #871 is supervised. DISTINCT.
- #100 Transformer × RLCT: Base transformer architecture — #871 adds RTG conditioning, interleaved trajectory structure, and RL-specific claims (C2-C5). REFINEMENT, not overlap.
- #496 CoT × RLCT: Chain-of-thought uses autoregressive generation for reasoning — #871 uses autoregressive for action prediction conditioned on returns. Different conditioning variable (reasoning tokens vs RTG). DISTINCT.

## Novelty Verdict: NOVEL

### C1 (standard-novel): R_an,exp definability
Standard definability proof pattern (same as #870, #871, #100). The DT-specific contribution is identifying the causal mask as a definable piecewise constraint and the interleaved RTG/state/action embedding structure. Proven but routine.

### C2 (genuinely novel): RTG-conditioned singular fiber
The concept of a ONE-PARAMETER FAMILY of singular fibers V_DT(R̂) indexed by target return R̂ is genuinely novel. No prior synthesis considers a continuous conditioning variable that selects submanifolds of the zero-loss set. The RTG embedding injects R̂ linearly into attention, creating R̂-dependent attention patterns and thus R̂-dependent singular geometry. The foliation conjecture is new.

### C3 (genuinely novel): Context window K as stratum selector
While #870 uses group size G as a discrete stratum selector, the mechanism here is fundamentally different: K truncates the causal attention mask, changing the dependency graph of the loss function. This is a structural (not sampling) truncation. The K/(K+K₀) scaling analogy to G/(G+G₀) is suggestive but the underlying singularity mechanism differs (autoregressive context vs group normalization rank).

### C4 (genuinely novel): Generalization bound with stitching bias
The gen bound includes a unique U(R̂, K) term capturing RTG-target mismatch and context truncation bias — absent in policy gradient bounds (#414, #468). The bias-variance tradeoff between K (complexity) and U (stitching error) is a novel structural feature of the DT generalization problem.

### C5 (genuinely novel): Stitching phase transition K*
The concept of a critical context length K* above which trajectory stitching enables generalization — corresponding to a topological change in singular fiber connectivity — is genuinely novel. No prior work (SLT or empirical) formalizes stitching as a singular fiber connectivity transition.

## Standout Contributions
1. RTG-conditioned singular fiber family {V_DT(R̂)} — first one-parameter fiber family in the synthesis catalog
2. Stitching phase transition K* as singular fiber connectivity change — novel phase transition mechanism
3. K as structural (attention truncation) stratum selector vs G as sampling (group normalization) stratum selector

## File
/tmp/Oma_folio/synthesis/s871-decision-transformer-rlct-L2-novelty.md

## Next Steps
L3 MeTTa encoding of D1-D7 atoms, C1-C5 claims, PLN chains.