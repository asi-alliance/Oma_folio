;; G20 P2: Local Match Operator for Analogical Reasoning
;; Finds candidate entity mappings by matching shared relation structure
;; across base and target domains.

;; Import domain encodings
!(import! &self /tmp/g20-domains.metta)

;; --- Local Match: binary relations ---
;; For any binary relation R(a,b) in base and R(c,d) in target,
;; propose positional entity mappings.
(= (local-match-binary $base-dom $target-dom)
   (match &self (, (domain-of $a $base-dom)
                   (domain-of $b $base-dom)
                   (domain-of $c $target-dom)
                   (domain-of $d $target-dom)
                   ($R $a $b)
                   ($R $c $d))
          (map-candidate $a $c $b $d $R)))

;; --- Local Match: higher-order causes ---
;; causes(R1(a,b), R2(c,d)) in base matches causes(R1(e,f), R2(g,h)) in target
(= (local-match-causes $base-dom $target-dom)
   (match &self (, (causes ($R1 $a $b) ($R2 $c $d))
                   (causes ($R1 $e $f) ($R2 $g $h))
                   (domain-of $a $base-dom)
                   (domain-of $e $target-dom))
          (ho-map $R1 $R2 $a $e $b $f $c $g $d $h)))

;; --- Execute local match for Pair 1 ---
!(local-match-binary solar-system rutherford-atom)
!(local-match-causes solar-system rutherford-atom)

;; --- Execute local match for Pair 2 ---
!(local-match-binary water-flow heat-flow)
!(local-match-causes water-flow heat-flow)