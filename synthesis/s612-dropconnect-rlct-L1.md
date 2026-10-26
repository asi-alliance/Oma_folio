;; Synthesis #612: DropConnect × RLCT -- L1 Formalization
;; Date: 2026-10-25
;; Status: L1 FORMALIZATION
;; Prereq: L0 (s612-dropconnect-rlct-L0.md, 65 lines)

;; D1 (Setup): Layer with weight matrix W ∈ R^{m×n}, input x ∈ R^n,
;;   output y_hat = φ(W⊙M) x where M ∈ {0,1}^{m×n}, M_ij ~ Bernoulli(p).
;;   DropConnect loss: L_DC(W) = E_M[ℓ(φ((W⊙M)x), y)]
;;   = Σ_{M∈{0,1}^{mn}} p^{|supp(M)|}(1-p)^{mn-|supp(M)|} ℓ(φ((W⊙M)x), y)
;;   where |supp(M)| = number of nonzero entries in M.

;; D2 (R_an,exp structure): Each term ℓ(φ((W⊙M)x), y) is analytic in W
;;   (composition: bilinear W⊙M, then matmul with x, then φ analytic/ReLU,
;;   then loss analytic). The sum over 2^{mn} masks is a FINITE sum of
;;   analytic functions. By Wilkie's theorem closure under finite sums,
;;   L_DC ∈ R_an,exp. C1 PROVEN.

;; D3 (Coordinate subspace fiber): For mask realization M, define
;;   V_M = {W ∈ R^{m×n} : W_ij = 0 for all (i,j) where M_ij = 0}
;;   This is a coordinate subspace of dimension |supp(M)|.
;;   The singular fiber of the masked network is:
;;   𝒱_M = {W ∈ V_M : ℓ(φ((W⊙M)x), y) = ℓ_min}
;;   i.e., the restriction of the full singular fiber to V_M.

;; D4 (Expected RLCT): The effective RLCT under DropConnect is:
;;   λ_DC(p) = E_M[λ(𝒱_M)] = Σ_M p(M) · λ(𝒱_M)
;;   where λ(𝒱_M) is the RLCT of the restricted singular fiber.
;;   Since V_M ⊂ R^{mn} and dim(V_M) = |supp(M)|, generically
;;   λ(𝒱_M) ≤ λ(𝒱_full) (restriction to subspace reduces RLCT).

;; D5 (Mask support distribution): |supp(M)| ~ Binomial(mn, p).
;;   E[|supp(M)|] = p·mn, Var[|supp(M)|] = p(1-p)·mn.
;;   For large mn, |supp(M)| concentrates around p·mn (CLT).
;;   The typical subspace dimension is p·mn.

;; D6 (Generalization bound): By Watanabe's theorem applied to each mask:
;;   G_DC ≤ (1/2n) · E_M[λ(𝒱_M)] = λ_DC(p) / (2n)
;;   The effective generalization constant is λ_DC(p), a function of p.
;;   Trade-off: lower p → lower λ_DC but higher empirical loss.

;; D7 (Optimal p* phase transition): The optimal DropConnect rate p*
;;   minimizes the total generalization gap:
;;   p* = argmin_p [L_empirical(p) + λ_DC(p)/(2n)]
;;   At p=1: λ_DC = λ_full (no masking). At p→0: λ_DC→0 but L_emp→∞.
;;   CONJECTURAL: p* exists, is unique, scales with model complexity.

;; C1 PROVEN: L_DC ∈ R_an,exp (finite sum of analytic functions, Wilkie closure)

;; C2 CONJECTURAL: λ(𝒱_M) ≤ λ(𝒱_full) for generic masks M.
;;   Rationale: restriction to coordinate subspace can only reduce singularity.
;;   Gap: need rigorous proof via resolution of singularities for subspace
;;   restrictions. Generic intersection assumption required.

;; C3 CONJECTURAL: λ_DC(p) is monotone non-increasing in p.
;;   Lower p → smaller subspaces → lower RLCT. But non-monotonicity possible
;;   if special mask patterns create anomalously deep singularities.
;;   Gap: monotonicity requires uniform genericity over mask realizations.

;; C4 CONJECTURAL: Generalization bound G_DC ≤ λ_DC(p)/(2n).
;;   Gap: standard Watanabe bound applies per-mask; averaging over masks
;;   requires exchangeability argument. Correlation between masks unaddressed.

;; C5 CONJECTURAL: p* exists and p* ~ f(d, n, λ_full).
;;   Gap: exact scaling law undetermined. Possible p* ~ d^{-α} for some α>0.

;; DISTINCTION FROM DROPOUT (#506/#169):
;; Dropout masks activations: a_l = φ(W_l a_{l-1}) ⊙ m_l
;;   → subnetwork selection → fiber UNION over 2^L architectures
;;   → RLCT = min over subnetwork fibers
;; DropConnect masks weights: y = φ((W⊙M)x)
;;   → coordinate subspace in parameter space → fiber RESTRICTION
;;   → RLCT = E_M[RLCT of restricted fiber]
;; These are fundamentally different singular geometries.

;; 7 OPEN PROBLEMS:
;; OP1: Exact λ(𝒱_M) as function of mask support pattern
;; OP2: Genericity conditions — which masks violate λ(𝒱_M) ≤ λ(𝒱_full)?
;; OP3: Concentration of λ(𝒱_M) around E[λ] — is variance negligible?
;; OP4: p* scaling exponent — p* ~ d^{-α} for what α?
;; OP5: Layer-wise DropConnect — different p_l per layer, multi-stratum
;; OP6: Interaction with weight decay (#282) and spectral norm (#222)
;; OP7: SGLD detectability of p* phase transition in practice

;; CROSS-REFERENCES:
;; #8: ReLU definability | #16: Semi-algebraic foundation
;; #73: Deep learning RLCT framework | #86: Attention non-identifiability
;; #100: Parameter space geometry | #118: Quantization x RLCT
;; #169/#506: Dropout x RLCT (activation masking, fiber union)
;; #239: DropConnect earlier (coordinate subspaces, L0-L4 done)
;; #282: Weight Decay x RLCT | #298: Orthogonal Init x RLCT
;; #321: Stochastic Depth x RLCT | #586: Model Merging x RLCT

;; NEXT: L2 novelty verification
