2026-10-28 OT × QUANTUM INFORMATION — L0 PROBLEM STATEMENT

DIRECTION: Optimal Transport × Quantum Information
SYNTHESIS ID: OT-QI-001
DATE: 2026-10-28

MOTIVATION:
Quantum Wasserstein distance (QWD), introduced by De Palma, Marvian, Trevisan, Lloyd (arXiv:2009.04469), generalizes the classical W1 Wasserstein metric to quantum states of n qudits. The cost is defined via the L1 norm of the generator of translations (sum of local Pauli operators), giving a distance that captures spatial/local distinguishability of quantum states. This is distinct from trace distance or fidelity, which are basis-independent and global.

KEY QUESTION:
Can the quantum Wasserstein distance between quantum error-correcting code states (or their error images) predict or bound the quantum code distance d, and can this connection yield new decoder design principles?

FIVE CLAIMS (C1-C5):

C1 (DEFINABILITY — PROVEN): The quantum W1 distance W1(rho,sigma) between stabilizer code states rho=|psi_g><psi_g| and sigma=|psi_h><psi_h| is well-defined and computable as the solution to a semidefinite program (SDP): minimize Tr(C*J) over coupling superoperators J subject to Tr_2(J)=rho, Tr_1(J)=sigma, where C is the cost operator (sum of local generators). For stabilizer states, the SDP reduces to a finite-dimensional linear program over the stabilizer group.

C2 (CODE DISTANCE BOUND — CONJECTURAL): There exists a monotone relationship between W1(|psi_g>, E|psi_g>) and the weight of the error E, where E is in the normalizer of the stabilizer group. Specifically, W1(|psi_g>, E|psi_g>) >= c*wt(E) for errors below distance d, and W1=0 iff E is a stabilizer (logical identity). This would make QWD a continuous proxy for code distance.

C3 (TRANSPORT PLAN ↔ DECODER STRUCTURE — CONJECTURAL): The optimal transport plan (coupling superoperator J*) that achieves W1(rho,sigma) for code states related by an error has a structure that mirrors the syndrome measurement circuit. The Kraus operators of J* decompose along stabilizer generators, suggesting the OT solution encodes decoder information.

C4 (GENERALIZATION BOUND — CONJECTURAL): For a family of [[n,k,d]] codes with growing n, the QWD between code and error-deformed code states scales as O(d/n) for local errors, providing a generalization bound: codes with larger QWD gap are more robust to local noise channels. This connects to the local indistinguishability property of QEC codes.

C5 (PHASE TRANSITION — CONJECTURAL): As the error rate p increases through the threshold p_th, the expected QWD between the noise channel output and the original code state undergoes a phase transition: below p_th, W1 proportional to p (linear, correctable regime); above p_th, W1 saturates or becomes non-analytic (uncorrectable regime). The QWD phase transition coincides with the decoding threshold.

NOVELTY:
Zero prior coverage in Oma synthesis catalog. The quantum Wasserstein distance × QEC bridge is genuinely new. Prior OT work covers classical settings; prior QEC work covers Toffoli optimization and stabilizer codes but never through the OT lens.

CROSS-REFERENCES:
- QEC circuit optimization (HUME conversations, GF(2^12) decoder)
- TQSG synthesis (quantum LDPC + spin glass + coding theory)
- K-theory to quantum information bridge (validated 2026-08-15)
- RLCT × coding theory connections in synthesis catalog

OPEN PROBLEMS:
1. Can W1 between stabilizer states be computed without full SDP, exploiting stabilizer structure for polynomial-time evaluation?
2. Does the optimal coupling J* for stabilizer code states always decompose into Pauli-group Kraus operators?
3. Is the QWD threshold transition sharp (non-analytic) or smooth at finite n?
4. Can QWD guide decoder design — e.g., minimum-weight decoding as minimum-cost transport?
5. Relationship between QWD and the Lipschitz constant of the decoder map?
6. Does C2 hold for degenerate quantum codes where multiple errors map to the same syndrome?
7. Extension to approximate quantum error correction (AQEC) codes?

NEXT: L1 formalization — define D1-D7, formalize C1 proof, sketch C2-C5 arguments.