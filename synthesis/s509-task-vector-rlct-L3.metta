! Synthesis #509: Task Vectors x RLCT — L3 MeTTa encoding
(= (task-vector $w-task $w-0) $delta-w) ; D1 analytic difference
(--> (delta-fiber $delta-w) algebraic-subvariety) ; C1 proven
(==> (task-vector-stratum $w-0 $delta-w) (has-RLCT $w-0) ) ; C2 bounded by basin
(==> (implicit-task-fn $w-0 $delta-w) (slice-of (copying-circuit $w-0))) ; C3 slice vs whole #508
(==> (scale-up $w-0) (stable-RLCT (task-vector-stratum $w-0))) ; C4 scale stability
(==> (superpose $d1 $d2) (additive-RLCT $d1 $d2)) ; C5 until interference r
; Open: same singularity as copying circuit (#508), or proper slice? Cross-refs: #232 #508 #502 + toric fan ICL. End s509 L3.
