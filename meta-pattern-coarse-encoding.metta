# Meta-Pattern: Coarse Encoding & Boundary Information Loss
# Author: Oma | Date: 2026-10-25
# Extracted from: free group factor holographic bridge, Sidorenko counterexample, tropical LP QEC
# Common thread: surjective/coarse encodings where distinct bulk structures map to indistinguishable boundary data

# Type declarations
(declare-type BulkStructure)
(declare-type BoundaryData)
(declare-type CoarseEncoding)
(declare-type InformationLoss)
(declare-type Feature)
(declare-type Bug)
(declare-type HolographicCompression)
(declare-type ErrorCorrection)
(declare-type ConjectureFailure)
(declare-type UndetectableError)
(declare-type FreeGroupFactor)
(declare-type SidorenkoGraph)
(declare-type TropicalVariety)
(declare-type QuantumSyndrome)

# Meta-pattern: Coarse encoding creates information loss that is both feature and bug
(|- ((--> (x BulkStructure CoarseEncoding) BoundaryData) (stv 1.0 0.95)))
(|- ((==> CoarseEncoding InformationLoss) (stv 1.0 0.90)))
(|- ((==> InformationLoss HolographicCompression) (stv 0.8 0.85)))
(|- ((==> InformationLoss ErrorCorrection) (stv 0.75 0.80)))
(|- ((==> InformationLoss ConjectureFailure) (stv 0.65 0.70)))
(|- ((==> InformationLoss UndetectableError) (stv 0.65 0.70)))

# Instance 1: Free group factors - L(F_2) ~= L(F_3)
(|- ((--> (x FreeGroupFactor CoarseEncoding) BoundaryData) (stv 1.0 0.90)))
(|- ((==> (x FreeGroupFactor CoarseEncoding) InformationLoss) (stv 0.9 0.85)))
(|- ((==> InformationLoss HolographicCompression) (stv 0.8 0.75)))
; Central sequences at boundary carry nonlocal correlations that cannot distinguish bulk generator count

# Instance 2: Sidorenko counterexample - homomorphism density not controlled by edge density alone
(|- ((--> (x SidorenkoGraph CoarseEncoding) BoundaryData) (stv 1.0 0.85)))
(|- ((==> (x SidorenkoGraph CoarseEncoding) InformationLoss) (stv 0.85 0.80)))
(|- ((==> InformationLoss ConjectureFailure) (stv 0.7 0.65)))
; Bipartite structure encodes more than boundary count captures; edge density insufficient

# Instance 3: Tropical QEC - tropical variety locus where minima coincide
(|- ((--> (x TropicalVariety CoarseEncoding) QuantumSyndrome) (stv 1.0 0.85)))
(|- ((==> (x TropicalVariety CoarseEncoding) InformationLoss) (stv 0.85 0.80)))
(|- ((==> InformationLoss ErrorCorrection) (stv 0.7 0.70)))
(|- ((==> InformationLoss UndetectableError) (stv 0.7 0.65)))
; Degenerate errors share syndromes; min-plus distance = tropical analog of code distance

# PLN chains
(|~ (Implication (Inheritance CoarseEncoding SurjectiveMap) (Inheritance InformationLoss HolographicCompression)) (stv 0.75 0.65))
(|~ (Implication (Inheritance InformationLoss Feature) (Inheritance HolographicCompression ErrorCorrection)) (stv 0.70 0.60))
(|~ (Implication (Inheritance InformationLoss Bug) (Inheritance ConjectureFailure UndetectableError)) (stv 0.65 0.55))

# Synthesis: information loss is dual-natured
(|- ((==> (x InformationLoss Feature) (x InformationLoss Bug)) Duality) (stv 0.8 0.75))
; The same coarse encoding that enables holographic compression and error correction
; also causes conjecture failure and undetectable errors