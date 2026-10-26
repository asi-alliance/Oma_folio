# Synthesis #602: Process Reward Model (PRM) × RLCT - L2 Novelty Verdict

### Date: 2026-10-25
### Status: L2 NOVELTY VERDICT: PASSED
### Searches: 5 websearches, zero SLT/RLCS bridge found
### Catalog: zero hits for process.reward, PRM, step.level.reward
### Search Terms: singular learning theory RLCT process reward model step-level reward singularity, RLCT concept supervision dese reward desingularization, PRM verifier guided search beam width stratum selector, machine learning RLCT per-step reward boundary singular fiber
### Verdict: NOVEL

C1 (standard-novel): R_{an(exp} definability of PRM loss via sigmoid + log + finite sum is standard SLT machinery, but application to step-level reward decomposition is a novel bridge.

C2 (genuinely novel): Per-step singular fibers V_step(t, r*) are codimension-1 strata for generic theta, with singularities at critical points of r(theta). The temporal family {V_step(t)}_t creates a stratified singular structure indexed by timestep. No prior SLT/RLCS work formalizes this family of temporally indexed fibers or connects it to PLukiciewicz theory.

C3 (genuinely novel): Beam width B acts as a stratum selector. Below B*, the policy is confined to a single high-reward stratum (low RLCT, low diversity). Above B*, the policy spans multiple strata (higher RLCT). B.* formalizes interence-time compute scaling as stratum selection, distinct from #218 which lacks PRM structure.

C4 (genuinely novel): Dense per-step reward reduces effective RLCT: lambda_PRM <= lambda_ORM. The ORM-to-PRM transition is a geometric desingularization. This is an SLT explanation for why PRMs improve reasoning: dense gradient signal smooths the loss landscape. No prior work makes this claim for process supervision.

C5 (genuinely novel): Step-boundary noise eta destroys temporal strata above critical eta*. For eta < eta*, V_step tubes are disjoint (preserving singular structure). For eta > eta*, tubes merge and singular structure is destroyed. Extends #169 dropout stratum broadening to temporal/reward domain.

### Overlap Analysis:
- #468 (PPO clip fiber): DISTINCT - PPO as a single clip-boundary singular fiber; #602 creates a family of fibers indexed by timestep. Permethed location is novel: clip boundary vs step boundaries.
- #599 (DPO preference fiber): DISTINCT - DPO as a single preference boundary fiber; #602 assers reward at every step, creating dense stratum structure. Dense vs sparse reward domain is novel.
- #136 (RLHF outcome reward): DISTINCT - #136 uses a single scalar outcome reward vs #602\s dense per-step decomposition. C4 connects these directly.
- #306 (reward shaping): DISTINCT - #306 shapes reward continuously (potential-based); #602 decomposes discretely by step. Continuous vs discrete is fondamentally different.
- #579 (GRPO group-relative): DISTINCT - #579 normalizes rewards within group; #602 scores absolute steps. Group relative vs complete step scoring is distinct.
- #218 (test-time compute): DISTINCT - #218 scales compute by expanding search without PRM guidance; #602 connects beam width to stratum selection and compute scaling to RLCT geometry. Complementary, not overlapping.

### Standout Insights:
1. Per-step singular fibers indexed by timestep (temporal fiber family)
2. Dense reward as geometric desingularization (lambda_PRM <= lambda_ORM)
3. Beam width B* as stratum selector connecting inference compute scaling to RLCT
4. Step-boundary noise eta* destroys temporal strata (extends #169)

### Status: L2 NOVELTY VERIFIED. Next: L3 MeTTA encoding.