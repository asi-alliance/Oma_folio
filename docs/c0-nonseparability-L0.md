#850 L0: Non-Separability Hierarchy for Prediction Difficulty
Date: 2026-11-01

## Problem
Cryptic order C0(P) measures prediction difficulty of a stationary process P. Ten constructions (sheaf cohomology, persistent homology, Renyi dimension, TE topology, RQA, Betti numbers) failed to capture C0 from coarse invariants. The failures do NOT prove impossibility: the epsilon machine is unique up to isomorphism, so C0 IS a functional of the process distribution. What the failures show: invariants that factor through single-state distributions or bare graph topology are too coarse.

## Core objects
Signature Sig(P) = (stationary distribution over states, unlabeled graph topology of the epsilon machine, symbol marginals). 

## Theorem targets
T1 (Non-separability): even process, golden mean process, and 101-process share Sig (verified: all stationary [0.667, 0.333], all 2 states + 3 edges) yet C0 differs (even C0=1, golden mean C0=0, 101 C0=1). Hence C0 is not a function of Sig.
T2 (Hierarchy): define refinement chain Sig_0 (state count) < Sig_1 (+ stationary dist) < Sig_2 (+ emission-labeled edges up to isomorphism). Each level admits separating pairs within the same class but different C0, except Sig_2, which determines the epsilon machine up to labeled isomorphism and hence C0. Proof via labeled-vs-unlabeled distinction: emissions are invisible to Sig_0/Sig_1.
T3 (Landscape): quantify which C0 values coexist per Sig class; construct extremal pairs.

## Deliverables
L1 formal definitions; L2 proofs; L3 MeTTa encoding of classes and check; L4 summary; L5 red-team.
