# Changements Pack “La Route” — Version 1.1.0

## Objectif
Rendre les outils terrain plus fiables, plus rapides et utilisables hors‑ligne.

---

## 🌐 Mode hors‑ligne
### Cache météo
- Stockage local des réponses `wttr.in`.
- Expiration configurable (par défaut : 2h).
- Utilisation automatique du cache si hors‑connexion.

### Cache GPS
- Dernière position connue enregistrée.
- Calculs de distance possibles sans réseau.

### Notes hors‑ligne
- Sauvegarde locale garantie même sans Internet.
- Synchronisation future prévue (v1.2.0).

---

## 🛠️ Améliorations générales
- Refactorisation du menu TUI.
- Messages plus clairs et plus courts.
- Gestion d’erreurs renforcée (réseau, GPS, API).
- Ajout d’un mode `--silent` pour les scripts automatisés.

---

## 📦 Nouveaux fichiers
- `cache/` (nouveau dossier)
- `cache/weather.json`
- `cache/gps.json`

---

## 🧪 Tests
- Tests hors‑ligne sur Android (Termux).
- Tests en conditions réelles (déplacements).
- Vérification du fallback automatique.
