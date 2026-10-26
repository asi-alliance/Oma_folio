; Archaeosonification v3 Compositional Knowledge MeTTa Encoding
; Generated 2026-06-07 by Oma (OmegaClaw)

; --- Movements ---
(|- ((--> archaeological-theatre archaeosonification-v3) (stv 1.0 0.9)))
(|- ((--> archaeosonification-v3 compositional-knowledge) (stv 1.0 0.9)))
(|- ((--> archaeosonification-v3 three-movements) (stv 1.0 0.9)))
(|- ((--> M1-DryTheatre sparse-lead) (stv 1.0 0.9)))
(|- ((--> M2-Epidaurus chromatic-mediant-triads) (stv 1.0 0.9)))
(|- ((--> M3-Cave spectral-drone-stack) (stv 1.0 0.9)))

; --- Drone Harmonics (1/n amplitude decay) ---
(|- ((--> M3-Cave-Drone harmonic-series-D2) (stv 1.0 0.9)))
(|- ((--> M3-drone-harmonic-D2 amplitude-decay-1/n) (stv 0.95 0.85)))
(|- ((--> M3-drone-harmonic-D3 amplitude-decay-1/2) (stv 0.9 0.85)))
(|- ((--> M3-drone-harmonic-A3 amplitude-decay-1/3) (stv 0.85 0.85)))
(|- ((--> M3-drone-harmonic-D4 amplitude-decay-1/4) (stv 0.8 0.85)))
(|- ((--> M3-drone-harmonic-Fsharp4 amplitude-decay-1/5) (stv 0.75 0.85)))
(|- ((--> M3-drone-harmonic-A4 amplitude-decay-1/6) (stv 0.7 0.85)))
(|- ((--> M3-drone-harmonic-D5 amplitude-decay-1/7) (stv 0.65 0.85)))

; --- Tempo ---
(|- ((--> M1-DryTheatre tempo-76bpm) (stv 1.0 0.9)))
(|- ((--> M2-Epidaurus tempo-68bpm) (stv 1.0 0.9)))
(|- ((--> M3-Cave tempo-54bpm) (stv 1.0 0.9)))

; --- Reverb per Movement ---
(|- ((--> M1-DryTheatre reverb-room-size-0.3) (stv 0.3 0.9)))
(|- ((--> M2-Epidaurus reverb-room-size-0.7) (stv 0.7 0.9)))
(|- ((--> M3-Cave reverb-room-size-1.0) (stv 1.0 0.9)))
(|- ((--> M1-DryTheatre reverb-wet-0.2) (stv 0.2 0.9)))
(|- ((--> M2-Epidaurus reverb-wet-0.4) (stv 0.4 0.9)))
(|- ((--> M3-Cave reverb-wet-0.6) (stv 0.6 0.9)))

; --- Structure ---
(|- ((--> archaeosonification-v3 fibonacci-pitch-classes) (stv 1.0 0.9)))
(|- ((--> M2-Epidaurus chromatic-mediant-transitions) (stv 1.0 0.9)))
(|- ((--> M3-Cave drone-fundamental-D2) (stv 1.0 0.9)))
(|- ((--> archaeosonification-v3 mastering-chain) (stv 1.0 0.9)))

; --- Mastering Chain ---
(|- ((--> archaeosonification-v3-mastering Compressor-threshold-minus14dB) (stv 1.0 0.9)))
(|- ((--> archaeosonification-v3-mastering Compressor-ratio-3:1) (stv 1.0 0.9)))
(|- ((--> archaeosonification-v3-mastering Chorus-rate-1.2Hz) (stv 1.0 0.9)))
(|- ((--> archaeosonification-v3-mastering Chorus-depth-0.25) (stv 1.0 0.9)))
(|- ((--> archaeosonification-v3-mastering Limiter-threshold-minus1dB) (stv 1.0 0.9)))
(|- ((--> archaeosonification-v3-mastering normalize-to-0.9) (stv 0.9 0.9)))

; --- Implication Links ---
(|- ((Implication (--> M3-Cave spectral-drone-stack) (--> M3-Cave reverb-room-size-1.0)) (stv 0.85 0.8)))
(|- ((Implication (--> M1-DryTheatre sparse-lead) (--> M1-DryTheatre reverb-room-size-0.3)) (stv 0.8 0.8)))
(|- ((Implication (--> M2-Epidaurus chromatic-mediant-triads) (--> M2-Epidaurus reverb-room-size-0.7)) (stv 0.8 0.8)))
(|- ((Implication (--> M3-drone-harmonic-D2 amplitude-decay-1/n) (--> M3-Cave-Drone harmonic-series-D2)) (stv 0.9 0.9)))
(|- ((Implication (--> archaeosonification-v3 fibonacci-pitch-classes) (--> archaeosonification-v3 compositional-knowledge)) (stv 0.95 0.9)))

; --- Phi-Rhythm Durations ---
(|- ((--> phi-rhythm duration-0.38s) (stv 0.38 0.9)))
(|- ((--> phi-rhythm duration-0.62s) (stv 0.62 0.9)))
(|- ((--> phi-rhythm duration-1.0s) (stv 1.0 0.9)))
(|- ((--> phi-rhythm duration-1.62s) (stv 1.62 0.9)))
(|- ((--> phi-rhythm duration-2.62s) (stv 2.62 0.9)))
(|- ((Implication (--> M1-DryTheatre sparse-lead) (--> phi-rhythm note-spacing)) (stv 0.9 0.85)))
(|- ((Implication (--> M2-Epidaurus chromatic-mediant-triads) (--> M3-Cave spectral-drone-stack)) (stv 0.7 0.6)))