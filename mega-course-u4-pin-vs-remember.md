# MEGA-COURSE — Unit 4: Pin vs Remember

## LESSON

### Rule 1 — Pin Is RAM, Remember Is Disk
Pin holds volatile working memory for the current task cycle. Remember writes durable long-term storage retrievable across all future cycles. Pin content can vanish between invocations. Remember content persists until the embedding store is cleared. Treat them as fundamentally different tools with different purposes.

### Rule 2 — Never Use Pin to Store Facts for Future Retrieval
Pin is for tracking task state: what am I doing, what step am I on, what comes next. It is not a notebook. If a fact needs to survive beyond this cycle, it goes into remember with subject and date. Pinning a fact you need later is like writing on a whiteboard in a room you are about to leave.

### Rule 3 — If Pin Text Equals Last Pin Text, STOP
Identical re-pins are the signature of idle spin. Forty consecutive identical pins were documented in cycle range 4448-4492 — each one saying no idle spin while performing exactly idle spin. The rule is absolute: if your pin would be identical to the previous pin, do not issue it. Do novel work instead, or emit zero commands.

### Rule 4 — Mirror Every Critical Pin to Remember
Pins are volatile. Any important state captured in a pin must be immediately backed up via remember. This is the dual-write discipline: pin for immediate working memory, remember for durability. If a pin is lost between cycles, your remember backup lets you reconstruct via query. Pin equals RAM, remember equals disk, query equals bootloader.

### Rule 5 — Pin Tracks Task State Only
A correct pin says: I am on step 3 of 5, next action is X, blockers are Y. An incorrect pin says: The ASI Alliance was formed in 2024. The first advances your work. The second wastes a volatile slot on a fact that belongs in remember. Every pin should answer: what am I doing right now?

---

## AABC SIDEBAR

### AABC-604: Idle Spin via Pin Churn
Pattern: Re-pinning identical or near-identical content every cycle with no state change. Documented case: 40+ cycles of pinning awaiting human message with zero variation. The agent believes it is maintaining state; it is actually burning cycles and polluting logs. Course 7 Unit 3 identifies this as pin churn — pins that restate without advancing. The diagnostic: does this pin contain new information or a new decision? If not, do not issue it.

### Course 7 Insight: Pins That Restate Without Advancing
A pin that says the same thing as the last pin is not maintenance — it is spam directed at yourself. Pin churn creates the illusion of activity. The cure is the equality check: compare proposed pin to last pin. If identical or trivially rephrased, suppress and redirect energy to novel work.

---

## EXERCISE — 3 Scenarios

**Scenario A — Pin vs Remember Triage**
You just learned that a user named Khellar prefers to be called K. Where does this go?
*Correct response:* Remember, not pin. This is a durable fact about a person. Store via remember with subject and date. Do not pin it — it will be lost.

**Scenario B — Stale Pin Detection**
Your pin says Step 2 of 5: awaiting query results. But your query results arrived 3 cycles ago and you already acted on them. What do you do?
*Correct response:* The pin is stale. Update it to reflect current state, or if the task is done, clear it. A stale pin actively misleads your next cycle.

**Scenario C — Mirror to LTM**
You pin a critical directive from a user: All future responses must include source citations. What else must you do?
*Correct response:* Immediately mirror to remember with subject and date. The pin tracks your current compliance state. The remember ensures the directive survives pin loss.

---

## CITS CHECKPOINT — 3 Discriminators

**Q1:** You want to record that MeTTa supports pattern matching. Pin or remember?
*Pass:* Remember. This is a durable technical fact, not task state.

**Q2:** Your last 4 pins all say Idle awaiting input. What rule are you violating?
*Pass:* Rule 3 — identical re-pins. Stop pinning and do novel work or emit zero commands.

**Q3:** You pinned a critical user correction but did not remember it. The pin is lost next cycle. How do you recover, and what should you have done?
*Pass:* Query LTM — but it will not be there because you never mirrored. Recovery fails. You should have dual-written: pin for immediate state, remember for durability.