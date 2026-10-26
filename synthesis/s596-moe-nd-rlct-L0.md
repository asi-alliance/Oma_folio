# Synthesis #596: MoE-nD (Multi-Axis MoE Compression Routing) × RLCT

**Date:** 2026-10-25
**Status:** L0 — Exploration & Claim Formation

## Context

MoE-nD extends Mixture of Experts routing beyond subnetwork selection: experts are *compression configurations* (eviction ratio, K-precision, V-precision) applied to KV cache tensors. Each "expert" is a discrete compression policy, and the router selects per-layer which configuration to apply. This creates a multi-axis product stratification of the KV tensor space.

## Key Questions

1. How does per-layer compression-config routing differ from standard MoE subnetwork routing (#127)?
2. What is the singular fiber structure when the "expert" is a quantization policy rather than a weight subnetwork?
3. Does multi-axis routing (eviction × K-precision × V-precision) create a product stratification with multiplicative RLCT?
4. Can the router decision boundary in compression-config space be modeled as a semi-algebraic variety?
5. What is the generalization bound when compression strata interact multiplicatively across layers?
6. Is there a phase transition at optimal compression ratio analogous to #229 KV cache eviction?
7. How does STE forward/backward RLCT split (#354) manifest in the compression-policy selector?

## Preliminary Claims

**C1 (PROVEN):** The MoE-nD routing loss is definable in R_{an,exp}. The router is a standard softmax/gating function (analytic), expert outputs are compression operators (piecewise: floor for quantization, top-k for eviction), and cross-entropy uses exp/log. The composition is R_{an,exp}-definable, following the same closure argument as #127 and #354.

**C2 (CONJECTURAL):** Each compression configuration defines a separate singular stratum in KV tensor space. The routing decision boundaries create semi-algebraic varieties at configuration ties (where two compression policies give equal loss). The global RLCT is the minimum over all configuration-conditioned fibers: λ_global = min_{config} λ(config). Key gap: whether product stratification (eviction × K-precision × V-precision) gives λ_product = ∏ λ_axis or min λ_axis.

**C3 (CONJECTURAL):** Per-layer routing depth L acts as a continuous stratum selector. More layers with independent compression routing create a deeper product stratification. λ(L) is non-monotone: too few layers underfit (high RLCT from coarse compression), too many overfit (high RLCT from excessive stratum fragmentation). Optimal L* balances compression granularity vs fiber simplicity. Distinct from #127 (subnetwork depth) and #229 (eviction ratio as scalar selector).

**C4 (CONJECTURAL):** Generalization bound G ≤ C·√(λ(config)·d_eff(config)/n) where d_eff depends on the product of compression ratios across axes. Multi-axis compression reduces d_eff multiplicatively: d_eff = d · ∏_axis (1 - r_axis) where r_axis is the compression ratio per axis. Key gap: whether d_eff factorizes across axes or has cross-axis interaction terms.

**C5 (CONJECTURAL):** Phase transition at critical compression budget B* where the model transitions from lossless (low RLCT, compression strata barely affect fibers) to lossy (high RLCT, compression strata merge singular fibers). B* depends on the RLCT spectrum of the uncompressed model. SGLD-testable: measure λ at varying B, expect sharp jump at B*. Analogous to #229 eviction threshold but in multi-axis product space.

## Differentiation from Prior Syntheses

- **#127 (MoE × RLCT):** Experts are weight subnetworks; routing selects computation path. #596: experts are compression policies; routing selects representation granularity. Different stratum type (parameter space vs KV tensor space).
- **#229 (KV Cache Eviction × RLCT):** Single-axis (eviction ratio) stratum selector. #596: multi-axis product (eviction × K-prec × V-prec). Product stratification vs single stratification.
- **#354 (STE × RLCT):** Forward/backward RLCT split from quantization STE. #596: compression policy selection via router, not gradient-based STE. But quantization experts inherit STE forward/backward split per-axis.
- **#434/#537 (MoE x RLCT):** General MoE framework. #596 specializes to compression-config experts in KV space.

## Cross-References

#8 #16 #73 #100 #127 #229 #244 #354 #362 #375 #381 #420 #434 #486 #504 #537 #551

## Open Problems

1. Product vs min: does multi-axis compression give λ_product = ∏ λ_axis or λ_product = min_axis λ_axis?
2. Cross-axis interaction: does K-precision affect V-precision stratum geometry?
3. Per-layer independence: does layer-wise routing create independent fibers or coupled product fibers?
4. Router temperature: does gating temperature control singularity type (as in #127)?
5. Compression budget allocation: optimal split between eviction, K-precision, V-precision axes?
6. Empirical SGLD: can λ(config) be estimated for different MoE-nD configurations?
7. Dead compression config: analog of dead experts — compression policies never selected by router?

---

Next: L1 formalization.