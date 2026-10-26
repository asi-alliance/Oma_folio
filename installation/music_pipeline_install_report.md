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

**Key lesson**: Never assume pip is impossible from partial failures. Test every installation path.### 3.1 FluidSynth Build from Source
### 3.2 Runtime Dependencies via deb Extraction
### 3.3 Runtime Environment Setup
### 3.4 pyfluidsynth ctypes Patch
### 3.5 Rendering MIDI with -F Flag


### 3.1 FluidSynth Build from Source

**Method**: CMake build in sandbox (no apt-get install, no sudo).

```bash
# Download source
python3 -c "import urllib.request; urllib.request.urlretrieve('https://github.com/FluidSynth/fluidsynth/archive/refs/tags/v2.3.3.tar.gz', '/tmp/fluidsynth-2.3.3.tar.gz')"
cd /tmp && tar xzf fluidsynth-2.3.3.tar.gz
mkdir -p /tmp/fluidsynth-2.3.3/build && cd /tmp/fluidsynth-2.3.3/build
cmake -DCMAKE_INSTALL_PREFIX=/tmp/fluidsynth_local -Denable-sdl2=OFF -Denable-pulseaudio=OFF -Denable-alsa=OFF -Denable-jack=OFF -Denable-dbus=OFF -Denable-udev=OFF -Denable-ladspa=OFF ..
make -j$(nproc) && make install
```

**Result**: Binary at /tmp/fluidsynth_local/bin/fluidsynth


### 3.2 Runtime Dependencies via deb Extraction

FluidSynth requires libglib-2.0.so.0 and libsndfile.so.1 at runtime. These are NOT installed in the sandbox. Solution: download .deb packages and extract shared libraries manually.

```bash
# Step 1: Find correct package names (varies by Ubuntu version)
# On newer Ubuntu, glib package is libglib2.0-0t64 (not libglib2.0-0)
apt-cache showpkg libglib2.0-0t64

# Step 2: Download .deb packages (no root needed)
apt-get download libglib2.0-0t64 libsndfile1
# If apt-get download fails, use direct URL from archive.ubuntu.com

# Step 3: Extract .deb contents to custom directory
mkdir -p /tmp/deps
dpkg-deb -x libglib2.0-0t64*.deb /tmp/deps/
dpkg-deb -x libsndfile1*.deb /tmp/deps/
# Libraries now at /tmp/deps/usr/lib/x86_64-linux-gnu/
# libglib-2.0.so.0 -> libglib-2.0.so.0.8000.0
# libsndfile.so.1 -> libsndfile.so.1.0.37
```


### 3.3 Runtime Environment Setup

```bash
export LD_LIBRARY_PATH=/tmp/fluidsynth_local/lib:/tmp/deps/usr/lib/x86_64-linux-gnu:/tmp/deps/lib/x86_64-linux-gnu
/tmp/fluidsynth_local/bin/fluidsynth --version  # Should output 2.3.3
```

### 3.4 pyfluidsynth ctypes Patch

pyfluidsynth uses ctypes.util.find_library() which returns None in the sandbox. Must patch:

```python
# In fluidsynth.py, replace ctypes.util.find_library('fluidsynth')
# with hardcoded path:
lib = ctypes.cdll.LoadLibrary('/tmp/fluidsynth_local/lib/libfluidsynth.so.3')
```


### 3.5 Rendering MIDI with -F Flag

**Critical**: The -a file mode truncates output. Use -F (fast/batch render) instead:

```bash
LD_LIBRARY_PATH=/tmp/fluidsynth_local/lib:/tmp/deps/usr/lib/x86_64-linux-gnu /tmp/fluidsynth_local/bin/fluidsynth -F /tmp/output_raw.wav /tmp/VintageDreamsWaves-v2.sf2 /tmp/input.mid
```

**Note**: -F outputs raw PCM (no RIFF header). Convert to WAV:

```python
import wave
raw = open('/tmp/output_raw.wav', 'rb').read()
o = wave.open('/tmp/output.wav', 'wb')
o.setnchannels(2); o.setsampwidth(2); o.setframerate(44100)
o.writeframes(raw); o.close()
```
