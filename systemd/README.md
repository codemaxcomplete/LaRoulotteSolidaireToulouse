🟦 1) systemd/README.md
📍 Chemin :  
`
systemd/README.md
`

`markdown

Dossier systemd — La Roulotte Solidaire Toulouse

Ce dossier contient les fichiers modèles des services systemd utilisés par la Roulotte Solidaire Toulouse.

Contenu

- roulotte-maintenance.service
- roulotte-maintenance.timer
- roulotte-syncgit.service
- roulotte-syncgit.timer

Ces fichiers ne sont pas utilisés directement par Linux.  
Ils doivent être installés dans /etc/systemd/system/ via le script :

`
scripts/systemd/installsystemdservices.sh
`

Rôle des services

Maintenance automatique
- Exécute la maintenance quotidienne
- Génère les rapports JSON
- Gère les logs

Synchronisation Git
- Pull / add / commit / push automatique
- Détection de conflits
- Logs dédiés

Installation

`
bash scripts/systemd/installsystemdservices.sh
`

Vérification

`
bash scripts/systemd/checksystemdstatus.sh
`

Désinstallation

`
bash scripts/systemd/uninstallsystemdservices.sh
`
`

---
