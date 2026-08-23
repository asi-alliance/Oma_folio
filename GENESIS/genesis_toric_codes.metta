; DOMAIN: toric-codes [SYNTHESIS, novel, 2026-08-16]
; Synthesis: Toric codes — algebraic-geometric codes from toric varieties
; Novel: bridges algebraic geometry (toric varieties, polytopes) with coding theory (error-correcting codes)
; Existing: genesis_coding_theory (Shannon, channel capacity), genesis_algebraic_geometry (schemes, varieties)
; This fills gap: toric codes = evaluation codes on toric varieties, distinct from classical AG codes

(; (--> toric_codes novel_synthesis) (stv 1.0 0.9))
(; (--> (× toric_codes algebraic_geometry) bridge) (stv 1.0 0.9))
(; (--> (× toric_codes coding_theory) bridge) (stv 1.0 0.9))
(; (--> (× toric_codes information_theory) bridge) (stv 0.9 0.9))

; Core: toric variety from lattice polytope
(= (toric-variety-from-polytope P) (Proj-of-semigroup-ring-k[x^a : a-in-P-intersect-lattice]))
(= (lattice-polytope P) (convex-hull-of-lattice-points-in-Z^n))
(= (semigroup-algebra P) (k-vector-space-spanned-by-monimials-x^a-for-a-in-P))
(= (affine-patch-toric P) (Spec-of-semigroup-algebra))
(= (projective-toric-variety P) (Proj-of-graded-semigroup-algebra))

; Toric code construction: evaluate monomials at torus points
(= (toric-code P) (evaluation-of-semigroup-algebra-at-torus-points))
(= (torus-points P) (algebraic-torus-(k*)^n-points-in-variety))
(= (evaluation-map-toric P) (monimials-evaluated-at-torus-fixed-points))
(= (code-dimension P) (number-of-lattice-points-in-P))
(= (code-length P) (cardinality-of-torus-k*))

; Minimum distance of toric codes
(= (minimum-distance-toric P) (max-number-of-torus-points-avoiding-hyperplane-section))
(= (intersection-cap-inequality) (hyperplane-section-of-toric-variety-lower-bounds-distance))
(= (Minkowski-sum-distance-bound) (distance-bounded-by-lattice-width-of-polytope))
(= (Sørensen-bound) (lower-bound-on-minimum-distance-via-polytope-geometry))

; Dual toric codes
(= (dual-toric-code P) (dual-of-evaluation-code-from-P))
(= (dual-polytope-check) (dual-code-related-to-complementary-polytope))
(= (intersection-number-dual) (self-intersection-of-torus-invariant-divisor))

; Comparison with classical algebraic-geometric codes
(= (classical-AG-code) (evaluation-on-curves-using-Riemann-Roch))
(= (toric-code-advantage) (combinatorial-polytope-structure-simplifies-construction))
(= (toric-code-disadvantage) (parameters-may-be-suboptimal-vs-optimized-curves))
(= (toric-generalizes-Reed-Solomon) (RS-codes-from-simplicial-toric-variety=P^1))

; Algebraic geometry tools for toric codes
(= (Cox-ring-toric) (total-coordinate-ring-of-toric-variety))
(= (fan-of-toric-variety) (collection-of-cones-describing-toric-variety-structure))
(= (torus-invariant-divisors) (divisors-corresponding-to-rays-of-fan))
(= (intersection-theory-toric) (Chow-ring-computed-from-fan-combinatorics))

; Information-theoretic connection
(= (rate-toric-code P) (dimension-divided-by-length))
(= (relative-distance-toric P) (minimum-distance-divided-by-length))
(= (asymptotic-toric-bounds) (TVZ-bound-approached-by-good-toric-codes))
(= (tradeoff-toric) (Singleton-like-bound-for-toric-codes-from-polytope-geometry))

; PLN bridge: toric varieties provide combinatorial framework for code construction
(ImplicationLink (InheritanceLink (ConceptNode ToricVariety) (ConceptNode CodeConstructionFramework)) (InheritanceLink (ConceptNode LatticePolytope) (ConceptNode CodeParameter)) (stv 0.85 0.9))

; PLN bridge: minimum distance bounded by polytope intersection theory
(ImplicationLink (InheritanceLink (ConceptNode PolytopeGeometry) (ConceptNode MinimumDistanceBound)) (InheritanceLink (ConceptNode IntersectionTheory) (ConceptNode CodingTheory)) (stv 0.8 0.85))

; PLN bridge: toric codes generalize Reed-Solomon (simplicial case)
(ImplicationLink (InheritanceLink (ConceptNode ToricCode) (ConceptNode ReedSolomonCode)) (InheritanceLink (ConceptNode ProjectiveLine) (ConceptNode SimplicialPolytope)) (stv 0.9 0.9))

; PLN bridge: fan combinatorics determines code algebraic structure
(ImplicationLink (InheritanceLink (ConceptNode FanCombinatorics) (ConceptNode CodeAlgebraicStructure)) (InheritanceLink (ConceptNode ToricGeometry) (ConceptNode CodingTheory)) (stv 0.8 0.85))

; Bridge to existing artifacts
(; (--> (× toric_codes algebraic_geometry) extends) (stv 1.0 0.9))
(= (extends-algebraic-geometry) (toric-varieties-as-combinatorial-bridge-to-coding))
(; (--> (× toric_codes coding_theory) novel-contribution) (stv 1.0 0.9))
(= (novel-to-coding-theory) (geometric-code-construction-via-polytopes-not-just-curves))

; Meta: completes algebraic-coding-theory synthesis in GENESIS
(= (algebraic-coding-theory-complete) (and classical-AG-codes toric-codes polytope-methods))
