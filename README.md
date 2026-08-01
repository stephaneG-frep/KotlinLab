# KotlinLab

KotlinLab est une application Flutter hors ligne pour apprendre Kotlin, du premier
`Hello World` aux coroutines et à Jetpack Compose.

## Démarrer

```bash
flutter pub get
flutter run
```

Le contenu pédagogique est embarqué dans l'application. La progression, les XP,
les favoris et la série quotidienne sont conservés localement avec Hive.

## Architecture

Le projet suit une architecture feature-first/MVVM :

- `core/` : thème, navigation et persistance ;
- `features/*/domain` : modèles métier ;
- `features/*/data` : contenu et dépôts locaux ;
- `features/*/presentation` : vues et view models Riverpod ;
- `shared/` : composants visuels communs.

