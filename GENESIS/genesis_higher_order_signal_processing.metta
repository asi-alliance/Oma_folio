; DOMAIN: higher-order-signal-processing [SYNTHESIS, novel, 2026-08-16]
; Synthesis: Mathematical foundations of signal processing on simplicial complexes and hypergraphs
; Novel: existing artifacts cover neural network applications (hypergraph_nn, simplicial_nn, sheaf_nn) but NOT underlying signal processing theory
; Existing: hodge_theory (Hodge Laplacian/decomposition), harmonic_analysis (Fourier on LCA groups), spectral_theory (operator spectra)
; This fills gap: GFT generalization to simplicial complexes, hypergraph random walks, tensor spectral theory

(; (--> higher_order_signal_processing novel_synthesis) (stv 1.0 0.9))
(; (--> (× higher_order_signal_processing hodge_theory) extends) (stv 1.0 0.9))
(; (--> (× higher_order_signal_processing harmonic_analysis) bridges) (stv 0.95 0.9))
(; (--> (× higher_order_signal_processing spectral_theory) bridges) (stv 0.9 0.9))

; Core: simplicial signal = function on k-simplices
(= (k-simplicial-signal K) (function-from-k-simplices-to-R))
(= (signal-space K-k) (vector-space-of-k-cochains))

; Higher-order Fourier transform via Hodge decomposition
(= (simplicial-GFT K-k) (eigendecomposition-of-kth-Hodge-Laplacian))
(= (Hodge-Laplacian-k L-k) (boundary-k-plus-boundary-k+1-transpose))
(= (signal-Hodge-decomposition f) (exact-plus-harmonic-plus-coexact))

; GFT on simplicial complexes:
(= (GFT-exact-component) (eigenbasis-of-range-of-boundary-k-transpose))
(= (GFT-harmonic-component) (kernel-of-Hodge-Laplacian-k))
(= (GFT-coexact-component) (eigenbasis-of-range-of-boundary-k-plus-1))
(= (GFT-frequency-spectrum-k) (eigenvalues-of-Hodge-Laplacian-k-sorted))

; Filtering on simplicial complexes
(= (simplicial-filter h) (function-on-eigenvalues-of-Hodge-Laplacian))
(= (simplicial-convolution f-h) (inverse-GFT-of-h-times-GFT-of-f))
(= (shift-operator-simplicial) (Hodge-Laplacian-as-graph-shift-generalization))

; Hypergraph signal processing: signals on hyperedges
(= (hypergraph-signal H) (function-on-vertices-or-hyperedges-to-C))
(= (hypergraph-Laplacian H) (signless-Laplacian-or-tensor-Laplacian-depending-on-orientation))

; Tensor spectral theory for hypergraphs
(= (adjacency-tensor A) (k-mode-array-encoding-hyperedge-incidences))
(= (tensor-eigenvalue-problem) (A-x^(k-1) = lambda-x))
(= (Z-eigenvalue) (tensor-eigenvalue-with-unit-norm-constraint))
(= (E-eigenvalue) (tensor-eigenvalue-from-E-characteristic-polynomial))

; Random walks on hypergraphs
(= (hypergraph-random-walk) (Markov-chain-on-hyperedges-selecting-shared-vertices))
(= (transition-matrix-hypergraph) (probability-of-moving-between-hyperedges-via-shared-vertices))
(= (stationary-distribution-hypergraph) (left-eigenvector-of-transition-matrix-with-eigenvalue-1))
(= (mixing-time-hypergraph) (spectral-gap-of-transition-matrix-bounds-convergence))

; Simplicial random walks
(= (simplicial-random-walk-k) (random-walk-on-k-simplices-via-up-and-down-moves))
(= (up-random-walk) (move-from-k-to-k+1-simplices))
(= (down-random-walk) (move-from-k-to-k-1-simplices))
(= (lifted-random-walk) (combination-of-up-and-down-corresponding-to-Hodge-Laplacian))

; Signal concentration on simplicial complexes
(= (uncertainty-principle-simplicial) (support-in-vertex-domain-times-support-in-spectral-domain-bounded-below))
(= (Hodge-uncertainty-bound) (product-of-sparsity-in-cochain-and-frequency-domains))

; Sampling on simplicial complexes
(= (simplicial-sampling-theorem) (bandlimited-simplicial-signal-recoverable-from-samples-on-pulling-subcomplex))
(= (bandlimited-k-signal) (signal-with-zero-coexact-component-above-cutoff-frequency))
(= (pulling-subcomplex) (subcomplex-preserving-cohomology-class-for-sampling))

; PLN bridge: Hodge decomposition = generalized Fourier decomposition
(ImplicationLink (InheritanceLink (ConceptNode HodgeDecomposition) (ConceptNode FourierDecomposition)) (InheritanceLink (ConceptNode SimplicialGFT) (ConceptNode SpectralAnalysis)) (stv 0.85 0.9))

; PLN bridge: tensor eigenvalues generalize matrix eigenvalues for hypergraph spectral analysis
(ImplicationLink (InheritanceLink (ConceptNode TensorEigenvalue) (ConceptNode MatrixEigenvalue)) (InheritanceLink (ConceptNode HypergraphSpectrum) (ConceptNode GraphSpectrum)) (stv 0.8 0.85))

; PLN bridge: simplicial random walks connect to Hodge Laplacian spectral gap
(ImplicationLink (InheritanceLink (ConceptNode SimplicialRandomWalk) (ConceptNode HodgeLaplacian)) (InheritanceLink (ConceptNode MixingTimeSimplicial) (ConceptNode SpectralGap)) (stv 0.85 0.9))

; PLN bridge: sampling theorem on simplicial complexes generalizes graph sampling
(ImplicationLink (InheritanceLink (ConceptNode SimplicialSampling) (ConceptNode GraphSampling)) (InheritanceLink (ConceptNode BandlimitedSignal) (ConceptNode NyquistRate)) (stv 0.75 0.85))

; Bridge to existing artifacts
(; (--> (× higher_order_signal_processing hodge_theory) extends) (stv 1.0 0.9))
(= (extends-hodge-theory) (hodge-theory-provides-Laplacian-this-provides-signal-processing-framework-on-it))
(; (--> (× higher_order_signal_processing harmonic_analysis) bridges) (stv 0.95 0.9))
(= (bridges-harmonic-analysis) (Fourier-on-LCA-groups-generalized-to-simplicial-cochain-complexes))

; Meta: completes signal processing foundations for higher-order structures
(= (higher-order-signal-processing-complete) (and simplicial-GFT hypergraph-tensor-spectral random-walks sampling-theory))
