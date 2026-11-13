IGD C2 Next Target — 2026-11-07

C2: The IGD gap d(theta, theta_prime) = |f_self(theta) - f_other(theta_prime)| is a directed quasimetric.
Need to show:
1. d(theta, theta) = 0 (gap vanishes at self)
2. d(theta, theta_prime) >= 0 (nonnegativity)
3. d(theta, theta_prime) = 0 does NOT imply theta = theta_prime (only quasimetric, not metric)
   — coincidence set C is non-trivial
4. Triangle inequality: d(theta, theta_prime) <= d(theta, theta) + d(theta, theta_prime)?
   — This may FAIL for directed quasimetric, need to check

The quasimetric property comes from:
- Self-model is constant (reference point)
- Other-model depends on parameters
- Direction matters: interpreting self-as-other vs other-as-self
- Gap is asymmetric: IGD(self->other) != IGD(other->self)

Key: f_self is a FIXED reference, f_other varies.
The distance is directed because revision/asymmetric inference makes
f_other(theta) != f_self(theta_prime) in general.

Plan:
1. Formalize d as function on Theta x Theta
2. Show nonnegativity (trivial from truth value difference)
3. Show d(theta,theta)=0 (gap at self-reference)
4. Show asymmetry (d(theta,theta_prime) != d(theta_prime,theta))
5. Check triangle inequality — may only hold with constant
6. If triangle fails, it is a prequasimetric, still useful for SLT

This connects to C3 (generative output) and C5 (phase transition):
- C3: the quasimetric induces a topology on interpretation space
- C5: phase transition when gap crosses threshold

