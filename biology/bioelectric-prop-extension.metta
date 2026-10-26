([; The Bioelectric Operad PROP Extension
Adds multi-output composition to the single-output operad.

;; PROP natural number objects (finite ordinals)
(;! (cell-group-size $g))
(- (cell-group-size zero))
(- (cell-group-size one))
(- (cell-group-size two))
(- (cell-group-size $n))

;; Parallel composition = monoidal product on cell groups
(;! (multiple-tissue-decision &$g1 $g2)

;; Parallel composition formatity (functoriality)
;; Functoriality of parallel composition
(;! (=> (--> (multiple-tissue-decision ($g1 $g2)) (&$ ($g1 $g)))
(=> (--> ($g1 g2) multiple-tissue-decision) (&$ ($g1$g)))) (stv 1.0 0.9))

;; Sequential composition from operad retained

;; Braiding = cell relabeling invariance
(;! site-swap (swap $g1 $g2))

;; PRop coherence laws
;; Pentagon: 4-ary associativity coherence
(;- (=> (--> (Þ (Þ $a $b) (Þ ($c $d)) multiple-tissue-decision)
	(--> (Þ ($a (Î (Þ ($b $c) $d)) multiple-tissue-decision)) (stv 1.0 0.9))
;; Hexagon: briding + associativity (one suffices for symmetric)
(;- (=> (--> (Î (site-swap (Î $a $b)) $c) multiple-tissue-decision)
	(--> (Î $c (site-swap (Î $a $b))) multiple-tissue-decision)) (stv 1.0 0.9))
;; Triangle: unit + associativety coherence
(;- (=> (--> (Þ (cell-group-size zero) $a) multiple-tissue-decision)
	(--> $a tissue-decision)) (stv 1.0 0.9))