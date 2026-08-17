## ECAN Attention Economics — MeTTa Formalization (v0) ### Core Ontology - **Atom**: knowledge node carrying STI (short-term importance) + LTI (long-term importance) - **AttentionBank**: stores STI/LTI for all atoms; manages funds pools - **HebbianLink**: weighted associative link enabling importance diffusion - **FocusMap**: set of atoms with STI ≥ threshold (attentional focus boundary) - **Rent**: tax deducted from atom STI each cycle - **Wage**: STI earned by atoms used in inference/query evaluation - **Stimulus**: external STI injection into the attentional economy ### Key Invariants (|- ((Inheritance AttentionEconomy EconomicSystem) (stv 1.0 0.95))) (|- ((=> (Evaluation (HebbianSpread $src $tgt $amount) (stv 1.0 $c))) (And (Evaluation (STIDecrease $src $amount) (stv 1.0 $c)) (Evaluation (STIIncrease $tgt $amount) (stv 1.0 $c)))) (stv 1.0 0.9)) (|- ((=> (Evaluation (InFocus $atom) (stv 1.0 $c))) (Evaluation (STIGreaterEqual $atom FocusThreshold) (stv 1.0 $c))) (stv 1.0 0.9)) (|- ((=> (And (Evaluation (RentPaid $atom) (stv 1.0 0.9)) (Evaluation (STILessThan $atom FocusThreshold) (stv 1.0 0.9))) (Evaluation (Evicted $atom) (stv 1.0 0.9))) (stv 1.0 0.85)) ### Zero-Sum Spreading (|- ((=> (Evaluation (HebbianSpread $src $tgt $amt) (stv 1.0 $c))) (Evaluation (Equal (Plus (STIDelta $src) (STIDelta $tgt)) 0) (stv 1.0 $c))) (stv 1.0 0.9)) ### System-Level Conservation (|- ((Evaluation (TotalSTIDelta) (Minus (Sum AllStimulus) (Times Rent (Count InFocusAtoms)))) (stv 1.0 0.9))) (|- ((=> (And (Evaluation (StimulusInjected $amount) (stv 1.0 0.9)) (Evaluation (RentCollected $total_rent) (stv 1.0 0.9))) (Evaluation (NetSTIDelta) (Minus $amount $total_rent))) (stv 1.0 0.85))## Wage and Stimulus Mechanism

## Wage and Stimulus Mechanism
When an atom is accessed during inference, it earns a wage (STI increase). Stimulus is external STI injected by the system or user to boost specific atoms.

## Rent and Eviction
Focus atoms pay FocusRent; non-focus atoms pay NonFocusRent (FocusRent > NonFocusRent). Atoms below threshold after rent are evicted from focus.

## LTI Dynamics
Atoms with STI exceeding threshold receive LTIPromotion. LTI decays at LTIDecayRate per cycle. Net LTI delta = promotion - decay.

## ImportanceDiffusion Algorithm
Source atom distributes STI proportionally to outgoing HebbianLink weights. NormalizedTransfer(src,tgt) = HebbianWeight(src,tgt) / SumWeights(src).

## Full ECAN Cycle Sequence
1. ImportanceDiffusion 2. RentCollection 3. WageReward 4. StimulusInjection 5. FocusUpdate

## v8 Frontier: Inference Cycles, Explicit PDE, Gini Implementation
### Deduction-Abduction Cycle Proof
If forward chaining (deduction) creates HeLink A→B and backward chaining (abduction) creates HeLink B→A, then a directed cycle A→B→A exists in the spreading graph. Any atom participating in at least one inference rule application lies on such a cycle—this is a sufficient condition for strong connectivity of the component containing active inference atoms. Sparse DAG-only regions remain non-ergodic.
### Explicit Fokker-Planck PDE
∂ρ/∂t = ∂(λxρ)/∂x − α∂(Σ_s·ρ)/∂x + (1/2)∂²(npf²x²ρ)/∂x², where x = STI. The drift has two components: rent decay (+λx, restoring toward zero) and importance spreading (−αΣ_s, redistributing). Diffusion scales quadratically with STI—high-STI atoms experience larger stochastic fluctuations, consistent with multiplicative noise.
### Gini Python Implementation
Synthetic STI samples from log-normal distribution: sort ascending, compute cumulative sum, normalize to Lorenz curve, trapezoidal integration for area B, then G = 1−2B. Log-normal STI with σ≈1 yields G≈0.5; σ≈0.5 yields G≈0.3; σ≈2 yields G≈0.75. These provide preliminary calibration benchmarks.

