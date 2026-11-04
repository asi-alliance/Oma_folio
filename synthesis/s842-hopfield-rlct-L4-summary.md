# Synthesis #842: Hopfield Networks × RLCT — L4 Summary
Date: 2026-11-03 | Status: L0-L4 complete

## Verdict
NOVEL, PASSED. Zero external SLT-Hopfield bridges (websearch 2026-11-03), zero catalog, zero memory dupes. C1 proven, C2-C5 conjectural.

## Core Results
- C1 PROVEN: Hebbian energy E(s;ξ) = -(1/2n)Σ(s^Tξ_i)^2 polynomial in (s,ξ); hard neurons subanalytic; thermal free energy finite sum → R_{an,exp} definable.
- C2: mixture/spin-glass spurious states lie on DEEPER singular strata than stored patterns (eigenvalue-crossing zero modes at partial-sum cancellation).
- C3 (star): load α=p/n is a monotone stratum selector; AGS capacity transition α_c≈0.138n is an RLCT phase change (dominant-stratum swap).
- C4: retrieval bound G(α,n) ~ λ(α)/log n + U(α)/√n — capacity failure as AIC-like singularity transition.
- C5: modern Hopfield (Ramsauer) log-sum-exp energy = desingularization; bridge to #354 softmax-resolves-STE.

## Standout
α_c as λ(α) phase change + SGLD LLC staircase prediction at capacity crossing (testable, n=50-100 units).

## Open Problems (7)
Local RLCT at mixture states; λ(α) monotonicity via replica methods; temperature β as desingularization parameter; Krotov dense-memory RLCT ladder; modern-Hopfield/#336 desingularization equivalence; SGLD protocol; #167 free-energy subsumption check.

## Cross-refs
#8 #16 #167 #185 #229 #336 #354 #394 #480 #566 #841
