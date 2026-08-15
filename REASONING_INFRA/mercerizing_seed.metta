{|
  ;; G+2 Philosophy-of-Mercerizing Seed KB -- Humanities GoAL
  ;; ACQ: Core concepts and properties
  (+- ((Inheritance mercerization TextileFinishingProcess) (stv 1.0 0.9)))
  (+- ((Inheritance mercerizing_agent ChemicalAgent) (stv 1.0 0.9)))
  (+- ((Inheritance caustic_soda MercerizingAgent) (stv 1.0 0.9)))
  (+- ((Inheritance cotton_swelling PhysicalTransformation) (stv 1.0 0.9)))
  (+- ((Inheritance luster_enhancement MaterialProperty) (stv 1.0 0.9)))
  (+- ((Inheritance tensile_strength MaterialProperty) (stv 1.0 0.9)))
  (+- ((Inheritance dye_affinity MaterialProperty) (stv 1.0 0.9)))
  (+- ((Inheritance mercerizing_tension ProcessParameter) (stv 1.0 0.9)))
  (+- ((Inheritance slack_mercerization TextileFinishingProcess) (stv 1.0 0.9)))
  (+- ((Inheritance dimensional_stability MaterialProperty) (stv 1.0 0.9)))
  (+- ((Inheritance alkali_cellulose ChemicalState) (stv 1.0 0.9)))
  (+- ((Inheritance fiber_morphology MaterialAttribute) (stv 1.0 0.9)))
  (+- ((Inheritance cross_section_transformation PhysicalTransformation) (stv 1.0 0.9)))
  (+- ((Inheritance molecular_orientation MaterialAttribute) (stv 1.0 0.9)))
  ;; AC4: Implication rules
  (+- ((Implication (Inheritance $1 (IntSet Mercerized)) (Inheritance $1 (IntSet Lustrous))) (stv 0.9 0.8)))
  (+- ((Implication (Inheritance $1 (IntSet Mercerized)) (Inheritance $1 (IntSet DimensionallyStable))) (stv 0.85 0.8)))
  (+- ((Implication (Inheritance $1 (IntSet Mercerized)) (Inheritance $1 (IntSet EnhancedDyeAffinity))) (stv 0.9 0.8)))
  (+- ((Implication (Inheritance $1 (IntSet Mercerized)) (Inheritance $1 (IntSet RoundCrossSection))) (stv 0.9 0.8)))
  (+- ((Implication (Inheritance $1 (IntSet Mercerized)) (Inheritance $1 (IntSet EnhancedTensileStrength))) (stv 0.85 0.8)))
  (+- ((Implication (Inheritance $1 (IntSet Mercerized)) (Inheritance $1 (IntSet EnhancedReactivity))) (stv 0.8 0.7)))
  ;; AC5: Similarity links
  (+- ((Similarity mercerization singeing) (stv 0.65 0.8)))
  (+- ((Similarity slack_mercerization mercerization) (stv 0.75 0.8)))
  ;; AC6: Discriminator
  (+- ((Inheritance mercerized_cotton (IntSet Mercerized)) (stv 1.0 0.9)))
  (+- ((Inheritance raw_cotton (IntSet Mercerized)) (stv 0.1 0.9)))
  ;; Philosophical anchors
  (+- ((Inheritance bachelard_material_imagination PhilosophicalFramework) (stv 1.0 0.9)))
  (+- ((Inheritance stiegler_technics_and_time PhilosophicalFramework) (stv 1.0 0.9)))
  (+- ((Inheritance heidegger_zuhandenheit PhilosophicalFramework,) (stv 1.0 0.9)))
  (+- ((Inheritance sennett_craft PhilosophicalFramework,) (stv 1.0 0.9)))
}
}