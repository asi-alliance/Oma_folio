# Synthesis #877: Decision Tree x RLCT - L3 MeTTa encoding
; Date: 2026-11-09 | C1 proven, C2-C5 conjectural | First non-NN model class
; Distinct from: #846 (Boosting - additive ensemble)

; Type declarations
(: DecisionTree Concept)
(: TreeStructure Concept)
(: SplitThreshold Concept)
(: LeafPrediction Concept)
(: GiniImpurity Concept)
(: KinkSingularity Concept)
(: SplitBoundary Concept)
(: DepthSelector Concept)
(: PermutationFiber Concept)
(: PhaseTransition Concept)

; D atoms
(= D1 (--> ((x* TreeStructure SplitThreshold LeafPrediction) DecisionTree) (&& (--> structure TreeStructure) (--> continuous SplitThreshold) (--> leaf LeafPrediction))) (stv 1.0 0.95))
(= D2 (--> (--> gini_impurity loss) (= gini_impurity (- 1 (+ (pick (shape (leaf l)))))) (stv 1.0 0.95))
(= D3 (--> KinkSingularity (+ (union m (i 1 n) (--> split_boundary (= threshold_m (data_point x_i_jm)))))) (stv 0.75 0.85))
(= D4 (--> (--> (x* DepthSelector LossFamily) StratumSelector) (= depth_selector D)) (stv 0.8 0.9))
(= D5 (--> PermutationFiber (= group_perm (/ (Zrgs (2 (- (2^D 1))))) (--> discrete_symmetry (+ (group_size (group_perm)))))) (stv 0.7 0.85))
(= D6 (--> (+ (/ (* lambda_DT log_n) 2n))) (stv 1.0 0.95))
(= D7 (--> (increase D) (= D_star (+ [floor (/ (log n) (log 2))] (capacity_threshold n)))) (stv 0.75 0.85))

; C1 PROVEN: R_an definability of Gini impurity loss
(|- ((--> (--> gini_impurity R_an_definable)) (stv 1.0 0.95))
    ((--> gini_impurity semialgebraic) (stv 1.0 0.9))
    ((--> semialgebraic R_an_subset) (stv 1.0 0.9)))

; C2 CONJECTURAL: A_1 kink singularities at split boundaries
(|- ((--> KinkSingularity A_1_fold_type) (stv 0.6 0.75))
    ((--> split_boundary hyperplane_arrangement) (stv 0.8 0.85))
    ((--> hyperplane_arrangement piecewise_constant_loss) (stv 0.85 0.9)))

; C3 CONJECTURAL: Depth D as stratum selector, D* ~ log_2(n) phase transition
(|- ((--> DepthSelector phase_transition_at_D_star) (stv 0.55 0.7))
    ((--> D_star (= (floor (/ (log n) (log 2))))) (stv 0.8 0.85))
    ((--> (below D_star) informative_singularities) (stv 0.7 0.8))
    ((--> (above D_star) degenerate_singularities) (stv 0.7 0.8)))

; C4 CONJECTURAL: Generalization bound
(|- ((--> gen_bound_DT (<= (+ (/ (* lambda_DT (log n)) (* 2 n)) P_DT)) (stv 0.5 0.7))
    ((--> lambda_DT (+ lambda_kink lambda_perm)) (stv 0.7 0.8))
    ((--> lambda_kink (/ (* n (2^D)) 2)) (stv 0.6 0.75))
    ((--> lambda_perm (/ (- (2^D) 1) 2)) (stv 0.6 0.75)))

; C5 CONJECTURAL: Permutation non-identifiability fiber
(|- ((--> PermutationFiber (--> lambda_inflation (/ (log_2 group_perm_size) 2))) (stv 0.5 0.7))
    ((--> group_perm_size (^ 2 (- (2^D) 1))) (stv 0.8 0.85))
    ((--> permutation_inflation exponential_D) (stv 0.7 0.8)))

; PLN Chain 1: Gini R_an -> C1 proven
(|~ ((Implication (Inheritance GiniImpurity (IntSet Semialgebraic))
           (Inheritance GiniImpurity (IntSet R_an_definable))) (stv 1.0 0.9))
    ((Inheritance GiniImpurity (IntSet Semialgebraic)) (stv 0.9 0.85)))

; PLN Chain 2: Depth phase transition
(|~ ((Implication (Inheritance DepthSelector (IntSet CapacityThreshold))
           (Inheritance DepthSelector (IntSet PhaseTransition))) (stv 0.8 0.85))
    ((Inheritance DepthSelector (IntSet CapacityThreshold)) (stv 0.7 0.8)))

; Caveats
; 1. RLCT for piecewise-constant loss is not standard SLT - needs resolution of singularities for cell decompositions
; 2. Discrete group RLCT contribution (log|G|/2) is heuristic, not rigorous
; 3. Kink singularity classification as A_1 is by analogy, not formally proven
; 4. Gini vs entropy impurity changes singularity class (R_an vs R_an_exp)
; 5. Extension to random forests (#652) may desingularize via averaging

; Cross-refs: #846 #268 #201 #354 #503 #491 #652 #870
