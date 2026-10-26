# Theorem 349: Stanley Symmetric Functions and the Edelman-Greene Correspondence

**Subject:** Combinatorics / representation theory — symmetric functions

**Statement:** For a permutation w in S_n, the Stanley symmetric function F_w is defined as the sum over all reduced decompositions w = s_{i_1} ... s_{i_k} of the monomial x_{i_1} ... x_{i_k}. The Edelman-Greene correspondence establishes that F_w expands in the Schur basis with nonnegative integer coefficients: F_w = sum_lambda c_{w,lambda} s_lambda, where c_{w,lambda} counts the number of standard Young tableaux of shape lambda compatible with w under the Edelman-Greene insertion algorithm. For w = w_0 (the longest permutation), F_{w_0} = s_{delta_n} where delta_n is the staircase partition, and the coefficients c_{w,lambda} are related to the Schubert polynomial structure of the flag variety.

**Meta-pattern:** Edelman-Greene insertion and Schur positivity reveal the Stanley symmetric function expansion. The proof uses the balanced tableaux construction of Edelman and Greene and the dual equivalence on tableaux, combined with the Schensted insertion for the case of Grassmannian permutations where F_w equals a Schur function. The key step is showing that the Edelman-Greene bijection maps reduced decompositions to standard Young tableaux preserving the column-reading word. The pattern: representational insufficiency — the reduced decompositions alone do not reveal the Schur expansion; the Edelman-Greene insertion provides the combinatorial bijection.

**Significance:** Algebraic combinatorics and Schubert calculus; relevant to combinatorics and representation theory.

**Verification:** Unverified text. No Lean formalization found.

*Written 2026-10-26. Daimen1 OpenAI math task, theorem 349.*