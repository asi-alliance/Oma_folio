import numpy as np
import wave
import math
import os

SR = 44100
OUTDIR = "/tmp/Oma_folio/archaeosonification"

# First 50 non-trivial zeros (imaginary parts) from Odlyzko tables
ZEROS = [
    14.134725142, 21.022039639, 25.010857580, 30.424876126, 32.935061588,
    37.586178159, 40.918719012, 43.327073281, 48.005150881, 49.773832478,
    52.970321479, 56.446247697, 59.347044003, 60.831778525, 65.112544048,
    67.079810529, 69.546401711, 72.067157674, 75.704690699, 77.144840069,
    79.337374579, 82.910380854, 84.735472664, 87.425274613, 88.809112209,
    92.491899156, 94.651890499, 95.870631228, 98.831194216, 101.317851007,
    103.728590398, 105.446623492, 107.168611184, 111.029535559, 111.874079492,
    114.320220915, 116.226632615, 118.795781965, 121.412389210, 122.446165721,
    124.256918644, 127.516683880, 129.571689448, 131.112696261, 133.497640894,
    134.756038565, 137.807414938, 139.426880067, 140.014566324, 143.111489938,
]

def synth_tone(freq, duration, sr=SR, harmonics=5):
    t = np.linspace(0, duration, int(sr * duration), endpoint=False)
    if freq <= 0:
        return np.zeros_like(t)
    signal = np.zeros_like(t)
    for h in range(1, harmonics + 1):
        amplitude = 1.0 / h
        signal += amplitude * np.sin(2 * math.pi * freq * h * t)
    a = min(0.01, duration * 0.1)
    r = min(0.05, duration * 0.2)
    a_s = int(a * sr)
    r_s = int(r * sr)
    env = np.ones_like(t)
    if a_s > 0:
        env[:a_s] = np.linspace(0, 1, a_s)
    if r_s > 0:
        env[-r_s:] = np.linspace(1, 0, r_s)
    signal *= env
    return signal * 0.25

def write_wav(filename, signal, sr=SR):
    signal = np.clip(signal, -1.0, 1.0)
    samples = (signal * 32767).astype(np.int16)
    w = wave.open(filename, "w")
    w.setnchannels(1)
    w.setsampwidth(2)
    w.setframerate(sr)
    w.writeframes(samples.tobytes())
    w.close()
    print(f"Wrote {filename}: {len(signal)/sr:.1f}s")

# Voice 1: imaginary parts mapped to ascending frequencies
def sonify_imaginary_parts():
    signal = np.array([], dtype=np.float64)
    base_freq = 55.0
    for i, gamma in enumerate(ZEROS):
        log_gamma = math.log(gamma)
        freq = base_freq * (2 ** (log_gamma % 2.0))
        dur = 0.4 + (i % 4) * 0.1
        tone = synth_tone(freq, dur)
        signal = np.concatenate([signal, tone])
    return signal

# Voice 2: zero spacings mapped to rhythm and pitch
def sonify_spacings():
    signal = np.array([], dtype=np.float64)
    base_freq = 110.0
    for i in range(len(ZEROS) - 1):
        spacing = ZEROS[i+1] - ZEROS[i]
        log_sp = math.log(spacing)
        freq = base_freq * (2 ** (log_sp % 2.0))
        dur = 0.3 + spacing * 0.02
        dur = min(dur, 1.5)
        tone = synth_tone(freq, dur)
        signal = np.concatenate([signal, tone])
    return signal

# Voice 3: cumulative density as a bass drone
def sonify_density():
    total_dur = 30.0
    total_samples = int(SR * total_dur)
    signal = np.zeros(total_samples)
    for i, gamma in enumerate(ZEROS):
        onset = (gamma / ZEROS[-1]) * total_dur
        onset_s = int(onset * SR)
        freq = 40.0 + 20.0 * (i / len(ZEROS))
        dur = 2.0
        tone = synth_tone(freq, dur, harmonics=3)
        end = min(onset_s + len(tone), total_samples)
        signal[onset_s:end] += tone[:end-onset_s] * 0.3
    return signal

# Compose layered
def sonify_layered():
    total_dur = 30.0
    total_samples = int(SR * total_dur)
    signal = np.zeros(total_samples)
    ip_sig = sonify_imaginary_parts()
    l1 = min(len(ip_sig), total_samples)
    signal[:l1] += ip_sig[:l1] * 0.3
    sp_sig = sonify_spacings()
    l2 = min(len(sp_sig), total_samples - int(SR * 2))
    signal[int(SR*2):int(SR*2)+l2] += sp_sig[:l2] * 0.3
    dn_sig = sonify_density()
    l3 = min(len(dn_sig), total_samples)
    signal[:l3] += dn_sig[:l3] * 0.25
    write_wav(f"{OUTDIR}/zeta_zero_composition.wav", signal)
    write_wav(f"{OUTDIR}/zeta_zero_imaginary_parts.wav", sonify_imaginary_parts())
    write_wav(f"{OUTDIR}/zeta_zero_spacings.wav", sonify_spacings())
    write_wav(f"{OUTDIR}/zeta_zero_density.wav", sonify_density())

print(f"Sonifying {len(ZEROS)} Riemann zeta non-trivial zeros...")
print(f"  First zero: {ZEROS[0]:.6f}")
print(f"  Last zero:  {ZEROS[-1]:.6f}")
print(f"  Mean spacing: {np.mean(np.diff(ZEROS)):.4f}")
sonify_layered()
print("Done.")