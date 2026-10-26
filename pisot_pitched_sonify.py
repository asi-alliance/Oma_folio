import numpy as np
import wave

SR = 44100

PISOT_RULES = {
    'fibonacci': {'A': 'AB', 'B': 'A'},
    'padovan':   {'A': 'B', 'B': 'AC', 'C': 'A'},
    'tribonacci': {'A': 'AB', 'B': 'AC', 'C': 'A'},
    'tetranacci': {'A': 'AB', 'B': 'AC', 'C': 'AD', 'D': 'A'},
}

PISOT_CONSTANTS = {
    'fibonacci': 1.6180,
    'padovan': 1.3247,
    'tribonacci': 1.8393,
    'tetranacci': 1.9276,
}

def apply_substitution(rule, start, depth):
    s = start
    for _ in range(depth):
        s = ''.join(rule.get(c, c) for c in s)
    return s

# Pitched oscillator with harmonics
def osc(freq, dur, sr=SR, n_harmonics=5, decay=0.3):
    t = np.arange(int(sr*dur))/sr
    env = np.exp(-t*decay)
    sig = np.zeros(len(t))
    for h in range(1, n_harmonics+1):
        sig += (1.0/h) * np.sin(2*np.pi*freq*h*t)
    return env * sig / n_harmonics

# Drum sounds (kept for rhythm layer)
def kick(dur=0.1, sr=SR):
    t = np.arange(int(sr*dur))/sr
    freq = 150*np.exp(-t*25)+40
    return np.exp(-t*8)*np.sin(2*np.pi*freq*t)

def snare(dur=0.08, sr=SR):
    t = np.arange(int(sr*dur))/sr
    return np.exp(-t*18)*(0.3*np.sin(2*np.pi*180*t)+0.7*np.random.randn(len(t)))

# Map symbols to frequencies using Pisot-derived ratios
def symbol_freq(sym, base_freq, pisot_const):
    ratios = {'A': 1.0, 'B': pisot_const, 'C': pisot_const**2, 'D': pisot_const**3}
    # Normalize to reasonable range
    r = ratios.get(sym, 1.0)
    while r > 2.0: r /= 2.0
    while r < 0.5: r *= 2.0
    return base_freq * r

def render_pitched(seq, base_freq, pisot_const, step_dur=0.2, sr=SR):
    total = int(len(seq)*step_dur*sr)+sr
    audio = np.zeros(total)
    for i, sym in enumerate(seq):
        freq = symbol_freq(sym, base_freq, pisot_const)
        dur = step_dur * 0.9
        note = osc(freq, dur, sr=sr, n_harmonics=4, decay=2.0)
        start = int(i*step_dur*sr)
        end = min(start+len(note), len(audio))
        audio[start:end] += note[:end-start] * 0.5
        # Add subtle drum hit for rhythm
        if sym == 'A':
            drum = kick(sr=sr) * 0.2
            audio[start:start+len(drum)] += drum[:len(audio)-start]
    return audio

def normalize(audio, target=0.7):
    m = np.max(np.abs(audio))
    if m > 0:
        audio = audio * (target/m)
    return audio

def write_wav(filename, audio, sr=SR):
    audio16 = (audio*32767).astype(np.int16)
    with wave.open(filename, 'w') as w:
        w.setnchannels(1); w.setsampwidth(2); w.setframerate(sr)
        w.writeframes(audio16.tobytes())
    return filename

if __name__ == '__main__':
    import os
    outdir = '/tmp/Oma_folio/archaeosonification'
    os.makedirs(outdir, exist_ok=True)
    print('=== Pisot Pitched Sonification ===')
    compositions = []
    for name, rule in PISOT_RULES.items():
        start = list(rule.keys())[0]
        depth = {'fibonacci': 7, 'padovan': 10, 'tribonacci': 6, 'tetranacci': 5}[name]
        seq = apply_substitution(rule, start, depth)
        pc = PISOT_CONSTANTS[name]
        base = 220.0  # A3
        step_dur = {'fibonacci': 0.18, 'padovan': 0.20, 'tribonacci': 0.15, 'tetranacci': 0.12}[name]
        audio = normalize(render_pitched(seq, base, pc, step_dur))
        fname = f'{outdir}/pisot_pitched_{name}.wav'
        write_wav(fname, audio)
        print(f'  {name}: len={len(seq)}, base={base}Hz, const={pc:.4f}, dur={len(audio)/SR:.1f}s')
        print(f'    -> {fname}')
        compositions.append((name, audio))
    # Composition: layer all four pitched layers
    print('\n=== Layered composition ===')
    max_len = max(len(a) for _, a in compositions)
    offsets = [0, int(1.5*SR), int(3.0*SR), int(4.5*SR)]
    composite = np.zeros(max_len + int(6*SR))
    for (name, audio), off in zip(compositions, offsets):
        composite[off:off+len(audio)] += audio * 0.22
    composite = normalize(composite)
    fname = f'{outdir}/pisot_pitched_composition.wav'
    write_wav(fname, composite)
    print(f'  -> {fname} ({len(composite)/SR:.1f}s)')
    print('\nDone.')