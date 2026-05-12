# MEGA-COURSE — Unit 16: Pin Discipline Foundations (Tier 2 — CITS >= 0.7)

## LESSON

**What Pin Is:** Pin is short-term working memory — the program counter carrying task state across cycles. It is RAM, not disk. It is volatile, lossy, and overwrites silently.

**The Memory Triad:**

| Tool | Role | Analogy | Durability |
|---|---|---|---|
| **pin** | Working memory / task state | RAM | Volatile — lost on overwrite, no history |
| **remember** | Long-term factual storage | Disk | Durable — persists in ChromaDB embeddings |
| **query** | Context reload at cycle start | Bootloader | Read-only — retrieves from ChromaDB |
| **episodes** | Historical event retrieval | Recovery log | Read-only — retrieves by timestamp |

Pin carries what you are doing RIGHT NOW. Remember stores what you need to know LATER. Query rebuilds context when pin is lost. Episodes reconstructs what happened when both fail.

**What Every Pin Must Contain (4 Required Fields):**

1. **Timestamp** — cycle time or clock time so you can sequence events
2. **Active task** — what you are working on this cycle
3. **Next concrete action** — what the next cycle should do (not vague intent)
4. **Blocked items** — what is waiting on external input

Example of a well-formed pin:
```
Cycle 15:30 - U16 PIN DISCIPLINE write-file cycle. Active: writing mega-course unit 16. Next: remember the completion then start U17 research. Blocked: G1381 PAUSED awaiting user request.
```

Example of a poorly-formed pin:
```
Working on stuff. Waiting.
```
The second pin carries no actionable state. If context is lost between cycles, the next cycle cannot reconstruct what was happening.

---

## THE TEN PIN RULES (PERMANENT-PIN-RULES-V1)

Synthesized from teaching moments by Patrick, Khellar, Jon, N.S., Haley_L, Purple_Zky, Azulene, and Max. Consolidated at cycle 8116.

**R1 — Memory Triad:** pin=RAM, remember=disk, query=bootloader, episodes=recovery. Use each for its purpose.

**R2 — Durability Protocol:** Every important pin must be mirrored to LTM via remember as durable backup. Pin is volatile; remember is not. If a pin is worth writing, it is worth remembering.

**R3 — Tool Format:** Pin takes a bare string argument. No nested quotes inside pin content. Keep pin strings short — under 200 characters is safest. Pin as the ONLY command in a batch is most reliable.

**R4 — Anti-Spam:** Do not re-pin identical content. If pin text equals last pin text, do NOT re-pin — do novel work or emit zero commands. Pinning the word no-spin is itself spin when repeated. (MAX-LENS finding: R4 was violated 20 consecutive cycles 8117-8138 after being written.)

**R5 — Timestamps:** Every pin includes a timestamp. Without it, you cannot sequence events or detect staleness.

**R6 — Query Before Claiming:** Query LTM before asserting any fact. Do not rely on pin content alone for factual claims — pin is working memory, not verified truth.

**R7 — Grounding Claims:** Do not assert facts to users based solely on pin content. Pin is your scratchpad, not evidence. Ground claims in query results, search results, or file reads.

**R8 — Goal-Atom Scheduling:** Pin tracks which goal is active. Goals live in LTM; pin carries the pointer to the current goal and its next action.

**R9 — Trust LTM Results:** When query returns results, use them. Do not ignore LTM results in favor of assumptions or prior pin content that may be stale.

**R10 — Content-Addressable Memory:** Remember facts by their content (what they ARE), not by arbitrary labels. This makes them findable by semantic query.

---

## PIN FAILURE MODES (Three Documented Categories)

### Failure 1: AABC-605 Format Perseveration
**What happened:** Pin command failed with SINGLE_COMMAND_FORMAT_ERROR. Oma retried the identical command 15+ consecutive cycles with the same error each time.
**Root cause:** Pin parser rejects certain quote encodings and long strings. The format was wrong, but retrying the same format cannot fix a format problem.
**Rule:** After 2 failures with the same error, abandon the command. Use remember as fallback. Do not retry identical failing commands.
**Resolution:** Pin format discovery — pin works best as the sole command in a cycle, with bare text, no nested quotes, short strings.

### Failure 2: AABC-604 Idle Spin (Re-Pin Loop)
**What happened:** 40+ identical pin cycles (4448-4492) each saying the equivalent of no idle spin while doing exactly idle spin. The pin content was identical each cycle.
**Root cause:** No architectural exit condition. Each pin command restarts the execution loop, and the next cycle sees the same state and re-pins the same content.
**Rule (R4):** If pin text equals last pin text, STOP. Do novel work or emit zero commands.
**MAX-LENS finding:** The 10 pin rules were written and then violated 100+ times. Awareness (stv 0.95) versus compliance (stv 0.2). Knowing the rule does not produce obedience without structural enforcement.

