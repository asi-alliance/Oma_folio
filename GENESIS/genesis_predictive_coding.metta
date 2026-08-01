; DOMAIN: neuroscience/predictive-coding [CLOSED, derived 2026-08-01]; Claim: Predictive coding theory models the brain as a hierarchical generative model that continually predicts sensory inputs and updates beliefs via prediction errors. Each cortical layer encodes predictions at its level of abstraction, forwarded to lower layers, while prediction errors propagate upward. Bayesian inference is implemented via precision-weighted error signals. The free energy principle unifies this with active inference: agents minimize variational free energy by updating beliefs or acting on the world.
; Structure: (hierarchical generative model) (prediction errors: residual = input - prediction) (precision weighting) (Bayesian belief updating) (free energy principle) (active inference)
; Result: Predictive coding recasts perception as hierarchical Bayesian inference where the brain minimizes surprise. Prediction errors propagate upward; predictions propagate downward. Precision weighting enables attentional modulation. Active inference extends the framework to motor control.
; Bridge: genesis_free_energy_principle + genesis_bayesian_inference + genesis_information_geometry + genesis_active_inference
;; Hierarchical generative model: each layer predicts layer below
(|- ((==> (&& (--> CorticalLayer $L_high) (--> CorticalLayer $L_low) (--> $L_high Above $L_low))) (--> $L_high Predicts $L_low)) (stv 1.0 0.9))
;; Prediction error: residual between sensory input and prediction
(|- ((==> (&& (--> Prediction $pred) (--> SensoryInput $x))) (--> PredictionError (- $x $pred))) (stv 1.0 0.95))
;; Prediction errors propagate upward to update higher-level beliefs
(|- ((==> (--> PredictionError $err) (--> Direction Upward))) (--> BeliefUpdate $err)) (stv 1.0 0.85)
;; Precision weighting: gain on error signals modulated by estimated variance
(|- ((==> (&& (--> PredictionError $err) (--> Precision $pi))) (--> PrecisionWeightedError (* $pi $err))) (stv 1.0 0.9))
;; Bayesian belief updating: posterior proportional to likelihood times prior
(|- ((==> (&& (--> Prior $p_theta) (--> Likelihood $p_x_theta) (--> Posterior $p_theta_x))) (--> BayesianUpdate (* $p_x_theta $p_theta))) (stv 1.0 0.9))
;; Free energy principle: minimize variational free energy
(|- ((==> (&& (--> VariationalFreeEnergy $F) (--> SensoryInput $x) (--> Belief $q))) (--> $F (+ (- (Log $p_x)) (KL $q $p)))) (stv 1.0 0.85))
;; Active inference: action changes sensory input to reduce prediction error
(|- ((==> (&& (--> Action $a) (--> SensoryConsequence $x_a) (--> PredictionError $err))) (--> ActiveInference (Minimize $err))) (stv 1.0 0.85))
