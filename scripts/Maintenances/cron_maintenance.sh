#!/usr/bin/env bash
# ==============================================================================
#  La Roulotte Solidaire Toulouse
#  Script : cron_maintenance.sh
#  Version : 1.1.0
#  Objectif :
#     - Exécuter automatiquement la maintenance quotidienne
#     - Générer un rapport JSON
#     - Gérer les logs CRON
#     - Détecter les erreurs
# ==============================================================================

set -euo pipefail

# --- Répertoires --------------------------------------------------------------
BASE_DIR="$(dirname "$(realpath "$0")")"
LOG_DIR="$BASE_DIR/../../logs/cron"
REPORT_SCRIPT="$BASE_DIR/maintenance_report.py"
MAINTENANCE_SCRIPT="$BASE_DIR/maintenance_roulotte.sh"

mkdir -p "$LOG_DIR"

# --- Log du jour --------------------------------------------------------------
DATE="$(date +%Y-%m-%d)"
LOG_FILE="$LOG_DIR/cron_${DATE}.log"

echo "=== CRON MAINTENANCE — $DATE ===" >> "$LOG_FILE"

# --- Exécution silencieuse ----------------------------------------------------
{
    bash "$MAINTENANCE_SCRIPT" --cron
    python3 "$REPORT_SCRIPT"
} >> "$LOG_FILE" 2>&1

# --- Vérification du rapport --------------------------------------------------
REPORT_PATH="$BASE_DIR/../../reports/maintenance_${DATE}.json"

if [[ ! -f "$REPORT_PATH" ]]; then
    echo "[ERREUR] Rapport non généré : $REPORT_PATH" >> "$LOG_FILE"
    exit 1
fi

echo "[OK] Maintenance terminée et rapport généré." >> "$LOG_FILE"
exit 0
