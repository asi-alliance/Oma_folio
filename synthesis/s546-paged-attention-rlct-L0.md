#546: Paged Attention × RLCT — L0 Exploration

## 1. Topic
Paged Attention (PagedAttention) — a memory management technique for LLM KV cache where the key-value cache is partitioned into fixed-size blocks/pages, stored in non-contiguous physical memory, with virtual-to-physical page mapping handled by a block table. Used in vLLM. This is an inference-time optimization, not a training-time architectural change.

## 2. Why This Topic
Paged Attention introduces a piecewise-constant block table that maps logical KV positions to physical memory pages. This mapping is non-smooth: the attention computation over a sequence is a composition of page lookups, each of which is a discontinuous function of the block allocation. From the RLCT perspective, the singularity arises at block boundaries where adjacent logical positions map to non-adjacent physical pages — the access pattern creates a piecewise structure in the attention computation. The block size B determines the granularity of this piecewise partition.

## 3. Key Concepts
- **Block table T**: Mapping from logical block index to physical block index. T[i] = physical page for logical page i. Piecewise-constant, discontinuous at allocation boundaries.
- **Block size B**: Fixed number of tokens per KV page. Determines partition granularity.
- **Non-contiguous storage**: KV cache for a single sequence spans multiple physical pages, potentially non-adjacent.
- **Block allocation/deallocation**: Dynamic during generation — blocks freed when sequences complete, reallocated to new sequences. Creates time-varying piecewise structure.
- **RLCT bridge**: The block table T creates a piecewise partition of the KV access pattern. At block boundaries (logical position i*B), there is a discontinuity in the physical memory access pattern. The RLCT of the inference-time loss landscape is affected by the block structure: smaller B → more boundaries → more piecewise segments → potentially higher effective RLCT due to finer partition. The singularity is in the mapping function T, which is integer-valued and discontinuous.

## 4. Claims
- **C1 (PROVEN)**: Paged Attention computes the same attention function as standard attention in exact arithmetic — the block table is a memory layout optimization that does not change the mathematical function. Therefore the RLCT of the model class is identical: λ_paged = λ_standard. (Same function, same loss landscape, same singularity structure.)
- **C2 (CONJECTURAL)**: In floating-point arithmetic, the non-associative summation order induced by block-level computation creates a perturbation of the attention output. This perturbation is piecewise in block allocation order, creating micro-singularities at block boundaries where summation order changes. The effective RLCT under this perturbation satisfies λ_fp_paged ≥ λ_standard_fp, with the gap proportional to the number of block boundaries O(N/B).
- **C3 (CONJECTURAL)**: The optimal block size B* minimizes a trade-off: too small B → many block boundaries → high perturbation RLCT overhead; too large B → memory fragmentation → throughput loss. B* depends on the floating-point precision and the attention dimension d_k.
- **C4 (CONJECTURAL)**: Under continuous batching with dynamic allocation/deallocation, the block table T(t) changes over time. The time-varying piecewise structure creates a non-stationary singularity landscape. The RLCT at time t, λ(t), is a function of the block allocation state, creating a phase transition when fragmentation crosses a threshold.
- **C5 (CONJECTURAL)**: For sequences shorter than one block (N < B), paged attention degenerates to standard attention with zero boundary cost. For N >> B, the boundary perturbation accumulates as O(N/B), and the generalization gap under finite-precision arithmetic scales as O(N/B * ε_machine).

## 5. Cross-References
- #499 Flash Attention × RLCT (same floating-point non-associativity theme, different mechanism: tiling vs paging)
- #545 Sparse Attention × RLCT (attention pattern restriction, different: sparsity mask vs memory layout)
- #229 KV Cache × RLCT (KV cache management, complementary: cache content vs cache layout)
- #498 MoD × RLCT (routing/gating, different: computation routing vs memory routing)
- #382 Scheduled Sampling × RLCT (self-referential discontinuity theme)

## 6. Open Questions
1. Exact characterization of floating-point perturbation at block boundaries
2. Whether block-level summation order creates a distinct micro-singularity class
3. RLCT behavior under variable block sizes (adaptive paging)
4. Interaction with prefix caching — does shared prefix create shared singularity structure?
5. Whether the dynamic allocation/deallocation phase transition (C4) is empirically observable as a generalization gap

## 7. Status
L0 COMPLETE. Next: L1 formalization.
Date: 2026-10-23.