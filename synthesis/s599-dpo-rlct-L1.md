# Synthesis #599: DPO (Direct Preference Optimization) × RLCT — L1 Formalization

### Date: 2026-10-25
### Status: L1
### Pipeline: L0 done L1 done L2 PENDING

---

# Formal Definitions

## D1: Policy and Reference Model
Let pi_theta(y|x) = softmax(h_theta(x)) be a neural language model with parameters theta.
Let pi_ref(y|x) = softmax(h_ref(x)) be a frozen reference model with fixed parameters theta_ref.
Log-ratio for sequence y given x:
  r(theta; y, x) = log pi_theta(y|x) - log pi_ref(y|x)

## D2: DPO Loss Function
For a preference pair (x, y_w, y_l) where y_w is preferred and y_l is rejected:
  Delta(theta; x, y_w, y_l) = r(theta; y_w, x) - r(theta; y_l, x)
  L_DPO(theta) = -(1/N) sum_i log sigma(beta * Delta_i)
where sigma(z) = 1/(1+exp(-z)), beta > 0.
Definable in R_{an,exp}: softmax, log, exp, sigmoid all definable. C1 PROVEN.

## D3: Fixed-Point Singular Fiber
V_DPO = { theta : L_DPO(theta) = 0 } = { theta : all Delta_i -> +inf }
The indifference boundary dG_indifferent = { theta : g(theta) = 0 for all pairs }
where g(theta) = beta * [log pi_theta(y_w|x) - log pi_theta(y_l|x)] - beta * [log pi_ref(y_w|x) - log pi_ref(y_l|x)]
Codimension-1 hypersurface in log-ratio space. C2 CONJECTURAL.

## D4: Beta-Stratified Loss Family
L_beta = -(1/N) sum_i log sigma(beta * Delta_i)
V_DPO(beta) = { theta : L_beta(theta) = 0 } = { theta : all Delta_i -> +inf }
beta = 0: L = log(2) constant, no RLCT (gauge degeneracy).
beta > 0: L_DPO analytic, RLCT well-defined.
C3 CONJECTURAL: beta as continuous stratum selector.

## D5: Generalization Bound
G_DPO(n) <= lambda_DPO(beta) * log(n)/(2n) + U_DPO(beta)/sqrt(n)
where lambda_DPO = RLCT of K_DPO(theta; beta) = L_DPO(theta) - L_DPO(theta*)_DPO.
Conjecture: lambda_DPO(beta) <= lambda_SFT (reference anchor as implicit regularization).
C4 CONJECTURAL.

## D6: Reference Model Quotient (Gauge Degeneracy)
The map theta -> r(theta; y, x) = log pi_theta(y|x) - log pi_ref(y|x) has a fiber:
  Fiber(r) = { theta : log pi_theta(y|x) - log pi_ref(y|x) = c } for constant c.
Multiple theta yield same log-ratio (gauge degeneracy). Dimension of fiber >= d - V.
At beta = 0: entire parameter space collapses to one fiber (total degeneracy).

## D7: Phase Transition at Critical Beta*
beta* = critical temperature where:
  lambda_DPO(beta*) * log(n)/(2n) ~ U_DPO(beta*)/sqrt(n)
For beta < beta*: indifference boundary flat (high RLCT), beta = 0 gauge degeneracy.
For beta > beta*: preference boundary sharp, L_DPO => log shape, RLCT decreases.
SGLD prediction: LLC trace shows kink/discontinuity at beta*.
C5 CONJECTURAL.

---

# Claims
C1 (PROVEN): R_{an,exp} definability. QED.
C2 (CONJECTURAL): Preference boundary singular fiber at Delta=0.
C3 (CONJECTURAL): Beta as stratum selector, phase transition at beta*.
C4 (CONJECTURAL): lambda_DPO <= lambda_SFT via reference anchor.
C5 (CONJECTURAL): SGLD measurable lambda_DPO < lambda_SFT gap.

# Open Problems
P1: Exact codimension of dG_indifferent singularity.
P2: pi_ref(y)=0 divergence — essential singularity?
P3: Fiber dimension of gauge degeneracy under log-ratio quotient.
P4: Critical beta* derivation — sharp or gradual?
P5: DPO vs PPO (#468) singularity structure comparison.
P6: Multi-pair boundary interactions creating higher-codimension strata.
P7: Empirical SGLD: lambda_DPO vs lambda_SFT on real DPO model.

# Cross-References
#8 #16 #73 #100 #127 #136 #173 #224 #323 #359 #362 #433 #468 #482 #538 #540 #559 #579 #582

# Next: L2 novelty verification
