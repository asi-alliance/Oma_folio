(; GENESIS: optimal control theory — dynamic optimization, Pontryagin maximum principle, Bellman equation ;)
(Domain: applied_mathematics/optimization)
(Bridges: calculus_of_variations, PDE, optimization, dynamical_systems, stochastic_processes)
(Survey-basis: Pontryagin; Bellman; Kalman; Lions)

(== (control_system) (tuple (dynamics f) (control u) (cost J) (constraint_set U)))
(= (optimal_control_problem) (minimize (integral_t0_t1 (L t x u)) subject_to (dot x = f(t,x,u)) (x(t0)=x0) (u(t) in U)))

(= (Pontryagin_maximum_principle) (and (= (dot x) (partial_p H)) (= (dot p) (- (partial_x H))) (= (u_star) (argmax_u H))))
(= (Hamiltonian_control H) (- (L t x u) (* p (f t x u))))

(= (Bellman_equation) (= (partial_t V) (min_u (+ (L t x u) (* (gradient V) (f t x u))))))
(= (value_function V) (inf_u (expected_cost (t x u))))

(= (dynamic_programming) (= (V t x) (min_u (+ (L t x u) (V (+ t dt) (f t x u))))))
(= (LQR_problem) (and (linear_dynamics) (quadratic_cost) (= (optimal_control u) (* (- K) x))))
(= (Riccati_equation) (= (dot P) (- (+ (Q (* A P) (* P A) (* (* P B) (* R_inverse) (* (transpose B) P)))))))
(= (controllability) (= (rank (controllability_matrix A B)) n))
(= (observability) (= (rank (observability_matrix A C)) n))
(= (Luenberger_observer) (= (dot_hat_x) (+ (* A hat_x) (* B u) (* L (- y (* C hat_x))))))
(= (duality_control_observe) (<=> (controllable A B) (observable (transpose A) (transpose B))))

(|- ((==> (optimal_control) (calculus_of_variations)) (stv 1.0 0.9)))
(|- ((==> (optimal_control) (PDE)) (stv 1.0 0.9)))
(|- ((==> (optimal_control) (optimization)) (stv 1.0 0.9)))
(|- ((==> (optimal_control) (dynamical_systems)) (stv 1.0 0.9)))
(|- ((==> (optimal_control) (stochastic_processes)) (stv 1.0 0.9)))
(|- ((==> (optimal_control) (functional_analysis)) (stv 1.0 0.9)))
