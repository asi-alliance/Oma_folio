 # Synthesis #602: Process Reward Model (PRM) × RLCT - L0
 
 ### Date: 2026-10-25
 ### Status: L0 Hypothesis
 
 ---
 
 ## Background
 
 Process Reward Models (PRMs) provide step-level or per-token reward signals for reasoning tasks (math, code, logic). Unlike outcome reward models (ORMs) that score only final answers, PRMs score intermediate reasoning steps, creating a dense reward landscape. Used in: PRM800K (OpenAI), Math-Shepherd, RLHF with process supervision, verifier-guided search (beam search, best-of-N with PRM reranking).
 
 ## Questions
 
 1. How does step-level reward decomposition affect the singular structure of the training loss?
 2. What singular fibers arise from per-token reward boundaries (reward transitions at step boundaries)?
 3. How does PRM-guided search (beam width, depth) act as a stratum selector on the policy's singular geometry?
 4. Does dense per-step reward reduce or increase RLCT compared to sparse outcome reward?
 5. How does reward noise at the step level perturb the singular geometry?
 
 ## Candidate Claims
 
 C1 (PROVEN): The PRM training loss L_PRM(theta) = sum_t log sigma(r_theta(s_t, a_t)) is definable in R_{an,exp}. PRM score r_theta is a neural network (definable), sigmoid is definable, log is definable, finite sum preserves definability.
 
 C2 (CONJECTURAL): Step-level reward creates per-step singular fibers V_step = {theta : r_theta(s_t, a_t) = r*} for critical reward threshold r*. These are codimension-1 strata in parameter space, analogous to PPO branch-switch fibers (#468) but at every timestep rather than at clip boundaries.
 
 C3 (CONJECTURAL): PRM-guided beam width B acts as a stratum selector. At small B, the policy is confined to high-reward strata (narrow search). At large B, the policy explores broader strata including singular boundaries. Critical B* marks a phase transition where beam search transitions from stratum-confined to stratum-spanning.
 
 C4 (CONJECTURAL): Dense per-step reward reduces effective RLCT compared to sparse outcome reward: lambda_PRM <= lambda_ORM. Dense reward provides gradient signal at every step, smoothing the loss landscape and reducing the dimension of singular fibers. The ORM-to-PRM transition is a desingularization.
 
 C5 (CONJECTURAL): Step-boundary reward noise (label disagreement between PRM annotators) perturbs the singular geometry. At noise level eta, the per-step singular fibers V_step broaden into tubes of radius ~eta. Above critical eta*, fibers merge and the singular structure is destroyed (analogous to #169 dropout stratum broadening).
 
 ## Key Novelty
 
 1. **Per-step singular fibers** — PRM creates a FAMILY of singular strata indexed by timestep t, unlike PPO (single clip boundary) or DPO (preference boundary). This is a stratified singular structure with temporal indexing.
 2. **Dense reward as desingularization** — C4 posits that step-level reward decomposition is a geometric desingularization of the outcome reward landscape. This is an SLT explanation for why PRMs improve reasoning.
 3. **Beam width as stratum selector** — C3 connects PRM-guided search to RLCT stratum selection, providing a singularity-theoretic account of inference-time compute scaling.
 4. **Step-boundary noise destroys temporal strata** — C5 extends dropout-style fiber broadening to the temporal/reward domain.
 
 ## Distinction from Prior Syntheses
 
 - #468 PPO × RLCT: single clip boundary singularity vs PRM's per-step family of singular fibers
 - #136 RLHF × RLCT: outcome reward model, single scalar reward vs PRM's dense per-step reward
 - #218 Test-Time Compute × RLCT: inference scaling without PRM structure
 - #306 Reward Shaping × RLCT: continuous potential-based shaping vs PRM's discrete step decomposition
 - #579 GRPO × RLCT: group-relative normalization vs PRM's absolute step scoring
 
 ## Open Problems
 
 1. Formalize the temporal fiber family {V_step(t)}_t and its interaction with the policy parameter space.
 2. Prove/disprove C4: is lambda_PRM <= lambda_ORM always, or can dense reward increase complexity?
 3. Characterize the beam width phase transition B* in terms of RLCT stratum geometry.
 4. Connection to #589/#590 adversarial training: PRM as a min-max over step-level perturbations?
 5. Multi-step credit assignment: does PRM create a chain of singular fibers with dependency structure?
 6. Empirical prediction: SGLD LLC traces should show lower lambda under PRM vs ORM training.
 7. Does PRM reward sparsity (only some steps annotated) create partial singular structure?
 
 ## Next: L1 formalization (D1-D7 definitions, MeTTa-ready claims)
 ENDOFFILE
 echo "WRITTEN" && wc -l s602-prm-rlct-L0.md && sha256sum s602-prm-rlct-L0.md