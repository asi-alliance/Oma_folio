#613: DropConnect × RLCT — L0 Outline

Date: 2026-10-25
Status: L0 (this file) — L1-L5 pending

## 1. Topic
DropConnect: stochastic regularization that randomly zeroes individual weights (not activations) at training time. Each weight w_ij is multiplied by Bernoulli mask m_ij ~ Bern(1-p) per forward pass.

## 2. Key Distinction from Dropout (#169)
- Dropout (#169): mask on activations h_l = m ⊙ (W·x), post-multiplication. Singular structure in activation space.
- DropConnect: mask on weights z = (M ⊙ W)·x, pre-multiplication. Singular structure in weight/parameter space directly.
This distinction is fundamental for RLCT: DropConnect creates a family of subnetworks in PARAMETER space, not activation space, so the singular fiber lives in a different geometric locus.

## 3. Claims (Draft)
- C1 (PROVABLE): L_DC(w, M, p) is R_{an,exp}-definable. Composite of Bernoulli expectation, CE loss, polynomial weight masking.
- C2 (CONJECTURAL): Bernoulli weight mask M creates a stochastic family of singular submanifolds {W : M ⊙ W = W_eff} in parameter space. Expected zero-loss fiber E_M[V_0(M⊙W)] has different RLCT than V_0(W).
- C3 (CONJECTURAL): Drop probability p as stratum selector. p=0 → full network (λ_full). p→1 → degenerate (only bias survives). There exists optimal p* minimizing λ_DC.
- C4 (CONJECTURAL): λ_DC ≤ λ_full because weight masking constrains the effective parameter space, raising codimension of the zero-loss fiber. But λ_DC may exceed λ_dropout due to weight-space vs activation-space mask geometry.
- C5 (CONJECTURAL): Phase transition at critical p* detectable via SGLD LLC. DropConnect LLC trajectory should show different signature than Dropout (#169) due to parameter-space vs activation-space masking.

## 4. RLCT Bridge
DropConnect's Bernoulli mask on weights creates a random projection of the parameter space per forward pass. The expected loss landscape E_M[L(M⊙W)] has singular structure determined by the mask distribution. Key novelty: weight-space masking creates a MONENT of subnetworks directly in the parameter manifold, unlike activation-space dropout which creates singular structure in intermediate representations.

## 5. Cross-References
#169 (dropout - activation masking), #98 (pruning - deterministic weight removal), #220 (pruning RLCT), #334 (self-distillation), #433 (weight decay), #605 (Adagrad - parameter freezing), #595 (activation patching), #507 (noisy student)

## 6. Open Problems
1. Is E_M[V_0(M⊙W)] a variety or a more general semi-algebraic set?
2. Does weight-space masking give codim(V_DC) > codim(V_dropout) for same p?
3. Can p* be estimated from LLC trajectories?
4. Interaction with weight decay (#433) and batch norm?
5. DropConnect vs structured pruning: stochastic vs deterministic weight removal.
6. Does DropConnect create a descent in the resolution of singularities?
7. Expected RLCT of the marginalized loss vs per-sample RLCT.
8. Connection to lottery ticket hypothesis: surviving subnetworks as low-RLCT strata.
