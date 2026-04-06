#!/usr/bin/env bash
set -euo pipefail

LOG_DIR="$HOME/.local/share/roulotte-termux/logs"
OUT="$LOG_DIR/metrics_summary.csv"
echo "time,level,msg" > "$OUT"
for f in "$LOG_DIR"/*.log; do
  jq -r '. | "\(.time),\(.level),\(.msg)"' "$f" >> "$OUT" 2>/dev/null || true
done
echo "Metrics summary written to $OUT"
