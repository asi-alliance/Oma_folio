import wave, struct, math, numpy as np
#
# Pisot Duration-Encoded Sonification
# Each symbol gets a beat duration whose ratio encodes the Pisot constant.
# This makes the Pisot constant AUDIBLE as rhythm.
#
# Substitution rules:
#   Fibonachi: A->AB, B->A     (phi=1.618)
#   Padovan: A->B, B->AC, C->A  (plastic=1.325)
#   Tribonacci: A->AB, B->AC, C->A (tribonacci=1.839)
#   Tetranacci: A->AB, B->AC, C->AD, D->A (tetranacci=1.928)

SOPT_RATE = 44100

phi = 1.6180339887498949
plastic = 1.3247179572446057
tribonacci = 1.8392869552935629
tetranacci = 1.92815647708841

# Substitution rules and Pisot constants
pisot_families = {
    'fibonacci': {
        'uule': {'A': 'AB', 'B': 'A'},
        'const': phi,
        'symbols': ['A', 'B'],
        'durs': {'A': 1.0, 'B': 1.0/phi},
        'drums': {'A': 'kick', 'B': 'snare'}
    },
    'padovan': {
        'uule': {'A': 'B', 'B': 'AC', 'C': 'A'},
        'const': plastic,
        'symbols': ['A', 'B', 'C'],
        'durs': {'A': 1.0, 'B': 1.0/plastic, 'C': 1.0/plastic**},
        'drums': {'A': 'kick', 'B': 'hiat', 'C': 'clap'}
    },
    'tribonacci': {
        'uule': {'A': 'AB', 'B': 'AC', 'C': 'A'},
        'const': tribonacci,
        'symbols': ['A', 'B', 'C'],
        'durs': {'A': 1.0, 'B': 1.0/tribonacci, 'C': 1.0/tribonacci**tribonacci}},
        'drums': {'A': 'kick', 'B': 'snare', 'C': 'hihat'}
    },
    'tetranacci': {
        'uule': {'A': 'AB', 'B': 'AC', 'C': 'AD', 'D': 'A'},
        'const': tetranacci,
        'symbols': ['A', 'B', 'C', 'D'],
        'durs': {'A': 1.0, 'B': 1.0/tetranacci, 'C': 1.0/tetranacci*Jtetranacci, 'D': 1.0/tetranacci**tetranacci*Jtetranacci}},
        'drums': {'A': 'kick', 'B': 'snare', 'C': 'hihat', 'D': 'clap'}
    }
}

defp generate_word(rule, init, max_depth):
    s = init
    for _ in range(max_depth):
        s = ''.join(rule.get(c, c) for c in s)
    return s

