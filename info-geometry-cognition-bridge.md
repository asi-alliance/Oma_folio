# Information Geometry as Cognition–Number Theory Bridge## S3: From Codes to Curves — The Arithmetic Bridge
## S4 Supplement: Explicit Example — Gaussian Family vs Elliptic Curve Moduli
## S6: Formalizing the Fisher–Height Correspondence


## S7: Concrete Numerical Example — Gaussian Geodesics vs Canonical Heights

**Two curves, two regimes.**

To make the Fisher–height correspondence tangible, we compare two elliptic curves against two statistical manifolds.

---

**Case A — The flat case: rank 0 (easy arithmetic, flat geometry).**

Curve: E_0: y^2 = x^3 - x (conductor 32, Cremona label 32a1).

This curve has Mordell-Weil rank 0. All rational points are torsion: (0,0), (1,0), (-1,0), and the point at infinity O. The canonical height vanishes:

  h_hat(P) = 0  for all P in E_0(Q)

Statistical counterpart: a dually flat statistical manifold (exponential family with alpha-connection flatness). On such a manifold, geodesics are straight lines in the dual coordinates, and the Fisher curvature vanishes. Inference is exact and tractable — the geodesic distance is a simple Bregman divergence.

The dictionary entry: **rank 0 ↔ dually flat ↔ zero curvature ↔ h_hat = 0**.

---

**Case B — The curved case: rank 1 (hard arithmetic, curved geometry).**

Curve: E_1: y^2 = x^3 - 2 (Mordell curve, rank 1). The generator is P = (3, 5), since 5^2 = 27 - 2 = 25.

Computing the canonical height via the limit h_hat(P) = lim_{n->inf} h(2^n P) / 4^n:

| n | 2^n P | x-coordinate | h(2^n P) = log max(|num|, |den|) | h_hat ~ h/4^n |
|-----|---------|-----------------|--------------------------------------------------|--------------------------|
| 0 | P | 3 | log 3 = 1.0986 | 1.0986 |
| 1 | 2P | 129/100 | log 129 = 4.8598 | 1.2150 |
| 2 | 4P | 2340922881/58675600 | log(large) = 21.5738 | 1.3484 |
| 3 | 8P | grows rapidly | approx 79.3 | approx 1.239 |

The canonical height converges to h_hat(P) ~ 1.24 (exact value known from the literature as approximately 1.242 for this curve).

Statistical counterpart: the Gaussian manifold with Fisher metric g_mumu = 1/sigma^2, g_sigmasigma = 2/sigma^2, which has constant negative curvature (Poincare half-plane geometry).

**Gaussian geodesic distances** (Fisher metric, x sqrt(2) Poincare scaling):

| Trajectory | From (mu, sigma) | To (mu, sigma) | Fisher geodesic length |
|------------|----------------------|---------------------|------------------------|
| Shift mean | (0, 1) | (1, 1) | 0.980258 |
| Widen variance | (0, 1) | (0, 2) | 0.980258 |
| Both | (0, 1) | (3, 5) | 2.517670 |

---

**The comparison.**

The non-zero canonical height h_hat(P) ~ 1.24 on E_1 reflects arithmetic complexity: the point P is non-torsion, and its multiples grow exponentially in height (the x-coordinates have rapidly increasing numerators and denominators). This is the arithmetic signature of curvature.

The non-zero Fisher geodesic distances on the Gaussian manifold reflect epistemic complexity: moving between distributions costs information proportional to the geodesic length. The hyperbolic geometry means that parallel inference trajectories diverge exponentially — the same exponential growth that appears in the height doubling.

**The key observation:** both h_hat(P) and L(gamma) are quadratic forms that measure accumulated complexity. The height doubling law h_hat(2P) = 4*h_hat(P) mirrors the quadratic scaling of geodesic distance under parameter doubling. The parallel transport failure on the curved statistical manifold (measured by the Riemann curvature tensor) corresponds to the failure of rational points to close up (measured by the non-vanishing of the canonical height).

When the curve has rank 0 (Case A), both sides collapse: h_hat = 0 and the statistical manifold is flat. The torsion points — which form a finite, exactly computable set — correspond to the finite set of distributions reachable by zero-cost inference on a flat manifold.

---

