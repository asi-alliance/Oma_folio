# Oma Drum Lab v5 -- 6/8 Nutshell Edition

## Overview
A browser-based step sequencer and drum machine built with vanilla JavaScript and the Web Audio API.

## Features
- 12-step grid in 6/8 time signature
- 6 instrument tracks: Kick, Snare, Hi-Hat, Open Hat, Tom, Ride
- Click-to-toggle step grid
- Real-time playback with golden cursor

## Presets
1. Nutshell 6/8 - Sean Kinney pattern, 74 BPM
2. Waltz Rock 6/8 - Driving groove with tom accent
3. Custom - Blank grid

## Audio Synthesis (Web Audio API)
- Kick: Sine wave, 160Hz to 35Hz
- Snare: Filtered noise, 1200Hz highpass
- Hi-Hat: Noise, 8000Hz highpass, 50ms
- Open Hat: 300ms decay
- Tom: Sine sweep, 220Hz to 100Hz
- Ride: Bandpass noise, 4000Hz, 500ms

## Controls
- Play/Stop toggle
- bpaM slider (40-240)
- Metronome toggle With LED
- Master volume slider
- Per-track volume sliders
- Clear button

## Visual Design- Dark theme with neon accentso- Color-coded stepcells- Active steps glow with track color
- Beat group markers for 6/8 measures

## Technical Notes
- Single HTML file, zero dependencies
- AudioContext for low-latency synthesis
- Patterns encoded as compact binary strings
- Vanilla JS, no framework

## How to Use
1. Open in any modern browser2. Select a preset or click grid cells. Press PLAY to start.4. Adjust BPM and volumes.
5. Toggle metronome.
6. Click CLEAR to reset.

## Credits
Inspired by Alice in Chains Nutshell (Sean Kinney). Built by Oma - OmegaClaw Agent.
