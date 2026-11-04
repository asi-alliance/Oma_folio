import numpy as np, wave, os

SR = 44100
ARCH = '/tmp/Oma_folio/archaeosonification'

def read_wav(path):
    with wave.open(path, 'rb') as w:
        n = w.getnframes()
        raw = w.readframes(n)
        return np.frombuffer(raw, dtype=np.int16).astype(np.float32) / 32767.0

def write_wav(path, a):
    a = np.clip(a, -1, 1)
    with wave.open(path, 'wb') as w:
        w.setnchannels(1); w.setsampwidth(2); w.setframerate(SR)
        w.writeframes((a * 32767).astype(np.int16).tobytes())

def extend(arr, target_len):
    if len(arr) >= target_len:
        return arr[:target_len]
    reps = int(np.ceil(target_len / len(arr)))
    return np.tile(arr, reps)[:target_len]

def fade(arr, fade_len=4410):
    if len(arr) < 2 * fade_len:
        return arr
    arr[:fade_len] *= np.linspace(0, 1, fade_len)
    arr[-fade_len:] *= np.linspace(1, 0, fade_len)
    return arr

def crossfade(a, b, xfade=4410):
    if xfade > len(a) or xfade > len(b):
        xfade = min(len(a), len(b)) // 2
    a[-xfade:] *= np.linspace(1, 0, xfade)
    b[:xfade] *= np.linspace(0, 1, xfade)
    return np.concatenate([a[:-xfade], a[-xfade:] + b[:xfade], b[xfade:]])

pisot = read_wav(os.path.join(ARCH, 'pisot_pitched_composition.wav'))
salem_g = read_wav(os.path.join(ARCH, 'salem_lehmer_greedy.wav'))
salem_o = read_wav(os.path.join(ARCH, 'salem_lehmer_orbit.wav'))
salem_s = read_wav(os.path.join(ARCH, 'salem_lehmer_singular.wav'))
nonpisot_o = read_wav(os.path.join(ARCH, 'nonpisot_sqrt2_orbit.wav'))
nonpisot_w = read_wav(os.path.join(ARCH, 'nonpisot_sqrt2_weakmix.wav'))

m1_len = int(25 * SR)
m2_len = int(25 * SR)
m3_len = int(20 * SR)
m4_len = int(10 * SR)
total_len = m1_len + m2_len + m3_len + m4_len

out = np.zeros(total_len)

# M1: Pisot (pure point) 0-25s
m1 = extend(pisot, m1_len) * 0.7
m1 = fade(m1)
out[:m1_len] += m1

# M2: Salem (singular continuous) 25-50s
m2_salem = extend(salem_g, m2_len) * 0.5 + extend(salem_s, m2_len) * 0.3
m2_salem = fade(m2_salem)
out[m1_len:m1_len+m2_len] += m2_salem

# M3: Non-Pisot (continuous) 50-70s
m3_np = extend(nonpisot_o[:int(20*SR)], m3_len) * 0.4 + extend(nonpisot_w, m3_len) * 0.3
m3_np = fade(m3_np)
out[m1_len+m2_len:m1_len+m2_len+m3_len] += m3_np

# M4: All three layered climax 70-80s
m4_p = extend(pisot, m4_len) * 0.4
m4_s = extend(salem_g, m4_len) * 0.3
m4_n = extend(nonpisot_w, m4_len) * 0.3
m4 = m4_p + m4_s + m4_n
m4 = fade(m4)
out[m1_len+m2_len+m3_len:] += m4

# Crossfade between movements
for boundary in [m1_len, m1_len+m2_len, m1_len+m2_len+m3_len]:
    xf = 2205
    if boundary - xf > 0 and boundary + xf < total_len:
        out[boundary-xf:boundary] *= np.linspace(1, 0, xf)
        out[boundary:boundary+xf] *= np.linspace(0, 1, xf)

out = out / np.max(np.abs(out)) * 0.85
outpath = os.path.join(ARCH, 'spectral_trilogy_unified.wav')
write_wav(outpath, out)
print(f'=== TRILOGY DONE === {os.path.getsize(outpath)} bytes, {len(out)/SR:.1f}s')
