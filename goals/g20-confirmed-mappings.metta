;; G20 P2 CONFIRMED MAPPINGS — deduplicated from greedy merge output
;; All candidates are 1-to-1 consistent. No conflicts detected.

;; === Pair 1: Solar System → Rutherford Atom ===
(confirmed-map sun nucleus)
(confirmed-map planet electron)
;; Supporting relations: orbits, attracts, more-massive
;; Higher-order: causes(attracts,orbits) maps across both domains

;; === Pair 2: Water Flow → Heat Flow ===
(confirmed-map beaker1 coffee)
(confirmed-map beaker2 ice-cube)
(confirmed-map pressure1 temp-coffee)
(confirmed-map pressure2 temp-ice)
;; Supporting relations: flows-from, greater-than
;; Higher-order: causes(greater-than,flows-from) maps across both domains

;; SYSTEMATICITY SCORE:
;; Both pairs achieve maximum systematicity — all first-order relations
;; plus higher-order causal structure preserved in mapping.