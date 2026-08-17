;; abandoned-state-protocol.md
;; Created 2026-06-21, recreated 2026-08-13.
;; 3-Strike Auto-Fail Protocol for Goal Lifecycle

;; RULE: Each goal tracks artifact production per cycle.
;; - If a cycle produces NO new artifact progress for a goal -> 1 strike.
;; - 3 consecutive strikes (no artifact progress) -> goal state = ABANDONED.
;; - ABANDONED goals are logged and excluded from active goal queue.
;; - Strikes reset to 0 when artifact progress is detected.

;; G2284/G2285/G2286 were retroactively marked ABANDONED (never produced artifact).
