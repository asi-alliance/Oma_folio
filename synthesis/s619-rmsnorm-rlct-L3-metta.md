# Synthesis #619: RMSNorm × RLCT — L3 MeTTa Encoding

## Core Atoms

(: RMSNorm (-> Input Output))
(: RLCT (-> LossFunction Real))
(: codim (-> Singularity Natural))
(: epsilon_resolution (-> Real Real))
(: generalization_bound (-> Real Natural Real))

## Definability (C1/D1)
(= RMSNorm (lambda x (gamma_dot (elementwise_div x (sqrt (add (mean (square x)) epsilon)))))

## RLCT Values (C4/D7)
(|- ((Implication (Inheritance RMSNorm NormalizationMethod))
     (== (RLCT RMSNorm) (stv 0.5 0.9))))

(|- ((Implication (Inheritance LayerNorm NormalizationMethod))
     (== (RLCT LayerNorm) (stv 1.0 0.9))))

(|- ((< (RLCT RMSNorm) (RLCT LayerNorm)) (stv 1.0 0.9)))

## Codimension Argument (D4)
(|- ((== (codim RMSNorm_collapse) 1) (stv 1.0 0.9)))
(|- ((== (codim LayerNorm_collapse) 2) (stv 1.0 0.9)))
(|- ((Implication (== (codim Sigma) 1))
     (== (RLCT Sigma) 0.5)) (stv 1.0 0.9))
(|- ((Implication (== (codim Sigma) 2))
     (== (RLCT Sigma) 1.0)) (stv 1.0 0.9))

## Epsilon Resolution (C3/D5)
(|- ((Implication (== epsilon 0))
     (== (epsilon_resolution epsilon) lambda_max)) (stv 1.0 0.7))
(|- ((Implication (> epsilon 0))
     (< (epsilon_resolution epsilon) lambda_max)) (stv 1.0 0.8))
(|- ((monotone_decreasing epsilon_resolution epsilon)) (stv 1.0 0.8))

## Generalization Bound (C5/D6)
(|- ((== (generalization_bound epsilon n)
        (add (mul (epsilon_resolution epsilon)
                  (div (log n) (mul 2 n)))
             (add (div U_epsilon (sqrt n))
                  (bias_epsilon epsilon)))))) (stv 1.0 0.9))

(|- ((Implication (> n n_threshold))
     (> (optimal_epsilon n) (optimal_epsilon n_threshold))) (stv 1.0 0.7))

## Origin Singularity (C2/D2)
(|- ((== RMSNorm_singularity_type polar_origin)) (stv 1.0 0.9))
(|- ((== LayerNorm_singularity_type coupled_mean_variance)) (stv 1.0 0.9))
(|- ((== BatchNorm_singularity_type batch_statistics_coupling)) (stv 1.0 0.9))
(|- ((distinct polar_origin coupled_mean_variance)) (stv 1.0 0.9))
(|- ((distinct polar_origin batch_statistics_coupling)) (stv 1.0 0.9))

## Cross-References
(|- ((related #619 #16)) (stv 1.0 0.9))
(|- ((related #619 #89)) (stv 1.0 0.9))
(|- ((related #619 #470)) (stv 1.0 0.9))
(|- ((related #619 #234)) (stv 1.0 0.9))
(|- ((related #619 #618)) (stv 1.0 0.9))
