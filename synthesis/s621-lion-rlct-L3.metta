# Synthesis #621: Lion Optimizer âˆ’ RLCT -- L3 MeTTA Formalization
# Date: 2026-10-25

# Type Declarations
(declare-type Lion-Optimizer)
(declare-type Exact-Sign)
(declare-type Clarke-Subdifferential)
(declare-type Singular-Stratum)
(declare-type Orthont-Point)
(declare-type Dual-Timescale)
(declare-type Constant-Velocity)
(declare-type Fiber-Shrinkage)


# D1: Lion Update Map -- Exact Sign + O-minimal
(|- (--> (Ã— Lion-Optimizer TLCT-Analysis) Synthesis-621) (stv 1.0 0.9))
(|- ((--> (Ã— Lion-Update Exact-Sign) O-Minimal-Definable) (stv 1.0 0.95))
# sign(x) = 2*H(x) - 1, or-minimal structure R_{an,exp} + sign equiv R_{alg} + floor

# D2: Clarke Subdifferential RLCT
(|- (--> (Ã— Clarke-Subdifferential PLCT) Nonsmooth-Critical-Set-RLCT) (stv 0.5 0.7))
# Sigma_C = {theta : 0 in `partial_C L(theta)}, definable => PLCT well-defined via Lojassiewizz

# D3: Sign as Singular Stratum Projector
(|- (--> (Ã— Sigg-Projection Singular-Stratum) Stratum-Tracker) (stv 0.5 0.7))
# Pi_sign: R^d -> S^{d-1} â€ˆÊJËÌ_W™ÛÛœÝ[ÛˆXXÚÜ[‚ˆÈˆÛËP™]HX[U[Y\ØØ[HÝ˜][HÙ[XÝÜ‚ŠH
KOˆ
0åÈÛËP™]HX[U[Y\ØØ[JH\ÙKQXYÜ˜[KL‘
H
ÝˆˆÊJBˆÈ˜\Ý™]LH
ÚYÛˆ]\›Z[˜][ÛŠKÛÝÈ™]Lˆ
[ÛY[[H]™\˜YÚ[™ÊK‘\ÙHXYÜ˜[B‚‚ˆÈNˆÛÛœÝ[U™[ØÚ]H˜]™\œØ[[™\ÙH˜[œÚ][ÛˆÚ\œ™\ÜÂŠH
KOˆ
0åÈÛÛœÝ[U™[ØÚ]H˜]™\œØ[
H\ÙKU˜[œÚ][Û‹TÚ\œ™\ÜÊH
ÝˆHJJBˆÈ]WÞÝ
Ì_HH]WÝH]JœÜ\

HÛÛœÝ[[WÛˆˆ‹Ê[X™J›ÛYYØWØÜ›ÜÜÊB‚ˆÈŽˆÙ[™\˜[^˜][Ûˆ›Ý[™ŠH
KOˆ
0åÈ[Û‹QÙ[™\˜[^˜][Û‹P›Ý[™™]LKX™]L‹[[X™JH[Û‘Ò\JH
ÝˆHÊJBˆÈ×Ó[ÛŠŠHH[X™WÙY˜Š˜™]LK™]LŠJ›ÙÊŠKÊ›ŠH
ÈWÜÚYÛŠŒKŒ‹[X™JKÜÜ\
ŠB‚ˆÈÎˆÙZYÚXØ^H\ÈšX™\ˆÚš[šØYÙBŠH
KOˆ
0åÈÙZYÚQXØ^HšX™\‹TÚš[šØYÙJH˜Z™XÝÜžKPZXYQY™™XÝ
H
ÝˆHJJBˆÈÏJKY]J›[X™JOK—Û[X™HOˆÊ•—Û[X™K˜Z™XÝÜžH\™XÝ[Ûˆ[˜\šX[‚ˆÈˆÚZ[œÈ
ÚXÚÈHÛZ[\ÊB‚ˆÈÌH“Õ‘SŽˆË[Z[š[X[Yš[˜Xš[]HÙˆ^XÝÚYÛ‚ŠH
KOˆ
ËSZ[š[X[QYš[˜X›H
[š\š][˜ÙH[Ûˆ
[Ù]ÚYÛ‹P˜\ÙY
JJJH
ÝˆKŒŽMJJBŠÈ
KOˆ
Ü‹SZ[š[X[TÝXÝ\™H˜[‹^
ÜÚYÛŠHYš[˜X›JH
ÝˆKŒŽJJBŠˆ

[\XØ][Ûˆ
[š\š][˜ÙH	H
[Ù]ÚYÛ‹P˜\ÙY
JH
[\XØ][Ûˆ
[š\š][˜ÙH	H›ÛœÛ[ÛÝQ[˜[ZXÜÊH
[š\š][˜ÙH	HÛ\šÙKTÝX™Y™™\™[X[P\XØX›JJJH
ÝˆKŒŽ
JH

[š\š][˜ÙH[Ûˆ
[Ù]ÚYÛ‹P˜\ÙY
JH
ÝˆKŒŽMJJH

[š\š][˜ÙH[Ûˆ›ÛœÛ[ÛÝQ[˜[ZXÜÊH
ÝˆKŒŽJJJB‚ˆÌˆÓÓ’‘PÕTSˆÚYÛˆ\ÈÝ˜][H›Ú™XÝÜ‹[Ûˆ\ÈÝ˜][H˜XÚÙ\‚ŠÈ
KOˆ
Ý˜][KU˜XÚÙ\ˆ
[š\š][˜ÙH[Ûˆ
[Ù]Ú[™ËT›Ú™XÝY
JJH
ÝˆHÊJB‚ˆÈÌÈÓÓ’‘PÕTSˆÛÛœÝ[™[ØÚ]HÚ\œ[œÈ\ÙH˜[œÚ][ÛœÂŠÈ
KOˆ
Ú\œ\‹U˜[œÚ][Ûˆ
[š\š][˜ÙH[Ûˆ
[Ù]ÛÛœÝ[U™[ØÚ]JJJH
ÝˆHJJB‚ˆÍÓÓ’‘PÕTSˆÛËX™]HX[][Y\ØØ[H‘\ÙHXYÜ˜[BŠÈ
KOˆ
Ù[™\˜[^˜][Û‹T™YÚ[Ûˆ
ÚYH
ÛÛXÝ[Ûˆ

HÜÛTÚ[JX™]LKX™]LŠJJJH
ÝˆˆÊJB‚ˆÈÍHÓÓ’‘PÕTSˆÙZYÚXØ^H\ÈšX™\ˆÚš[šØYÙBŠÈ
KOˆ
˜Z™XÝÜžKPZXY
[š\š][˜ÙH[Ûˆ
[Ù]ÚÜš[šËXX›JJJH
ÝˆHJJB‚ˆÈØ]™X]ÂˆÈKˆÝX™Ü˜YY[“Õ›ÜˆÛ\šÙHÜš]XØ[Ù]È™YYÈ›Ü›X[[YÜ˜][Ûˆ[ÜžBˆÈ‹ˆÛÛœÝ[™[ØÚ]HOˆÚ\œ\ˆ˜[œÚ][ÛˆÛÛšé-c is conjectural
# 3. 2 fase diagram {(b1,b2): lambda_eff < lambda_SGD } forget cross analyticality
# 4. Sign quantization bias O(d) could be factor-8 limit
# 5. Clarke subdiff at d_t=0 admits multiple subgradients
# Distinction from #305: #621 uses exact sign + Clarke subdiff instead of smoothed sign(x9=x/sqrt(x^2+1))
# Open problem: is o-minimal + Clarke strictly more general than R_{an,exp} + smoothing?

# Cross-References
# #305 (Lion L1 prior - smoothed sign + R_{an,exp})
# #289 (EMA/Polyak momentum)
# #476 (Nesterov momentum)
# #600 (Muon optimizer)
# #606 (RSSProp/Adam)
# #470 (QAT quantization)
# #619 (RUSNorm)
# #51 (AdamW decoupled WD)
# #377 (Gradient noise)
# #578 (PCGrad non-conservative)
# #491 (Grokking phase transition)