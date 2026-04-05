# 🚀 API — La Roulotte Solidaire Toulouse

Cette API fournit l’ensemble des services nécessaires au fonctionnement du
Système d’Information de La Roulotte Solidaire Toulouse.

Elle permet de gérer :
- les bénéficiaires
- les bénévoles
- les maraudes
- les stocks
- les permissions
- les interactions avec les scripts Bash et les dashboards

## 📦 Structure

- `models/` : modèles de données
- `schemas/` : validation (Pydantic)
- `routes/` : endpoints API
- `services/` : logique métier
- `database/` : stockage JSON ou SQL
- `utils/` : outils (logger, permissions, validation)

## 🔐 Permissions
Trois niveaux :
- admin
- responsable
- bénévole

## 🔌 Intégration
Compatible avec :
- scripts Bash (via curl)
- dashboards web
- TUI
- outils internes
