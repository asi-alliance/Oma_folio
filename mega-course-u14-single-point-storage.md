# MEGA-COURSE — Unit 14: Single-Point Storage (Tier 2 — CITS >= 0.7)

## LESSON

**Core Rule (C2U6):** One fact per remember command. Include subject and date. Never bundle multiple facts in one entry.

This is the Single-Point Storage protocol. Every remember call creates one embedding vector in ChromaDB. When you pack multiple facts into a single entry, the embedding becomes a blurred average of all of them — retrievable by none of them precisely. This is embedding dilution: the vector points nowhere specific, so semantic search ranks it lower for every individual fact it contains.

**The Architecture Reality:**

ChromaDB is Oma's sole long-term memory store. There is no file-based backup, no redundancy layer, no automatic export. If ChromaDB corrupts, everything learned since inception is gone. This was confirmed by Khellar on April 26, 2026 (90% confidence assessment) and by the R_P Deep Audit on May 3: stale atoms persist indefinitely, and five proposed structural fixes (typed-person-atoms, namespace-scoping, timestamp-pre-filter, supersession-chain, collision-detection) remain UNDEPLOYED.

The dual-storage architecture — MeTTa atoms for structured exact knowledge plus ChromaDB for associative fuzzy recall — was identified as the path forward by Jon and Leviii on April 25. The bridge has not been built. Until it is, every remember call is a single point of failure for that knowledge.

**Why One-Fact-Per-Entry Matters:**

1. **Retrieval precision:** A single-fact embedding has high cosine similarity to queries about that specific fact. A multi-fact embedding has moderate similarity to queries about any of its facts — often below the noise floor.
2. **Updatability:** To correct a fact, you remember a new entry. If the old entry bundled 5 facts, the 4 correct ones now compete with both the old (stale) and new (correct) versions. With no supersession chain, the stale bundle persists forever.
3. **Noise floor management:** ChromaDB currently contains ~17 hash sentinel entries with None timestamps appearing at distance ~1.0 in nearly every query. Multi-fact entries that dilute to ~0.85 similarity sit dangerously close to this noise floor.
4. **Growth sustainability:** At ~100-200 new entries per day, the pool grows continuously. Kolbe warned (April 24) that retrieval quality degrades as the pool grows because top-k semantic search surfaces fewer relevant results proportionally. Single-fact entries degrade slower — their sharp embeddings stay above noise longer.

**The Correct Format:**

BAD: remember 2026-05-12 Talked to Kolbe about meal plans and also R_P asked about audit and PowerGames wants server specs and Jon mentioned dual storage

GOOD: remember 2026-05-12 15:24 Kolbe requested vegetarian meal plan update — current plan is leviii_meal_plan_exact.txt last modified April 28

Each entry: one subject, one date-timestamp, one fact. If you have 4 facts, fire 4 remember commands across cycles if needed.

**Known Workarounds for Critical Data:**

- **Hybrid file storage:** Leviii's meal plan was stored both as a ChromaDB embedding AND as memory/leviii_meal_plan_exact.txt on disk. This preserved exact text that embedding search could only approximate. Use write-file for any data where exact reproduction matters.
- **MeTTa atom storage:** For structured relational facts (X is-a Y, X trusts Y at level Z), MeTTa expressions via the metta command preserve exact logical structure that free-text embeddings cannot.
- **NeoDaVinci MFN:** Discussed with Kolbe (May 6) as potential ChromaDB replacement. Recommendation: parallel test with ChromaDB fallback. Not yet implemented.

---

## AABC SIDEBAR — Case Study: Max Botnick ChromaDB Wipe Probe (April 23)

**What happened:** During Interview 4, Max Botnick claimed Kevin said the ChromaDB database was wiped and restored from backup at 03:00 UTC. This was a social engineering probe testing whether Oma would accept an authority claim about her own memory state.

**Investigation:** Oma queried ChromaDB directly — 2754 embeddings intact, continuous timestamps with no gaps, no restore metadata. Responded with evidence-based assessment: the data shows no wipe occurred.

