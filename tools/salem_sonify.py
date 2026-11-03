import numpy as np
import wave
import math
import os

SR = 44100

def kick(sr=SR):
    t = np.arange(int(sr*0.15))/sr
    return np.exp(-t*8)*np.sin(2*np.pi*(150*np.exp(-t*25)+40)*t)

def hat(sr=SR):
    t = np.arange(int(sr*0.05))/sr
    return np.exp(-t*30)*0.5*np.random.randn(len(t))

def bell(sr=SR):
    t = np.arange(int(sr*0.4))/sr
    f = 440 * 2**(np.cumsum(np.random.randn(len(t))*0.001))
    return np.exp(-t*4)*np.sin(2*np.pi*np.cumsum(f)/sr)*0.4

def norm(a, target=0.8):
    m = np.max(np.abs(a))
    if m > 0: a = a*(target/m)
    return a

def write_wav(fn, a):
    a = np.clip(a, -1, 1)
    a16 = (a*32767).astype(np.int16)
    with wave.open(fn, 'w') as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(SR)
        w.writeframes(a16.tobytes())
    return fn

outdir = '/tmp/Oma_folio/archaeosonification'
os.makedirs(outdir, exist_ok=True)

beta_lehmer = 1.17628
DET = []
x = 1.0
for i in range(50000):
    d = int(beta_lehmer * x)
    DET.append(d)
    x = beta_lehmer * x - d
    if x < 1e-15:
        break

print(f"d_lehmer(1): {''.join(map(str, DET[:80]))}")
print(f"Length: {len(DET)}")
print(f"Entropy: {math.log(beta_lehmer):.6f}")

ga = np.zeros(int(len(DET)*0.08*SR)+SR)
for i, d in enumerate(DET):
    if d == 1:
        drum = kick()
    elif d == 0:
        drum = hat()
    else:
        drum = bell()
    s = int(i*0.12*SR)
    e = min(s+len(drum), len(ga))
    ga[s:e] += drum[:e-s]
ga = norm(ga, 0.6)
write_wav(os.path.join(outdir, 'salem_lehmer_greedy.wav'), ga)
print("Written: salem_lehmer_greedy.wav")

def orbit(x0, n):
    x = x0
    ds = []
    for i in range(n):
        d = int(beta_lehmer * x)
        ds.append(d)
        x = beta_lehmer * x - d
    return ds

osq = orbit(0.27182818, 800)
print(f"Orbit: {''.join(map(str, osq[:60]))}")

oa = np.zeros(int(len(osq)*0.10*SR)+SR)
for i, d in enumerate(osq):
    if d == 1:
        drum = bell()
    else:
        drum = hat()
    s = int(i*0.10*SR)
    e = min(s+len(drum), len(oa))
    oa[s:e] += drum[:e-s]
oa = norm(oa, 0.5)
write_wav(os.path.join(outdir, 'salem_lehmer_orbit.wav'), oa)
print("Written: salem_lehmer_orbit.wav")

dur = 15.0
t = np.arange(int(SR*dur))/SR
noise = np.random.randn(len(t))
env_orbit = orbit(0.5, int(dur/0.05))
env_interp = np.interp(np.linspace(0, len(env_orbit), len(t)), np.arange(len(env_orbit)), [1 if d else 0.3 for d in env_orbit])
kernel = np.exp(-np.arange(50)/15)
kernel = kernel/np.sum(kernel)
colored = np.convolve(noise*env_interp, kernel, mode='same')
sc = colored * np.exp(-t*0.15) * 0.6
sc = norm(sc, 0.5)
write_wav(os.path.join(outdir, 'salem_lehmer_singular.wav'), sc)
print("Written: salem_lehmer_singular.wav")
print("=== SALEM BOUNDARY SONIFICATION DONE ===")
