# 📘 Documentation 2.0.0 — Guide Centralisé

La Roulotte Solidaire évolue. Cette documentation 2.0.0 structure l'ensemble des ressources pour un déploiement fluide **multi-équipes** et **multi-villes**.

---

## 🗺️ Architecture de la Documentation

La documentation est désormais organisée par usage et par échelle :


docs/
├── guides/                 # Guides opérationnels & stratégiques
│   ├── multi_equipes.md    # Coordination inter-équipes
│   └── multi_villes.md     # Déploiement & gestion multi-sites
├── procedures/             # SOPs & checklists terrain
├── materiel/               # Inventaires & maintenance
├── communication/          # Charte & supports
└── formation/              # Parcours d'intégration & tutoriels
```

---

## 👥 Guide Multi-Équipes

Ce guide définit comment organiser la collaboration entre plusieurs équipes agissant sur un même périmètre.

### 1. Structure & Rôles
- **Coordinateur·rice** : Assure la liaison terrain / logistique / communication.
- **Responsable d’axe** : Gère un domaine spécifique (maraudes, distributions, accompagnement).
- **Bénévole opérationnel·le** : Applique les procédures et remonte les insights.

### 2. Communication & Synchronisation
- **Réunions courtes** : Points flash de 15 min avant/après action.
- **Outils partagés** : Utilisation de canaux dédiés par axe.
- **Transparence** : Tout compte-rendu est anonymisé et archivé dans `actions/comptes_rendus/`.

### 3. Résolution de Conflits & Feedback
- Remontée systématique via les templates `.github/ISSUE_TEMPLATE/`.
- Validation croisée avant mise à jour des procédures.

---

## 🌍 Guide Multi-Villes

La duplication du modèle sur plusieurs villes nécessite une standardisation forte couplée à une adaptation locale.

### 1. Principes de Déploiement
- **Noyau commun** : Procédures de sécurité, charte éthique, structure de base des dossiers.
- **Adaptation locale** : Chaque ville crée un sous-dossier `docs/cities/[nom_ville]/` pour spécificités géographiques, partenaires locaux et règlements.

### 2. Coordination Inter-Villes
- **Sync mensuelle** : Partage des retours terrain et optimisation des processus.
- **Mutualisation** : Partage des templates, visuels et scripts validés au niveau central.
- **Gouvernance** : Validation des modifications majeures par le noyau pilote avant dissémination.

---

## 🛠️ Bonnes Pratiques & Contribution

### 🔒 Confidentialité & Éthique
- Aucune donnée personnelle, visage identifiable ou lieu sensible non sécurisé.
- Ton neutre, bienveillant et factuel.

### 📦 Cycle de vie d'un document
1. **Brouillon** → `docs/drafts/`
2. **Revue** → PR + checklist `.github/PULL_REQUEST_TEMPLATE.md`
3. **Validation** → Archivage dans le dossier cible + mise à jour du changelog

### 🤝 Contribuer
- Utilisez les templates d’issues (`.github/ISSUE_TEMPLATE/`).
- Liez vos PR aux issues (`#numéro`).
- Respectez scrupuleusement la structure et le Code de Conduct.

---

> 📌 *Cette documentation est vivante. Elle évoluera avec les retours terrain et les besoins des équipes.*  
> 🙏 Merci pour votre engagement et votre rigueur au service de la solidarité.