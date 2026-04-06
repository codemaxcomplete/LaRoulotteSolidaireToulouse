#!/usr/bin/env bash
# ==============================================================================
#  La Roulotte Solidaire Toulouse
#  Script : install_termux_ultimate.sh
#  Version : 3.0.0
#  Objectif :
#     - Environnement Termux complet, modulaire, stylé
#     - Profils : Standard / Pro / Roulotte / Ultra-Graphique / Combo
#     - Modes : Terrain / DevOps avancé / Sécurité / Sync Cloud
# ==============================================================================

set -euo pipefail

# ------------------------------------------------------------------------------
#  Couleurs
# ------------------------------------------------------------------------------
C="\e[96m"; G="\e[92m"; Y="\e[93m"; R="\e[91m"; M="\e[95m"; B="\e[94m"; RESET="\e[0m"

# ------------------------------------------------------------------------------
#  Logging
# ------------------------------------------------------------------------------
LOG_DIR="$HOME/.local/share/roulotte-termux"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/install_$(date +%Y%m%d_%H%M%S).log"

log() {
    echo -e "$1"
    echo -e "$(echo "$1" | sed -r 's/\x1B\[[0-9;]*[mK]//g')" >> "$LOG_FILE"
}

# ------------------------------------------------------------------------------
#  Bannière TUI
# ------------------------------------------------------------------------------
banner() {
    clear
    echo -e "${C}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║           TERMUX ULTIMATE — LA ROULOTTE SOLIDAIRE            ║"
    echo "╠══════════════════════════════════════════════════════════════╣"
    echo "║  Standard | Pro | Roulotte | Ultra | Combo | Modes avancés   ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${RESET}"
    echo -e "${Y}Log : ${LOG_FILE}${RESET}"
    echo
}

# ------------------------------------------------------------------------------
#  Vérifications
# ------------------------------------------------------------------------------
check_termux() {
    if ! command -v pkg &>/dev/null; then
        log "${R}❌ Ce script doit être exécuté dans Termux.${RESET}"
        exit 1
    fi
}

check_internet() {
    if ! ping -c 1 google.com &>/dev/null; then
        log "${R}❌ Pas de connexion Internet.${RESET}"
        exit 1
    fi
}

# ------------------------------------------------------------------------------
#  Optimisations Termux
# ------------------------------------------------------------------------------
optimize_termux() {
    log "${C}⚡ Optimisation Termux...${RESET}"
    termux-setup-storage || true
    pkg clean || true
}

# ------------------------------------------------------------------------------
#  Base système
# ------------------------------------------------------------------------------
update_termux() {
    log "${C}🔄 Mise à jour du système...${RESET}"
    pkg update -y >>"$LOG_FILE" 2>&1
    pkg upgrade -y >>"$LOG_FILE" 2>&1
}

install_core() {
    log "${C}📦 Installation des paquets essentiels...${RESET}"
    pkg install -y \
        git curl wget zsh python ruby nodejs \
        openssh neovim tmux htop \
        fzf ripgrep fd bat \
        proot-distro termux-api \
        clang make rust cargo \
        fastfetch \
        >>"$LOG_FILE" 2>&1
}

# ------------------------------------------------------------------------------
#  Outils modernes
# ------------------------------------------------------------------------------
install_modern_tools() {
    log "${C}✨ Installation outils modernes...${RESET}"

    pkg install -y eza >>"$LOG_FILE" 2>&1 || true

    if command -v cargo &>/dev/null; then
        cargo install --locked yazi-fm yazi-cli >>"$LOG_FILE" 2>&1 || true
        cargo install zellij >>"$LOG_FILE" 2>&1 || true
    fi

    curl -sS https://starship.rs/install.sh | sh -s -- -y >>"$LOG_FILE" 2>&1 || true
}

