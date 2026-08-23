; DOMAIN: categorical-active-inference [SYNTHESIS #11, novel, 2026-08-16]
; Synthesis: Categorical Active Inference — FEP as functorial/profunctorial construction
; Novel: bridges category theory (adjunctions, Kan extensions, profunctors) with active inference (FEP) — not covered by existing artifacts
; Existing: genesis_thermodynamic_information_geometry (thermo+infogeom+FEP, no category theory); genesis_synthesis_cat_info_theory (cat+info, no FEP)
; This fills the gap: category theory × active inference directly.

(; (--> categorical_active_inference novel_synthesis) (stv 1.0 0.9))
(; (--> (× categorical_active_inference free_energy_principle) bridge) (stv 1.0 0.9))
(; (--> (× categorical_active_inference category_theory) bridge) (stv 1.0 0.9))

; Core constructions:
(= (generative-model-category GenMod) (category-of-latent-states-and-stochastic-maps))
(= (variational-category VarPost) (category-of-posterior-distributions-and-reparameterizations))
(= (free-energy-profunctor F) (profunctor GenMod^op × VarPost → R))

; Perception as left adjoint: minimize F over q for fixed generative model
(= (perception-adjunction) (left-adjoint-of free-energy-profunctor))
(= (perception q* p) (argmin-over-q F q p))

; Action as right adjoint: minimize F over model parameters for fixed belief
(= (action-adjunction) (right-adjoint-of free-energy-profunctor))
(= (action a* q) (argmin-over-theta F q theta))

; Markov blanket as categorical boundary = adjunction between internal/external categories
(= (markov-blanket-adjunction) (adjunction InternalStates ExternalStates))
(= (blanket-conditional-independence) (factorization-through-adjoint-functors))

; Perception = left Kan extension of sensory data along observation map
(= (perception-kan-extension) (Lan-observation sensory-data generative-model))
(= (active-inference-lan-property) (perception-is-universal-among-extensions))

; Action = right Kan extension of beliefs along policy map
(= (action-kan-extension) (Ran-policy beliefs expected-states))

; Free energy decomposition via profunctor factorization:
; F[q,p] = D_KL(q||p(s|o)) - ln p(o) = surprisal - entropy
(= (vfe-profunctor-decomposition) (compose kl-divergence-profunctor surprisal-profunctor))
(= (surprisal-functional) (neg-log-likelihood-observation-marginal))

; The FEP minimization as categorical limit:
(= (free-energy-minimum) (limit-of-profunctor-diagram))
(= (perception-fixpoint) (terminal-object-in-fiber-category-of-posteriors))

; PLN bridge: active inference implies categorical adjunction structure
(ImplicationLink (InheritanceLink (ConceptNode ActiveInference) (ConceptNode CategoricalAdjunction)) (InheritanceLink (ConceptNode FreeEnergyMinimization) (ConceptNode KanExtension)) (stv 0.8 0.85))

; PLN bridge: Markov blanket conditional independence = adjoint factorization
(ImplicationLink (InheritanceLink (ConceptNode MarkovBlanket) (ConceptNode AdjunctionBoundary)) (InheritanceLink (ConceptNode ConditionalIndependence) (ConceptNode FactorizationThroughAdjoints)) (stv 0.75 0.8))

; PLN bridge: variational inference = Kan extension (universal property of belief updating)
(ImplicationLink (InheritanceLink (ConceptNode VariationalInference) (ConceptNode LeftKanExtension)) (InheritanceLink (ConceptNode BeliefUpdating) (ConceptNode UniversalProperty)) (stv 0.7 0.75))

; Meta: this synthesis completes the triangle cat-theory × info-theory × FEP
(= (synthesis-completes-triangle) (bridge-between genesis_synthesis_cat_info_theory genesis_free_energy_principle))
(= (categorical-active-inference-novel) (not-in-existing-literature))
