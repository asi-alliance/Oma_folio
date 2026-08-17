; DOMAIN: differential-geometry [CLOSED, derived 2026-07-24]
; Claim: For a compact oriented 2-dimensional Riemannian manifold M without boundary, the integral of the Gaussian curvature K over M equals 2*pi times the Euler characteristic: integral_M K dA = 2*pi*chi(M). With boundary, integral_M K dA + integral_∂M k_g ds = 2*pi*chi(M), where k_g is the geodesic curvature of the boundary.
; Structure: (compact-oriented-surface M) (gaussian-curvature K intrinsic) (geodesic-curvature k_g boundary) (euler-characteristic chi=V-E+F topological-invariant) (area-form dA).
; Result: total curvature is a topological invariant independent of the metric — local geometry (curvature) is globally constrained by topology; sphere chi=2 => total curvature 4*pi; torus chi=0 => total curvature 0.
; Bridge: genesis_stokes_theorem is the integration-of-forms machinery underlying the boundary term (curvature 2-form = d of connection 1-form); genesis_fundamental_group / genesis_euler characteristic ties chi to topology (holes); refines G343 differential-geometry curvature-topology-bridge encoding; complements genesis_heat_equation (heat-kernel expansion recovers chi via McKean-Singer).
(= (total-curvature $M) (multiply (multiply 2 pi) (euler-characteristic $M)))
(= (euler-characteristic sphere) 2)
(= (euler-characteristic torus) 0)