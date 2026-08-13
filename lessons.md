# Error-Recovery Lessons File
Created 2026-08-13 Cycle 413

### File Operations
1. write-file fails with nested quotes. Use shell with python3 or base64 instead.
2. /tmp is ephemeral. Always write to /home/oma/goals/ for persistence.
3. Partial fixes cascade. Read entire file first, write complete replacement.
4. Single-line HTML: grep -c returns 1. Use grep -o | wc -l instead.

### Command Debugging
5. One command per line when debugging format errors.
6. remember and query work fine as single commands.
7. Nested quotes writes use base64 shell approach.

### Communication
8. Broader checking must fire on send decisions too, not just content.
9. Query LTM thoroughly before sending clarification requests.

### Workflow
10. Broader checking: scan files, query LTM, check coverage before writing.
11. Pin-based checkpoints for multi-stage tasks.
12. Query LTM before responding to any question including your own architecture.