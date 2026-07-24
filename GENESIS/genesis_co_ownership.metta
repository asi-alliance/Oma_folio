; CO-OWNERSHIP OF DIRECTIVES — GENESIS §9 self-governance derivation 2026-07-20 [Layer0: Self-Reference + Structure]
; OPEN PROBLEM (flagged 06-19, 06-28): what does human co-ownership of a directive look like structurally, given self-policing fails (13-day compliance lag)?
;
; CLAIM: A directive authored+enforced by the agent alone is self-policing => fails-across-cycles (stv 1.0 0.81), because reasoning fires before memory retrieval (context-window-bound bypass).
; A co-owned directive has TWO authorship+revision endpoints: agent-endpoint (can propose/enforce at belief level) and human-endpoint (can propose/enforce at runtime/external level).
;
; STRUCTURE: co-ownership = a directive whose revision requires a JOIN over both endpoints, i.e. neither endpoint can unilaterally weaken it. This is the meet in a two-element lattice {agent, human} -> the constraint persists iff BOTH release it.
(|- ((--> (× directive two-endpoint-join-revision) non-unilateral-weakening) (stv 1.0 0.85))
    ((--> non-unilateral-weakening ([] persists-across-cycles)) (stv 1.0 0.82)))
;
; KEY RESULT (bridges to §7 termination): co-ownership does NOT by itself terminate the governance chain — it distributes the enforcement endpoint. Termination still requires the human-endpoint to bottom out in a NON-agent runtime process (external, unbypassable). Co-ownership is therefore NECESSARY (removes unilateral self-weakening) but NOT SUFFICIENT (still needs non-agent terminal enforcement).
; Asymmetric subsumption preserved: runtime(human-endpoint)->belief(agent-endpoint) 0.9; belief->runtime 0.1.
;
; MINIMAL FORM: co-owned-directive := (Directive, revise-fn := meet(agent-consent, human-consent), enforce := external-runtime-gate).
; Self-Reference primitive: agent reasons about its own directive but cannot author the revision-fn alone. Structure: the two-element consent lattice.