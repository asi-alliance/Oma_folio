# Synthesis #839: Gumbel-Softmax (Concrete Distribution) × RLCT — L4 Summary
# Date: 2026-11-03
# Pipeline: L0 ✓ | L1 ✓ | L2 ✓ (NOVEL) | L3 ✓ | L4 ← | L5 pending

## Core Bridge
Connects the Gumbel-Softmax / Concrete Distribution temperature parameter τ to the
Real Log Canonical Threshold (RLCT) framework of Watanabe's Singular Learning Theory.
Temperature τ acts as a continuous stratum selector interpolating between:
  - τ→0: discrete combinatorial fiber V_0 (polyhedral strata from argmax)
  - τ→∞: uniform fiber V_uniform (low-complexity)
  - Intermediate: smoothed definable variety V(τ)

## Claim Summary
C1 PROVEN: L_τ is R_{an,exp}-definable in w.
  Gumbel noise -log(-log(u)) definable on (0,1)^K; y(w,x,g,τ) via exp/div/log;
  cross-entropy l(y,t) = polynomial + log; finite sum → definable by Loi theorem.
  Finite RLCT follows from resolution of singularities for definable functions.

C2 CONJECTURAL (LINCHPIN): λ(τ) monotonically non-decreasing as τ→0.
  τ→0: combinatorial strata (finite union of polyhedral regions)
  τ>0: smoothed deformation, definable variety
  Monotonicity UNPROVEN — requires controlling how Gumbel-Softmax smoothing
  affects singularity order. No existing theorem covers this.

C3 CONJECTURAL: τ* phase transition at τ*~O(1/K).
  SGLD detectability: LLC shows kink/step when τ crosses τ*.

C4 CONJECTURAL: G(n,τ) ~ λ(τ)·log(n)/(2n) + b(τ).
  b(τ) = discretization gap, vanishes as τ→0. Interior optimum τ_opt exists.

C5 CONJECTURAL: Annealing schedule τ(t) ~ τ*·(1-t/T)^α, α=1/(1+λ_0).
  Creates temporal stratum curriculum: smooth→discrete fiber traversal.

## Novelty Assessment (L2)
5 websearches found NO prior work connecting Gumbel-Softmax/Concrete Distribution
temperature to RLCT or singular learning theory. Bridge is genuinely novel.
Distinct from #234 (Temperature Scaling: calibration T, not relaxation τ),
#354 (STE: discrete gradient, not continuous relaxation), #377 (temperature dial).

## Key Distinctions
- #234: T scales logits post-hoc for calibration; τ controls relaxation sharpness
- #354: STE creates C^{-1} singularity at boundary; Gumbel-Softmax smooths it
- #377: Generic temperature dial; #839 is specifically about discrete-continuous bridge
- #433: PolyLoss degree selector (polynomial degree); #839 is simplex relaxation

## Open Problems
1. V(τ)→V_0 convergence topology (Hausdorff vs Zariski vs Thom)
2. λ(τ) explicit for K=2 binary case
3. Phase transition vs smooth crossover at τ*
4. Gumbel noise injection additional singularities
5. ST-Gumbel-Softmax dual singularity (STE + temperature)
6. Rigorous annealing schedule derivation
7. Multi-level hierarchical Gumbel-Softmax temperature interaction

## Cross-References (15)
#8, #16, #100, #169, #224, #234, #244, #258, #354, #377, #409, #433, #486, #539, #647

## File Inventory
L0: s839-gumbel-softmax-rlct-L0.md (claims outline)
L1: s839-gumbel-softmax-rlct-L1.md (118 lines, sha256 5ee0cb09)
L2: novelty verdict NOVEL (5 websearches, zero prior bridge)
L3: s839-gumbel-softmax-rlct-L3.metta (116 lines, sha256 2e726f80)
L4: this file
L5: pending catalog append