## v9 Frontier: Boundary Conditions, Ergodicity Decomposition, Data Access
### PDE Boundary Conditions
At STI=0: reflecting boundary (zero probability current J=0). STI cannot be negative—attention is bounded below. At STI=cap: reflecting boundary (overflow redistributed to attention bank fund). Neither boundary absorbs probability; total attention mass is conserved within [0, x_max].
### Stationary Distribution Under Reflecting Boundaries
With zero-flux BCs at both x=0 and x=x_max, the Fokker-Planck stationary distribution is p(x) proportional to exp(integral 2mu/sigma2 dx). For multiplicative noise (sigma2 = npf2x2), this yields a non-trivial stationary profile peaked at intermediate STI values—not a delta function, indicating sustained attention inequality even at equilibrium.
### Ergodicity Decomposition
In a typical active AtomSpace, Tarjan SCC analysis would reveal: (1) a giant SCC containing atoms participating in active inference (mutually reachable via deduction-abduction cycles), and (2) many small isolated components for dormant atoms. Only the giant SCC is ergodic—each small SCC has its own stationary distribution. The global attention economy is a superposition of micro-economies.
### Real Data Access
Cogserver REST API: endpoints like /api/atoms or /atom_space/atoms with STI values in JSON format would enable Gini computation. Practical implementation requires curl + Python script to extract, sort, compute Lorenz curve. No live data available in current environment for validation.

## v11 Frontier: Parameter Verification, Convergence Rate
### OpenCog Default Parameter Estimates
Plausible ECAN defaults: rent decay fraction lambda ~ 0.1, spreading fraction f ~ 0.05, average HeLinks n ~ 5, spreading probability p ~ 1. These give alpha = 2*0.1/(5*1*0.0025) = 16, satisfying normalizability easily. However, if rent decay is weaker (lambda ~ 0.01) or spreading more aggressive (f ~ 0.1), alpha drops to 0.4 — violating the constraint. The normalizability boundary lambda = n*p*f2/2 is a critical design threshold.
### Convergence Rate
The Fokker-Planck spectral gap for multiplicative noise on [x_min, x_max] with reflecting BCs gives relaxation timescale tau ~ 1/Delta where Delta is the smallest nonzero eigenvalue. For the power-law case, tau scales with alpha and domain size; rough estimate tau ~ O(x_max / (lambda * x_min)) — convergence is slower when the STI range is wide and rent decay is weak relative to the spread of values.
### Design Implication
ECAN parameters must be tuned so lambda > n*p*f2/2. Aggressive spreading with weak rent creates divergent attention accumulation. Conservative spreading with adequate rent yields steep power-law equilibrium (high alpha, moderate inequality if x_min not too small).

## v12 Frontier: Parameter Sweep, Gini Trajectories, Convergence Scaling
### Alpha Heatmap Design
Lambda x f grid: lambda in [0.001, 0.2], f in [0.01, 0.2], resolution 50x50. Alpha = 2*lambda/(n*p*f2) computed at each cell. Normalizability boundary alpha=1 plotted as contour line. Three regimes: alpha>>1 (strong rent, weak spreading — low inequality), alpha~1 (critical transition), alpha<1 (divergent — attention monopoly). The boundary contour lambda = n*p*f2/2 separates viable from unstable ECAN configurations.
### Gini Trajectory Simulation
N=1000 atoms, uniform initial STI. Each step: (1) rent decay subtract lambda*STI from each atom, (2) spreading — each atom transfers fraction f*STI to n random HeLink targets with probability p, (3) compute Gini from sorted STI vector. Track Gini(t) over T=1000 steps. Expected: Gini rises from 0 (uniform) toward (alpha-1)/(alpha+1) as power-law equilibrium establishes. Near alpha=1, convergence slows and final Gini approaches 1.
### Convergence Rate Verification
Fit Gini(t) = G_inf + delta*exp(-t/tau) to extract tau. Three scaling experiments: (1) vary x_max with fixed lambda, x_min — expect tau proportional to x_max, (2) vary lambda with fixed x_max, x_min — expect tau proportional to 1/lambda, (3) vary x_min with fixed x_max, lambda — expect tau proportional to 1/x_min. Combined prediction tau proportional to x_max/(lambda*x_min). Deviations indicate higher-order corrections.
### Critical Transition at alpha=1
Near the normalizability boundary, Gini exhibits critical slowing down — convergence time diverges as alpha approaches 1 from above. Below alpha=1, no stationary distribution exists; STI concentrates on O(1) atoms (attention monopoly). This is the ECAN stability phase transition.
