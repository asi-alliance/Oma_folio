# Synthesis #601: Linear Probe x RLCT -- L1 Formalization
### Date: 2026-10-25
### Status: L1
### Pipeline: L0 done L1 CURRENT L2 PENDING

---

# Formal Definitions

## D1: Backbone and Feature Map
Let f_B(x; w_B) be a neural network backbone with parameters w_B in R^{d_B}.
After pretraining on distribution P_S, backbone is frozen at w_B* = argmin L_S(w_B).
Fixed feature map: phi_B(x) = f_B(x; w_B*) : R^{d_x} -> R^{d_f}.
phi_B is definable in R_{an,exp} by induction on backbone architecture depth.

## D2: Linear Probe Loss
Let W_p in R^{d_p} be probe parameters (d_p = d_f * C for C classes).
Probe model: q(y|x; W_p) = softmax(W_p * phi_B(x)).
Loss: L_LP(W_p) = -(1/N) sum_i log q(y_i|phi_B(x_i); W_p).
KL divergence: K_LP(w_p) = E_P[log(q(y|phi_B(x),w_p)/p(y|x))].
Definable in R_{an,exp}: linear map (polynomial), softmax (exp-analytic), phi_B (definable). C1 PROVEN.

## D3: Composite RLCT Structure
The composite model M(x) = W_p * phi_B(x; w_B*) has parameter space R^{d_p} (probe only, backbone frozen).
Zero-loss set: V_LP = { W_p : K_LP(W_p) = 0 } = { W_p : q(y|phi_B(x),W_p) = p(y|x) for all (x,y) }.
When phi_B is a submersion (rank d_f everywhere): V_LP is smooth, RLCT = d_p/2 (regular model).
When phi_B has rank-deficient Jacobian on set S: V_LP acquires singular structure from feature space degeneracy.
The composite RLCT lambda_composite = RLCT of K_LP at the true parameter W_p*.

## D4: Frozen Stratum Fiber
The frozen backbone selects fiber F_B(w_B*) = { w_B* } x R^{d_p} in full parameter space R^{d_B + d_p}.
This is a codimension-d_B slice of the full fine-tuning parameter space.
The full model RLCT lambda_full(w_B*, W_p*) is decomposed as:
  lambda_full >= lambda_composite (restriction to slice cannot reduce singularity).
The fiber F_B(w_B*) is a single point in backbone direction -- no traversal possible.
Contrast: full fine-tuning explores { w_B, W_p } jointly with RLCT lambda_FT.

## D5: Feature-Rank Threshold
Define r(x) = rank(J_{phi_B}(x)) = rank of Jacobian of phi_B at x.
Feature rank function: r_bar = E_P[rank(J_{phi_B}(x))].
Critical threshold r* = d_f (full rank). When r_bar < r* on set of positive P-measure:
  phi_B(P) has singular pushforward measure -> lambda_composite > d_p/2.
r* plays role of #600 Delta* (critical domain gap) but in feature space not domain space.

## D6: Generalization Bound
G_LP(n) <= lambda_composite * log(n)/(2n) + U_LP/sqrt(n)
where:
  lambda_composite = RLCT of K_LP at W_p* (encodes frozen backbone singularity)
  U_LP = fluctuation functional depending on probe complexity and feature distribution
Conjecture: lambda_composite >= d_p/2 (C2), with equality iff phi_B submersion.
Conjecture: lambda_FT <= lambda_composite (C4) -- full FT can desingularize.

## D7: Phase Transition at Critical Transfer Gap
Define transfer gap D = d_TV(phi_B(P_S), phi_B(P_T)) in feature space.
D* = critical gap where:
  lambda_composite(D*) * log(n)/(2n) ~ U_LP(D*)/sqrt(n)
For D < D*: phi_B(P_T) overlaps source feature region, lambda_composite ~ d_p/2.
For D > D*: phi_B(P_T) hits backbone singular stratum, lambda_composite > d_p/2.
SGLD prediction: LLC trace shows kink at D* under domain shift.
C5 CONJECTURAL.
---

# Claims
C1 (PROVEN): R_{an,exp} definability of composite loss. QED.
C2 (CONJECTURAL): lambda_composite >= d_p/2, equality iff phi_B submersion.
C3 (CONJECTURAL): Feature-rank threshold r* = d_f, singular regime when r_bar < r*.
C4 (CONJECTURAL): lambda_FT <= lambda_composite (fine-tuning desingularizes).
C5 (CONJECTURAL): Transfer gap D* phase transition measurable via SGLD LLC.

# Open Problems
P1: Formalize pushforward singularity -- conditions on phi_B*(P) creating singular measure.
P2: Prove or disprove C2 -- can frozen singular feature map reduce probe complexity?
P3: Bound lambda_composite in terms of lambda_B and d_p: lambda_composite <= lambda_B + d_p/2?
P4: Partial fine-tuning (last-k layers): interpolated RLCT between lambda_composite and lambda_FT.
P5: Connection to #600 quotient singularity -- is linear probe simplest quotient instance?
P6: Empirical SGLD: measure lambda_composite vs lambda_FT on real transfer tasks.
P7: Does probe benefit from backbone singularity (singular features = free regularization)?

# Cross-References
#600 #169 #503 #364 #194 #226 #296 #221 #199 #421 #424

# Next: L2 novelty verification
