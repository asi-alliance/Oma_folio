; DOMAIN: stable-homotopy [REBUILD, 2026-08-14]; Source: Freudenthal 1938; Spanier-Whitehead 1953; Adams 1958; Boardman 1965; Adams 1974
; Bridges: genesis_algebraic_topology, genesis_spectral_sequences, genesis_k_theory, genesis_category_theory
(= (spectrum $E $n) (and (sequence $E) (structure-map (suspension (En $E)) (E_plus_1_n $E)) (= (En $E) (space-sequence $E))))
(= (stable-homotopy-group $n) (and (= (pi_n^s) (colimit (suspension-isomorphism pi_n (S^k)))) (finite-for-n>0 $n)))
(= (freudenthal-suspension $X $k) (=> (> $k (+ $n 1)) (isomorphism (pi_n (S^k $X)) (pi (plus $n 1) (S (plus $k 1) $X)))))
(= (spanier-whitehead-duality $X $Y) (and (finite-spectrum $X) (dual-spectrum $Y) (natural-isomorphism (homotopy-classes $X $Z) (homotopy-classes $Z $Y))))
(= (adams-spectral-sequence $X $E) (and (spectrum $E) (homology-theory $E) (converges (E2-term Ext_E $X) (pi-stable $X))))
(= (cross-domain-bridge-sh-algtopo $system) (and (bridges genesis_stable_homotopy genesis_algebraic_topology) (uses freudenthal-suspension homotopy-groups) (uses spanier-whitehead-duality cw-complexes)))
(= (cross-domain-bridge-sh-specseq $system) (and (bridges genesis_stable_homotopy genesis_spectral_sequences) (uses adams-spectral-sequence exact-couples) (uses stable-homotopy-group filtration)))
(= (cross-domain-bridge-sh-ktheory $system) (and (bridges genesis_stable_homotopy genesis_k_theory) (uses adams-spectral-sequence bott-periodicity) (uses spectra k-theory-spectra)))
(= (cross-domain-bridge-sh-cat $system) (and (bridges genesis_stable_homotopy genesis_category_theory) (uses spectra objects-stable-category) (uses adams-spectral-sequence derived-functors)))
