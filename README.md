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

- `core/` : thème, navigation et utilitaires ;
- `features/*/domain` : modèles métier ;
- `features/*/data` : contenu pédagogique embarqué ;
- `features/*/presentation` : écrans et contrôleurs Riverpod
  (la progression est persistée par `ProfileController`) ;
- `shared/` : composants visuels communs.

La police Plus Jakarta Sans est embarquée dans `assets/fonts/` (licence OFL) :
l'application ne fait aucun appel réseau.

## Vérifier

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

La CI GitHub Actions (`.github/workflows/ci.yml`) lance ces trois étapes à
chaque push sur `main` et sur chaque pull request, puis construit un APK debug
téléchargeable depuis la page du workflow.

## Publier sur Android

### 1. Créer la clé de signature (une seule fois)

```bash
keytool -genkey -v -keystore ~/kotlinlab-upload.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Sauvegarde ce fichier et ses mots de passe hors de l'ordinateur (gestionnaire
de mots de passe, copie chiffrée). Avec la signature d'application Google Play,
une clé d'importation perdue peut être réinitialisée via le support Google,
mais c'est long : mieux vaut ne pas la perdre.

### 2. Déclarer la clé

Crée `android/key.properties` (ignoré par git, ne jamais le commiter) :

```properties
storePassword=…
keyPassword=…
keyAlias=upload
storeFile=/home/<utilisateur>/kotlinlab-upload.jks
```

Sans ce fichier, la release est signée avec la clé de debug : pratique pour
tester, mais refusée par le Play Store.

### 3. Construire

```bash
flutter build appbundle --release   # à envoyer sur le Play Store
flutter build apk --release         # pour installer directement un APK
```

Avant chaque publication, augmente `version` dans `pubspec.yaml`
(`1.0.1+2` : nom de version visible + numéro de build, toujours croissant).

