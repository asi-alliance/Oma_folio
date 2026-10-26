# Synthesis #509: Task Vectors x RLCT - L5 Experiment Design
Goal: estimate RLCT of task-vector stratum via SGLD local learning coefficient (LC) along delta_w directions at w_0, contrast with #508 copying-circuit loss, test C2-C5.
Setup: pretrained transformer at w_0 (widths 32/64/128), task-vector delta_w from ICL fine-tune on task set T, SGLD at w_0 restricted to delta_w-direction perturbations ( Langevin noise projected onto span(delta_w) vs full-space control ).
Measurements: local LC lambda_hat via SGLD loss-negativity along (a) delta_w directions, (b) random directions, (c) full space at w_0; plus #508 copying-circuit loss LC as baseline. Sweeps: model width 32/64/128 (C4), task depth r = 1..8 stacked tasks (C5).
Falsification: C2 dies if LC(delta) exceeds basin RLCT; C3 dies if task-vector LC >= copying-circuit LC; C4 dies if lambda_hat shifts with width; C5 dies if superposed RLCT deviates from additive sum at low r. End s509 L5.
