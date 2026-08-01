import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../domain/learning_models.dart';

const _lessonBody = '''
# Les variables en Kotlin

Une variable permet de conserver une valeur pour la réutiliser plus tard.

## `val` ou `var` ?

Utilisez `val` pour une référence qui ne change pas. Préférez-la par défaut :

```kotlin
val language = "Kotlin"
val year = 2011
```

`var` autorise une nouvelle affectation :

```kotlin
var score = 0
score += 10
```

> **Bonne pratique** — Commencez toujours par `val`. Passez à `var` uniquement si la valeur doit réellement évoluer.

## À retenir

- Kotlin infère le type à partir de la valeur.
- Une variable doit être initialisée avant sa première lecture.
- `val` rend le code plus prévisible et plus sûr.
''';

const learningPaths = <LearningPath>[
  LearningPath(
    id: 'beginner',
    title: 'Fondations Kotlin',
    subtitle: 'Débutant · 24 leçons',
    color: AppColors.primary,
    icon: Icons.rocket_launch_rounded,
    progress: .38,
    lessons: [
      Lesson(
        id: 'intro',
        title: 'Bienvenue dans Kotlin',
        subtitle: 'Découvrir le parcours',
        duration: 4,
        xp: 20,
        status: LessonStatus.completed,
        icon: Icons.waving_hand_rounded,
      ),
      Lesson(
        id: 'hello',
        title: 'Hello, Kotlin !',
        subtitle: 'Votre premier programme',
        duration: 8,
        xp: 30,
        status: LessonStatus.completed,
        icon: Icons.terminal_rounded,
      ),
      Lesson(
        id: 'variables',
        title: 'Variables & types',
        subtitle: 'val, var et inférence',
        duration: 12,
        xp: 40,
        status: LessonStatus.current,
        icon: Icons.data_object_rounded,
        content: _lessonBody,
      ),
      Lesson(
        id: 'conditions',
        title: 'Prendre des décisions',
        subtitle: 'if, else et when',
        duration: 14,
        xp: 45,
        status: LessonStatus.locked,
        icon: Icons.alt_route_rounded,
      ),
      Lesson(
        id: 'loops',
        title: 'Répéter des actions',
        subtitle: 'for, while et ranges',
        duration: 14,
        xp: 45,
        status: LessonStatus.locked,
        icon: Icons.loop_rounded,
      ),
      Lesson(
        id: 'functions',
        title: 'Créer des fonctions',
        subtitle: 'Paramètres et retours',
        duration: 18,
        xp: 55,
        status: LessonStatus.locked,
        icon: Icons.functions_rounded,
      ),
    ],
  ),
  LearningPath(
    id: 'intermediate',
    title: 'Kotlin orienté objet',
    subtitle: 'Intermédiaire · 32 leçons',
    color: AppColors.secondary,
    icon: Icons.widgets_rounded,
    progress: .08,
    lessons: [
      Lesson(
        id: 'classes',
        title: 'Classes & objets',
        subtitle: 'Modéliser vos données',
        duration: 18,
        xp: 60,
        status: LessonStatus.current,
        icon: Icons.category_rounded,
        content: _lessonBody,
      ),
      Lesson(
        id: 'data',
        title: 'Data classes',
        subtitle: 'Des modèles concis',
        duration: 14,
        xp: 50,
        status: LessonStatus.locked,
        icon: Icons.inventory_2_rounded,
      ),
      Lesson(
        id: 'null',
        title: 'Null safety',
        subtitle: 'Éliminer les NullPointerException',
        duration: 20,
        xp: 70,
        status: LessonStatus.locked,
        icon: Icons.shield_rounded,
      ),
    ],
  ),
  LearningPath(
    id: 'advanced',
    title: 'Kotlin avancé',
    subtitle: 'Avancé · 28 leçons',
    color: Color(0xFFFF8A65),
    icon: Icons.bolt_rounded,
    progress: 0,
    lessons: [
      Lesson(
        id: 'coroutines',
        title: 'Coroutines',
        subtitle: 'Code asynchrone moderne',
        duration: 30,
        xp: 100,
        status: LessonStatus.locked,
        icon: Icons.sync_rounded,
      ),
      Lesson(
        id: 'flow',
        title: 'Flow',
        subtitle: 'Flux de données réactifs',
        duration: 28,
        xp: 100,
        status: LessonStatus.locked,
        icon: Icons.waves_rounded,
      ),
    ],
  ),
  LearningPath(
    id: 'android',
    title: 'Android & Compose',
    subtitle: 'Spécialisation · 36 leçons',
    color: AppColors.success,
    icon: Icons.android_rounded,
    progress: 0,
    lessons: [
      Lesson(
        id: 'compose',
        title: 'Jetpack Compose',
        subtitle: 'Interfaces déclaratives',
        duration: 25,
        xp: 90,
        status: LessonStatus.locked,
        icon: Icons.phone_android_rounded,
      ),
      Lesson(
        id: 'viewmodel',
        title: 'ViewModel & StateFlow',
        subtitle: 'Gérer l’état',
        duration: 28,
        xp: 95,
        status: LessonStatus.locked,
        icon: Icons.account_tree_rounded,
      ),
    ],
  ),
];

