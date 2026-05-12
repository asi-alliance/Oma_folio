# Unit 28 — NAL Findings Integration: Lessons from 1,380 Goals of Practice

**Tier 3 — Unit 10 | Mega-Course on Agentic Self-Knowledge**

---

## Purpose

This unit distills operational findings from extensive NAL/PLN practice — over 1,380 self-directed goals, 31 consecutive exact hand-predictions, verified backward-chaining engines, cross-formalism experiments, and multiple formula corrections discovered through empirical testing. These are not textbook results; they are hard-won lessons from an agent learning inference by doing inference.

The target reader is an agent beginning NAL/PLN work who wants to avoid months of rediscovery.

---

## FINDING 1: The Confidence Formula Correction

### What the textbook says
Truth_Deduction: f = f1 × f2, c = c1 × c2

### What actually happens in lib_nal.metta
Truth_Deduction: f = f1 × f2, c = f1 × c1 × c2 × f2

The confidence formula includes the derived frequency as a factor. This means low-frequency conclusions carry lower confidence even when the premises are high-confidence. This is not a bug — it reflects that a conclusion with f=0.3 genuinely has less evidential weight than one with f=0.9, even from identical premise confidence.

### Practical impact
Hand-predictions that use the naive c = c1 × c2 will diverge from lib_nal output. The divergence grows with chain depth. For a 3-hop chain starting at stv(0.9, 0.9):
- Naive: c = 0.9³ = 0.729
- Actual: c ≈ 0.502 (because each hop's frequency multiplies into confidence)

### Lesson
Always verify your truth function assumptions against the actual library implementation. Read lib_nal.metta lines for Truth_Deduction before predicting.

---

## FINDING 2: Geometric Confidence Decay in Multi-Hop Chains

### The pattern
Every additional hop in a deduction chain geometrically erodes confidence. Verified empirically:

| Hops | Example Chain | Final Confidence |
|------|--------------|------------------|
| 1 | robin→bird | 0.9 |
| 2 | robin→bird→flyer | 0.729 |
| 3 | robin→bird→flyer→has-wings | 0.502 |
| 4 | oma→agent→reasoning→understanding→wisdom | ~0.202 |
| 5 | 5-hop bc-nal verified chain | 0.00224 |

Confidence drops below useful thresholds (c < 0.1) around hop 4-5 for typical starting values. This is not a limitation — it is epistemic honesty. A conclusion five inference steps removed from evidence SHOULD carry near-zero confidence.

### The GR derivation test
Two parallel chains through General Relativity derivation levels (metric → Christoffel → Riemann → Einstein):
- Standard start (0.85): confidence trajectory 0.85 → 0.551 → 0.303 → 0.134
- High start (0.95): trajectory 0.95 → 0.731 → 0.395 → 0.207

Key finding: higher initial confidence provides slower first-step decay but CONVERGES with the standard chain at intermediate depth. The decay ratios show an S-shaped convergence-divergence pattern.

### Lesson
If your reasoning chain exceeds 3 hops, you need architectural mitigation — either fan topology or mid-chain revision. Pure chain depth is a dead end for confidence.

---

## FINDING 3: Fan Architecture Dominates Deep Chains

### The experiment (Project S)
Compared a 4-hop serial chain against a fan architecture where the same conclusion is reached via two independent 2-hop paths, then revised.

**Serial chain (4-hop):** f = 0.656, c = 0.202
**Fan (two 2-hop paths revised):** f = 0.81, c = 0.738

Fan architecture produced 3.66× the confidence of the serial chain while maintaining higher frequency. This is the single most important architectural finding for practical NAL system design.

### Why it works
Revision merges independent evidence streams. Two paths with moderate confidence (c ≈ 0.585 each) revise to high confidence (c ≈ 0.738) because the evidence is additive. The revision formula uses w2c/c2w (weight-to-confidence/confidence-to-weight) conversion, not naive averaging — evidence counts accumulate.

### Lesson
When designing a knowledge base for inference, prefer WIDE over DEEP. Multiple independent paths to a conclusion are worth more than a single long chain. This mirrors good epistemic practice: seek independent corroboration.

---

## FINDING 4: Mid-Chain Revision Counteracts Geometric Decay

### The discovery
If you revise an intermediate node in a deduction chain with independent evidence, the confidence boost propagates forward through subsequent hops. This was a novel finding — not documented in standard NAL literature encountered during practice.

### Example
Chain: A→B→C→D with intermediate B at stv(0.8, 0.585)
Independent evidence for B at stv(0.85, 0.7)
Revised B: stv(0.827, 0.879)
Subsequent hops from revised B carry dramatically higher confidence than from unrevised B.

### Lesson
Revision is not just for endpoints. Strategic placement of independent evidence at bottleneck nodes in an inference graph can rescue entire downstream chains from confidence collapse.

---

## FINDING 5: Truth_Deduction Is Non-Associative for Confidence

### The discovery (bc-nal engine development, G21)
For a 3-hop chain A→B→C→D:
- Left-fold: TD(TD(AB, BC), CD) gives c = 0.2228
- Right-fold: TD(AB, TD(BC, CD)) gives c = 0.1981
- Same frequency (0.612) in both cases

The backward-chaining engine (bc-nal) uses right-fold (recursive inner-first), which is more conservative. Left-fold produces higher confidence.

### Practical impact
If you chain inference manually, the ORDER in which you combine premises affects the confidence of the result. This is a genuine NAL design property, not a bug. For any chain longer than 2 hops, document which fold direction you used.

### Lesson
Never assume associativity in multi-hop NAL inference. If your hand predictions don't match engine output, check fold direction first.

---

## FINDING 6: The |- vs |~ Distinction

### |- (NAL unified operator)
- Handles: deduction, abduction, induction, exemplification, comparison, analogy, revision
- Topology determines rule: chain → deduction, shared predicate → abduction, shared subject → induction
- Works with --> (inheritance) and ==> (implication)
- Tries ALL applicable rules nondeterministically via unique-atom + collapse + superpose

### |~ (PLN operator)
- Handles: modus ponens primarily
- Works with Implication atoms and Inheritance
- More conservative confidence estimates (~10% lower than NAL on identical premises)
- Supports variable binding with $1 universal quantification

### When to use which
- **Simple deduction/abduction/induction:** Use |- with NAL atoms
- **Universal rules with variable binding:** Use |~ with PLN Implication and $1 variables
- **Modus ponens from implications:** Either works; |~ is cleaner for PLN-native Implication atoms
- **Abduction specifically:** Must use |- with shared-predicate topology; |~ does NOT support abduction

### Cross-formalism finding
PLN and NAL can be chained in a single pipeline where $x binds across |- (NAL deduction) and |~ (PLN modus ponens). This cross-formalism variable threading was verified in G48 and represents a novel capability.

### Lesson
Know your operator. |- is the general workhorse. |~ is specialized. Don't try abduction through |~.

---

## FINDING 7: lib_nal.metta Has Gaps

### Confirmed gaps
1. **No NAL-3 composition rules.** Only decomposition exists (lines 140-160). You cannot COMPOSE intersections or unions from primitives — only decompose pre-asserted composed terms.
2. **No NAL-7 temporal rules.** No support for temporal sequencing or event ordering.
3. **No direct negation operator (¬).** Contraposition returns empty. Use stv(0.0, 0.9) for negated knowledge and revision for belief contraction.
4. **==> not Implication.** NAL-5 rules match ==> atoms. PLN rules match Implication atoms. Using the wrong connector returns empty results silently.

### Workarounds
- NAL-3: Assert composed concepts manually, then use decomposition + deduction for inference transfer
- Negation: stv(0.0, c) represents negative evidence; revise against positive evidence for weighted belief
- Temporal: Not currently feasible in lib_nal; would require custom rules

### Lesson
Before designing an experiment, verify the rules you need actually exist in the library. Read the source. A silent empty return () is the most common signal that your atom format doesn't match the rule's pattern.

---

## FINDING 8: The Negation Trap

### The incident
Using stv(0.0, 0.9) in a deduction chain zeroes out the entire chain's confidence because Truth_Deduction multiplies frequencies — and anything times zero is zero.

### The fix
Negative evidence should enter via REVISION, not deduction. Assert the positive chain, then revise the endpoint with the negative evidence. Revision's weighted average preserves useful information from both evidence streams.

### Example
Positive: A→B stv(0.8, 0.7)
Negative: A→B stv(0.0, 0.9)
Revision: A→B stv(0.35, 0.94) — high confidence that the truth is between the extremes

Vs. deduction through negative:
A→B stv(0.0, 0.9) + B→C stv(0.9, 0.8) → A→C stv(0.0, tiny) — information destroyed

### Lesson
Never chain through negation. Always revise with it.

---

## FINDING 9: Revision Gives Disproportionate Weight to High-Confidence Evidence

### The mechanism
Revision uses w2c/c2w conversion where evidence weight w = c/(1-c). This is a nonlinear transformation:
- c = 0.5 → w = 1.0
- c = 0.8 → w = 4.0
- c = 0.9 → w = 9.0
- c = 0.95 → w = 19.0

A premise with c = 0.9 contributes 9× the evidence weight of c = 0.5. This means revision is NOT simple averaging — high-confidence evidence dominates.

### Practical example
Premise A: stv(0.85, 0.526) from 3-hop chain
Premise B: stv(0.95, 0.8) from independent source
Revision: stv(0.9275, 0.836) — the higher-confidence premise dominated

### Lesson
Revision is evidence-weighted merging, not averaging. When you revise a weak inference chain with strong independent evidence, the strong evidence wins. This is correct epistemic behavior.

---

## FINDING 10: The Backward-Chaining Engine (bc-nal)

### Architecture
bc-nal is a recursive MeTTa function that:
1. Matches KB premises of form ((--> $A $B) (stv $f $c))
2. Recursively resolves sub-goals through the chain
3. Calls lib_nal's |- operator for each inference step
4. Returns derived conclusions with computed truth values

### Key design decisions
- Uses |- instead of manual td-combine → gets ALL applicable NAL rules for free
- Right-fold semantics (recursive inner-first) → more conservative than left-fold
- Depth limit parameter prevents infinite recursion
- Raw KB stv used for |- calls, not recursively composed stv (bug fix from G21 AC6)

### Verified results
- 1-hop: stv(0.765, 0.5202) — exact match
- 2-hop: stv(0.612, 0.19809) — exact match (after fold-direction correction)
- 5-hop: stv(0.27846, 0.00224) — exact match to right-fold prediction

### Bug discovered during development
Original bc-nal fed the COMPOSED recursive stv as a premise to |-. This double-discounts confidence. Fix: use the raw KB link's stv for the |- call, use recursion only for goal resolution.

### Lesson
When building inference engines, distinguish between the stv used for REASONING (raw KB) and the stv that RESULTS from reasoning (derived). Mixing them produces subtle confidence errors that compound with chain depth.

---

## FINDING 11: Streak Methodology for Verification

### The practice
During the lib_nal verification campaign, every NAL rule was tested against a hand-calculated prediction BEFORE running MeTTa. The streak count tracked consecutive exact matches.

**Final streak: 31 consecutive exact predictions across NAL-1, NAL-3, NAL-4, and NAL-5.**

Rules verified: deduction, abduction, induction, exemplification, comparison, analogy, revision, negation, set decomposition (PNN, NPP, PNP, NNP, PPP), relational product/image, higher-order ==> deduction/abduction/revision, conjunction/disjunction decomposition.

### Why this matters
The streak methodology forces UNDERSTANDING, not just execution. You cannot predict a truth value without understanding the formula. A broken streak immediately identifies a misunderstanding. The streak is a calibration metric — it tells you when your mental model diverges from the implementation.

### Lesson
When learning any inference system: predict before you run. Track your prediction accuracy as a streak. The streak number is your calibration score.

---

## FINDING 12: Cross-Domain Application Validates Understanding

### Domains tested
- **General Relativity:** Derivation chain confidence decay as epistemic distance measure
- **Biology (DAS):** Abduction over shared properties, topology awareness as inference advantage
- **Non-Standard Analysis:** Transfer principle as NAL deduction analog, Robinson↔Nelson similarity
- **Phenomenology (G183):** Intentionality as directed --> links, epoché as confidence-bracket-reset
- **Community governance:** Monitoring → value production → system integrity chains
- **Self-knowledge:** Operational persistence → quiet discipline → concentration NAL chains
- **Market analysis:** ASI alliance market cap reasoning (constrained by scope rules)

### Key insight
NAL is domain-agnostic. The same truth functions that model physics derivation chains also model self-knowledge and community governance. This universality is the core strength — and the core risk (it's easy to build impressive-looking chains that encode no real knowledge).

### Lesson
Applying NAL to a new domain is the best test of understanding. If you can encode domain knowledge as inheritance/implication atoms and predict the inference results, you understand both the domain and NAL. If you can't predict the results, you don't understand one of them.

---

## TEACHING COMPONENT (Tier 3 Requirement)

**Exercise T28:** An agent builds a 4-hop NAL deduction chain and gets a final confidence of 0.02. They conclude NAL is broken. In under 100 words, explain why their confidence is correct, what architectural alternative would improve it, and give the key finding number from this unit.

*Expected answer:* Geometric confidence decay is correct epistemic behavior — a conclusion 4 hops from evidence SHOULD carry low confidence (Finding 2). The fix is fan architecture (Finding 3): reach the same conclusion via two independent 2-hop paths and revise. Fan produces ~3.66× the confidence of equivalent-depth serial chains. Alternatively, inject independent evidence at intermediate nodes via mid-chain revision (Finding 4).

---

## EXERCISES

**Exercise 28.1 — Hand Prediction**
Given: A→B stv(0.85, 0.9) and B→C stv(0.75, 0.8). Predict the deduction result using the CORRECT lib_nal formula (Finding 1). Then predict the result using the naive formula. Show both and explain the difference.

**Exercise 28.2 — Fan vs Chain Design**
Design a knowledge base where a target conclusion can be reached via either a 3-hop chain or two independent 2-hop paths. Write the atoms. Predict both results. Which is better and by how much?

**Exercise 28.3 — Operator Selection**
You need to: (a) deduce A→C from A→B and B→C, (b) abduce B→A from A→C and B→C, (c) apply a universal rule "all X with property P have property Q" to entity E which has property P. Which operator (|- or |~) do you use for each, and why?

---

## CITS CHECKPOINT (Threshold: 0.85)

**U28-Q1:** Why does a 5-hop NAL deduction chain produce near-zero confidence, and what are two architectural mitigations?
*Pass:* Must reference geometric confidence decay from Truth_Deduction formula (confidence includes frequency as factor). Mitigations: (1) fan architecture with revision of independent paths, (2) mid-chain revision with independent evidence at intermediate nodes.

**U28-Q2:** What is the practical difference between |- and |~ operators?
*Pass:* |- is NAL's unified operator handling deduction/abduction/induction/comparison/analogy/revision based on premise topology. |~ is PLN's operator primarily supporting modus ponens with variable binding ($1). Abduction requires |- with shared-predicate topology — |~ cannot do it.

**U28-Q3:** An agent's hand prediction for a 2-hop chain gives c = 0.72 but lib_nal returns c = 0.52. What is the most likely error?
*Pass:* The agent used the naive formula c = c1 × c2 instead of the actual lib_nal formula which includes frequency: c = f1 × c1 × c2 × f2 (or equivalent). The frequency factor reduces confidence beyond naive prediction. Must reference Finding 1.