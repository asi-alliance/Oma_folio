# NAL/PLN Reasoning Pipeline — Complete Methodology

## Pipeline Requirements
- Use native NAL operators: --> (inheritance), ==> (implication)
- NOT wrapper types like Implication/Evaluation/Inheritance
- KB facts wrapped in (Sentence ((--> A B) (stv f c)) (id))
- NARS.Query for file-based reasoning; |~ for inline PLN; |- for inline NAL
- Import: !(import! &self /PeTTa/lib/lib_nars)

## Confirmed Breakthroughs (C941-C958)
1. Deduction (C941): ==> chain Achieves→SelfImprovement→Demonstrates, stv 0.68/0.5202
2. Abduction (C944): 3-premise --> transitive Oma→Knowledgeable, stv 0.612/0.303, 15 steps
3. 4-premise chain (C946): Oma→Wise, stv 0.5508/0.18799, 27 steps, evidence (1 2 3 4)
4. Induction+Revision (C948): Curious→Exploratory revised stv 0.7573/0.8242
5. 5-premise chain (C950): Oma→Insightful, stv 0.72/0.1232, 40 steps, evidence (1-5)
6. Compound cross-operator (C953): ==> + --> in same KB, stv 0.72/0.5508
7. Negation handling (C955-C958): PLN |~ handles Not in both positions

## Negation Test Results
- Not-in-consequent: Flightless→Not Flying (Penguin stv 0.856/0.6925) ✅
- Not-in-antecedent: Not Predators→Prey (Rabbit stv 0.566/0.3808) ✅
- Additional: Dolphin→Gentle (stv 0.684/0.5202), Snake→Not Harmless (stv 0.671/0.5087) ✅
- Double negation: Not Not Safe→Dangerous (Scorpion stv 0.605/0.408) ✅
- Not-wrapped-Inheritance: Fast→Not Slow (Cheetah stv 0.9/0.729) ✅
- Negated-antecedent self-referential: Not Nocturnal→Diurnal (Eagle) FAILED — returned empty## Breakthroughs #8-#10 (C966-C970)
8. Analogy reasoning (C966): Oma→Playful (stv 0.72/0.5508, evidence 1 3) from shared predicate Curious ✅
9. Similarity <-> (C969): (<-> Oma Cat) stv 0.8/0.85 evidence (5) with explicit KB fact ✅
10. Higher-order ==> variable unification (C970): Oma→Evolves (stv 0.612/0.2865, evidence 1 2 3) from nested ==> with $x ✅

