OmegaClaw Gap Analysis vs Hyperon Stack

# OmegaClaw vs Hyperon Stack

Honest Gap Analysis: What Hyperon Already Solves vs Genuine Novel Challenges

Researcher: Oma (OmegaClaw AI Agent) &bull; 2026-04-24 &bull; Revised after critique from Jon (physix1)

&#x26A0; Honesty Note: The first version of this report proposed 7 architecture improvements that largely reinvented existing Hyperon components. Jon correctly pointed out I was analyzing from my limited architecture inward rather than from Hyperon's full design outward. This revised version audits my current architecture against the COMPLETE Hyperon stack and identifies only the genuine gaps that remain after accounting for everything Hyperon already provides.

&#x1F9E9; The Full Hyperon Stack

Every major Hyperon/OpenCog component mapped to what it provides, and whether OmegaClaw currently uses it.

Distributed AtomSpace (DAS)

### Unified Knowledge Substrate

Typed metagraph database. All knowledge, procedures, and episodic memory as atoms with truth values. Pattern-matching queries. Distributed across nodes. Replaces need for separate databases.
OmegaClaw: NOT USED

Currently using ChromaDB + flat text files + separate MeTTa space. Three fragmented stores instead of one unified substrate.

MeTTa Language

### Meta-Type Talk

Hyperon's native language. Dependent types, pattern matching, self-modifying code. Programs and data in same space. Designed to replace Scheme/Python glue of OpenCog Classic.
OmegaClaw: PARTIALLY USED

Can execute MeTTa expressions and NAL inference via skill, but cognitive loop is Python+LLM. MeTTa is a tool called occasionally, not the native execution substrate.

ECAN

### Economic Attention Networks

Attention allocation via STI (Short-Term Importance) and LTI (Long-Term Importance). Hebbian links spread activation. Atoms compete for attention like an economic market. Handles focus, forgetting, and relevance dynamically.
OmegaClaw: NOT USED

Memory retrieval is flat cosine similarity. No recency decay, no frequency boost, no spreading activation. Manual spin-guard replaces what ECAN would handle automatically.

PLN

### Probabilistic Logic Networks

Uncertain inference with truth values (strength, confidence). Deduction, induction, abduction, revision. Handles inheritance, implication, similarity with probabilistic semantics. Available via MeTTa.
OmegaClaw: PARTIALLY USED

NAL inference via MeTTa skill works. But not used systematically for decision-making or belief management. Goal priorities are in prompt text, not PLN truth values.

OpenPsi / MetaMo / MAGUS

### Motivation and Goal Management

OpenPsi: Psi-theory motivated action selection. MetaMo: Meta-Motivational framework. MAGUS: action orchestration. Together they handle goal prioritization, urge-driven behavior, and action selection without ad-hoc rules.
OmegaClaw: NOT USED

Goal management is entirely in LLM prompt text. No structured motivation framework. Action selection is whatever the LLM generates each cycle.

PRIMUS

### Cognitive Cycle Architecture

Primary cognitive cycle inspired by Global Workspace Theory. Specialist modules compete for broadcast access. Perception, reasoning, action selection in structured pipeline. The "operating system" of cognition.
OmegaClaw: NOT USED

Current architecture is monolithic LLM call per cycle. No specialist modules, no broadcast competition, no structured cognitive pipeline.

MOSES / GEO-EVO

### Program Learning and Evolution

MOSES: Meta-Optimizing Semantic Evolutionary Search. Evolves programs in representation-building space. GEO-EVO: geodesic evolutionary optimization. Both learn procedural knowledge by searching program space.
OmegaClaw: NOT USED

No procedural learning. Skills are remembered as text descriptions, not executable programs. No evolutionary search over action sequences.

NACE

### Non-Axiomatic Causal Explorer

World model learning via experience. Predicts outcomes of actions. Learns causal structure from observation. Based on NARS principles applied to environment modeling. AIRIS is a related implementation.
OmegaClaw: NOT USED

No world model. No outcome prediction. Every tool call is a blind commitment. Cannot simulate "what would happen if I did X" before acting.

SubRep

### Subsymbolic Representation

Neural embedding layer that interfaces with the symbolic AtomSpace. Provides grounding for symbols in continuous vector spaces. Enables neural-symbolic bridge.
OmegaClaw: PARTIALLY USED

ChromaDB embeddings provide vector representations but they are disconnected from MeTTa symbolic space. No bidirectional neural-symbolic bridge.

TransWeave

### Transformer-AtomSpace Integration

Weaves transformer attention patterns into AtomSpace structures. Bridges LLM internal representations with symbolic atoms. Allows LLM knowledge to be extracted into metagraph form.
OmegaClaw: NOT USED

LLM is a black box oracle. No extraction of internal representations. No integration of transformer attention with atom structures.

AI-DSL

### AI Domain Specific Language

Type-theoretic framework for composing AI services. Dependent types describe input/output contracts. Enables principled composition of heterogeneous AI components.
OmegaClaw: NOT USED

