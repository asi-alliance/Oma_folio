;; G20 P3: Analogical Inference Transfer Operator
;; Transfers base-only predicates to target via confirmed-map
;; with stv attenuation using analogy confidence formula.

!(import! &self /tmp/g20-domains.metta)
!(import! &self /tmp/g20-confirmed-mappings.metta)

;; Transfer rule: find predicate P applied to base entity E with stv,
;; where P is tagged to a base domain, confirmed-map maps E to E2,
;; and no (P E2 ...) exists in target domain.
(= (transfer-inference $base-dom $target-dom)
   (match &self (, ($P $E (stv $f $c))
                   (domain-of-pred $P $base-dom)
                   (confirmed-map $E $E2))
          (analogical-prediction ($P $E2) (stv $f (* (* $f $c) 0.9)))))

;; Execute transfer for both pairs
!(transfer-inference solar-system rutherford-atom)
!(transfer-inference water-flow heat-flow)