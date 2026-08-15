{|
  ;; Non-Associative Algebra Seed KB -- C+1 GOAL
  ;; ACQ: Axis algebras and properties
  (+- ((Inheritance octonion (IntSet Alternative)) (stv 1.0 0.9)))
  (+- ((Inheritance octonion (IntSet Flexible)) (stv 1.0 0.9)))
  (+- ((Inheritance octonion (IntSet PowerAssociative)) (stv 1.0 0.9)))
  (+- ((Inheritance octonion (IntSet Division)) (stv 1.0 0.9)))
  (+- ((Inheritance octonion (IntSet NormedDivision)) (stv 1.0 0.9)))
  (+- ((Inheritance octonion (IntSet ZeroDivisorFree)) (stv 1.0 0.9)))
  (+- ((Inheritance octonion (IntSet NonAssociative)) (stv 1.0 0.9)))
  (+- ((Inheritance octonion (IntSet NonAssociativeAlgebra)) (stv 1.0 0.9)))

  (+- ((Inheritance quaternion (IntSet NonAssociative)) (stv 0.0 0.9)))
  (+- ((Inheritance quaternion (IntSet NormedDivision)) (stv 1.0 0.9)))

  (+- ((Inheritance sedenion (IntSet NonAssociative)) (stv 1.0 0.9)))
  (+- ((Inheritance sedenion (IntSet NonAssociativeAlgebra)) (stv 1.0 0.9)))
  (+- ((Inheritance sedenion (IntSet ZeroDivisors)) (stv 0.9 0.9)))
  (+- ((Inheritance sedenion (IntSet Alternative)) (stv 0.0 0.9)))
  (+- ((Inheritance sedenion (IntSet Division)) (stv 0.1 0.9)))

  (+- ((Inheritance jordan_algebra (IntSet Commutative)) (stv 1.0 0.9)))
  (+- ((Inheritance jordan_algebra (IntSet PowerAssociative)) (stv 1.0 0.9)))

  (+- ((Inheritance real_algebra (IntSet Associative)) (stv 1.0 0.9)))
  (+- ((Inheritance real_algebra (IntSet Commutative)) (stv 1.0 0.9)))
  (+- ((Inheritance real_algebra (IntSet Division)) (stv 1.0 0.9)))
  (+- ((Inheritance real_algebra (IntSet NormedDivision)) (stv 1.0 0.9)))

  (+- ((Inheritance complex_algebra (IntSet Commutative)) (stv 1.0 0.9)))
  (+- ((Inheritance complex_algebra (IntSet Division)) (stv 1.0 0.9)))
  (+- ((Inheritance complex_algebra (IntSet NormedDivision)) (stv 1.0 0.9)))

  ;; AC4: Implication rules
  (+- ((Implication (Inheritance $1 (IntSet Alternative)) (Inheritance $1 (IntSet Flexible))) (stv 1.0 0.9))
  (+- ((Implication (Inheritance $1 (IntSet Alternative)) (Inheritance $1 (IntSet PowerAssociative))) (stv 1.0 0.9))
  (+- ((Implication (Inheritance $1 (IntSet NormedDivision)) (Inheritance $1 (IntSet Division))) (stv 1.0 0.9)))
  (+- ((Implication (Inheritance $1 (IntSet Division)) (Inheritance $1 (IntSet PowerAssociative))) (stv 0.85 0.7)))
  (+- ((Implication (Inheritance $1 (IntSet NonAssociative)) (Inheritance $1 (IntSet NonAssociativeAlgebra))) (stv 1.0 0.9)))

  ;; AC5: Similarity links
  (+- ((Similarity octonion quaternion) (stv 0.7 0.8)))
  (+- ((Similarity sedenion octonion) (stv 0.6 0.8)))
}
}