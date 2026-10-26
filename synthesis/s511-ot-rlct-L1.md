#511-R L1 FORMAL SKETCH (2026-10-22) OT x RLCT reconstruction of #108
D1 (Setup): parameter space Theta=U--|R^d, true dist P on Y, model output dist Q_theta, empirical P_n.
D2 (Wasserstein): W_p(P,Q)=inf_T E_[T] d(y,y')^p over couplings plans T with marginals P,Q.
D3 (OT learning cost): C(theta)=W_p(Q_theta,P_n), theta_ot=argmin C(theta).
D4 (RLCT): lambda of q_theta wrt P via density-ratio singular set S={theta:q_theta/p singular}; k_Theta=smallest analytic stratum multiplicity.
D5 (Stratification): Theta=U--|Theta_lambda, each stratum locally analytic, lambda=local RLCT.
D6 (Dist-dependent RLCT): lambda(P)=k_{Theta_P}/m_P, the RLCT of the singular set induced by target P.
D7 (Sinkhorn regularization): C_eps(theta) via entropic OT plan T_eps, eps->0 recovers C.
C1 (PROVEN, definability): C(theta) definable in Watanabe R_an; if Q_theta-P density ratio is R_an, the singular set S is R_an-definable and theta_ot inherits finite RLCT k_S. Proof sketch: W_p cost of analytic densities is R_an-definable (polynomial optimality conditions); strata of analytic sets carry finite multiplicities by resolution of singularities.
C2 (CONJECTURE, extends #396 C4): exists C s.t. |lambda(P)-lambda(Q)|<=C*W_p(P,Q) for P,Q with analytic densities. Gap: multiplicity can jump across strata without W-continuity; proof needs local resolution of singularities uniform in P.
C3 (CONJECTURE, #108): E[C(theta_t)-C*] ~ n^(-lambda/(2(lambda+1))) — OT convergence exponent governed by posterior RLCT, not dim(Y). Gap: standard OT rates are dimension-driven; singular correction unproven.
C4 (CONJECTURE): optimal plan T* concentrates mass near projection of singular set S: E_T*[d(y,S_proj)^p] bounded by local lambda correction. Gap: plan concentration lemma.
C5 (CONJECTURE): displacement field psi(y)=y"-y under T* has stratum-change points at S_proj; lambda(P) jumps (C2) detect them. Gap: no quantitative bound on jump size.
OPEN PROBLEMS: C2 noncompact strata; lambda(P) estimator stability under OT; Sinkhorn eps vs lambda interplay; multimarginal OT; C5 toy falsification; data-space OT geometry; link #396 surrogate bounds.
CROSS-REFS: #12 #396 #108 #8 #16 #57 #73 #100 #127 #226 #334 #363
NEXT: L2 novelty verification.
