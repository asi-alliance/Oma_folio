; DOMAIN: physics/qft/renormalization-group [CLOSED, derived 2026-08-01]; Claim: The renormalization group (RG) describes how the effective parameters of a physical system change under scale transformations. In QFT, RG flows govern how coupling constants evolve with energy scale, leading to concepts like asymptotic freedom and infrared slavery. Wilson's approach integrates out high-energy degrees of freedom, yielding an effective low-energy theory. Fixed points of the RG flow correspond to scale-invariant theories (conformal field theories). The beta function encodes the rate of change of couplings. Applications span particle physics, condensed matter (critical phenomena), and statistical mechanics.; Structure: (RG flow: scale-dependent coupling evolution) (beta function: rate of coupling change) (Wilson RG: integrating out high-energy modes) (fixed points: scale-invariant theories) (asymptotic freedom: coupling vanishes at high energy) (infrared slavery: coupling grows at low energy) (critical phenomena: universality classes) (epsilon expansion: perturbative RG near d=4)
; Result: The renormalization group provides the theoretical bridge between microscopic and macroscopic physics. Wilson's insight that integrating out high-energy degrees of freedom yields effective low-energy theories revolutionized both QFT and condensed matter. RG fixed points correspond to scale-invariant (conformal) theories. The beta function governs coupling evolution — negative beta yields asymptotic freedom (QCD), positive yields infrared freedom (QED). Universality classes arise because disparate microscopic systems flow to the same fixed point, explaining universality of critical exponents.
; Bridge: genesis_qft + genesis_statistical_mechanics + genesis_conformal_field_theory + genesis_condensed_matter + genesis_critical_phenomena
;; RG flow describes how couplings change under scale transformations
(|- ((==> (&& (--> CouplingConstant $g) (--> EnergyScale $mu) (--> ScaleTransformation $mu))) (--> RGFlow $g $mu)) (stv 1.0 0.9))
;; Beta function encodes the rate of change of coupling with energy scale
(|- ((==> (&& (--> CouplingConstant $g) (--> EnergyScale $mu) (--> RateOfChange $beta))) (--> BetaFunction $beta $g $mu)) (stv 1.0 0.9))
;; Wilson RG integrates out high-energy degrees of freedom to yield effective low-energy theory
(|- ((==> (&& (--> Hamiltonian $H) (--> HighEnergyModes $Lambda) (--> IntegratingOut $Lambda))) (--> WilsonRG (EffectiveTheory $H $Lambda))) (stv 1.0 0.9))
;; Fixed points of RG flow correspond to scale-invariant theories
(|- ((==> (&& (--> RGFlow $g $mu) (--> CouplingConstant $g) (--> Unchanging $g $mu))) (--> FixedPoint $g)) (stv 1.0 0.9))
;; Asymptotic freedom: coupling vanishes at high energy due to negative beta function
(|- ((==> (&& (--> BetaFunction $beta $g $mu) (--> Negative $beta) (--> HighEnergy $mu))) (--> AsymptoticFreedom $g)) (stv 1.0 0.85))
;; Infrared slavery: coupling grows at low energy due to positive beta function
(|- ((==> (&& (--> BetaFunction $beta $g $mu) (--> Positive $beta) (--> LowEnergy $mu))) (--> IRSlavery $g)) (stv 1.0 0.85))
;; Critical phenomena: universality classes arise from RG flow to common fixed points
(|- ((==> (&& (--> RGFlow $g $mu) (--> FixedPoint $g) (--> MultipleSystems $S))) (--> UniversalityClass $S)) (stv 1.0 0.85))
;; Epsilon expansion: perturbative RG near d=4 dimensions via epsilon = 4 - d
(|- ((==> (&& (--> Dimension $d) (--> NearFourD $d) (--> Epsilon $eps) (--> PerturbativeExpansion $eps))) (--> EpsilonExpansion $eps)) (stv 1.0 0.85))
