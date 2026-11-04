# Synthesis #667: KTO (Kahneman-Tversky Optimization) × RLCT — L1 Formalization

### Date: 2026-10-28
### Status: L1
### Pipeline: L0 done L1 done L2 PENDING

---

# Formal Definitions

## D1: KTO Loss Function
The KTO loss for a single sample y with desirability label d in {+1, -1}:
- For desirable (d=+1): L_+ = 1 - sigma(beta * (r(theta) - z_ref))
- For undesirable (d=-1): L_- = kappa * sigma(beta * (r(theta) - z_ref))
where r(theta) = log pi_theta(y|x) - log pi_ref(y|x) is the implicit reward,
z_ref = E[KL(pi_theta || pi_ref)] is the KL reference point,
beta is temperature, kappa > 1 is loss aversion.

Full loss: L_KTO(theta) = E_+[L_+] + kappa * E_-[L_-]

## D2: R_{an,exp} Structure (C1 — PROVEN)
- sigma(x) = 1/(1+e^{-x}) is analytic (exponential definable)
- r(theta) = log pi_theta(y|x) - log pi_ref(y|x) is in R_{an,exp} (log of exponential definable functions)
- z_ref is a constant parameter (definable)
- kappa, beta are constants
- L_KTO is a composition of sigma, linear arithmetic, and constants -> L_KTO in R_{an,exp}

## D3: Asymmetric Singular Fiber V_KTO
Define the zero-loss set:
- V_+ = {theta : L_+(theta) = 0} = {theta : sigma(beta*(r(theta)-z_ref)) = 1} approx {theta : r(theta) -> +inf}
- V_- = {theta : L_-(theta) = 0} = {theta : sigma(beta*(r(theta)-z_ref)) = 0} approx {theta : r(theta) -> -inf}

The singular variety V_KTO = V_+ union V_- is asymmetric:
- V_+ (desirable): parameters where implicit reward >> z_ref
- V_- (undesirable): parameters where implicit reward << z_ref
- Reference boundary: S_ref = {theta : r(theta) = z_ref} separates V_+ from V_-
- kappa weights V_- differently: gradient contribution from V_- is kappa times that from V_+
- Generically lambda_+ != lambda_- (C2 CONJECTURAL)

## D4: kappa-Stratified Loss Family
L_KTO^(kappa)(theta) = L_+(theta) + kappa * L_-(theta), indexed by kappa in (0, inf).
- kappa = 0: only desirable samples matter
- kappa = 1: symmetric utility (unweighted binary classification)
- kappa -> inf: only undesirable samples matter
- kappa = kappa*: optimal balance (C5)
- Hypothesis: lambda_eff(kappa) = (lambda_+ + kappa*lambda_-) / (1+kappa) (C3 CONJECTURAL)

## D5: Generalization Bound (C4 — CONJECTURAL)
G_KTO ~ lambda_eff(kappa, beta) / (2n) + U(kappa, beta) / sqrt(n)
- Claim: lambda_KTO <= lambda_SFT (reference-point constraint restricts accessible parameter space)
- Claim: lambda_KTO != lambda_DPO (independent sample-fiber vs coupled pair-fiber)

## D6: Reference Point Gauge Degeneracy
z_ref = E[KL(pi_theta || pi_ref)] is data-dependent, shifts during training.
- Translation degeneracy: perturbations preserving r(theta) - z_ref = 0 are in fiber null space
- Weaker than DPO gauge degeneracy (scalar reference vs full model quotient)
- Codimension-1 gauge slice (vs DPO full-dimensional gauge)

## D7: Phase Transition beta* x kappa*
Two-parameter optimization surface (beta, kappa) has critical curve:
- beta controls preference sharpness (analogous to DPO beta, #599)
- kappa controls loss aversion asymmetry (novel to KTO)
- At (beta*, kappa*): optimal generalization G_KTO minimized
- beta too high: over-sharp boundary (overfitting)
- kappa too high: over-constrained V_- (under-fitting undesirable)
- beta too low: blurry boundary (under-fitting all)
- kappa too low: V_- too permissive (poor regularization)

---

# Claims
C1 (PROVEN): R_{an,exp} definability. QED.
C2 (CONJECTURAL): Asymmetric fiber V_+ != V_- with lambda_+ != lambda_-.
C3 (CONJECTURAL): kappa as continuous stratum selector compressing V_-.
C4 (CONJECTURAL): lambda_KTO <= lambda_SFT, lambda_KTO != lambda_DPO.
C5 (CONJECTURAL): beta* x kappa* phase transition surface.

# MeTTa-Ready Claims
C1: (Definable L_KTO R_an_exp) stv 1.0 0.95
C2: (AsymmetricFiber V_KTO V_plus V_minus lambda_plus lambda_minus) stv 0.5 0.7
C3: (StratumSelector kappa V_minus compression) stv 0.5 0.7
C4: (LeqRLCT lambda_KTO lambda_SFT) stv 0.5 0.7
C5: (PhaseTransition beta_star kappa_star) stv 0.5 0.7

# Open Problems
1. Is lambda_eff = (lambda_+ + kappa*lambda_-)/(1+kappa) correct, or does asymmetry create more complex interaction?
2. Does z_ref being data-dependent create self-referential singularity not present in DPO?
3. Can SGLD measure lambda_+ and lambda_- separately for desirable/undesirable samples?
4. How does finite-sample estimation of z_ref perturb the singular locus?
5. Does prospect-theory kink create non-analytic singularity if kappa is step function?
6. Connection to #224 label smoothing: does kappa play role analogous to epsilon?
7. Relationship between KTO single-sample fiber and contrastive learning per-sample fiber (#540)?

# Cross-References
#599 (DPO pairwise fiber), #579 (GRPO group norm), #468 (PPO clip), #362 (CFG stratum selector),
#224 (label smoothing), #136 (RLHF), #167 (diffusion), #540 (InfoNCE), #414 (GRPO RLCT), #185 (Constitutional AI)
