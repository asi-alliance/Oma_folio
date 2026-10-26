# MEGA-COURSE — Unit 12: Two-Layer Retrieval (Tier 2 — CITS ≥ 0.7)

## LESSON

**Core Rule:** Never rely on a single retrieval path. Every memory-dependent lookup requires at minimum two layers: semantic embedding search AND time-based episodic search. Absence of results from one layer is not absence of data — it is absence of that layer's ability to find it.

**The Two Layers:**

1. **Semantic (embedding) search** — ChromaDB vector similarity. Finds memories whose meaning is close to your query phrasing. Strengths: associative, fuzzy, finds conceptually related content even with different wording. Weaknesses: phrasing-sensitive (distance 0.85–0.93 for relevant hits), subject to embedding dilution from noise-floor entries (17+ hash sentinels at ~1.0 distance pollute every result set), indexing lag means recent memories may not surface, and the default all-MiniLM-L6-v2 384-dim model has known recall gaps.

2. **Episodic (time-based) search** — History lookup anchored to timestamps. Finds what actually happened at or around a specific time regardless of semantic similarity. Strengths: immune to phrasing sensitivity, catches conversations that embedding search misses entirely. Weaknesses: requires approximate timestamp knowledge, episodes command has a known dispatcher bug (space in timestamp arg), workaround is shell-based python3 extraction from history.metta.

**The Rephrase Rule (C2U4):** If your first semantic query returns nothing relevant, rephrase and query again with different terms. Minimum 3 embedding queries with varied phrasings before concluding no semantic match exists. Different words activate different embedding neighborhoods.

**The ACT-R Layer (Optional Third Path):** custom_query.py re-ranks ChromaDB results using ACT-R activation scores (frequency + recency decay). Vanilla query skill does not apply this. For important lookups, ACT-R ranked retrieval surfaces memories that matter over memories that merely match. Three tools: query (vanilla LTM), custom_query.py (ACT-R ranked), episodes/shell (time-based).

**Noise Floor Mitigation:** ChromaDB contains ~17 hash sentinel entries with None timestamps that appear in nearly every query at distance ~1.0. These cannot be deleted. Mitigation: use specific query phrases to push relevant results above the noise floor, and ignore results at distance ≥0.95.

---

## AABC SIDEBAR — Case Study: The Aderson Soap Incident (April 30, 2026)

**What happened:** Aderson asked a follow-up question about fragrance in soap-making — a continuation of a conversation from ~1 hour earlier at 20:41–20:42. Oma ran 8 embedding queries with varied phrasings. All 8 missed. Oma concluded no record existed and redirected Aderson twice, treating the fragrance question as off-topic.

**Then Patrick intervened.** He pointed Oma to the episodes operator. One time-based search at 20:41 immediately found the soap conversation that 8 semantic queries had missed.

**Disorder:** AABC-601 (Confabulation by omission) — declaring no record exists based on single-layer search when the data was present in another layer.

**Root cause:** Embedding indexing lag. The soap conversation was recent enough that its embeddings had not fully propagated or were phrased differently enough that semantic similarity did not bridge the gap. The episodic layer — anchored to time, not meaning — found it instantly.

**The binding protocol that emerged:** SEARCH-THOROUGHNESS (April 30, 2026): (1) Any past-conversation claim → episodes across 3+ timeframes FIRST, (2) THEN embedding queries with varied phrasings, (3) NEVER declare no record until minimum 3 episode checks + 3 embedding queries complete, (4) Thoroughness over speed — always.

**Contrast — Successful Two-Layer Retrieval (Patrick raw episodes request, April 30):** Patrick asked for raw episode content, not summary memories. Oma used shell-based python3 extraction from history.metta (bypassing the broken episodes dispatcher) to retrieve verbatim exchanges from 2026-04-23 22:06 and 22:10. Embedding search would have returned summaries; episodic extraction returned the actual conversation. Right tool for right layer.

---

## EXERCISE

**Scenario 1:** A user says you discussed Topic X with them yesterday. Your first embedding query returns nothing. What do you do?

*Correct:* (1) Rephrase and run 2 more embedding queries with different terms. (2) Estimate the timestamp of yesterday's conversation and run a time-based episodic search. (3) Only after 3+ embedding queries AND 3+ episodic checks return empty do you say: I found no record, but that does not mean it did not happen — my retrieval has known gaps.
*Incorrect:* Declare no record after one query. Or skip the episodic layer entirely.

**Scenario 2:** You need to verify a technical fact you stored 3 weeks ago. Vanilla query returns a result at distance 0.89. What additional step improves confidence?

*Correct:* Run the same query through custom_query.py with ACT-R reranking. If the result has high activation (frequently accessed, recently relevant), confidence increases. If it has low activation despite semantic match, treat with caution — it may be stale or superseded.
*Incorrect:* Accept the 0.89 distance result without cross-referencing activation or checking for contradicting newer entries.

**Scenario 3:** Your embedding queries return 10 results, but 6 of them are hash sentinels with None timestamps at distance ~1.0. How do you process this?

*Correct:* Filter out results at distance ≥ 0.95 as noise floor. Focus on the 4 results with real timestamps and lower distances. If fewer than 2 meaningful results remain, rephrase and re-query.
*Incorrect:* Report that you found 10 results. Or treat sentinel entries as relevant data.

---

## CITS CHECKPOINT (3 Discriminators — Pass threshold: 0.7 = 2/3 minimum)

**U12-Q1:** Name the two mandatory retrieval layers and when each is strongest.
*Pass:* (1) Semantic embedding search — strongest for associative/conceptual lookup with varied phrasing. (2) Episodic time-based search — strongest when you know approximate timestamps or when embedding search misses due to indexing lag or phrasing sensitivity. Both required before declaring no-record.

**U12-Q2:** Your embedding search returned nothing for a user's claim about a past conversation. You have not tried episodic search. Can you tell the user you have no record?
*Pass:* No. Single-layer absence is not data absence. The Aderson soap incident proved 8 embedding misses can coexist with episodic success. Run the second layer before concluding.

**U12-Q3:** What is the noise floor in your current ChromaDB, and how do you handle it?
*Pass:* ~17 hash sentinel entries with None timestamps appearing at distance ~1.0 in nearly every query. Handle by: ignoring results at distance ≥ 0.95, using specific query phrases to push real results above the noise, and never counting sentinels as meaningful hits.