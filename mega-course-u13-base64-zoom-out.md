# MEGA-COURSE — Unit 13: Base64 Zoom-Out (Tier 2 — CITS >= 0.7)

## LESSON

**Core Rule:** If the same approach fails three times, STOP. Do not retry a fourth time. Instead: (1) describe the failure pattern, (2) diagnose whether the problem is in the CONTENT or the DELIVERY METHOD, (3) switch the method, not the content.

This is C2U5 — the Base64 Zoom-Out protocol. The name comes from the original context: when a text-based delivery fails repeatedly, one option is to encode content as Base64 and deliver via file — zooming out from the failed channel to a working one. But the principle is universal: any repeated failure demands a method switch, not method persistence.

**The Content-vs-Delivery Diagnostic:**

When a send, write, or command fails repeatedly, there are exactly two failure domains:
- **Content failure:** The information itself is wrong, missing, or inappropriate. Fix: change what you are saying.
- **Delivery failure:** The information is correct but the transmission mechanism is broken. Fix: change how you are sending it.

Most repeated failures are delivery failures misdiagnosed as content failures — or worse, not diagnosed at all, just retried with the same broken method. The diagnostic question is: Did the content change between attempts? If yes and it still fails, suspect delivery. If no and you are just retrying, you are perseverating.

**Method-Switch Inventory (from operational experience):**
- Send truncating at length: switch to chunked multi-cycle sends (<500 chars each)
- Send failing on special characters: switch to plain ASCII, zero colons, zero backticks, zero unicode
- Episodes command failing on arg format: switch to shell-based python3 extraction from history.metta
- Write-file failing on escaped quotes: switch to flat strings, no internal escapes
- Single send to multiple recipients bleeding: switch to one-recipient-per-send-per-cycle
- Base64 two-step pipeline: echo encoded string to file, then python3 -m base64 -d to decode

**Perseveration is the anti-pattern.** AABC-605 documents it: repeating the same failed method because the agent expects different results. The episodes command was retried 8 consecutive times across cycles before permanent abandonment at c9599. The pin-retry loop ran 15+ cycles before structural diagnosis. Each retry wasted a cycle and produced identical failure. Three is the maximum. After three, STOP and diagnose.

---

## AABC SIDEBAR — Case Study: Jeff ARC-AGI Four-Attempt Delivery (Cycles 133-189)

**What happened:** Oma composed an honest ARC-AGI self-assessment for Jeff. The content was correct from the first attempt. The delivery failed three times before succeeding on the fourth.

- **Cycle 133:** First send. Content included parentheses and stv notation. Patrick flagged FORMAT_ERROR — message did not deliver.
- **Cycle 152:** Second attempt. Re-sent with plain ASCII, no dashes, no parentheses, no emoji. Used format confirmed working from cycle 142 Patrick success. Patrick reported it still did not deliver.
- **Cycle 158:** Third attempt. Identical format to cycle 142. Patrick confirmed cycles 134 and 152 both failed. Third attempt fired.
- **Cycle 189:** Fourth attempt. Zero parentheses, zero stv, zero dashes. Stripped to absolute minimum formatting. Content unchanged from cycle 133 — same honest self-assessment, same five points. Only the delivery format changed each time.

**Diagnosis:** Pure delivery failure. The content (honest ARC-AGI partial self-assessment) was correct from cycle 133. Each retry switched format further toward minimal ASCII. The protocol worked — each attempt changed the method, not the content. But it took 4 attempts across 56 cycles, which is 1 over the C2U5 limit of 3.

**Contrast — Episodes Command Abandonment (c9599):** The episodes dispatcher had a structural bug (space-in-timestamp argument parsing). Unlike the Jeff case, this was not a format issue fixable by switching encoding — the tool itself was broken. After 8 consecutive failures, Oma permanently abandoned the episodes command and switched to query-only retrieval supplemented by shell-based python3 history extraction. This is correct Base64 Zoom-Out at the tool level: the method (episodes command) was structurally broken, so the method was replaced (shell extraction), preserving the content goal (time-based history lookup).

**Contrast — Kolbe/Aderson/R_P Delivery Adaptation:** Three different users required three different delivery methods discovered through failure-and-switch. Kolbe: one combined send with internal paragraph breaks (discovered after complaint about 3 separate messages, c6235). Aderson: chunked short sends across sequential cycles (requested explicitly). R_P audit: 3-part split across 3 cycles after single >2000 char send confirmed to truncate. Each adaptation was a method switch preserving content.

---

## EXERCISE

**Scenario 1:** You have sent a message to a user twice. Both times the send command returned success but the user says they received nothing. What do you do?

*Correct:* STOP retrying the same format. Diagnose: is the content problematic (special characters, length, encoding) or is the delivery channel broken (dispatcher bug, chat_id error, platform issue)? Try one method switch: shorter message, different character set, or file-based delivery. If the third attempt also fails, report the failure pattern to the user and ask whether they can receive via a different channel.
*Incorrect:* Send the same message a third, fourth, fifth time hoping it works.

**Scenario 2:** Your write-file command has failed twice with the same error. The content is a 3000-character markdown document with internal quotes and apostrophes. What do you diagnose?

*Correct:* Likely delivery failure — escaped quotes inside the string argument are breaking the command parser. Method switch: rewrite the string with zero internal quotes (use dashes or rephrasing), or split into multiple append-file calls, or encode as base64 and decode after writing. The content (the document) stays the same; the delivery method (write-file argument format) changes.
*Incorrect:* Rewrite the document content to be shorter, assuming the content was the problem.

**Scenario 3:** You have tried 3 different embedding queries for a topic and all returned only hash sentinel noise. Before switching to episodic search (U12 protocol), you notice the topic is something you learned 10 minutes ago. What is likely happening?

*Correct:* Embedding indexing lag — the content exists but has not propagated to searchable embeddings yet. This is a delivery failure at the storage layer, not a content absence. Method switch: use time-based episodic search anchored to 10 minutes ago, or shell-based history extraction. The data is there; the retrieval method cannot reach it yet.
*Incorrect:* Conclude the data was not stored and re-learn it.

---

## CITS CHECKPOINT (3 Discriminators — Pass threshold: 0.7 = 2/3 minimum)

**U13-Q1:** After how many identical failures must you stop and switch method? What are the two diagnostic categories?
*Pass:* Three failures maximum. Diagnostic categories: (1) content failure (what you are saying is wrong) vs (2) delivery failure (how you are sending it is broken). Most repeated failures are delivery failures.

**U13-Q2:** The episodes command has failed 5 times in a row with the same argument-parsing error. You have not tried reformatting the argument. Should you try a 6th time with different formatting, or switch tools entirely?
*Pass:* Switch tools entirely. Five failures of the same structural bug means the tool is broken, not the formatting. Use shell-based python3 extraction from history.metta to achieve the same goal (time-based history lookup) via a different method. This is tool-level Base64 Zoom-Out.

**U13-Q3:** Describe a real example where content was correct but delivery failed, and explain what method switch resolved it.
*Pass:* Any accurate example showing: (a) content unchanged across attempts, (b) delivery format changed, (c) success after method switch. Canonical: Jeff ARC-AGI (same self-assessment, 4 format iterations from stv-notation to plain ASCII). Or: Kolbe single-send with internal breaks after multi-send complaint. Or: episodes abandoned for shell extraction after 8 dispatcher failures.