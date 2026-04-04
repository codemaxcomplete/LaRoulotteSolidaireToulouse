#!/usr/bin/env bash
# ===========================================================
# Script : volunteer_launcher.sh
# Objectif : Interface TUI pour créer ou gérer un bénévole
# ===========================================================

set -euo pipefail
IFS=$'\n\t'

DIALOG=${DIALOG=dialog}

CREATE="./create_volunteer.sh"
MANAGE="./manage_volunteer.sh"

input_field() {
    $DIALOG --clear --stdout --inputbox "$2" 10 60 --title "$1"
}

create_volunteer_tui() {
    LASTNAME=$(input_field "Nom" "Nom du bénévole :")
    FIRSTNAME=$(input_field "Prénom" "Prénom :")
    EMAIL=$(input_field "Email" "Email (optionnel) :")
    PHONE=$(input_field "Téléphone" "Téléphone (optionnel) :")
    ROLE=$(input_field "Rôle" "Rôle (maraude, logistique, cuisine…) :")
    AVAILABILITY=$(input_field "Disponibilités" "Disponibilités (jours, créneaux) :")
    NOTES=$(input_field "Notes" "Notes (optionnel) :")

    $CREATE \
        --lastname "$LASTNAME" \
        --firstname "$FIRSTNAME" \
        --email "$EMAIL" \
        --phone "$PHONE" \
        --role "$ROLE" \
        --availability "$AVAILABILITY" \
        --notes "$NOTES"

    $DIALOG --msgbox "Bénévole créé avec succès." 8 40
}

manage_volunteer_tui() {
    CHOICE=$($DIALOG --clear --stdout --menu "Gestion bénévole" 15 60 6 \
        1 "Afficher un bénévole" \
        2 "Rechercher un bénévole" \
        3 "Modifier un bénévole" \
        4 "Supprimer un bénévole" \
        5 "Exporter un bénévole")

    case "$CHOICE" in
        1)
            ID=$(input_field "Afficher" "ID du bénévole :")
            $MANAGE --show "$ID" | $DIALOG --textbox - 20 80
            ;;
        2)
            NAME=$(input_field "Rechercher" "Nom ou fragment :")
            $MANAGE --search "$NAME" | $DIALOG --textbox - 20 80
            ;;
        3)
            ID=$(input_field "Modifier" "ID du bénévole :")
            FIELD=$(input_field "Champ" "Champ à modifier :")
            VALUE=$(input_field "Valeur" "Nouvelle valeur :")
            $MANAGE --update "$ID" "$FIELD" "$VALUE"
            ;;
        4)
            ID=$(input_field "Supprimer" "ID du bénévole :")
            $MANAGE --delete "$ID"
            ;;
        5)
            ID=$(input_field "Exporter" "ID du bénévole :")
            $MANAGE --export "$ID"
            ;;
    esac
}

main_menu() {
    while true; do
        CHOICE=$($DIALOG --clear --stdout --menu "Gestion des bénévoles" 15 60 6 \
            1 "Créer un bénévole" \
            2 "Gérer les bénévoles" \
            3 "Quitter")

        case "$CHOICE" in
            1) create_volunteer_tui ;;
            2) manage_volunteer_tui ;;
            3) clear; exit 0 ;;
        esac
    done
}

main_menu
