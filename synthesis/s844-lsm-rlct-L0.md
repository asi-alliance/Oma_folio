# Synthesis #844: Liquid State Machines × RLCT — L0 Scoping
Date: 2026-11-03 | Status: L0 (scoping, pre-claims)

## Object
Liquid State Machine (Maass et al.): fixed random reservoir of spiking neurons (typically LIF) driven by continuous input; state read out via trained kernel function (linear readout on spike-train kernels: firing rate, synfire-style temporal kernels, or spike-trace convolution).

## Why it is not covered
- #158 SNN × RLCT: generic SNN spike-threshold singularity, whole-network learning. #843 ESN × RLCT: analog reservoir, continuous tanh states. LSM = spiking + fixed reservoir + kernel readout: the piecewise/event-driven structure collides with the frozen-reservoir reduced problem — new ground.
- External: websearches found zero SLT/RLCT × LSM; RC generalization results are Rademacher/martingale only.

## Core tensions to formalize
1. Definability wall: spike times are discontinuous functions of parameters/input (threshold crossing is a measure-zero switching event, cf. #158). Kernel readout on spike trains (smooth kernel convolution) may restore R_an,exp definability for the readout loss — the KERNEL acts as a definability restorer. This is a genuinely new mechanism: smooth out the spikes before the loss, not after (contrast #354 STE which backprops through discrete decisions).
2. Reduced problem: like #843, only the readout is trained → readout fiber; claim λ_readout ≤ λ_full at the locked reservoir. The spike-train kernel map is NON-smooth in parameters but the trained part (readout weights on fixed kernel features) is linear — the reduction is even cleaner than #843, but the feature map is not analytic. Does Watanabe still apply, or does the definability fail first?
3. Separation property (liquid-applied-computing core): input separation depends on reservoir regime (connectivity density, synaptic time constants, inhibitory/excitatory balance). Analog of #843's ρ as stratum selector: separation C_sep as a (non-spectral-radius) selector — what is the right coordinate for spiking reservoirs? Pseudo-spectrum has no direct analog; candidates: eigen-spectrum of the mean-field rate map, Lyapunov exponent of the spiking dynamics.
4. Spike-count / rate kernels: as kernel width σ → ∞, the readout sees rates only (loses temporal info, smoother features); σ → 0 recovers discrete spikes (max information, maximal non-analyticity). Kernel width σ is a continuous definability/stratum dial — dual of #566 N_gaussians and #843 ρ.
5. Memory capacity (Maass liquid memory function) vs d_eff: analog of #843 OP4 but for event-driven states — short-term plasticity and time constants set the memory kernel, which shapes the covariance degeneracy of kernel features.

## Candidate claims (to refine in L1)
- C1 (provable?): readout loss is definable for SMOOTH kernels; loss of definability as σ→0.
- C2: λ_readout ≤ λ_full at locked reservoir (projection argument).
- C3 (star candidate): kernel width σ as continuous stratum/definability selector; separation property regime as second selector.
- C4: G ~ λ_eff(σ, regime)/n + U(σ)/√n.
- C5: SGLD LLC signature on readout as σ and reservoir regime sweep.

## Open problems seed
- Is spike-threshold definability failure removable by kernel smoothing (quantify: error terms vs σ)?
- Right spectral coordinate for spiking reservoirs (no clean ρ).
- Fading memory property (echo-state analog) for point-process states: formal analog of #843 D4.

## Cross-refs (planned)
#8, #158, #354, #383, #480, #566, #601, #843

## Next
L1 formalization.
