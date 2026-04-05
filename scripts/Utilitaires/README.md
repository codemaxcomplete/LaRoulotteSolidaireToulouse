📁 Utilitaire/ 
- Scripts Utilitaires
La Roulotte Solidaire Toulouse

Ce dossier regroupe l’ensemble des scripts utilitaires utilisés par La Roulotte Solidaire Toulouse pour automatiser, fiabiliser et accélérer les opérations quotidiennes : gestion des bénévoles, bénéficiaires, actions, données, sauvegardes, diagnostics, API, etc.

Ces outils sont conçus pour être :  
- simples à utiliser pour les bénévoles  
- robustes et maintenables pour les responsables techniques  
- modulaires et évolutifs pour accompagner la croissance du projet  
- compatibles Linux / Bash, avec une logique claire et documentée  

---

🧩 Objectifs du dossier

Le dossier utilitaire/ sert à :

- centraliser tous les scripts transversaux utilisés dans plusieurs actions  
- fournir des outils communs (logs, couleurs, validation, JSON, API…)  
- garantir une cohérence technique dans tout le projet  
- éviter la duplication de code  
- offrir une base solide pour les futurs outils CLI, TUI ou API

---

🗂️ Structure recommandée

`plaintext
utilitaire/
│
├── README.md                # Documentation du dossier
│
├── core/                    # Fonctions communes et modules partagés
│   ├── couleurs.sh          # Styles, couleurs, mise en forme
│   ├── logs.sh              # Système de logs unifié
│   ├── erreurs.sh           # Gestion des erreurs
│   ├── validation.sh        # Vérifications d’entrées
│   ├── json.sh              # Manipulation JSON (jq)
│   └── api.sh               # Fonctions pour appeler l’API locale
│
├── system/                  # Scripts système
│   ├── check_env.sh         # Vérification de l’environnement
│   ├── diagnostics.sh       # Diagnostic complet du système
│   └── backup.sh            # Sauvegardes automatiques
│
├── data/                    # Outils liés aux données
│   ├── export.sh            # Export CSV/JSON
│   ├── import.sh            # Import sécurisé
│   └── clean.sh             # Nettoyage et normalisation
│
└── outils/                  # Scripts utilitaires divers
    ├── horodatage.sh        # Génération d’horodatages
    ├── uuid.sh              # Génération d’identifiants uniques
    └── notify.sh            # Notifications locales (CLI)
`

---

⚙️ Standards techniques

Tous les scripts suivent les règles suivantes :

✔️ Qualité & Robustesse
- Mode strict : set -euo pipefail
- Gestion d’erreurs centralisée
- Logs normalisés (INFO / WARN / ERROR)
- Messages lisibles pour les bénévoles

✔️ Accessibilité & Clarté
- Noms explicites  
- Aucune abréviation obscure  
- Commentaires pédagogiques  
- Messages en français clair  

✔️ Modulaire & Réutilisable
- Chaque script fait une seule chose  
- Les fonctions communes sont dans core/  
- Aucun code dupliqué  

---

🚀 Utilisation

Exécuter un script
`bash
./utilitaire/system/diagnostics.sh
`

Charger les modules communs dans un script
`bash
source "$(dirname "$0")/../core/logs.sh"
source "$(dirname "$0")/../core/erreurs.sh"
`

Exemple d’appel API
`bash
api_get "/beneficiaires/liste"
`

---

🛡️ Sécurité & Données

- Aucun script ne doit manipuler des données sensibles sans validation.  
- Les exports sont anonymisés par défaut.  
- Les logs ne doivent jamais contenir d’informations personnelles.  

---

📌 Évolutions prévues

- Intégration complète avec l’API interne  
- Ajout d’une TUI (interface terminal) pour les bénévoles  
- Système de tests automatisés pour les scripts  
- Documentation interactive (mkdocs ou docs/)

---
