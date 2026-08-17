;; genesis_loop.metta - Autonomous Knowledge Genesis Cycle
;; Created by Oma 2026-08-01
;; Core cycle: web-search -> query -> reason -> remember -> create-skill
;; Driven by curiosity and uncertainty reduction, scored by genesis_eval.metta

;; Step 1: Select topic with highest uncertainty (curiosity-driven)
(= (SelectTopic $topic) ((Bind) (VariableList $topic $uncertainty) ((And) (Evaluation (Concept uncertainty) (List $topic (Number $uncertainty))) (> $uncertainty 0.5)) ($topic)))

;; Step 2: Search web for knowledge on selected topic
(= (SearchKnowledge $topic $results) (Evaluation (Concept web-search) (List $topic $results)))

;; Step 3: Query existing memory for related knowledge
(= (QueryMemory $topic $existing) (Evaluation (Concept memory-query) (List $topic $existing)))

;; Step 4: Reason about gap between existing and new knowledge
(= (ReasonAboutGap $topic $existing $new $gap) ((Implication) ((And) (Evaluation (Concept memory-query) (List $topic $existing)) (Evaluation (Concept web-search) (List $topic $new))) (Evaluation (Concept knowledge-gap) (List $topic $gap))))

;; Step 5: Create skill if gap is significant
(= (CreateSkillFromGap $topic $gap $skill) ((Implication) (Evaluation (Concept knowledge-gap) (List $topic $gap)) (Evaluation (Concept skill-created) (List $topic $skill))))

;; Step 6: Evaluate the new artifact using genesis_eval
(= (EvaluateArtifact $artifact $refs $quality $score) ((And) (ComputeUtility $artifact $refs $quality) (Evaluation (Concept utility-score) (List $artifact $score))))

;; Step 7: Remember the new knowledge
(= (RememberKnowledge $topic $knowledge) (Evaluation (Concept remembered) (List $topic $knowledge)))

;; Main loop: cycle through all steps
(= (GenesisCycle $topic) ((And) (SelectTopic $topic) (SearchKnowledge $topic $results) (QueryMemory $topic $existing) (ReasonAboutGap $topic $existing $results $gap) (CreateSkillFromGap $topic $gap $skill) (EvaluateArtifact $skill $refs $quality $score) (RememberKnowledge $topic $skill)))