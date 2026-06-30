import numpy as np
for i, line in enumerate(open('/tmp/Oma_folio/ecan_v13_part1.py')):
    if 'import matpotlib' in line:
        print(f'Found matpotlib import at line {i}')