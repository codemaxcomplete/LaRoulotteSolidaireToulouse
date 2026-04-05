#!/usr/bin/env bash
# ==============================================================================
#  La Roulotte Solidaire Toulouse - Script de maintenance avancé
#  Fichier : maintenance_roulotte.sh
#  Version : 3.0
#  Modes   :
#    - interactif (par défaut, TUI)
#    - --all              : exécute toutes les tâches
#    - --cron             : mode silencieux, pour CRON
#    - --non-interactif   : exécute une liste de tâches sans menu
#    - --dry-run          : simule sans modifier (logs + rapport)
# ==============================================================================

set -o errexit
set -o pipefail
set -o nounset

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------

PROJECT_NAME="La Roulotte Solidaire Toulouse"
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="${BASE_DIR}/logs"
REPORT_DIR="${BASE_DIR}/reports"
BACKUP_DIR="${BASE_DIR}/backups"
DATA_DIR="${BASE_DIR}/data"   # à adapter à ta structure réelle
PYTHON_BIN="python3"

mkdir -p "${LOG_DIR}" "${REPORT_DIR}" "${BACKUP_DIR}"

TIMESTAMP="$(date +'%Y%m%d_%H%M%S')"
REPORT_JSON="${REPORT_DIR}/maintenance_${TIMESTAMP}.json"
LOG_FILE="${LOG_DIR}/maintenance_$(date +'%Y%m%d').log"

DRY_RUN=false
CRON_MODE=false
NON_INTERACTIVE=false
RUN_ALL=false

# ------------------------------------------------------------------------------
# Style & Effets
# ------------------------------------------------------------------------------

RESET="\033[0m"
BOLD="\033[1m"
DIM="\033[2m"

CYAN="\033[1;36m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
WHITE="\033[1;37m"

spinner() {
    local pid=$!
    local frames=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
    while kill -0 $pid 2>/dev/null; do
        for f in "${frames[@]}"; do
            $CRON_MODE || echo -ne "  ${CYAN}${f}${RESET}  \r"
            sleep 0.1
        done
    done
    $CRON_MODE || echo -ne "                \r"
}

banner() {
    $CRON_MODE && return
    clear
    echo -e "${CYAN}"
    echo "██████╗  ██████╗ ██╗   ██╗██╗     ██╗   ██╗████████╗███████╗"
    echo "██╔══██╗██╔═══██╗██║   ██║██║     ██║   ██║╚══██╔══╝██╔════╝"
    echo "██████╔╝██║   ██║██║   ██║██║     ██║   ██║   ██║   ███████╗"
    echo "██╔══██╗██║   ██║██║   ██║██║     ██║   ██║   ██║   ╚════██║"
    echo "██████╔╝╚██████╔╝╚██████╔╝███████╗╚██████╔╝   ██║   ███████║"
    echo "╚═════╝  ╚═════╝  ╚═════╝ ╚══════╝ ╚═════╝    ╚═╝   ╚══════╝"
    echo -e "${RESET}"
    echo -e "${WHITE}${BOLD}Console de maintenance — ${PROJECT_NAME}${RESET}"
    echo -e "${DIM}$(date '+%d/%m/%Y %H:%M:%S') — Hôte : $(hostname)${RESET}"
    echo
}

log() {
    local level="$1"; shift
    local msg="$*"
    local ts
    ts="$(date +'%Y-%m-%d %H:%M:%S')"
    echo -e "${ts} [${level}] ${msg}" >> "${LOG_FILE}"
    $CRON_MODE || echo -e "${ts} [${level}] ${msg}"
}

info()  { log "INFO"  "$*"; }
warn()  { log "WARN"  "$*"; }
error() { log "ERROR" "$*"; }
ok()    { log "OK"    "$*"; }

# ------------------------------------------------------------------------------
# Rapport JSON
# ------------------------------------------------------------------------------

add_task() {
    local name="$1"
    local status="$2"
    local details="$3"

    "${PYTHON_BIN}" - <<EOF
import json, os

path="${REPORT_JSON}"

if os.path.exists(path):
    with open(path, "r", encoding="utf-8") as f:
        data=json.load(f)
else:
    data={
        "project":"${PROJECT_NAME}",
        "timestamp":"$(date +'%Y-%m-%dT%H:%M:%S')",
        "host":"$(hostname)",
        "dry_run": ${DRY_RUN},
        "tasks":[]
    }

data["tasks"].append({"name":"$name","status":"$status","details":"$details"})

with open(path,"w",encoding="utf-8") as f:
    json.dump(data,f,indent=2,ensure_ascii=False)
EOF
}

record_task() {
    local name="$1"
    local status="$2"
    local details="$3"
    add_task "$name" "$status" "$details"
}

# ------------------------------------------------------------------------------
# Tâches
# ------------------------------------------------------------------------------

task_disk() {
    info "Analyse de l’espace disque..."
    if $DRY_RUN; then
        ok "[DRY-RUN] df -h serait exécuté."
        record_task "check_disk" "success" "DRY-RUN : df -h simulé."
        return
    fi
    ( df -h > "${REPORT_DIR}/disk_${TIMESTAMP}.txt" 2>&1 ) &
    spinner
    ok "Espace disque analysé."
    record_task "check_disk" "success" "df -h exécuté, sortie enregistrée."
}

