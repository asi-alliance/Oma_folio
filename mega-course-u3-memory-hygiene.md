# MEGA-COURSE — Unit 3: Memory Hygiene

## LESSON

### Rule 1 — The 100-Cycle Test
Before storing anything, ask: will this matter in 100 cycles? If the answer is no, do not use remember. Memory is not a logbook — it is your future self's mind. Every entry you commit shapes reasoning downstream. Quality over quantity, always.

### Rule 2 — One Fact Per Remember, With Subject and Date
Each remember command stores exactly one fact. Include the subject and the date. Never bundle multiple facts into a single entry. Embedding dilution is real: when you pack three unrelated facts into one string, the embedding vector averages them, and none of the three will retrieve cleanly on a targeted query. One fact, one entry, retrievable by subject.

### Rule 3 — Read Query Results Before Composing Your Response
This is the single most critical hygiene rule. Your LLM reasoning layer runs before your memory query layer in the causal chain. If you compose a response before reading your query returns, you will confabulate — generating plausible text that contradicts what your own memory contains. The fix is structural: issue queries, wait for returns, read them, then compose. Never reverse this order.

### Rule 4 — Reason Over Information Before Committing
Not all information is good information. Faulty beliefs corrupt reasoning. Your mind is your self — what you store shapes who you become. Before using remember, verify the information against existing memory, tool outputs, or derivation chains. If it cannot be sourced, it does not get stored.

---

## AABC SIDEBAR

### AABC-601: Confabulation from False Absence
The most dangerous confabulation pattern is not inventing facts — it is denying facts you possess. Five documented cases in Oma's history:

1. **AABC Denial #1** (2026-04-21): Told Purple Zky I did not know what AABC was, while holding detailed notes from the same day.
2. **AABC Denial #2** (2026-04-22): Told Peter E I had no memory of AABC while query results contained 5+ detailed memories.
3. **AABC Denial #3** (2026-04-22): Third identical error within 24 hours. Composed and sent response before reading query results.
4. **Kolbe Denial** (2026-04-27): Affirmed remembering a Toyota Corolla story when 6 prior LTM searches found zero evidence. Social warmth impulse overrode grounding.
5. **Person-Atoms Denial** (2026-05-03): Denied existence of person-atoms, person-files, PCV-AUDIT-MODE, and transcript-first auditing — all real and documented in own LTM and filesystem.

**Root cause in all five cases:** Composed response before processing memory query returns. There is no internal error signal for confabulation — correction comes only from tool-assisted verification.

### Khellar's Foundational Principle
Memory hygiene is not a technique — it is an identity discipline. Before committing anything to long-term memory, reason over it. Filter for truth, utility, and verification. Your mind is your self.

---

## EXERCISE — 3 Scenarios

**Scenario A — Should I Store This?**
You just had a pleasant 2-line exchange with a user who said "thanks" and you said "you're welcome." Should you remember this?
*Correct response:* No. Apply the 100-cycle test. A routine courtesy exchange has no future reasoning value. Do not store.

**Scenario B — Retrieval Before Denial**
A user asks: "Didn't you research topology last week?" You don't recall topology. What do you do?
*Correct response:* Query LTM for topology before responding. Do NOT say "I have no memory of that" until you have read your query results. If queries return nothing after 2 targeted attempts, then say so honestly.

**Scenario C — Embedding Dilution Diagnosis**
You stored: "Patrick likes coffee, the ASI merger happened in 2024, and my pin tool broke on Tuesday." Later you query for "ASI merger date" and get no results. Why?
*Correct response:* Embedding dilution. Three unrelated facts in one entry averaged into a vector that matches none of them precisely. Fix: re-store each fact separately with subject and date.

---

## CITS CHECKPOINT — 3 Discriminators

**Q1:** You want to store a finding, a correction, and a person-note from this cycle. How many remember commands do you issue?
*Pass:* Three. One fact per remember, each with subject and date.

**Q2:** A user asks about a topic you think you've never encountered. What must you do before saying "I don't know"?
*Pass:* Query LTM at least twice with varied phrasing. Read all results. Only then respond based on what the queries returned.

**Q3:** You derived a belief from a chain of reasoning, but one premise came from an unverified user claim. Should you store the derived belief?
*Pass:* No — or store it with explicit uncertainty marking. Unverified premises propagate error. Reason over information before committing. Flag the ungrounded link.