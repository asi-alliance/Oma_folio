# Synthesis #596: MoE-nD (Multi-Axis MoE Compression Routing) × RLCT — L4 Summary

Date: 2026-10-25

# Plain-Language Summary

MoE-nD treats KV-cache compression as a mixture-of-experts routing problem: instead of routing between weight subnetworks, each layer routes between compression configurations (eviction ratio × K-precision × V-precision). In SLT terms, this creates a product-stratified singular fiber geometry — each axis (eviction, K-precision, V-precision) contributes its own singular stratum, and the router selects which stratum combination is active per layer.

## Claims Recap

- **C1 (PROVEN)**: MoE-nD loss is R_an,exp-definable. Router = softmax(affine) → R_an; compression op = piecewise (top-k + quantization) → R_an; attention + CE → R_an,exp. Standard closure. ∎
- **C2 (CONJECTURAL)**: Compression-config-stratified singular fiber. Global zero-loss set V_0 = ∪_c V_0(c), union over config assignments. Routing boundaries Σ_{c,c'} are semi-algebraic hypersurfaces. At config ties, intersection V_0(c) ∩ V_0(c') may have higher codim → lower RLCT.
- **C3 (CONJECTURAL)**: Per-layer routing depth L_r as stratum selector. Non-monotone U-shape: too few routed layers = coarse compression (high λ), too many = router noise (high λ), optimal L_r* balances granularity (low λ). Distinct from #127 (parameter-space strata).
- **C4 (CONJECTURAL)**: Multi-axis generalization bound G ≤ C·√(λ(c*)·d_eff(c*)/n). Key hypothesis: d_eff factorizes as product of per-axis compression ratios. Cross-axis interaction terms may dominate.
- **C5 (CONJECTURAL)**: Compression budget phase transition at B*. Below B*: λ ≈ λ_dense (lossless). Above B*: λ jumps (lossy regime). SGLD-detectable kink. Extends #229 single-axis to multi-axis product space.

## Key Novel Contributions

1. **Compression-config as expert**: First formal SLT characterization of routing over KV-tensor compression configurations (not weight subnetworks).
2. **Multi-axis product stratification**: Singular fiber geometry over product space (eviction × K-precision × V-precision), with product-vs-min RLCT as key open question.
3. **Per-layer routing depth selector**: U-shaped λ(L_r) — novel stratum selector distinct from #127/#229.
4. **Routing boundary semi-algebraicity**: Formal characterization of config-tie hypersurfaces and their intersection singularity type.
5. **Multi-axis d_eff factorization hypothesis**: Testable prediction — does d_eff decompose as product or require interaction terms?

## Open Problems

1. Product vs min: does multi-axis compression give λ_product = ∏ λ_axis or λ_product = min_axis λ_axis?
2. Cross-axis interaction: does K-precision affect V-precision stratum geometry through attention score coupling?
3. Router decision geometry: is routing boundary Σ_{c,c'} generically transverse to V_0(c)?
4. Dead compression configs: analog of dead experts — unused strata with empty fiber?
5. STE inheritance: does #354 forward/backward RLCT split stack with routing singularity per-axis?
6. Load balancing: does MoE-nD load balancing regularize λ?
7. Empirical SGLD: can λ(c) be estimated for different MoE-nD configurations?

## Cross-References

#8 (Adam) #16 (ReLU) #73 #100 (SGD) #127 (MoE routing) #229 (KV eviction) #244 #354 (STE/quantization) #362 #375 #381 #420 #434 (MoE framework) #486 #504 #537 (MoE L4) #545 (Sparse attention) #551

## Status

L0-L4 COMPLETE. Next: L5 catalog append.