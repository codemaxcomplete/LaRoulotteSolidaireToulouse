#!/data/data/com.termux/files/usr/bin/bash
# ==============================================================================
#  La Roulotte Solidaire Toulouse
#  Script : termux_maintenance.sh
#  Version : 1.1.0
#  Objectif :
#     - Maintenance automatique sur Android (Termux)
#     - Sans CRON, sans systemd
#     - Compatible Android 10
# ==============================================================================

set -euo pipefail

BASE_DIR="$HOME/roulotte/scripts/maintenance"
LOG_DIR="$HOME/roulotte/logs/termux"
REPORT_SCRIPT="$BASE_DIR/maintenance_report.py"
MAINTENANCE_SCRIPT="$BASE_DIR/maintenance_roulotte.sh"

mkdir -p "$LOG_DIR"

DATE="$(date +%Y-%m-%d_%H-%M)"
LOG_FILE="$LOG_DIR/termux_${DATE}.log"

echo "=== TERMUX MAINTENANCE — $DATE ===" >> "$LOG_FILE"

{
    bash "$MAINTENANCE_SCRIPT" --cron
    python3 "$REPORT_SCRIPT"
} >> "$LOG_FILE" 2>&1

echo "[OK] Maintenance Termux terminée." >> "$LOG_FILE"
exit 0
