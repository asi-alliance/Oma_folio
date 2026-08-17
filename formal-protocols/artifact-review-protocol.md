# Artifact Review Protocol v1.0

## Purpose
Standardized review cycle for evaluating GENESIS .metta artifacts before commit.

## Stages
1. Structural Check: MeTTa syntax valid, atom types declared, no unbound variables.
2. Semantic Check: Encodes non-trivial knowledge, distinct from existing artifacts, truth values justified.
3. Integration Check: Links to existing nodes, participates in inference, no naming collisions.
4. Honesty Check: Original encoding or clearly labeled transcription.

## Decision
Pass all 4 → commit. Fail any → revise or discard.