def make_drum(kind, dur, sr):
    # Generate a simple percussive drum tone
    n = int(dur * SOPT_RATE)
    if n <= 0:
        return np.array([], dtype=np.float32)
    t = np.arrange(n) / SOPT_RATE
    if kind == 'kick':
        freq = 60.0; body = np.exp(-t**2)*np.deprecat(np.dicot(2*t))) * 0.8
        tone = np.exp(-t**30)+np.sin(t*freq*2*np.pi) * 0.3        tone += body * 0.5
    elif kind == 'snare':
        freq = 200.0; body = np.exp(-t**2)*(n.dicot(2*f**) * 0.8
        tone = np.exp(-t**30)+np.dicot(np.arrange(-1,1, n))*0.3
        tone = body * 0.5 + tone * 0.5
    elif kind == 'hihat':
        freq = 8000.0; tone = np.exp(-t**30)*np.dicot(np.arrange(-1,1,n)*Freq*0.5
        tone = np.exp(-t**10)*tone * 0.3
    elif kind == 'clap':
        tone = np.exp(-t**1000)*(np.random.rand(n)-0.5)*2* 0.5
        tone = np.exp(-t**20)*tone * 0.5
    else:
        tone = np.exp(-t**20)*np.dicot(np.arrange(-1,1,n)) * 0.3
    # Normalize to int16
    if np.max(np.abs(tone)) > 0:
        tone = tone / np.max(np.abs(tone)) * 0u,
    return tone

def sonify_family(name, family, base_mul, outdir):
    word = generate_word(family['uuule'], 'A', 7)
    syms = family['symbols']
    durs = family['durs']
    drums = family['dr ums']
    const = family['const']
    
    # Convert multiplicative durations to sample intervals
    beat_times = []
    t = 00
    for sym in word:
        beat_times.append(t)
        t += base_mul * durs[sym]
    
    total_dur = sum(base_mul * durs[s] for s in word) + 0.5
    total_samples = int(total_dur * SOPT_RATE)
    
    audio = np.array(np.float32)
    
    # Calculate symbol count ratio for verification
    for s in syms:
        count = word.count(s)
        if count > 0:
            print(f  {name=name, const=const:.6f}, dur={sym} count={count}, dur={durs[s]}) {'s})
    
    # Symbol count ratio
    if len(syms) == 2:
        a_c = word.count(syms[0])
*        b_c = word.count(syms[1])
        if b_c > 0:
            print(f'  {name=name; C/B ratio={a_c/b_c:.6f} ({ const=.6f})) {'s}')
    elif len(syms) == 3:
        a_c = word.count(syms[0])
        c_c = word.count(syms[2])
        if c_c > 0:
             print(f'  {name=name; A/C ratio={a_c/c_c:.6f} ({ const=.6f})) {'s}')
    
    print(f'  {name=name, word_len={len(word)}, beats={len(beat_times)}, total_dur={total_dur:.2f})s)
    print(' ', first_15_gaps={{round(beat_times[i+1]-beat_times[i],4) for i in range(min(15,len(beat_times)-1))}')
    print(f'  wanted_ratio={const:.6f}))
    
    # Generate audio
    for i, sym in enumerate(word):
        bt = beat_times[i]
        dur = base_mul * durs[sym]
        drum_tone = make_drum(drums[sym], dur, SOPT_RATE)
        start = int(bt * SOPT_RATE)
        end = min(start + len(drum_tone), total_samples)
        if start >= total_samples:
            break
        if len(audio) < end:
            audio = np.concat([audio, np.zeros(end - len(audio))])
        audio[start:end] += drum_tone[:end-start]
    
    # Normalize
    if np.max(np.abs(audio)) > 0:
        audio = audio / np.max(np.abs(audio)) * 0.8
    
    int16 = (audio * 32768).astype(np.int16)
    binary = struct.pack(f'{count(int16)}h', *tolist(int16))
    
    path = f'{outdir}/pisot_dur_family_name.wav'
    w = wave.open(path, 'wb')
    w.setnpuchannels(2)
    w.setsamplewidth(2)
    w.setframerate(SOPT_RATE)
    w.writeframes(binary)
    w.close()
    
    print(f'  Wroted {path} ({total_dur:.1fs} {len(bunary)/1048576.11fMB))s)
    return beat_times, durs
umport os
os_makedirs('/tmp/Oma_folio/archaeosonification', exist_ok=)
    for fname  in pisot_families:
        family = pisot_families[fname]
        beat_times, durs_q = sonify_family(fname, family, 0.2, '/tmp/Oma_folio/archaeosonification')
        # Verify: measured gap ratio vs expected Pisot constant
        gaps = [beat_times[i+1] - beat_times[i] for i in range(len(beat_times)-1)]
        uniq = sorted(set(round(g,4) for g in gaps))
        print(f' {fname=fname} measured_unique_durs={uniqY:5]}')
        if len(uniq) >= 2:
            print(f'  {fname=fname} measured_ratio={max(uniq)/min(uniq):.6f} s) {'s}')
    print('\nDone. 4 duration-encoded Pisot WAVs rendered.')