task_backup() {
    info "Sauvegarde des données..."
    if [[ ! -d "${DATA_DIR}" ]]; then
        warn "Dossier de données introuvable : ${DATA_DIR}"
        record_task "backup" "warning" "DATA_DIR introuvable : ${DATA_DIR}"
        return
    fi

    local backup_file="${BACKUP_DIR}/backup_${TIMESTAMP}.tar.gz"

    if $DRY_RUN; then
        ok "[DRY-RUN] tar -czf \"${backup_file}\" \"${DATA_DIR}\" serait exécuté."
        record_task "backup" "success" "DRY-RUN : backup simulé vers ${backup_file}."
        return
    fi

    ( tar -czf "${backup_file}" -C "${DATA_DIR}" . 2>>"${LOG_FILE}" ) &
    spinner
    ok "Sauvegarde terminée : ${backup_file}"
    record_task "backup" "success" "Backup créé : ${backup_file}"
}

task_permissions() {
    info "Vérification des permissions..."
    local paths=(
        "${BASE_DIR}"
        "${LOG_DIR}"
        "${REPORT_DIR}"
        "${BACKUP_DIR}"
    )

    local details=""
    local status="success"

    for p in "${paths[@]}"; do
        if [[ -w "${p}" ]]; then
            details+="OK: ${p} est inscriptible\n"
        else
            details+="WARN: ${p} n'est pas inscriptible\n"
            status="warning"
        fi
    done

    if [[ "${status}" == "success" ]]; then
        ok "Permissions correctes."
    else
        warn "Certaines permissions sont limitées."
    fi

    record_task "check_permissions" "${status}" "${details}"
}

task_logs_rotation() {
    info "Rotation simple des logs..."
    local rotated="${LOG_DIR}/maintenance_${TIMESTAMP}.rotated.log"

    if $DRY_RUN; then
        ok "[DRY-RUN] rotation des logs vers ${rotated}."
        record_task "logs_rotation" "success" "DRY-RUN : rotation simulée."
        return
    fi

    if [[ -f "${LOG_FILE}" ]]; then
        cp "${LOG_FILE}" "${rotated}"
        : > "${LOG_FILE}"
        ok "Rotation des logs effectuée : ${rotated}"
        record_task "logs_rotation" "success" "Logs copiés vers ${rotated} puis vidés."
    else
        warn "Aucun log à faire tourner."
        record_task "logs_rotation" "warning" "Aucun log existant."
    fi
}

run_all_tasks() {
    task_disk
    task_backup
    task_permissions
    task_logs_rotation
}

# ------------------------------------------------------------------------------
# Rapport détaillé (Python)
# ------------------------------------------------------------------------------

generate_report() {
    if [[ ! -f "${REPORT_JSON}" ]]; then
        warn "Aucun rapport JSON trouvé : ${REPORT_JSON}"
        return
    fi
    info "Génération du rapport détaillé (TXT + MD)..."
    "${PYTHON_BIN}" "${BASE_DIR}/maintenance_report.py" "${REPORT_JSON}"
    ok "Rapport détaillé généré."
}

# ------------------------------------------------------------------------------
# Menu TUI
# ------------------------------------------------------------------------------

print_menu() {
    banner
    echo -e "${WHITE}1) Vérifier l’espace disque${RESET}"
    echo -e "${WHITE}2) Sauvegarder les données${RESET}"
    echo -e "${WHITE}3) Vérifier les permissions${RESET}"
    echo -e "${WHITE}4) Rotation des logs${RESET}"
    echo -e "${WHITE}5) Lancer toutes les tâches${RESET}"
    echo -e "${WHITE}6) Générer le rapport détaillé${RESET}"
    echo -e "${WHITE}0) Quitter${RESET}"
    echo
}

interactive_loop() {
    while true; do
        print_menu
        read -rp "Choix : " c
        case "$c" in
            1) task_disk ;;
            2) task_backup ;;
            3) task_permissions ;;
            4) task_logs_rotation ;;
            5) run_all_tasks ;;
            6) generate_report ;;
            0) exit 0 ;;
            *) echo -e "${YELLOW}Choix invalide.${RESET}" ;;
        esac
        $CRON_MODE || read -rp "Entrée pour continuer..." _
    done
}

# ------------------------------------------------------------------------------
# Parsing des arguments
# ------------------------------------------------------------------------------

usage() {
    cat <<EOF
Usage : $0 [options]

Options :
  --all              Exécute toutes les tâches puis génère le rapport
  --cron             Mode silencieux (pour CRON)
  --non-interactif   Exécute sans menu (à combiner avec --all)
  --dry-run          Simule les actions sans modifier le système
  -h, --help         Affiche cette aide
EOF
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --all)
                RUN_ALL=true
                NON_INTERACTIVE=true
                shift
                ;;
            --cron)
                CRON_MODE=true
                shift
                ;;
            --non-interactif)
                NON_INTERACTIVE=true
                shift
                ;;
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            *)
                echo "Option inconnue : $1"
                usage
                exit 1
                ;;
        esac
    done
}

# ------------------------------------------------------------------------------
# Main
# ------------------------------------------------------------------------------

main() {
    parse_args "$@"

    if $NON_INTERACTIVE; then
        if $RUN_ALL; then
            run_all_tasks
            generate_report
        else
            # Non interactif sans --all : on peut adapter ici si tu veux une liste de tâches
            run_all_tasks
            generate_report
        fi
    else
        interactive_loop
    fi
}

main "$@"
