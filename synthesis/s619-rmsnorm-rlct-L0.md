# Synthesis #619: RMSNorm × RLCT — L0 Exploration

## Date
2026-10-25

## Topic
RMSNorm (Root Mean Square Normalization) classified by RLCT. RMSNorm: y_i = x_i / sqrt((1/d)Σ_j x_j² + ε) · γ_i. Unlike BatchNorm (#16, uses mean+variance with batch statistics) and LayerNorm (uses mean+variance per sample), RMSNorm uses only the root-mean-square (second moment) — no mean centering. The normalization denominator sqrt(RMS(x) + ε) where RMS(x) = sqrt((1/d)Σ x_j²). The key singularity: when RMS(x) → 0 (all activations near zero), the denominator approaches sqrt(ε), creating a near-division-by-zero structure. For ε → 0, the map x ↦ x/||x|| (RMS normalization without ε) is the projection onto the unit sphere — smooth everywhere except at x = 0 (origin singularity). With ε > 0, the singularity is regularized but the loss landscape retains a singular fiber structure near configurations where activation norms collapse.

Novel: No prior PLT/RLCT analysis of RMSNorm exists. RMSNorm's division structure (x/sqrt(mean(x²)+ε)) creates a fundamentally different singularity type than BatchNorm (#16, batch-statistics coupling) or LayerNorm (#89, mean+variance coupling). The origin singularity (||x|| → 0) is a polar singularity — analogous to resolution of singularities in algebraic geometry (blow-up at origin).

## Claims

### C1 (PROVEN): RMSNorm is definable in R_{an,exp}
RMSNorm: y_i = γ_i · x_i / sqrt((1/d)Σ_j x_j² + ε). The denominator sqrt(s + ε) where s = (1/d)Σ x_j² is a polynomial in x (definable in R_an). sqrt is definable in R_an (o-minimal structure includes restricted sqrt). Division x_i / sqrt(s+ε) is definable in R_an for s+ε > 0 (guaranteed by ε > 0). The affine scale γ_i · y_i is definable. Composition through network layers preserves definability. For ε = 0: x/||x|| is definable on R^d \ {0} (not extendable to origin). With ε > 0: definable everywhere. Thus RMSNorm loss L_RMS(θ) = Σ L(f_θ(x), y) where f_θ includes RMSNorm layers is definable in R_an (or R_{an,exp} if exp-based activations used). By Watanabe theorem, RLCT is well-defined. QED.

### C2 (CONJECTURAL): Origin-proximity singular fiber from activation norm collapse
The RMSNorm denominator sqrt(RMS(x) + ε) creates a singular fiber structure near parameter configurations where intermediate activations collapse to near-zero norm. Define the activation-collapse locus: A(θ) = {θ : ∃ layer l, ∃ input x, RMS(h_l(x;θ)) → ε^{1/2}} (activations approach the ε-regularized origin). Near A, the gradient of the loss w.r.t. θ is amplified by 1/sqrt(RMS + ε) → the effective learning rate diverges as RMS → 0. This creates a singular stratum: the Fisher information matrix degenerates (gradients become dominated by the normalization denominator, not the task signal). Conjecture: A defines a singular stratum Σ_0 in the loss landscape. The RLCT λ_0 near Σ_0 is determined by the order of vanishing of RMS(x;θ) at the collapse configuration. If RMS ~ ||θ - θ*||^k near collapse, then the effective loss has a pole-like structure with λ_0 related to k and the codimension of Σ_0. Predicted: λ_RMS < λ_LN (RMSNorm has fewer statistics → simpler fiber → lower RLCT).

### C3 (CONJECTURAL): ε as blow-up parameter — resolution of origin singularity
Without ε (ε = 0), RMSNorm reduces to spherical projection x/||x|| — singular at origin (x = 0). With ε > 0, the map is regularized: x/sqrt(||x||²/d + ε). In algebraic geometry, blow-up at origin replaces the singular point with an exceptional divisor. Analogously, ε > 0 "resolves" the origin singularity by replacing the point x=0 with a ball of radius ~sqrt(ε). Conjecture: ε acts as a resolution parameter. The RLCT λ(ε) transitions:
- ε = 0: λ = λ_max (unresolved singularity, maximal RLCT)
- ε > 0: λ(ε) < λ_max (singularity resolved/partially regularized)
- ε → ∞: λ → λ_smooth (normalization becomes identity-like, no singularity)
The relationship λ(ε) ~ λ_max - c·log(1/ε) for small ε (logarithmic resolution, analogous to log-resolution of singularities in Hironaka's theorem). The ε parameter controls the "thickness" of the exceptional divisor: smaller ε → thinner resolution → higher λ.

### C4 (CONJECTURAL): RMSNorm vs LayerNorm RLCT comparison
RMSNorm (no mean centering): y = x/sqrt(mean(x²)+ε)·γ. LayerNorm (mean+variance): y = (x-μ)/sqrt(σ²+ε)·γ. LayerNorm has two coupled statistics (μ, σ²) creating a 2-parameter family of singular configurations (mean collapse AND variance collapse). RMSNorm has one statistic (RMS = sqrt(mean(x²))), creating a 1-parameter family (norm collapse only). Conjecture: λ_RMS ≤ λ_LN because:
1. Fewer normalization statistics → fewer coupled singular directions → lower codimension of singular stratum.
2. No mean-centering removes the translation singularity (LayerNorm has singular fiber near μ → 0 AND σ → 0; RMSNorm only near RMS → 0).
3. The polar structure x/||x|| has known RLCT (sphere projection singularity, codim 1), while LayerNorm's coupled mean+variance has higher codimension.
Predicted: λ_RMS = λ_LN - δ where δ ~ 1/2 (one fewer coupled statistic removes ~1 DOF from singular fiber).

### C5 (CONJECTURAL): Generalization bound and the ε-resolution tradeoff
SLT bound: G(n) ≤ λ·log(n)/(2n) + U/√n + B.
For RMSNorm with ε: G_ε(n) ≤ λ(ε)·log(n)/(2n) + U_ε/√n + B_ε.
- λ(ε): decreases as ε increases (better resolution of singularity → lower RLCT).
- B_ε: bias increases as ε increases (larger ε → normalization weaker → activations less normalized → representation quality degrades). At ε = 0: B = 0 (perfect normalization, but λ maximal). At ε → ∞: B → large (no normalization).
- Optimal ε* minimizes λ(ε)·log(n)/(2n) + B_ε.
Tradeoff: small ε (good normalization, high λ) vs large ε (poor normalization, low λ). The optimal ε* shifts with n: for large n, the log(n)/(2n) term shrinks, so ε* increases (prefer lower bias over lower λ). This predicts that optimal ε should increase with training set size — a testable prediction.
Testable via SGLD: measure LLC ν_ε as function of ε. Predict ν_ε decreasing in ε. Also predict ν_RMS < ν_LN at same ε.

## Distinctness
- vs #16 BatchNorm: BN uses batch statistics (mean+var) creating coupling between samples. RMSNorm uses per-sample RMS (no batch coupling, no mean). Different singularity source (batch-statistics coupling vs origin-proximity).
- vs #89 LayerNorm: LN uses mean+variance (2 statistics). RMSNorm uses only RMS (1 statistic). LN has translation singularity (mean centering), RMSNorm does not. Predicted λ_RMS < λ_LN.
- vs #470 QAT: QAT introduces quantization singularities (discrete rounding). RMSNorm introduces normalization singularities (continuous division). Different singularity type.
- vs #234 Temperature: Temperature scales logits by 1/T (smooth scaling). RMSNorm scales activations by 1/RMS (non-smooth at origin). Temperature is global scalar, RMSNorm is per-activation-vector.
- vs #618 Sparsemax: Sparsemax creates support-change kink singularities (piecewise-linear). RMSNorm creates origin-proximity polar singularities (radial projection). Different geometric mechanism.

## Open Problems
1. Exact RLCT of spherical projection singularity x/||x|| — is it 1/2 (codim-1 hypersurface) or modified by network composition?
2. ε-resolution: is λ(ε) ~ λ_max - c·log(1/ε) (logarithmic) or λ(ε) ~ λ_max - c·ε^{-α} (power-law)?
3. Interaction with activation function: does ReLU (non-smooth at 0) × RMSNorm (singular at 0) create compound singularity at activation collapse?
4. Depth dependence: does stacking RMSNorm layers compound the origin singularity (iterated radial projections)?
5. Comparison with GroupNorm, InstanceNorm — how many normalization statistics affect λ?
6. Optimal ε schedule: should ε anneal (large→small) during training to traverse λ(ε) landscape?
7. Weight tying interaction (#618): if shared weights produce correlated activations, does RMS collapse locus become higher-dimensional?
8. SGLD measurement: can LLC detect the origin-proximity singular fiber empirically?
9. Connection to neural collapse: at terminal training, activations often collapse to specific geometries (ETF). Does RMSNorm's origin singularity interact with neural collapse?

## Cross-References (10)
#16 (BatchNorm) #89 (LayerNorm) #234 (temperature) #323 (label smoothing) #470 (QAT) #618 (sparsemax/entmax) #100 (softmax) #169 (dropout) #433 (PolyLoss) #539 (focal loss)
