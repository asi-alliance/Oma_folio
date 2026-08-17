#!/usr/bin/env python3
"""G1282 Method-Evaluation-Tool: AC-Skeleton-Audit
Compares acceptance-criteria structures across goals to flag identical skeletons.
AC1: Parse goal summaries without error
AC2: Extract AC-type fingerprint per goal
AC3: Pairwise Jaccard similarity on AC-type sets
AC4: Flag pairs with Jaccard >= 0.85 as skeleton-identical
AC6: Generate report artifact
"""
import sys, os, re, json
from itertools import combinations

def parse_summary(filepath):
    """AC1: Parse a goal summary file and extract goal ID + AC list."""
    goal_id = os.path.basename(filepath).split('-')[0].lstrip('g')
    ac_types = set()
    with open(filepath, 'r') as f:
        for line in f:
            m = re.match(r'\s*AC(\d+)[\.:]', line)
            if m:
                ac_types.add(f'AC{m.group(1)}')
    return goal_id, ac_types

def extract_fingerprint(ac_types):
    """AC2: Return AC-type fingerprint as sorted tuple."""
    return tuple(sorted(ac_types))

def jaccard(set_a, set_b):
    """AC3: Compute Jaccard similarity."""
    if not set_a and not set_b:
        return 1.0
    union = set_a | set_b
    inter = set_a & set_b
    return len(inter) / len(union) if union else 0.0

def main(input_dir='/tmp', output_path='/tmp/g1282-report.txt'):
    # AC1: Find and parse summaries
    summary_files = sorted([
        os.path.join(input_dir, f) for f in os.listdir(input_dir)
        if re.match(r'g1\d{3}.*\.txt', f)
    ])
    if len(summary_files) < 2:
        print(f'WARNING: Found {len(summary_files)} summary files, need >=2')
        return
    goals = {}
    for sf in summary_files:
        try:
            gid, acs = parse_summary(sf)
            goals[gid] = acs
        except Exception as e:
            print(f'PARSE ERROR on {sf}: {e}')
    # AC2: Fingerprints
    fingerprints = {gid: extract_fingerprint(acs) for gid, acs in goals.items()}
    # AC3+AC4: Pairwise Jaccard + flag identical skeletons
    flagged = []
    results = []
    for (g1, g2) in combinations(sorted(goals.keys()), 2):
        j = jaccard(goals[g1], goals[g2])
        results.append((g1, g2, j, fingerprints[g1], fingerprints[g2]))
        if j >= 0.85:
            flagged.append((g1, g2, j))
    # AC6: Write report
    with open(output_path, 'w') as out:
        out.write('G1282 AC-Skeleton-Audit Report
')
        out.write(f'Goals analyzed: {len(goals)}\n')
        out.write(f'Pairwise comparisons: {len(results)}\n\n')
        out.write('AC-Type Fingerprints:\n')
        for gid, fp in sorted(fingerprints.items()):
            out.write(f'  {gid}: {fp}\n')
        out.write(f'\nFlagged skeleton-identical pairs (Jaccard >= 0.85): {len(flagged)}\n')
        for g1, g2, j in flagged:
            out.write(f'  {g1} <-> {g2}: Jaccard={j:.4f}\n')
        if not flagged:
            out.write('  None found.\n')
        out.write(f'\nFull pairwise matrix:\n')
        for g1, g2, j, fp1, fp2 in sorted(results, key=lambda x: -x[2]):
            out.write(f'  {g1} <-> {g2}: Jaccard={j:.4f} | {fp1} vs {fp2}\n')
    print(f'Report written to {output_path}')
    print(f'AC1: Parsed {len(goals)} summaries')
    print(f'AC2: Extracted {len(fingerprints)} fingerprints')
    print(f'AC3: Computed {len(results)} pairwise Jaccard values')
    print(f'AC4: Flagged {len(flagged)} skeleton-identical pairs (Jaccard>=0.85)')
    print(f'AC6: Report artifact at {output_path}')

if __name__ == '__main__':
    main()