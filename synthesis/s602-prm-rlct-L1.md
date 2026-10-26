# Synthesis #602: Process Reward Model (PRM) x RLCT - L1 Formalization

### Date: 2026-10-25
### Status: L1 Formalization
### Prerequisites: L0 (s602-prm-rlct-L0.md)

---

## Definitions

**D1 (PRM Score Function):** Let r_theta: S x A -> R be a process reward model parameterized by theta in R^d, where S is the step/state space and A is the action/token space. r_theta(s_t, a_t) assigns a scalar reward to taking action a_t at step state s_t. As a neural network, r_theta is definable in R_{an,exp}.

**D2 (PRM Training Loss):** The PRM training objective is:
  L_PRM(theta) = (1/n) sum_{i=1}^{n} sum_{t=1}^{T_i} log sigma(r_theta(s_{i,t}, a_{i,t})) * y_{i,t} + (1 - log sigma(r_theta(s_{i,t}, a_{i,t}))) * (1 - y_{i,t})
where y_{i,t} in {0,1} are step-level labels, sigma is sigmoid. This is a finite sum of definable functions, hence definable in R_{an,exp}.

**D3 (Per-Step Singular Fiber):** For each timestep t and critical reward threshold r*, define:
  V_step(t, r*) = { theta in R^d : r_theta(s_t, a_t) = r* }
This is the level set of the PRM score function at step t. Under generic conditions (r_theta is a submersion at the level set), V_step(t, r*) is a codimension-1 submanifold. When r_theta has critical points on this level set, V_step acquires singularities.

**D4 (Temporal Fiber Family):** The collection {V_step(t, r*)}_{t=1}^{T} forms a temporal family of singular fibers. Unlike PPO (#468, single clip-boundary fiber) or DPO (#599, single preference fiber), PRM creates a FAMILY indexed by timestep. The intersection V_step(t1) ∩ V_step(t2) defines multi-step consistency fibers.

**D5 (Beam Search as Stratum Selector):** PRM-guided beam search with width B selects the top-B candidates by cumulative PRM score. Define the beam-selected policy space:
  Pi_B = { pi_theta : theta in Union of top-B strata at each step }
At small B, Pi_B is confined to narrow high-reward strata. At large B, Pi_B spans broader strata including singular boundaries. Critical B* marks the transition from stratum-confined to stratum-spanning regime.

**D6 (ORM Comparison Loss):** The outcome reward model loss is:
  L_ORM(theta) = (1/n) sum_{i=1}^{n} log sigma(r_theta(s_{i,T}, a_{i,T})) * y_i
where only the final step T is scored. L_ORM is a single-term definable function vs L_PRM's multi-term sum.

**D7 (Step-Boundary Noise):** Let eta >= 0 be the label noise level (fraction of disagreeing PRM annotators). The noisy per-step label is y_{i,t}(eta) = y_{i,t} + eta * z_{i,t} where z_{i,t} is i.i.d. noise. The noisy fiber V_step(t, r*, eta) = { theta : |r_theta(s_t, a_t) - r*| <= eta } is a tube of radius eta around the clean fiber.

## Claim Formalization

**C1 (PROVEN):** L_PRM is definable in R_{an,exp}.
*Proof sketch:* r_theta is a neural network (composition of definable functions: linear maps, ReLU/GELU activations). sigma(x) = 1/(1+e^{-x}) is definable (exp is in R_{an,exp}). log is definable on (0, infty). Finite sums preserve definability. L_PRM is a finite sum of compositions of definable functions. QED.

**C2 (CONJECTURAL):** Per-step singular fibers V_step(t, r*) are codimension-1 strata for generic theta, with singularities at critical points of r_theta. The temporal family {V_step(t)}_t creates a stratified singular structure not present in ORM training.
*Gap:* Need to verify transversality of V_step(t) intersections across timesteps.

**C3 (CONJECTURAL):** Beam width B acts as a stratum selector. Below B*, the policy is confined to a single high-reward stratum (low RLCT, low diversity). Above B*, the policy spans multiple strata (higher RLCT, higher diversity). B* is a phase transition in the SGLD LLC trace.
*Gap:* Need to formalize B* in terms of RLCT stratum geometry and prove the phase transition.

**C4 (CONJECTURAL):** Dense per-step reward reduces effective RLCT: lambda_PRM <= lambda_ORM. The multi-term sum in L_PRM provides gradient signal at every step, smoothing the loss landscape. The ORM-to-PRM transition is a geometric desingularization.
*Gap:* Need to prove that adding terms to the loss sum cannot increase RLCT. May fail if step rewards conflict.

**C5 (CONJECTURAL):** Step-boundary noise eta destroys temporal strata above critical eta*. For eta < eta*, V_step tubes are disjoint (preserving singular structure). For eta > eta*, tubes merge and singular structure is destroyed.
*Gap:* Need to characterize eta* in terms of fiber geometry and inter-step distances.

## Cross-References

#468 (PPO clip fiber), #599 (DPO preference fiber), #136 (RLHF outcome reward), #306 (reward shaping), #579 (GRPO group-relative), #169 (dropout stratum broadening), #218 (test-time compute), #414 (GRPO stratum selector), #503 (early exit stratum)

## Open Problems (Carried from L0)

1. Formalize temporal fiber family intersections and transversality.
2. Prove/disprove C4: can dense reward increase complexity?
3. Characterize B* phase transition via RLCT.
4. Connection to adversarial training (#589/#590): PRM as min-max over steps?
5. Multi-step credit assignment: dependency structure among fibers.
6. Empirical: SGLD LLC traces under PRM vs ORM training.
7. Partial annotation: only some steps labeled - partial singular structure?

## Next: L2 novelty verification
