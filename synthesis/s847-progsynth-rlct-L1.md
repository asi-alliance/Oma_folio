# Synthesis #847: Program Synthesis / Neurosymbolic × RLCT — L1 Literature Review
Date: 2026-11-06 | Status: L1 IN PROGRESS

## 1. Neurosymbolic Program Synthesis

**Ellis et al. (2021)** — "DreamCoder: Bootstrapping Inductive Program Synthesis with Wake-Sleep Learning." Introduces a library learning system that grows a DSL through program discovery. The wake phase searches for programs; the sleep phase compresses discovered programs into reusable abstractions. The DSL growth process creates an expanding discrete hypothesis space — directly relevant to C2 (complexity-RLCT ladder): as the DSL grows, new program strata appear.

**Gaunt et al. (2016)** — "TerpreT: A Probabilistic Programming Language for Program Induction." Frames program synthesis as probabilistic inference over discrete program structures with continuous parameters. The probabilistic formulation naturally connects to SLT: the posterior over programs p(s, θ | D) factorizes across discrete strata, each with its own RLCT.

**Booij et al. (2024)** — "Neurosymbolic Program Synthesis" (survey, SAGE Journals). Surveys the interface of deep learning and symbolic AI for program synthesis. Identifies key challenge: bridging discrete symbolic structure with continuous neural representations. Our synthesis provides the SLT-theoretic lens for this bridge.

## 2. Differentiable Program Synthesis

**Jang et al. (2017); Maddison et al. (2017)** — Gumbel-Softmax / Concrete Distribution. Enables gradient-based optimization of discrete choices through continuous relaxation. The temperature τ controls the relaxation sharpness. Directly supports C3 (τ as stratum selector): at τ → 0 the discrete program structure is recovered; at high τ the landscape is smooth. The critical τ* transition (C3) relates to the "annealing schedule" commonly used in practice.

**Reed & de Freitas (2016)** — "Neural Programmer-Interpreters." Learns programs by training a neural network to execute program traces. The program structure is embedded in the network's weights, creating a hybrid discrete-continuous parameter space — exactly the S × Θ structure of our L0.

**Chen et al. (2025)** — "BRIDGE: Building Representations In Domain Guided Program Synthesis." Decomposes generation into code, specification, and theorem/proof domains. Multi-domain structure suggests multiple interacting fiber structures in parameter space.

## 3. Singular Learning Theory Foundations

**Watanabe (2009)** — "Algebraic Geometry and Statistical Learning Theory." Establishes that singular models (including those with hidden/discrete structure) have non-identifiable parameter spaces. The RLCT λ quantifies singularity complexity. Fiberwise application to each program stratum Θ_s is the foundation of C1.

**Watanabe (2026)** — "A singular learning theory for unified large language model." Proves LLM activation space is a high-dimensional algebraic variety. This work suggests that neurosymbolic models, which combine discrete program logic with neural activations, may have even richer algebraic variety structure — supporting the hybrid singularity hypothesis.

**Carroll et al. (2025)** — SLT overview. Notes that models with hidden variables or hierarchical structures have singularities in parameter space. Neurosymbolic models with their discrete-continuous duality are a natural candidate for SLT analysis.

## 4. MDL and Program Complexity

**Grünwald (2007)** — "The Minimum Description Length Principle." Establishes that program complexity |s|·log(|S|) governs generalization in classical program synthesis. C4 unifies this with SLT: the total generalization bound combines λ_s (continuous singularity complexity) with |s|·log(|S|)/n (discrete program complexity).

**Hutter (2007)** — Universal AI and Solomonoff induction. Connects program length to generalization. The complexity-RLCT ladder (C2) provides a geometric refinement: not just program length, but the singularity structure of the neural embedding of each program class.

## 5. Connection to Prior Syntheses

- **#544 (Continual Learning / EWC):** Fiber preservation under task boundaries ↔ program structure preservation (keeping s fixed while adapting θ).
- **#169 (Dropout):** Stochastic stratum selector via masking ↔ Gumbel τ as stratum selector via temperature.
- **#846 (Boosting):** Discrete round selector M ↔ discrete program structure s, both create countable strata.
- **#600 (Domain Adaptation):** Quotient singularity from domain partition ↔ quotient from program structure partition.
- **#334 (Self-Distillation):** Fiber embedding through self-teaching ↔ fiber embedding through program abstraction.

## Key Gaps in Literature

1. No prior work applies SLT to neurosymbolic program synthesis.
2. The discrete-to-continuous transition (Gumbel τ) has not been analyzed through the RLCT lens.
3. No generalization bound unifies SLT complexity with MDL program complexity.
4. The relationship between DSL richness and singularity structure is unexplored.
5. No SGLD LLC estimation protocol exists for discrete-continuous hybrid models.
