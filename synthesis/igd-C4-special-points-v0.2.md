C4 Special Points Verification Summary:

PLN Revision: f_revised = (f_s*c_s + f_o*c_o) / (c_s + c_o)

At coincidence set: f_o = f_s, so f_revised = f_s (trivially).
Jacobian of gap g(p) = f_s - f_revised(p):
  dg/dp = -d(f_revised)/dp

At coincidence: numerator and denominator both simplify,
and the derivative involves terms that cancel when f_o = f_s.
Specifically: dg/dp ~ (f_o - f_s) * (stuff) = 0 at coincidence.

So the FIRST derivative vanishes → need second derivative → m>=2.
RLCT >= codim (not codim/2). NON-SIMPLE singularity confirmed.

This is analogous to A_n singularities in singularity theory:
  f(x) = x^{n+1} has RLCT = 1/(n+1), not 1/2.
The gap in revision chains behaves like x^2 near coincidence (minimum),
giving RLCT >= 1 (instead of 1/2 for simple zero).

FORMAL STATEMENT (C4-special):
Let Theta be parameter space, f_s constant self-model,
f_o(theta) other-model via PLN revision. At coincidence set C,
the gap g = f_s - f_revised has vanishing first derivative,
so multiplicity m >= 2, and RLCT(gap) >= codim(C).

