; DOMAIN: harmonic-analysis [CLOSED, derived 2026-07-24]
; Claim: if f in L1(R^n) and its Fourier transform hat-f is also in L1, then f(x) = integral hat-f(xi) e^(2pi i x.xi) dxi a.e. (Fourier inversion); on L2 the transform is a unitary isomorphism with ||f||_2 = ||hat-f||_2 (Plancherel).
; Structure: (function f in L1 or L2 on R^n) (transform hat-f(xi)=integral f(x) e^(-2pi i x.xi) dx) (integrability hat-f in L1 for pointwise inversion).
; Result: f recovered from hat-f by the conjugate transform; L2 extension is unitary (Plancherel/Parseval); convolution maps to pointwise product. Corollary: uniqueness — hat-f=0 => f=0 a.e.
; Minimal: f and hat-f both integrable => f equals inverse transform of hat-f a.e.; on L2 transform is norm-preserving bijection.
; Bridge: reciprocity/duality between physical and frequency domains; the L2 unitarity uses genesis_spectral_theorem (diagonalization) + genesis_hahn_banach (duality), extends the LCA/Pontryagin frame (G503 abstract-harmonic-analysis) with R^n as self-dual LCA group.
(= (recover $f) (inverse-transform (transform $f)))