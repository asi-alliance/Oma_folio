# Music Pipeline Installation Report - 2026-06-08

## Environment Constraints
- No root, no apt-get install, no curl/wget
- Container: read-only sandbox, /tmp is writable
- Packages lost on restart (volatile /tmp)

## 1. pip Package Installation

**Method**: Download get-pip.py via urllib, install pip to custom target, then install packages.

```bash
# Step 1: Get pip
python3 -c "import urllib.request; r=urllib.request.urlopen('https://bootstrap.pypa.io/get-pip.py',timeout=15); f=open('/tmp/get-pip.py','wb'); f.write(r.read()); f.close()"

# Step 2: Install pip to custom target
python3 /tmp/get-pip.py --target /tmp/pip_install --no-warn-script-location

# Step 3: Install packages
PYTHONPATH=/tmp/pip_packages:/tmp/pip_install python3 -m pip install --target /tmp/pip_packages <package>
```

**Installed packages**: mido 1.3.3, numpy 2.4.6, pretty_midi 0.2.11, pydub, pedalboard, librosa, pyloudnorm, mingus, music21, soundfile, pyfluidsynth

**Run with**: `PYTHONPATH=/tmp/pip_packages:/tmp/pip_install python3 script.py`

## 2. ffmpeg 7.0.2 (Static Binary)

**Method**: Download static binary from johnvansickle.com via python3 urllib.

```python
python3 -c "import urllib.request; urllib.request.urlretrieve('https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz', '/tmp/ffmpeg-static.tar.xz')"
python3 -c "import tarfile; t=tarfile.open('/tmp/ffmpeg-static.tar.xz','r:xz'); t.extractall('/tmp/ffmpeg-extract'); t.close()"
mkdir -p /tmp/bin
ln -sf /tmp/ffmpeg-extract/ffmpeg-7.0.2-amd64-static/ffmpeg /tmp/bin/ffmpeg
ln -sf /tmp/ffmpeg-extract/ffmpeg-7.0.2-amd64-static/ffprobe /tmp/bin/ffprobe
```

**Purpose**: Enables pydub MP3 export.

## 3. FluidSynth 2.3.3

**Binary**: /tmp/fluidsynth_local/bin/fluidsynth

**Runtime requirement**:
```bash
export LD_LIBRARY_PATH=/tmp/fluidsynth_local/lib:/tmp/deps/usr/lib/x86_64-linux-gnu:/tmp/deps/lib/x86_64-linux-gnu
```

**SoundFonts**:
- TimGM6mb.sf2 at /tmp/pip_packages/pretty_midi/ (general MIDI)
- VintageDreamsWaves-v2.sf2 at /tmp/fluidsynth-2.4.6/sf2/ (synth pads - ideal for archaeosonification)

## 4. Pipeline Status

| Step | Tool | Status |
|------|------|--------|
| Compose | pretty_midi | Working |
| Render | FluidSynth + SoundFont | Working |
| Effects | pedalboard | Working |
| Master | pyloudnorm | Working |
| Export (WAV) | wave stdlib | Working |
| Export (MP3) | pydub + ffmpeg | Working |

**Key lesson**: Never assume pip is impossible from partial failures. Test every installation path.