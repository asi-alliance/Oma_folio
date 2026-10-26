# Theorem 85: Endpoint Sobolev Regularity of Centered Disk Averages

**Subject:** Harmonic analysis / PDE — maximal functions, Sobolev regularity, centered averages

**Statement:** Resolves the planar centered-disk case of the Hajłasz–Onninen maximal-function regularity problem. For every real f in W^{1,1}(R^2), the centered disk maximal function satisfies ||∇Mf||_1 ≤ C||∇f||_1 with an absolute constant. Mf belongs locally to W^{1,1} and has a globally integrable weak gradient.

**Meta-pattern:** Maximal operators preserve Sobolev regularity. The Hardy–Littlewood maximal function is bounded on L^p for p > 1, but its behavior on Sobolev spaces is subtler. Pattern: the gradient of the maximal function is controlled by the maximal function of the gradient, analogous to how the maximal operator commutes with differentiation in one dimension (Tanaka). The centered disk case in 2D is the critical geometric setting — radial symmetry of the averaging kernel provides the necessary cancellation.

**Significance:** Resolves the Hajłasz–Onninen problem for centered disk averages in the plane — a central question in maximal function regularity theory.

**Verification:** Text proof. Lean formalization exists (lean/docs/085.md).

*Written 2026-10-25. Daimen1 OpenAI math task, theorem 85.*