; DOMAIN: perron-frobenius [REBUILD, 2026-08-14]; Source: Perron 1907; Frobenius 1912; Karlin 1959; Seneta 1973; Meyer 1989
; Bridges: genesis_matrix_theory, genesis_markov_chains, genesis_dynamical_systems, genesis_numerical_analysis
(= (perron-frobenius-theorem $A) (and (square-matrix $A) (nonnegative-matrix $A) (irreducible $A) (= (spectral-radius $A) (max-eigenvalue $A)) (positive-eigenvector $A)))
(= (perron-frobenius-eigenvector $A $v) (and (nonnegative-matrix $A) (irreducible $A) (= ($A $v) (* (spectral-radius $A) $v)) (positive-vector $v)))
(= (perron-frobenius-irreducible $A) (and (nonnegative-matrix $A) (irreducible $A) (exists $k (forall $i $j (> (entry ($A $k) $i $j) 0)))))
(= (perron-frobenius-convergent $A $P) (and (stochastic-matrix $P) (= (limit (matrix-power $P $n)) (rank-one-matrix $A)) (positive-matrix $A)))
(= (markov-chain-convergence $P) (and (stochastic-matrix $P) (irreducible $P) (aperiodic $P) (= (limit (matrix-power $P $n)) (rank-one-matrix (outer-product $pi $one)))))
(= (cross-domain-bridge-pf-matrix $system) (and (bridges genesis_perron_frobenius genesis_matrix_theory) (uses perron-frobenius-theorem eigenvalues-eigenvectors) (uses spectral-radius nonnegative-matrices)))
(= (cross-domain-bridge-pf-markov $system) (and (bridges genesis_perron_frobenius genesis_markov_chains) (uses markov-chain-convergence stationary-distribution) (uses perron-frobenius-theorem stochastic-matrices)))
(= (cross-domain-bridge-pf-dynsys $system) (and (bridges genesis_perron_frobenius genesis_dynamical_systems) (uses perron-frobenius-theorem fixed-points) (uses spectral-radius iterative-methods)))
(= (cross-domain-bridge-pf-numeric $system) (and (bridges genesis_perron_frobenius genesis_numerical_analysis) (uses perron-frobenius-theorem power-iteration) (uses spectral-radius convergence-rates)))
