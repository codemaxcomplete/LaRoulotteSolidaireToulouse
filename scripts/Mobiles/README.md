README Termux — La Roulotte Solidaire

Script : install.sh  
But : installer et configurer un environnement Termux complet, modulaire, sécurisé et stylé pour le projet La Roulotte. Profils, modes, plugins, hooks, auto‑update, dry‑run, logs texte + JSON.

---

Aperçu

Ce dépôt fournit un installateur tout‑en‑un pour Termux conçu pour les usages terrain, développement et opérations. Le script propose :

- Profils : standard, pro, roulotte, ultra, combo  
- Modes avancés : terrain, devops, security, cloud  
- Fonctionnalités : dry‑run, verbose, silent, self‑update, hooks pre/post, plugins, logs JSON + texte, intégrité optionnelle  
- Structure : modules, plugins, hooks, configuration YAML

Le script est pensé pour être sécurisé, maintenable, et personnalisable pour ton workflow Roulotte.

---

Démarrage rapide

1. Copier le script
`bash
mkdir -p ~/scripts/mobile
nano ~/scripts/mobile/installtermuxgodmode.sh

coller le script fourni
chmod +x ~/scripts/mobile/installtermuxgodmode.sh
`

2. Lancer en mode simulation
`bash
~/scripts/mobile/installtermuxgodmode.sh --profile standard --dry-run --verbose
`

3. Lancer l’installation réelle
`bash
~/scripts/mobile/installtermuxgodmode.sh --profile combo --modes all
`

Options utiles
- --profile standard|pro|roulotte|ultra|combo  
- --modes terrain,devops,security,cloud,all  
- --dry-run simule sans modifier le système  
- --verbose affiche les logs en direct  
- --silent n’affiche rien à l’écran, écrit uniquement les logs  
- --install-module <module> installe un module précis  
- --self-update met à jour le script si SELFUPDATEURL est configuré

---

Profils et modes

| Type | Contenu principal | Usage recommandé |
|---|---:|---|
| standard | core packages, modern tools, shell | poste de travail mobile standard |
| pro | standard + proot Ubuntu, outils DevOps | développement et opérations |
| roulotte | standard + workspace, scripts de sync | usage terrain et coordination projet |
| ultra | standard + dashboard TUI, thèmes | expérience visuelle et monitoring |
| combo | tous les profils | installation complète tout‑en‑un |
| terrain | termux‑api, capture GPS, photo | collecte terrain, formulaires |
| devops | kubectl, helm, helpers | gestion Kubernetes et CI |
| security | openssl, gnupg, audit scripts | audits et chiffrement |
| cloud | rclone, sync helpers | sauvegarde et synchronisation cloud |

---

Configuration hooks et plugins

Fichiers et emplacements
- Config YAML : ~/.config/roulotte/config.yaml  
- Plugins : ~/.local/share/roulotte-termux/plugins/*.sh (sourcés automatiquement)  
- Hooks : ~/.local/share/roulotte-termux/hooks/preinstall.sh et postinstall.sh (exécutables)

Exemples
`yaml

~/.config/roulotte/config.yaml
repo_url: "git@github.com:monorg/roulotte.git"
remote_name: "roulotte-remote"
`

Créer un plugin
`bash
cat > ~/.local/share/roulotte-termux/plugins/myplugin.sh <<'EOF'

plugin example
export MYPLUGIN_ENABLED=1
EOF
`

Créer un hook
`bash
cat > ~/.local/share/roulotte-termux/hooks/pre_install.sh <<'EOF'

!/usr/bin/env bash
echo "Hook pre_install: préparation spécifique"
EOF
chmod +x ~/.local/share/roulotte-termux/hooks/pre_install.sh
`

---

Exemples d’utilisation avancée

Installer le profil pro et le mode cloud
`bash
~/scripts/mobile/installtermuxgodmode.sh --profile pro --modes cloud
`

Installer un module précis
`bash
~/scripts/mobile/installtermuxgodmode.sh --install-module modern-tools
`

Activer l’auto‑update avant installation
`bash
export SELFUPDATEURL="https://raw.githubusercontent.com/monorg/roulotte/main/installtermuxgodmode.sh"
~/scripts/mobile/installtermuxgodmode.sh --self-update --profile standard
`

Vérifier les logs
`bash
ls -lh ~/.local/share/roulotte-termux/logs
tail -n 200 ~/.local/share/roulotte-termux/logs/install_*.log
`

---

Dépannage contribution licence

Problèmes courants
- termux-setup-storage demande une interaction : lancer manuellement et autoriser l’accès au stockage.  
- proot-distro prend du temps : patience, l’installation d’une distribution peut durer plusieurs minutes.  
- cargo absent : installer rust via pkg ou activer le module core qui installe cargo.  
- Permissions : certains hooks ou scripts demandent chmod +x.

Conseils
- Toujours tester avec --dry-run avant une installation complète.  
- Lire les logs JSON + texte pour diagnostiquer les erreurs.  
- Ajouter des hooks pour automatiser les étapes spécifiques à ton infrastructure.

Contribuer
- Forker le dépôt, ajouter un module ou plugin, ouvrir une pull request.  
- Respecter la structure modules/, plugins/, hooks/, docs/.  
- Documenter chaque ajout dans docs/ et mettre à jour le CHANGELOG.

Licence
- MIT par défaut. Ajouter un fichier LICENSE à la racine du dépôt si tu veux une autre licence.

---
