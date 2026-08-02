)
(= (pontryagin_maximum_principle $H $u $x $lambda $T) (and (hamiltonian $H $u $x $lambda) (== (dy_dx $x) (partial_deriv $H $lambda)) (== (dy_dx $lambda) (partial_deriv $H $x)) (forall $t (== ($H $u_opt $x $lambda) (max $H $u $x $lambda)))))
