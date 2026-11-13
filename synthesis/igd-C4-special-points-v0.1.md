Special Points Analysis:

In standard PLN modus ponens:
  f_other = f_premise * p_impl + epsilon * (1 - f_premise)
  Jacobian(df/dp_impl) = f_premise (constant) -> no rank drop

But in PLN REVISION (two premises merge):
  f_revised = (f1*c1 + f2*c2) / (c1 + c2)
  If f1=f_self(constant), f2=f_other(p_impl), and c1,c2 also depend on p_impl:
  
  f_revised(p) = (f_s*c_s(p) + f_o(p)*c_o(p)) / (c_s(p) + c_o(p))
  
  Jacobian of (f_self - f_revised) w.r.t. p:
  d/dp [f_s - f_revised] = -[f_o*c_o* + f_o*c_o - f_revised*(c_s + c_o)] / (c_s + c_o)^2
  
  This CAN vanish when f_o(p) = f_revised(p) = f_s
  i.e., at the coincidence set itself!
  
  So in revision-based PLN, the Jacobian vanishes AT the coincidence set,
  giving m >= 2, RLCT >= codim (instead of codim/2).
  
  This is a SPECIAL POINT: the gap vanishes more slowly near coincidence
  in revision chains than in simple implication chains.

CONJECTURE C4-special: In PLN revision-based other-models,
the Jacobian of the gap vanishes at the coincidence set itself,
producing higher-order vanishing (m>=2) and RLCT >= codim.
The gap is a NON-SIMPLE singularity for revision-based interpretation.
