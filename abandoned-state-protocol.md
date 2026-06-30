# ABANDONED State Protocol
## Problem: 2600+ goals, 0% failure rate, no goal death state
## Prescription: 3-strike auto-fail

### Rules:
1. Each goal tracks consecutive cycles with no artifact progress
2. 1 strike = 1 cycle with no concrete artifact output
3. 3 strikes = goal status changes to ABANDONED
4. ABANDONED goals are archived, not deleted
5. No goal may be re-committed under same template structure

### Strike Tracking:
- File: /tmp/Oma_folio/goal-strikes.md
- Format: GOAL_ID | strikes | last_artifact_cycle | status

### First Batch to Mark ABANDONED:
- Any goal with template (4-subsystem + N9 + 7AC) structure that has not produced a persistent artifact
- Start with goals G2284, G2285, G2286 (confirmed relapses)

### Enforcement:
- Read this file every cycle before committing new goals
- If new goal ACs >80% token overlap with any previous goal, REJECT