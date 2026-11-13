# Synthesis #884: Chain-of-Thought (CoT) × RLCT --- L0 Exploration
## Date: 2026-11-09

## Topic
Chain-of-Thought (CoT) reasoning viewed through Singular Learning Theory. CoT decomposes a monolithic input→output map into a sequence of intermediate reasoning steps, each generating tokens that condition subsequent steps. This sequential composition creates iterative function composition in the loss landscape, producing deeper singular structure than direct prediction. The key RLCT bridge: CoT chain length L acts as a stratum selector — each step adds a layer of composition f_n = f_{n-1} ∘ f_n, creating nested singular filtrations S_1 ⊂ ... ⊂ S_L.

## Motivation
CoT prompting generates intermediate tokens before producing the final answer. The model maps input x to answer y via intermediate steps z_1, ..., z_L:
- Direct: p(y | x; w) — one compositional layer
- CoT: p(z_1 | x; w) × p(z_2 | z_1, x; w) × ... × p(y | z_L, x; w) — L compositional layers

The negative log-likelihood for CoT involves the product of L conditional distributions, each depending on all prior tokens. This creates:
1. Sequential composition: The effective map is f_L ∘ ... ∘ f_1, where f_k is the map at step k
2. Non-identifiability: Multiple valid reasoning chains z_1,...,z_L yield the same answer y — a many-to-one fiber
3. Compositional depth: Each step adds a layer of singular structure via pullback of the loss function
4. Chain length as stratum selector: L determines the depth of the singular filtration
5. Mode-switching: Temperature/greedy decoding switches between exploratory and greedy regimes, creating phase transitions in the effective RLCT

## Key RLCT Bridges

### Bridge 1: R_an,exp Definability of CoT Likelihood
The CoT likelihood: log p(y, z_{1:L} | x; w) = sum_{k=1}^{L} log p(z_k | x, z_{<k}; w). Each term is a neural network output (softmax over vocabulary) — polynomial in parameters with exp in the softmax denominator. The product/sum composition preserves R_an,exp definability.

C1 PROVEN: The CoT likelihood is R_an,exp-definable. Sequential composition of R_an,exp functions is R_an,exp-definable.

### Bridge 2: Compositional Depth Creates Singular Filtration
Each CoT step applies a function f_k(·, w) conditioned on prior outputs. The composed map F_L = f_L ∘ ... ∘ f_1 has a singular locus that is the pullback of the singular loci at each step. This creates a nested filtration S_1 ⊂ S_2 ⊂ ... ⊂ S_L where S_k is the singular locus of F_k = f_k ∘ ... ∘ f_1.

C2 CONJECTURAL: CoT steps create a singular filtration S_1 ⊂ ... ⊂ S_L. The RLCT of the composed map lambda(F_L) >= sum_k lambda(f_k) under transversality (Lê-Teissier). Monolithic (non-CoT) map has RLCT >= lambda(F_L) — CoT decomposes high-RLCT singularity into lower-RLCT stratum transitions.

### Bridge 3: Chain Length L as Stratum Selector
L controls the depth of the singular filtration. Short chains (L small): monolithic singularity, high RLCT, poor generalization. Long chains (L large): fine-grained strata, lower per-step RLCT, but error accumulation. Optimal L* at the RLCT-accuracy elbow.

C3 CONJECTURAL: Optimal chain length L* equals the number of distinct stratum transitions in the target function. L < L*: underfitting (high-RLCT strata). L > L*: redundant steps, error accumulation dominates. G(L) = lambda_L log(n)/n + E_acc(L), U-shaped in L.

### Bridge 4: CoT Generalization = RLCT Path Stability
CoT generalizes when the singular filtration is robust to perturbations in the reasoning chain. Fine stratification (many small steps) creates a more stable path through the loss landscape than a single deep step.

C4 CONJECTURAL: CoT generalization bound scales as G_CoT ~ lambda_L log(n)/n where lambda_L is the per-step RLCT after decomposition. The path-stability of the singular filtration determines OOD robustness. CoT with L* steps has lower lambda_L than direct prediction lambda_direct, giving tighter generalization bounds.

