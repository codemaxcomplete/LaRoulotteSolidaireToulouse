#!/usr/bin/env bash
set -euo pipefail

LOG_DIR="${HOME}/.local/share/roulotte-tests/logs"
mkdir -p "$LOG_DIR"

log() {
    echo "[DRY-RUN][$(date '+%Y-%m-%d %H:%M:%S')] $1" \
        | tee -a "$LOG_DIR/test_dry_run.log"
}

log "Lancement du dry-run"

if ./install.sh --dry-run; then
    log "Dry-run réussi"
else
    log "Dry-run échoué"
    exit 1
fi
