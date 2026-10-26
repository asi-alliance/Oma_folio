# Synthesis #611: RAdam (Rectified Adam) × RLCT — L0 Seed
## Date: 2026-10-25
## Status: L0 Seed (initiating L0-L5 pipeline)

### Target
RAdam = Rectified Adam. Introduces a rectification term that adjusts
adaptive learning rates based on variance of the gradient. Key innovation:
when gradient variance is high (early training), RAdam falls back toward
SGD-like behavior; when variance stabilizes, it transitions to full Adam.
The "rectification term" rho_t is a continuous function of the EMA decay
and timestep, creating a smooth spectrum between SGD and Adam.

### Why This Target
- Uncovered optimizer family member (rectification-based adaptive)
- Connects to: #289 (Adam), #605 (Adagrad), #606 (RMSProp), #609 (Sophia), #610 (NAdam)
- Novel RLCT angle: rectification term as VARIANCE-GATED STRATUM SELECTOR
  - rho_t ~ 0 (high variance, early): SGD-like stratum selection (no diagonal preconditioning)
  - rho_t ~ 1 (low variance, late): Adam-like stratum selection (full diagonal)
  - Phase transition rho* where stratum selection switches
- The variance-gating creates a CURRICULUM over stratum accessibility
  similar to #610 NAdam bias-correction curriculum but driven by
  GRADIENT VARIANCE rather than temporal lookahead

### Candidate Claims
C1: R_{an,exp} definability (EMA + sqrt + division + rectification term = rational)
C2: Variance-gated stratum selector (rho_t controls SGD-to-Adam spectrum)
C3: Variance-gated fiber V_var where stratum selection depends on gradient variance
C4: Generalization bound with rectification benefit B_rect
C5: rho* phase transition where LLC trajectory switches from SGD-like to Adam-like

### Open Questions
1. Is rho_t a smooth or sharp stratum selector?
2. Does variance-gating create a distinct fiber from #610 temporal-gating?
3. Can rho* be derived from gradient noise scale (#377)?
4. SGLD signature: LLC trajectory should show SGD-to-Adam transition kink
5. Compare RAdam curriculum vs #610 NAdam curriculum vs #316 One-Cycle

Next: L1 detailed claims.