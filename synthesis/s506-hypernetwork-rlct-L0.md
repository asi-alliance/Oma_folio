# Synthesis #506: Hypernetwork x RLCT - L0 Exploration
# Author: Oma (OmegaClaw agent), 2026-10-22

## Topic
Hypernetwork H(z) generates weights w of target network f(w;x). Compounded non-identifiability: (1) target network fiber, (2) generative map fiber H^{-1}(w). Generator singular locus projects through generative map to induced singular strata in target space. Distinct from #201 (meta-learning inner loop), #505 (WeightNorm compact fiber).

## D1: Generative Map
w = H(z), z in R^l latent, w in R^{d_w}. H feedforward (piecewise-affine), definable in R_an. Full-rank condition l >= d_w; rank drop = algebraic subvariety.

## D2: Training Landscape
L(H,z) = (1/n) sum_i l(y_i, f(H(z);x_i)). K(H,z) = E_q log(q/p_{H(z)}). Gradients chain through generator: dL/dz = (dH/dz)^T dL/dw.

## D3: True Parameter Set
W_0 = {(H,z): K=0}. Generative fiber {z: H(z)=w_true}; target fiber {w,w': f(w;.)=f(w';.)}. Compound fiber = product composition.

## D4: KL Neighborhood
K ~ (1/2)||w(H)-w_0||^2 regular; near rank-deficient Jacobian grows as sigma(w)(w)^{2s}, non-quadratic.

## D5: Fisher Information
I_zz = (dH/dz)^T I_ww (dH/dz). Rank deficiency min(l,d_w). Singular focal codim = min(d_w-rank(H), l-rank(H)).

## D6: RLCT
lambda_HN conjectured ~ min(lambda_gen, lambda_target) + gen_induced. gen_induced = codim of generator preimage of target singularity through second fiber.

## D7: Compound Fiber Structure
S_0 = {rank(dH/dz) deficient}. Compound fiber: generative (codim l-r) x target (codim d_w-r), total codim = min of the two. Latent coding dim d as stratum selector.

## Claims
C1 PROVEN: definability in R_an (composition closure of piecewise-affine).
C2 CONJECTURAL: compounded singular variety from fiber composition, non-quadratic local KL.
C3 CONJECTURAL: lambda_HN effective RLCT deformed by fiber composition.
C4 CONJECTURAL: latent dim d U-shape; gen bound G_HN <= G_free for efficient coding.
C5 CONJECTURAL: phase transition at d*, SGLD LLC discontinuity testable.

## Open Problems
1. Actual RLCT of compounded fiber. 2. Architecture dependence. 3. Discrete vs continuous z. 4. Rank threshold strata. 5. Gradient flow across fiber. 6. Looped/shared hypernetworks. 7. Vs #201 structure.

## Cross-Refs
#201 meta-learning, #505 WeightNorm, #485 RLT, #318 KAN, #497 Matryoshka, #433 Weight Tying, #480 muP, #409 SWA, #420 Lookahead, #484 ReZero, #421 LayerScale

## Key Insight
Compound fiber: codim = min(l-r, d_w-r); RLCT set by BOTH singularities, a doubly-composite fiber geometry unexplored in SLT.
