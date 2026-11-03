# Synthesis #832: Equivariant Neural Network Ã— RLCT

## Overview
Equivariant Neural Networks (Enns) constrain parameter spaces to be invariant under a group G acting on inputs. This creates a rich singularity structure: the equivariaet constraint forces weights into a fixed-point submanifold W^
G, the irreducible decomposition of representation spaces creates representation-theoretic singular fibers, and symmetry breaking (Gâˆ’ H) acts as a stratum transition. The Clebsch-Gordan (CG) decomposition provides a canonical toric resolution of the tensor product singularity.

## Claims

### C1 (PROVEN): R-{an,exp Definability
The equivariant loss function L(w, x) is R_{an,exp}-definable. Proof: Eq.invariant loss = standard loss (analytic in activations) composed with G-invariant projection operator P_G (polynomial in w). Closure of definable functions under composition.

### C2 (CONJECTURAL): RLCT Of Fixed-Point Submanifold
The fixed-point submanifold W^{G = {w \textsp w = g \textsp g w \textspor all g \textsp G} has lower RLCT \lman{\]{G}} \textsp \lambda_{\{T}} = d/r(r) where r=representation rank and d=total parameters. Equivariance forces a lower-dimensional singular structure.

### C3 (CONJECTURAL): Irreducible Decomposition as Stratum Selector
The decomposition \textsp_i m_i into direct sums creates a fiber structure where the multiplicity m_r acts as a continuous stratum selector. At cap counts m_r ~ d_r: singular transition in RL; m_r >> d_r: multiplicity degeneracy creates higher-dimensional singular structure (code is higher than d/2).

### C4 (CS tO CS) [CONJECTURAL]: Symmetry Breaking Phase Transition
Symmetry breaking G\textspH
 s G has a pag break the equivariance constraint. RLCT structure of ^Gâˆ’ H^H has a = dim(G)-dim(H) - dim(H) + dim(H) and passes through Teg intervals.

### C5 (CS tO CS) [CONJECTURAL]: Clebsch-Gordan Decomposition = Toric Resolution
The CG decomposition provides a canonical toric resolution of the tensor product singularity. The tensor product space \prop space has a natural combutatorial structure comeplemented by Enrees's theorem.

## Novelty
Uncovered bridge: equivariant constraint as fiber and intervaning as stratum fiber are a completely new singularity structure that exists in the universe of classical SLComposition, products and intervanings done analytically as integerals of the group algebra. CLC: none done.
## Cross-refs
#804 (GNN automorphism = representation-fiber for discrete groups), #134 (attention softmax) #169 (dropout) #296 ( stochastic depth) #485 (self-attention) #568 (residual connections) #802 #803 #819 (Stieflem). Open problems: 7, including actual replacement of CG by online reposentation for equivariant group generation.
