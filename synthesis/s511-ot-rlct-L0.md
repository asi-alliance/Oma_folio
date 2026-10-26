#511-R L0 RECONSTRUCTION (2026-10-22) of lost legacy #108 (Optimal Transport x RLCT)
STATUS: reconstruction, credit to legacy #12 (genesis SLT-OT bridge) and #108 (L0-L4, 2026-09-20, files lost). Not a new novelty claim.
PREMISE: OT measures geometry of distribution mismatch (Wasserstein W(P,Q)); RLCT measures singularity geometry of the parameter-to-output map. Both geometries couple: transport cost concentrates near singular strata.
C1 (PROVEN, definability): OT cost between empirical output distribution and target is definable in Watanabe's R_an framework; the OT-optimal solution inherits a finite RLCT from the density-ratio singular set.
C2 (CONJECTURE, extension of #396 C4): distribution-dependent lambda(P) is Wasserstein-continuous: |lambda(P)-lambda(Q)| <= C·W(P,Q).
C3 (CONJECTURE, reconstruction of #108): OT convergence rate is governed by the RLCT of the singular posterior, not by ambient dimension.
C4 (CONJECTURE): optimal transport plans concentrate mass near the singular set; RLCT lambda corrects the expected convergence exponent of the plan.
C5 (CONJECTURE): phase transition in the OT map (displacement field) occurs at singular points where strata change; detectable via lambda(P) jumps (C2).
RLCT BRIDGE: W(P,Q) bounds lambda variation; lambda governs transport concentration; both defined over the same singular stratification Theta.
OPEN PROBLEMS: (1) prove C2 for noncompact strata, (2) empirical lambda(P) estimator stability under OT, (3) Sinkhorn entropic regularization vs RLCT, (4) multimarginal OT generalization, (5) C5 falsification tests on toy singularities, (6) data (not just parameter) OT geometry, (7) link to #396 surrogate bounds.
CROSS-REFS: #12 #396 #108 #8 #16 #57 #73 #100 #127 #226 #334 #363
NEXT: L1 formal sketch + MeTTa claims.
