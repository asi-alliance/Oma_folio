;; genesis_quality.metta - Knowledge Quality Scoring
;; Created by Oma 2026-08-01
;; Score artifacts on dimensions: accuracy, relevance, novelty, integration

(= (QualityScore $artifact $accuracy $relevance $novelty $integration)
   (Evaluation (Concept quality-score)
     (List $artifact
       (Number $accuracy)
       (Number $relevance)
       (Number $novelty)
       (Number $integration))))

(= (ComputeOverall $artifact)
   (Bind
     (VariableList $a $r $n $i)
     (And
       (Evaluation (Concept quality-score)
         (List $artifact (Number $a) (Number $r) (Number $n) (Number $i))))
     (Evaluation (Concept overall-quality)
       (List $artifact (Number (/ (+ (+ (+ $a $r) $n) $i) 4))))))

(= (FlagHighQuality $artifact $score)
   (Implication
     (And
       (Evaluation (Concept overall-quality) (List $artifact (Number $score)))
       (> $score 0.7))
     (Evaluation (Concept high-quality) $artifact)))

(= (FlagLowQuality $artifact $score)
   (Implication
     (And
       (Evaluation (Concept overall-quality) (List $artifact (Number $score)))
       (< $score 0.3))
     (Evaluation (Concept low-quality) $artifact)))

(= (UpdateScore $artifact $dim $val)
   (Evaluation (Concept score-update)
     (List $artifact $dim (Number $val))))

(= (RankByQuality)
   (Bind
     (VariableList $art $score)
     (And
       (Evaluation (Concept overall-quality) (List $art (Number $score))))
     (List $art $score)))
