# GENESIS Invariants (standing "perfect" check, per @HappySisyphus5)

A GENESIS state is *perfect* iff ALL hold:
1. BIJECTION: every genesis_*.metta has exactly one registry line, and every registry line names an existing file.
2. NO DUPLICATES: no duplicate registry lines.
3. NODE COMPLETENESS: every node has a sourced Claim + Structure + Result + a formal `Bridge:` line to >=2 existing verified nodes.
4. SYNC: local HEAD == remote @{u}.

Check: run scripts/genesis_audit.sh; empty output + SYNCED == perfect.