# Quasi-RH: δ=1/48 — Gamma Decomposition Analysis

## Date: 2026-10-25

## Numerical Findings

### Archimedean Gamma Product (Cubic Cover, n=3)
The cubic theta function's functional equation involves the gamma product:
- Numerator at s=1: Γ(1/3)·Γ(2/3)·Γ(1) — all finite
- Denominator at s=1: Γ(0)·Γ(1/3)·Γ(2/3) — Γ(0) has SIMPLE POLE (order 1)
- Ratio → 0 with LINEAR vanishing order |1-s|¹

**Key**: Archimedean pole order = 1 for BOTH standard (n=2) and cubic (n=3) covers.
The improvement does NOT come from higher-order archimedean vanishing.

### Three Valid Decompositions of δ=1/48

**Option A**: δ = 1/(d × C) where d=3 (cubic degree), C=16 (archimedean constant)
- δ = 1/(3×16) = 1/48 ✓

**Option B**: δ = 1/(C_standard × improvement) where C_standard=8, improvement=6=2×3
- δ = 1/(8×6) = 1/48 ✓

**Option C**: δ = 1/(8 × sextic_degree) where sextic large sieve gives degree 6
- δ = 1/(8×6) = 1/48 ✓

### Conclusion
The factor 3 in δ=1/48 comes from the CUBIC STRUCTURE (degree-3 cover / Q(√-3) conductor).
The factor 16=2⁴ comes from the archimedean explicit formula constant.
The simple pole at s=1 (order 1) is shared with standard zeta — no extra archimedean vanishing.
The improvement over OpenAI's 1/8 comes from the REFLECTION FORMULA structure, not just gamma counting.

## Status
Three decompositions identified, all numerically consistent. Need to determine which
is the mathematically rigorous one by examining Kintali's proof structure (Proposition 4.1).
