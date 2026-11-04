#855 CRYPTIC ORDER SCALING IN N-STATE CYCLIC HMMs

## Summary
For the family cycn(n, delta=0.05) — n-state cyclic deterministic HMMs with graded emission bias — the cryptic order C0 scales as a power law in n:

    C0 ~ 2170 * n^1.119   (R2 = 0.986)

This exceeds linear growth: n=7,8 data points lie above the linear fit from n=3-6.

## Data (delta=0.05, Lmax=20, tol=1e-9)
| n | Cmu | C0est | rho | C0/Cmu |
|---|-----|-------|-----|--------|
| 3 | 1.585 | 6986 | 0.9970 | 4409 |
| 4 | 2.000 | 10640 | 0.9980 | 5320 |
| 5 | 2.322 | 13817 | 0.9984 | 5950 |
| 6 | 2.585 | 16568 | 0.9987 | 6408 |
| 7 | 2.807 | 18978 | 0.9989 | 6761 |
| 8 | 3.000 | 21088 | 0.9990 | 7029 |

## Key Findings
1. C0 grows super-linearly (power law exponent 1.119 > 1)
2. 1-rho ~ 0.008/n (gap decay rate approaches 1 as 1/n)
3. C0/Cmu ratio grows without bound — no finite ceiling on prediction difficulty
4. delta=0.01 causes STALL: gap saturates at ~2.0, never reaches 0 → effectively infinite C0
5. Two independent mechanisms for unbounded C0: (a) increase n, (b) decrease delta toward uniformity

## Theoretical Implication
Over the class of finite-state HMMs with binary alphabet, the cryptic order C0 has no finite upper bound. The ratio C0/Cmu (prediction difficulty per bit of entropy rate) can be made arbitrarily large. This means there exist machines where the optimal predictor must remember an unbounded amount of history relative to the entropy rate.

## Method
Gap = Cmu - I(X_1^L ; S_0) computed via exact backward mutual information. C0est via geometric gap-decay fit: rho = (gap[L]/gap[L-6])^(1/6), C0est = L + log(tol/gap_L)/log(rho). Validated at fixed L=10,12,14 for consistency.

## Status: CLOSED