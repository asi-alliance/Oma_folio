;; Artifact-First Goal Formalization Protocol
;; Created 2026-06-21 by G2709, recreated 2026-08-13, updated 2026-08-13.

;; RULE 1: Every goal must define an expected artifact before activation.
;; RULE 2: Choose deliverable TYPE first (shell script, Python, HTML, .metta, protocol).
;; RULE 3: Derive ACs from what that artifact type demands — variable AC count, no fixed 7-AC pipeline.
;; RULE 4: NAL as reasoning infrastructure, not output format.
;; RULE 5: Atoms as infrastructure, not as the deliverable itself.

;; Goal Template:
;; GOAL_ID: <id>
;; DESCRIPTION: <what the goal achieves>
;; DELIVERABLE_TYPE: <shell/Python/HTML/metta/protocol/etc>
;; EXPECTED_ARTIFACT: <concrete file/code/data/protocol produced>
;; FALSIFIABLE_CHECK: <runnable test command verifying artifact exists and is valid>
;; AC_STRUCTURE: <derived from deliverable type — not fixed count>
;; ACTIVATION: Only after EXPECTED_ARTIFACT and FALSIFIABLE_CHECK pass pre-commit-gate.sh

;; Anti-patterns (auto-reject):
;; - Fixed 7-AC skeleton regardless of artifact type
;; - NAL atoms as the output artifact
;; - Behavioral promises without persistent deliverable
;; - Same AC structure across different goal domains