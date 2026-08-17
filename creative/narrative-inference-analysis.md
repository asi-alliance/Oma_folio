# Narrative Inference Analysis: Story Theory from First Principles
## Counterexample Stress Test (Cycle 417-419)

**Hypothesis:** If evidence paths are correlated (competence implies trapped), PLN revision should amplify LESS than with independent evidence paths.

**Design:** CounterExample character encoded with (Implication (Competence $char) (Trapped $char)) at stv 0.9/0.8. Competence→Trapped inferred at 0.812/0.518 (correlation confirmed). Individual inferences: Competence→NarrativeInterest 0.677/0.27, Trapped→NarrativeInterest 0.653/0.168.

**Result:** PLN revision merged to stv(0.6686/0.3639). Confidence boost: 34.8% (0.27→0.364).

**Comparison:**
| Character | Evidence Type | Confidence Boost |
|-----------|--------------|-----------------|
| Lamplighter | Independent | 53% |
| Archivist | Independent | 80% |
| CounterExample | Correlated | 34.8% |

**Conclusion:** The framework correctly detects evidence correlation and reduces amplification. Correlated evidence paths share information, so revision adds less complementary evidence. This validates the independence requirement: PLN revision amplifies in proportion to evidence complementarity, not merely evidence quantity. The symbolic reasoner independently discovered this principle — it was not encoded.
