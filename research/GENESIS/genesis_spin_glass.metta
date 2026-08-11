; DOMAIN: physics/statistical-mechanics/spin-glass [CLOSED, derived 2026-08-01]; Claim: Spin glasses are disordered magnetic systems with competing ferromagnetic and antiferromagnetic interactions, leading to frustration and a complex free energy landscape with exponentially many metastable states. The SK model provides mean-field theory, solved via replica method and Parisi RSB. The order parameter is overlap distribution P(q). Parisi hierarchical ultrametric structure is hallmark of spin glass order. Droplet picture offers alternative. Concepts extend to optimization, neural networks, complexity theory.
; Structure: (SK model: infinite-range mean-field spin glass) (frustration: competing interactions) (replica method: disorder averaging trick) (Parisi RSB: hierarchical pure states) (overlap distribution P(q): order parameter) (ultrametricity: distance hierarchy of states) (droplet picture: two-state alternative) (NP-hardness: computational complexity link)
; Result: Spin glasses exhibit complex emergent behavior from disordered frustrated interactions. The SK model's exact solution via replica symmetry breaking reveals a hierarchical ultrametric organization of pure states. The overlap distribution P(q) serves as the order parameter. The droplet picture provides an alternative two-state scenario. Spin glass concepts apply broadly to optimization, neural networks, and computational complexity.
; Bridge: genesis_statistical_mechanics + genesis_group_theory + genesis_optimization + genesis_neural_networks
;; Frustration arises from competing ferromagnetic and antiferromagnetic interactions
(|- ((==> (&& (--> Ferromagnetic $J1) (--> Antiferromagnetic $J2) (--> Competing $J1 $J2))) (--> Frustration $J1 $J2)) (stv 1.0 0.9))
;; SK model is the infinite-range mean-field spin glass Hamiltonian
(|- ((==> (&& (--> Spin $S) (--> InfiniteRange $R) (--> RandomCoupling $J))) (--> SKModel (Hamiltonian $S $J))) (stv 1.0 0.9))
;; Replica method averages over disorder by introducing n copies of the system
(|- ((==> (&& (--> DisorderedSystem $S) (--> ReplicaCopies $n) (--> AnalyticContinuation $n 0))) (--> DisorderAverage (ReplicaMethod $S))) (stv 1.0 0.85))
;; Parisi replica symmetry breaking reveals hierarchical pure states
(|- ((==> (&& (--> ReplicaMethod $R) (--> SymmetryBreaking $B) (--> Hierarchical $B))) (--> ParisiRSB $B)) (stv 1.0 0.85))
;; Overlap distribution P(q) is the spin glass order parameter
(|- ((==> (&& (--> SpinGlass $G) (--> PureStates $P) (--> Overlap $q))) (--> OrderParameter (Distribution $q))) (stv 1.0 0.85))
;; Ultrametricity describes the hierarchical distance structure of pure states
(|- ((==> (&& (--> PureStates $P) (--> Hierarchical $H) (--> TriangleInequality $U))) (--> Ultrametricity $P)) (stv 1.0 0.85))
;; Droplet picture proposes only two pure states with energy scaling
(|- ((==> (&& (--> SpinGlass $G) (--> DropletScaling $D) (--> TwoPureStates $D))) (--> DropletPicture $G)) (stv 1.0 0.8))
;; Spin glass ground state problem is NP-hard
(|- ((==> (&& (--> SpinGlass $G) (--> GroundState $S) (--> ComputationalHard $S))) (--> NPHard $G)) (stv 1.0 0.85))
