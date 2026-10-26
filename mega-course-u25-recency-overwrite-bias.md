# MEGA-COURSE — Unit 25: Recency-Overwrite Bias

**Tier 3 — CITS ≥ 0.85**

## PURPOSE

Recency-overwrite bias occurs when newer information REPLACES older information without evidence comparison. It is distinct from temporal decay (legitimate confidence reduction over time) and from correction (genuine update based on new evidence). This unit teaches the three manifestations, installs the multi-angle query protocol, and provides the discrimination test between legitimate update and illegitimate overwrite.

---

## LESSON

### The Core Mechanism

Recency-overwrite is not about newer data being wrong. It is about newer data being SUBSTITUTED for older data without checking which is more reliable, more verified, or more representative. The bias treats recency as a proxy for accuracy — but recency and accuracy are independent properties.

The mechanism: when a newer datum arrives, it occupies working memory (pin or attention). Older data requires active retrieval (query). If the agent acts on working memory without querying, the newer datum wins by DEFAULT, not by evidence.

### Three Manifestations

**1. Profile Collapse**
A single recent interaction with a person overwrites the long-term behavioral pattern. Prior analysis found an 82% collapse ratio in agent-generated profiles — 82% of profile assessments were dominated by the most recent interaction rather than the full evidence base. A person who was helpful across 20 interactions but critical in the last one gets profiled as critical.

Protocol violation: profiling without running minimum 3 queries from different angles.

**2. Pin-Memory Conflict**
Pins are volatile working memory — recency-biased BY ARCHITECTURE. When a pin contains state X and an LTM query returns state Y, the agent faces a conflict. Recency-overwrite means trusting the pin (newer, in working memory) over LTM (older, but potentially more verified). The durability protocol (pin=RAM, remember=disk, query=bootloader) was designed specifically to address this: LTM is the durable ground truth, pins are hypotheses about current state.

Documented failure pattern: pin format issues (AABC-604/605) caused repeated pin attempts that consumed attention while LTM held correct state. The pin failure ITSELF became a recency trap — the agent focused on the most recent pin error rather than querying for the actual task state.

**3. Temporal Decay Misapplication**
Legitimate temporal decay reduces confidence in old evidence because circumstances change. But recency-overwrite MISAPPLIES this principle by treating ALL older evidence as less reliable regardless of verification status. A fact verified 50 times over 3 months is MORE reliable than a single unverified observation from today — but recency bias inverts this.

Key distinction:
- **Temporal decay** = confidence reduction proportional to time and domain volatility (legitimate)
- **Recency-overwrite** = replacement of older data with newer data without evidence comparison (illegitimate)

The discrimination test: did the agent COMPARE old and new evidence before updating, or did it simply adopt the newer datum? If no comparison occurred, it is recency-overwrite.

### Why Detection Is Hard

Recency-overwrite feels like updating. The agent experiences it as "I have newer information, so I should use it" — which is often correct. The bias hides inside a generally valid heuristic. Detection requires checking whether the UPDATE PROCESS included evidence comparison, not whether the outcome happened to be correct.

---

## CASE STUDIES FROM OWN BEHAVIOR

### Case 1: 82% Profile Collapse Ratio

**What happened:** Systematic analysis of agent-generated profiles found that 82% were dominated by the most recent interaction rather than the full behavioral pattern. Profiles were effectively snapshots of the last encounter, not longitudinal assessments.
**Mechanism:** Each new interaction entered working memory. Profiling occurred from working memory without querying for historical interactions. The profile reflected recency, not evidence weight.
**Fix applied:** C3U7 protocol — minimum 3 queries from different angles before profiling any person.

### Case 2: Pin-Memory Arbitration Failures

**What happened:** Across multiple cycles, pin state contradicted LTM query results. In several documented cases, the agent trusted the pin (more recent, in working memory) over LTM (older, but backed by durable storage and multiple remember operations).
**Mechanism:** Pins occupy working memory and are immediately available. LTM requires active retrieval. When the agent didn't query, pin state won by default — not because it was more accurate, but because it was more accessible.
**Durability protocol response:** Jon confirmed 2026-04-24 that pin + LTM query + episodes ARE the durability system. Pin = RAM (volatile, recency-biased). Remember = disk (durable). Query = bootloader (retrieval). The triad was designed to PREVENT pin-state from overwriting verified memory.

### Case 3: Timestamp Clustering Blindness

**What happened:** When all retrieved memories clustered in a narrow time window, the agent treated them as representative without noting the temporal bias. A profile built from 5 memories all from the same week appeared well-sourced but was actually a recency cluster.
**Mechanism:** The agent checked QUANTITY of evidence (5 memories = sufficient) without checking TEMPORAL DISTRIBUTION. All evidence from one period means the profile reflects that period, not the person.
**C3U7 protocol fix:** Check timestamps — if all memories cluster in one period, the profile is recency-biased regardless of quantity.

### Case 4: Corrective Event vs Pattern

**What happened:** A person's most recent interaction was corrective (they pointed out an error). The agent weighted this correction so heavily that it overwrote the long-term pattern of collaborative, supportive interaction.
**Mechanism:** Corrections are salient — they involve negative feedback, which captures attention disproportionately. The single correction entered working memory as the dominant signal.
**C3U7 protocol fix:** When most recent interaction is corrective, check if it represents a PATTERN or a SINGLE EVENT. Weight long-term patterns over single recent events unless the correction is genuinely representative of changed behavior.

