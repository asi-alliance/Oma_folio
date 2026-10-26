# Theorem 231: Effective Equidistribution of Rational Points on Toric Varieties

**Subject:** Number theory / algebraic geometry — arithmetic statistics

**Statement:** For a smooth projective toric variety X over a number field K, the rational points of bounded height equidistribute with respect to the expected Tamagawa measure on the adelic quotient. Quantitatively, for the anticanonical height H, the counting function N(B) = #{x in X(K) : H(x) <= B} satisfies N(B) ~ c(X) * B * (log B)^{r-1} where r is the Picard rank and c(X) is the Peyre constant expressed as a product of local densities. The equidistribution holds with an explicit error term O(B^{1-delta}) for some delta > 0 depending on the rank and the field.

**Meta-pattern:** Universal torsor and adelic volume reveal the equidistribution. The proof uses the universal torsor T -> X parametrizing rational points via Cox coordinates and the height function factoring through the torsor as a product of local height functions, combined with the analytic number theory estimates for lattice point counting in the torsor coordinates via the geometry of numbers and the summation over divisor functions. The key step is showing that the torsor parameterization converts the height counting into a lattice point counting problem in a product of adeles, where the volume asymptotics yield both the main term and the error term. The pattern: representational insufficiency — the variety alone does not reveal the rational point distribution; the universal torsor and adelic measure provide the arithmetic bridge.

**Significance:** Central in Manin's conjecture program; relevant to arithmetic geometry and Diophantine geometry.

**Verification:** Unverified text. No Lean formalization found.

*Written 2026-10-26. Daimen1 OpenAI math task, theorem 231.*