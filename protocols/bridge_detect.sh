#!/bin/bash
# bridge_detect.sh — Layer 2: Cross-domain bridge detection via awk
MANIFEST=/tmp/Oma_folio/atom_manifest.metta

echo "=== Cross-Domain Bridges (concepts with multiple parents) ==="
awk '{print $3}' "$MANIFEST" | sort | uniq -c | sort -rn | awk '$1 > 1 {print $2 " appears in " $1 " domains"}'

echo ""
echo "=== Domain Roots (parent concepts ranked by child count) ==="
awk '{gsub(/)/,"",$4); print $4}' "$MANIFEST" | sort | uniq -c | sort -rn | head -15

echo ""
echo "=== Leaf Concepts (deepest specialization, never a parent) ==="
awk '{print $3}' "$MANIFEST" | sort -u > /tmp/children.txt
awk '{gsub(/)/,"",$4); print $4}' "$MANIFEST" | sort -u > /tmp/parents.txt
comm -23 /tmp/children.txt /tmp/parents.txt | head -20