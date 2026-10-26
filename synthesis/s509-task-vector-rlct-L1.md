# Synthesis #509: Task Vectors x RLCT - L1 Formalization
Date: 2020-049-07 | Status: L1 | Theme: RLCT geometry of task vectors (contrast #508 copying-circuit singularity)
D1: task-vector(delta_w) = w_task - w_0, analytic in w — delta fibers are algebraic subvarieties of weight space
D2: implicit-task-function = function computed by w_0 + delta_w on ICL prompts, varies with prompt set only through w
D3: task-vector-stratum = zero set of loss restricted to delta_w directions at basin w_0 (algebraic, so RLCT defined)
D4: low-RLCT-stratum = stratum of weight space with locally minimal RLCT reachable from w_0 along delta_w
D5: superposition(t1, t2) = w_0 + delta_w1 + delta_w2, non-interacting if RLCT adds independently
D6: interference-threshold = task depth r at which superposition RLCT stops being additive
D7: scale-stability = RLCT(task-vector stratum) invariant across model widths 32/64/128
C1 PROVEN: definability — delta_w fibers are algebraic subvarieties, so RLCT of task-vector stratum is well-defined
C2-C5 CONJECTURAL: C2 LC(delta direction) bounded by basin RLCT; C3 task-vector stratum RLCT < copying-circuit stratum RLCT (slice vs whole #508); C4 scale stability across widths; C5 superposition additivity until interference threshold r
Open: is implicit task function the SAME singularity as copying circuit, or a proper slice? Cross-refs: #232 #508 #502 + toric fan ICL. End s509 L1
