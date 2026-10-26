# Synthesis #621: Lion Optimizer x RLCT -- L1 Formalization

## Date: 2026-10-25

## Definitions (D1-D7)

### D1: Lion Update Map
- Interpolated direction: d_t = beta1*m_{t-1} + (1-beta1)*g_t
- Sign update: u_t = sign(d_t) in {-1, 0, +1}^d (coordinatewise)
- Parameter update: theta_{t+1} = (1-eta*lambda)*theta_t - eta*u_t
- Momentum buffer: m_t = beta2*m_{t-1} + (1-beta2)*g_t

Definability: sign(x) = 2*H(x) - 1 where H is Heaviside. In o-minimal structure R_{an,exp} + sign (equiv R_{alg} + floor), update map is definable. t-fold composition definable by o-minimal closure (van den Dries). C1 PROVEN.

Distinction from #305: #305 used sign(x)=x/sqrt(x^2+eps) in R_{an,exp}. #621 uses EXACT sign requiring o-minimal extension beyond R_{an,exp}. #305 analyzes sign as L-infinity projection; #621 analyzes sign as singular stratum projector via Clarke subdifferential.

### D2: Clarke Subdifferential RLCT
For locally Lipschitz loss L: R^d -> R, Clarke subdifferential:
partial_C L(theta) = conv{lim grad L(theta_i) : theta_i -> theta, theta_i not in Omega_L}

Subgradient RLCT: For Clarke critical set Sigma_C = {theta : 0 in partial_C L(theta)}, lambda_C = multiplicity of Sigma_C in zero set of Clarke subdifferential correspondence. Under o-minimal definability, Sigma_C is definable, RLCT well-defined via Lojasiewicz inequality.

Key: Lion trajectory visits points where sign(d_t) discontinuous (d_t=0). Clarke subdifferential multi-valued, RLCT determined by worst-case subgradient.

### D3: Sign as Singular Stratum Projection
Pi_sign: R^d -> S^{d-1} cap {+/-1}^d by Pi_sign(g) = sign(g)/sqrt(d).
- Constant on each orthant O_sigma
- Discards radial info, preserves orthant membership
- Preimage Pi_sign^{-1}(sigma) = O_sigma is definable open cone

Singular fiber: gradient near V_lambda points in directions determined by local singularity. Pi_sign projects onto dominant orthant identifying which side of singular fiber. Lion moves at constant velocity eta*sqrt(d) direction Pi_sign(d_t), independent of gradient magnitude. Lion tracks WHICH stratum, discards HOW FAR. Fundamentally different from SGD (tracks distance) and Adam (tracks relative distance).

### D4: Two-Beta Dual-Timescale Stratum Selector
Fast timescale (beta1): Controls sign determination rate. High beta1 = stable stratum tracking. Low beta1 = reactive switching. Sign-switching rate rho(beta1) = E[sign(d_t) != sign(d_{t-1})].
Slow timescale (beta2): Controls momentum buffer averaging. High beta2 = long memory. Low beta2 = short memory.
Dual-timescale RLCT: lambda_eff(beta1,beta2). Phase transition at (beta1*,beta2*) where dual-timescale crosses from memorization to generalization stratum. 2D phase diagram defines generalization region.

### D5: Constant-Velocity Traversal and Phase Transition Sharpness
||theta_{t+1} - theta_t|| = eta*sqrt(d) (constant, independent of gradient magnitude).
Traversal time T_S = diam(S)/v constant. SGD slows near singularities; Lion uniform time per stratum.
Phase transition width: SGD Delta_n ~ 1/lambda (broad). Lion Delta_n ~ v/(lambda*omega_cross) (sharper). Conjecture: Lion transition sharper than SGD.

### D6: Generalization Bound
G_Lion(n) <= lambda_eff(beta1,beta2)*log(n)/(2n) + U_sign(beta1,beta2,lambda)/sqrt(n)
U_sign captures: sign quantization bias O(d), weight decay shrinkage bias O(lambda^2*||theta||^2), two-beta mismatch O(|beta1-beta2|^2*||g||^2).
lambda_eff(Lion) <= lambda_SGD when sign projection aligns with low-lambda stratum. U_sign may exceed U_SGD due to quantization. Net improvement when RLCT reduction exceeds bias increase.

### D7: Weight Decay as Singular Fiber Shrinkage
Shrinkage k=(1-eta*lambda)<1. V_lambda -> k*V_lambda (scaled copy, same multiplicity). But sign update u_t=sign(d_t) unaffected by theta scaling: trajectory direction invariant while position shrinks. Effect: trajectory runs ahead of shrinking fiber. Optimal lambda* where k*V_lambda aligns with sign-projected gradient direction.

## Claims Summary
C1 (PROVEN): O-minimal definability of Lion update with exact sign.
C2 (CONJECTURAL): Sign as singular stratum projector, Lion as stratum tracker.
C3 (CONJECTURAL): Constant velocity sharpens phase transitions vs SGD.
C4 (CONJECTURAL): Two-beta dual-timescale 2D phase diagram, generalization region non-empty.
C5 (CONJECTURAL): Weight decay as fiber shrinkage with trajectory-ahead effect.

## Open Problems
1. Formalize subgradient RLCT for Clarke critical sets under o-minimal definability
2. Prove/disprove: Lion constant velocity -> sharper phase transition
3. Characterize 2D phase diagram {(beta1,beta2): lambda_eff < lambda_SGD}
4. Quantify sign quantization bias U_quant = O(d) -- dimension dependence real?
5. Clarke subdifferential at d_t=0: what subgradients admitted?
6. Connection to #305: o-minimal + Clarke strictly more general than R_{an,exp} + smoothing?
7. Empirical: measure LLC via SGLD for Lion vs SGD

## Cross-References
#305 (Lion L1 prior), #289 (EMA/Polyak), #476 (Nesterov), #600 (Muon), #606 (RMSProp/Adam), #470 (QAT), #619 (RMSNorm), #51 (AdamW), #377 (Gradient noise), #578 (PCGrad), #491 (Grokking)

## Next: L2 novelty verification
