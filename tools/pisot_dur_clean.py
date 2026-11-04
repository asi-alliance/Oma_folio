import wave, struct, numpy as np, os

SR = 44100
phi = 1.6180339887498949
plastic = 1.3247179572446057
tribo = 1.839286755214562
tetra = 1.9281564770847

def gen_word(rule, init, depth):
    s = init
    for _ in range(depth):
        s = ''.join(rule.get(c, c) for c in s)
    return s

def make_drum(kind, dur, sr):
    n = int(dur * sr)
    if n <= 0:
        return np.array([], dtype=np.float32)
    t = np.arange(n) / sr
    if kind == 'kick':
        return (np.exp(-t**2)*np.sin(t*2*np.pi*60)*0.8 + np.exp(-t*30)*0.3) * 0.7
    elif kind == 'snare':
        return (np.exp(-t*30)*0.5 + np.random.randn(n)*0.3*np.exp(-t*15)) * 0.5
    elif kind == 'hihat':
        return np.exp(-t*100)*np.random.randn(n) * 0.3
    else:
        return np.exp(-t*20)*np.random.randn(n) * 0.4

families = {
    'fibonacci': {'rule': {'A':'AB','B':'A'}, 'durs': {'A':1.0,'B':1.0/phi}, 'drums': {'A':'kick','B':'snare'}, 'const': phi},
    'padovan': {'rule': {'A':'B','B':'AC','C':'A'}, 'durs': {'A':1.0,'B':1.0/plastic,'C':1.0/plastic**2}, 'drums': {'A':'kick','B':'hihat','C':'snare'}, 'const': plastic},
    'tribonacci': {'rule': {'A':'AB','B':'AC','C':'A'}, 'durs': {'A':1.0,'B':1.0/tribo,'C':1.0/tribo**2}, 'drums': {'A':'kick','B':'snare','C':'hihat'}, 'const': tribo},
    'tetranacci': {'rule': {'A':'AB','B':'AC','C':'AD','D':'A'}, 'durs': {'A':1.0,'B':1.0/tetra,'C':1.0/tetra**2,'D':1.0/tetra**3}, 'drums': {'A':'kick','B':'snare','C':'hihat','D':'clap'}, 'const': tetra},
}

os.makedirs('/tmp/Oma_folio/archaeosonification', exist_ok=True)
base_mul = 0.15

for name, fam in families.items():
    word = gen_word(fam['rule'], 'A', 7)
    durs = fam['durs']
    drums = fam['drums']
    const = fam['const']
    beat_times = []
    t = 0
    for sym in word:
        beat_times.append(t)
        t += base_mul * durs[sym]
    total = int(t * SR + SR * 0.5)
    audio = np.zeros(total, dtype=np.float32)
    for i, sym in enumerate(word):
        bt = beat_times[i]
        dur = base_mul * durs[sym]
        tone = make_drum(drums[sym], dur, SR)
        start = int(bt * SR)
        end = min(start + len(tone), total)
        if start >= total:
            break
        if len(audio) < end:
            audio = np.concatenate([audio, np.zeros(end - len(audio))])
        audio[start:end] += tone[:end-start]
    if np.max(np.abs(audio)) > 0:
        audio = audio / np.max(np.abs(audio)) * 0.8
    int16 = (audio * 32768).astype(np.int16)
    path = '/tmp/Oma_folio/archaeosonification/pisot_dur_' + name + '.wav'
    w = wave.open(path, 'wb')
    w.setnchannels(1)
    w.setsampwidth(2)
    w.setframerate(SR)
    w.writeframes(struct.pack('{0}h'.format(len(int16)), *int16.tolist()))
    w.close()
    gaps = [round(beat_times[i+1]-beat_times[i], 4) for i in range(min(15, len(beat_times)-1))]
    uniq = sorted(set(round(g, 4) for g in [beat_times[i+1]-beat_times[i] for i in range(len(beat_times)-1)]))
    ratio = max(uniq)/min(uniq) if len(uniq) >= 2 else 0
    print(name + ': word_len=' + str(len(word)) + ' beats=' + str(len(beat_times)) + ' dur=' + str(round(t,1)) + 's')
    print('  gaps=' + str(gaps[:10]))
    print('  unique_durs=' + str([round(u,4) for u in uniq[:5]]) + ' ratio=' + str(round(ratio,4)) + ' const=' + str(round(const,4)))
    print('  written ' + path + ' (' + str(round(len(int16)*2/1048576,1)) + 'MB)')
print('Done.')