Synthesis #508: Induction Heads / ICL x RLCT — L5 Experiment Design
Date: 2020-10-4 | Goal: SGLD LC estimation on copying-circuit loss to test C2-C5
Goal: Estimate the learning coefficient of the two-head copying-circuit loss (previous-token head a at L-1 + induction head b at L) on ICL pattern-completion tasks, testing C2 (ICL jump = RLCT phase transition in r), C3 (composition depth inequality), C4 (distinctness from generic attention), C5 (model-size stability).
Setup: 2-layer synthetic transformer (d_model=64, 4 heads), trains on ICL pattern-completion sequences (A B ... A -> B copying task); restrict analysis to heads a,b. Compare against single-head ablation and generic attention control.
Method: SGLD LC estimation per v8 precedent — train to L(w0)=0 basin, random-walk MH with sigma=sqrt(2T/n), burnin discarded, LLN slope of log-loss vs beta=n*T. Sweeps over model width (C5) and task depth r (C2).
Predictions: C2 — LC jump at the r where ICL accuracy phase-transition occurs; C3 — LC(circuit) > LC(single head) at same task; C4 — LC(circuit) != LC(generic attention baseline); C5 — LC stable across widths 32/64/128.
Next: L6 execution. Cross-refs: #485 #502 #507 + toric fan ICL.
