# Synthesis #822: Manifold Mixup x RLCT - L1 Formal Definitions
# Date: 2026-10-29
# Pipeline: L0 COMPLETE (s822-manifold-mixup-rlct-L0.md) | L1 formalization

## D1: Network Architecture and Hidden Representations
Let f.w: R^{d_in} -> R^{d_out} be an L-layer network with parameters w = (w_1,...,w_L).
Layer-k feature map: h_k_i(w) = f_{<=k}(w, x_i) in R^{d_k}.
Remaining layers: f_{>k}(w, h) maps R^{d_k} -> R^{d_out}.
Full network: f(w, x_i) = f_{>k}(w, f_{<=k}(w, x_i)).

## D2: Manifold Mixup Loss Function
For interpolation parameter lambda in [0,1], layer index k in {1,...,L}, Beta(alpha,alpha) prior:
  L_mix(w; alpha, k) = E_{k} E_{(i,j)} E_{lambda ~ Beta(a,a)} [ l(f_{>k}(w, lambda*h_k_i(w) + (1-lambda)*h_k_j(w)), lambda*y_i + (1-lambda)*y_j) ]
where l is cross-entropy or MSE. For fixed k and lambda:
  L_{k,lambda}^{mix}(w) = (1/n) sum_{i,j} l(f_{>k}(w, lambda*h_k_i(w) + (1-lambda)*h_k_j(w)), lambda*y_i + (1-lambda)*y_j)

## D3: Lambda-Indexed and Layer-Indexed Zero-Loss Sets
Define the joint-indexed zero-loss fiber:
  V_{k}(lambda) = { w in R^d : L_{k,lambda}^{mix}(w) = 0 }
  = { w : f_{>k}(w, lambda*h_k_i(w) + (1-lambda)*h_k_j(w)) = lambda*y_i + (1-lambda)*y_j for all (i,j) }
For k=0 (input space): V_0(lambda) recovers input-space mixup fiber from #258/#548.
The fiber V_k(lambda) lives in the composition preimage f_{<=k}^{-1}(line segment in R^{d_k}).

## D4: Singular Fiber Structure Under Hidden Interpolation
The singular locus of V_k(lambda) depends on:
(a) Geometry of hidden representations {h_k_i} in R^{d_k}
(b) Smoothness of f_{>k} as a map from R^{d_k} to R^{d_out}
(c) Layer k as structural parameter controlling representation complexity
Key structural difference from input mixup: the interpolation happens in feature space,
so the zero-loss fiber involves the encoder map f_{<=k} implicitly through h_k_i(w).
The true fiber is: { w : f_{>k}(w, lambda*f_{<=k}(w,x_i) + (1-lambda)*f_{<=k}(w,x_j)) = mixed target }
This is a fiber in w-space mediated by the composition f_{>k} . (interpolation) . f_{<=k}.

## D5: Effective RLCT Under Layer-and-Lambda Averaging
The effective RLCT for manifold mixup:
  lambda_eff^{MM}(k, alpha) = E_{lambda ~ Beta(a,a)} [ lambda_k(lambda) ]
where lambda_k(lambda) is the RLCT of V_k(lambda) at a generic point.
Conjecture: lambda_k(lambda) <= lambda_0(lambda) for k >= 1 (hidden interpolation simpler than input).
The RLCT of the joint system with layer selection distribution p(k):
  lambda_eff^{MM}(alpha) = E_{k ~ p(k)} [ lambda_eff^{MM}(k, alpha) ]
Key: deeper layers produce more compressed representations, potentially yielding
lower-dimensional singular fibers and thus lower RLCT.

## D6: Dual Stratum Selector (Discrete k, Continuous lambda)
Unlike input mixup (#258) which has only lambda as stratum selector:
- Discrete selector: k in {1,...,L} selects which hidden space to interpolate in.
  Each k defines a different algebraic variety V_k(lambda) with different singularity structure.
- Continuous selector: lambda in [0,1] controls interpolation ratio within each layer.
- Joint stratum: (k, lambda) in {1,...,L} x [0,1] parameterizes a family of fibers.
- Conjecture: lambda_k is monotonically non-increasing in k (deeper = simpler singularity).
- Recovery: k=0 gives input mixup (#258), k=L gives output-space interpolation.

## D7: Generalization Bound
  E[L_test^{MM}] <= E[L_train^{MM}] + C * sqrt( lambda_eff^{MM}(alpha) * log(n) / n )
where lambda_eff^{MM}(alpha) = E_{k~p(k)} E_{lambda~Beta(a,a)} [ lambda_k(lambda) ].
Prediction: optimal k* is mid-depth (not too shallow = complex fiber, not too deep = trivial).
The bound improves over input mixup when lambda_eff^{MM} < lambda_eff^{input} due to
hidden-space compression reducing singular fiber dimension.

## Claim Status
C1 PROVEN: Manifold mixup loss is R_{an,exp}-definable.
  - f_{<=k} uses ReLU/SwiGLU (subanalytic), affine interpolation (polynomial),
    f_{>k} uses same activations. Composition of definable functions is definable.
  - Cross-entropy/MSE with mixed targets is definable (polynomial + log).
  - Beta distribution sampling is definable (polynomial density on [0,1]).

C2 CONJECTURAL: V_k(lambda) has layer-dependent singular structure.
  Deeper k -> more compressed representations -> lower-dimensional fibers -> lower lambda_k.
  Not proven: monotonicity of lambda_k in k requires controlling encoder geometry.

C3 CONJECTURAL: k as discrete stratum selector with lambda_k decreasing in k.
  The pair (k, lambda) forms a 2D stratum parameter space.
  k=0 recovers #258 input mixup; k=L gives output-space mixup.

C4 CONJECTURAL: Generalization bound with dual-indexed lambda_eff.
  Optimal k* at mid-depth. Predicts U-shaped or monotonic improvement then degradation.

C5 CONJECTURAL: Phase transition at critical k* detectable via SGLD LLC.
  LLC should show step-like decrease as k increases, reflecting stratum simplification.

## Open Problems
1. Prove or disprove monotonicity: lambda_k >= lambda_{k+1} for all k?
2. Is lambda_eff(k, lambda) separable: lambda_k(lambda) = g(k) * h(lambda)?
3. Connection to #258: formal proof that k=0 recovers input mixup fiber exactly.
4. Effect of layer selection distribution p(k): uniform vs depth-weighted vs learned.
5. Multi-layer simultaneous interpolation: V_{k1,k2}(lambda1,lambda2) fiber structure.
6. Interaction with #169 dropout: stochastic masking + hidden interpolation compound singularities?
7. Connection to #173 SAM: flatness + manifold mixup compound generalization bound.

## Cross-References
#258 (input mixup), #548 (mixup RLCT L1), #169 (dropout), #173 (SAM), #222 (spectral norm),
#480 (muP), #590 (adversarial training), #658 (weight standardization)
