# Scripts systemd — La Roulotte Solidaire Toulouse

Ce dossier contient les scripts permettant de gérer les services systemd du projet.

## Contenu

### `install_systemd_services.sh`
Installe automatiquement :
- roulotte-maintenance.service
- roulotte-maintenance.timer
- roulotte-syncgit.service
- roulotte-syncgit.timer

Actions :
- copie vers `/etc/systemd/system/`
- reload systemd
- active les timers
- démarre les services

### `check_systemd_status.sh`
Affiche :
- état des services
- état des timers
- dernières exécutions
- logs récents

### `uninstall_systemd_services.sh`
Supprime proprement :
- les services systemd
- les timers
- désactive les unités
- reload systemd

### `restart_systemd_services.sh`
Redémarre proprement :
- les services
- les timers
- recharge systemd

## Utilisation

Installation :
`
bash installsystemdservices.sh
`

Vérification :
`
bash checksystemdstatus.sh
`

Désinstallation :
`
bash uninstallsystemdservices.sh
`

Redémarrage :
`
bash restartsystemdservices.sh
`
`

---