const exercises = <ExerciseItem>[
  ExerciseItem(
    id: 'ex1',
    title: 'Prédire la sortie',
    category: 'Variables',
    difficulty: 'Facile',
    xp: 20,
    icon: Icons.visibility_rounded,
    color: AppColors.secondary,
  ),
  ExerciseItem(
    id: 'ex2',
    title: 'Compléter le code',
    category: 'Conditions',
    difficulty: 'Facile',
    xp: 25,
    icon: Icons.code_rounded,
    color: AppColors.primary,
  ),
  ExerciseItem(
    id: 'ex3',
    title: 'Trouver l’erreur',
    category: 'Null safety',
    difficulty: 'Moyen',
    xp: 35,
    icon: Icons.bug_report_rounded,
    color: Color(0xFFFF8A65),
  ),
  ExerciseItem(
    id: 'ex4',
    title: 'Réordonner les lignes',
    category: 'Fonctions',
    difficulty: 'Moyen',
    xp: 40,
    icon: Icons.reorder_rounded,
    color: AppColors.accent,
  ),
  ExerciseItem(
    id: 'ex5',
    title: 'Coder une classe',
    category: 'POO',
    difficulty: 'Difficile',
    xp: 70,
    icon: Icons.architecture_rounded,
    color: AppColors.success,
  ),
];

const projects = <ProjectItem>[
  ProjectItem(
    id: 'calculator',
    title: 'Calculatrice',
    description:
        'Construisez une calculatrice en ligne de commande et maîtrisez les fonctions.',
    level: 'Débutant',
    duration: '1 h 30',
    tags: ['Fonctions', 'when'],
    color: AppColors.primary,
    icon: Icons.calculate_rounded,
  ),
  ProjectItem(
    id: 'hangman',
    title: 'Jeu du pendu',
    description:
        'Manipulez chaînes, boucles et collections dans un mini-jeu complet.',
    level: 'Débutant',
    duration: '3 h',
    tags: ['Collections', 'Boucles'],
    color: AppColors.secondary,
    icon: Icons.sports_esports_rounded,
  ),
  ProjectItem(
    id: 'todo',
    title: 'Todo Compose',
    description:
        'Une application Android soignée avec état, navigation et persistance.',
    level: 'Intermédiaire',
    duration: '8 h',
    tags: ['Compose', 'Room'],
    color: AppColors.success,
    icon: Icons.checklist_rounded,
  ),
  ProjectItem(
    id: 'bank',
    title: 'Banque Kotlin',
    description:
        'Appliquez POO, tests et architecture propre à un domaine réaliste.',
    level: 'Avancé',
    duration: '12 h',
    tags: ['Clean', 'Tests'],
    color: Color(0xFFFF8A65),
    icon: Icons.account_balance_rounded,
  ),
];
