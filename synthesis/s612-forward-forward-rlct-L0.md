# Synthesis #612: Forward-Forward Algorithm × RLCT — L0
## Date: 2026-10-25
## Status: L0 Problem Statement

### Background
The Forward-Forward (FF) Algorithm (Hinton, 2022) replaces forward-backward propagation with layer-wise local training. Each layer is trained independently using a local goodness function. For a layer with hidden activations h = (h_1, ..., h_m), the goodness is G(h) = sum_i h_i^2. The local loss for layer l is:

L_l(theta_l) = -log(1 / (1 + exp(-G(h_l) + theta)))

where theta is a threshold. Positive data (real inputs) should produce G > theta (push up goodness), negative data (corrupted/wrong inputs) should produce G < theta (push down goodness). Each layer is trained greedily and independently — no gradient flows backward across layers.

### Five Claims

- C1 (PROVABLE): The FF local loss L_l is R_{an,exp}-definable. Goodness G = sum h_i^2 is polynomial. The log-sigmoid loss -log(sigmoid(G - theta)) is analytic on R. All compositions of polynomial, analytic, and exponential functions preserve R_{an,exp}-definability.

- C2 (CONJECTURAL): Each layer's local loss defines an independent singular fiber V_l = {theta_l : L_l(theta_l) = 0}, and because no gradient flows between layers, these fibers are decoupled — the composite loss landscape is a direct product of per-layer singular fibers, not a coupled composite singularity as in standard backprop-trained networks. The RLCT of the full network lambda_FF = max_l lambda_l (dominated by the worst layer), unlike standard networks where gradient coupling creates lambda_composite >= max_l lambda_l.

- C3 (CONJECTURAL): The threshold theta acts as a stratum selector. At theta = 0, positive and negative fibers are symmetric (high RLCT). Increasing theta separates the positive-data fiber (G >> theta) from the negative-data fiber (G << theta), creating a discriminant boundary at G = theta. Critical theta* marks a phase transition where the boundary crosses a singular stratum — analogous to #433 PolyLoss degree and #539 Focal Loss gamma as stratum selectors.

- C4 (CONJECTURAL): Generalization bound: L_gen^FF <= L_train + C * lambda_FF / n + B_FF / sqrt(n), where lambda_FF = max_l lambda_l (worst-layer-dominated) and B_FF includes a layer-independence bias B_indep = sum_l ||partial L/partial theta_l|| (accumulated local errors without gradient feedback). The lack of gradient coupling means each layer generalizes independently — no implicit regularization from gradient flow across layers.

- C5 (CONJECTURAL): Phase transition at critical network depth D*: below D*, layer-wise greedy training is sufficient (each layer's local fiber is well-separated); above D*, accumulated local errors cause the positive-data fiber to drift (G_l positive but G_{l+1} negative due to representation shift), and the network fails to maintain a coherent singular fiber across layers. This is testable via SGLD LLC estimation per layer: lambda_l should be roughly constant for l < D* but diverge for l > D*. Distinct from #169 (weight decay, global) and #371 (dropout, stochastic stratum).

### Distinctions from Prior Syntheses

- #8 (Cross-Entropy): Global loss with backprop coupling. FF replaces this with per-layer local loss — decoupled singular fibers.
- #16 (SGD): Gradient flows through entire network. FF has no backward pass — each layer's gradient is computed locally.
- #371 (Dropout): Stochastic stratum projection on forward pass. FF has deterministic forward pass but independent per-layer loss landscapes.
- #296 (Stochastic Depth): Randomly drops layers. FF keeps all layers but trains them independently.
- #364 (Early Exit): Multi-exit with shared backbone. FF has independent per-layer fibers, no shared backbone gradient.
- #434 (MoE): Routing creates piecewise expert assignment. FF creates piecewise per-layer training, but the pieces are layers, not experts.
- #201 (Meta-learning): Inner-loop adaptation composes singularities. FF prevents composition by decoupling layers entirely.

### Seven Open Problems

1. Is lambda_FF = max_l lambda_l, or does the greedy layer-wise training introduce implicit coupling through data distribution shifts (layer l changes the input distribution for layer l+1)?
2. Does the goodness function G = sum h_i^2 create a specific singularity type (quadratic form = non-degenerate critical point, or degenerate when h has repeated eigenvalues)?
3. Can SGLD LLC estimation distinguish FF-trained networks from backprop-trained networks on the same architecture?
4. Does the threshold theta create a non-smooth stratum boundary (log-sigmoid is smooth, but the decision G > theta vs G < theta is piecewise)?
5. Is the depth phase transition D* related to the RLCT of individual layers (D* ~ n^{1/(lambda_l + 1)})?
6. Does negative data generation method (Gaussian noise, label corruption, adversarial) create different singular fiber structures for the negative-data component?
7. Can the per-layer independence be exploited for parallel RLCT estimation (each layer's fiber computed independently)?

### Cross-References

#8 (cross-entropy) #16 (SGD) #58 (ReLU) #169 (weight decay) #201 (meta-learning) #258 (mixup) #296 (stochastic depth) #350 (SiLU) #353 (ELU) #364 (early exit) #371 (dropout) #433 (PolyLoss) #434 (MoE) #539 (focal loss) #555 (GELU) #609 (Sophia)

### Next Steps

- L1: Formal definitions D1-D7 (goodness function, local loss, per-layer singular fiber, threshold stratum selector, decoupled RLCT, layer-independence bias, depth phase transition)