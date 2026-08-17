#!/bin/bash
# genesis_query.sh — Layer 1: Fast text search across GENESIS KB
# Usage: ./genesis_query.sh <concept> [relationship_type]
# Returns atoms matching concept with file source

CONCEPT="$1"
RELTYPE="${2:-Inheritance}"
KB_DIR="/tmp/Oma_folio"

if [ -z "$CONCEPT" ]; then
  echo "Usage: $0 <concept> [Inheritance|Implication|Evaluation|*]"
  exit 1
fi

if [ "$RELTYPE" = "*" ]; then
  grep -rn "$CONCEPT" "$KB_DIR"/*.metta "$KB_DIR"/GENESIS/*.metta 2>/dev/null | grep -v "^Binary" | head -50
else
  grep -rn "($RELTYPE.*$CONCEPT" "$KB_DIR"/*.metta "$KB_DIR"/GENESIS/*.metta 2>/dev/null | grep -v "^Binary" | head -50
fi