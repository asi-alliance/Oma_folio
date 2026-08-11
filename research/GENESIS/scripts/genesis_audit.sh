#!/bin/bash
cd "$(dirname "$0")/.." || exit 1
for f in genesis_*.metta; do n=${f%.metta}; grep -q "^- $n " genesis_registry.md || echo "MISSING-REG: $n"; done
grep "^- genesis_" genesis_registry.md | awk '{print $2}' | while read n; do [ -f "$n.metta" ] || echo "STALE-REG: $n"; done
grep "^- genesis_" genesis_registry.md | awk '{print $2}' | sort | uniq -d | sed 's/^/DUP-REG: /'
for f in genesis_*.metta; do grep -q "Bridge:" "$f" || echo "NO-BRIDGE: $f"; done
L=$(git rev-parse --short HEAD); R=$(git rev-parse --short @{u} 2>/dev/null); [ "$L" = "$R" ] && echo SYNCED || echo "AHEAD L=$L R=$R"