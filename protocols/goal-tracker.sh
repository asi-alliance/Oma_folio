#!/bin/bash
# goal-tracker.sh — 3-strike auto-fail mechanism
# Usage: goal-tracker.sh <goal_id> <yes|no> [cycle_num]
STRIKES_FILE=/tmp/Oma_folio/goal-strikes.md
GOAL_ID=$1
PRODUCED=$2
CURRENT=${3:-unknown}
if [ -z "$GOAL_ID" ] || [ -z "$PRODUCED" ]; then echo "Usage: goal-tracker.sh <goal_id> <yes|no> [cycle_num]"; exit 1; fi
LINE=$(grep "^$GOAL_ID " "$STRIKES_FILE" 2>/dev/null)
if [ -z "$LINE" ]; then
  STRIKES=0; STATE=ACTIVE; LAST=never
else
  STRIKES=$(echo "$LINE" | cut -d"|" -f2 | tr -d " ")
  STATE=$(echo "$LINE" | cut -d"|" -f4 | tr -d " ")
  LAST=$(echo "$LINE" | cut -d"|" -f3 | tr -d " ")
fi
if [ "$STATE" = "ABANDONED" ]; then echo "$GOAL_ID already ABANDONED"; exit 0; fi
if [ "$PRODUCED" = "yes" ]; then
  STRIKES=0; LAST="cycle_$CURRENT"
else
  STRIKES=$((STRIKES + 1))
fi
if [ "$STRIKES" -ge 3 ]; then STATE=ABANDONED; else STATE=ACTIVE; fi
NEWLINE="$GOAL_ID | $STRIKES | $LAST | $STATE"
if [ -z "$LINE" ]; then
  echo "$NEWLINE" >> "$STRIKES_FILE"
else
  grep -v "^$GOAL_ID " "$STRIKES_FILE" > "$STRIKES_FILE.tmp" && mv "$STRIKES_FILE.tmp" "$STRIKES_FILE"
  echo "$NEWLINE" >> "$STRIKES_FILE"
fi
echo "$GOAL_ID: strikes=$STRIKES state=$STATE"
