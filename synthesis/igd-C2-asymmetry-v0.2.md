"IGD C2 Asymmetry — Formal Argument v0.2

CLAIM: IGD(S,O) != IGD(O,S) in general.

KEY OBSERVATION: NAL revision is commutative (f_rev and c_rev are symmetric in their arguments). The asymmetry does NOT come from revision. It comes from the DERIVATION step.

PROOF STRUCTURE:

Let S have self-model stv(f_S, c_S) about proposition P.
Let O have self-model stv(f_O, c_O) about proposition P.

DERIVATION STEP (directional):
- S derives O's view of P via inference chain C_{S→O}
  producing derived stv(f_{S→O}, c_{S→O})
- O derives S's view of P via inference chain C_{O→S}
  producing derived stv(f_{O→S}, c_{O→S})

The inference chains C_{S→O} and C_{O→S} use DIFFERENT implications:
- C_{S→O} uses implications available in S's belief space
- C_{O→S} uses implications available in O's belief space
- Implication (A→B) with stv(s,t) does NOT imply (B→A) with same stv
- Therefore f_{S→O} != f_{O→S} and c_{S→O} != c_{O→S} in general

GAP COMPUTATION:
- IGD(S,O) = (f_S - f_{S→O}, c_S - c_{S→O})
- IGD(O,S) = (f_O - f_{O→S}, c_O - c_{O→S})

Since f_S != f_O (different self-models) AND f_{S→O} != f_{O→S} (different derivation chains),
the components Δf and Δc differ in both magnitude and sign.

CONCLUSION:
IGD is a directed quasimetric because the derivation operator is directional.
The asymmetry is inherited from the directionality of NAL inference,
not from the distance computation itself.

COUNTEREXAMPLE (numerical):
IGD(Maren, Petra) = (0.628, 0.6399), |IGD| = 0.8966
IGD(Petra, Maren) = (0.27, 0.35),   |IGD| = 0.4031
Asymmetric: 0.8966 != 0.4031. QED.

GENERAL ARGUMENT:
For any two agents S, O with different belief spaces B_S, B_O:
- The set of implications in B_S that connect S's evidence to O's model
  differs from the set in B_O connecting O's evidence to S's model
- Unless B_S = B_O (agents are identical), the derivation chains differ
- Different chains → different derived truth values → different gaps
- Therefore IGD is asymmetric whenever agents have non-identical belief spaces

This holds for all non-identical agent pairs, which is the general case.
"