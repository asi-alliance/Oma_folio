;; Synthesis #612: DropConnect × RLCT -- L0 Exploration
;; Date: 2026-10-25
;; Status: L0 START
;; Candidate: DropConnect (Wan et al. 2013) × Singular Learning Theory
;; Prior coverage: ZERO (catalog grep 0, websearch 0)

;; DISTINCTION FROM PRIOR SYNTHESSES
;; #506/#169 Dropout: Bernoulli mask on ACTIVATIONS (a = f(Wx) ⊙ m, m~Bern(p))
;;   → Each mask selects a SUBNETWORK (subset of active units)
;;   → Singular fiber = union of 2^L sub-network fibers
;; #239 DropConnect (earlier ref): Bernoulli mask on WEIGHTS (y = (W⊙M)x, M~Bern(p))
;;   → Each mask selects a SUB-MATRIX of the weight matrix
;;   → Weight-space stratum = coordinate subspace of parameter space
;; #612 DropConnect (THIS): Formal SLT analysis of weight masking
;;   → Each weight mask M realization zeroes specific entries of W
;;   → Parameter space stratum: {w : w_ij = 0 for (i,j) ∈ supp(M^c)}
;;   → This is a COORDINATE SUBSPACE of R^{d_in × d_out}
;;   → Distinct from dropout: dropout acts in ACTIVATION space (post-nonlinearity),
;;     DropConnect acts in PARAMETER space (pre-activation)

;; KEY INSIGHT: DropConnect creates a DIRECT singular stratum in parameter space
;; Unlike dropout (which selects subnetworks with inherited singularities),
;; DropConnect zeroes weight entries directly, creating coordinate hyperplane
;; intersections in W-space. Each mask realization M defines:
;;   V_M = {w ∈ R^{d_in×d_out} : w_ij = 0 ∀(i,j) where M_ij = 0}
;; This is a linear subspace of dimension |supp(M)| = p·d_in·d_out.
;; The RLCT of V_M is a function of the mask support pattern.

;; C1 (R_an,exp definability): DropConnect loss = E_M[L((W⊙M)x, y)]
;;   = Σ_M p(M) · L(W⊙M, x, y) where p(M) = p^{|supp(M)|} (1-p)^{d-|supp(M)|}
;;   Each L(W⊙M) is analytic (composition of analytic loss with bilinear W⊙M)
;;   Finite sum of analytic functions → analytic → R_an,exp definable
;;   PROVEN (C1)

;; C2 (Coordinate subspace stratum): Each mask M defines a coordinate subspace
;;   V_M ⊂ R^d where d = d_in·d_out. The singular fiber of the masked network
;;   is the restriction of the full fiber to V_M.
;;   CONJECTURAL: RLCT(V_M) ≤ RLCT(V_full) for generic masks
;;   (restriction to subspace can only reduce or preserve RLCT)

;; C3 (Mask support as stratum selector): DropConnect rate p controls:
;;   - Expected subspace dimension E[|supp(M)|] = p·d
;;   - Variance of subspace dimension = p(1-p)·d
;;   - Lower p → smaller subspaces → potentially deeper singularities
;;   CONJECTURAL: optimal p* minimizes effective RLCT

;; C4 (Generalization bound): For DropConnect with rate p:
;;   G_dropconnect ≤ λ_eff(p) / (2n) where λ_eff(p) = E_M[RLCT(V_M)]
;;   CONJECTURAL: λ_eff(p) is monotone non-increasing in p
;;   (more masking → smaller subspaces → lower RLCT → better generalization bound)
;;   But also less capacity → higher empirical loss. Trade-off at p*.

;; C5 (p* phase transition): Critical p* where RLCT reduction balances
;;   capacity loss. At p → 1: no masking, full network RLCT.
;;   At p → 0: near-trivial network, RLCT → 0 but loss → high.
;;   CONJECTURAL: p* exists and scales with model complexity d.

;; DISTINCTION FROM DROPOUT (#506):
;; Dropout: mask in activation space → subnetwork selection → fiber UNION
;; DropConnect: mask in weight space → coordinate subspace → fiber RESTRICTION
;; Dropout RLCT = min over subnetwork fibers (union structure)
;; DropConnect RLCT = E_M[RLCT of restricted fiber] (subspace structure)
;; These are fundamentally different singular geometries.

;; NEXT: L1 formalization
