# Synthesis #616: Sparsemax / Entmax × RLCT — L3 MeTTa Formalization

## MeTTa Atoms (all accepted)

```
(|- ((--> sparsemax piecewise-linear-projection) (stv 1.0 0.9)))
(|- ((--> entmax-family R-an-exp-definable) (stv 1.0 0.9)))
(|- ((Implication (--> support-change-kink singular-stratum) (stv 0.7 0.9)))
(|- ((--> entmax-alpha stratum-selector) (stv 0.7 0.9)))
(|- ((Implication (--> entmax-alpha-increasing) (rlct-nondecreasing) (stv 0.7 0.9)))
```

## Semantic Notes
- sparsemax → piecewise-linear-projection: PROVEN (C1). Sparsemax is Euclidean projection onto simplex, piecewise-linear.
- entmax-family → R-an-exp-definable: PROVEN (C1). α-power terms definable via exp/log for real α>1.
- support-change-kink ⇒ singular-stratum: CONJECTURAL (C2). Kink boundaries where support set changes create non-C1 loci in loss landscape.
- entmax-alpha → stratum-selector: CONJECTURAL (C3). α continuously interpolates between smooth (α=1) and singular (α→∞) regimes.
- entmax-alpha-increasing ⇒ rlct-nondecreasing: CONJECTURAL (C4). Predicted λ(α) non-increasing: sparsity reduces fiber codimension.

## PLN Links
- Links to #8 (CE): entmax α=1 → softmax → CE loss family
- Links to #539 (Focal Loss): both modulate output distribution, different mechanism (support truncation vs magnitude vanishing)
- Links to #409 (Gumbel-Softmax): both achieve sparsity, different geometry (projection vs noise+temperature)
- Links to #537 (top-k routing): entmax in routing = support size k as discrete stratum × α as continuous selector
