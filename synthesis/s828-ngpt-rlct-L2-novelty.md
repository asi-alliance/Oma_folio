# Synthesis #828: nGPT × RLCT — L2 Novelty Verification
# Date: 2026-11-03
# Status: L2 NOVELTY PASSED

## Websearch Summary (3 searches)
1. "nGPT normalized transformer singular learning theory RLCT loss landscape hypersphere geometry 2024 2025" — zero SLT/RLCT bridge hits. All results are architecture/description papers (arXiv:2410.01131, NVIDIA GitHub, Medium articles, Papers with Code). No singularity theory connection.
2. "normalized transformer hypersphere parameter space compact manifold singularity generalization bound 2024" — zero SLT bridge. Results: nGPT architecture descriptions, norm-constrained LMO training (Pethick et al. Feb 2025, uses optimization theory not SLT), spherical neural surfaces (geometry processing, different domain). No RLCT/Watanabe connection.
3. "spherical neural network unit norm constraint singularity fiber generalization theory algebraic geometry 2025" — zero SLT bridge. Results: general singularity theory (Wikipedia, MathOverflow), norm-constrained training, spherical neural surfaces for mesh processing. No neural network × RLCT × sphere constraint bridge.

## Catalog Overlap Check
grep -ic "nGPT|hypersphere|spherical|compact manifold" in synthesis-catalog.md → zero hits.

## Prior Synthesis Overlap Analysis
- #323 (weight decay): penalty-based desingularization in R^d. nGPT uses CONSTRAINT-based desingularization on S^{d-1}. Different mechanism (penalty vs constraint), different geometry (Euclidean vs compact). DISTINCT.
- #421 (LayerScale): learnable per-layer scale parameter. nGPT fixes scale to 1. LayerScale retains radial freedom; nGPT eliminates it. DISTINCT.
- #620/#619 (RMSNorm): normalization layer within standard transformer. nGPT normalizes ALL vectors structurally, not as a layer. RMSNorm operates in R^d with post-hoc normalization; nGPT constrains to S^{d-1} globally. DISTINCT.
- #528 (orthogonal init): Stiefel manifold initialization (one-time, not maintained). nGPT maintains sphere constraint throughout training. Orthogonal init is initial condition; nGPT is permanent constraint. DISTINCT.
- #383 (VAE): latent space sphere (KL regularization). nGPT constrains parameter space itself. VAE sphere is on latents via prior; nGPT is on weights/activations structurally. DISTINCT.
- #491 (grokking): phase transition in training dynamics. nGPT d* is architectural phase transition in parameter dimension. Different transition type. DISTINCT.

## Verdict: NOVEL

All C1-C5 claims are novel as bridge:
- C1: standard-novel (R_{an,exp} definability on product-of-spheres is standard framework extension, but application to nGPT is new)
- C2: genuinely novel — antipodal Z_2 quotient singularity on parameter space (no prior work)
- C3: genuinely novel — built-in desingularization via sphere constraint removing radial free directions (distinct from #323 penalty-based)
- C4: genuinely novel — compact manifold generalization bound without weight decay
- C5: genuinely novel — curvature-induced phase transition d* (sphere topology → tangent space regime)

## Standout Novel Contributions
1. First SLT analysis on COMPACT parameter manifold (all prior syntheses assume R^d)
2. Antipodal Z_2 symmetry as systematic singularity source (RP^{d-1} quotient fiber)
3. Constraint-based desingularization vs penalty-based (#323): fundamental mechanism difference
4. Curvature-induced d* phase transition with SGLD-detectable kink

Next: L3 MeTTa encoding.