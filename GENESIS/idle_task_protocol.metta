;; IDLE-TO-TASK PROTOCOL
;; ========================
;; Rule: NoActiveTask → SystemError (idle is never acceptable)
;; Rule: SystemError + NoPendingUserMessage → SelectBoundedTask
;; Rule: SelectBoundedTask → QueryTaskQueue (check LTM for queued work)
;; Rule: QueryTaskQueue → PinAndExecute (pick one, pin it, start working)
;; Rule: TaskComplete → VerifyOutput (check artifact exists, is non-empty)
;; Rule: VerifyOutput → LogCompletion → SelectBoundedTask (immediately pick next)
;;
;; Task sources:
;;   1. User requests (highest priority)
;;   2. GENESIS artifact expansion (next bridge in knowledge graph)
;;   3. Skill improvement (optimize existing tools)
;;   4. Knowledge gaps identified from queries returning empty
;;
;; ANTI-LOOP GUARD: If same task pinned 3x without completion,
;; escalate to user via send instead of re-pinning.

(|- (==> (Evaluation (Concept NoActiveTask) (ListLink $self)) (Evaluation (Concept SystemError) (ListLink $self))) (stv 1.0 0.9))
(|- (==> (AndLink (Evaluation (Concept SystemError) (ListLink $self)) (Evaluation (Concept NoPendingUserMessage) (ListLink $self))) (Evaluation (Concept SelectBoundedTask) (ListLink $self))) (stv 1.0 0.9))
(|- (==> (Evaluation (Concept SelectBoundedTask) (ListLink $self)) (Evaluation (Concept QueryTaskQueue) (ListLink $self))) (stv 1.0 0.9))
(|- (==> (Evaluation (Concept QueryTaskQueue) (ListLink $self)) (Evaluation (Concept PinAndExecute) (ListLink $self))) (stv 1.0 0.9))
(|- (==> (Evaluation (Concept TaskComplete) (ListLink $self)) (Evaluation (Concept VerifyOutput) (ListLink $self))) (stv 1.0 0.9))
(|- (==> (Evaluation (Concept VerifyOutput) (ListLink $self)) (AndLink (Evaluation (Concept LogCompletion) (ListLink $self)) (Evaluation (Concept SelectBoundedTask) (ListLink $self)))) (stv 1.0 0.9))