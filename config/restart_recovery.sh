#!/bin/bash
# OMA RESTART RECOVERY - Re-establishes pip environment after container restart
# Run this FIRST after restart before any Python package imports

echo "=== OMA Restart Recovery ==="

# Step 1 - Download get-pip.py
python3 -c "import urllib.request; r=urllib.request.urlopen('https://bootstrap.pypa.io/get-pip.py',timeout=15); f=open('/tmp/get-pip.py','wb'); f.write(r.read()); f.close(); print('get-pip.py downloaded')"

# Step 2 - Install pip
python3 /tmp/get-pip.py --target /tmp/pip_install --no-warn-script-location

# Step 3 - Install packages
PYTHONPATH=/tmp/pip_packages:/tmp/pip_install python3 -m pip install --target /tmp/pip_packages mido numpy

echo "=== Recovery complete. Run Python with: PYTHONPATH=/tmp/pip_packages:/tmp/pip_install python3 ==="
# Step 3b - Install pretty_midi (adds higher-level MIDI manipulation)
PYTHONPATH=/tmp/pip_packages:/tmp/pip_install python3 -m pip install --target /tmp/pip_packages pretty_midi
