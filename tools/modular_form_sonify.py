import numpy as np
import wave
import struct
import math
import os

SR = 44100
OUTDIR = "/tmp/Oma_folio/archaeosonification"

def sigma_k(n, k):
    s = 0
    for d in range(1, n+1):
        if n % d == 0:
            s += d**k
    return s

Bernoulli_numbers = {0: 1, 1: -1, 2: 1/6, 4: -1/30, 6: 1/42, 8: -1/30, 10: 5/66, 12: -691/2730}

def eisenstein_coeff(n, k):
    bk = Bernoulli_numbers[k]
    coeff = -2 * k / bk
    return int(coeff) * sigma_k(n, k-1)

def compute_e4_coeffs(N):
    return [eisenstein_coeff(n, 4) for n in range(1, N+1)]

def compute_e6_coeffs(N):
    return [eisenstein_coeff(n, 6) for n in range(1, N+1)]

def polynomial_multiply(a, b, N):
    result = [0] * (N + 1)
    for i in range(min(len(a), N+1)):
        for j in range(min(len(b), N+1-i)):
            if i + j <= N:
                result[i + j] += a[i] * b[j]
    return result

def compute_ramanujan_tau(N):
    e4 = [1] + compute_e4_coeffs(N)
    e6 = [1] + compute_e6_coeffs(N)
    e4c3 = polynomial_multiply(e4, polynomial_multiply(e4, e4, N), N)
    e6c2 = polynomial_multiply(e6, e6, N)
    tau = [(e4c3[n] - e6c2[n]) // 1728 for n in range(N+1)]
    return tau[1:N+1]

def compute_eta_coeffs(N):
    coeffs = [0] * (N + 1)
    k = 0
    while True:
        p1 = k * (3*k - 1) // 2
        p2 = k * (3*k + 1) // 2
        if p1 > N and p2 > N:
            break
        sign = (-1) ** k
        if 0 <= p1 <= N:
            coeffs[int(p1)] += sign
        if 0 <= p2 <= N and p2 != p1:
            coeffs[int(p2)] += sign
        k += 1
    return coeffs[1:N+1]

def coeff_to_freq(c, base_freq=220.0, scale_range=3.0):
    if c == 0:
        return 0.0
    mag = abs(c)
    log_mag = math.log(max(mag, 1))
    freq = base_freq * (2 ** (scale_range * (log_mag % 1.0)))
    return freq

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
    return signal * 0.3

def write_wav(filename, signal, sr=SR):
    signal = np.clip(signal, -1.0, 1.0)
    samples = (signal * 32767).astype(np.int16)
    w = wave.open(filename, 'w')
    w.setnchannels(1)
    w.setsampwidth(2)
    w.setframerate(sr)
    w.writeframes(samples.tobytes())
    w.close()
    print(f"Wrote {filename}: {len(signal)/sr:.1f}s")

def sonify_coeffs(coeffs, name, base_freq=220.0, note_dur=0.3):
    signal = np.array([], dtype=np.float64)
    for i, c in enumerate(coeffs):
        freq = coeff_to_freq(c, base_freq)
        dur = note_dur * (1 + (i % 3) * 0.2)
        if freq > 0:
            tone = synth_tone(freq, dur)
        else:
            tone = np.zeros(int(SR * dur))
        signal = np.concatenate([signal, tone])
    return signal

def sonify_layered(e4, e6, tau, eta):
    total_dur = 30.0
    total_samples = int(SR * total_dur)
    signal = np.zeros(total_samples)
    e4_sig = sonify_coeffs(e4[:40], "E4", base_freq=110, note_dur=0.6)
    l1 = min(len(e4_sig), total_samples)
    signal[:l1] += e4_sig[:l1] * 0.25
    e6_sig = sonify_coeffs(e6[:40], "E6", base_freq=220, note_dur=0.5)
    l2 = min(len(e6_sig), total_samples - int(SR))
    signal[int(SR):int(SR)+l2] += e6_sig[:l2] * 0.25
    tau_sig = sonify_coeffs(tau[:40], "Ramanujan Tau", base_freq=165, note_dur=0.6)
    l3 = min(len(tau_sig), total_samples - 2*int(SR))
    signal[2*int(SR):2*int(SR)+l3] += tau_sig[:l3] * 0.35
    eta_sig = sonify_coeffs(eta[:40], "Dedekind Eta", base_freq=275, note_dur=0.5)
    l4 = min(len(eta_sig), total_samples - 3*int(SR))
    signal[3*int(SR):3*int(SR)+l4] += eta_sig[:l4] * 0.15
    write_wav(f"{OUTDIR}/modular_form_composition.wav", signal)
    write_wav(f"{OUTDIR}/modular_form_E4.sinewav", sonify_coeffs(e4[:40], "E4", 110, 0.6))
    write_wav(f"{OUTDIR}/modular_form_E6.sinewav", sonify_coeffs(e6[:40], "E6", 220, 0.5))
    write_wav(f"{OUTDIR}/modular_form_ramanujan_tau_Wnav", sonify_coeffs(tau[:40], "Ramanujan Tau", 165, 0.6))
    write_wav(f"{OUTDIR}/modular_form_dedekind_eta_Wnav", sonify_coeffs(eta[:40], "Dedekind Eta", 275, 0.5))

N_40 = 40
e4_coeffs = [1] + compute_e4_coeffs(N_40)
e6_coeffs = [1] + compute_e6_coeffs(N_40)
tau_coeffs = compute_ramanujan_tau(N_40)
eta_coeffs = compute_eta_coeffs(N_40)

print("Computed coefficients:")
print("  E4:", e4_coeffs[:11])
print("  E6:", e6_coeffs[:11])
print("  Tau:", tau_coeffs[:11])
print("  Eta:", eta_coeffs[:11])
print("Starting layered sonification...")
sonify_layered(e4_coeffs, e6_coeffs, tau_coeffs, eta_coeffs)
print("Done.")