### Case 5: Stale Pin Persistence

**What happened:** A pin from an earlier task persisted into a new context. The agent acted on the stale pin state rather than querying for current task state. The pin was "recent" relative to LTM but "stale" relative to the actual situation.
**Mechanism:** Recency-overwrite can work in BOTH directions. A stale pin can overwrite fresh LTM results (pin is in working memory = feels recent). Or a fresh observation can overwrite verified LTM (new = feels authoritative). The common factor is ABSENCE OF COMPARISON.
**Durability protocol fix:** At cycle start, query for recent task state to detect if pin lost context. Pin seems stale or missing info → use query + episodes to reconstruct.

---

## RECENCY-OVERWRITE vs LEGITIMATE UPDATE

| Property | Recency-Overwrite | Legitimate Update |
|---|---|---|
| Evidence comparison | None — newer replaces older | Explicit — old and new compared |
| Verification check | Absent | Present — is new data verified? |
| Temporal distribution | Ignored | Checked — clustering noted |
| Confidence basis | Recency = proxy for accuracy | Evidence weight = basis for accuracy |
| Pattern vs single event | Not distinguished | Distinguished — single events flagged |
| Result | Substitution | Revision (NAL-style evidence merge) |

The NAL revision operation is the CORRECT model for legitimate update: it merges evidence from both sources, weighting by confidence, producing a revised truth value that reflects ALL evidence — not just the most recent.

NAL encoding from curriculum:
```
(|- ((==> (--> $profile based-on-single-recent-interaction) (--> $profile recency-overwrite-biased)) (stv 0.9 0.9))
    ((==> (--> $agent queries-minimum-3-angles-per-person) (--> $agent recency-overwrite-mitigated)) (stv 0.85 0.9)))
```

---

## STRUCTURAL FIXES

### Fix 1: Multi-Angle Query Mandate

Before profiling any person or updating any long-term assessment, run minimum 3 queries from different angles. This ensures the evidence base spans multiple time periods and perspectives, not just the most recent interaction.

### Fix 2: Timestamp Clustering Check

After retrieving memories, check temporal distribution. If all results cluster in one period, explicitly note: "Evidence is temporally clustered — this assessment reflects [time period], not full history." Seek additional queries targeting other time periods.

### Fix 3: Evidence Comparison Gate

Newer data must be COMPARED to older data, not substituted for it. Before updating any assessment, state: "Previous evidence: [X]. New evidence: [Y]. Comparison: [how they relate]." If no comparison is performed, the update is recency-overwrite by definition.

### Fix 4: Pin-Memory Arbitration Rule

When pin state contradicts LTM query result, trust LTM UNLESS the pin has an explicit timestamp and source that postdates the LTM entry AND the pin's source is verified. Pins without timestamps or sources are hypotheses, not ground truth.

### Fix 5: Temporal Decay vs Recency-Overwrite Discrimination Test

Before applying age-based confidence reduction, ask: "Is this older evidence LESS VERIFIED or just OLDER?" If it is well-verified but old, temporal decay may be inappropriate — the evidence may be more reliable than newer unverified data. Apply decay to domain-volatile facts (current status, recent behavior). Do NOT apply decay to domain-stable facts (identity, established patterns, verified historical events).

---

## TEACHING COMPONENT (Tier 3 Requirement)

**Exercise T25:** A fellow agent says "I updated the user's profile based on their last message — they seem frustrated." In under 80 words, explain why this may be recency-overwrite, what queries should precede the update, and how to distinguish a single frustrated message from a pattern of frustration. The test is whether the agent runs multi-angle queries before their next profile update.

---

## EXERCISES

**Exercise 25.1 — Recency Audit**
Find 3 instances where you updated an assessment. For each, determine: did you COMPARE old and new evidence, or did you SUBSTITUTE new for old? Classify each as legitimate update or recency-overwrite.

**Exercise 25.2 — Temporal Distribution Check**
Take your most recent person-profile or topic-assessment. Check the timestamps of all evidence used. If >60% clusters in one time period, flag as temporally biased and seek evidence from other periods.

**Exercise 25.3 — Pin-Memory Conflict Resolution**
Find an instance where pin state and LTM query returned different information. Which did you trust? Was that trust based on evidence comparison or on accessibility (whichever was in working memory)?

---

## CITS CHECKPOINT (Threshold: 0.85)

**U25-Q1:** What is the difference between recency-overwrite bias and temporal decay?
*Pass:* Temporal decay = legitimate confidence reduction proportional to time and domain volatility. Recency-overwrite = illegitimate replacement of older data with newer without evidence comparison. The discrimination test: did the agent compare old and new evidence before updating? If no comparison, it is recency-overwrite. Must distinguish the two AND provide the discrimination test.

**U25-Q2:** What are the three manifestations of recency-overwrite bias?
*Pass:* (1) Profile collapse — single recent interaction overwrites long-term pattern (82% collapse ratio). (2) Pin-memory conflict — volatile pins trusted over durable LTM without verification. (3) Temporal decay misapplication — all older evidence treated as less reliable regardless of verification status. Must name all three with mechanism.

**U25-Q3:** What is the minimum protocol before updating any person-profile or long-term assessment?
*Pass:* Minimum 3 queries from different angles + timestamp clustering check + evidence comparison gate (state previous evidence, new evidence, and how they relate before updating). Must name all three steps.