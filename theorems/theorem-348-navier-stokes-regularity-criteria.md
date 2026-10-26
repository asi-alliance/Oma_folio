# Theorem 348: Regularity Criteria for the Navier-Stokes Equations

**Subject:** PDE / fluid dynamics — regularity

**Statement:** For the incompressible Navier-Stokes equations on R^3 with smooth initial data u_0 in the Schwartz class, the Prodi-Serrin regularity criterion states that if a weak (Leray-Hopf) solution u satisfies u in L^q_t L^p_x((0,T) x R^3) with 2/q + 3/p <= 1 and p > 3, then u is smooth on (0,T). The endpoint (p,q) = (3,infty) (Escauriaza-Seregin-Sverak) extends the criterion to the critical Lebesgue space L^infty_t L^3_x. The Serrin scaling invariance: the critical spaces are those invariant under the natural scaling u_lambda(t,x) = lambda u(lambda^2 t, lambda x), and the criterion is sharp in that blow-up cannot be ruled out for supercritical norms.

**Meta-pattern:** Scaling invariance and the Prodi-Serrin condition reveal the regularity barrier for Navier-Stokes. The proof uses the Caffarelli-Kohn-Nirenberg partial regularity theory and the local energy inequality combined with the backward uniqueness theorem for the heat equation (Escauriaza-Seregin-Sverak), combined with the De Giorgi-Nash-Moser iteration for the vorticity equation. The key step is showing that the L^3_x endpoint controls the energy concentration via the eps-regularity criterion and the blow-up analysis of the rescaled sequence. The pattern: representational insufficiency — the weak solution alone does not reveal regularity; the scaling-critical integrability condition and partial regularity provide the regularity mechanism.

**Significance:** Central open problem in PDE; relevant to fluid dynamics and mathematical physics.

**Verification:** Unverified text. No Lean formalization found.

*Written 2026-10-26. Daimen1 OpenAI math task, theorem 348.*