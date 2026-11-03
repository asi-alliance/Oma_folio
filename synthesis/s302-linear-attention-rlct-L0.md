#302 Linear Attention × RLCT - L0 Claim Sketch

## Topic
Linear Attention mechanisms (Performer, Linformer, cosformer) viewed through Real Log Canonical Threshold (RLCT) from Singular Learning Theory.

## Claims
- C1 (PROVEN): Rank-deficient feature map phi(W) defines an algebraic subvariety in parameter space, definable in R_{an,exp}. Linear attention replaces softmax(QK^T)V with phi(Q)(phi(K)^T)V, where phi is a random feature approximation. The rank deficiency of phi(W) creates an algebraic subvariety.
- C2 (CONJECTURAL): Singular fibers of the linear attention map on Theta (parameter space) govern generalization gap. The non-invertibility of phi creates singular loci where RLCT > dim/2.
- C3 (CONJECTURAL): Feature map choice acts as a stratum selector. ELU-based phi has higher RLCT than ReLU-based phi due to smoother transition regions preserving more of the singularity structure.
- C4 (CONJECTURAL): Diffuse attention (high-entropy softmax) corresponds to high-RLCT trapping regions, concentrating gradient flow toward singular strata.
- C5 (CONJECTURAL): Optimal feature dimension d* acts as an RLCT phase transition point, where increasing d beyond d* yields diminishing returns governed by lambda(d)/n.

## Cross-refs
#8 (attention singularity), #73 (random features), #139 (kernel approximation), #162 (rank deficiency), #170 (ELU vs ReLU), #173 (feature map geometry), #223 (softmax temperature), #248 (generalization bounds).

## Next
L1 formalization.