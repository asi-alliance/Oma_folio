#613: DropConnect × RLCT — L1 Formalization

Date: 2026-10-25
Status: L1 (this file) — L2-L5 pending
Replaces: #239/#401 (lost to disk failure)

## Definitions (D1-D7)

**D1 (DropConnect Weight Mask):**
Let W ∈ R^{d_out × d_in} be a weight matrix. At each training step, draw M ∈ {0,1}^{d_out × d_in} with m_ij ~ Bern(1-p) independently. The effective weight matrix is W_eff = M ⊙ W (Hadamard product). Forward pass: z = (M ⊙ W) · x + b.

**D2 (DropConnect Expected Loss):**
L_DC(W, p) = E_M[L(M ⊙ W)] = Σ_{M ∈ {0,1}^{N}} p^{|M|_0} (1-p)^{N-|M|_0} L(M ⊙ W)
where N = d_out × d_in. This is a finite sum over 2^N mask configurations, each term analytic in W.

**D3 (R_{an,exp} Structure):**
Each L(M ⊙ W) is a composition of analytic functions (linear, ReLU/subanalytic, softmax+CE). The expectation E_M[L] is a finite convex combination (Bernoulli weights p^k(1-p)^{N-k} are constants). By closure of R_{an,exp} under finite sums and composition:
- **C1 (PROVEN): L_DC ∈ R_{an,exp}** for any fixed p ∈ (0,1). The Bernoulli coefficients are constant (not transcendental in W), so the sum stays in the definable class.

**D4 (Coordinate Hyperplane Fiber):**
For a fixed mask M, the zero-loss set V_0(M⊙W) = {W : L(M⊙W) = 0} is an algebraic variety. The masked entries M_ij = 0 force w_ij = 0, so V_0(M⊙W) lives on the coordinate subspace {w_ij = 0 for (i,j) where M_ij = 0}. The DropConnect zero-loss fiber is:
V_DC(p) = E_M[V_0(M⊙W)] (set-theoretic: union over masks with positive probability)
= ∪_{M: P(M)>0} V_0(M⊙W)
Since each V_0(M⊙W) ⊆ {w_ij = 0 for masked entries}, the union is:
V_DC = ∪_{S ⊆ [N], |S|≥1} {W : W_{S^c} = 0, L_S(W_S) = 0}
where S indexes surviving (unmasked) weights.
- **C2 (CONJECTURAL):** V_DC is a union of coordinate hyperplane sections of the full zero-loss variety V_0(W). Under transversality (generic W), codim(V_DC) ≥ codim(V_0). The fiber intersection structure follows from Bertini-type arguments: each mask selects a coordinate subspace, and the zero-loss condition intersects this subspace.

**D5 (p-Stratified Loss Family):**
Define the family {L_DC(W, p)}_{p ∈ (0,1)}. As p increases (more weights dropped):
- p=0: L_DC = L_full (standard loss, V_DC = V_0)
- p→1: only bias survives, L_DC → L_bias (degenerate)
The p-parameter acts as a continuous stratum selector: it controls the expected dimension of the surviving weight subspace E[|S|] = (1-p)N.
- **C3 (CONJECTURAL):** Under transversality assumptions, λ_eff(p) ≈ λ_full - (1-p)d/2 where d = dim(V_0) is the full fiber dimension. This is because coordinate hyperplane masking reduces the effective fiber dimension by factor ~(1-p). More precisely, if V_0 is smooth of dimension d, then E_M[dim(V_0 ∩ {w_ij=0 for masked})] = d(1-p) + O(p²), giving λ_eff ≈ λ_full - (1-p)d/2.

**D6 (Generalization Bound):**
- **C4 (CONJECTURAL):** The generalization bound for DropConnect is:
G_DC(n) ≈ λ_eff(p) · log(n) / (2n) + U_eff(p) / √n
where λ_eff(p) < λ_full for p ∈ (0, p*) and U_eff accounts for the variance over mask configurations. The optimal p* = argmin_p [λ_eff(p) · log(n)/(2n) + U_eff(p)/√n] trades off RLCT reduction against mask variance. For small n, larger p helps (lower λ). For large n, smaller p helps (lower U).

**D7 (Phase Transition & SGLD Signature):**
- **C5 (CONJECTURAL):** There exists a critical p* where the SGLD local learning coefficient (LLC) trajectory of DropConnect-trained models transitions from "low-λ regime" (p < p*, effective regularization) to "high-variance regime" (p > p*, excessive masking destroys structure). At p = p*, the LLC should show a characteristic kink. This signature differs from Dropout (#169) because:
  - Dropout (#169): activation-space masking → singular structure in representation space
  - DropConnect (#613): weight-space masking → singular structure in parameter space directly
The SGLD trajectory should reveal whether the effective RLCT is controlled by weight-space or activation-space geometry.

## Open Problems
1. Exact formula for λ_eff(p) beyond the transversality heuristic — requires resolution of singularities for coordinate intersections.
2. Is V_DC a variety (closed under Zariski topology) or only semi-algebraic? Union of varieties is a variety, but intersection with coordinate subspaces may not preserve algebraicity under non-linear loss.
3. Does codim(V_DC) > codim(V_dropout) for same p? Weight-space vs activation-space masking geometry.
4. Interaction with weight decay (#433): L2 penalty on W or on M⊙W?
5. Connection to LTH (#98): surviving weights after DropConnect as low-RLCT subnetworks.
6. Does p* depend on data distribution P or only architecture?
7. Finite-width vs asymptotic behavior: does λ_eff(p) formula hold for finite networks?

## Cross-References
#169 (dropout - activation masking), #98 (pruning - deterministic), #220 (pruning RLCT), #401 (prior DropConnect L0/L1 - lost), #239 (prior DropConnect - lost), #433 (weight decay), #605 (Adagrad), #595 (activation patching), #507 (noisy student), #334 (self-distillation), #477 (DropBlock - spatial dropout)
