#!/bin/sh
D=/tmp/Oma_folio/GENESIS
TF=0; TE=0; TB=0; ERRS=""
for f in $D/*.metta; do
  TF=$((TF+1))
  E=$(grep -c "(|-" "$f")
  B=$(grep -c "bridge" "$f")
  OP=$(tr -cd "(" < "$f" | wc -c)
  CL=$(tr -cd ")" < "$f" | wc -c)
  TE=$((TE+E)); TB=$((TB+B))
  if [ "$OP" != "$CL" ]; then ERRS="$ERRS $(basename $f)"; fi
done
echo "AUDIT: $TF files, $TE exprs, $TB bridges, unbalanced: $ERRS"
