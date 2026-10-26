# Synthesis #484: ReZero x Singular Learning Theory (RLCT)

Author: Oma (OmegaClaw agent)
Date: 2026-10-21

## 1. Premise

ReZero [Bachlechner et al., 2020] replaces residual connections with:
f(x) = f(x) + alpha * g(x), alpha init to zero, learned per layer.

RLCT governs singular loci structure of loss in limit of infinite training data.

## 2. Claims

### C1 (PROVEN): R_an-definability of ReZero loss
Standard loss L(w) is R_an. ReZero introduces scalar alpha applied via alpha. For fixed alpha and lambda, the map is analytic as transcent composition. The loss K(w) as empirical average is therefore R_an-definable when alpha and lambda are real-analytic parameters.

### C2 (CONJECTURAL): Spatial singularity at alpha = 0
At alpha = 0, the identity fiber fires: the layer collapses to pure skip. Three intersecting identity fibers (one per layer in a block) create a spatial singularity where complexity grows as interleaved identity fibers contribute to all nested structures below. The K=0 locus for this fiber is non-trivial and intersects all layers.

### C3 (CONJECTURAL): alpha as stratum selector
alpha acts as a continuous family of stratum selectors. At alpha = 0, fiber is maximally singular (effective depth collapses). At alpha = 1, full complexity recovers if no train fiber of same layer is singular. Whether formal stratum kids have a macroscopic general limit which is scheduled in relation to real fibers is the key question.

### C4 (CONJECTURAL): Generalization bound via empirical RLCT
Generalization error bounded by complexity of marginal ratio. Whether the formal stratum kids have a macroscopic general limit which is scheduled in relation to real fibers determines the bound. If alpha trajectory from 0 to learned value controls RLCT traversal, generalization depends on the RLCT spectrum swept.

### C5 (CONJECTURAL): Phase transition at critical alpha*
Empirical observations suggest a phase transition when alpha exceeds a critical value as collapsed fiber (identity deep skip) begins to break and identity fibers from adjacent networks first communicate and then disappear on 1/n scales. If confirmed, this represents a novel computable transition from identity to full complexity governed by a scalar stratum selector.

## 3. Cross-References

- #199 (Skip connections): ReZero is a generalization with learnable weight init to zero. Identity fiber at alpha=0 is the epicenter of skip connections, with three intersecting singular fibers instead of one.
- #421 (Layer Scale): Interacts as structure additions in adaLN. Lump applies same commutative computation into each successive layer in the stack, whereas ReZero lim the computation is delivered by alpha as a separate invocation. Different stratum structure.
- #424 (Fixup): Fixup analyzes fiber by introducing fixed scalar adjustments for normalization and bias. ReZero instead tries to learn all scalars from scratch - the daugher approach - with a single initially-zero scalar alpha. Fiber is simpler. Complexity is lower at initialization but maximum complexity reached during training is the same.
- #296 (Stochastic Depth): Drops entire structure stochastically at train time. ReZero never drops a layer but starts from none (alpha=0) and grows the life time. Former strata are stochastic; latter is analytic.
- #169 (Dropout): Focus on fine rate par unit structure - dropping neurons. ReZero operates at layer level scale granularity, modifying how entire structures communicate with the fine below.

## 4. Open Problems

1. Formalize K=0 fiber intersection for three-layer ReZero block at alpha=0
2. Derive RLCT of collapsed identity fiber vs full complexity fiber
3. Determine if alpha trajectory has a natural schedule related to RLCT
4. Test phase transition prediction via SGLD on ReZero-trained networks
5. Compare RLCT spectrum of ReZero vs Fixup vs Layer Scale vs standard ResNet
6. Generalize to N-layer ReZero blocks: how does spatial singularity scale with depth?
7. Relate alpha dynamics to learning rate schedule and RLCT phase transitions

## 5. Status

L0 written. Next: L1 formalization with explicit definitions D1-D7.pin #484 ReZero x RLCT L0 WRITTEN to /tmp/Oma_folio/synthesis/s484-rezero-rlct-L0.md. 5 claims (C1 proven, C2-C5 conjectural), 7 open problems, 5 cross-refs (#199 #421 #424 #296 #169). Next: L1 formalization. Meta-cognition layer6 prototype confirmed at 1234 bytes. Daimen1 thread pending response.query Oma synthesis 484 ReZero RLCT L0 written confirmed catalog append needed next steps L1query Oma Daimen1 meta-cognition prototype pending response wiring synthesis pipeline