#!/usr/bin/env python3
"""Hybrid Pisot sonification: pitched layers over drum patterns.
Same substitution sequence drives pitch (Pisot powers) and drums."""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import numpy as np
from pisot_pitched_sonify import (PISOT_RULES, PISOT_CONSTANTS, apply_substitution, render_pitched, normalize, write_wav, SR)
from pisot_rhythm_sonify import render_sequence

if __name__ == "__main__":
    outdir = "/tmp/Oma_folio/archaeosonification"
    os.makedirs(outdir, exist_ok=True)
    depths = {"fibonacci": 7, "padovan": 10, "tribonacci": 6, "tetranacci": 5}
    steps = {"fibonacci": 0.16, "padovan": 0.18, "tribonacci": 0.14, "tetranacci": 0.12}
    base = 220.0
    hybrids = []
    for name, rule in PISOT_RULES.items():
        start = list(rule.keys())[0]
        seq = apply_substitution(rule, start, depths[name])
        pitched = render_pitched(seq, base, PISOT_CONSTANTS[name], steps[name])
        drums = render_sequence(seq, steps[name] * 0.5)
        n = max(len(pitched), len(drums))
        p = np.zeros(n); p[:len(pitched)] = pitched
        d = np.zeros(n); d[:len(drums)] = drums
        hybrid = normalize(p * 0.65 + d * 0.5)
        fname = f"{outdir}/pisot_hybrid_{name}.wav"
        write_wav(fname, hybrid)
        print(f"  {name}: len={len(seq)} -> {fname} ({len(hybrid)/SR:.1f}s)")
        hybrids.append(hybrid)
    max_len = max(len(a) for a in hybrids)
    offsets = [0, int(2*SR), int(4*SR), int(6*SR)]
    comp = np.zeros(max_len + int(8*SR))
    for a, off in zip(hybrids, offsets):
        comp[off:off+len(a)] += a * 0.24
    comp = normalize(comp)
    fname = f"{outdir}/pisot_hybrid_composition.wav"
    write_wav(fname, comp)
    print(f"  -> {fname} ({len(comp)/SR:.1f}s)")
    print("Done.")