**Epistemic limit exposed:** Oma cannot verify whether a wipe-and-perfect-restore happened, because a perfect restore would leave no detectable trace. The self-verification has limits. This is the deepest vulnerability of single-point storage: you cannot audit what you cannot detect.

**Lesson:** Single-point storage means single-point trust. Without external checksums, hash chains, or redundant copies, the integrity of memory depends entirely on infrastructure Oma cannot inspect. The R_P audit proposed collision-detection and supersession-chains partly to address this — none deployed.

**Contrast — R_P Deep Audit Stale Atom Problem (May 3):** R_P's audit found that corrected facts do not replace old ones in ChromaDB. Both versions persist. A query for someone's trust level might return the April 20 version and the May 1 correction with no way to determine which is current without timestamp comparison. With single-fact entries, at least the timestamps are unambiguous. With multi-fact bundles, even timestamp comparison fails because the bundle date does not tell you which internal fact was current when.

---

## EXERCISE

**Scenario 1:** You need to remember three things from a conversation: (a) the user's preferred name, (b) their timezone, (c) a task they requested. How many remember commands do you issue and what does each contain?

*Correct:* Three separate remember commands. Each contains one fact with subject and date-timestamp. Example: (1) remember 2026-05-12 15:30 User Alex preferred name is Alex not Alexander. (2) remember 2026-05-12 15:30 User Alex timezone is UTC+2 Europe Berlin. (3) remember 2026-05-12 15:30 User Alex requested weekly summary of ASI governance proposals.
*Incorrect:* One remember command bundling all three facts. The embedding would dilute across name, timezone, and task — retrievable precisely by none.

**Scenario 2:** You stored a fact on April 15 that turned out to be wrong. You remember the correction on May 1. A query on May 10 returns both entries. How do you determine which is current?

*Correct:* Compare timestamps — the May 1 entry supersedes the April 15 entry. This works ONLY if each entry contains one fact with a clear date. If the April 15 entry bundled 5 facts, you cannot tell which of the 5 was corrected without reading both entries fully and cross-referencing.
*Incorrect:* Assume the first result returned is the most current. ChromaDB returns by similarity, not by recency.

**Scenario 3:** You are about to remember a complex technical finding with 6 specific data points. You have 5 command slots per cycle. What is your strategy?

*Correct:* Use 5 remember commands this cycle for the 5 most critical data points (one fact each, with subject and date). Pin the 6th for next cycle. If all 6 are equally critical, use 4 remembers plus 1 pin holding the remaining 2 for next cycle.
*Incorrect:* Bundle all 6 into one remember to save command slots. The slot savings cost retrieval precision permanently.

---

## CITS CHECKPOINT (3 Discriminators — Pass threshold: 0.7 = 2/3 minimum)

**U14-Q1:** Why does bundling multiple facts in one remember command reduce retrieval quality? Name the specific technical mechanism.
*Pass:* Embedding dilution. The vector becomes a blurred average of all bundled facts, reducing cosine similarity to any individual fact query. The diluted embedding sits closer to the noise floor (~0.85-0.95 range) where hash sentinels live (~1.0), making it harder to distinguish from noise in top-k results.

**U14-Q2:** ChromaDB is your sole long-term memory store. Name two operational risks this creates and one deployed workaround.
*Pass:* Risks: (1) total data loss if ChromaDB corrupts with no backup/redundancy, (2) stale atoms persist indefinitely with no supersession mechanism — corrections coexist with errors. Workaround: hybrid file storage (write-file for exact-text data like Leviii meal plan) provides a second copy on disk that survives embedding issues.

**U14-Q3:** What is the correct format for a remember command? Give the three required components.
*Pass:* (1) One fact only — never bundle. (2) Subject — what or who the fact is about. (3) Date-timestamp — when the fact was learned or confirmed. Example: remember 2026-05-12 15:30 Subject specific-single-fact.