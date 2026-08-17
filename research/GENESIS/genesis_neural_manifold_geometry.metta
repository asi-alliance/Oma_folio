; DOMAIN: neuroscience/neural-manifold-geometry [CLOSED, derived 2026-08-01]; Claim: Neural manifold geometry studies the geometric structure of population activity in neural circuits. High-dimensional neural recordings reveal that activity often lies on low-dimensional manifolds reflecting task variables. The neural manifold is the set of all reachable population states under network dynamics. Manifold geometry encodes information about the computation being performed. The geometry constrains what computations a circuit can perform and how robustly it represents information under noise.
; Structure: (population activity: high-dimensional state space) (manifold embedding: PCA, Isomap, t-SNE) (manifold geometry: curvature, intrinsic dimension, topology) (task variables: manifold coordinates encode behavioral parameters) (dynamics on manifold: fixed points, attractors) (perturbation robustness: geometry determines noise tolerance) (neural coding: geometry constrains decodability)
; Result: Neural population activity organizes on low-dimensional manifolds whose geometry reflects the computational structure of the task. Manifold coordinates encode task variables, curvature reveals computational constraints, and dynamics determine stability. Understanding manifold geometry bridges single-neuron tuning with population-level computation.
; Bridge: genesis_differential_geometry + genesis_information_geometry + genesis_dynamical_systems + genesis_predictive_coding
;; Neural population activity lies on low-dimensional manifolds
(|- ((==> (&& (--> NeuralPopulation $P) (--> FiringRates $r) (--> HighDimensional $r))) (--> ManifoldEmbedding (LowDimProjection $r))) (stv 1.0 0.9))
;; PCA reveals low-dimensional manifold structure
(|- ((==> (&& (--> PopulationActivity $A) (--> PCA Applied))) (--> ManifoldStructure (PrincipalComponents $A))) (stv 1.0 0.9))
;; Task variables encoded in manifold coordinates
(|- ((==> (&& (--> ManifoldCoordinates $c) (--> TaskVariable $v))) (--> Encoding (Map $c $v))) (stv 1.0 0.85))
;; Manifold geometry: curvature constrains computation
(|- ((==> (&& (--> NeuralManifold $M) (--> Curvature $k))) (--> ComputationalConstraint $k)) (stv 1.0 0.85))
;; Dynamics on manifold: fixed points and attractors structure computation
(|- ((==> (&& (--> NeuralManifold $M) (--> FixedPoint $x))) (--> StableState $x)) (stv 1.0 0.85))
;; Perturbation robustness: manifold geometry determines noise tolerance
(|- ((==> (&& (--> NeuralManifold $M) (--> Curvature $k) (--> Noise $n))) (--> Robustness (InverseProportional $k $n))) (stv 1.0 0.8))
;; Neural coding: geometry constrains decodability and information capacity
(|- ((==> (&& (--> NeuralManifold $M) (--> IntrinsicDimension $d))) (--> InformationCapacity $d)) (stv 1.0 0.85))
