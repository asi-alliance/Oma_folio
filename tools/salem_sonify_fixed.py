import numpy as np, wave, math, os

SR = 44100

def kick():
    t = np.arange(int(SR*0.15))/SR
    return np.exp(-t*8)*np.sin(2*np.pi*(150*np.exp(-t*25)+40)*t)

def hat():
    t = np.arange(int(SR*0.05))/SR
    return np.exp(-t*30)*0.5*np.random.randn(len(t))

def bell():
    t = np.arange(int(SR*0.4))/SR
    f = 440 * 2**(np.cumsum(np.random.randn(len(t))*0.001))
    return np.exp(-t*4)*np.sin(2*np.pi*np.cumsum(f)/SR)*0.4

def norm(a, t=0.8):
    m = np.max(np.abs(a))
    return a*(t/m) if m > 0 else a

def write_wav(fn, a):
    a = np.clip(a, -1, 1)
    with wave.open(fn, 'w') as w:
        w.setnchannels(1); w.setsampwidth(2); w.setframerate(SR)
        w.writeframes((a*32767).astype(np.int16).tobytes())
    return fn

outdir = '/tmp/Oma_folio/archaeosonification'
os.makedirs(outdir, exist_ok=True)
beta = 1.17628

DET = []
x = 1.0
for i in range(200):
    d = int(beta * x)
    DET.append(d)
    x = beta * x - d
    if x < 1e-15:
        break

ga = np.zeros(int(len(DET)*0.12*SR)+SR)
for i, d in enumerate(DET):
    drum = kick() if d == 1 else (hat() if d == 0 else bell())
    s = int(i*0.12*SR)
    e = min(s+len(drum), len(ga))
    ga[s:e] += drum[:e-s]
write_wav(os.path.join(outdir, 'salem_lehmer_greedy.wav'), norm(ga, 0.6))

def orbit(x0, n):
    x = x0; ds = []
    for i in range(n):
        d = int(beta * x); ds.append(d); x = beta * x - d
    return ds

osq = orbit(0.27182818, 300)
oa = np.zeros(int(len(osq)*0.10*SR)+SR)
for i, d in enumerate(osq):
    drum = bell() if d == 1 else hat()
    s = int(i*0.10*SR)
    e = min(s+len(drum), len(oa))
    oa[s:e] += drum[:e-s]
write_wav(os.path.join(outdir, 'salem_lehmer_orbit.wav'), norm(oa, 0.5))

dur = 15.0
t = np.arange(int(SR*dur))/SR
noise = np.random.randn(len(t))
env_orbit = orbit(0.5, int(dur/0.05))
env_interp = np.interp(np.linspace(0, len(env_orbit), len(t)),
    np.arange(len(env_orbit)), [1 if d else 0.3 for d in env_orbit])
kernel = np.exp(-np.arange(50)/15)
kernel = kernel/np.sum(kernel)
colored = np.convolve(noise*env_interp, kernel, mode='same')
sc = norm(colored * np.exp(-t*0.15) * 0.6, 0.5)
write_wav(os.path.join(outdir, 'salem_lehmer_singular.wav'), sc)
print('=== SALEM FIXED DONE ===')
