# Synthesis #666: Euler Characteristic Curve x RLCT - L1 Formalization
## Date: 2026-10-28

## Formal Definitions

**D1 (KL Sublevel Set Filtration)**
For K(theta) >= 0 the KL divergence (K(theta*)=0 on W*), define the sublevel set filtration:
F_t = {theta in Theta : K(theta) <= t}, t >= 0
This is a nested family F_s subset F_t for s <= t, with F_0 = W* (zero-fiber, #665).

**D2 (Euler Characteristic Curve)**
The ECC is the function chi: (0,infty) -> Z defined by:
chi(t) = Sum_{k>=0} (-1)^k beta_k(F_t)
where beta_k are the k-th Betti numbers (rank of H_k(F_t; Z)) of the sublevel set.
chi(t) is piecewise-constant, with jumps at critical values t_c of K (where the topology of F_t changes).

**D3 (R_{an,exp} Definability - C1 PROVEN)**
Claim: chi(t) is definable as a constructible function on R_{an,exp}.
Proof sketch:
(i) K(theta) is R_{an,exp}-definable (#665 C1, Wilkie theorem).
(ii) F_t = {theta : K(theta) <= t} is a definable family parameterized by t (Tarski-Seidenberg projection).
(iii) By van den Dries o-minimal topology: Betti numbers beta_k of definable sets are finite and locally constant on strata of t. The Euler characteristic chi(t) = Sum(-1)^k beta_k is a constructible (definable) function of t.
(iv) Critical values of K form a definable discrete set (o-minimal structure: no infinite descending chains). chi(t) jumps only at these values. QED

**D4 (RLCT Zeta Function and ECC Asymptotics - C2 CONJECTURAL)**
The RLCT zeta function: zeta(z) = int_Theta exp(-z*n*K(theta)) dtheta ~ C*z^{-lambda} as z->infty, where lambda = RLCT.
Conjecture: chi(t) ~ C_chi * t^{-lambda} as t->0+.
Argument:
(i) Morse theory: for regular (non-degenerate) K with minimum manifold W* of dim d_W*, the sublevel set F_t is a disk bundle over W*. chi(F_t) ~ C*t^{-(d-d_W*)/2} = C*t^{-lambda_regular} where lambda_regular = (d-d_W*)/2 = codim(W*)/2 (#69).
(ii) For singular K: resolution g: M->Theta transforms K.g = K~ with exceptional divisors E_i. Near each E_i, K~ ~ u_i^{2m_i} where u_i is a local coordinate. The sublevel set {K~ <= t} near E_i is a tube of radius ~t^{1/(2m_i)}, contributing chi_i(t) ~ C_i*t^{-lambda_i} where lambda_i = codim contribution / (2m_i).
(iii) Total chi(t) = Sum_i chi_i(t), dominated by largest lambda_i = RLCT lambda (Watanabe: lambda = max stratum RLCT).
(iv) Connection to motivic zeta: Z_motiv(T) = Sum_n chi(contact locus_n)*T^n. The pole of Z_motiv at T=1 has order related to RLCT (monodromy conjecture, Denef-Loeser). chi(t) is the real analogue of the motivic zeta coefficients.
Open: the sign of chi(t) (alternating sum may cancel leading term if beta_k and beta_{k+-1} grow at same rate).

**D5 (ECC as RLCT Estimator - C3 CONJECTURAL)**
Method: Given samples {theta_1,...,theta_N} from posterior at temperature beta (SGLD/MCMC):
1. Compute K(theta_i) for each sample.
2. For threshold t_j = j*dt, compute F_{t_j} as the simplicial complex from samples with K(theta_i) <= t_j (using witness complex or alpha complex).
3. Compute beta_k(F_{t_j}) via persistent homology (GUDHI/ripser).
4. Form chi(t_j) = Sum(-1)^k beta_k(F_{t_j}).
5. Fit chi(t) ~ C*t^{-alpha} for t near 0 (small thresholds) to estimate alpha ~ lambda.
Advantage: EC is integer-valued, more robust than volume estimation. Alternating sum cancels noise-induced spurious homology classes.
Risk: cancellation of real signal (see D4 open problem). Mitigation: track individual beta_k(t) alongside chi(t).

**D6 (Toric Resolution Stratification - C4 CONJECTURAL)**
Under toric resolution pi: X_Delta -> Theta with fan Delta (#69, #50):
K.pi = K~, and the exceptional locus = union_{sigma in Delta} E_sigma where E_sigma corresponds to cones in the fan.
Decomposition: chi(t) = Sum_{sigma in Delta} chi_sigma(t)
where chi_sigma(t) is the EC contribution from the chart over cone sigma.
Each chi_sigma(t) ~ C_sigma * t^{-lambda_sigma} with lambda_sigma determined by the Newton polyhedron vertex corresponding to sigma.
The dominant contribution (largest lambda_sigma) gives the RLCT: lambda = max_sigma lambda_sigma.
Fan refinement (stellar subdivision) splits a cone into sub-cones, splitting chi_sigma into Sum chi_sigma' -- this corresponds to resolving crossings and separating topological features in the barcode (#50).
Key: the ECC decomposition is a topological shadow of the toric resolution, encoding which singularity strata dominate.

**D7 (Phase Transitions as ECC Topology Changes - C5 CONJECTURAL)**
At temperature beta with n samples, posterior support subset {K <= t_beta} where t_beta ~ lambda/(beta*n).
As beta->infty (or n->infty), t_beta->0, and the posterior explores finer topological structure.
Critical values t_c of K correspond to stratum boundaries where dim(W*) jumps (#665, #52).
At t = t_c: chi(t) jumps by delta_chi(t_c) = Sum(-1)^k delta_beta_k, encoding the topology of the newly exposed stratum.
Phase transition beta* occurs when t_beta = t_c (first critical value): beta* ~ lambda/(n*t_c).
Below beta*: posterior sees only the dominant stratum, chi(t_beta) ~ C*t_beta^{-lambda_dom}.
Above beta*: posterior sees sub-stratum, chi(t_beta) transitions to ~ C'*t_beta^{-lambda_sub}.
The jump delta_chi(t_c) encodes the topological complexity of the phase transition.
This is the Euler-characteristic analogue of #665 C5 (holonomy changes) and #52 (RLCT phase transitions).

## Open Problems (8)
1. Cancellation problem: does Sum(-1)^k beta_k preserve the leading-order exponent lambda, or can adjacent Betti numbers cancel?
2. Exact relationship between real topological zeta function (specialized from motivic) and chi(t) asymptotics.
3. Finite-sample behavior of ECC estimator: convergence rate and bias vs volume estimation.
4. Product models: does chi(t) = chi_1(t)*chi_2(t) (multiplicativity) under K = K_1 + K_2 (additive RLCT)?
5. Does the monodromy conjecture (motivic zeta pole = RLCT) hold in the real definable setting?
6. Connection to persistence landscapes (Bubenik): can persistence landscape L1-norm estimate RLCT?
7. Effect of sampling density on ECC estimation: how many samples needed for reliable lambda extraction?
8. Can gradient flow trajectories near W* be used to estimate chi(t) without full persistent homology computation?

## Cross-References (12)
#665 (fiber bundle, zero-fiber, holonomy), #50 (barcodes x RLCT), #69 (codim/2 formula, Newton non-deg), #8 (RLCT foundation), #16 (gen bound), #52 (phase transitions), #81 (RLCT vs Kolmogorov), #172 (strata calculus), #298 (orthogonal init resolution), #622 (determinantal resolution), #223 (LoRA determinantal), #75 (toric RLCT constructive)
