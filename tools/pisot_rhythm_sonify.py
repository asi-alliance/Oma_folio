import numpy as np
import wave
import struct

SR = 44100

# === Pisot substitution rules ===
# Each rule maps a symbol to a sequence (substitution morphism)
PISOT_RULES = {
    "fibonacci": {"A": "AB", "B": "A"},
    "padovan":   {"A": "B", "B": "AC", "C": "A"},
    "tribonacci": {"A": "AB", "B": "AC", "C": "A"},
    "tetranacci": {"A": "AB", "B": "AC", "C": "AD", "D": "A"},
}

def apply_substitution(rule, start, depth):
    s = start
    for _ in range(depth):
        s = "".join(rule.get(c, c) for c in s)
    return s

# === Drum synthesis ===
def kick(dur=0.15, sr=SR):
    t = np.arange(int(sr*dur))/sr
    freq = 150*np.exp(-t*25)+40
    env = np.exp(-t*8)
    return env*np.sin(2*np.pi*freq*t)

def snare(dur=0.12, sr=SR):
    t = np.arange(int(sr*dur))/sr
    env = np.exp(-t*18)
    tone = 0.3*np.sin(2*np.pi*180*t)
    noise = 0.7*np.random.randn(len(t))
    return env*(tone+noise)

def hihat(dur=0.05, sr=SR):
    t = np.arange(int(sr*dur))/sr
    env = np.exp(-t*60)
    return env*np.random.randn(len(t))*0.5

def clap(dur=0.10, sr=SR):
    t = np.arange(int(sr*dur))/sr
    env = np.exp(-t*25)
    return env*np.random.randn(len(t))*0.6

DRUMS = {"A": kick, "B": snare, "C": hihat, "D": clap}

# === Render rhythmic sequence to audio ===
def render_sequence(seq, step_dur=0.2, sr=SR):
    total = int(len(seq)*step_dur*sr)+sr
    audio = np.zeros(total)
    for i, sym in enumerate(seq):
        if sym in DRUMS:
            drum = DRUMS[sym](sr=sr)
            start = int(i*step_dur*sr)
            end = min(start+len(drum), len(audio))
            audio[start:end] += drum[:end-start]
    return audio

def normalize(audio, target=0.8):
    m = np.max(np.abs(audio))
    if m > 0:
        audio = audio * (target/m)
    return audio

def write_wav(filename, audio, sr=SR):
    audio16 = (audio*32767).astype(np.int16)
    with wave.open(filename, "w") as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(sr)
        w.writeframes(audio16.tobytes())
    return filename

# === Main ===
if __name__ == "__main__":
    import os
    outdir = "/tmp/Oma_folio/archaeosonification"
    os.makedirs(outdir, exist_ok=True)
    
    print("=== Pisot Rhythm Sonification ===")
    
    compositions = []
    
    for name, rule in PISOT_RULES.items():
        start = list(rule.keys())[0]
        # Choose depth to get ~30-50 steps
        depth = {"fibonacci": 7, "padovan": 10, "tribonacci": 6, "tetranacci": 5}[name]
        seq = apply_substitution(rule, start, depth)
        print(f"  {name}: depth={depth}, length={len(seq)}, seq={seq[:40]}...")
        
        step_dur = {"fibonacci": 0.15, "padovan": 0.18, "tribonacci": 0.13, "tetranacci": 0.11}[name]
        audio = normalize(render_sequence(seq, step_dur))
        
        fname = f"{outdir}/pisot_{name}.wav"
        write_wav(fname, audio)
        print(f"    -> {fname} ({len(audio)/SR:.1f}s)")
        compositions.append((name, audio, step_dur))
    
    # Multi-layer composition: overlay all four with different start times
    print("\n=== Building multi-layer composition ===")
    # Offset each layer to create polyrhythmic entry
    max_len = max(len(a) for _, a, _ in compositions)
    layer_offsets = [0, int(0.5*SR), int(1.0*SR), int(1.5*SR)]
    
    composite = np.zeros(max_len + int(2*SR))
    for (name, audio, sd), offset in zip(compositions, layer_offsets):
        composite[offset:offset+len(audio)] += audio * 0.25
    
    composite = normalize(composite)
    fname = f"{outdir}/pisot_composition.wav"
    write_wav(fname, composite)
    print(f"  -> {fname} ({len(composite)/SR:.1f}s)")
    
    print("\nDone. All WAV files generated.")