import numpy as np
import wave
import os

SR = 44100
OUTDIR = "/tmp/Oma_folio/archaeosonification"

def read_wav(fn):
    w = wave.open(fn, 'r')
    n = w.getnframes()
    raw = w.readframes(n)
    w.close()
    return np.frombuffer(raw, dtype=np.int16).astype(np.float32) / 32768.0

def write_wav(fn, a):
    a = np.clip(a, -1, 1)
    a16 = (a * 32767).astype(np.int16)
    with wave.open(fn, 'w') as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(SR)
        w.writeframes(a16.tobytes())
    return fn

def norm(a, t=0.7):
    m = np.max(np.abs(a))
    if m > 0: a = a * (t/m)
    return a

def fade(a, sr=SR, dur=0.5):
    n = int(sr * dur)
    if n > len(a): n = len(a)
    a[:n] *= np.linspace(0, 1, n)
    a[-n:] *= np.linspace(1, 0, n)
    return a

# Load sources
pisot_comp = read_wav(os.path.join(OUTDIR, "pisot_composition.wav"))
pisot_fib = read_wav(os.path.join(OUTDIR, "pisot_pitched_fibonacci.wav"))
pisot_pad = read_wav(os.path.join(OUTDIR, "pisot_pitched_padovan.wav"))
np_orbit = read_wav(os.path.join(OUTDIR, "nonpisot_sqrt2_orbit.wav"))
np_weakmix = read_wav(os.path.join(OUTDIR, "nonpisot_sqrt2_weakmix.wav"))

print(f"pisot_comp: {len(pisot_comp)/SR:.1f}s")
print(f"pisot_fib: {len(pisot_fib)/SR:.1f}s")
print(f"pisot_pad: {len(pisot_pad)/SR:.1f}s")
print(f"np_orbit: {len(np_orbit)/SR:.1f}s")
print(f"np_weakmix: {len(np_weakmix)/SR:.1f}s")

# Movement durations (seconds)
M1_DUR = 20
M2_DUR = 20
M3_DUR = 20
TOTAL = M1_DUR + M2_DUR + M3_DUR
total_samples = TOTAL * SR

out = np.zeros(total_samples)

# Movement 1 (0-20s): Pisot regular only
# Loop pisot_comp to fill 20s
m1 = np.zeros(M1_DUR * SR)
src = pisot_comp
pos = 0
while pos < M1_DUR * SR:
    chunk = min(len(src), M1_DUR * SR - pos)
    m1[pos:pos+chunk] = src[:chunk]
    pos += chunk
m1 = fade(m1, dur=1.0)
m1 = norm(m1, 0.6)
out[:M1_DUR*SR] += m1

# Movement 2 (20-40s): Non-Pisot aperiodic only
m2_start = M1_DUR * SR
m2_len = M2_DUR * SR
m2 = np.zeros(m2_len)
# Take first 20s of orbit (76s available)
orbit_chunk = np_orbit[:m2_len]
m2[:len(orbit_chunk)] += orbit_chunk * 0.5
# Layer weak mixing noise at low level
wm_chunk = np_weakmix[:m2_len]
if len(wm_chunk) < m2_len:
    wm_pad = np.zeros(m2_len)
    wm_pad[:len(wm_chunk)] = wm_chunk
    wm_chunk = wm_pad
m2 += wm_chunk * 0.15
m2 = fade(m2, dur=1.0)
m2 = norm(m2, 0.5)
out[m2_start:m2_start+m2_len] += m2

# Movement 3 (40-60s): Both layered - the contrast
m3_start = (M1_DUR + M2_DUR) * SR
m3_len = M3_DUR * SR
m3 = np.zeros(m3_len)

# Pisot layer (loop fibonacci pitched)
pos = 0
while pos < m3_len:
    chunk = min(len(pisot_fib), m3_len - pos)
    m3[pos:pos+chunk] += pisot_fib[:chunk] * 0.5
    pos += chunk

# Non-Pisot layer (orbit, offset start to variety)
np_start = 10 * SR  # start 10s into orbit for different material
np_chunk = np_orbit[np_start:np_start+m3_len]
if len(np_chunk) < m3_len:
    np_pad = np.zeros(m3_len)
    np_pad[:len(np_chunk)] = np_chunk
    np_chunk = np_pad
m3 += np_chunk * 0.35

# Padovan layer for harmonic depth
pos = 0
while pos < m3_len:
    chunk = min(len(pisot_pad), m3_len - pos)
    m3[pos:pos+chunk] += pisot_pad[:chunk] * 0.3
    pos += chunk

m3 = fade(m3, dur=1.5)
m3 = norm(m3, 0.6)
out[m3_start:m3_start+m3_len] += m3

# Crossfades between movements (2s overlap)
xfade = 2 * SR
for i in range(xfade):
    env_out = 1.0 - i / xfade
    env_in = i / xfade
    out[M1_DUR*SR - xfade + i] = m1[-xfade+i] * env_out + m2[i] * env_in if i < xfade else 0
    out[(M1_DUR+M2_DUR)*SR - xfade + i] = m2[-xfade+i] * env_out + m3[i] * env_in if i < xfade else 0

# Final normalize
out = norm(out, 0.85)
out = fade(out, dur=2.0)

write_wav(os.path.join(OUTDIR, "contrast_pisot_vs_nonpisot.wav"), out)
print(f"Written: contrast_pisot_vs_nonpisot.wav ({TOTAL}s)")
print("=== DONE ===")
