#!/usr/bin/env bash
# ==============================================================================
#  La Roulotte Solidaire Toulouse
#  Script : uninstall_systemd_services.sh
#  Objectif :
#     - Désinstaller proprement les services systemd
# ==============================================================================

set -euo pipefail

SERVICE_DIR="/etc/systemd/system"

echo "=== Désinstallation des services systemd de la Roulotte ==="

# Désactivation
sudo systemctl disable roulotte-maintenance.timer || true
sudo systemctl disable roulotte-syncgit.timer || true

# Arrêt
sudo systemctl stop roulotte-maintenance.timer || true
sudo systemctl stop roulotte-syncgit.timer || true

# Suppression
sudo rm -f "$SERVICE_DIR/roulotte-maintenance.service"
sudo rm -f "$SERVICE_DIR/roulotte-maintenance.timer"
sudo rm -f "$SERVICE_DIR/roulotte-syncgit.service"
sudo rm -f "$SERVICE_DIR/roulotte-syncgit.timer"

# Reload
sudo systemctl daemon-reload

echo "[OK] Services systemd désinstallés."
