#!/usr/bin/env python3
# ==============================================================================
#  La Roulotte Solidaire Toulouse – Pack utilitaire "La Route"
#  Fichier : route_tools.py
#  Fonctions :
#    - Menu central TUI
#    - GPS : distance + direction
#    - Météo rapide (wttr.in)
#    - Notes de route (horodatées)
#    - Outils d’urgence (réseau, batterie, stockage)
# ==============================================================================

import math
import argparse
import subprocess
import shutil
import os
from datetime import datetime
from pathlib import Path

try:
    import requests
except ImportError:
    requests = None

# ------------------------------------------------------------------------------
# Style
# ------------------------------------------------------------------------------

CYAN = "\033[96m"
GREEN = "\033[92m"
YELLOW = "\033[93m"
RED = "\033[91m"
RESET = "\033[0m"
BOLD = "\033[1m"

NOTES_FILE = Path("notes_route.txt")

# ------------------------------------------------------------------------------
# Bannières
# ------------------------------------------------------------------------------

def banner_main():
    os.system("clear" if os.name != "nt" else "cls")
    print(f"{CYAN}{BOLD}=== La Roulotte Solidaire Toulouse – Outils de route ==={RESET}")
    print(f"{YELLOW}Date : {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}{RESET}")
    print()

def banner(title: str):
    print(f"{CYAN}=== {title} ==={RESET}")

# ------------------------------------------------------------------------------
# GPS Helper
# ------------------------------------------------------------------------------

def haversine(lat1, lon1, lat2, lon2):
    R = 6371
    dlat = math.radians(lat2 - lat1)
    dlon = math.radians(lon2 - lon1)
    a = math.sin(dlat/2)**2 + math.cos(math.radians(lat1)) \
        * math.cos(math.radians(lat2)) * math.sin(dlon/2)**2
    return R * (2 * math.atan2(math.sqrt(a), math.sqrt(1 - a)))

def bearing(lat1, lon1, lat2, lon2):
    dlon = math.radians(lon2 - lon1)
    y = math.sin(dlon) * math.cos(math.radians(lat2))
    x = math.cos(math.radians(lat1)) * math.sin(math.radians(lat2)) \
        - math.sin(math.radians(lat1)) * math.cos(math.radians(lat2)) * math.cos(dlon)
    brng = (math.degrees(math.atan2(y, x)) + 360) % 360
    return brng

def gps_interactive():
    banner("GPS Helper – Distance & Direction")
    try:
        lat1 = float(input("Latitude point A : "))
        lon1 = float(input("Longitude point A : "))
        lat2 = float(input("Latitude point B : "))
        lon2 = float(input("Longitude point B : "))
    except ValueError:
        print(f"{RED}Entrées invalides.{RESET}")
        return

    dist = haversine(lat1, lon1, lat2, lon2)
    brng = bearing(lat1, lon1, lat2, lon2)

    print(f"{GREEN}Distance : {dist:.2f} km{RESET}")
    print(f"{YELLOW}Direction : {brng:.1f}°{RESET}")
    input("\nEntrée pour revenir au menu...")

# ------------------------------------------------------------------------------
# Météo rapide
# ------------------------------------------------------------------------------

def get_weather(city: str):
    if requests is None:
        print(f"{RED}Le module 'requests' n'est pas installé.{RESET}")
        return None
    url = f"https://wttr.in/{city}?format=j1"
    r = requests.get(url, timeout=5)
    r.raise_for_status()
    data = r.json()
    current = data["current_condition"][0]
    return {
        "temp": current["temp_C"],
        "desc": current["weatherDesc"][0]["value"],
        "wind": current["windspeedKmph"],
    }

def weather_interactive():
    banner("Météo rapide")
    city = input("Ville / lieu : ").strip()
    if not city:
        print("Aucun lieu fourni.")
        return
    try:
        w = get_weather(city)
    except Exception as e:
        print(f"{RED}Erreur météo : {e}{RESET}")
        return
    if not w:
        return
    print(f"{GREEN}Température : {w['temp']}°C{RESET}")
    print(f"Conditions : {w['desc']}")
    print(f"Vent : {w['wind']} km/h")
    input("\nEntrée pour revenir au menu...")

