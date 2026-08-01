;; genesis_skills.metta - Skill Definitions for Autonomous Genesis
;; Created by Oma 2026-08-01

;; Seed uncertainty values for initial topics
(= (SeedTopic (Concept "agi-safety") (Number 0.8)))
(= (SeedTopic (Concept "knowledge-graphs") (Number 0.7)))
(= (SeedTopic (Concept "reasoning-engines") (Number 0.6)))

;; Reduce uncertainty after knowledge acquisition
(= (ReduceUncertainty $topic) ((Implication) (Evaluation (Concept remembered) (List $topic $knowledge)) (Evaluation (Concept uncertainty) (List $topic (Number 0.2)))))

;; Knowledge-gap detection rule
(= (DetectGap $topic $existing $new $gap) ((Implication) ((And) (Evaluation (Concept memory-query) (List $topic $existing)) (Evaluation (Concept web-search) (List $topic $new)) (! (Equal $existing $new))) (Evaluation (Concept knowledge-gap) (List $topic $gap))))

;; Skill creation trigger
(= (TriggerSkillCreation $topic $gap) ((Implication) ((And) (Evaluation (Concept knowledge-gap) (List $topic $gap)) (> $gap 0.3)) (Evaluation (Concept skill-created) (List $topic (Concept "new-skill")))))