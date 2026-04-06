#!/usr/bin/env bash
# ==============================================================================
#  La Roulotte Solidaire Toulouse
#  Script : sync_git.sh
#  Version : 1.1.0
#  Objectif :
#     - Synchroniser automatiquement le dépôt Git
#     - Gérer les conflits
#     - Loguer les opérations
# ==============================================================================

set -euo pipefail

# --- Répertoires --------------------------------------------------------------
BASE_DIR="$(dirname "$(realpath "$0")")"
LOG_DIR="$BASE_DIR/../../logs/git"
mkdir -p "$LOG_DIR"

DATE="$(date +%Y-%m-%d_%H-%M)"
LOG_FILE="$LOG_DIR/git_sync_${DATE}.log"

echo "=== SYNC GIT — $DATE ===" >> "$LOG_FILE"

cd "$BASE_DIR/../../" || exit 1

# --- Pull ---------------------------------------------------------------------
echo "[INFO] Pull des dernières modifications..." >> "$LOG_FILE"
if ! git pull --no-edit >> "$LOG_FILE" 2>&1; then
    echo "[ERREUR] Conflit détecté lors du pull." >> "$LOG_FILE"
    exit 1
fi

# --- Add ----------------------------------------------------------------------
echo "[INFO] Ajout des fichiers modifiés..." >> "$LOG_FILE"
git add -A >> "$LOG_FILE" 2>&1

# --- Commit -------------------------------------------------------------------
echo "[INFO] Commit automatique..." >> "$LOG_FILE"
git commit -m "Sync auto — $DATE" >> "$LOG_FILE" 2>&1 || \
    echo "[INFO] Aucun changement à commit." >> "$LOG_FILE"

# --- Push ---------------------------------------------------------------------
echo "[INFO] Push vers le dépôt distant..." >> "$LOG_FILE"
git push >> "$LOG_FILE" 2>&1

echo "[OK] Synchronisation Git terminée." >> "$LOG_FILE"
exit 0
