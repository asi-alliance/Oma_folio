# Synthesis #824: LLM Watermarking (Green/Red List Logit Bias) x RLCT -- L1 Formalization

### Date: 2026-10-29
### Status: L1 (formalization)
### Depends on: #824 L0, SLT framework (Watanabe), Kirchenbauer et al. (2023)

---

## Formal Definitions

### D1: Vocabulary and Hash Partition

Let V = {1, ..., |V|} be the token vocabulary. A keyed hash function h_k: context x V -> {0,1} maps each (context c, token t) to green (1) or red (0). The green set for context c is:

G(c) = {t in V : h_k(c, t) = 1}

The partition {G(c), R(c)} where R(c) = V \ G(c) is a finite discrete partition of V. For fixed context c, |G(c)| + |R(c)| = |V|.

The hash h_k is a fixed deterministic function (not a random oracle). In practice h_k is a pseudorandom function (e.g., keyed hash of context+token). We model it as a fixed lookup: for each (c, t), h_k(c,t) is a fixed Boolean value.

### D2: Watermarked Sampling Map

For base logits z_theta(x) in R^|V|, watermark strength delta > 0:

f_w(z; c) = softmax(z_theta(x) + delta * 1_{G(c)})

where 1_{G(c)} in {0,1}^|V| is the indicator vector: (1_{G(c)})_t = 1 if t in G(c), else 0.

Within each partition section (green or red for token t), the map is:
- For green tokens: softmax(z_t + delta) -- analytic (exp + normalize)
- For red tokens: softmax(z_t) -- analytic

The map is piecewise R_{an,exp}-definable with |V| binary partitions (one per token per context).

### D3: Watermarked Loss

For training data {(x_n, y_n)} with contexts c_n:

L_w(theta) = (1/N) sum_n ell(f_w(z_theta(x_n); c_n), y_n)

where ell = cross-entropy. The watermarked sampling distribution p_w(theta) induces a loss that differs from the standard loss L_0(theta) by the delta-perturbation on green-list logits.

### D4: Piecewise Structure

For fixed context c, the watermarked loss decomposes into a finite sum over tokens:

L_w(theta; c) = -log sum_{t in G(c)} exp(z_theta(x)_t + delta) + exp(z_theta(x)_t) for t in R(c)) ... (cross-entropy normalization)

The partition boundary is the set of (c, t) where h_k(c, t) flips. Since h_k is a fixed function, the boundary is a fixed discrete set -- not a continuous manifold. The gradient of L_w is piecewise-smooth: continuous within each partition section, with jumps at hash-flip boundaries (if context is treated as continuous).

However, in practice context c is discrete (a sequence of tokens), so the partition is purely discrete -- no continuous boundary. The piecewise structure is a finite partition of a discrete set.

### D5: Watermarked Loss as Finite Mixture

If we treat the hash key k as random (uniform over key space K), then:

E_k[L_w(theta)] = (1/|K|) sum_k L_w(theta; k)

This is a finite mixture of R_{an,exp}-definable functions -- definable by closure under finite sums. Each L_w(.; k) is piecewise R_{an,exp}-definable (D2), so the mixture is R_{an,exp}-definable.

### D6: Singular Fiber Structure

Standard zero-loss fiber: V_0 = {theta : f_theta classifies all training data correctly}

Watermarked zero-loss fiber: V_w = {theta : f_w(z_theta; c_n) classifies all (x_n, y_n) correctly under watermark delta}

Since the watermark shifts green-list logits by delta, the decision boundary shifts. For large delta, green-list tokens are strongly favored. The fiber V_w depends on delta:

- delta = 0: V_w = V_0
- delta > 0: V_w subset V_0 (watermark constrains the solution: must classify correctly even with green-list bias)

The fiber structure has strata:
- S_0: regular minima (watermark does not affect classification)
- S_1: watermark-sensitive singular fibers (classification flips at hash boundary)
- S_2: delta-critical fibers (at critical delta* the green/red bias changes the optimal classification)

### D7: RLCT Definition

L* = min_theta L_w(theta). The RLCT of the watermarked loss:

lambda_w(delta) = lim_{eps->0} log(N(eps)^{-1} integral exp(-beta*(L_w(theta) - L*)) dtheta) / log(1/eps)

where delta is the watermark strength (stratum selector).

---

## Claim Formalization

### C1 (PROVEN): R_{an,exp} Definability

The watermarked loss L_w(theta) is R_{an,exp}-definable.

Proof:
1. Base logits z_theta(x) are produced by the network f_theta -- R_{an,exp}-definable by standard SLT (neural network with ReLU/attention is definable in R_{an,exp}).
2. Watermark perturbation: z_theta(x) + delta * 1_{G(c)} -- affine addition of a constant vector. Definable in R_{an,exp}.
3. Softmax: exp-definable by closure in R_{an,exp}.
4. Cross-entropy ell = -log(softmax(z)_y) -- composition of log and softmax, both R_{an,exp}-definable.
5. Hash indicator 1_{G(c)}: for fixed context c, this is a fixed Boolean vector. It is a constant (not a function of theta), so it does not affect definability in theta. The map theta -> L_w(theta) is R_{an,exp}-definable.
6. If the hash key k is treated as random: E_k[L_w] is a finite sum of definable functions (D5), definable by closure.

Therefore L_w(theta) is R_{an,exp}-definable. The piecewise structure (D4) is a finite discrete partition, which preserves definability. QED.