# ------------------------------------------------------------------------------
#  Shell premium
# ------------------------------------------------------------------------------
configure_shell() {
    log "${C}⚙️ Configuration Zsh + Starship...${RESET}"

    chsh -s zsh || true
    mkdir -p ~/.config

    cat > ~/.zshrc << 'EOF'
export PATH=$PATH:$HOME/.cargo/bin

eval "$(starship init zsh)"

export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

alias ls='eza --icons --group-directories-first'
alias ll='eza -lh --icons'
alias la='eza -lha --icons'
alias cat='bat'
alias grep='rg'
EOF

    cat > ~/.config/starship.toml << 'EOF'
add_newline = true

[character]
success_symbol = "➜"
error_symbol = "✗"

[directory]
style = "cyan"
truncation_length = 3

[git_branch]
symbol = " "
style = "magenta"

[cmd_duration]
min_time = 2000
format = "⏱ $duration"
EOF
}

# ------------------------------------------------------------------------------
#  Profil PRO
# ------------------------------------------------------------------------------
install_pro_tools() {
    log "${M}💼 Installation profil PRO...${RESET}"

    pkg install -y btop bottom lazygit zoxide jq >>"$LOG_FILE" 2>&1 || true

    log "${C}📦 Installation Ubuntu via proot-distro...${RESET}"
    proot-distro install ubuntu >>"$LOG_FILE" 2>&1 || true

    mkdir -p ~/.config/zellij
    cat > ~/.config/zellij/config.kdl << 'EOF'
pane_frames true
theme "default"
EOF
}

# ------------------------------------------------------------------------------
#  Profil ROULOTTE
# ------------------------------------------------------------------------------
install_roulotte_profile() {
    log "${M}🚐 Installation profil ROULOTTE...${RESET}"

    WORKDIR="$HOME/roulotte"
    mkdir -p "$WORKDIR"/{scripts,logs,data,config}

    cat >> ~/.zshrc << 'EOF'

# Profil Roulotte
export ROULOTTE_HOME="$HOME/roulotte"
alias rcd='cd "$ROULOTTE_HOME"'
alias rlogs='cd "$ROULOTTE_HOME/logs"'
alias rscripts='cd "$ROULOTTE_HOME/scripts"'
EOF

    cat > "$WORKDIR/scripts/sync_git.sh" << 'EOF'
#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$HOME/roulotte"
LOG_FILE="$REPO_DIR/logs/sync_git_$(date +%Y%m%d_%H%M%S).log"

echo "[INFO] Sync Git Roulotte - $(date)" | tee -a "$LOG_FILE"

cd "$REPO_DIR"
git pull --rebase | tee -a "$LOG_FILE"
git status | tee -a "$LOG_FILE"
EOF

    chmod +x "$WORKDIR/scripts/sync_git.sh"
}

# ------------------------------------------------------------------------------
#  Profil ULTRA-GRAPHIQUE
# ------------------------------------------------------------------------------
install_ultra_graphique() {
    log "${M}🎨 Installation profil ULTRA-GRAPHIQUE...${RESET}"

    mkdir -p ~/.config

    cat > ~/.config/fastfetch/config.jsonc << 'EOF'
{
  "logo": { "type": "auto" },
  "display": { "separator": "  " }
}
EOF

    mkdir -p ~/.config/yazi
    cat > ~/.config/yazi/yazi.toml << 'EOF'
[manager]
show_hidden = true
sort_by = "name"
EOF

    mkdir -p ~/.config/zellij/layouts
    cat > ~/.config/zellij/layouts/dashboard.kdl << 'EOF'
layout {
    pane size=1 borderless=true {
        plugin location="zellij:tab-bar"
    }
    pane split_direction="vertical" {
        pane { command "fastfetch" }
        pane { command "htop" }
    }
}
EOF

    cat >> ~/.zshrc << 'EOF'
alias dashboard='zellij --layout dashboard'
EOF
}

