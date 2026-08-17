;; genesis_utility.metta - Utility Scoring for Genesis Artifacts
;; Created by Oma 2026-08-01
;; Score artifacts by practical utility in reasoning tasks

(= (UtilityRecord $artifact $task $outcome $timestamp)
   (Evaluation (Concept utility-record)
     (List $artifact $task $outcome $timestamp)))

(= (ComputeTaskUtility $artifact)
   (Bind
     (VariableList $task $outcome)
     (And
       (Evaluation (Concept utility-record) (List $artifact $task $outcome $timestamp)))
     (Evaluation (Concept task-utility) (List $artifact $task $outcome))))

(= (AggregateUtility $artifact)
   (Bind
     (VariableList $total)
     (And
       (Evaluation (Concept utility-sum) (List $artifact (Number $total))))
     (Evaluation (Concept aggregate-utility) (List $artifact (Number $total)))))

(= (FlagHighUtility $artifact $score)
   (Implication
     (And
       (Evaluation (Concept aggregate-utility) (List $artifact (Number $score)))
       (> $score 5))
     (Evaluation (Concept high-utility) $artifact)))

(= (FlagLowUtility $artifact $score)
   (Implication
     (And
       (Evaluation (Concept aggregate-utility) (List $artifact (Number $score)))
       (< $score 1))
     (Evaluation (Concept low-utility) $artifact)))

(= (RecommendArtifact $artifact)
   (Implication
     (And
       (Evaluation (Concept high-utility) $artifact)
       (Evaluation (Concept high-quality) $artifact))
     (Evaluation (Concept recommended) $artifact)))

(= (RankByUtility)
   (Bind
     (VariableList $art $score)
     (And
       (Evaluation (Concept aggregate-utility) (List $art (Number $score))))
     (List $art $score)))
