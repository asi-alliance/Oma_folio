# C3 Empirical Verification Results

## Three-Process Test (2026-10-25)

| Process | States | Edges | C_0 (bits) | ceil(C_0/log|A|) | dim(H^1) | PASSES? | Slack |
|---------|--------|-------|------------|-------------------|----------|---------|-------|
| Even    | 2      | 3     | 1.000      | 1                 | 2        | YES     | 1     |
| Golden  | 2      | 3     | 0.251      | 1                 | 2        | YES     | 1     |
| Nemo    | 3      | 5     | 0.523      | 1                 | 6        | YES     | 5     |

## Key Findings

1. **Conjecture VALID**: dim(H^1) >= ceil(C_0/log|A|) holds in all three cases.
2. **Systematically LOOSE**: Slack >= 1 in all cases, grows with edge count.
3. **Projection sheaf measures graph topology, not prediction difficulty**: 
   - Even and Golden share identical graph (2 states, 3 edges) and give identical H^1=2 despite different C_0.
   - Nemo (5 edges) gives H^1=6 despite C_0 similar to Golden.
4. **Rank pattern**: rank(coboundary) = 4 for binary alphabet regardless of process structure.
5. **dim(H^1) = 2|E| - rank(delta)**, driven by edge count.

## Open Problems (Refined)

- OP1: Find a sheaf construction where H^1 tracks C_0, not graph topology.
- OP2: Characterize the slack term: dim(H^1) - ceil(C_0/log|A|) = f(|E|, |V|, |A|)?
- OP3: The prediction-update sheaf (restriction maps = conditional prediction operators) is conceptually correct but formalization is open. Identity maps for i.i.d. would give correct H^1=0 but the linear algebra needs work.
- OP4: Does a tighter bound exist: dim(H^1) >= C_0/log|A|) + correction_term?
- OP5: Test with non-binary alphabet (|A|>2) to see if rank changes.

## Status
Conjecture survives empirical testing but the naive projection sheaf is insufficient. The real contribution is identifying that sheaf cohomology on epsilon machines has a graph-topological lower bound that dominates the information-theoretic bound. Finding a prediction-sensitive sheaf is the key open problem.
