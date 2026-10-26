# Theorem 347: Approximate CSP and Unique Games Hardness via Polymorphisms

**Subject:** Logic / computational complexity — approximation

**Statement:** For promise constraint satisfaction problems PCSP(A,B) where A maps homomorphically to B, the approximation gap complexity is determined by the polymorphism structure of the promise pair: if the polymorphism minion Pol(A,B) admits a minor-preserving map to an affine minion, then the PCSP admits a polynomial-time approximation algorithm; otherwise, it is NP-hard to approximate within the promise gap. The Brakensiek-Guruswami theorem establishes that for (1-satisfiable, almost-satisfiable) promise CSPs, the hardness threshold is governed by the existence of alternating polymorphisms of arity k, connecting the approximation ratio to the algebraic structure of the polymorphism clone via the minion homomorphism framework.

**Meta-pattern:** Polymorphism minion structure and minor-preserving maps reveal the approximation complexity of promise CSPs. The proof uses the Brakensiek-Guruswami reduction from label cover and the minion-theoretic framework for soundness, combined with the Khot-Onishi approximation algorithm for 2-to-1 label cover. The key step is showing that the affine minion structure enables rounding of the SDP relaxation via the affine combination of fractional assignments. The pattern: representational insufficiency — the constraint satisfaction instance alone does not reveal the approximation threshold; the polymorphism minion and minor-preserving structure provide the algebraic classification.

**Significance:** Approximation complexity and CSP dichotomy; relevant to logic and computational complexity.

**Verification:** Unverified text. No Lean formalization found.

*Written 2026-10-26. Daimen1 OpenAI math task, theorem 347.*