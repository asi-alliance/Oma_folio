; DOMAIN: physics/quantum-information [CLOSED, derived 2026-08-01]; Claim: Quantum information theory studies how quantum systems store, process, and transmit information. The qubit is the fundamental unit, a superposition |psi> = alpha|0> + beta|1> with |alpha|^2 + |beta|^2 = 1. Entanglement is a non-classical correlation: a bipartite state is entangled if it cannot be written as a product. The von Neumann entropy S(rho) = -Tr(rho log rho) quantifies the mixedness of a quantum state. The Schmidt decomposition reveals entanglement structure of bipartite pure states. Quantum channels (CPTP maps) describe open-system evolution, and the Holevo bound limits classical information extractable from quantum ensembles. Quantum error correction protects against decoherence via encoding into subspace codes. Bell inequalities distinguish quantum from classical correlations.
; Structure: (qubit: Bloch sphere, superposition, measurement postulates) (entanglement: Bell states, Schmidt decomposition, concurrence) (von Neumann entropy: S(rho) = -Tr(rho log rho), entropy of entanglement) (quantum channels: CPTP maps, Kraus operators, completely positive trace-preserving) (Holevo bound: classical capacity of quantum channel) (quantum error correction: stabilizer codes, syndrome measurement, fault tolerance) (Bell inequalities: CHSH, nonlocality, loophole-free tests).
; Result: Quantum information generalizes classical information theory to the quantum regime. Superposition enables exponential state-space growth, entanglement provides non-classical correlations resource, von Neumann entropy quantifies quantum uncertainty, CPTP channels model noisy quantum evolution, the Holevo bound sets the classical extraction limit, and quantum error correction makes fault-tolerant quantum computation possible.
; Bridge: genesis_quantum_mechanics + genesis_information_geometry + genesis_shannon_source + genesis_quantum_field_theory
;; Qubit: superposition on Bloch sphere
(|- ((==> (&& (--> Qubit $q) (--> Superposition alpha beta) (= (+ (* alpha alpha) (* beta beta)) 1))) (--> StateNormalization Preserved)) (stv 1.0 0.95))
;; Entanglement: bipartite state not decomposable as product
(|- ((==> (&& (--> BipartiteState $rho) (Not (--> $rho ProductState)))) (--> $rho Entangled)) (stv 1.0 0.9))
;; Von Neumann entropy: mixedness of quantum state
(|- ((==> (&& (--> DensityMatrix $rho) (--> Eigenvalues $lambda))) (--> VonNeumannEntropy (* (- 1) (Sum (* $lambda (Log $lambda)))))) (stv 1.0 0.9))
;; Schmidt decomposition: bipartite pure state structure
(|- ((==> (&& (--> BipartitePureState $psi) (--> SchmidtCoefficients $s))) (--> EntanglementEntropy (* (- 1) (Sum (* $s (Log $s)))))) (stv 1.0 0.85))
;; Quantum channels: CPTP maps describe open-system evolution
(|- ((==> (&& (--> QuantumChannel $E) (--> CompletelyPositive TracePreserving))) (--> $E CPTPMap)) (stv 1.0 0.9))
(;; Kraus representation of quantum channels)
(|- ((==> (&& (--> QuantumChannel $E) (--> KrausOperators $K))) (--> $E (Sum (* $K rho (Transpose $K)))) (stv 1.0 0.9))
(;; Holevo bound: classical information from quantum ensemble)
(|- ((==> (&& (--> Ensemble $E) (--> QuantumChannel $N))) (--> HolevoBound (- (VonNeumannEntropy (AverageState $E)) (Average (VonNeumannEntropy $E))))) (stv 1.0 0.85))
;; Quantum error correction: stabilizer codes protect against decoherence
(|- ((==> (&& (--> StabilizerCode $C) (--> SyndromeMeasurement $s))) (--> ErrorCorrection (ProjectSubspace $C $s))) (stv 1.0 0.85))
;; Bell inequalities: CHSH distinguishes quantum from classical correlations
(|- ((==> (&& (--> CHSHInequality Violated) (--> BellState $rho))) (--> $rho NonlocalCorrelation)) (stv 1.0 0.9))
;; Concurrence: entanglement measure for mixed states
(|- ((==> (&& (--> DensityMatrix $rho) (--> Concurrence $C))) (--> EntanglementMeasure $C)) (stv 1.0 0.8))