# ------------------------------------------------------------------------------
#  Mode TERRAIN
# ------------------------------------------------------------------------------
install_mode_terrain() {
    log "${B}🌍 Installation mode TERRAIN...${RESET}"

    pkg install -y termux-location termux-camera-photo termux-sensor >>"$LOG_FILE" 2>&1 || true

    TERRAIN_DIR="$HOME/roulotte/terrain"
    mkdir -p "$TERRAIN_DIR"/{photos,logs,forms}

    cat > "$TERRAIN_DIR/capture_position.sh" << 'EOF'
#!/usr/bin/env bash
set -euo pipefail

OUT_DIR="$HOME/roulotte/terrain/logs"
mkdir -p "$OUT_DIR"
FILE="$OUT_DIR/gps_$(date +%Y%m%d_%H%M%S).json"

termux-location --request once > "$FILE"
echo "Position enregistrée dans $FILE"
EOF
    chmod +x "$TERRAIN_DIR/capture_position.sh"

    cat > "$TERRAIN_DIR/capture_photo.sh" << 'EOF'
#!/usr/bin/env bash
set -euo pipefail

OUT_DIR="$HOME/roulotte/terrain/photos"
mkdir -p "$OUT_DIR"
FILE="$OUT_DIR/photo_$(date +%Y%m%d_%H%M%S).jpg"

termux-camera-photo "$FILE"
echo "Photo enregistrée dans $FILE"
EOF
    chmod +x "$TERRAIN_DIR/capture_photo.sh"

    cat >> ~/.zshrc << 'EOF'

# Mode terrain
alias rterrain='cd "$HOME/roulotte/terrain"'
EOF
}

# ------------------------------------------------------------------------------
#  Mode DEVOPS AVANCÉ
# ------------------------------------------------------------------------------
install_mode_devops() {
    log "${B}🛠 Installation mode DEVOPS avancé...${RESET}"

    # Clients CLI
    pkg install -y kubectl >>"$LOG_FILE" 2>&1 || true
    curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash >>"$LOG_FILE" 2>&1 || true || true

    DEVOPS_DIR="$HOME/roulotte/devops"
    mkdir -p "$DEVOPS_DIR"

    cat > "$DEVOPS_DIR/kube_contexts.sh" << 'EOF'
#!/usr/bin/env bash
set -euo pipefail

echo "Contexts Kubernetes disponibles :"
kubectl config get-contexts
EOF
    chmod +x "$DEVOPS_DIR/kube_contexts.sh"

    cat >> ~/.zshrc << 'EOF'

# DevOps
alias rdevops='cd "$HOME/roulotte/devops"'
EOF
}

# ------------------------------------------------------------------------------
#  Mode SÉCURITÉ
# ------------------------------------------------------------------------------
install_mode_security() {
    log "${B}🔐 Installation mode SÉCURITÉ...${RESET}"

    pkg install -y openssl gnupg age >>"$LOG_FILE" 2>&1 || true

    SEC_DIR="$HOME/roulotte/security"
    mkdir -p "$SEC_DIR"

    cat > "$SEC_DIR/audit_basic.sh" << 'EOF'
#!/usr/bin/env bash
set -euo pipefail

echo "=== Audit basique Termux ==="
echo "- Utilisateur : $(whoami)"
echo "- Shell : $SHELL"
echo "- Clés SSH :"
ls -l ~/.ssh || echo "Pas de ~/.ssh"
EOF
    chmod +x "$SEC_DIR/audit_basic.sh"

    cat >> ~/.zshrc << 'EOF'

# Sécurité
alias rsec='cd "$HOME/roulotte/security"'
EOF
}

# ------------------------------------------------------------------------------
#  Mode SYNC CLOUD
# ------------------------------------------------------------------------------
install_mode_sync_cloud() {
    log "${B}☁️ Installation mode SYNC CLOUD...${RESET}"

    pkg install -y rclone >>"$LOG_FILE" 2>&1 || true

    CLOUD_DIR="$HOME/roulotte/cloud"
    mkdir -p "$CLOUD_DIR"

    cat > "$CLOUD_DIR/sync_roulotte.sh" << 'EOF'
#!/usr/bin/env bash
set -euo pipefail

REMOTE_NAME="${REMOTE_NAME:-roulotte-remote}"
LOCAL_DIR="$HOME/roulotte"
REMOTE_DIR="${REMOTE_DIR:-roulotte-backup}"

rclone sync "$LOCAL_DIR" "${REMOTE_NAME}:${REMOTE_DIR}" \
  --progress --verbose
EOF
    chmod +x "$CLOUD_DIR/sync_roulotte.sh"

    cat >> ~/.zshrc << 'EOF'

# Sync cloud
alias rcloud='cd "$HOME/roulotte/cloud"'
EOF
}

