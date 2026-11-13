# Synthesis #885: ICA x RLCT - L2 Novelty Verification

Date: 2026-11-09

## Websearch Results

Search 1: "singular learning theory ICA independent component analysis identifiability singularity quotient permutation scaling RLCT 2024 2025"
- ZERO hits bridging SLT/RLCT to ICA. Results about non-identifiability in Stan models, Murfet SLT work, unrelated topics.

Search 2: "ICA blind source separation singularity algebraic geometry non-identifiability quotient fiber statistical learning theory"
- ZERO SLT/ICA bridge. Results about ICA non-identifiability in classical signal processing, no singular learning theory connection.

Search 3: "Darmois Skitovich theorem singular learning theory Gaussian identifiability phase transition neural network"
- ZERO hits connecting Darmois-Skitovich to singular learning theory. The theorem appears only in classical ICA/Blind Source Separation literature.

Search 4: "ICA non-identifiability permutation scaling RLCT generalization bound algebraic singularity deep learning 2024 2025 2026"
- ZERO hits. No prior work bridging ICA non-identifiability quotient to RLCT or generalization bounds.

## Overlap Analysis with Prior Syntheses

### #86 (Attention Head Permutation S_H)
- Overlap: Both have discrete permutation non-identifiability fibers.
- Distinction: #86 has S_H (pure discrete, no scaling). ICA has S_n x (R*)^n (discrete + continuous scaling). ICA also has the Gaussian threshold stratum selector absent in #86.

### #91 (Sparse Dictionary K! x 2^K x R^K)
- Overlap: Both have permutation + scaling non-identifiability.
- Distinction: #91 includes Z_2^K sign component (from L1 sparsity allowing sign flips). ICA absorbs sign into D (d_k can be negative), so no separate Z_2 component. #91 has sparsity constraint creating additional semi-algebraic strata. ICA has no sparsity constraint. #91 lacks the Gaussian threshold phase transition.

### #240 / #467 / #670 (Weight Tying Quotient)
- Overlap: Both involve quotient singularities from parameter identification.
- Distinction: Weight tying creates quotient by IDENTIFYING parameters (reducing fiber). ICA quotient arises from SOURCE SEPARATION non-identifiability (intrinsic fiber, not engineered). Different mechanism, different geometry.

### #884 (CoT Inference-Time Phase Transition)
- Overlap: Both are inference-time / data-distribution phase transitions with RLCT jumps.
- Distinction: #884 driven by MODEL SCALE (CoT chain length). ICA driven by SOURCE DISTRIBUTION (Gaussianity). Different stratum selector, different mechanism.

### #88 (Tensor Decomposition)
- Overlap: Both involve matrix/tensor non-identifiability quotient.
- Distinction: #88 has CP rank non-identifiability (continuous tensor rank). ICA has fixed-rank mixing matrix with permutation+scaling quotient. Different algebraic structure.

## Novelty Verdict

NOVEL. The ICA x RLCT bridge is genuinely unexplored:
1. No prior work connecting ICA non-identifiability to RLCT (4 websearches, zero hits).
2. The Darmois-Skitovich Gaussian threshold as RLCT phase transition is a novel contribution — no prior work treats source Gaussianity as a singularity stratum selector.
3. The quotient fiber S_n x (R*)^n is distinct from all prior syntheses: richer than #86 (adds scaling), different from #91 (no sparsity/sign), different mechanism from #240 (intrinsic vs engineered), different selector from #884 (data vs model).
4. The generalization bound with non-identifiability bias U = n + n_g(n_g-1)/2 is novel.

## Confidence: HIGH
- C1 (definability) is straightforward and proven.
- C2-C5 are conjectural but well-motivated by ICA theory and SLT.
- The key risk is whether O(n_g) rotation fiber contributes to RLCT as claimed (C3/C5) — this needs SGLD verification.

## Status
L2 written 2026-11-09. Verdict: NOVEL. Next: L3 MeTTa formalization.