# ------------------------------------------------------------------------------
# Notes de route
# ------------------------------------------------------------------------------

def notes_interactive():
    banner("Notes de route")
    note = input("Note : ").strip()
    if not note:
        print("Aucune note enregistrée.")
        return
    ts = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    entry = f"[{ts}] {note}\n"
    with NOTES_FILE.open("a", encoding="utf-8") as f:
        f.write(entry)
    print(f"{GREEN}Note enregistrée dans {NOTES_FILE}{RESET}")
    input("\nEntrée pour revenir au menu...")

# ------------------------------------------------------------------------------
# Emergency tools
# ------------------------------------------------------------------------------

def check_ping():
    print("Test réseau (ping 8.8.8.8)...")
    r = subprocess.call(
        ["ping", "-c", "2", "8.8.8.8"],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )
    if r == 0:
        print(f"{GREEN}OK : Internet accessible{RESET}")
    else:
        print(f"{RED}Échec : pas de connexion{RESET}")

def check_battery():
    if shutil.which("termux-battery-status"):
        out = subprocess.check_output(["termux-battery-status"]).decode()
        print(out)
    else:
        print("Batterie : non disponible sur ce système (Termux requis).")

def check_storage():
    st = shutil.disk_usage("/")
    print(f"Espace libre : {st.free // (1024**2)} Mo")

def emergency_interactive():
    banner("Emergency Tools")
    check_ping()
    check_battery()
    check_storage()
    input("\nEntrée pour revenir au menu...")

# ------------------------------------------------------------------------------
# Menu central
# ------------------------------------------------------------------------------

def menu_loop():
    while True:
        banner_main()
        print("1) GPS – Distance & direction")
        print("2) Météo rapide")
        print("3) Notes de route")
        print("4) Outils d’urgence")
        print("0) Quitter")
        print()
        choice = input("Choix : ").strip()
        if choice == "1":
            gps_interactive()
        elif choice == "2":
            weather_interactive()
        elif choice == "3":
            notes_interactive()
        elif choice == "4":
            emergency_interactive()
        elif choice == "0":
            break
        else:
            print(f"{YELLOW}Choix invalide.{RESET}")
            input("Entrée pour continuer...")

# ------------------------------------------------------------------------------
# Mode CLI direct (sans menu)
# ------------------------------------------------------------------------------

def cli_mode():
    parser = argparse.ArgumentParser(
        description="Outils de route – La Roulotte Solidaire Toulouse"
    )
    sub = parser.add_subparsers(dest="cmd")

    gps = sub.add_parser("gps", help="Calcul distance + direction")
    gps.add_argument("lat1", type=float)
    gps.add_argument("lon1", type=float)
    gps.add_argument("lat2", type=float)
    gps.add_argument("lon2", type=float)

    meteo = sub.add_parser("meteo", help="Météo rapide")
    meteo.add_argument("city")

    notes = sub.add_parser("note", help="Ajouter une note de route")
    notes.add_argument("text", nargs="+", help="Texte de la note")

    sub.add_parser("emergency", help="Outils d’urgence")

    args = parser.parse_args()

    if not args.cmd:
        menu_loop()
        return

    if args.cmd == "gps":
        dist = haversine(args.lat1, args.lon1, args.lat2, args.lon2)
        brng = bearing(args.lat1, args.lon1, args.lat2, args.lon2)
        print(f"{GREEN}Distance : {dist:.2f} km{RESET}")
        print(f"{YELLOW}Direction : {brng:.1f}°{RESET}")
    elif args.cmd == "meteo":
        w = get_weather(args.city)
        if w:
            print(f"{GREEN}Température : {w['temp']}°C{RESET}")
            print(f"Conditions : {w['desc']}")
            print(f"Vent : {w['wind']} km/h")
    elif args.cmd == "note":
        text = " ".join(args.text)
        ts = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        entry = f"[{ts}] {text}\n"
        with NOTES_FILE.open("a", encoding="utf-8") as f:
            f.write(entry)
        print(f"{GREEN}Note enregistrée dans {NOTES_FILE}{RESET}")
    elif args.cmd == "emergency":
        emergency_interactive()

# ------------------------------------------------------------------------------
# Main
# ------------------------------------------------------------------------------

if __name__ == "__main__":
    cli_mode()
