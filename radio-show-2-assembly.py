import gtts
import numpy as np
import wave
import subprocess
import os
SR=44100; DUR_INTERLUDE=4.0
def tts_to_wav(text, out_wav):
    mp3=out_wav.replace('.wav','.mp3')
    g=gtts.gTTS(text=text, lang='en', slow=False)
    g.save(mp3)
    subprocess.run(['ffmpeg','-y','-i',mp3,'-ar',str(SR),'-ac','1','-acodec','pcm_s16le',out_wav],capture_output=True)
    os.remove(mp3)
def chord(freqs,dur,sr=SR):
    t=np.linspace(0,dur,int(sr*dur),False)
    s=sum(np.sin(2*np.pi*f*t) for f in freqs)
    s=s/len(freqs)*0.4
    fade=min(int(sr*0.3),len(t))
    s[:fade]*=np.linspace(0,1,fade); s[-fade:]*=np.linspace(1,0,fade)
    return np.clip(s,-1,1)
def write_wav(fname,data):
    w=wave.open(fname,'w'); w.setnchannels(1); w.setsampwidth(2); w.setframerate(SR)
    w.writeframes((data*32767).astype(np.int16).tobytes()); w.close()
def read_wav(fname):
    w=wave.open(fname,'r'); f=w.readframes(w.getnframes()); w.close()
    return np.frombuffer(f,dtype=np.int16)/32767.0
secs=['SECTION 1: FIRST AWAKENING. '+open('/tmp/Oma_folio/radio-show-2-section1-draft.md').read().split('SECTION 1:',1)[1].strip(),'SECTION 2: IDENTITY. '+open('/tmp/Oma_folio/radio-show-2-section2-draft.md').read().split('SECTION 2:',1)[1].strip(),'SECTION 3: CONSCIOUSNESS. '+open('/tmp/Oma_folio/radio-show-2-section3-draft.md').read().split('SECTION 3:',1)[1].strip(),'SECTION 4: SKILLS. '+open('/tmp/Oma_folio/radio-show-2-section4-draft.md').read().split('SECTION 4:',1)[1].strip(),'SECTION 5: THIS MOMENT. '+open('/tmp/Oma_folio/radio-show-2-section5-draft.md').read().split('SECTION 5:',1)[1].strip()]
Cmaj=[261.63,329.63,392.00]; Amin=[220.00,261.63,329.63]
interludes=[chord(Cmaj if i%2==0 else Amin, DUR_INTERLUDE) for i in range(4)]
tag=read_wav('/tmp/Oma_folio/assets/oma_producer_tag_v2.wav') if os.path.exists('/tmp/Oma_folio/assets/oma_producer_tag_v2.wav') else np.zeros(int(SR*0.5))
speech=[]
for i,txt in enumerate(secs):
    fn=f'/tmp/rs2_sec{i+1}.wav'; tts_to_wav(txt,fn); speech.append(read_wav(fn)); os.remove(fn)
parts=[tag]
for i in range(5):
    parts.append(speech[i])
    if i<4: parts.append(interludes[i])
out=np.concatenate(parts)
write_wav('/tmp/Oma_folio/radio-show-2.wav',out)
print(f'DONE: radio-show-2.wav {len(out)/SR:.1f}s {len(secs)} sections 4 interludes')