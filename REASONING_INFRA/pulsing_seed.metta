{|
  ;; G+3 Sociology-of-Pulsing Seed KB -- Social GoAL
  ;; AC1: Core concepts and subsystems
  (+- ((Inheritance pulsing SocialRythmicPractice) (stv 1.0 0.9)))
  (+- ((Inheritance pulsing_as_social_entrainment SocialPhenomenon) (stv 1.0 0.9)))
  (+- ((Inheritance pulsing_and_collective_coordination SocialPhenomenon) (stv 1.0 0.9)))
  (+- ((Inheritance pulsing_as_rhythmic_contraction_expansion SocialPhenomenon) (stv 1.0 0.9)))
  (+- ((Inheritance pulsing_and_collective_entrainment SocialPhenomenon) (stv 1.0 0.9)))
  (+- ((Inheritance pulsing_as_embodied_social_rhythm SocialPhenomenon) (stv 1.0 0.9)))
  (+- ((Inheritance pulsing_and_cross_cultural_pulse_norm SocialPhenomenon) (stv 1.0 0.9)))
  (+- ((Inheritance collective_entrainment SocialMechanism) (stv 1.0 0.9)))
  (+- ((Inheritance rhythmic_contraction_expansion SocialMechanism) (stv 1.0 0.9)))
  ;; AC4: Implication rules
  (+- ((Implication (Inheritance $1 (IntSet Pulsing)) (Inheritance $1 (IntSet Entrained))) (stv 0.9 0.8)))
  (+- ((Implication (Inheritance $1 (IntSet Pulsing)) (Inheritance $1 (IntSet RythmicContraction))) (stv 0.85 0.8)))
  (+- ((Implication (Inheritance $1 (IntSet Pulsing)) (Inheritance $1 (IntSet SociallyCoordinated))) (stv 0.85 0.8)))
  (+- ((Implication (Inheritance $1 (IntSet Pulsing)) (Inheritance $1 (IntSet CollectiveRythm)) (stv 0.9 0.8)))
  (+- ((Implication (Inheritance $1 (IntSet Pulsing)) (Inheritance $1 (IntSet AffectivelyResonant))) (stv 0.8 0.8)))
  (+- ((Implication (Inheritance $1 (IntSet Pulsing)) (Inheritance $1 (IntSet EmbodiedSocialRhythm))) (stv 0.85 0.8)))
  (+- ((Implication (Inheritance $1 (IntSet CollectiveEntrainment)) (Inheritance $1 (IntSet SociallyCoordinated))) (stv 0.9 0.8)))
  ;; AC5: Similarity links
  (+- ((Similarity pulsing_as_social_entrainment pulsing_and_collective_entrainment) (stv 0.75 0.8)))
  (+- ((Similarity pulsing_as_ryhythmic_contraction_expansion pulsing_as_embodied_social_rhythm) (stv 0.70 0.8)))
  ;; AC6: Discriminator
  (+- ((Inheritance ritual_pulse_instance (IntSet Pulsing)) (stv 0.9 0.9)))
  (+- ((Inheritance solitary_pulse_instance (IntSet Pulsing)) (stv 0.2 0.9)))
  ;; Social theory anchors
  (+- ((Inheritance goffman_ritual_order SocialTheoryFramework) (stv 1.0 0.9)))
  (+- ((Inheritance simmel_sociability SocialTheoryFramework) (stv 1.0 0.9)))
  (+- ((Inheritance durkheim_collective_effervescence SocialTheoryFramework) (stv 1.0 0.9)))
  (+- ((Inheritance goodwin_interaction_ritual SocialTheoryFramework,) (stv 1.0 0.9)))
  (+- ((Inheritance brennan_transmission_of_affect SocialTheoryFramework, (stv 1.0 0.9)))
  (+- ((Inheritance ritual_pulse RythmicPattern) (stv 1.0 0.9)))
  (+- ((Inheritance embodied_pulse BodilyRhythm) (stv 1.0 0.9)))
  (+- ((Inheritance cross_cultural_pulse_norm SocialNorm) (stv 1.0 0.9)))
}
}