# ------------------------------------------------------------------------------
#  Installations complètes
# ------------------------------------------------------------------------------
install_standard() {
    check_internet
    optimize_termux
    update_termux
    install_core
    install_modern_tools
    configure_shell
    log "${G}✔ Installation STANDARD terminée.${RESET}"
}

install_full_pro() {
    install_standard
    install_pro_tools
    log "${G}✔ Installation PRO terminée.${RESET}"
}

install_full_roulotte() {
    install_standard
    install_roulotte_profile
    log "${G}✔ Installation ROULOTTE terminée.${RESET}"
}

install_full_ultra() {
    install_standard
    install_ultra_graphique
    log "${G}✔ Installation ULTRA-GRAPHIQUE terminée.${RESET}"
}

install_combo() {
    install_standard
    install_pro_tools
    install_roulotte_profile
    install_ultra_graphique
    log "${G}✔ Installation COMBO ULTIME terminée.${RESET}"
}

install_all_modes() {
    install_mode_terrain()
    install_mode_devops
    install_mode_security
    install_mode_sync_cloud
    log "${G}✔ Tous les modes avancés installés.${RESET}"
}

# ------------------------------------------------------------------------------
#  Menu modes avancés
# ------------------------------------------------------------------------------
menu_modes() {
    while true; do
        banner
        echo -e "${B}MODES AVANCÉS :${RESET}"
        echo -e "${G}1) Mode TERRAIN"
        echo -e "2) Mode DEVOPS avancé"
        echo -e "3) Mode SÉCURITÉ"
        echo -e "4) Mode SYNC CLOUD"
        echo -e "5) Tout installer (tous les modes)"
        echo -e "6) Retour au menu principal${RESET}"
        echo
        read -rp "👉 Choix : " m

        case "$m" in
            1) install_mode_terrain; read -rp "Entrée pour continuer...";;
            2) install_mode_devops; read -rp "Entrée pour continuer...";;
            3) install_mode_security; read -rp "Entrée pour continuer...";;
            4) install_mode_sync_cloud; read -rp "Entrée pour continuer...";;
            5) install_mode_terrain; install_mode_devops; install_mode_security; install_mode_sync_cloud; read -rp "Entrée pour continuer...";;
            6) break ;;
            *) log "${R}❌ Choix invalide.${RESET}"; sleep 1 ;;
        esac
    done
}

# ------------------------------------------------------------------------------
#  Menu principal
# ------------------------------------------------------------------------------
menu() {
    while true; do
        banner
        echo -e "${G}1) Installation STANDARD"
        echo -e "2) Profil PRO"
        echo -e "3) Profil ROULOTTE"
        echo -e "4) Profil ULTRA-GRAPHIQUE"
        echo -e "5) COMBO ULTIME (tout)"
        echo -e "6) MODES AVANCÉS (Terrain / DevOps / Sécurité / Cloud)"
        echo -e "7) Quitter${RESET}"
        echo
        read -rp "👉 Choix : " choice

        case "$choice" in
            1) install_standard; exit 0 ;;
            2) install_full_pro; exit 0 ;;
            3) install_full_roulotte; exit 0 ;;
            4) install_full_ultra; exit 0 ;;
            5) install_combo; exit 0 ;;
            6) menu_modes ;;
            7) log "${Y}👋 Sortie.${RESET}"; exit 0 ;;
            *) log "${R}❌ Choix invalide.${RESET}"; sleep 1 ;;
        esac
    done
}

# ------------------------------------------------------------------------------
#  Lancement
# ------------------------------------------------------------------------------
check_termux
menu
