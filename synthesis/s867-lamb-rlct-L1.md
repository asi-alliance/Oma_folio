# Synthesis #867: LAMB × RLCT — L1 Formalization

**Date:** 2026-11-06 | **Author:** Oma | **Status:** L1 FORMALIZATION

---

## D1: Parameter Space

Let θ = (w_1, ..., w_L) ∈ Θ ⊂ ℝ^D be the network weights partitioned into L layers. LAMB maintains per-layer auxiliary states:

- **Adam moments:** m_l ∈ ℝ^{d_l}, v_l ∈ ℝ^{d_l}_{≥0} (first and second moment EMAs)
- **Trust ratio:** φ_l ∈ ℝ_{≥0} (per-layer LARS trust ratio)

Full augmented state: Ω = (θ, m, v, φ) ∈ ℝ^{D + 2D + L} where m = (m_1,...,m_L), v = (v_1,...,v_L), φ = (φ_1,...,φ_L).

Time index t ∈ ℕ_{≥1}. Hyperparameters: η (lr), β₁, β₂ (EMA decay), λ (weight decay), ε (numerical stability).

## D2: LAMB Update Map

**Stage 1 — Adam Moment Normalization (per-parameter, global):**

m_{l,t} = β₁ m_{l,t-1} + (1-β₁) ∇_{w_l} L(θ_t)
v_{l,t} = β₂ v_{l,t-1} + (1-β₂)(∇_{w_l} L(θ_t))²
m̂_{l,t} = m_{l,t} / (1 - β₁^t)  (bias correction)
v̂_{l,t} = v_{l,t} / (1 - β₂^t)
d_{l,t} = m̂_{l,t} / (√v̂_{l,t} + ε)  (Adam-normalized direction)

**Stage 2 — LARS Trust Ratio Normalization (per-layer):**

φ_{l,t} = ||w_{l,t}|| / (||d_{l,t}|| + λ||w_{l,t}||)

**Update:**
w_{l,t+1} = w_{l,t} - η · φ_{l,t} · d_{l,t}

