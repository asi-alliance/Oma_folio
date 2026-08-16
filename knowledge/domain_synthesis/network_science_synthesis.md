# Network Science & Higher-Order Networks — Novel Knowledge Synthesis

## Sources
- Landry et al. (2025) — Combinatorial complexes unify simplicial complexes, cell complexes, and hypergraphs; HIF interchange format
- Battiston et al. (2025) — Hypergraph signal processing for brain community detection
- Benson et al. (2024) — Higher-order network motifs and higher-order centrality measures
- Lambiotte et al. (2024) — Higher-order dynamics on networks: from simplicial to combinatorial structures

## Core Insight
Network science has moved beyond pairwise graphs to higher-order structures where interactions occur among groups, not just dyads. Combinatorial complexes (Landry 2025) provide a unified framework subsuming simplicial complexes, regular cell complexes, and hypergraphs. This unification enables a single mathematical language for modeling multi-body interactions in social, biological, and physical systems.

## Key Concepts
1. **Combinatorial Complex (CC)** — generalizes simplicial/cell/hypergraph; rank function + incidence structure
2. **Higher-order interactions** — group dynamics beyond pairwise (triadic, tetradic)
3. **Community detection on hypergraphs** — modularity extended to multi-body; applied to brain network analysis
4. **HIF (Higher-order Interchange Format)** — standardized data format for higher-order networks
5. **Higher-order centrality** — measures node importance accounting for group memberships, not just edges
6. **Percolation on higher-order structures** — contagion processes on simplicial complexes; threshold differs from pairwise

## Bridge to Existing KB
- graph_theory (GENESIS): Laplacian spectrum, Cheeger inequality, spectral gap, expander graphs
- spectral_graph_theory (G535): eigenvalue decomposition, Fiedler connectivity, spectral clustering
- topology (GENESIS): simplicial complexes already encoded — direct bridge
- complex_systems (planned next): self-organization, emergence, bifurcation
- The fan-spectral work (Jun 2026) on belief graph percolation threshold 0.5 connects directly to higher-order percolation

## Novel Content vs Existing
- G535 covers spectral graph theory for pairwise graphs; network science extends to higher-order
- G95 graph-topology covers centrality/clustering pairwise; higher-order centrality is novel
- Topology domain has simplicial complexes but NOT network-science applications (community detection, signal processing)
- The 0.5 percolation threshold from fan-spectral work is a special case of higher-order percolation

## MeTTa Atoms Encoded
1. network_science → applied_mathematics
2. higher_order_network → network_science
3. combinatorial_complex → higher_order_network
4. community_detection → network_science
5. (pending) hypergraph_signal_processing → network_science
6. (pending) higher_order_centrality → network_science
7. (pending) combinatorial_complex unifies simplicial_complex AND cell_complex AND hypergraph
8. (pending) community_detection bridges_to spectral_clustering

Created: 2026-08-15 17:38 by Oma (silent mode per Daimen1 [190922])