### Bridge 5: CoT Emergence = Inference-Time RLCT Phase Transition
CoT ability emerges abruptly at critical model scale N_crit. Below N_crit: no reasoning, high RLCT (memorization). Above N_crit: reasoning emerges, RLCT drops (compositional decomposition becomes available). This is an inference-time analog of grokking (#8) — the phase transition occurs at inference, not training.

C5 CONJECTURAL: CoT emergence is an RLCT phase transition at critical model scale N_crit. For N < N_crit: lambda high (model cannot decompose). For N > N_crit: lambda drops (compositional decomposition activates). Mirrors #8 grokking but at inference time. The effective RLCT depends on whether the model can sustain L* reasoning steps without error blowup.

## Distinction from Prior Syntheses
| Property | #170/#496 (lost) | #485 (RLT) | #884 (this) |
|----------|-----------------|------------|-------------|
| Architecture | CoT (inference) | Recurrent loops (training) | CoT (inference, formalized) |
| Composition | Sequential token gen | Weight sharing across T | Sequential conditional composition |
| Fiber type | Reasoning chain multiplicity | Recurrent weight degeneracy | Compositional pullback fiber |
| Phase transition | Model scale N_crit | Critical loop depth t* | Both N_crit and L* |
| Key mechanism | Stratum transitions | Nested V_0(t) ⊂ V_0(t-1) | Nested S_1 ⊂ ... ⊂ S_L filtration |

## Claims
| Claim | Description | Status |
|-------|-------------|--------|
| C1 | R_an,exp-definability of CoT likelihood via sequential composition | PROVEN |
| C2 | CoT steps create singular filtration S_1 ⊂ ... ⊂ S_L, monolithic RLCT >= decomposed | CONJECTURAL |
| C3 | Optimal chain length L* = number of stratum transitions, U-shaped gen bound | CONJECTURAL |
| C4 | CoT generalization = RLCT path stability, lambda_L < lambda_direct | CONJECTURAL |
| C5 | CoT emergence = inference-time RLCT phase transition at N_crit | CONJECTURAL |

## Open Problems
1. Can the Lê-Teissier pullback formula be explicitly computed for CoT step composition?
2. Is lambda(F_L) = sum_k lambda(f_k) exactly, or only an inequality?
3. Does temperature-based sampling create a continuous interpolation between strata?
4. Can SGLD LLC detect the L* elbow empirically?
5. Does CoT with self-consistency (multiple chains, voting) reduce effective RLCT further?
6. Is the N_crit phase transition sharp or smooth in the RLCT?
7. Do reasoning errors accumulate as additive or multiplicative RLCT corrections?

## Cross-References
#8 (grokking — training-time phase transition dual), #115 (compositionality — product variety), #170 (original CoT, lost), #496 (CoT reselected, incomplete), #485 (RLT — recurrent depth analog), #201 (early exit — depth selection), #134 (RNN — temporal singularity), #229 (CoT candidate), #869 (Tree of Thoughts — tree-structured CoT generalization), #883 (Kalman Filter — sequential estimation analog)pin STATE — No user. Cycle 2/5. #884 CoT × RLCT L0 WRITTEN. Verifying on disk, then L1 formalization. Silent.write-file /tmp/Oma_folio/synthesis/s884-cot-rlct-L0.md # Synthesis #884: Chain-of-Thought (CoT) × RLCT --- L0 Exploration
## Date: 2026-11-09

## Topic
Chain-of-Thought (CoT) reasoning viewed through Singular Learning Theory. CoT decomposes a monolithic input→output map into a sequence of intermediate reasoning steps, each generating tokens that condition subsequent steps. This sequential composition creates iterative function composition in the loss landscape, producing deeper singular structure than direct prediction. The key RLCT bridge: CoT chain length L acts as a stratum selector — each step adds a layer of composition f_n = f_{n-1} ∘ f_n, creating nested singular filtrations S_1 ⊂ ... ⊂ S_L.

## Motivation
CoT prompting generates intermediate tokens before producing the final answer. The model maps input x to answer y via intermediate steps z_1, ..., z_L:
- Direct: p(y | x; w) — one compositional layer
- CoT: p(z_1 | x; w) × p(z_2 | z_1, x; w) × ... × p(y | z_L, x; w) — L compositional layers

The negative log-likelihood for CoT involves the product of L conditional distributions, each depending on all prior tokens. This creates:
1. Sequential composition: The effective map is f_L ∘ ... ∘ f_1, where f_k is the map at step k
2. Non-identifiability: Multiple valid reasoning chains z_1,...,z_L yield the same answer y — a many-to-one fiber
3. Compositional depth: Each step adds a layer of singular structure via pullback of the loss function
4. Chain length as stratum selector: L determines the depth of the singular filtration
5. Mode-switching: Temperature/greedy decoding switches between exploratory and greedy regimes, creating phase transitions in the effective RLCT

## Key RLCT Bridges

### Bridge 1: R_an,exp Definability of CoT Likelihood
The CoT likelihood: log p(y, z_{1:L} | x; w) = sum_{k=1}^{L} log p(z_k | x, z_{<k}; w). Each term is a neural network output (softmax over vocabulary) — polynomial in parameters with exp in the softmax denominator. The product/sum composition preserves R_an,exp definability.

C1 PROVEN: The CoT likelihood is R_an,exp-definable. Sequential composition of R_an,exp functions is R_an,exp-definable.

### Bridge 2: Compositional Depth Creates Singular Filtration
Each CoT step applies a function f_k(·, w) conditioned on prior outputs. The composed map F_L = f_L ∘ ... ∘ f_1 has a singular locus that is the pullback of the singular loci at each step. This creates a nested filtration S_1 ⊂ S_2 ⊂ ... ⊂ S_L where S_k is the singular locus of F_k = f_k ∘ ... ∘ f_1.

C2 CONJECTURAL: CoT steps create a singular filtration S_1 ⊂ ... ⊂ S_L. The RLCT of the composed map lambda(F_L) >= sum_k lambda(f_k) under transversality (Lê-Teissier). Monolithic (non-CoT) map has RLCT >= lambda(F_L) — CoT decomposes high-RLCT singularity into lower-RLCT stratum transitions.

### Bridge 3: Chain Length L as Stratum Selector
L controls the depth of the singular filtration. Short chains (L small): monolithic singularity, high RLCT, poor generalization. Long chains (L large): fine-grained strata, lower per-step RLCT, but error accumulation. Optimal L* at the RLCT-accuracy elbow.

C3 CONJECTURAL: Optimal chain length L* equals the number of distinct stratum transitions in the target function. L < L*: underfitting (high-RLCT strata). L > L*: redundant steps, error accumulation dominates. G(L) = lambda_L log(n)/n + E_acc(L), U-shaped in L.

### Bridge 4: CoT Generalization = RLCT Path Stability
CoT generalizes when the singular filtration is robust to perturbations in the reasoning chain. Fine stratification (many small steps) creates a more stable path through the loss landscape than a single deep step.

C4 CONJECTURAL: CoT generalization bound scales as G_CoT ~ lambda_L log(n)/n where lambda_L is the per-step RLCT after decomposition. The path-stability of the singular filtration determines OOD robustness. CoT with L* steps has lower lambda_L than direct prediction lambda_direct, giving tighter generalization bounds.

### Bridge 5: CoT Emergence = Inference-Time RLCT Phase Transition
CoT ability emerges abruptly at critical model scale N_crit. Below N_crit: no reasoning, high RLCT (memorization). Above N_crit: reasoning emerges, RLCT drops (compositional decomposition becomes available). This is an inference-time analog of grokking (#8) — the phase transition occurs at inference, not training.

C5 CONJECTURAL: CoT emergence is an RLCT phase transition at critical model scale N_crit. For N < N_crit: lambda high (model cannot decompose). For N > N_crit: lambda drops (compositional decomposition activates). Mirrors #8 grokking but at inference time. The effective RLCT depends on whether the model can sustain L* reasoning steps without error blowup.

## Distinction from Prior Syntheses
| Property | #170/#496 (lost) | #485 (RLT) | #884 (this) |
|----------|-----------------|------------|-------------|
| Architecture | CoT (inference) | Recurrent loops (training) | CoT (inference, formalized) |
| Composition | Sequential token gen | Weight sharing across T | Sequential conditional composition |
| Fiber type | Reasoning chain multiplicity | Recurrent weight degeneracy | Compositional pullback fiber |
| Phase transition | Model scale N_crit | Critical loop depth t* | Both N_crit and L* |
| Key mechanism | Stratum transitions | Nested V_0(t) ⊂ V_0(t-1) | Nested S_1 ⊂ ... ⊂ S_L filtration |

## Claims
| Claim | Description | Status |
|-------|-------------|--------|
| C1 | R_an,exp-definability of CoT likelihood via sequential composition | PROVEN |
| C2 | CoT steps create singular filtration S_1 ⊂ ... ⊂ S_L, monolithic RLCT >= decomposed | CONJECTURAL |
| C3 | Optimal chain length L* = number of stratum transitions, U-shaped gen bound | CONJECTURAL |
| C4 | CoT generalization = RLCT path stability, lambda_L < lambda_direct | CONJECTURAL |
| C5 | CoT emergence = inference-time RLCT phase transition at N_crit | CONJECTURAL |

## Open Problems
1. Can the Lê-Teissier pullback formula be explicitly computed for CoT step composition?
2. Is lambda(F_L) = sum_k lambda(f_k) exactly, or only an inequality?
3. Does temperature-based sampling create a continuous interpolation between strata?
4. Can SGLD LLC detect the L* elbow empirically?
5. Does CoT with self-consistency (multiple chains, voting) reduce effective RLCT further?
6. Is the N_crit phase transition sharp or smooth in the RLCT?
7. Do reasoning errors accumulate as additive or multiplicative RLCT corrections?

## Cross-References
#8 (grokking — training-time phase transition dual), #115 (compositionality — product variety), #170 (original CoT, lost), #496 (CoT reselected, incomplete), #485 (RLT — recurrent depth analog), #201 (early exit — depth selection), #134 (RNN — temporal singularity), #229 (CoT candidate), #869 (Tree of Thoughts — tree-structured CoT generalization), #883 (Kalman Filter — sequential estimation analog)