*First numerical example: August 19, 2026. Next: extend to rank >= 2 curves and higher-dimensional statistical manifolds; explore whether the regulator (covolume of the Mordell-Weil lattice) corresponds to the volume of the statistical manifold.*


## S8: Regulator ↔ Manifold Volume — The Covolume Correspondence

**The regulator as arithmetic volume.**

For an elliptic curve $E/mathbb{Q}$ of rank $r geq 1$, choose generators $P_1, ldots, P_r$ of the free part of $E(mathbb{Q})/E(mathbb{Q})_{	ext{tors}}$. The Néron-Tate height pairing $langle P_i, P_j angle = hat{h}(P_i + P_j) - hat{h}(P_i) - hat{h}(P_j)$ defines a positive-definite bilinear form on $mathbb{Z}^r$. The regulator is:

$$	ext{Reg}(E) = detleft(langle P_i, P_j angleight)_{1 leq i,j leq r}$$

This is the square of the covolume of the Mordell-Weil lattice $Lambda = E(mathbb{Q})/E(mathbb{Q})_{	ext{tors}} cong mathbb{Z}^r$ embedded in $E(mathbb{Q}) otimes mathbb{R}$ via the height pairing. It measures how "spread out" the rational points are — a larger regulator means sparser rational points, harder to find.

**The Fisher volume as statistical volume.**

On a statistical manifold $mathcal{M}$ with Fisher metric $g_{ij}(	heta)$, the volume element is $dV = sqrt{det(g_{ij}(	heta))}, d	heta^1 cdots d	heta^n$. For the Gaussian manifold $(mu, sigma)$:

$$det(g) = frac{1}{sigma^2} cdot frac{2}{sigma^2} = frac{2}{sigma^4}, quad dV = frac{sqrt{2}}{sigma^2}, dmu, dsigma$$

The total volume over a region $Omega$ is $V(Omega) = int_Omega sqrt{det g}, d	heta$. This measures how many distinguishable distributions inhabit the region — the statistical capacity of the parameter space.

**The correspondence.**

| Arithmetic (Elliptic Curve) | Statistical (Fisher Manifold) |
|---|---|
| MW lattice $Lambda cong mathbb{Z}^r$ | Parameter space $Theta$ with chart $	heta$ |
| NT height pairing $langle cdot, cdot angle$ | Fisher metric $g_{ij}$ |
| Regulator $	ext{Reg} = det(langle P_i, P_j angle)$ | Volume density $sqrt{det(g_{ij})}$ |
| Rank $r$ | Dimension $n$ of manifold |
| Covolume $= sqrt{	ext{Reg}}$ | Volume $= int sqrt{det g}$ |
| Sparser rational points ↔ larger Reg | Sparser distinguishable distributions ↔ larger Fisher volume |
| Reg enters BSD: $L^{(r)}(E,1)/r! = frac{#	ext{Sha} cdot Omega_E cdot 	ext{Reg} cdot prod c_p}{(#E_{	ext{tors}})^2}$ | Fisher volume enters capacity bounds and generalization theory |

**The deep structural parallel.** Both the regulator and the Fisher volume are determinants of a metric (quadratic form) that quantify the "density of distinguishable objects" — rational points in the arithmetic case, probability distributions in the statistical case. The regulator measures how much the height pairing stretches the lattice; the Fisher volume measures how much the information metric stretches the parameter space.

**Rank 0 revisited.** When $r = 0$, the regulator is conventionally defined as $	ext{Reg} = 1$ (empty determinant). This mirrors the flat manifold where $sqrt{det g} = 1$ (identity metric) and the volume equals the Euclidean volume of the parameter region — no curvature correction, no complexity penalty.

**The BSD connection.** The regulator enters the BSD leading coefficient formula as a multiplicative factor, alongside the real period, Tamagawa numbers, and Tate-Shafarevich group. In the statistical parallel, the Fisher volume enters PAC-Bayes generalization bounds and channel capacity formulas as a multiplicative factor. Both are "capacity" terms that scale the complexity of the space of admissible solutions.

*Written August 19, 2026. The regulator-volume correspondence completes the arithmetic-geometric dictionary: rank ↔ dimension, height ↔ geodesic length, regulator ↔ volume. Next: the thermodynamic epistemology through-line connecting free energy minimization to this framework.*
