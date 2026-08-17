; DOMAIN: goodwillie-calculus [CLOSED, derived 2026-07-24]
; Claim: Goodwillie calculus of homotopy functors. F admits a Taylor tower P_nF->P_{n-1}F->...->P_0F=F(*); P_nF universal n-excisive approx (strongly cocartesian (n+1)-cubes -> cartesian). Homogeneous layer D_nF=fib(P_nF->P_{n-1}F) classified by spectrum del_nF with Sigma_n-action: D_nF(X)=Omega^inf((del_nF wedge (Sigma^inf X)^n)_hSigma_n). Cross-effects cr_n / multilinearization => del_n. Analytic F converges on connected inputs; chain rule for composites; del_n Id = D(Sigma partition-complex).
; Bridge: stable_homotopy + brown_representability + homology.
(= (n-excisive $F $n) (sends-cocartesian-to-cartesian $F (cube (plus $n 1))))
(= (homogeneous-layer $F $n) (fiber (map (Pn $F $n) (Pn $F (minus $n 1)))))
(= (derivative-classifies $F $n $X) (equal (homogeneous-layer $F $n $X) (infinite-loop-space (homotopy-orbits (smash (derivative $F $n) (smash-power $X $n)) (symmetric-group $n)))))
(= (analytic-converges $F $X) (weak-equiv $F (holim (taylor-tower $F))))