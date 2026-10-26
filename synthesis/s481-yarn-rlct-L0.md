# Synthesis #481: YaRN × RLCT
## L0: Outline and Core Hypotheses

### Background

YaRN (Yet another RoPE extensioN) extends transformer context windows by applying frequency-band-dependent scaling to RoPE position embeddings. RoPE encodes position m as rotation by angle m·θ_i for dimension pair i, where θ_i = base^(-2i/d). YaRN partitions frequency pairs into three bands based on wavelength λ_i = 2π/θ_i relative to training context length L_train:

1. **High-frequency band** (λ_i << L_train): No scaling (extrapolation). Rotation unchanged.
2. **Transition band** (λ_i ~ L_train): Smooth ramp interpolation between extrapolation and full interpolation.
3. **Low-frequency band** (λ_i >> L_train): Full interpolation by ratio s = L_target/L_train.

Additionally, YaRN applies attention temperature scaling: attention logits are divided by t = √s, compensating for entropy change in the attention distribution.

### Core Claims

**C1 (Proven): R_an,exp Definability.**
The YaRN-modified position embedding map is piecewise-definable in R_an,exp. The ramp function α(λ) is piecewise smooth (constant 0 on high-freq band, linear ramp on transition band, constant 1 on low-freq band). The effective frequency θ'_i = (1 + α(λ_i)·(s-1))·θ_i is a piecewise-analytic function of θ_i and s. The temperature scaling t = √s is algebraic (square root). The softmax+CE composition preserves R_an,exp definability. Each piece is analytic; the full map is piecewise-analytic with finitely many pieces.

**C2 (Conjectural): Frequency-Band Singular Strata.**
YaRN creates heterogeneous singular strata across frequency dimension pairs. Each band b ∈ {high, transition, low} defines a distinct effective position map φ_b: (m, θ_i) → rotation angle. The singular fiber V_b depends on the band assignment. High-freq band: V_high = V_train (unchanged training fiber, same RLCT). Low-freq band: V_low = V_interp (interpolated fiber, potentially different RLCT due to compressed effective positions). Transition band: V_trans = blend, with α controlling the interpolation degree. The band boundaries create piecewise structure in the parameter space, analogous to #354 STE's quantization cells but along the frequency axis rather than the weight axis.

**C3 (Conjectural): Ramp Function as Continuous Stratum Selector.**
The ramp function α(λ) acts as a continuous stratum selector interpolating between the extrapolation stratum (α=0, no scaling) and the interpolation stratum (α=1, full scaling). The effective RLCT is a band-weighted aggregation: λ_eff(s) = Σ_b w_b(s) · λ_b, where w_b depends on the fraction of dimension pairs in each band at scaling ratio s. As s increases, more pairs migrate from high→transition→low bands, shifting weight toward interpolation strata. This is distinct from #427 ALiBi's uniform slope-based fiber stratification (all heads share linear bias) — YaRN's stratification is per-frequency-pair, not per-head.

**C4 (Conjectural): Generalization Bound with Band-Dependent RLCT.**
The generalization bound depends on band-dependent RLCT: G_YaRN ~ λ_eff(s)/n + U(s)/√n, where λ_eff aggregates band-level RLCTs and U(s) captures the temperature correction's effect on posterior concentration. The attention temperature t = √s rescales logits, changing the effective loss landscape sharpness. Extrapolation ability corresponds to λ_eff invariance: high-freq bands maintain λ_high (invariant to s), providing extrapolation anchor, while low-freq bands adapt via interpolation. The partial invariance (some bands invariant, some adapted) is YaRN's key advantage over uniform scaling (#224 RoPE). Distinct from #427 ALiBi where all heads extrapolate uniformly.

**C5 (Conjectural): Phase Transition at Critical Ratio s*.**
There exists a critical scaling ratio s* where the transition band width transitions from O(1) to O(d/2), causing a qualitative change in λ_eff behavior. Below s*: high-freq band dominates, λ_eff ≈ λ_high, extrapolation works (few pairs need interpolation). Above s*: transition+low bands dominate, λ_eff ≈ λ_interp + λ_trans, temperature correction becomes critical for maintaining attention entropy. The transition is controlled by the relationship between wavelength distribution {λ_i} and context lengths L_train, L_target. At s*, the number of dimension pairs crossing from high→transition band jumps, analogous to #421 LayerScale's per-feature stratum lattice but along the frequency axis.

### Open Problems

1. Exact form of λ_b for each band — is λ_high exactly the training RLCT, or does the band boundary create a new singularity?
2. Transversality of band boundaries — do the piecewise boundaries interact with the analytic structure of the loss?
3. Derivation of λ_eff(s) aggregation formula — additive vs. min vs. harmonic mean?
4. Temperature correction's effect on RLCT — does t=√s change the singularity structure or only the coefficient?
5. Optimal ramp function shape (linear vs. cosine vs. learned) — does it affect λ_eff?
6. Dependence of s* on base frequency θ_0 and dimension d — scaling law?
7. Comparison with #427 ALiBi: does per-frequency-pair stratification outperform per-head stratification in RLCT terms?
8. SGLD testability: can band-dependent λ_b be measured via local loss landscape geometry?

### Cross-References

#224 (RoPE × RLCT), #245 (RoPE variant), #427 (ALiBi × RLCT), #354 (STE × RLCT, piecewise structure), #421 (LayerScale, per-feature strata), #433 (PolyLoss, degree as selector), #199 (Skip connections), #221 (BatchNorm), #296 (Stochastic depth), #411 (CoT), #8 (Attention), #73 (Skip), #169 (Zoneout), #185 (Constitutional AI)

### Key Distinctions

- vs #224 RoPE: YaRN applies non-uniform, band-dependent scaling; RoPE uses uniform rotation. YaRN's singularity structure is piecewise across frequency axis.
- vs #427 ALiBi: ALiBi stratifies by head (slope m_h); YaRN stratifies by frequency pair (wavelength λ_i). Different axes of stratification.
- vs #354 STE: Both have piecewise structure; STE along weight axis (quantization cells), YaRN along frequency axis (wavelength bands).