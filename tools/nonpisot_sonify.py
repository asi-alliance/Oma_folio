import numpy as np
import wave
import math
import os

SR = 44100
beta = math.sqrt(2)

DET = []
x = 1.0
for i in range(10000):
    d = int(beta * x)
    DET.append(d)
    x = beta * x - d
    if x < 1e-15:
        break

print("d_beta(1):", "".join(map(str, DET[:80])))
print("Length:", len(DET))

def kick(sr=SR):
    t = np.arange(int(sr*0.15))/sr
    return np.exp(-t*8)*np.sin(2*np.pi*(150*np.exp(-t*25)+40)*t)

def bass(sr=SR):
    t = np.arange(int(sr*0.10))/sr
    return np.exp(-t*20)*np.sin(2*np.pi*55*t)*0.6

def snare(sr=SR):
    t = np.arange(int(sr*0.12))/sr
    return np.exp(-t*18)*(0.3*np.sin(2*np.pi*180*t)+0.7*np.random.randn(len(t)))

def norm(a, target=0.8):
    m = np.max(np.abs(a))
    if m > 0: a = a*(target/m)
    return a

def write_wav(fn, a, sr=SR):
    a16 = (a*32767).astype(np.int16)
    with wave.open(fn, "w") as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(sr)
        w.writeframes(a16.tobytes())
    return fn

outdir = "/tmp/Oma_folio/archaeosonification"
os.makedirs(outdir, exist_ok=True)

print("=== Non-Pisot Beta-Shift Sonification for sqrt(2) ===")
print("beta =", beta)
print("topological entropy h = log(beta) =", math.log(beta))
print("d_beta(1) length:", len(DET))

ga = np.zeros(int(len(DET)*0.17*SR)+SR)
for i, d in enumerate(DET):
    drum = kick() if d == 1 else bass()
    s = int(i*0.17*SR)
    e = min(s+len(drum), len(ga))
    ga[s:e] += drum[:e-s]
ga = norm(ga)
write_wav(os.path.join(outdir, "nonpisot_sqrt2_greedy.wav"), ga)
print("Written: nonpisot_sqrt2_greedy.wav")

def orbit(x0, n):
    x = x0
    ds = []
    for i in range(n):
        d = int(beta*x)
        ds.append(d)
        x = beta*x - d
    return ds

osq = orbit(0.31415, 500)
print("Orbit digits:", "".join(map(str, osq[:60])))
oa = np.zeros(int(len(osq)*0.15*SR)+SR)
for i, d in enumerate(osq):
    drum = snare() if d == 1 else bass()
    s = int(i*0.15*SR)
    e = min(s+len(drum), len(oa))
    oa[s:e] += drum[:e-s]
oa = norm(oa)
write_wav(os.path.join(outdir, "nonpisot_sqrt2_orbit.wav"), oa)
print("Written: nonpisot_sqrt2_orbit.wav")

dur = 10.0
t = np.arange(int(SR*dur))/SR
noise = np.random.randn(len(t))
kernel = np.exp(-np.arange(100)/20)
kernel = kernel/np.sum(kernel)
colored = np.convolve(noise, kernel, mode="same")
env = np.exp(-t*0.3)
wm = colored*env*0.5
wm = norm(wm, target=0.6)
write_wav(os.path.join(outdir, "nonpisot_sqrt2_weakmix.wav"), wm)
print("Written: nonpisot_sqrt2_weakmix.wav")
print("=== DONE ===")
