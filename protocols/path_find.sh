#!/bin/bash
M=/tmp/Oma_folio/atom_manifest.metta
echo "Ancestors of $1:"
awk -v c=$1 '$3==c {gsub(/)/,"",$4); print $4}' $M | sort -u
echo "---"
echo "Ancestors of $2:"
awk -v c=$2 '$3==c {gsub(/)/,"",$4); print $4}' $M | sort -u
