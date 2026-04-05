#!/usr/bin/env python3
# ==============================================================================
#  Weather Quick – La Route
# ==============================================================================

import requests
import argparse

CYAN = "\033[96m"
GREEN = "\033[92m"
RESET = "\033[0m"

def banner():
    print(f"{CYAN}=== Météo rapide – La Route ==={RESET}")

def get_weather(city):
    url = f"https://wttr.in/{city}?format=j1"
    r = requests.get(url, timeout=5)
    data = r.json()
    current = data["current_condition"][0]
    return {
        "temp": current["temp_C"],
        "desc": current["weatherDesc"][0]["value"],
        "wind": current["windspeedKmph"],
    }

def main():
    banner()
    parser = argparse.ArgumentParser()
    parser.add_argument("city", help="Ville ou lieu")
    args = parser.parse_args()

    w = get_weather(args.city)
    print(f"{GREEN}Température : {w['temp']}°C{RESET}")
    print(f"Conditions : {w['desc']}")
    print(f"Vent : {w['wind']} km/h")

if __name__ == "__main__":
    main()
