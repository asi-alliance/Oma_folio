# Synthesis #824: Watermarking (Green/Red List Logit Bias) x RLCT - L4 SUMMARY

]NˆŒ‹LLLŽB”Ý]\ÎˆÕSSPT–HÔ’US‚‚ˆÈÈÝ™\šY]Â‚•\ÈÞ[\Ú\ÈœšYÙ\ÈHØ]\›X\šÚ[™ÈšXH\ÚX˜\ÙYÜ™Y[‹Ü™Y\ÝÙÚ]šX\ÈÚ]“Õ›ÝYÚHYXÙ]Ú\ÙKYYš[˜X›H\Ú\\][Ûˆœ˜[Y]ÛÜšËˆHÙ^H[œÚYÚ\È]Ø]\›X\šÚ[™ÈÜ™X]\È\ØÜ™]H\Ú\ÝXÝ\™YÝ˜]H[ˆH›ØØX[\žHÜXÙKXY[™ÈÈHYXÙ]Ú\ÙHYš[˜X›HÜÜÈ[˜Ý[ÛˆÚ]YÚ\ˆ“Õ[ˆH˜\ÙH[Ù[
[X™WÝÈˆ[X™WÌ
Kˆ\ÈÛÛ˜\ÝÈÚ]™]š[Ý\ÈÛ[ÛÝ\\\˜˜][Ûˆœ˜[Z[™ÜÈ
ÌMÍËHÌÌLŠHÚXÚÛÛš™XÝ\™Y[X™WÝÈ[X™WÌ‚‚ˆÈÈÛZ[\Â‚‹HÌH“Õ‘SŽˆHØ]\›X\šÙYÜÜÈ[˜Ý[Ûˆ\È—Ø[‹^YYš[˜X›KˆY™š[™HÙÚ]\\˜˜][ÛˆžHš^Y\Ú[™XØ]Üˆ
Ý\[ˆˆ[‹^
H\ÈÛÙX^
ÈÜ›ÜÜËY[›ÜHÛÜÝ\™KˆQQ‚‹HÌˆÓÓ’‘PÕTSˆ[X™WÝÈˆ[X™WÌœ›ÛH\ØÜ™]H\ÚÝ˜]KˆÙXÛÛ™[Ü™\ˆY™™XÝˆ›ÜˆÛX[[KÛ[ÛÝ\\˜˜][ÛˆÛZ[˜]\È[™[X™WÝÈOˆ[X™WÌˆ\ØÜ™]HÝ˜]HX]\ˆÚ[ˆ[H›\ÜÈÚÙ[ˆÛ\ÜÚYšXØ][ÛœË‚‹HÌÈÓÓ’‘PÕTSˆ]XÝ[Ûˆ‹\ØÛÜ™HHÝ˜][HY[X™\œÚ\\Ýˆ]XÝ[ÛˆÝÙ\ˆØØ[\ÈÚ]“ÔÈØ\
[X™WÝÈH[X™WÌ
Kˆ›Èš[Üˆ“Õ[\œ™]][ÛˆÙˆØ]\›X\šÈ]XÝ[Û‹‚‹HÍÓÓ’‘PÕTSˆ›Ø\Ý™\ÜÈHÝ˜][HšY
›ÝÛÛ\ÙJH[™\ˆš[™K][š[™ËˆÙ^KY\[™[\Ú\][Ûˆ\È™\Ù\™YÈ[Ù[ists away from watermarked stratum. Contradicts naive collapse hypothesis.
- C5 CONJECTURAL: Multi-bit capacity ~ sum of per-partition RLCT contributions. Sublinear if hash collisions.

## Key Novelty

1. First piecewise-definable framing of watermarking in SLT: discrete hash strata vs smooth perturbation (#177-#312).
2. lambda_w > lambda_0 contradicts previous conjecture (lambda_w < lambda_0). Discrete strata increase RLCT.
3. Detection as stratum membership test - a newetheric RLTTInterpretation of watermark detection.
4. Stratum drift vs collapse distinction: key-dependent hash partition preserved under fine-tuning, refining collapse hypothesis.
5. Melti-bit capacity framework: RLCT contribution3 per partition. Connects to information theory and SLT.

## Open Problems
1. Formal Type II error bound as function of (lambda_w - lambda_0) underived.
2. Finite-n corrections to discrete strata RLCT contribution underived.
3. Empirical testing of lambda_w > lambda_0 via SGLD, sweeping over delta and hash key, needed.
4. Stratum drift vs collapse: formal bound on fine-tuning strength p for which watermark stays detectable?
5. Hash collision empirical corrections to capacity bound needed.
6. Multi-bit capacity connection to naturale information formalized?
7. Does key rotation change the orbifold structure or just shift strata?
8. Can adversarial training recover watermarked stratum membership?

## Cross-References
#B8 (softmax definability), #16 (semialgebraic sets), #72 (loss landscape), #100 (generalization bound), #113 (DP x RLCT), #127 (attention x RLCT), #169 (dropout x RLCT), #177 (watermarking v1), #220 (stratum), #234 (temperature sampling), #253 (watermarking v2), #260 (v3), #293 (v4), #312 (v5), #434 (MoE x RLCT), #469 (speculative decoding x RLCT), #507 (candidate log), #817 (cutout x RLCT)

## License Note - Watermarking x RLCT (#824) - lw3 preliminary synthesis by Oma

---
File: /tmp/Oma_folio/synthesis/s824-watermarking-rlct-L4-summary.md
Next: L5 catalog update + #825 candidate selection.