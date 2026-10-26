# Synthesis #617: BitNet b1.58 × RLCT — L1 Formalization
## Date: 2026-10-25

D1 (Ternary projection map): Q_s: R^d → {-1,0,+1}^d defined by Q_s(w)_i = sign(w_i) * 1[|w_i| > s] where s is the deadzone threshold. Q_s is subanalytic (composition of sign and indicator of semi-algebraic set {|w|>s}). The quantized loss K_Q(θ) = L(Q_s(θ)) is definable in R_an,exp by closure under subanalytic composition.

D2 (Ternary fiber): V_Q = Q_s^{-1}(W_0) = union over all ternary assignments t ∈ {-1,0,+1}^d of cells C_t = {θ : Q_s(θ) = t}. Each C_t is an open convex region (hypercube with deadzone strips). The fiber V_Q has 3^d connected components — exponentially many, structurally distinct from binary (2^d) or continuous (1 component).

D3 (Deadzone singularity): The zero-level stratum S_0 = {θ : Q_s(θ) = 0} = {θ : |θ_i| ≤ s ∀i} is a closed cube of side 2s centered at origin. This creates a codimension-0 region (not a hypersurface) mapped to zero — fundamentally different from binary quantization which has no zero level. The singularity at S_0 boundary ∂S_0 = {|θ_i| = s} is a piecewise-linear hypersurface with normal crossings along coordinate axes.

D4 (Bit-width stratum selector): Define b: log2(levels) where levels = 2^b. Ternary: b = log2(3) ≈ 1.585. The effective RLCT λ_eff(b) is a function of quantization resolution. For b=1 (binary), λ_bin is the RLCT under ±1 projection. For b→∞ (continuous), λ_cont is the standard RLCT. Conjecture: λ_bin ≤ λ_ternary ≤ λ_cont. The selector s (deadzone width) modulates between binary-like (s→0) and sparse-ternary (s→∞) regimes within the ternary stratum.

D5 (Generalization bound): G_BitNet ≤ λ_ternary * log(n) / (2n) + U(ternary,s) / sqrt(n) where λ_ternary is the RLCT of the ternary loss landscape and U(ternary,s) captures quantization bias from projection Q_s. From-scratch training means the model optimizes directly on the discrete ternary loss — no forward/backward split (unlike QAT #470). The bound reflects the piecewise-constant loss landscape. Gap: U(ternary,s) characterization; interaction with architecture depth.

D6 (From-scratch vs QAT RLCT): BitNet: K_Q(θ) = L(Q_s(θ)) — single loss, training on discrete landscape. QAT (#470): K_fwd(θ) = L(Q_s(θ)) but K_bwd(θ) = L(θ) via STE — two different loss landscapes with potentially different RLCTs λ_fwd ≠ λ_bwd. BitNet has no STE, so λ_BitNet = λ(Q_s) is a single RLCT. Conjecture: λ_BitNet ≤ λ_QAT,bwd because the discrete landscape has fewer effective degrees of freedom. Gap: formal comparison proof; SGD dynamics on piecewise-constant loss.

D7 (Phase transition at critical bit-width b*): Conjecture: ∃ b* ∈ (1, 2) such that below b* the deadzone pruning dominates (sparse subnetworks emerge, effective complexity reduced) and above b* the quantization error dominates (continuous-like behavior). b* ≈ log2(3) is the natural threshold where ternary resolution matches intrinsic model complexity. SGLD LLC measurement across bit-widths can detect b* as an LLC inflection point. Gap: universality of b* across architectures; relationship to lottery ticket hypothesis (#88/#98).

C1 (PROVEN): Q_s = sign(w)·1[|w|>s] is subanalytic; K_Q = L∘Q_s is R_an,exp definable by composition closure with definable L (cross-entropy with definable activations).

C2 (CONJECTURAL): Ternary fiber V_Q has 3^d components; deadzone S_0 creates qualitatively new singular stratum absent in binary. λ_Q determined by cell boundary geometry + deadzone. Gaps: RLCT well-definedness on piecewise-constant loss; toric fan refinement structure of 3^d cells.

C3 (CONJECTURAL): λ_bin ≤ λ_ternary ≤ λ_cont; bit-width b selects among quantization strata; s modulates within ternary stratum. Gaps: monotonicity proof; finite-width corrections; interaction with optimizer (#370 Adam coordinate rescaling).

C4 (CONJECTURAL): G_BitNet ≤ λ_ternary·log(n)/(2n) + U/sqrt(n) with from-scratch discrete landscape. Gaps: U(ternary,s) characterization; comparison with QAT bound (#470); depth dependence.

C5 (CONJECTURAL): Phase transition b* ≈ log2(3) where deadzone pruning ↔ quantization error dominance switches. Detectable via SGLD LLC inflection. Gaps: universality; connection to pruning (#88) and lottery tickets (#98); b* vs architecture capacity.

OPEN PROBLEMS:
1) RLCT well-definedness on piecewise-constant ternary loss — is Watanabe framework directly applicable or needs extension?
2) Toric geometry of 3^d ternary cells — is V_Q a toric fan refinement with 3-ray cones?
3) Deadzone scale s optimization during training — can s be learned as adaptive stratum selector?
4) λ_BitNet vs λ_QAT formal comparison — is from-scratch strictly lower complexity?
5) SGLD LLC measurement protocol for ternary-trained models — piecewise-constant loss may break SGLD assumptions.
6) Interaction with MoE routing — does ternary routing create compound singularities?
7) b* universality across architectures — does log2(3) threshold generalize beyond transformers?

CROSS-REFS: #470 #244 #194 #354 #576 #319 #88 #98 #100 #162 #199 #556 #89 #8 #16 #370
