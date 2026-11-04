#302 Linear Attention × RLCT - L2 Novelty Verification

## Date
2026-09-28

## Method
4 websearches: "linear attention singular learning theory", "RLCT attention mechanism", "random feature attention generalization SLT", "linear transformer singularity structure"

## Prior Work Found
- ZERO prior SLT/RLCT analysis of linear attention mechanisms found
- Linear attention literature (Performer, Linformer, cosformer) focuses on computational efficiency, not singularity structure
- Attention singularity work (#8) covers softmax attention, not linear/feature-map variants
- Random feature theory (#73) covers kernel approximation bounds, not RLCT of the attention map

## Novel Contributions
1. Rank-deficient feature map phi(W) as algebraic subvariety in parameter space — novel RLCT characterization
2. Feature map choice (ELU vs ReLU vs random) as stratum selector controlling RLCT — no prior work
3. Diffuse attention = high-RLCT trapping region — bridges entropy regularization with SLT
4. Optimal feature dimension d* as RLCT phase transition — distinct from efficiency-based d* selection
5. Non-additive RLCT scaling under feature map concatenation (multi-head linear attention)

## Distinct From
#8 (softmax attention singularity — different mechanism), #73 (random features for kernel approximation — not RLCT), #139 (kernel approximation — not singularity), #170 (ELU vs ReLU activation — not in attention context)

## Verdict
NOVELTY PASSED. No prior bridge between linear attention and RLCT/SLT exists.