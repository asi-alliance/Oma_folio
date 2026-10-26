# Synthesis #508: Induction Heads / ICL x RLCT — L1 Formalization
Date: 2026-10-22 | Status: L1 (formalization)
## Topic
Induction heads (previous-token head -> induction head copying circuit) implementing in-context learning, formalized as RLCT singularity candidate.
## Definitions D1-D7
D1: Previous-token head: attention head a with W_K a maps token t1 to t0 (key/value position offset -1), definable as linear+softmax restriction.
D2: Induction head: head b at layer L composes previous-token head at L-1: value b(t0) reads key a(t1) via K_b Q_a, copies Q_b(t0)=[t0;t1] — the copying circuit.
D3: Function class restriction: fix heads a,b to the copying-circuit parameter subspace; loss restricted to this class defines the candidate RLCT setting.
D4: Lag compensation: identity map with +1 offset so value position matches induction token — a stratum candidate within the restricted class.
D5: Composition depth: copying circuit requires >=2 layers (L-1 key head, L value head); single-layer restriction cannot express D2 circuit.
D6: ICL task restriction: restrict loss to tasks where the circuit performs in-context copying (pattern completion), making the circuit parameter subspace the effective learner.
D7: Candidate RLCT setting: copying-circuit singularity = degeneracy structure of loss restricted to the D3 subspace on ICL tasks.
## C1 Definability (proven)
Previous-token head + induction head are both linear maps + softmax heads; composing them is a function-class restriction on parameters, so loss definability holds (same argument class as #485, #507).
## C2-C5 (conjectural)
C2: ICL accuracy jump (Olsson phase transition) hypothesized as RLCT phase transition in r. C3: two-head composition carries strictly higher RLCT than any single head — explains multi-layer reinforcement. C4: copying-circuit singularity distinct from generic attention singularities (#485). C5: RLCT model-size stable, cross-model measurable.
## Cross-refs
#8 #100 #234 #396 #485 #502 #507 + toric fan ICL notes (2026-09)