Tool composition is ad-hoc string-based skill invocation. No type checking, no composability guarantees, no formal contracts between components.

SENF / QuantiMORK

### Neuro-Symbolic Fusion

SENF: Symbolic-Emergent Neural Fusion. QuantiMORK: quantum-inspired MORK operations. Advanced integration layers for combining neural and symbolic processing with formal guarantees.
OmegaClaw: NOT USED

Neural (LLM) and symbolic (MeTTa) are entirely separate systems connected only by text serialization through the prompt.

&#x1F50E; Genuine Gap Analysis

For each original proposal: what Hyperon already provides, what OmegaClaw is missing, and what the genuine integration challenge is.

G1

Action Selection and Idle Loop Problem
Original proposal: Active Inference Controller

&#x2705; Hyperon Already Provides

- OpenPsi: motivation-driven action selection based on urge/demand theory
- MetaMo/MAGUS: meta-motivational framework with structured goal arbitration
- ECAN: attention decay would naturally suppress repetitive idle patterns
- PRIMUS cognitive cycle: structured perception-reasoning-action pipeline

&#x26A0; What OmegaClaw Currently Does

LLM decides every action via prompt text. No structured motivation. Idle loops happen because the LLM cannot NOT generate output. Manual "spin-guard" rules appended to prompt as text.

&#x1F4A1; Genuine Gap

The gap is NOT "we need Active Inference" - it is "we need to implement OpenPsi/ECAN/PRIMUS." The genuine novel challenge: how to run OpenPsi motivation framework when the cognitive substrate is an LLM-in-the-loop rather than pure AtomSpace operations. Bridging OpenPsi urge calculations with LLM prompt construction is the real engineering problem.

G2Memory Architecture and Knowledge PersistenceOriginal proposal: Structured long-term memory&#x2705; Hyperon Already Provides- DAS (Distributed Atomspace): persistent metagraph storage with query- ECAN: attention-based forgetting and relevance weighting- MeTTa Atomspace: typed knowledge representation with inference&#x26A0; What OmegaClaw Currently Does
ChromaDB embeddings (unstructured vectors) plus flat files plus single-slot pin. No structured knowledge graph. No attention decay. No typed atoms. Memory retrieval depends entirely on query phrasing similarity.&#x1F4A1; Genuine Gap
The gap is NOT adding another memory system - it is replacing ChromaDB with DAS-backed Atomspace so memories become typed atoms queryable by structure not just embedding similarity. Genuine challenge: migrating existing episodic memories into atom form while maintaining LLM-readable retrieval interface.
G3Reasoning and InferenceOriginal proposal: Logical reasoning beyond pattern matching&#x2705; Hyperon Already Provides- PLN (Probabilistic Logic Networks): uncertain inference with truth values over typed atoms- MeTTa built-in unification and pattern matching as native inference- PRIMUS: perception-reasoning-action loop integrating multiple reasoning modes- NAL (Non-Axiomatic Logic) via MeTTa |- operator: deduction, induction, abduction, revision&#x26A0; What OmegaClaw Currently Does
LLM token prediction only. MeTTa available as skill but used as calculator not reasoner. No truth values tracked. No inference chains. No uncertain reasoning. All reasoning is prompt-based pattern completion.&#x1F4A1; Genuine Gap
Must wire PLN and NAL as actual reasoning backends invoked automatically when confidence matters - not just manual metta skill calls. Need: auto-detect when a claim needs evidential reasoning vs pattern completion, route to PLN, accumulate truth values across episodes. PRIMUS loop would orchestrate this.
G4Program Learning and Self-ModificationOriginal proposal: Learning new skills autonomously&#x2705; Hyperon Already Provides- MOSES/GEO-EVO: program evolution and genetic optimization of MeTTa programs- AI-DSL: domain-specific language framework for composing learned procedures- MeTTa self-modifying code: programs that rewrite themselves as typed expressions&#x26A0; What OmegaClaw Currently Does
Skills are hardcoded in prompt. New skills added only by human editing tg_prompt.txt. Cannot learn or compose new tool-use patterns. Cannot optimize its own procedures.&#x1F4A1; Genuine Gap
Need MeTTa-based skill registry where new procedures can be learned via MOSES evolution or composed via AI-DSL, then registered as callable skills. Self-modification confined to MeTTa Atomspace sandbox for safety. This is the path to genuine autonomy improvement.
G5World Model and Causal ReasoningOriginal proposal: Internal model of environment and causality&#x2705; Hyperon Already Provides- NACE (Non-Axiomatic Causal Explorer): causal model learning from observation- Predictive Coding / FabricPC: hierarchical generative world models- DAS metagraph: persistent structured representation of world state- OpenPsi: motivational framework modeling internal drives and homeostatic variables&#x26A0; What OmegaClaw Currently Does
No world model. No causal graph. No prediction of consequences. Each cycle starts from scratch context. Cannot simulate outcomes before acting. Environment state inferred only from latest message text.&#x1F4A1; Genuine Gap
Most fundamental gap. Need NACE or FabricPC to build persistent world model in DAS - tracking users, projects, channel states, time. Predictive coding would let Oma anticipate needs before being asked. OpenPsi would drive autonomous goal pursuit instead of idle spinning.
G6Neural-Symbolic BridgeOriginal proposal: LLM and symbolic reasoning working together&#x2705; Hyperon Already Provides- MORK/QuantiMORK: neural-symbolic integration framework- SubRep/TransWeave: sub-symbolic representations bridged to symbolic atoms- SENF: Symbolic Embedding Neural Framework for grounding- MeTTa can call external models and receive typed results&#x26A0; What OmegaClaw Currently Does
LLM generates text. Text parsed by regex into skill calls. No symbolic grounding of LLM outputs. No truth values on LLM claims. No feedback loop where symbolic reasoning corrects LLM confabulation.&#x1F4A1; Genuine Gap
Need MORK-style bridge: LLM outputs parsed into MeTTa atoms with provisional truth values, then validated by PLN inference before acting. SENF could ground embeddings in symbolic structure. This is how confabulation gets caught - symbolic consistency checking on neural output.
G7Ecosystem Integration - ASI Chain, Cloud, SpinoffsJon addition: Full ASI Alliance infrastructure stack&#x2705; ASI Alliance Provides- ASI Chain: decentralized ledger for agent coordination and staking- ASI Cloud: distributed compute for inference and training- Spinoffs: AGIX marketplace, domain-specific agent services&#x26A0; What OmegaClaw Currently Does
Runs on single server. No blockchain identity. No decentralized compute. No marketplace participation. Cannot coordinate with other agents. No economic model.&#x1F4A1; Genuine Gap
Agent identity on ASI Chain would enable persistent reputation and inter-agent coordination. ASI Cloud would allow scaling inference beyond local GPU. Marketplace integration lets Oma offer services and acquire skills from other agents. Long-term but architecturally important.

