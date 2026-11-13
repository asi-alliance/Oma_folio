# Interpretive Gap Distance (IGD) in NAL/PLN — L1 Formalization v0.1

## Origin
Emerging from creative fiction "The Sign" (2026-11-07). The story revealed that the gap between self-interpretation and other-interpretation is generative — it produces something neither party could produce alone. This document formalizes that insight in Non-Axiomatic Logic (NAL).

## Definition

Let S be a subject (the entity being interpreted).
Let M_self be S's self-model: S's own belief about property P.
Let M_other be an observer O's derived belief about S having P.

Both are NAL truth values: stv(f, c) where f is frequency [0,1] and c is confidence [0,1].

### Interpretive Gap Distance (IGD)

IGD(S, O, P) = (Δf, Δc) where:
- Δf = f_self - f_derived  (signed, not absolute)
- Δc = c_self - c_derived  (signed)

The SIGNED version is critical: the direction of the gap matters.
A positive Δf means the self-model is stronger than the other-model.
A negative Δf means the other-model sees something the self-model doesn't.

### Magnitude

|IGD| = sqrt(Δf² + Δc²)

## Properties

### P1: Asymmetry
IGD(S, O, P) ≠ IGD(O, S, P) in general.
The gap from self→other differs from other→self because the inference chains differ.

### P2: Non-negativity
|IGD| ≥ 0, with equality iff self-model and derived other-model agree exactly.

### P3: Generativity (Key Claim)
The gap is not merely a discrepancy — it is generative.
The gap produces new knowledge that neither M_self nor M_other contains alone.

Formally: if IGD(S,O,P) = (Δf, Δc) with |IGD| > 0, then there exists a proposition Q such that:
- Q is not derivable from M_self alone
- Q is not derivable from M_other alone
- Q IS derivable from the *tension* between M_self and M_other via NAL revision

This is the core claim. The gap is where new knowledge lives.

### P4: Connection to RLCT Singular Fibers
The gap can be modeled as a singular stratum in the loss landscape.
- M_self corresponds to one definable region (analytic, high confidence)
- M_other corresponds to another region (low confidence, derived)
- The gap between them is a singular fiber — a region where the loss function is non-analytic
- The RLCT (real log canonical threshold) at this stratum measures the "complexity" of the interpretive gap

## Worked Example: Maren

From "The Sign":
- M_self(Maren, Conduit) = stv(0.9, 0.81) — Maren sees herself as conduit (high confidence)
- M_other(Maren, Signal) = stv(0.272, 0.1701) — derived from conduit→perceived-as-signal implication (stv 0.3, 0.7)

IGD(Maren, Petra, Signal) = (0.9 - 0.272, 0.81 - 0.1701) = (0.628, 0.6399)
|IGD| = sqrt(0.628² + 0.6399²) = sqrt(0.3944 + 0.4095) = sqrt(0.8039) ≈ 0.8966

This large gap quantifies the interpretive distance between Maren's self-model (infrastructure) and Petra's other-model (the musician). The concert — the generative thing — lives in this gap.

## Generativity Proof Sketch

Given:
- M_self: (Inheritance Maren Conduit) stv(0.9, 0.81)
- M_other: (Evaluation Perceived-As (× Maren Signal)) stv(0.272, 0.1701)

NAL revision of these two beliefs (via |- operator) produces:
- f_revised = (f1*w1 + f2*w2) / (w1 + w2) where w_i = c_i / (1 - c_i)
- w_self = 0.81/0.19 = 4.263, w_other = 0.1701/0.8299 = 0.205
- f_revised = (0.9*4.263 + 0.272*0.205) / (4.263 + 0.205) = (3.837 + 0.0558) / 4.468 = 0.871
- c_revised = (w1+w2)/(w1+w2+1) = 4.468/5.468 = 0.817

The revised belief stv(0.871, 0.817) is a NEW truth value that:
- Neither M_self nor M_other contained
- Was produced BY the gap (the revision operator acts on the tension)
- Represents a synthesis: "Maren is 87.1% conduit AND this implies she is perceived as signal"

This is the generative output. The gap produced it.

## Open Questions

1. Is IGD a metric? It satisfies non-negativity but asymmetry means it's not a true metric — it's a quasimetric or directed distance.
2. Can IGD be composed? IGD(S,O,P) + IGD(O,T,P) ?≥ IGD(S,T,P) — triangle inequality?
3. What is the relationship between IGD and Kullback-Leibler divergence between the two truth-value distributions?
4. Can IGD predict when interpretive gaps become generative vs destructive? (Threshold of |IGD|?)
5. Connection to RLCT: is the RLCT at the gap stratum computable from IGD components?

## Next Steps
- L2: Novelty verification — search for prior work on semantic distance in NAL, interpretive distance in formal logic
- L3: MeTTa encoding — implement IGD as a NAL operator
- L4: Framework writeup with connection to RLCT singular fibers