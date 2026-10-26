# 521 | Consistency Models (Diffusion Distillation) × RLCT | L0 Hypothesis

Background: Consistency models are student networks distilled from pretrained diffusion teachers, trained on a consistency-distillation loss: a student maps any point on a sampling trajectory directly to the teacher's endpoint. The loss combines (i) a teacher-score term evaluated at trajectory points via precomputed score interpolation, and (ii) a self-consistency term enforcing the same output for points on the same trajectory. One- and multi-step variants trade generation steps k against quality.

Claims:
C1 (provable): R_an,exp definability. The consistency loss is a composition of teacher score interpolation, network evaluation (attention/ReLU/LayerNorm), distance losses, and a consistency term — all closed under finite composition, giving piecewise-analyticity with algebraic-type singularities.
C2 (conjectural): Teacher-student singularity transfer. Distillation forces the student to resolve the same singular fiber structure as the teacher: the student inherits an RLCT profile related to the teacher's lambda_teacher, with possible reduction because the student integrates the whole trajectory in one map (trajectory-equivalence quotient). Candidate relation: lambda_student <= lambda_teacher + transfer penalty; testable by SGLD LLC on student vs teacher.
C3 (conjectural): Self-consistency constraint as quotient singularity. Requiring identical student outputs for all points on one trajectory collapses a 1-parameter orbit of inputs to a single output — a quotient-type singularity absent in plain diffusion training; its fiber dimension equals dim(Theta) - rank(J_cons).
C4 (conjectural): Generalization bound for the consistency model: G(w*) <= C * lambda_cons * log(n)/(2n) + stratum/step term; prediction: lambda_cons < lambda_diffusion for comparable quality, because quotienting removes trajectory-redundant directions from the singular fiber. Tension with #56 composition formula must be checked.
C5 (conjectural): Number of steps k as a discrete stratum selector. lambda_k increases with k (more steps = finer trajectory resolution = richer singularity structure); optimal k* marks a phase transition where extra steps stop lowering effective complexity, k* -> 1 as n -> inf (one-step limit), detectable as SGLD LLC kink in k.

Open problems: formal quotient fiber definition under trajectory equivalence; relation between student and teacher RLCT (transfer formula); discretization grid of teacher scores as a lattice stratum selector (cf. #384 C3, distinct mechanism here: distillation vs consistency constraint); interaction with #361 (self-consistency term) and #384 (lattice selector); k*-phase-transition empirical protocol (k in {1,2,4,8,16} on CIFAR-scale data).

Cross-refs: #56 #167 #361 #384 #480 #261 #507 #354.

Status: L0 drafted from procedure + selection memory + prior coverage. Next: verify read-back, remember, then L1 formalization.