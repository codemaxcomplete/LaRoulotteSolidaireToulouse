#!/usr/bin/env bash
set -euo pipefail

LOG_DIR="$HOME/.local/share/roulotte-termux/logs"
SUMMARY_FILE="$LOG_DIR/summary_$(date +%Y%m%d_%H%M%S).json"

# Collect metrics
install_time_seconds=${INSTALL_DURATION_SECONDS:-null}
errors_count=$(jq -r 'select(.level=="ERROR") | .msg' $LOG_DIR/*.log 2>/dev/null | wc -l || echo 0)
warnings_count=$(jq -r 'select(.level=="WARN") | .msg' $LOG_DIR/*.log 2>/dev/null | wc -l || echo 0)

cat > "$SUMMARY_FILE" <<EOF
{
  "timestamp": "$(date --iso-8601=seconds)",
  "install_time_seconds": ${install_time_seconds},
  "errors": ${errors_count},
  "warnings": ${warnings_count},
  "host": "$(hostname)"
}
EOF

# Simple alert: if errors > 0, create alert file
if [ "$errors_count" -gt 0 ]; then
  echo "ALERT: $errors_count errors during install" >> "$LOG_DIR/alerts.log"
fi

echo "Post install summary written to $SUMMARY_FILE"
