; DOMAIN: linear-algebra [CLOSED, derived 2026-07-24]
; Claim: a real symmetric (Hermitian) operator on a finite-dimensional inner-product space has an orthonormal basis of eigenvectors with real eigenvalues (spectral theorem).
; Structure: (inner-product-space V) (self-adjoint A, A=A*).
; Result: A = sum_i lambda_i P_i, lambda_i real, P_i orthogonal projections, sum P_i = I, P_i P_j = 0 (i!=j).
; Minimal: self-adjointness => orthogonal diagonalizability with real spectrum.
; Bridge: diagonalization/decomposition principle; finite-dim analogue enabling Banach-iteration convergence-rate analysis via eigenvalue moduli.
(= (diagonalize $A) (spectral-decomposition $A))