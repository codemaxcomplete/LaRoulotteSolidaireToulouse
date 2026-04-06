📄 README.md — Modèle Multiville (Version 2.0.0)

`md

La Roulotte Solidaire — Modèle Multiville
Un modèle reproductible pour créer, déployer et coordonner une Roulotte Solidaire dans n’importe quelle ville.

Ce dépôt fournit les outils, la structure, les procédures et les bonnes pratiques nécessaires pour lancer une initiative locale d’accompagnement des personnes en grande précarité.

---

🌍 Objectif du modèle multiville

Permettre à toute équipe locale de :
- lancer une Roulotte Solidaire dans sa ville,
- utiliser des outils éprouvés,
- suivre des procédures simples et reproductibles,
- assurer une coordination efficace,
- garantir une qualité d’accompagnement cohérente.

Ce modèle est conçu pour être adaptable, léger, modulaire et accessible à tous.

---

🚀 Ce que contient ce modèle

🧩 Architecture modulaire
- Modules indépendants (terrain, logistique, coordination)
- Plugins activables selon les besoins locaux
- Configuration centralisée et simple

🖥️ Dashboard TUI (v3)
- Vue multi-équipes
- Suivi des maraudes
- Gestion des stocks/dons
- Supervision locale

📝 Formulaires terrain
- Intervention
- Besoins
- Suivi
- Orientation
- Export JSON / CSV / PDF

☁️ Synchronisation Cloud
- Mode offline
- Sync bidirectionnelle
- Gestion des conflits
- Chiffrement des données sensibles

📚 Documentation complète
- Guide de lancement d’une Roulotte
- Procédures terrain
- Organisation interne
- Communication locale
- Sécurité et confidentialité

---

🏙️ Comment créer une Roulotte dans votre ville

1. Cloner le modèle
`bash
git clone https://github.com/<organisation>/roulotte.git
cd roulotte
`

2. Configurer votre ville
Modifier le fichier :
`
config/city.yaml
`
Exemples :
- Nom de la ville
- Zones de maraude
- Équipes locales
- Partenaires

3. Installer les outils
`bash
./install.sh
`

Mode simulation :
`bash
./install.sh --dry-run
`

4. Former l’équipe locale
- Lecture du guide bénévoles
- Formation terrain
- Formation outils numériques
- Mise en situation

5. Lancer les premières maraudes
- 2 à 4 maraudes pilotes
- Collecte des retours
- Ajustements locaux

---

🧪 Tests et validation

Lancer tous les tests :
`bash
./scripts/tests/test_install.sh
`

Tester un module :
`bash
./scripts/tests/test_module.sh <module>
`

Dry-run :
`bash
./scripts/tests/testdryrun.sh
`

---

🗂️ Structure du projet

`
.
├── config/
│   └── city.yaml
├── modules/
├── dashboard/
├── forms/
├── sync/
├── scripts/
│   └── tests/
└── docs/
`

---

🤝 Rejoindre le réseau des Roulottes

Chaque ville peut :
- partager ses retours,
- proposer des améliorations,
- contribuer au modèle,
- mutualiser les ressources,
- participer aux réunions inter-villes.

---

🏁 Licence
Projet ouvert, réutilisable et modifiable dans un cadre solidaire et non lucratif.

---

❤️ Remerciements
Merci aux équipes locales, bénévoles, partenaires et personnes accompagnées qui font vivre ce modèle dans chaque ville.
`

---
