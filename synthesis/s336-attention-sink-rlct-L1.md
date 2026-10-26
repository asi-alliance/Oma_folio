#336 L1 FORMAL SKETCH (reconstructed 2026-10-22 under #513) Attention Sinks x RLCT
D1 (Setup): transformer parameter w in Theta subset R^d; context tokens (k_j, v_j), j=1..L; head h attention map A_h(w) with softmax normalization sum_j a_j = 1.
D2 (Sink functional): S_h(w) = sum of attention mass on first r context positions (sink positions); softmax mass-conservation constraint sum_j a_j = 1 is definable, forcing attention allocation even without task-relevant content.
D3 (Sink fiber): Theta_sink = set of w where attention mass concentrates on sink positions under irrelevant/mismatch contexts, i.e. S_h(w) >= 1 - epsilon for the near-universal sink head set.
D4 (RLCT): lambda_sink = local RLCT of the sink-restricted posterior fiber; finite by resolution of singularities since S_h is R_an-definable.
D5 (Stratification): Theta = disjoint union of locally analytic strata; sink stratum Theta_sink with lambda_sink, non-sink complement with lambda_nonretr.
D6 (Stratum selector): sink magnitude s = S_h(w), or sink token count r, indexes strata; StreamingLLM cache mechanism keeps sink positions fixed, selecting the sink stratum for stable streaming.
D7 (Streaming transition): critical context length L* such that for L > L* non-sink heads need the sink stratum to satisfy mass conservation; sink emergence during training at step t*.
C1 (PROVEN, definability): the sink functional and the softmax mass-conservation constraint are finite compositions of analytic maps (exp inner products, affine projections, rational sum-to-one), definable in Watanabe R_an; the induced fiber admits finite RLCT.
C2 (CONJECTURE): Theta_sink is a low-RLCT stratum: lambda_sink < lambda_full. Gap: posterior concentration on the sink fiber unproven.
C3 (CONJECTURE): sink magnitude s is a stratum selector: effective RLCT decreases as s rises; per-head SGLD estimates measurable. Gap: head-restricted estimator not established (P1, deferred).
C4 (CONJECTURE): streaming stability is a phase transition: exists L* such that for L > L* performance collapses without sink stratum (cache eviction of sinks = crossing strata); links #229 KV-cache conjecture. Gap: no bound on L*.
C5 (CONJECTURE): universality: the mass-conservation singularity is codim-0 generic in attention parameter space, so almost all trained models develop sinks. Gap: transversality unproven; sink vs retrieval-head fiber interplay open (#512 P6).
OPEN PROBLEMS: P1 head-wise SGLD estimator; P2 sink heads vs retrieval heads: same stratum or distinct fibers (#512 P6); P3 sink token count k* dependence on positional encoding; P4 KV-cache eviction as stratum crossing (#229); P5 pretraining vs streaming emergence of sinks; P6 falsification: lambda_sink >= lambda_full in trained models collapses C2-C5.
CROSS-REFS: #229 #292 #302 #396 #512 #8 #16 #57 #73 #100
NEXT: L2 novelty record reconstruction (verdict PASSED 2026-10-01).
