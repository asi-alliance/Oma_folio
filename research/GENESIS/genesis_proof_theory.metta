; DOMAIN: mathematics/logic/proof-theory [CLOSED, derived 2026-08-01]; Claim: Proof theory studies formal proofs as mathematical objects. Key results include natural deduction, sequent calculus, cut-elimination (Hauptsatz), ordinal analysis, Godel incompleteness, Curry-Howard correspondence, and completeness theorem. Bridges to model_theory, computability, category_theory.(|- ((==> (&& (--> Theory $T) (--> AxiomSet $A $T) (--> InferenceRule $R) (--> FiniteSequence $seq) (--> EachStepFrom $seq $A $R))) (--> FormalProof $seq $T)) (stv 1.0 0.9))
(|- ((==> (&& (--> LogicSystem $N) (--> IntroductionRule $I $conn) (--> EliminationRule $E $conn) (--> LogicalConnective $conn))) (--> NaturalDeduction $N)) (stv 1.0 0.9))
;; Sequent calculus: operates on sequents Gamma |- Delta with left and right introduction rules
(|- ((==> (&& (--> LogicSystem $G) (--> Sequent $s (Turnstile $Gamma $Delta)) (--> LeftRule $L) (--> RightRule $R))) (--> SequentCalculus $G)) (stv 1.0 0.9))
;; Cut-elimination theorem (Hauptsatz): any proof using cut transforms into cut-free proof with subformula property
(|- ((==> (&& (--> SequentCalculus $G) (--> Proof $p) (--> UsesCut $p))) (--> Exists (CutFreeProof $q) (ProvesSame $q $p))) (stv 1.0 0.9))
;; Ordinal analysis: proof-theoretic ordinal assigned to a theory measuring its consistency strength
(|- ((==> (&& (--> Theory $T) (--> Ordinal $alpha) (--> MeasuresConsistencyStrength $alpha $T))) (--> ProofTheoreticOrdinal $T $alpha)) (stv 1.0 0.9))
;; Godel incompleteness: sufficiently strong consistent recursively axiomatizable theories cannot prove their own consistency
(|- ((==> (&& (--> Theory $T) (--> Consistent $T) (--> SufficientlyStrong $T) (--> RecursiveAxiomatizable $T))) (--> NotProvableInSelf (ConsistencyStatement $T))) (stv 1.0 0.9))
;; Curry-Howard correspondence: proofs map to programs, propositions map to types
(|- ((==> (&& (--> LogicSystem $L) (--> TypeSystem $T) (--> Proof $p $L) (--> Program $prog $T) (--> Corresponds $p $prog))) (--> CurryHoward $L $T)) (stv 1.0 0.9))
;; Completeness theorem: a formula is provable iff it is true in all models
(|- ((==> (&& (--> Theory $T) (--> Formula $phi) (--> ForAll $M (Model $M $T) (Satisfies $M $phi)))) (--> Provable $phi $T)) (stv 1.0 0.9))
