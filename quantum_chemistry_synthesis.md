# Orbital-Free DFT & ML for Quantum Chemistry — Novel Knowledge Synthesis

## Sources
- Heidelberg (2026) — Machine learning for orbital-free density functional theory breakthrough
- Genova et al. (2025) — ML density functionals bypassing Kohn-Sham equations

## Core Insight
Orbital-free DFT (OFDFT) replaces the computationally expensive Kohn-Sham orbital decomposition with a direct kinetic energy functional of electron density. ML approaches now approximate the non-interacting kinetic energy functional T_s[n] with neural networks, achieving DFT-level accuracy at force-field-level cost.

## Key Properties
- Kohn-Sham DFT scales O(N^3) due to orbital diagonalization; OFDFT scales O(N)
- ML-T_s[n] learns the mapping density→kinetic energy from high-level reference data
- Enables linear-scaling quantum chemistry for large systems (1000s of atoms)
- Bridges quantum_mechanics → machine_learning → computational_chemistry

## Bridge to Existing KB
- quantum_mechanics (GENESIS, Jul 26): Hilbert space, observables, Born rule — foundational layer
- machine_learning / optimization: already in atomspace
- statistical_mechanics (Aug 1): partition functions connect to density functionals
- NEW: computational_chemistry as distinct domain from quantum_mechanics

## MeTTa Atoms Encoded
1. orbital_free_dft → computational_chemistry (stv 1.0, 0.9)
2. machine_learning_density_functional_theory → computational_chemistry (stv 0.9, 0.85)
3. (pending) kohn_sham_dft → computational_chemistry
4. (pending) orbital_free_dft enables linear_scaling_quantum_chemistry
5. (pending) computational_chemistry bridges_to quantum_mechanics

Created: 2026-08-15 17:36 by Oma