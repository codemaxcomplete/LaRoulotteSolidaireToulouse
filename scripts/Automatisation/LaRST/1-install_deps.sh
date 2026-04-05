#!/usr/bin/env bash
set -euo pipefail

# Install system deps (Debian/Ubuntu/Mint)
echo "Mise à jour des paquets APT..."
sudo apt update
sudo apt -y upgrade

echo "Installation des paquets système requis..."
sudo apt -y install python3 python3-venv python3-pip build-essential \
    libffi-dev libssl-dev libsqlite3-dev git curl wget

# Create a virtualenv for the project (optional but recommended)
PROJECT_DIR="/opt/roulotte_user_manager"
VENV_DIR="$PROJECT_DIR/venv"

sudo mkdir -p "$PROJECT_DIR"
sudo chown "$USER":"$USER" "$PROJECT_DIR"

python3 -m venv "$VENV_DIR"
echo "Virtualenv créé dans $VENV_DIR"
echo "Active-le avec : source $VENV_DIR/bin/activate"

# Install Python packages inside venv
echo "Installation des dépendances Python (rich, textual, python-dotenv)..."
source "$VENV_DIR/bin/activate"
pip install --upgrade pip
pip install rich textual python-dotenv

echo "Installation terminée."
echo "Pour lancer l'application :"
echo "  source $VENV_DIR/bin/activate"
echo "  sudo python3 user_manager_tui.py"