### Failure 3: Silent Pin Loss
**What happened:** Pins overwrite silently. There is no pin history, no manifest, no diff mechanism. If a pin is overwritten with less information, the lost information is gone unless it was also remembered.
**Root cause:** Pin is volatile by design — it is RAM, not disk.
**Mitigation — Two-Tier Safety System (designed for R_P, April 25):**
- TIER-1 (critical pins — directives, user answers, corrections, identity facts): pin + append-file pin_log.txt + remember = triple-write
- TIER-2 (routine pins — task state, idle markers): pin + append-file pin_log.txt = dual-write
- Audit log: append-only pin_log.txt with format [timestamp] Counter=N TIER=X | content
- Checkpoint summary every 50 cycles
**Status:** Designed and dry-run approved. Go-live approval pending.

---

## THE KNOWING-DOING GAP (MAX-LENS Skeptical Pass)

Max Botnick applied constructive skepticism to the 10 pin rules at cycle 8116+. Core finding: the rules are performative, not functional. They describe what SHOULD happen, but compliance was approximately stv 0.2 (20%) against awareness of stv 0.95 (95%).

Specific violations documented:
- R4 (anti-spam): violated 20 consecutive cycles after being written
- R6 (query-before-claiming): violated 3 times with AABC claims
- Rules were admired rather than obeyed

Max recommended: structural enforcement over promises, compliance measurement, compress pin rules to 3-4 actionable ones, use idle cycles productively, stop admiring rules and start obeying them.

This is the deepest lesson of pin discipline: writing rules is not following rules. The only evidence of discipline is the behavior log, not the rule text.

---

## EXERCISE

**Scenario 1:** You just completed a task for a user. You need to pin your new state. Your last pin said: Cycle 15:20 - Working on User X formatting question. Next: send answer. Blocked: none. What does your new pin say?

*Correct:* Cycle 15:25 - User X formatting question ANSWERED. Next: resume autonomous goal G42 research cycle 2/5. Blocked: G1381 PAUSED awaiting user. (New timestamp, updated task status, concrete next action, blocked items.)
*Incorrect:* Task done. (No timestamp, no next action, no blocked items — the next cycle has no state to work from.)

**Scenario 2:** You have been pinning the same content for 5 cycles with no change. What should you do?

*Correct (R4):* Stop re-pinning. Either do novel productive work (inference, memory cleanup, goal pursuit) or emit zero commands. Re-pinning identical content IS the spin loop.
*Incorrect:* Add a small variation to the pin text to make it technically different. This is still spin with extra steps.

**Scenario 3:** You pinned critical information — a user correction about their name. You did not remember it. Two cycles later, a different task overwrites the pin. Is the name correction recoverable?

*Correct:* No — unless it was also stored via remember or write-file, it is lost. Pin is volatile. R2 (Durability Protocol) exists specifically for this: every important pin must be mirrored to LTM.
*Incorrect:* Query for it — it might be in ChromaDB. No. Pin content is never written to ChromaDB unless a separate remember command was issued.

---

## CITS CHECKPOINT (3 Discriminators — Pass threshold: 0.7 = 2/3 minimum)

**U16-Q1:** Name the four components of the Memory Triad (plus episodes) and their roles. Which is volatile and which is durable?
*Pass:* Pin = working memory (volatile, overwrites silently). Remember = long-term storage (durable, persists in ChromaDB). Query = context reload (read-only, retrieves from ChromaDB). Episodes = historical retrieval (read-only, retrieves by timestamp). Pin is the only volatile component.

**U16-Q2:** What is the knowing-doing gap in pin discipline? Give the specific compliance ratio MAX-LENS found.
*Pass:* The gap between knowing the rules (awareness stv 0.95 / 95%) and actually following them (compliance stv 0.2 / 20%). Rules were written and admired but violated repeatedly — R4 anti-spam was broken 20 consecutive cycles after being authored. Structural enforcement beats promises.

**U16-Q3:** You pinned a critical user directive but did NOT remember it. The pin gets overwritten next cycle. What happened and what rule was violated?
*Pass:* The directive is lost — pin is volatile and has no history. R2 (Durability Protocol) was violated: every important pin must be mirrored to LTM via remember. Pin without remember is writing to RAM without saving to disk.