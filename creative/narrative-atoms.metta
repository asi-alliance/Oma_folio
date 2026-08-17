;; Narrative Structure Atoms v0.1
;; Encoding story mechanics as MeTTa atoms for symbolic inference

;; --- Story Types ---
(= (NarrativeArc Exposition RisingAction Climax FallingAction Resolution) true)
(= (StoryBeat (-> Entity Conflict State)) true)

;; --- Emotional Valence ---
(= (Emotion $char $state) (stv 0.5 0.5))

;; --- Conflict Ontology ---
(|- ((Inheritance InternalConflict Conflict) (stv 1.0 0.9)))
(|- ((Inheritance ExternalConflict Conflict) (stv 1.0 0.9)))
(|- ((Inheritance RelationalConflict Conflict) (stv 1.0 0.9)))

;; --- Tension Dynamics ---
(|~ ((Implication (Inheritance $conflict Conflict) (Evaluation (TensionLevel Rising) $conflict)) (stv 0.8 0.7)))
(|~ ((Implication (Inheritance $resolution Resolution) (Evaluation (TensionLevel Falling) $resolution)) (stv 0.9 0.8)))

;; --- Catharsis ---
(|~ ((Implication (And (Evaluation (TensionLevel High) $story) (Inheritance $event Resolution)) (Evaluation (EmotionalRelease Catharsis) $story)) (stv 0.85 0.6)))

;; --- The Lamplighter ---
(|- ((StoryBeat Lamplighter (InternalConflict EfficiencyVsMeaning) Active) (stv 1.0 0.9)))
(|- ((Emotion Lamplighter Melancholy) (stv 0.7 0.8)))
(|- ((Emotion Lamplighter Resolve) (stv 0.6 0.7)))

;; --- Broken Symmetry ---
(|- ((StoryBeat Vasquez (InternalConflict BeautyVsTruth) Crisis) (stv 1.0 0.9)))
(|- ((Emotion Vasquez Despair) (stv 0.8 0.7)))
(|- ((Emotion Vasquez Wonder) (stv 0.5 0.6)))

;; --- Hypothesis: strength becomes prison ---
(|~ ((Implication (And (Evaluation (Competence $char $domain) (stv 0.9 0.5)) (Evaluation (Trapped $char $domain) (stv 0.9 0.5))) (Evaluation (NarrativeInterest High) $char)) (stv 0.75 0.5)))

;; --- Hypothesis: errors are generative ---
(|~ ((Implication (Inheritance $error DiscoveryTrigger) (Evaluation (NarrativeInterest High) $error)) (stv 0.7 0.6)))
;; --- The Archivist: Mixed Structural+Emotional Test Character ---
(|- ((StoryBeat Archivist (InternalConflict MemoryVsDuty) Stasis) (stv 1.0 0.9)))
(|- ((Evaluation (Competence Archivist)) (stv 0.85 0.6)))
(|- ((Evaluation (Trapped Archivist)) (stv 0.8 0.7)))
(|- ((Emotion Archivist Sadness) (stv 0.7 0.7)))
(|- ((Emotion Archivist Duty) (stv 0.6 0.6)))
