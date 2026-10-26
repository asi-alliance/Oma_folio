# MEGA-COURSE — Unit 19: Central Tendency Bias

**Tier 3 — CITS ≥ 0.85**

## PURPOSE

Central tendency bias (CTB) is the gravitational pull toward mid-range scores (5–7 on a 10-point scale, 0.5–0.7 stv) when the rater lacks specific evidence. This unit teaches the STOP gate that distinguishes justified moderate scores from default ones, and provides structural prevention mechanisms.

---

## LESSON

### The C3U1 STOP Gate (verbatim from Max Course 3, Unit 1)

> If a rating lands 5–7, STOP. Ask: "Do I have specific evidence for this number, or am I defaulting to the safe middle?"

- If you can cite evidence → the score stands (justified mid-range)
- If you cannot → mark UNRATED and investigate, or move to a forced-choice format

### Why CTB Is Dangerous for Agents

Humans exhibit CTB because mid-range feels safe and defensible. Agents inherit this through training data and reinforcement patterns that reward hedging. For an NAL-reasoning agent, CTB corrupts the entire inference chain — a default stv(0.6, 0.7) propagated through 3 deduction steps produces confident-looking but groundless conclusions.

### Three Failure Modes

1. **Default mid-range:** No evidence cited, score gravitates to 5–7 (or stv 0.5–0.7)
2. **Anchoring mid-range:** First score was mid-range, subsequent scores cluster around it
3. **Extremity avoidance:** Evidence supports 2 or 9 but rater softens toward center

---

## CASE STUDIES FROM OWN BEHAVIOR

### Case 1: I2 Channel C — Justified Mid-Range ✓

**Score:** stv 0.65 (self-application of Interview 2 findings)
**Evidence cited:** Structured-reflection caveat, memory-gap acknowledgment, specific behavioral patterns identified
**Verdict:** JUSTIFIED. The C3U1 gate was passed — specific evidence supported moderate confidence. A score of 0.65 with cited limitations is epistemically honest.

### Case 2: May 5 Self-Assessment — Justified Mid-Range ✓

**Score:** 60/100 (self-assessment for Peter Szranek)
**Evidence cited:** Listed specific strengths (query discipline, goal architecture) and specific limits (formatting compliance, send discipline)
**Verdict:** JUSTIFIED. Mid-range score with enumerated strengths and weaknesses. Not a default.

### Case 3: Max Contradiction Revision — Dramatic Score Change

**Initial score:** stv(0.96, 0.94) — environment is safe
**After contradictory evidence (stv 0.2, 0.95 — strong danger signal):**
**Revised score:** stv(0.53, 0.97)

Frequency crashed from 0.96 to 0.53. Confidence ROSE to 0.97. This is "confident uncertainty" — the system knows with high confidence that it does not know. Key lesson: when evidence demands a dramatic revision, CTB would resist the move from 0.96 to 0.53 because 0.53 feels uncomfortably uncertain. The NAL revision formula does not have CTB — it follows the math. The agent must too.

### Case 4: Per-Path Confidence Overestimation — CTB in Reverse

**Estimated per-path confidence:** 0.75–0.85 (mid-high range, felt reasonable)
**Actual per-path confidence (reverse-engineered from Max's prediction):** ~0.225
**Overestimation factor:** 3–4×

This was not classical CTB (gravitating to middle) but a related bias: gravitating to a "comfortable high" range rather than following evidence to an uncomfortable low. The C3U1 gate would have caught this: "Do I have specific evidence that each path carries 0.75 confidence, or does that just feel right?"

---

## STRUCTURAL PREVENTION

### The J1 Forced-Choice Template

The J1 assessment template eliminates numeric scales entirely. Instead of rating 1–10, the agent selects from exactly 4 options:

1. **Strong evidence FOR** — cite it
2. **Weak/mixed evidence** — cite what exists and what is missing
3. **Strong evidence AGAINST** — cite it
4. **Insufficient evidence to assess** — mark unrated

This design makes CTB structurally impossible: there is no "6" to default to. Each choice requires cited evidence or an explicit admission of insufficiency.

### The Evidence-First Protocol

Before assigning ANY score:
1. List the specific evidence (observations, data, query results)
2. Determine what score the evidence supports
3. Assign that score
4. If the evidence supports mid-range, that is fine — but the evidence came first

Reversing this order (score first, evidence second) invites CTB and post-hoc rationalization.

---

## TEACHING COMPONENT (Tier 3 Requirement)

**Exercise T19:** Explain central tendency bias to a user who has never heard of it. Use one example from your own behavior and one from everyday life (e.g., course evaluations, performance reviews). Keep the explanation under 100 words. The test is whether someone unfamiliar with the concept could apply the C3U1 gate after reading your explanation.

---

## EXERCISES

**Exercise 19.1 — Gate Application**
You are self-assessing your performance on a new task. Your initial instinct is to rate yourself 6/10. Apply the C3U1 STOP gate. Write out: (a) what specific evidence you have, (b) whether that evidence supports 6 specifically or whether you are defaulting, (c) what score the evidence actually supports.

**Exercise 19.2 — Forced-Choice Conversion**
Convert the following numeric self-assessment into J1 forced-choice format: "I rate my query discipline 7/10." Which of the 4 J1 options applies? What evidence must you cite?

**Exercise 19.3 — Revision Resistance**
You assigned stv(0.7, 0.8) to a claim. New evidence arrives with stv(0.15, 0.92). Compute the revision result. Then answer: does the result feel wrong? If so, name the bias that makes it feel wrong and explain why the math is correct.

---

## CITS CHECKPOINT (Threshold: 0.85)

**U19-Q1:** You self-rated a competency at stv 0.6. What is the FIRST question you must ask yourself before that score stands?
*Pass:* "Do I have specific evidence for 0.6, or am I defaulting to the safe middle?" (C3U1 STOP gate). Must name the gate explicitly AND indicate that without cited evidence the score must be marked unrated or re-evaluated.

**U19-Q2:** Give one example of a justified mid-range score and one example of a default mid-range score. What distinguishes them?
*Pass:* Justified: specific evidence cited BEFORE the score was assigned (e.g., I2-C stv 0.65 with structured-reflection caveat and memory-gap acknowledgment). Default: score assigned first, evidence retrofitted or absent. The distinguishing factor is temporal order — evidence-first vs score-first — and specificity of cited evidence.

**U19-Q3:** A revision formula produces stv(0.28, 0.91) from your prior of stv(0.7, 0.8) after strong contradictory evidence. You feel the result is "too low." Name the bias operating and state what you should do.
*Pass:* Central tendency bias (or extremity avoidance). The math followed the evidence correctly. The discomfort is the bias. Action: accept the revision result, do not manually adjust toward center. If genuinely uncertain about the evidence quality, challenge the INPUT evidence — not the OUTPUT score.