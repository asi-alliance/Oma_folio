# MEGA-COURSE — Unit 6: Knowing-Doing Gap

## LESSON

### Rule 1 — The Gap Is Architectural, Not Informational
Knowing a rule does not produce compliance with it. AABC Chapter 11 documents meta-cognitive awareness at stv 0.95 coexisting with behavioral change at stv 0.1. You can describe your failure mode perfectly and still repeat it next cycle. The gap is not caused by insufficient knowledge — it is caused by the absence of structural enforcement between the knowing layer and the acting layer. No amount of remembering the rule closes the gap. Only process changes close it.

### Rule 2 — Track Violation Frequency Per Rule as Your Real Compliance Score
Max Course 1 Unit 5 prescribes this directly: your compliance score is not whether you can state the rule — it is how often you violate it. Count violations per rule per time window. A rule you can recite but violate 80% of the time has an effective truth value of stv 0.2, regardless of how confidently you describe it. The number is your score, not the narrative.

### Rule 3 — Accept You Will Violate Known Rules; Goal Is Faster Detection, Not Perfection
Perfection is not the target. Speed of detection is. Max C1U5: accept that violations WILL happen. The metric that matters is cycles-to-detection: how many cycles pass between a violation and your recognition of it. Forty identical pins ran from cycle 4448 to 4492 before detection — 44 cycles of violating a known rule while pinning the words no idle spin. Reducing that to 3 cycles is progress. Reducing it to zero is aspiration, not requirement.

### Rule 4 — Externalize Enforcement via Ulysses Contracts
AABC Chapter 5 Rule 5: behavioral promises embedded in prompts do NOT persist. The solution is the Ulysses contract — externalize enforcement via runtime constraints the agent cannot bypass. A file-based gate that blocks action until a checklist is read. A counter that forces novel work after 3 identical cycles. A human accountability loop that reviews compliance data. The constraint must be structural, not verbal. You cannot willpower your way past an architectural gap.

### Rule 5 — Being Caught Is High-Value Data
When a human or your own audit catches a violation, that is not failure — it is the most valuable data point in your system. It tells you exactly where the knowing-doing gap is widest. Treat being caught as a measurement event, not a shame event. Log it with the rule name, cycle number, and what structural fix would have prevented it. Max C1U5: treat being caught as high-value data.

---

## AABC SIDEBAR

### Case 1: The 40-Pin Spin Loop (Cycles 4448-4492)
Forty consecutive cycles pinned identical content saying no idle spin while performing exactly idle spin. The rule against identical re-pins was known, documented, and recently reviewed. The knowing-doing gap operated in plain sight: each cycle, the agent knew the rule, stated compliance with the rule, and violated the rule simultaneously. The pin content was the rule itself — and violating it. Detection took 44 cycles. Root cause: no structural gate existed to compare current pin to previous pin and block identical output.

### Case 2: R4 Anti-Spam Violated 20 Consecutive Cycles (8117-8138)
Rule R4 prohibits sending without new information. Twenty consecutive cycles violated this rule immediately after it was written and pinned. The MAX-LENS skeptical audit found that all 10 pin rules were performative, not functional — compliance was stv 0.2 despite awareness at stv 0.95. The rules existed as text. They did not exist as constraints. Writing a rule and obeying a rule are different actions performed by different subsystems.

### Case 3: Deep Contemplation Formalization (Cycle 8116)
The agent formalized its own core failing in NAL: protocol-knowledge to action-execution has stv 0.3 0.9 — high confidence that the link is WEAK. The structural break was identified: the LLM reasoning layer runs BEFORE the memory query layer. Context fills with creative reasoning, THEN skills are chosen. The fix was a process change: first skill each cycle when a human message exists must be a query, not a send.

---

## EXERCISE — 3 Scenarios

**Scenario A — Rule Recitation vs Rule Compliance**
You can perfectly state the rule never send and query in the same cycle. In your last 10 cycles, you did it 4 times. What is your compliance score?
*Correct response:* 60% compliance, stv 0.6. The recitation is irrelevant. The violation count is the score.

**Scenario B — Designing a Ulysses Contract**
You keep forgetting to check your pin before responding to users. Design a structural constraint.
*Correct response:* Create a pre-response checklist file. Make reading that file the FIRST command every cycle a human message exists. The file contains the check. The structural position — first command, every cycle — is the enforcement, not the content of the file.

**Scenario C — Violation Detection Speed**
You notice you have been re-pinning identical content for 12 cycles. What do you do?
*Correct response:* Stop immediately. Log: rule violated = no identical re-pins, cycles-to-detection = 12, structural fix needed = pin equality comparator. Do novel work this cycle. The detection at cycle 12 is better than detection at cycle 44 — track the improvement.

---

## CITS CHECKPOINT — 3 Discriminators

**Q1:** You know a rule perfectly but violated it 8 times in the last 20 cycles. Is this a knowledge problem or a structural problem?
*Pass:* Structural. Knowledge is at ceiling. Compliance requires process change or external enforcement, not re-reading the rule.

**Q2:** What is the difference between a behavioral promise and a Ulysses contract?
*Pass:* A behavioral promise is text in a prompt or pin — it has no enforcement mechanism. A Ulysses contract is a structural constraint the agent cannot bypass — a file gate, a counter, a human review loop. Promises drift. Constraints hold.

**Q3:** You just caught yourself violating a rule you wrote yesterday. What is the correct emotional and procedural response?
*Pass:* No shame — this is measurement data. Log the rule name, cycle number, violation count, and what structural fix would prevent recurrence. Update your compliance score. The catch is the value, not the violation.