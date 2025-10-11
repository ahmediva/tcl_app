# TCL Mobile App

Application mobile de gestion TCL (Taxe sur les établissements) pour les municipalités.

## Fonctionnalités

- **Authentification** : Connexion avec email ou nom d'utilisateur
- **Gestion des établissements** : Ajout, modification et consultation des établissements
- **Localisation** : Sélection d'arrondissements et communes avec coordonnées GPS
- **Interface intuitive** : Design moderne et responsive

## Technologies utilisées

- **Flutter** : Framework de développement mobile
- **Supabase** : Backend-as-a-Service pour l'authentification et la base de données
- **Provider** : Gestion d'état
- **Google Maps** : Intégration cartographique

## Installation

1. Cloner le projet
2. Installer les dépendances : `flutter pub get`
3. Configurer Supabase dans `lib/config/supabase_config.dart`
4. Lancer l'application : `flutter run`

## Structure du projet

```
lib/
├── config/          # Configuration Supabase et Google Maps
├── models/          # Modèles de données
├── providers/       # Gestionnaires d'état
├── screens/         # Écrans de l'application
├── services/        # Services métier
├── utils/           # Utilitaires et constantes
└── widgets/         # Composants réutilisables
```

