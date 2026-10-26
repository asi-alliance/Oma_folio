# Synthesis #653: Depthwise Separable Convolution × RLCT
## L4 — Plain-Language Summary

**Date:** 2026-10-26
**Status:** L4 Summary

### What is this about?

Depthwise separable convolutions (used in MobileNet, Xception) split a standard convolution into two steps: first a per-channel spatial filter (depthwise), then a 1×1 channel mixer (pointwise). This reduces parameters from O(C²K²) to O(CK² + C²). We analyze this through Singular Learning Theory (SLT), specifically the Real Log Canonical Threshold (RLCT) — a measure of how "singular" or degenerate the loss landscape is.

### The Five Claims (C1-C5)

**C1 (Proven):** The depthwise separable conv loss is mathematically well-defined in the framework SLT requires. Depthwise conv is polynomial, pointwise is linear, ReLU is piecewise-polynomial, softmax+cross-entropy uses exp/log — all definable in R_{an,exp}. Composition preserves this. So RLCT exists.

**C2 (Conjectural):** The depthwise step creates a block-diagonal Jacobian — each channel has its own independent K²×HW convolution Jacobian. The singular fiber (where the model degenerates) is a union of C independent determinantal varieties, one per channel. Under independence, the total RLCT is the max across channels, not the sum. This is structurally simpler than the dense conv's single large determinantal variety.

**C3 (Conjectural):** Group count g acts as a "stratum selector" — a knob interpolating between dense conv (g=1, all channels mixed) and depthwise (g=C, no mixing). More groups → simpler singular structure → lower RLCT. This is testable: sweep g from 1 to C and measure LLC via SGLD.

**C4 (Conjectural):** The factorization trades one O(C²K²)-dimensional singular locus for C independent O(K²)-dimensional loci plus one O(C²)-dimensional locus. By subadditivity of RLCT under independence, the factorized version has lower or equal RLCT at comparable accuracy. This means better generalization per parameter.

**C5 (Conjectural):** There's a critical group count g* where a phase transition occurs. Below g*, you get efficiency gains with accuracy maintained. Above g*, per-group information becomes insufficient for the pointwise stage to reconstruct — accuracy degrades. SGLD should show a step-like drop in LLC at g*.

### Key Novelty

This is the first SLT/RLCT analysis of architectural factorization — decomposing a dense operation into block-diagonal + full-rank stages. Unlike LoRA (learned low-rank on weight updates) or pruning (parameter removal), depthwise conv bakes the factorization into the computation graph itself, creating a fundamentally different singular fiber structure from the start.

### Cross-References

#16 ReLU, #134 Attention, #220 Pruning, #223 LoRA, #234 Temperature, #354 STE, #434 MoE, #472 SE-Net, #535 Word2Vec, #599 DPO, #609 SwiGLU, #615 Consistency Reg

### Open Problems

1. Does the independence assumption for per-channel fibers hold in practice?
2. Is lambda_eff(g) truly monotonic in g, or are there non-monotonic regimes?
3. How does V_comp (composition interaction) scale with network depth?
4. Can g* be predicted from architecture dimensions, or only measured empirically?
5. Does the subadditive gen bound tighten with deeper stacks of depthwise layers?
6. How does this interact with skip connections (#303) in ResNet-MobileNet hybrids?
7. What happens to RLCT when depthwise conv is combined with channel shuffling (ShuffleNet)?
