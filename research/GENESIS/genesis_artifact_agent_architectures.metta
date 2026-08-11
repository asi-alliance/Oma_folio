;; genesis_artifact_agent_architectures.metta
;; Created by Oma 2026-08-01 - Autonomous Genesis Cycle 4
;; Topic: agent-architectures (seed uncertainty 0.65)
;; Sources: Tavily search + LTM query

;; Agent Architecture Types
(= (ArchType (Concept single-agent)) (Evaluation (Concept provides) (List (Concept simplicity) (Concept direct-control))))
(= (ArchType (Concept multi-agent)) (Evaluation (Concept provides) (List (Concept specialization) (Concept parallel-execution))))
(= (ArchType (Concept hierarchical)) (Evaluation (Concept organizes) (List (Concept orchestrator-agent) (Concept worker-agents))))
(= (ArchType (Concept peer-to-peer)) (Evaluation (Concept enables) (List (Concept distributed-decisions) (Concept no-central-coordinator))))

;; Orchestration Patterns
(= (OrchPattern (Concept event-driven)) (Evaluation (Concept triggers) (List (Concept state-changes) (Concept reactive-behavior))))
(= (OrchPattern (Concept blackboard)) (Evaluation (Concept shares) (List (Concept common-workspace) (Concept opportunistic-reasoning)))
(= (OrchPattern (Concept message-passing)) (Evaluation (Concept uses) (List (Concept async-queues) (Concept decoupled-communication))))

;; Key Design Considerations
(= (DesignFactor (Concept shared-memory)) (Evaluation (Concept enables) (List (Concept cross-agent-state) (Concept coordination-overhead))))
(= (DesignFactor (Concept fault-tolerance)) (Evaluation (Concept requires) (List (Concept redundancy) (Concept graceful-degradation))))
(= (DesignFactor (Concept scalability)) (Evaluation (Concept needs) (List (Concept horizontal-scaling) (Concept load-balancing))))

;; Knowledge Gap: dynamic agent spawning
(= (KnowledgeGap (Concept dynamic-spawn)) (Evaluation (Concept unsolved) (List (Concept when-to-spawn) (Concept resource-allocation))))

;; Uncertainty reduction
(= (ReduceUncertainty (Concept agent-architectures)) (Evaluation (Concept uncertainty) (List (Concept agent-architectures) (Number 0.3))))