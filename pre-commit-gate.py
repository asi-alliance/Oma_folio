#!/usr/bin/env python3
"""Pre-commit gate: Reject goals with >80% token overlap against prior ACs.
Based on G766 ac-overlap-check.py proven pattern."""
import sys, re
from collections import Counter

def tokenize(text):
    return Counter(re.findall(r'[a-zA-Z0-9]+', text.lower()))

def overlap_pct(tokens_a, tokens_b):
    if not tokens_a or not tokens_b:
        return 0.0
    intersection = sum((tokens_a & tokens_b).values())
    union = sum((tokens_a | tokens_b).values())
    return intersection / union if union else 0.0

def check_new_ac(new_ac_text, prior_acs_file):
    new_tokens = tokenize(new_ac_text)
    with open(prior_acs_file) as f:
        priors = [line.strip() for line in f if line.strip()]
    max_overlap = 0.0
    for prior in priors:
        pct = overlap_pct(new_tokens, tokenize(prior))
        max_overlap = max(max_overlap, pct)
    if max_overlap > 0.80:
        print(f"BLOCKED: {max_overlap:.1%} overlap with prior AC")
        return 1
    print(f"PASS: max overlap {max_overlap:.1%}")
    return 0

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: pre-commit-gate.py <new_ac_text> <prior_acs_file>")
        sys.exit(2)
    sys.exit(check_new_ac(sys.argv[1], sys.argv[2]))
