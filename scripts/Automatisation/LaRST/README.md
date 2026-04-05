README.md — résumé d’installation et d’utilisation

`markdown

Roulotte User Manager — TUI avancée

Pré-requis
- Linux Mint Cinnamon (ou Debian/Ubuntu)
- Accès root (sudo)

Installation rapide
1. Copier le dossier roulotteusermanager sur la machine (par ex. /opt/roulotteusermanager).
2. Rendre les scripts exécutables :
   `bash
   sudo chmod +x installdeps.sh createadminandsetup.py usermanagertui.py
   `
3. Installer dépendances et créer un virtualenv :
   `bash
   sudo ./install_deps.sh
   source /opt/roulotteusermanager/venv/bin/activate
   `
4. Créer l'administrateur par défaut (optionnel) :
   `bash
   sudo python3 createadminand_setup.py
   `
5. Lancer l'application TUI :
   `bash
   sudo python3 usermanagertui.py
   `

Import CSV
- Exemple : sample_users.csv
- Colonnes : username,full_name,password,sudo,shell

Sécurité
- Change immédiatement le mot de passe de LaRST-Admin :
  `bash
  sudo passwd LaRST-Admin
  `
- Teste d'abord dans une VM.

Logs
- Fichier de log : /var/log/roulotteusermanager.log
`

---

6. Remarques techniques et améliorations possibles

- TUI plus riche : on peut remplacer les prompts en terminal par des formulaires Textual complets (widgets Input, Modal) pour une UX 100% TUI. J’ai choisi un mix Textual + prompts terminal pour garder le code lisible et robuste tout en offrant une interface moderne. Si tu veux, je peux convertir chaque interaction en formulaire Textual complet.  
- Sécurité mot de passe : pour la production, éviter de stocker ou transmettre des mots de passe en clair ; préférer passwd interactif ou intégration avec un coffre (Vault).  
- Import avancé : validation des doublons, génération de mots de passe sécurisés, envoi d’email d’accueil.  
- Audit : ajout d’un journal d’audit plus complet, rotation des logs, et export CSV des utilisateurs.  
- Intégration LDAP/AD : possible si tu veux centraliser les comptes.  
- Tests unitaires : on peut ajouter des tests pytest pour les fonctions non-système (parsing CSV, validation).

---
