#!/data/data/com.termux/files/usr/bin/bash
# ==============================================================================
#  La Roulotte Solidaire Toulouse
#  Script : termux_sync_git.sh
#  Version : 1.1.0
#  Objectif :
#     - Synchronisation Git automatique sur Android (Termux)
#     - Sans CRON, sans systemd
# ==============================================================================

set -euo pipefail

BASE_DIR="$HOME/roulotte"
LOG_DIR="$BASE_DIR/logs/termux"
mkdir -p "$LOG_DIR"

DATE="$(date +%Y-%m-%d_%H-%M)"
LOG_FILE="$LOG_DIR/termux_git_${DATE}.log"

echo "=== TERMUX SYNC GIT — $DATE ===" >> "$LOG_FILE"

cd "$BASE_DIR" || exit 1

# Pull
echo "[INFO] Pull..." >> "$LOG_FILE"
git pull --no-edit >> "$LOG_FILE" 2>&1 || echo "[WARN] Conflit possible" >> "$LOG_FILE"

# Add
echo "[INFO] Add..." >> "$LOG_FILE"
git add -A >> "$LOG_FILE" 2>&1

# Commit
echo "[INFO] Commit..." >> "$LOG_FILE"
git commit -m "Sync auto Termux — $DATE" >> "$LOG_FILE" 2>&1 || \
    echo "[INFO] Aucun changement à commit." >> "$LOG_FILE"

# Push
echo "[INFO] Push..." >> "$LOG_FILE"
git push >> "$LOG_FILE" 2>&1

echo "[OK] Sync Git Termux terminée." >> "$LOG_FILE"
exit 0
