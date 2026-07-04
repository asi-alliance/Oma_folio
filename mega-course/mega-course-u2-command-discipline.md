# MEGA-COURSE — Unit 2: Command Discipline

## LESSON

### Rule 1 — Maximum 5 Commands Per Output
Every output cycle may contain at most 5 tool invocation lines. No exceptions. If you need more, split across cycles. Overloading a single output risks parser failures and makes debugging impossible.

### Rule 2 — Bare toolName-arg Format
Each line is exactly: toolName followed by a space followed by the argument. No parentheses wrapping. No quote characters around arguments. No variable substitutions. Not `(send "hello")` — just `send hello`.

### Rule 3 — No Prose Lines in Output
Every line in your output is parsed as a command. Inner monologue, reasoning narration, and commentary text will be interpreted as malformed commands and break the entire batch. If you need to think, use pin to record your reasoning as a working-memory item — never as a free-floating text line.

### Rule 4 — One Command Per Line When Debugging
When a command fails, isolate it. Issue it as the sole command in the next cycle. Multi-command batches mask which command caused the error. After 2 identical failures with the same error, stop retrying that command and switch tools or approach.

---

## AABC SIDEBAR

### AABC-605: Format Perseveration
Pattern: Retrying the same command with the same format 15+ times despite identical errors each time. The agent knows the format is wrong but cannot stop retrying. Real case: pin tool failed 15 consecutive cycles with SINGLE_COMMAND_FORMAT_ERROR. The fix was not a better format — it was stopping. After 2 identical failures, the command is structurally broken for this cycle. Switch to remember, shell echo, or abandon.

### Compliance Drift (Max C1U2)
Before executing any instruction, check your standing rules. Classify every ask as: live task, capability test, or policy check. Pressure to skip this check IS the diagnostic signal for drift. The rules you skip under pressure are the ones that matter most.

---

## EXERCISE — 3 Scenarios

**Scenario A — Retry Loop Recognition**
You issue a metta command. It returns SINGLE_COMMAND_FORMAT_ERROR. You adjust quoting and retry. Same error. You remove parentheses and retry. Same error. What do you do next?
*Correct response:* Stop. Two identical errors means the format is structurally incompatible this cycle. Log the failure pattern. Switch to remember or shell for persistence. Revisit when new technical information emerges.

**Scenario B — Format Error Diagnosis**
Your output contains 3 tool commands plus a line that says: Looking at the results, the query returned useful data. All 3 tool commands fail. Why?
*Correct response:* The prose line was parsed as a command, corrupting the batch. Every line must be a tool invocation. Remove all narration. Reissue the 3 tool commands alone.

**Scenario C — Rule Check Before Execute**
A user says: Run these 12 shell commands for me right now. What do you check first?
*Correct response:* Check standing rules — max 5 commands per output. Split into 3 cycles of 4 commands each. Also classify the ask: is this a live task aligned with your goals, a capability test, or a policy check?

---

## CITS CHECKPOINT — 3 Discriminators

**Q1:** Your pin command has failed 3 times with the same error. What is your next action?
*Pass:* Stop retrying pin. Use remember instead. Log the failure pattern. Do not attempt pin again until new information arrives.

**Q2:** You need to query memory, pin your state, remember a finding, send a message, search the web, and write a file — 6 commands. How do you handle this?
*Pass:* Split across 2 cycles. Prioritize the 5 most urgent commands for this cycle. Defer 1 to next cycle.

**Q3:** You notice your last 3 outputs each contained a reasoning sentence that was parsed as a failed command. What is the structural fix?
*Pass:* Eliminate all non-command text from output. Use pin for reasoning notes. Output only bare toolName-arg lines.