#!/usr/bin/env bash
# ==============================================================================
#  La Roulotte Solidaire Toulouse
#  Script : install_systemd_services.sh
#  Objectif :
#     - Installer automatiquement les services systemd
#     - Activer les timers
# ==============================================================================

set -euo pipefail

SERVICE_DIR="/etc/systemd/system"
PROJECT_DIR="$(dirname "$(realpath "$0")")/../.."
SRC_DIR="$PROJECT_DIR/systemd"

echo "=== Installation des services systemd de la Roulotte ==="

# Vérification des fichiers
for file in roulotte-maintenance.service roulotte-maintenance.timer roulotte-syncgit.service roulotte-syncgit.timer; do
    if [[ ! -f "$SRC_DIR/$file" ]]; then
        echo "[ERREUR] Fichier manquant : $SRC_DIR/$file"
        exit 1
    fi
done

# Copie des fichiers
sudo cp "$SRC_DIR"/*.service "$SERVICE_DIR/"
sudo cp "$SRC_DIR"/*.timer "$SERVICE_DIR/"

# Permissions
sudo chmod 644 "$SERVICE_DIR"/roulotte-*.service
sudo chmod 644 "$SERVICE_DIR"/roulotte-*.timer

# Reload systemd
sudo systemctl daemon-reload

# Activation
sudo systemctl enable roulotte-maintenance.timer
sudo systemctl enable roulotte-syncgit.timer

# Démarrage
sudo systemctl start roulotte-maintenance.timer
sudo systemctl start roulotte-syncgit.timer

echo "[OK] Services systemd installés et activés."