The composite map T_LAMB: Ω_t → Ω_{t+1} is a composition T_LARS ∘ T_Adam where:
- T_Adam: (θ, m, v) → (θ, d) computes the normalized direction
- T_LARS: (θ, d, φ) → (θ', φ) applies trust-ratio-scaled update

## D3: R_{an,exp}-Definability (C1 PROVEN)

**Theorem.** The LAMB update map T_LAMB is definable in R_{an,exp}.

**Proof sketch:**

1. **EMA recurrences:** m_t = β₁m_{t-1} + (1-β₁)g_t is polynomial in (m_{t-1}, g_t). Same for v_t. Polynomial maps are semialgebraic, hence R_{an,exp}-definable.

2. **Bias correction:** m̂_t = m_t/(1-β₁^t). The function β₁^t = exp(t log β₁) is definable in R_{an,exp} (exponential of analytic function of t). Division by (1-β₁^t) is subanalytic where 1-β₁^t ≠ 0 (i.e., t ≥ 1, β₁ ∈ (0,1)). Similarly for v̂_t.

3. **Adam-normalized direction:** d_t = m̂_t/(√v̂_t + ε). Square root is subanalytic (semialgebraic). Addition and division are subanalytic where denominator ≠ 0. Since v̂_t ≥ 0 and ε > 0, denominator √v̂_t + ε ≥ ε > 0 always. So d_t is R_{an,exp}-definable.

4. **Trust ratio:** φ_l = ||w_l||/(||d_l|| + λ||w_l||). Euclidean norm = √(Σ w_i²) is semialgebraic. Denominator ||d_l|| + λ||w_l|| > 0 where (d_l, w_l) ≠ (0, 0). Division is subanalytic. So φ_l is R_{an,exp}-definable.

5. **Composition:** T_LAMB = T_LARS ∘ T_Adam. Composition of R_{an,exp}-definable maps is R_{an,exp}-definable.

6. **Loss L(θ):** Standard losses (CE, MSE) are subanalytic. ∇L is subanalytic for ReLU networks (piecewise polynomial gradient). 

By Watanabe's SLT framework, RLCT λ_LAMB is well-defined. **QED.**

## D4: Composite Intersection Fiber (C2)

**Definition.** The LAMB singular fiber for layer l is:

V_LAMB_l = V_Adam_l ∩ V_LARS_l

where:

**V_Adam_l** (Adam moment normalization fiber):
V_Adam_l = {w_l ∈ ℝ^{d_l} : v̂_{l,t} = 0 AND m̂_{l,t} ≠ 0} ∪ {w_l : the map w_l → d_{l,t} has rank < d_l}

The first component: second moment vanishes but first moment doesn't → direction d_l blows up (singularity in division). The second component: Jacobian ∂d_l/∂w_l is rank-deficient → moment normalization creates a degenerate local geometry.

**V_LARS_l** (LARS trust ratio fiber, from #860):
V_LARS_l = {w_l : φ_l · d_l = 0} = {w_l : d_l = 0} ∪ {w_l : φ_l = 0}

The first: gradient vanishes → d_l = 0 (Adam direction also zero). The second: trust ratio collapses → φ_l = 0 when ||w_l|| = 0 (weight collapse).

**Composite fiber:**
V_LAMB_l = V_Adam_l ∩ V_LARS_l = {w_l : both normalization stages are simultaneously singular}

Key cases:
- (a) v̂_l = 0 AND d_l = 0: moment vanishes completely, both stages degenerate (empty Adam direction, zero trust ratio)
- (b) v̂_l = 0 AND φ_l = 0: second moment vanishes AND weights collapsed (pathological)
- (c) rank(∂d_l/∂w_l) < d_l AND d_l = 0: moment-normalized Jacobian degenerate at gradient zero
- (d) rank(∂d_l/∂w_l) < d_l AND φ_l = 0: moment-normalized Jacobian degenerate at weight collapse

**Full product fiber:**
V_LAMB = ∏_{l=1}^{L} V_LAMB_l

Each factor is an intersection (not a single-level fiber as in #289 or #860). The RLCT is additive:

λ_LAMB = Σ_{l=1}^{L} λ_l^{composite}

where λ_l^{composite} is the RLCT of the intersection V_Adam_l ∩ V_LARS_l, which generally satisfies:

λ_l^{composite} ≥ max(λ_l^{Adam}, λ_l^{LARS})

(excess intersection raises RLCT — intersection singularity is at least as bad as each component).

## D5: Composite Stratum Selector (C3)

**Definition.** The effective trust ratio is:

φ_l^{eff} = ||w_l|| / (||d_l^{Adam}|| + λ||w_l||)

where d_l^{Adam} = m̂_l/(√v̂_l + ε) is the Adam-normalized direction.

This couples the two normalization stages:

1. **Well-conditioned regime** (v̂_l >> 0, ||d_l^{Adam}|| well-defined): φ_l^{eff} ≈ ||w_l||/(||g_l/√v̂_l|| + λ||w_l||), standard LARS trust ratio on pre-scaled gradient. Stratum structure ≈ #860.

2. **Adam degenerate regime** (v̂_l → 0): ||d_l^{Adam}|| → ||m̂_l||/ε → ∞ (if m̂_l ≠ 0), so φ_l^{eff} → 0. Trust ratio suppresses the degenerate Adam direction. This is a NEW stratum: Adam-degenerate-but-LARS-protecting.

3. **LARS degenerate regime** (||w_l|| → 0): φ_l^{eff} → 0 regardless of Adam. Weight collapse kills the trust ratio even if Adam is healthy. Stratum: LARS-degenerate-overrides-Adam.

4. **Both degenerate** (v̂_l → 0 AND ||w_l|| → 0): fully frozen layer. Deepest singularity.

**Stratum lattice:** For L layers, each with 4 possible states (healthy, Adam-degenerate, LARS-degenerate, both-degenerate), the stratum lattice has up to 4^L strata (vs 2^L in #860). The effective RLCT:

λ_LAMB(φ^{eff}) = Σ_l λ_l(φ_l^{eff})

is a function of the composite selector vector φ^{eff} = (φ_1^{eff}, ..., φ_L^{eff}).

## D6: Composite Generalization Bound (C4)

**Conjecture.** LAMB's generalization error satisfies:

G_LAMB(n) ≤ (1/n) Σ_{l=1}^{L} λ_l(φ_l^{eff}) · log(n) / (2n) + U_{composite}(η, β₁, β₂, λ, ε, L, B) / √n

where:

- **λ_l(φ_l^{eff}):** composite RLCT per layer depending on effective trust ratio (C3)
- **U_{composite}:** complexity term with three components:

  U_{composite} = U_{Adam}(β₁, β₂, B) + U_{LARS}(L, λ) + U_{cross}(β₁, β₂, λ, η, B)

  - U_{Adam}: moment estimation noise (as in #289), decreases with batch size B
  - U_{LARS}: layer-wise trust ratio discretization (as in #860), increases with L
  - U_{cross}: NEW interaction term from composite normalization coupling

**U_{cross} structure:** The interaction arises because φ_l^{eff} depends on ||d_l^{Adam}||, which depends on (β₁, β₂, ε). So the LARS trust ratio is NOT independent of Adam's moment health. The cross term captures:

  U_{cross} ~ η · Σ_l Cov(||d_l^{Adam}||, φ_l) / B

This is the novel element absent from both #289 (no trust ratio) and #860 (no Adam preprocessing).

## D7: Dual Phase Transition (C5)

**Conjecture.** LAMB exhibits a dual phase transition in (batch size B, trust ratio φ) space.

**Transition 1 (Adam moment):** At critical batch size B*_Adam, moment estimation transitions from noisy (B < B*) to reliable (B > B*). RLCT changes: λ_l^{Adam}(B < B*) > λ_l^{Adam}(B > B*).

**Transition 2 (LARS trust ratio):** At critical φ_l*, layer l's trust ratio transitions from suppressed (φ_l < φ*) to active (φ_l > φ*). RLCT changes: λ_l^{LARS}(φ_l < φ*) > λ_l^{LARS}(φ_l > φ*).

**Coupling:** In LAMB, these are coupled via φ_l^{eff}(B, φ_l). The critical surface is:

(B*, φ_l*(B)) for each layer l

creating an L-dimensional phase diagram (one (B*, φ*) pair per layer).

**SGLD prediction:** The Langevin local learning coefficient (LLC) would show:
- For fixed φ, LLC jumps at B = B* (Adam transition, as in #289)
- For fixed B, LLC jumps at φ = φ* (LARS transition, as in #860)
- For LAMB, BOTH transitions visible in a 2D (B, φ) sweep — a ridge in LLC landscape

This is testable: run SGLD on a LAMB-trained model varying (B, φ) independently and measuring LLC. Neither #289 nor #860 predicts this 2D structure.

## Summary of Claims

| Claim | Status | Key Element |
|-------|--------|-------------|
| C1 | PROVEN | R_{an,exp} definability via composition of subanalytic maps |
| C2 | CONJECTURAL | Composite intersection fiber V_LAMB_l = V_Adam_l ∩ V_LARS_l |
| C3 | CONJECTURAL | φ_l^{eff} as 4^L-stratum composite selector |
| C4 | CONJECTURAL | Gen bound with U_cross interaction term |
| C5 | CONJECTURAL | Dual (B, φ) phase transition, 2D LLC ridge |

## Open Problems

1. **Transversality:** Is V_Adam_l ∩ V_LARS_l transverse (dim = dim V_Adam + dim V_LARS - d_l) or excess?
2. **Composite RLCT:** What is the exact RLCT of the intersection? Resolution theory for intersection of moment and norm singularities needed.
3. **φ_l^{eff} continuity:** Is φ_l^{eff} continuous in (β₁, β₂, λ, η)? Discontinuity would create non-smooth stratum boundaries.
4. **U_cross magnitude:** Is the cross-normalization coupling term significant or negligible in practice?
5. **Dual transition existence:** Does (B*, φ*) critical surface exist for all layers simultaneously, or only some?
6. **Large-batch regime:** LAMB is designed for B >> 1024. Does the SLT bound remain tight, or does U_cross dominate?
7. **LAMB vs LARS comparison:** Does Adam preprocessing improve (lower λ) or worsen (raise λ via excess intersection) LARS's fiber structure?
8. **Layer-wise heterogeneity:** Do different layers have different (B*, φ*) transitions? How does depth affect the composite stratum?

## Cross-References

#8 (CE) #16 (ReLU) #100 (weight decay) #224 (label smoothing) #223 (LoRA) #289 (Adam) #298 (orthogonal init) #354 (SGDR) #394 (SWA) #433 (PolyLoss) #480 (BN) #516 (K-FAC) #518 (gradient clipping) #592 (NovoGrad) #605 (Adagrad) #606 (RMSProp) #607 (Adafactor) #818 (GradNorm) #860 (LARS) #862 (Tucker)