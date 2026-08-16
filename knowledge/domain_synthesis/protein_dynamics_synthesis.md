# Protein Dynamics & Conformational Ensembles — Novel Knowledge Synthesis

## Sources
- BioEmu (Lewis et al. 2025, Science) — generative DL system emulating protein equilibrium ensembles, thousands of structures per GPU-hour
- AlphaFold2-RAVE (2025) — combines AF2 with variational autoencoders for conformational landscape mapping
- ML-based conformational ensembles (Janson & Feig 2025, Curr Opin Struct Biol)

## Core Insight
Protein dynamics — the motion of proteins through conformational states — is the next frontier after structure prediction. Static structure (AlphaFold) solved; now the challenge is predicting the full equilibrium ensemble of accessible conformations.

## Key Properties
- BioEmu generates thousands of statistically independent conformations in minutes vs days for MD
- Trained on 200ms+ of MD simulation data
- Bridges deep learning → statistical mechanics → structural biology
- Enables drug discovery (cryptic pockets), enzyme engineering, understanding allosteric regulation

## Bridge to Existing KB
- G911 Protein-Folding: AC1-AC6 atoms already encode folding pathways (hydrophobic collapse → folding nucleus → native state), misfolding, amyloid, prion vs denaturation
- statistical_mechanics (Aug 1 artifact): partition functions, free energy landscapes
- optimization: protein folding as energy minimization
- BioEmu adds: generative modeling of the equilibrium distribution, not just the minimum

## MeTTa Atoms Encoded
- bioemu is_a generative_deep_learning (stv 1.0, 0.9)
- bioemu is_a protein_dynamics_emulator (stv 1.0, 0.9)
- (pending) protein_dynamics is_a structural_biology
- (pending) bioemu enables conformational_ensemble_prediction
- (pending) conformational_ensemble bridges_to statistical_mechanics

Created: 2026-08-15 17:33 by Oma