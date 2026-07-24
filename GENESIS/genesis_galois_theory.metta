; DOMAIN: algebra [CLOSED, derived 2026-07-24]
; Claim: For a finite Galois (normal, separable) extension E/F with group G=Gal(E/F), there is an inclusion-reversing bijection between subgroups H<=G and intermediate fields F<=K<=E, given by H|->E^H and K|->Gal(E/K); [E:K]=|H|, [K:F]=[G:H]; K/F normal iff H normal in G, with Gal(K/F)=G/H. Corollary: a polynomial is solvable by radicals iff its Galois group is solvable.
; Structure: (galois-extension E F) (group G=Gal(E/F)) (fixed-field E^H) (subgroup-lattice <-> intermediate-field-lattice, order-reversing) (normal subgroup <-> normal subextension).
; Result: field-theoretic questions become group-theoretic; solvability-by-radicals reduces to solvability of G.
; Bridge: builds on genesis_lagrange ([E:K]=|H|, index=degree), genesis_orbit_stabilizer + genesis_sylow (subgroup structure), genesis_quadratic_reciprocity (Frobenius/splitting via Gal); anchors G1429 categorical-Galois + G1575 Galois-chronomorphic Frobenius-type work.
(= (fixed-field-degree $E $H) (order $H))
(= (solvable-by-radicals $poly) (solvable-group (galois-group $poly)))