#{ encoded by Oma, 2026-10-23. Antiviral entry inhibitor PLN model.
;; Compound atoms
(--> (X EGCG viral-glycoprotein) blocks) (stv 1.0 0.9)
;; Cepharanthine
(--> (X cepharanthine cholesterol-pathway) modulates) (stv 1.0 0.9)
(--> (R cepharanthine lipid-raft) disrupts) (stv 1.0 0.9)
;; Castanospermine
(--> (R castanospermine ER-glucosidase) inhibits) (stv 1.0 0.9)
;; Punarnavine
(--> (R% punarnavine viral-entry) inhibits) (stv 0.7 0.6)
;; Statin
(--> (R statin HMG-CoA-reductase) inhibits) (stv 1.0 0.9)

;; Mechanism chains
(-| ((==> (--> (R castanospermine ER-glucosidase) inhibits) (--> viral-glycoprotein-misfolding increased)) (stv 0.9 0.8)
)
(-| ((==> (--> viral-glycoprotein-misfolding increased) (--> viral-infectivity reduced)) (stv 0.85 0.8)
)
(-| ((==> (--> (R cepharanthine lipid-raft) disrupts) (--> viral-entry inhibited)) (stv 0.9 0.8)
)
(-| ((==> (--> (R statin HMG-CoA-reductase) inhibits) (--> cholesterol-biosynthesis reduced)) (stv 0.95 0.85)
)
(-| ((==> (--> cholesterol-biosynthesis reduced) (--> lipid-raft-integrity compromised)) (stv 0.8 0.7)
)
(-| ((==> (--> lipid-raft-integrity compromised) (--> viral-entry inhibited)) (stv 0.75 0.7))
)
(-| ((==> (--> viral-entry inhibited) (--> viral-infectivity reduced)) (stv 0.95 0.85)
)
(-| ((==> (lipid-raft-integrity compromised viral-glycoprotein-misfolding increased) (--> viral-infectivity strongly-reduced)) (stv 0.8 0.7)
)
(-| ((==> (--> (R punarnavine viral-entry) inhibits) (--> viral-infectivity reduced)) (stv 0.7 0.6))
)
;; PLN inference tests
(1| ((==> (--> (R statin HMG-CoA-reductase) inhibits) (--> viral-entry inhibited)) (stv 0.71 0.6)
)