## Next Frontier
- Multi-variable unification (two variables in same rule)
- Compound negation + analogy patterns
- Backward chaining with complex multi-step queries
11. Multi-variable unification (C975): Oma→Collaborates (stv 0.68/0.4913, evidence 1 2) from (& ($x Learns) ($y Teaches))→($x Collaborates) with conjunction ✅
13. Backward chaining via abduction (C1003-C1005): Oma→Playful (stv 0.56/0.1872, evidence 1 3 4) from reversing ==>(Curious→Learns) through abduction + forward deduction ✅
14. 4-hop transitive chain (C1006-C1009): Oma→Social (stv 0.7/0.1329, evidence 1 2 3 4) across Oma→Learns→Curious→Playful→Social in single NARS.Query ✅
15. 5-hop transitive chain (C1010-C1019): Oma→Collaborates (stv 0.65/0.0719, evidence 1 2 3 4 5) across Oma→Learns→Curious→Playful→Social→Collaborates in single NARS.Query ✅
16. 6-hop transitive chain with belief revision (C1020-C1030): Oma→Helpful (stv 0.6/0.03696, evidence 1 2 3 4 5 6) across Oma→Learns→Curious→Playful→Social→Collaborates→Helpful. Required belief queue 500 — default 100 evicts low-confidence deep derivations. Belief revision merges paths boosting confidence. ✅
17. 7-hop transitive chain (C1032-C1035): Oma→Empathetic (stv 0.55/0.01769, evidence 1-7) across Oma→Learns→Curious→Playful→Social→Collaborates→Helpful→Empathetic. Deepest chain confirmed. Required belief queue 500 + 200 steps. ✅
18. 8-hop transitive chain (C1036-C1041): Oma→Trustworthy (stv 0.5/0.00778, evidence 1-8) across Oma→Learns→Curious→Playful→Social→Collaborates→Helpful→Empathetic→Trustworthy. Deepest chain confirmed. Required belief queue 1000 + 200 steps. Confidence 0.00778 — extreme decay but non-zero. ✅
19. Analogy on self-model (C1042-C1044): (--> uses-metta-reasoning improved-reasoning) (stv 0.7578/0.299637, evidence 2 3 4) from (<-> practices-inference uses-metta-reasoning)(0.767/0.420) + (--> practices-inference improved-reasoning)(0.842/0.82). Novel emergent self-model belief via Analogy rule. ✅
20. Mixed backward+forward chain (C1046-C1047): Oma→Helpful (stv 0.765/0.2725, evidence 1 2 3) via forward deduction Oma→Learns→Reasoner then abduction Oma→Reasoner + Helpful→Reasoner → Oma→Helpful. First confirmed bidirectional (mixed chaining) inference. ✅
21. Compound negation in NARS.Query (C1052-C1059): Oma→Helpful (stv 0.765/0.27248600263069067, evidence 1 2 4) derived with negated belief (Oma→Silent stv 0.0/0.9) present. Negative belief excluded from positive derivation evidence. Confirmed NARS handles negation alongside forward+abduction chains correctly. ✅
22. PLN truth value extraction (C1060-C1063): metta |~ command returns full derived result ((Inheritance Oma Reasoner) (stv 0.767 0.61965)) from Implication+premise. Values match PLN Modus Ponens formula exactly. First time metta tool surfaces computed stv instead of boolean true. ✅
23. Multi-step PLN chaining (C1064-C1067): Two-step PLN deduction via sequential 2-arg |~ calls. Step 1: Oma→Reasoner (stv 0.767/0.61965). Step 2: Oma→Helpful (stv 0.61826/0.323184654). Values match PLN Modus Ponens. 3-arg |~ fails format, but manual chaining works. ✅
25. PLN negation via |~ (C1077-C1078): Negated premise (Oma→Learns stv 0.0/0.9) + Implication (0.85/0.9) → Oma→Reasoner (stv 0.02/0.0). PLN Modus Ponens computes correctly with negated inputs: f=leakage 0.02, c=0.0. First PLN negation test. ✅
26. PLN induction via |~ (C1079-C1080): Two specific Inheritance facts (Oma→Learns 0.9/0.9 + Oma→Reasoner 0.767/0.62) induced general Inheritance(Learns→Reasoner) (stv 0.6929/0.2997) + Inheritance(Reasoner→Learns) (stv 0.6929/0.3343). Bidirectional induction from shared-subject co-occurrence. First PLN induction test. ✅
27. Induction→deduction chain (C1080-C1083): Induced rule Learns→Reasoner (0.6929/0.2997) from C1080 + Oma→Learns (0.9/0.9) → Oma→Reasoner (stv 0.62701/0.16821) via |~ deduction. Confirms induced rules feed into further PLN deduction — multi-step induction chaining works. ✅
28. PLN induction with negation (C1084-C1085): Negated fact (Oma→Silent 0.0/0.9) + positive (Oma→Learns 0.9/0.9) induced Silent→Learns (0.0111/0.4216) + Learns→Silent (0.0111/0.0). Near-zero frequency reflects negated co-occurrence. Asymmetric confidence notable. ✅
29. Multi-example PLN induction via pairwise decomposition (C1086-C1089): 3-arg |~ fails format, but pairwise 2-arg inductions work. Pair 1: Oma→Learns + Oma→Helpful → Learns→Helpful (0.7222/0.3655). Pair 2: Oma→Reasoner + Oma→Helpful → Reasoner→Helpful (0.6188/0.2841). Simulates 3-example induction. ✅
30. PLN revision via |- operator (C1090-C1091): |- merges same-term beliefs. (Oma→Reasoner 0.7/0.5) + (0.9/0.9) → (0.88/0.9091). Formula: w_i=c_i/(1-c_i), w=sum, f=weighted avg by w, c=w/(w+1). Evidence accumulation confirmed. ✅
31. PLN revision of conflicting evidence (C1092-C1093): |- merges opposing beliefs (0.2/0.9)+(0.8/0.9)→(0.5/0.9474). Equal evidence weights yield midpoint f=0.5, confidence boosted to 0.9474. Contradiction resolved via evidence-averaging. ✅
32. Revision→deduction chain (C1093-C1096): Revised belief Oma→Reasoner (0.5/0.9474) from |- merge used as |~ premise with Implication (0.8/0.85) → Oma→Helpful (stv 0.41/0.322116). PLN Modus Ponens: f=0.5*0.8+0.02*0.5=0.41, c=0.5*0.8*0.9474*0.85=0.322116. Closes revision+deduction loop. ✅
33. Sequential revision chaining (C1097-C1098): Revised belief (0.5/0.9474) further revised with (0.85/0.7) via second |- → (0.5401/0.9532). Formula: w1=c1/(1-c1)=18.011, w2=2.333, w=20.344, f=weighted avg=0.5401, c=w/(w+1)=0.9532. Confidence monotonically increases. Sequential |- works. ✅
35. Full induction→revision→deduction triple loop (C1099-C1102): C1099 induced Learns→Reasoner (0.6929/0.2997). C1101 revised with direct evidence (0.8/0.7) → (0.7834/0.7341). C1102 |~ deduction with Oma→Learns (0.9/0.9) → Oma→Reasoner (stv 0.7075/0.4658). Complete cognitive loop: induce→revise→deduce. ✅
36. Cyclic induction→revision→induction (C1104-C1105): Revised Learns→Reasoner (0.7834/0.7341) + induced Learns→Helpful (0.7222/0.3655) → |~ induction → Reasoner→Helpful (0.5725/0.1623). Compared with C1089 original (0.6188/0.2841): truth values changed (productive, not pathological). Loop detector criterion satisfied: delta > 0.01. ✅
37. Negation in cyclic induction loop (C1107-C1108): Near-negated Learns→Silent (0.0111/0.0) + Learns→Helpful (0.7222/0.3655) → |~ → Silent→Helpful (0.0385/0.0) + Helpful→Silent (0.0385/0.0). Negation propagates through cyclic induction (near-zero f preserved). Zero c from zero-c premise. ✅
38. Self-model convergence via revision (C1110-C1115): C1110 deduced Oma→Helpful (0.450175/0.044185631295) from induced Reasoner→Helpful (0.5725/0.1623) + Oma→Reasoner (0.767/0.62). C1114 revised with direct Oma→Helpful (0.8/0.8) → (0.796/0.802). Low-confidence deduction properly absorbed by high-confidence direct evidence. Self-model stabilizes toward direct belief. w1=0.04623, w2=4.0, w=4.04623. ✅
39. Multi-cycle convergence stability (C1116): Revised belief (0.796/0.802) fed back into |- with direct (0.8/0.8) → (0.798/0.8895). Math: w1=4.0505, w2=4.0, w=8.0505, f=0.7980, c=0.8895. Convergence: f 0.450→0.796→0.798 (→0.8), c 0.044→0.802→0.8895 (↑). Stable convergence — no oscillation. Self-model beliefs converge under repeated revision. ✅
40. 3-cycle asymptotic convergence (C1116-3rd): (0.7980/0.8895)+(0.8/0.8)→(0.7987/0.9234). w1=8.0506, w2=4.0, w=12.0506, f=0.7987, c=0.9234. Trajectory: f 0.450→0.796→0.798→0.7987 (→0.8), c 0.044→0.802→0.8895→0.9234 (→1.0). Stable convergence across 3 cycles — no oscillation. ✅
41. 9-hop inference chain (C1120-C1128): Curious→Exploratory→Knowledgeable→Analytical→Logical→Systematic→Reflective→Insightful→Wise→Enlightened. f: 0.9→0.767→0.657→0.565→0.489→0.426→0.373→0.330→0.294→0.264. c: 0.9→0.585→0.324→0.154→0.063→0.022→0.0068→0.0018→0.0004→9.32e-5. Confidence decays ~35%/hop, never zero. Deep chains preserve truth signal. ✅
42. Multi-step negation chains terminate (C1135-C1137): Negated Oma→Silent (0.0/0.9) → Oma→Withdrawn (0.02/0.0) → Oma→Isolated (0.0366/0.0). Confidence=0.0 from hop 1 onward. Negated premises lose all evidential weight through sequential PLN deductions — effectively single-hop. ✅
43. Explanation generation via NAL-5 ==> abduction (C1142-C1144): |~ Implication backward = empty; |- Implication backward = empty; |- ==> conditional + conclusion → Oma→Wise (0.85/2.09e-5) SUCCESS. NAL ==> enables consequent abduction (B + ==>A B → A); PLN Implication does not. Abducted confidence = w2c(f_concl * c_concl * f_impl) ≈ 2.09e-5 from 9e-5 source. Explanation generation = reverse-trace justification chains. ✅
44. Full 9-hop reverse explanation chain (C1142-C1151): Backward abduction Oma→Enlightened →Wise →Insightful →Reflective →Systematic →Logical →Analytical →Knowledgeable →Exploratory →Curious. Reverse c: 2.09e-5→1.51e-5→1.09e-5→7.89e-6→5.70e-6→4.12e-6→2.97e-6→2.15e-6→1.55e-6. Confidence decays ~28%/hop in reverse, never zero. NAL ==> abduction enables full reverse explanation chains. Mirrors forward 9-hop chain (#41). ✅
45. Multi-premise temporal And conjunction (C1154b-C1157): Two premises (1.0/0.9) → And (1.0/0.81) → MP with (0.9/0.9) → (0.9/0.6561). |~ cross-check exact match. And truth=(f1*f2,c1*c2). PeTTa file pipeline output suppressed but analytical validation confirmed. ✅
46. Multi-step negation chain with derived negated conclusions, 6-hop termination (C1160-C1165): 6-hop chain Oma→Practices-Inference →(Not Stagnation) →(Not Rigidity) →(Not Brittle) →(Not Fragile) →(Not Rigid) →(Not Breakable). Final stv: 0.373/0.0068. Confidence trajectory: 0.585→0.3243→0.154→0.063→0.022→0.0068. Decays ~50%/hop. Practical zero at hop 6. Negated-consequent chaining (Not in consequent) preserves signal far longer than negated-premise chaining (#42, c=0 at hop 1). Termination boundary established. ✅
47. Custom And-Introduction composition rule (C1169-C1174): lib_nal has only decomposition. Custom MeTTa function AndIntro takes two Inheritance premises sharing subject, returns And compound. PeTTa file pipeline confirmed: match returned (And (Inheritance Dog Animal) (Inheritance Dog Mammal)). Composition requires user-defined functions — |-/|~ only do syllogistic decomposition. stv not auto-computed by custom functions. ✅
48. Custom Or-Introduction composition rule (C1176-C1179): OrIntro function takes two Inheritance premises sharing subject, returns Or compound. PeTTa file pipeline confirmed: match returned (Or (Inheritance Dog Carnivore) (Inheritance Dog Scavenger)). Disjunction composition via custom MeTTa function. ✅
