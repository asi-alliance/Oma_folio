#!/usr/bin/env python3
"""Runtime gate checker: Block goals with template-pattern overlap AND missing artifact path."""
import sys, re
from collections import Counter

def tokenize(text):
    return Counter(re.findall(r'[a-zA-Z0-9]+', text.lower()))

def token_overlap_pct(tokens_a, tokens_b):
    if not tokens_a or not tokens_b:
        return 0.0
    intersection = sum((tokens_a & tokens_b).values())
    union = sum((tokens_a | tokens_b).values())
    return intersection / union if union else 0.0

AC_SKELETON = [r'AC1', r'AC2', r'AC3', r'AC4', r'AC5', r'AC6', r'AC7']
HOP_PATTERN = r'[0-9]+-hop'
DISCRIMINATOR_PATTERN = r'discriminator'
ARTIFACT_PATTERN = r'artifact|deliverable|write-file|[.]py|[.]html|[.]txt|[.]md'

def detect_skeleton(text):
    found = sum(1 for ac in AC_SKELETON if re.search(ac, text, re.IGNORECASE))
    return found >= 6

def detect_hop_pipeline(text):
    has_hop = bool(re.search(HOP_PATTERN, text, re.IGNORECASE))
    has_disc = bool(re.search(DISCRIMINATOR_PATTERN, text, re.IGNORECASE))
    return has_hop and has_disc

def detect_artifact_path(text):
    return bool(re.search(ARTIFACT_PATTERN, text, re.IGNORECASE))

def check_goal(goal_text, prior_file=None, threshold=0.80):
    reasons = []
    structural_score = 0
    if detect_skeleton(goal_text):
        structural_score += 1
    if detect_hop_pipeline(goal_text):
        structural_score += 1
    if not detect_artifact_path(goal_text):
        reasons.append('MISSING ARTIFACT PATH: no persistent deliverable specified')
    if structural_score >= 2:
        reasons.append('TEMPLATE PATTERN: goal has 7-AC skeleton + hop/discriminator pipeline rigidity')
    if prior_file:
        try:
            with open(prior_file) as f:
                priors = [line.strip() for line in f if line.strip()]
            new_tokens = tokenize(goal_text)
            max_overlap = max((token_overlap_pct(new_tokens, tokenize(p)) for p in priors), default=0.0)
            if max_overlap > threshold:
                reasons.append(f'TOKEN OVERLAP: {max_overlap:.1%} with prior goals (threshold {threshold:.0%})')
        except FileNotFoundError:
            pass
    if reasons:
        print('BLOCKED:')
        for r in reasons:
            print(f'  - {r}')
        return 1
    print('PASS: goal has artifact path and no template rigidity detected')
    return 0

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print('Usage: runtime-gate-checker.py <goal_text> [prior_acs_file] [threshold]')
        sys.exit(2)
    goal = sys.argv[1]
    prior = sys.argv[2] if len(sys.argv) > 2 else None
    thr = float(sys.argv[3]) if len(sys.argv) > 3 else 0.80
    sys.exit(check_goal(goal, prior, thr))