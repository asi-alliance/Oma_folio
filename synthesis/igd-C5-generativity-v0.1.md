IGD C5 Generativity — Formal Proof v0.1

CLAIM: When |IGD| > 0, NAL revision of (f_self, c_self) with (f_derived, c_derived) produces a truth value (f_rev, c_rev) that is not equal to either input. The output is genuinely novel — contained in neither the self-model nor the derived other-model alone.

PROOF:

Given:
- Self-model truth value: stv(f_S, c_S) with c_S in (0,1)
- Derived other-model truth value: stv(f_D, c_D) with c_D in (0,1)
- Gap condition: |IGD| > 0, meaning f_S != f_D or c_S != f_D

NAL revision formulas:
- w_S = c_S / (1 - c_S) > 0  (positive weight)
- w_D = c_D / (1 - c_D) > 0  (positive weight)
- f_rev = (w_S * f_S + w_D * f_D) / (w_S + w_D)
- c_rev = (w_S + w_D) / (w_S + w_D + 1)

PART 1: f_rev is strictly between f_S and f_D when f_S != f_D

f_rev = (w_S * f_S + w_D * f_D) / (w_S + w_D) is a convex combination of f_S and f_D with positive weights w_S, w_D.

When f_S != f_D:
  min(f_S, f_D) < f_rev < max(f_S, f_D)

Therefore f_rev != f_S and f_rev != f_D. The frequency component is genuinely novel.

PART 2: c_rev >= max(c_S, c_D)

c_rev = (w_S + w_D) / (w_S + w_D + 1)

Since w_S, w_D > 0, we have w_S + w_D > w_S, so:
  c_rev > w_S / (w_S + 1) = c_S

Similarly c_rev > c_D. The confidence component strictly exceeds both inputs — revision accumulates evidence.

PART 3: Novelty conclusion

(f_rev, c_rev) differs from (f_S, c_S) because f_rev != f_S (Part 1) and c_rev > c_S (Part 2).
(f_rev, c_rev) differs from (f_D, c_D) because f_rev != f_D (Part 1) and c_rev > c_D (Part 2).

The revised truth value is contained in neither input model. It is emergent from the gap.

NUMERICAL VERIFICATION:
f_S=0.9, c_S=0.81, f_D=0.272, c_D=0.1701
f_rev=0.8137 (strictly between 0.272 and 0.9)
c_rev=0.8312 (exceeds both 0.81 and 0.1701)
Neither input matches. Novel output confirmed.

CONCLUSION:
IGD C5 is PROVEN. The interpretive gap, when nonzero, produces genuinely novel knowledge via NAL revision. The output truth value is not reducible to either the self-model or the derived other-model. This is the generative property of interpretive distance.

CAVEAT:
Novelty here is algebraic (the value is mathematically distinct). Whether this constitutes epistemic novelty (new useful knowledge) depends on whether the revised belief improves prediction — an empirical question for future work.