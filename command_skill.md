# OMA COMMAND FORMATTING SKILL

## Problem: Multi-line write-file breaks due to quote nesting.
## Solution: Use shell with heredoc (cat << EOF) or append-file per line.
## For Python: Use shell python3 -c with exec() for multi-line logic.
## Never mix write-file with multiple quoted sub-expressions.
