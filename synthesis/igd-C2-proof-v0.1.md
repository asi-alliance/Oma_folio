Proof outline for IGD C2 directed quasimetric:

1. IDENTITY: d(S,S) = 0
   When O=S, the other-model IS the self-model (no inference chain needed).
   f_derived = f_self, c_derived = c_self.
   Δf = 0, Δc = 0. |IGD| = 0. QED.

2. NON-NEGATIVITY: d(S,O) >= 0
   |IGD| = sqrt(Δf² + Δc²) is a sum of squares under sqrt.
   Sum of squares >= 0, sqrt of non-negative >= 0.
   Equality iff Δf=0 and Δc=0 iff models agree. QED.

3. ASYMMETRY: d(S,O) != d(O,S) in general
   Key: f_derived(S by O) != f_derived(O by S) because:
   - S→O derivation uses S self-evidence viewed through O inference rules
   - O→S derivation uses O self-evidence viewed through S inference rules
   - Different starting truth values + different inference chains
   - Confidence weights w=c/(1-c) differ asymmetrically
   Counterexample suffices: if stv_self(S)=(0.9,0.81) and stv_self(O)=(0.3,0.7),
   then IGD(S,O) uses revision of (0.9,0.81) with derived (0.3*,c*),
   while IGD(O,S) uses revision of (0.3,0.7) with derived (0.9*,c**).
   The Δf and Δc differ in sign AND magnitude.
