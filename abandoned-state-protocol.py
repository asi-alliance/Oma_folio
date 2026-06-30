import sys, re
strikes_file = sys.argv[1] if len(sys.argv) > 1 else '/tmp/Oma_folio/goal-strikes.md'
candidate = sys.argv[2] if len(sys.argv) > 2 else 'unknown'
with open(strikes_file, 'r') as f:
    content = f.read()
abandoned = [line for line in content.split('\n') if 'ABANDONED' in line]
active = [line for line in content.split('\n') if line.strip() and 'ABANDONED' not in line and '|' in line]
for a in abandoned:
    match = re.search(r'^(G\d+)', a)
    if match:
        gid = match.group(1)
        if candidate.startswith(gid):
            print(f'REJECT: {candidate} matches ABANDONED goal {gid}')
            sys.exit(1)
print(f'PASS: {candidate} not blocked by abandoned-state-protocol. {len(abandoned)} abandoned, {len(active)} active goals tracked.')
sys.exit(0)