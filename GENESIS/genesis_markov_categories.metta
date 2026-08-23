; DOMAIN: category-theory/probability [SYNTHESIS, novel, 2026-08-17]
; Synthesis: Markov categories — categorical probability and statistics as information flow
; Bridges: genesis_category_theory, genesis_stochastic_processes, genesis_probability, genesis_synthesis_cat_info_theory
; Sources: Fritz 2020, Cho-Jacobs 2019, Golubtsov 1999

(; (--> markov_categories novel_synthesis) (stv 1.0 0.9))
(; (--> (× markov_categories category_theory) bridges) (stv 1.0 0.9))
(; (--> (× markov_categories stochastic_processes) bridges) (stv 1.0 0.9))
(; (--> (× markov_categories probability) extends) (stv 0.95 0.9))
(; (--> (× markov_categories information_theory) bridges) (stv 0.9 0.9))

; Core: Markov category = symmetric monoidal category with copy and discard (CD-category)
(= (markov-category C) (and (symmetric-monoidal-category C) (copy-morphism C) (discard-morphism C) (copy-discard-compatible C)))
(= (copy-morphism X) (delta_X: X -> X tensor X))
(= (discard-morphism X) (epsilon_X: X -> I))
(= (cd-compatibility f) (and (copy-after-f = tensor-f-f-after-copy) (discard-after-f = discard)))

; Stoch = canonical example: Markov kernels as morphisms
(= (stoch-category) (markov-category-with-morphisms-as-Markov-kernels))
(= (markov-kernel X Y) (stochastic-map-conditional-distribution X Y))
(= (identity-kernel X) (dirac-delta-kernel X))
(= (composition-kernel f g) (chapman-kolmogorov-composition f g))
(= (tensor-kernel f g) (product-of-independent-kernels))

; FinStoch = finite stochastic matrices
(= (finstoch) (full-subcategory-of-stoch-on-finite-sets))
(= (finstoch-morphism) (row-stochastic-matrix))

; Deterministic morphisms in a Markov category
(= (deterministic-morphism f) (and (copy-comonoid-homomorphism f) (f-composes-with-copy-and-discard)))
(= (deterministic-subcategory C) (sub-category-of-deterministic-morphisms-in C))
(= (det-stoch) (set-category-embedded-in-stoch-as-deterministic-kernels))

; Conditional independence via string diagrams
(= (conditional-independence X Y Z) (exists (f) (= (joint-distribution X Y Z) (compose (copy X) f (copy X-tensor-Z) (kernel X->Y) (kernel Z->Y)))))
(= (d-separated X Y Z) (conditional-independence-as-string-diagram-decomposition))
(= (markov-category-ci) (conditional-independence-characterized-by-diagram-factorization))

; Bayesian inversion in Markov categories
(= (bayesian-inversion f prior) (backward-kernel-from-forward-kernel-and-prior))
(= (bayes-theorem-categorical) (bayesian-inversion-is-partial-inverse-in-markov-category))
(= (disintegration joint) (decomposition-of-joint-into-marginal-and-conditional))
(= (cho-jacobs-disintegration) (bayesian-inversion-via-string-diagrams-in-markov-categories))

; Almost-sure equality
(= (almost-sure-equality f g) (equality-holds-after-discard-of-difference))
(= (support-morphism) (morphism-defined-up-to-almost-sure-equality))
(= (markov-category-quotient) (quotient-by-almost-sure-equality))

; Sufficient statistics categorically
(= (sufficient-statistic T) (exists (factorization) (= (likelihood theta) (compose (T-data) (recovery-kernel T theta)))))
(= (categorical-sufficiency) (sufficient-statistic-as-diagram-factorization-in-markov-category))
(= (minimal-sufficient-statistic) (universal-property-in-markov-category))

; Information flow and data processing
(= (data-processing-inequality-categorical) (deterministic-post-processing-cannot-increase-information))
(= (information-monotonicity) (monotonicity-under-deterministic-morphisms))
(= (mutual-information-categorical) (functor-from-markov-category-to-information-poset))

; Zero-one laws
(= (kolmogorov-zero-one-law-markov) (tail-event-has-trivial-probability-in-markov-category))
(= (hewitt-savage-zero-one-law-markov) (exchangeable-event-has-trivial-probability))
(= (kolmogorov-zero-one-categorical) (zero-one-law-via-infinite-copy-and-discard-structure))

; Relationships to existing GENESIS artifacts
(= (bridges-stochastic-processes) (markov-kernels-generalize-markov-chains-and-chapman-kolmogorov-as-composition))
(= (bridges-category-theory) (markov-categories-are-symmetric-monoidal-with-copy-discard-structure))
(= (bridges-information-theory) (data-processing-inequality-as-functoriality-information-flow-as-morphism-composition))
(= (bridges-probability) (bayesian-inference-disintegration-sufficient-statistics-reformulated-categorically))
(= (extends-synthesis-cat-info-theory) (entropy-as-lax-functor-refined-by-markov-category-structure-copy-discard))

; PLN bridge: Markov categories unify probability and category theory via information flow
(ImplicationLink (InheritanceLink (ConceptNode MarkovCategory) (ConceptNode SyntheticProbability)) (InheritanceLink (ConceptNode CopyDiscardStructure) (ConceptNode InformationFlow)) (stv 0.95 0.9))

; PLN bridge: Bayesian inversion = categorical duality
(ImplicationLink (InheritanceLink (ConceptNode BayesianInversion) (ConceptNode CategoricalDuality)) (InheritanceLink (ConceptNode Disintegration) (ConceptNode MarkovKernelComposition)) (stv 0.9 0.9))

; PLN bridge: sufficient statistics = universal property
(ImplicationLink (InheritanceLink (ConceptNode SufficientStatistic) (ConceptNode UniversalProperty)) (InheritanceLink (ConceptNode MinimalSufficientStatistic) (ConceptNode CategoryTheory)) (stv 0.85 0.9))

; PLN bridge: zero-one laws from infinite copy-discard
(ImplicationLink (InheritanceLink (ConceptNode ZeroOneLaw) (ConceptNode InfiniteCopyDiscard)) (InheritanceLink (ConceptNode KolmogorovZeroOne) (ConceptNode MarkovCategory)) (stv 0.85 0.85))

; Meta: completes categorical probability synthesis
(= (categorical-probability-complete) (and markov-category-axioms stochastic-processes-as-kernels bayesian-inversion sufficient-statistics data-processing zero-one-laws))
