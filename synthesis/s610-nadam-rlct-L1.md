# Synthesis #610: NAdam (Nesterov-accelerated Adam) × RLCT — L1 Formalization
## Date: 2026-10-25
## Status: L1 Formalization

### D1: Update Map Definability (C1 PROVEN)
The NAdam update map Phi_NAdam: (w_t, m_t, v_t) -> (w_{t+1}, m_{t+1}, v_{t+1}) is:
  m_{t+1} = beta1 * m_t + (1-beta1) * g_t
  v_{t+1} = beta2 * v_t + (1-beta2) * g_t^2
  m_hat = beta1 * m_{t+1} / (1-beta1^{t+2}) + (1-beta1) * g_t / (1-beta1^{t+1})
  v_hat = v_{t+1} / (1-beta2^{t+1})
  w_{t+1} = w_t - eta * m_hat / (sqrt(v_hat) + eps)

Each component: EMA (linear recurrence), bias correction (rational t), 
sqrt (analytic), division (rational), Hadamard (polynomial).
All definable in R_{an,exp}. QED.

### D2: Anticipatory Momentum (C2 CONJECTURAL)
The Nesterov-lookahead momentum m_hat replaces standard Adam's 
m_t/(1-beta1^t) with an anticipatory form:
  m_hat = beta1 * m_{t+1}/(1-beta1^{t+2}) + (1-beta1) * g_t/(1-beta1^{t+1})
This evaluates momentum at the "looked-ahead" position w_t + mu*(w_t - w_{t-1}).
The effective gradient entering the preconditioned update is g_eff = m_hat,
which contains curvature information from a future point on the loss landscape.
Conjecture: lambda_NAdam <= lambda_Adam because the anticipatory gradient
can detect singular fibers before the trajectory reaches them, allowing
the diagonal metric to select strata that standard Adam would miss.

### D3: Dual Temporal Lag Fiber V_lag (C3 CONJECTURAL)
Define V_lag(t) = { w : the stratum selected by v_t (retrospective metric)
  differs from the stratum probed by m_hat (anticipatory direction) }.
This is a dynamic construct: at each step t, the metric D_t = diag(v_hat)^{-1/2}
is built from past gradients, while the direction m_hat points forward.
The "lagged fiber" is the set of parameters where this temporal mismatch
causes the optimizer to select a different stratum than either pure Adam
or pure Nesterov would. Open: is V_lag a well-defined algebraic variety
or purely dynamical?

### D4: Generalization Bound with Lookahead Benefit (C4 CONJECTURAL)
GenBound_NAdam = lambda_eff * log(n)/(2n) + B_look/sqrt(n)
where:
  lambda_eff = effective RLCT under NAdam dynamics
  B_look = lookahead benefit term
    B_look < 0 when lookahead correctly identifies singular fibers
    B_look > 0 when lookahead overshoots (probes past singularity into
    region of higher curvature, causing v_t to inflate and freeze
    parameters prematurely)
Conjecture: E[B_look] < 0 for moderate mu, yielding improvement over Adam.
The optimal mu balances exploration (large mu, more stratum access)
against overshoot risk (large mu, B_look > 0).

### D5: Lookahead Distance mu as Stratum Selector (C5 CONJECTURAL)
The effective lookahead distance mu (related to beta1) controls how far
ahead the gradient is evaluated:
  mu -> 0: NAdam reduces to Adam (no lookahead, retrospective only)
  mu -> 1: NAdam maximizes lookahead (aggressive stratum probing)
Conjecture: mu acts as a continuous stratum selector analogous to:
  - gamma in RMSProp (#606, EMA decay as stratum dial)
  - tau in Sophia (#609, clipping threshold as trust region)
  - k in Lookahead (#420, exploration depth)
Phase transition at mu* where B_look changes sign:
  mu < mu*: lookahead beneficial (B_look < 0, more singular strata accessed)
  mu > mu*: lookahead harmful (B_look > 0, overshoot dominates)
Conjecture: mu* ~ 1/lambda (flatter landscapes permit longer lookahead).

### D6: Bias Correction × Lookahead Interaction
Standard Adam bias correction c_t = 1/(1-beta^t) compensates for 
initialization bias. NAdam's lookahead modifies this:
  c_eff(t) = 1/(1-beta1^{t+1}) for the anticipatory term
  vs 1/(1-beta1^{t+2}) for the momentum term
This creates a TIME-DEPENDENT stratum accessibility:
  Early training (t small): c_eff large, lookahead amplified -> 
    aggressive stratum exploration (analogous to warmup in #316)
  Late training (t large): c_eff -> 1, lookahead attenuated ->
    conservative stratum commitment
The bias-correction × lookahead coupling creates a NATURAL CURRICULUM
over stratum exploration depth that is absent in both Adam and Nesterov.

### D7: SGLD-Testable Predictions
1. LLC(t) under NAdam should show a different trajectory than Adam:
   - If anticipatory stratum selection works, LLC should drop FASTER
     (reaching lower-RLCT strata earlier due to lookahead)
   - If overshoot dominates, LLC should be HIGHER than Adam
2. Phase transition at mu*: LLC vs mu should show a U-shape or cusp
   at mu*, analogous to tau* in Sophia (#609) and gamma* in RMSProp (#606)
3. The dual temporal lag V_lag should manifest as increased LLC 
   variance during early training (stratum mismatch creates 
   non-equilibrium fluctuations)
4. Bias correction × lookahead: LLC trajectory should show
   early aggressive exploration (high variance) transitioning to
   late conservative commitment (low variance) — a curriculum signature

## Open Problems (from L0, refined)
1. Formalize V_lag as algebraic variety or prove it is purely dynamical.
2. Prove lambda_NAdam <= lambda_Adam under transversality conditions.
3. Derive mu* ~ 1/lambda conjecture from fiber geometry.
4. Characterize B_look as function of loss landscape singularity structure.
5. Does bias-correction × lookahead curriculum generalize to other
   lookahead-optimizer combinations (e.g., Lookahead + RMSProp)?
6. Compare NAdam vs #420 Lookahead: gradient-space vs parameter-space
   lookahead — different fiber structures?
7. Can V_lag be detected via LLC variance decomposition?

## Cross-References
#289 (Adam), #304 (Adam L0-L4), #100 (momentum), #476 (Nesterov),
#420 (Lookahead optimizer), #605 (Adagrad), #606 (RMSProp),
#607 (AdaFactor), #609 (Sophia), #516 (K-FAC), #415 (Muon),
#316 (One-Cycle LR), #433 (weight decay), #169 (weight decay),
#377 (gradient noise)