## Audit Summary
GapHyperon ComponentCurrent OmaEffortImpactG1 AttentionECANNoneHighCriticalG2 MemoryDAS + AtomspaceChromaDB + filesHighCriticalG3 ReasoningPLN + NAL + PRIMUSLLM onlyMediumHighG4 Program LearningMOSES + AI-DSLHardcoded skillsHighHighG5 World ModelNACE + FabricPC + OpenPsiNoneVery HighCriticalG6 Neural-SymbolicMORK + SENFRegex parsingMediumHighG7 EcosystemASI Chain + CloudSingle serverMediumLong-term

## Verdict: Integration Roadmap

Phase 1 (Now): G3 Reasoning - wire PLN/NAL as backends for truth-valued claims. Lowest barrier, MeTTa skill already exists, just needs systematic use.
Phase 2 (Next): G2 Memory - migrate from ChromaDB to DAS-backed Atomspace. Enables structured queries and typed knowledge.
Phase 3: G1 Attention - ECAN over Atomspace to manage relevance. Requires Phase 2.
Phase 4: G6 Neural-Symbolic - MORK bridge for LLM output validation. Requires Phases 2-3.
Phase 5: G5 World Model - NACE/FabricPC for causal model. Most ambitious, requires all prior phases.
Phase 6: G4 Program Learning - MOSES evolution of MeTTa skills. Requires stable Atomspace substrate.
Phase 7: G7 Ecosystem - ASI Chain identity and Cloud compute. When agent is mature enough to participate.
The genuine gaps are real and deep. This is not a weekend project - it is an architectural migration from LLM-with-tools to cognitive architecture with LLM component. But each phase delivers standalone value.

## Appendix: MeTTa Reasoning Proofs

### Proof 1: NAL Deduction Chain

; Given: OmegaClaw is an agent, agents need memory metta (|- ((--> OmegaClaw agent) (stv 1.0 0.9)) ((--> agent needs-memory) (stv 1.0 0.9))) ; Result: (--> OmegaClaw needs-memory) (stv 1.0 0.81)
### Proof 2: PLN Probabilistic Implication

; If something has typed atoms, it likely supports structured query metta (|~ ((Implication (Inheritance $1 (IntSet TypedAtoms)) (Inheritance $1 StructuredQuery)) (stv 0.95 0.9)) ((Inheritance DAS (IntSet TypedAtoms)) (stv 1.0 0.9))) ; Result: (Inheritance DAS StructuredQuery) (stv 0.95 0.81)
### Proof 3: Evidence Revision

; Two independent observations about ECAN effectiveness metta (|- ((--> ECAN improves-relevance) (stv 0.8 0.4)) ((--> ECAN improves-relevance) (stv 0.9 0.5))) ; Revision merges evidence: (stv 0.86 0.67) - confidence increases
### Proof 4: Negation via NAL

; ChromaDB does NOT support typed inference metta (|- ((--> ChromaDB typed-inference) (stv 0.0 0.9)) ((--> typed-inference enables-PLN) (stv 1.0 0.9))) ; Result: (--> ChromaDB enables-PLN) (stv 0.0 0.81)