#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

DIALOG=${DIALOG=dialog}

CREATE="./create_beneficiary.sh"
MANAGE="./manage_beneficiary.sh"

input_field() {
    $DIALOG --clear --stdout --inputbox "$2" 10 60 --title "$1"
}

create_beneficiary_tui() {
    LASTNAME=$(input_field "Nom" "Nom du bénéficiaire :")
    FIRSTNAME=$(input_field "Prénom" "Prénom :")
    NICKNAME=$(input_field "Surnom" "Surnom (optionnel) :")
    PHONE=$(input_field "Téléphone" "Téléphone (optionnel) :")
    NEED=$(input_field "Besoin" "Type de besoin :")
    LOCATION=$(input_field "Lieu" "Lieu habituel :")
    NOTES=$(input_field "Notes" "Notes (optionnel) :")

    $CREATE \
        --lastname "$LASTNAME" \
        --firstname "$FIRSTNAME" \
        --nickname "$NICKNAME" \
        --phone "$PHONE" \
        --need "$NEED" \
        --location "$LOCATION" \
        --notes "$NOTES"

    $DIALOG --msgbox "Bénéficiaire créé avec succès." 8 40
}

manage_beneficiary_tui() {
    CHOICE=$($DIALOG --clear --stdout --menu "Gestion bénéficiaire" 15 60 6 \
        1 "Afficher un bénéficiaire" \
        2 "Rechercher un bénéficiaire" \
        3 "Modifier un bénéficiaire" \
        4 "Supprimer un bénéficiaire" \
        5 "Exporter un bénéficiaire")

    case "$CHOICE" in
        1)
            ID=$(input_field "Afficher" "ID du bénéficiaire :")
            $MANAGE --show "$ID" | $DIALOG --textbox - 20 80
            ;;
        2)
            NAME=$(input_field "Rechercher" "Nom ou fragment :")
            $MANAGE --search "$NAME" | $DIALOG --textbox - 20 80
            ;;
        3)
            ID=$(input_field "Modifier" "ID du bénéficiaire :")
            FIELD=$(input_field "Champ" "Champ à modifier :")
            VALUE=$(input_field "Valeur" "Nouvelle valeur :")
            $MANAGE --update "$ID" "$FIELD" "$VALUE"
            ;;
        4)
            ID=$(input_field "Supprimer" "ID du bénéficiaire :")
            $MANAGE --delete "$ID"
            ;;
        5)
            ID=$(input_field "Exporter" "ID du bénéficiaire :")
            $MANAGE --export "$ID"
            ;;
    esac
}

main_menu() {
    while true; do
        CHOICE=$($DIALOG --clear --stdout --menu "Gestion des bénéficiaires" 15 60 6 \
            1 "Créer un bénéficiaire" \
            2 "Gérer les bénéficiaires" \
            3 "Quitter")

        case "$CHOICE" in
            1) create_beneficiary_tui ;;
            2) manage_beneficiary_tui ;;
            3) clear; exit 0 ;;
        esac
    done
}

main_menu
