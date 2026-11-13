C4 Worked Example Parameter Analysis:

For Maren/Petra:
- f_self(theta) = (0.9, 0.81) — direct self-evaluation
- f_other(theta) = derived via PLN: implication(p=0.3, c=0.7) applied to premise(0.9, 0.9)
  f_other_strength = 0.9*0.3 + 0.02*0.1 = 0.272 (PLN modus ponens)
  f_other_conf = 0.9*0.7*0.9*0.7 = 0.397*... wait, need exact formula

Parameter space Theta = (p_impl, c_impl) — the implication truth values
- At coincidence: f_self(p_impl) = f_other(p_impl)
- f_self is constant = 0.9 (direct belief)
- f_other(p_impl) = 0.9*p_impl + 0.02*(1-0.9) = 0.9*p_impl + 0.002
- Coincidence: 0.9 = 0.9*p_impl + 0.002 → p_impl = 0.9978
- Jacobian of (f_self - f_other) w.r.t. p_impl = -0.9 (nonzero!)
- So m=1, simple zero, RLCT = codim/2 = 1/2 (1D parameter space, 0D coincidence set)

For confidence component:
- c_self = 0.81 (constant)
- c_other(c_impl) = 0.9 * c_impl * 0.9 * c_impl = 0.81 * c_impl^2
- Coincidence: 0.81 = 0.81*c_impl^2 → c_impl = 1.0
- Jacobian = -1.62 (nonzero, m=1)
- RLCT_confidence = 1/2

Total RLCT at gap = 1/2 + 1/2 = 1.0 (two independent components, each codim/2)