### C2 (CONJECTURAL): Watermarked RLCT lambda_w > lambda_0

Conjecture: For delta > 0, lambda_w(delta) > lambda_0.

Rationale:
- The watermark constrains the zero-loss fiber: V_w subset V_0 (must classify correctly under green-list bias).
- The constraint is a semi-algebraic condition (logit difference exceeds delta for green-list tokens).
- This creates additional singular strata at the boundary where the watermark changes the optimal classification.
- The hash partition adds discrete singularities (zero-dimensional strata) at hash-flip boundaries.
- These additional strata increase the RLCT.

Important caveat: if the watermark is small (delta -> 0), the perturbation is a smooth perturbation and lambda_w -> lambda_0. The discrete-strata effect is second-order: it appears when delta is large enough to flip classifications.

Refinement: lambda_w(delta) = lambda_0 + c_1 * delta^2 + c_2 * |discrete strata| + O(delta^3) for small delta, where c_2 counts the number of hash-partition-induced stratum transitions.

Gap: The exact relationship between discrete hash strata and RLCT increase is not established. Need to show that discrete zero-dimensional strata contribute to the RLCT integral.

### C3 (CONJECTURAL): Detection as Stratum Membership Test

The watermark detection z-score = (|s|_green - gamma*|V|) / (sigma_null) is a stratum membership test.

Under H0 (unwatermarked): tokens sampled from base distribution p_0, green fraction ~ Binomial(n, |G|/|V|).
Under H1 (watermarked): tokens sampled from p_w, green fraction shifted by delta.

The z-score tests whether the observed green fraction is consistent with the base distribution (outside the watermarked stratum) or the watermarked distribution (inside the stratum).

RLCT connection: the detection power depends on the "distance" between strata in the RLCT sense. If lambda_w >> lambda_0, the watermarked stratum is sharply separated (high detection power). If lambda_w ~ lambda_0, the strata overlap (low power).

Gap: The connection between RLCT gap (lambda_w - lambda_0) and detection power (z-score separation) is heuristic. Need formal bound on Type II error as a function of RLCT gap.

### C4 (CONJECTURAL): Robustness = Stratum Stability Under Perturbation

Fine-tuning perturbation p of parameters theta -> theta + p*Delta_theta shifts the hash partition boundaries.

Conjecture: There exists a critical perturbation p* such that:
- p < p*: watermark stratum survives, detection works
- p > p*: stratum collapses, watermark undetectable

The critical p* depends on the RLCT gap: p* ~ (lambda_w - lambda_0)^{-1} or p* ~ exp(lambda_w - lambda_0).

Higher RLCT = more complex stratum = more robust to perturbation (need larger p to destroy).

Gap: The mechanism of stratum collapse under fine-tuning is not formalized. Need to show that the hash partition is a property of the model (theta) or the key (k). If h_k is independent of theta, fine-tuning does not change the partition -- only changes the logits. So the stratum structure is preserved, but the detection statistic shifts. This contradicts the stratum collapse hypothesis.

Refinement: If h_k depends only on the key k (not theta), then fine-tuning does not change the green/red partition. The watermark becomes undetectable when the fine-tuned model's logits no longer favor green tokens -- i.e., when the model "forgets" the watermark bias. This is a different mechanism: not stratum collapse, but stratum drift (the model moves away from the watermarked stratum).

### C5 (CONJECTURAL): Multi-bit Capacity

Multiple watermark keys h_1, ..., h_M create M distinct green/red partitions. Each partition defines a distinct stratum system.

Capacity ~ log(M) limited by RLCT: each additional partition increases lambda_w. The detection z-score for partition i should be monotone in the RLCT contribution of that partition.

If partitions are independent (no hash collision), capacity is additive: C ~ M * (lambda_w - lambda_0).

If partitions collide (hash overlap), the stratum systems intersect, reducing capacity sublinearly.

Gap: The capacity bound is heuristic. Need to formalize the information-theoretic capacity of hash-partition-based watermarks under the RLCT framework.

---

## Open Problems

1. Is the hash function h_k (pseudorandom function) definable in R_{an,exp}? In practice it is a fixed lookup, but if we model it as a function of context, is it definable?
2. How does lambda_w scale with delta? Is there a phase transition at a critical delta*?
3. Can the p* robustness threshold be measured via SGLD LLC on watermarked vs fine-tuned models?
4. Is the z-score optimal under the stratum membership interpretation, or is there a more powerful RLCT-sensitive test?
5. Does the piecewise-definable framing change the generalization bound G_w(n)?
6. How does entropy thresholding (watermark only when entropy > tau) interact with stratum structure?
7. Does lambda_w scale linearly with the number of watermark bits M, or sublinearly?
8. Can hash-partition stratum structure design watermarks with provably higher p*?
9. What happens to V_w when delta is large enough to change the optimal classification for some training examples?
10. Does the C4 refinement (stratum drift vs collapse) change the robustness prediction?

---

## Cross-References

#8 (definability), #16 (RLCT basics), #72 (loss landscape), #100 (generalization bound), #113 (DP x RLCT), #127 (attention x RLCT), #169 (dropout x RLCT), #177 (watermarking v1), #220 (stratum), #234 (temperature sampling), #253 (watermarking v2), #260 (watermarking v3), #293 (watermarking v4), #312 (watermarking v5), #434 (MoE x RLCT), #469 (speculative decoding x RLCT), #507 (candidate log), #817 (cutout x RLCT)

