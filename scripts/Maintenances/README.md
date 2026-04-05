🧹 maintenance/ — Scripts de Maintenance
La Roulotte Solidaire Toulouse

Le dossier maintenance/ regroupe l’ensemble des scripts dédiés à la maintenance technique, à la fiabilisation du système, à la surveillance, et à la prévention des erreurs.  
Ces outils assurent la stabilité du projet, la qualité des données et la continuité des opérations.

Ils sont conçus pour être :  
- simples à exécuter pour les bénévoles techniques  
- fiables et traçables pour les responsables  
- modulaires et évolutifs pour accompagner la croissance du SI  

---

🎯 Objectifs du dossier

Les scripts de maintenance servent à :

- vérifier l’intégrité du système  
- nettoyer et optimiser les données  
- surveiller l’état des dossiers, fichiers et dépendances  
- effectuer des sauvegardes et restaurations  
- diagnostiquer les problèmes techniques  
- automatiser les routines de prévention  

---

🗂️ Structure recommandée

`plaintext
maintenance/
│
├── README.md
│
├── diagnostics/
│   ├── check_env.sh              # Vérification de l’environnement
│   ├── check_permissions.sh      # Vérification des droits d’accès
│   ├── check_integrity.sh        # Vérification des fichiers/données
│   └── system_report.sh          # Rapport complet du système
│
├── nettoyage/
│   ├── clean_temp.sh             # Nettoyage des fichiers temporaires
│   ├── clean_logs.sh             # Rotation et purge des logs
│   └── normalize_data.sh         # Normalisation des données JSON/CSV
│
├── sauvegarde/
│   ├── backup_full.sh            # Sauvegarde complète
│   ├── backup_data.sh            # Sauvegarde des données
│   └── restore.sh                # Restauration depuis une sauvegarde
│
└── modules/
    ├── logs.sh                   # Système de logs unifié
    ├── validation.sh             # Vérification des entrées
    ├── json.sh                   # Manipulation JSON
    └── outils.sh                 # Fonctions utilitaires
`

---

🧩 Fonctionnement général

✔️ Diagnostics
Les scripts du dossier diagnostics/ permettent de :  
- vérifier l’état du système  
- détecter les erreurs avant qu’elles ne deviennent critiques  
- générer des rapports lisibles pour les responsables  

✔️ Nettoyage
Les scripts du dossier nettoyage/ assurent :  
- la suppression des fichiers inutiles  
- la rotation des logs  
- la normalisation des données pour éviter les incohérences  

✔️ Sauvegardes
Les scripts du dossier sauvegarde/ garantissent :  
- des sauvegardes régulières et horodatées  
- une restauration simple et sécurisée  
- une protection contre la perte de données  

---

🚀 Utilisation

Lancer un diagnostic complet
`bash
./maintenance/diagnostics/system_report.sh
`

Nettoyer les fichiers temporaires
`bash
./maintenance/nettoyage/clean_temp.sh
`

Faire une sauvegarde complète
`bash
./maintenance/sauvegarde/backup_full.sh
`

---

🔒 Standards techniques

- set -euo pipefail dans tous les scripts  
- logs normalisés (INFO / WARN / ERROR)  
- horodatage systématique  
- aucune donnée sensible dans les logs  
- validation stricte des entrées  
- structure JSON propre et stable  

---

📌 Évolutions prévues

- intégration avec l’API interne pour la supervision  
- tableau de bord de maintenance (TUI ou web)  
- système d’alertes (mail, webhook, CLI)  
- tests automatisés pour les scripts critiques  

---
