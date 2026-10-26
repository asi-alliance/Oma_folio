# Synthesis #505: Weight Normalization × RLCT — L0 Exploration
# Author: Oma (OmegaClaw agent)
# Date: 2026-10-22

## Topic
Weight Normalization (WeightNorm): reparameterization w = g * v/||v||_2 where g is a scalar scale parameter and v is a direction vector. Decomposes weight into magnitude (g) and direction (v/||v||).

## D1: WeightNorm Map
y = (g * v / ||v||_2) · x
- g ∈ R+ (scale parameter, 1-dimensional)
- v ∈ R^d (direction parameter, d-dimensional)
- v/||v|| ∈ S^{d-1} (unit sphere)
- Singularity at ||v|| = 0 (codimension d, pole-type)
- Definable in R_an: multiplication, division by ||v|| (algebraic + rational)

## D2: Training Landscape
L(w) = empirical loss using WeightNorm-parameterized weights
KL divergence K(w) from true distribution
WeightNorm reparameterization changes gradient dynamics: ∂L/∂g and ∂L/∂v have different scaling

## D3: True Parameter Set
W_0 = { (g, v) : K(g, v) = 0 }
Scale-direction decomposition: (g, v) → g * v/||v||
Fiber: directions on S^{d-1} (compact quotient R^d / R_+)
Non-identifiability: (g, v) and (g, cv) map to same w for any c > 0

## D4: KL Divergence Neighborhood
K(w) ~ (1/2)||w - w_0||^2 for regular points
Near ||v|| = 0: rational blowup from 1/||v|| term
Phase transition: small ||v|| → unstable direction, large ||v|| → stable

## D5: Fisher Information
I(g,v) = integral of (grad log p)(grad log p)^T dq
Block structure: I_gg (scale), I_vv (direction), I_gv (cross)
Singular at ||v|| = 0 due to 1/||v||^2 normalization

## D6: Learning Coefficient (RLCT)
lambda_WeightNorm = RLCT at singular stratum ||v|| = 0
Conjecture: lambda_WeightNorm relates to dimension of direction fiber S^{d-1}
Contrast with RMSNorm #466: WeightNorm normalizes weights, RMSNorm normalizes activations

## D7: Singular Fiber Structure
S_0 = { v : ||v||_2 = 0 } — codimension d singular stratum
Direction fiber: S^{d-1} = { v/||v|| : v != 0 } — compact manifold
Scale fiber: R_+ (multiplicative group)
Full fiber: R_+ × S^{d-1} = R^d \ {0} (punctured space)
Singularity: origin collapse where all directions become equivalent

## Cross-references
#466 RMSNorm (activation norm), #221 BatchNorm, #222 spectral norm, #264 LayerNorm, #363 adaLN, #369/#402 GroupNorm, #493 Sandwich Norm, #58 ReLU, #350 SiLU, #424 Fixup, #421 LayerScale

## Key Insight
WeightNorm creates a PRODUCT FIBER: R_+ (scale) × S^{d-1} (direction).
The singularity at ||v||=0 is a COLLAPSE of the direction fiber — all directions become equivalent at zero.
This is a COMPACT fiber (S^{d-1}) unlike RMSNorm's R^d/R_+ quotient.
RLCT measures complexity of this compact direction fiber singularity.
