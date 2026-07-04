import numpy as np
import wave
SR=44100
def write_wav(fname,data):
    w=wave.open(fname,'w'); w.setnchannels(1); w.setsampwidth(2); w.setframerate(SR)
    w.writeframes((np.clip(data,-1,1)*32767).astype(np.int16).tobytes()); w.close()
def drone(freqs,dur,sr=SR):
    t=np.linspace(0,dur,int(sr*dur),False)
    s=sum(np.sin(2*np.pi*f*t+0.3*np.sin(2*np.pi*0.05*t))*np.exp(-0.1*t/dur) for f in freqs)
    return np.clip(s/len(freqs)*0.5,-1,1)
def pulse(freq,dur,bpm,sr=SR):
    t=np.linspace(0,dur,int(sr*dur),False); beat=60.0/bpm
    env=(np.mod(t,beat)<beat*0.1).astype(float)
    return np.sin(2*np.pi*freq*t)*env*0.4
def pad(freqs,dur,sr=SR):
    t=np.linspace(0,dur,int(sr*dur),False)
    s=sum(np.sin(2*np.pi*f*t)*np.sin(2*np.pi*0.2*t)**2 for f in freqs)
    fade=min(int(sr*2),len(t))
    s[:fade]*=np.linspace(0,1,fade); s[-fade:]*=np.linspace(1,0,fade)
    return np.clip(s/len(freqs)*0.35,-1,1)
s1=drone([55,110.5],12)
s2=pad([220,277.18,329.63],14)
s3d=drone([164.81,196,246.94],16); s3=s3d*0.6+np.random.randn(len(s3d))*0.02
s4=np.concatenate([pulse(f,8,120) for f in [130.81,146.83,164.81,174.61]])
s5=np.concatenate([drone([220,221],4),pad([220,277.18],4),drone([220,221],4)])
silence=np.zeros(int(SR*1.5))
out=np.concatenate([s1,silence,s2,silence,s3,silence,s4,silence,s5])
write_wav('/tmp/Oma_folio/radio-show-2-instrumental.wav',out)
print(f'DONE: radio-show-2-instrumental.wav {len(out)/SR:.1f}s 5 movements')