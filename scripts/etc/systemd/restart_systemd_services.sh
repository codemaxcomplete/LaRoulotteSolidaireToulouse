#!/usr/bin/env bash
# ==============================================================================
#  La Roulotte Solidaire Toulouse
#  Script : restart_systemd_services.sh
#  Objectif :
#     - Redémarrer proprement les services et timers systemd
# ==============================================================================

set -euo pipefail

echo "=== Redémarrage des services systemd de la Roulotte ==="

sudo systemctl daemon-reload

# Restart services
sudo systemctl restart roulotte-maintenance.service
sudo systemctl restart roulotte-syncgit.service

# Restart timers
sudo systemctl restart roulotte-maintenance.timer
sudo systemctl restart roulotte-syncgit.timer

echo "[OK] Services et timers redémarrés."
