import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../domain/learning_models.dart';

/// Textes génériques, utilisés tant qu'une leçon n'a pas son propre contenu.
const genericMistakes = [
  'Reproduire mécaniquement les habitudes de Java au lieu d’utiliser les idiomes Kotlin.',
  'Rendre une valeur nullable ou mutable sans nécessité.',
  'Écrire une expression compacte qui devient difficile à relire.',
];
const genericJava =
    'Kotlin supprime une grande partie du code cérémoniel de Java. Les types restent stricts, tandis que l’inférence, les expressions et la null safety rendent l’intention plus visible.';
const genericMemo = [
  'Commence par la solution la plus simple.',
  'Préfère les valeurs immuables.',
  'Fais exprimer les contraintes par le système de types.',
  'Donne des noms qui expliquent le métier.',
];
const genericChallenge =
    'Réécris l’exemple avec tes propres données, puis ajoute un cas limite. Explique le résultat attendu avant de lancer le code.';

Lesson _lesson({
  required String id,
  required String title,
  required String subtitle,
  required String concept,
  required String code,
  required String practice,
  required IconData icon,
  required String level,
  int duration = 15,
  int xp = 45,
  List<String> mistakes = genericMistakes,
  String java = genericJava,
  List<String> memo = genericMemo,
  String challenge = genericChallenge,
}) => Lesson(
  id: id,
  title: title,
  subtitle: subtitle,
  duration: duration,
  xp: xp,
  icon: icon,
  level: level,
  content: _course(
    title: title,
    concept: concept,
    code: code.replaceAll(r'\n', '\n'),
    practice: practice,
    mistakes: mistakes,
    java: java,
    memo: memo,
    challenge: challenge,
  ),
);

String _course({
  required String title,
  required String concept,
  required String code,
  required String practice,
  required List<String> mistakes,
  required String java,
  required List<String> memo,
  required String challenge,
}) =>
    '''
# $title

## Objectifs

- Comprendre le rôle de **$title** dans un programme Kotlin.
- Lire et expliquer un exemple idiomatique.
- Appliquer le concept dans un petit programme autonome.

## Comprendre

$concept

```kotlin
$code
```

## Lecture du code

Observe les types, les valeurs qui peuvent évoluer et le résultat de chaque expression. Kotlin privilégie un code concis, mais la concision ne doit jamais masquer l’intention.

> **Bonne pratique** — $practice

## Erreurs fréquentes

${mistakes.map((item) => '- $item').join('\n')}

## Comparaison avec Java

$java

## Mémo

${[for (var i = 0; i < memo.length; i++) '${i + 1}. ${memo[i]}'].join('\n')}

## Défi

$challenge
''';

final learningPaths = <LearningPath>[
  LearningPath(
    id: 'beginner',
    title: 'Fondations Kotlin',
    subtitle: 'Débutant · 12 leçons',
    color: AppColors.primary,
    icon: Icons.rocket_launch_rounded,
    lessons: [
      _lesson(
        id: 'intro',
        title: 'Bienvenue dans Kotlin',
        subtitle: 'Pourquoi apprendre Kotlin',
        concept:
            'Kotlin est un langage moderne, statiquement typé et interopérable avec Java. Il sert au développement Android, serveur, desktop et multiplateforme.',
        code: 'fun main() {\n    println("Bienvenue dans KotlinLab")\n}',
        practice:
            'Exécute de petits programmes souvent : une boucle de retour rapide accélère l’apprentissage.',
        mistakes: [
          r'''Penser que Kotlin ne sert qu’à Android : il cible aussi la JVM côté serveur, le web (Kotlin/JS et Wasm) et le natif.''',
          r'''Croire qu’il faut maîtriser Java avant de commencer : Kotlin s’apprend directement.''',
          r'''Oublier `main` : c’est le point d’entrée, sans elle le programme ne s’exécute pas.''',
        ],
        java:
            r'''En Java, le même programme demande une classe et une méthode statique :

```java
public class Main {
    public static void main(String[] args) {
        System.out.println("Bienvenue dans KotlinLab");
    }
}
```

En Kotlin, une fonction peut exister en dehors de toute classe : `fun main()` suffit.''',
        memo: [
          r'''Kotlin est statiquement typé : les erreurs de type sont détectées à la compilation.''',
          r'''Il est interopérable avec Java : les deux langages peuvent cohabiter dans un même projet.''',
          r'''Le point d’entrée est `fun main()`.''',
          r'''Le point-virgule en fin de ligne est facultatif.''',
        ],
        challenge:
            r'''Modifie le programme pour afficher deux lignes : ton prénom, puis la raison pour laquelle tu apprends Kotlin.''',
        icon: Icons.waving_hand_rounded,
        level: 'Débutant',
        duration: 6,
        xp: 20,
      ),
      _lesson(
        id: 'hello',
        title: 'Premier programme',
        subtitle: 'main et println',
        concept:
            'L’exécution commence généralement dans une fonction main. println écrit une valeur suivie d’un retour à la ligne.',
        code:
            r'fun main() {\n    val learner = "Ada"\n    println("Bonjour, $learner !")\n}',
        practice:
            'Utilise l’interpolation de chaînes plutôt que de longues concaténations avec +.',
        mistakes: [
          r'''Confondre `print` et `println` : `print` n’ajoute pas de retour à la ligne.''',
          r'''Écrire `"Bonjour, " + learner + " !"` alors que `"Bonjour, $learner !"` est plus lisible.''',
          r'''Oublier les accolades autour d’une expression : `"$learner.length"` affiche le prénom suivi de `.length`, il faut écrire `"${learner.length}"`.''',
        ],
        java:
            r'''Java n’a pas d’interpolation de chaînes : on concatène avec `+` ou on passe par `String.format`.

```java
String learner = "Ada";
System.out.println("Bonjour, " + learner + " !");
```

Kotlin intègre les templates directement dans les chaînes.''',
        memo: [
          r'''`println(x)` affiche `x` puis passe à la ligne.''',
          r'''`$nom` insère la valeur d’une variable.''',
          r'''`${expression}` insère le résultat d’une expression.''',
          r'''`fun main(args: Array<String>)` permet de lire les arguments de la ligne de commande.''',
        ],
        challenge:
            r'''Déclare ton prénom et ton âge, puis affiche « Ada aura 37 ans l’an prochain » en calculant l’âge directement dans le template avec `${}`.''',
        icon: Icons.terminal_rounded,
        level: 'Débutant',
        duration: 8,
        xp: 30,
      ),
      _lesson(
        id: 'variables',
        title: 'Variables & types',
        subtitle: 'val, var et inférence',
        concept:
            'val crée une référence non réassignable et var une référence modifiable. Kotlin infère souvent le type depuis la valeur initiale.',
        code:
            r'val language: String = "Kotlin"\nvar score = 0\nscore += 10\nprintln("$language : $score XP")',
        practice:
            'Commence toujours par val et ne passe à var que si la réassignation est nécessaire.',
        mistakes: [
          r'''Utiliser `var` par réflexe : chaque `var` est un état supplémentaire à suivre.''',
          r'''Croire que `val` rend l’objet immuable : avec `val list = mutableListOf(1)`, on ne peut pas réassigner `list`, mais `list.add(2)` fonctionne.''',
          r'''Déclarer `var x` sans valeur ni type : Kotlin exige une valeur initiale ou un type explicite.''',
        ],
        java:
            r'''`val` correspond à une variable `final` en Java, et l’inférence au `var` de Java 10 :

```java
final String language = "Kotlin";
int score = 0;
score += 10;
```

En Kotlin, la version immuable est aussi courte à écrire que la version modifiable, ce qui encourage les bonnes habitudes.''',
        memo: [
          r'''`val` : lecture seule après l’initialisation.''',
          r'''`var` : réassignable.''',
          r'''Le type est inféré : `val n = 3` est un `Int`.''',
          r'''Un type explicite s’écrit après deux-points : `val n: Long = 3`.''',
        ],
        challenge:
            r'''Écris un compteur de points : un `val` pour le nom du joueur, un `var` pour le score. Ajoute trois victoires de 10 points et affiche le total. Essaie ensuite de réassigner le nom et lis le message d’erreur du compilateur.''',
        icon: Icons.data_object_rounded,
        level: 'Débutant',
        duration: 14,
        xp: 40,
      ),
      _lesson(
        id: 'basic_types',
        title: 'Types essentiels',
        subtitle: 'Nombres, textes et booléens',
        concept:
            'String, Int, Long, Double, Boolean et Char couvrent la majorité des premières données. Les conversions sont explicites.',
        code:
            'val age = 28\nval price = 19.99\nval active = true\nval initial = \'K\'\nprintln(age.toDouble() + price)',
        practice:
            'Choisis le type qui traduit le domaine, pas simplement le plus grand type.',
        mistakes: [
          r'''Attendre une conversion automatique : `val total: Double = age` ne compile pas, il faut écrire `age.toDouble()`.''',
          r'''Diviser deux `Int` en espérant une décimale : `7 / 2` vaut `3`.''',
          r'''Confondre `'K'` (un `Char`) et `"K"` (une `String`).''',
        ],
        java:
            r'''Java distingue les types primitifs (`int`) et leurs classes enveloppes (`Integer`). Kotlin n’a qu’un seul type `Int` : le compilateur utilise un primitif quand c’est possible.

Java élargit aussi implicitement un `int` en `double`. Kotlin refuse : chaque conversion est écrite, donc visible.''',
        memo: [
          r'''`Int` (32 bits), `Long` (64 bits, suffixe `L`), `Double`, `Boolean`, `Char`, `String`.''',
          r'''Les conversions sont explicites : `toInt()`, `toDouble()`, `toString()`.''',
          r'''`"42".toInt()` lève une exception si le texte n’est pas un nombre ; `toIntOrNull()` renvoie `null`.''',
          r'''Les grands nombres se lisent mieux avec des tirets bas : `1_000_000`.''',
        ],
        challenge:
            r'''Convertis le texte `"19.99"` en `Double`, ajoute une TVA de 20 % et affiche le résultat. Teste ensuite `"abc".toDoubleOrNull()` et explique ce qui s’affiche.''',
        icon: Icons.text_fields_rounded,
        level: 'Débutant',
      ),
      _lesson(
        id: 'operators',
        title: 'Opérateurs',
        subtitle: 'Calculer et comparer',
        concept:
            'Les opérateurs arithmétiques calculent des valeurs. Les opérateurs de comparaison et logiques construisent des conditions booléennes.',
        code:
            r'val subtotal = 80.0\nval freeDelivery = subtotal >= 50.0\nval total = subtotal * 1.20\nprintln("Total: $total, offerte: $freeDelivery")',
        practice:
            'Décompose les conditions complexes dans des variables booléennes bien nommées.',
        mistakes: [
          r'''Comparer des chaînes avec `===` : `==` compare le contenu, `===` compare les références.''',
          r'''Oublier que `&&` et `||` court-circuitent : la partie droite peut ne jamais être évaluée.''',
          r'''Écrire `a > 0 && !(b < 10 || c)` au lieu de nommer chaque condition dans un `val`.''',
        ],
        java:
            r'''En Java, `==` compare les références des objets : il faut `equals()` pour comparer le contenu de deux chaînes.

En Kotlin, `==` appelle `equals()` et gère `null` : `"a" == "a"` fait ce qu’on attend. L’égalité de référence s’écrit `===`.''',
        memo: [
          r'''Arithmétique : `+ - * / %`.''',
          r'''Affectation composée : `+= -= *= /=`.''',
          r'''Comparaison : `== != < > <= >=`.''',
          r'''Logique : `&& || !`.''',
          r'''`in` teste l’appartenance : `x in 1..10`.''',
        ],
        challenge:
            r'''Détermine si une commande a droit à la livraison gratuite : sous-total d’au moins 50 € ou client premium, mais jamais pour une adresse hors zone. Nomme chaque condition dans un `val` booléen.''',
        icon: Icons.calculate_rounded,
        level: 'Débutant',
      ),
      _lesson(
        id: 'conditions',
        title: 'Conditions',
        subtitle: 'if, else et when',
        concept:
            'if et when sont des expressions : elles peuvent produire directement une valeur. when évite les cascades difficiles à lire.',
        code:
            'val score = 82\nval grade = when {\n    score >= 90 -> "A"\n    score >= 75 -> "B"\n    else -> "C"\n}\nprintln(grade)',
        practice:
            'Utilise when quand plusieurs branches représentent un même choix métier.',
        mistakes: [
          r'''Oublier `else` dans un `when` utilisé comme expression : le compilateur l’exige s’il ne peut pas prouver que tous les cas sont couverts.''',
          r'''Mettre les branches dans le mauvais ordre : `when` s’arrête à la première branche vraie, donc `score >= 75` placé avant `score >= 90` capture aussi les A.''',
          r'''Écrire `if (x) { y = 1 } else { y = 2 }` au lieu de `val y = if (x) 1 else 2`.''',
        ],
        java:
            r'''Java a l’opérateur ternaire `cond ? a : b`. Kotlin n’en a pas besoin : `if` est déjà une expression qui renvoie une valeur.

`when` remplace `switch` et accepte des valeurs multiples (`1, 2 ->`), des intervalles (`in 3..9 ->`), des tests de type (`is String ->`) ou des conditions quelconques.''',
        memo: [
          r'''`val x = if (condition) a else b`.''',
          r'''`when (valeur) { 1, 2 -> … ; in 3..9 -> … ; else -> … }`.''',
          r'''`when { condition -> … }` s’écrit aussi sans argument.''',
          r'''Les branches sont testées dans l’ordre.''',
        ],
        challenge:
            r'''Écris une fonction `shippingCost(weight: Double): Double` avec `when` : gratuit jusqu’à 0,5 kg, 4,90 € jusqu’à 2 kg, 9,90 € au-delà. Teste 0.5, 2.0 et 10.0 pour vérifier les bornes.''',
        icon: Icons.alt_route_rounded,
        level: 'Débutant',
        duration: 16,
        xp: 50,
      ),
      _lesson(
        id: 'loops',
        title: 'Boucles & ranges',
        subtitle: 'for, while et répétitions',
        concept:
            'for parcourt une séquence ou un intervalle. while convient quand le nombre de répétitions n’est pas connu à l’avance.',
        code:
            'for (number in 1..5) {\n    println(number * number)\n}\nfor (index in 10 downTo 0 step 2) println(index)',
        practice:
            'Pour transformer une collection, préfère souvent map ou filter à une boucle avec état mutable.',
        mistakes: [
          r'''Confondre `1..5` (5 inclus) et `1 until 5` (5 exclu).''',
          r'''Écrire `for (i in 10..0)` : l’intervalle est vide, il faut `10 downTo 0`.''',
          r'''Parcourir les indices pour lire chaque élément : `for (item in list)` suffit, et `withIndex()` donne l’indice et l’élément.''',
        ],
        java:
            r'''La boucle Java `for (int i = 0; i < n; i++)` s’écrit `for (i in 0 until n)` en Kotlin.

Il n’y a pas de boucle à trois parties : on parcourt toujours un intervalle ou une collection. `while` et `do … while` existent dans les deux langages.''',
        memo: [
          r'''`1..5` inclut 5 ; `1 until 5` et `1..<5` l’excluent.''',
          r'''`downTo` descend, `step` change le pas.''',
          r'''`for ((index, item) in list.withIndex())` donne l’indice et la valeur.''',
          r'''`break` et `continue` fonctionnent comme en Java.''',
        ],
        challenge:
            r'''Affiche la table de multiplication de 7 de 1 à 10, puis uniquement les résultats pairs. Réécris ensuite la seconde version sans boucle, avec `(1..10).map { … }.filter { … }`.''',
        icon: Icons.loop_rounded,
        level: 'Débutant',
      ),
      _lesson(
        id: 'functions',
        title: 'Fonctions',
        subtitle: 'Paramètres et retours',
        concept:
            'Une fonction rassemble une responsabilité nommée. Les paramètres par défaut et les expressions simples réduisent les surcharges.',
        code:
            'fun finalPrice(price: Double, discount: Double = 0.0): Double =\n    price * (1 - discount)\n\nprintln(finalPrice(100.0, discount = 0.15))',
        practice:
            'Écris des fonctions courtes dont le nom décrit le résultat ou l’action.',
        mistakes: [
          r'''Multiplier les surcharges au lieu d’utiliser des paramètres par défaut.''',
          r'''Passer plusieurs paramètres du même type sans les nommer : `finalPrice(100.0, 0.15)` est ambigu, `discount = 0.15` est clair.''',
          r'''Oublier le type de retour d’une fonction à corps bloc : sans `: Double`, une fonction écrite avec `{ }` renvoie `Unit`.''',
        ],
        java:
            r'''Java n’a ni paramètres par défaut ni arguments nommés : on écrit plusieurs surcharges de la même méthode.

En Kotlin, une fonction peut aussi être déclarée directement dans un fichier, sans classe utilitaire remplie de méthodes `static`.''',
        memo: [
          r'''`fun nom(param: Type): Retour { … }`.''',
          r'''Corps expression : `fun double(x: Int) = x * 2`.''',
          r'''Valeur par défaut : `discount: Double = 0.0`.''',
          r'''Argument nommé à l’appel : `finalPrice(100.0, discount = 0.15)`.''',
          r'''`Unit` signale qu’une fonction ne renvoie pas de valeur utile.''',
        ],
        challenge:
            r'''Écris `formatPrice(amount: Double, currency: String = "€", decimals: Int = 2): String`. Appelle-la de trois façons différentes, dont une qui ne précise que `decimals`, en argument nommé.''',
        icon: Icons.functions_rounded,
        level: 'Débutant',
        duration: 18,
        xp: 55,
      ),
      _lesson(
        id: 'strings',
        title: 'Chaînes de caractères',
        subtitle: 'Interpolation et manipulation',
        concept:
            'Les chaînes offrent interpolation, textes multi-lignes et de nombreuses transformations sans modifier la valeur originale.',
        code:
            'val raw = "  kotlin lab  "\nval words = raw.trim().split(" ")\nval title = words.joinToString(" ") { it.replaceFirstChar(Char::uppercase) }\nprintln(title)',
        practice:
            'Utilise la bibliothèque standard avant de réinventer un traitement de texte.',
        mistakes: [
          r'''Croire que `trim()` modifie la chaîne : il renvoie une nouvelle chaîne, il faut récupérer le résultat.''',
          r'''Concaténer dans une boucle avec `+=` : `buildString { }` ou `joinToString` sont plus lisibles et plus efficaces.''',
          r'''Comparer sans tenir compte de la casse en appelant `lowercase()` des deux côtés : `a.equals(b, ignoreCase = true)` existe.''',
        ],
        java:
            r'''Comme en Java, les `String` sont immuables. Kotlin ajoute les templates, les chaînes brutes `"""…"""` (proches des text blocks de Java) et de nombreuses fonctions : `trim`, `split`, `replaceFirstChar`, `removePrefix`, `padStart`…''',
        memo: [
          r'''`"Bonjour $nom"` et `"${a + b}"`.''',
          r'''`trim`, `split`, `uppercase`, `lowercase`, `replace`.''',
          r'''`"""…""".trimIndent()` pour un texte sur plusieurs lignes.''',
          r'''`joinToString(", ")` assemble les éléments d’une liste.''',
        ],
        challenge:
            r'''Transforme `"  ada LOVELACE  "` en `"Ada Lovelace"`. Indice : `trim()`, `lowercase()`, `split(" ")`, puis `replaceFirstChar`.''',
        icon: Icons.short_text_rounded,
        level: 'Débutant',
      ),
      _lesson(
        id: 'lists',
        title: 'Listes',
        subtitle: 'Collections ordonnées',
        concept:
            'listOf crée une liste en lecture seule. mutableListOf autorise les ajouts. map, filter et sortedBy composent des traitements.',
        code:
            'val scores = listOf(12, 18, 9, 16)\nval passed = scores\n    .filter { it >= 10 }\n    .map { it * 5 }\nprintln(passed)',
        practice:
            'Expose une List en lecture seule même si l’implémentation interne est mutable.',
        mistakes: [
          r'''Croire que `listOf` est vraiment immuable : c’est une vue en lecture seule, pas une copie protégée.''',
          r'''Lire `list[5]` sur une liste de 3 éléments : `IndexOutOfBoundsException`. `getOrNull(5)` renvoie `null`.''',
          r'''Enchaîner `filter` puis `first()` sans penser au cas vide : `first()` lève une exception, `firstOrNull()` non.''',
        ],
        java:
            r'''Java propose `List.of(…)`, et les traitements passent par `stream()` puis `collect(…)`.

En Kotlin, `map`, `filter` ou `sortedBy` s’appellent directement sur la liste et renvoient une nouvelle `List`.''',
        memo: [
          r'''`listOf` : lecture seule ; `mutableListOf` : modifiable.''',
          r'''`list[0]`, `first()`, `last()`, `getOrNull(i)`.''',
          r'''`filter`, `map`, `sortedBy`, `sum`, `average`.''',
          r'''`in` teste la présence d’un élément : `3 in list`.''',
        ],
        challenge:
            r'''À partir de `listOf("kiwi", "pomme", "fraise", "ananas")`, affiche les fruits de plus de 5 lettres, triés par longueur, en majuscules et séparés par des virgules.''',
        icon: Icons.view_list_rounded,
        level: 'Débutant',
        duration: 18,
        xp: 55,
      ),
      _lesson(
        id: 'sets_maps',
        title: 'Sets & Maps',
        subtitle: 'Unicité et associations',
        concept:
            'Set garantit l’unicité des éléments. Map associe une clé unique à une valeur et facilite les recherches directes.',
        code:
            'val tags = setOf("kotlin", "android", "kotlin")\nval capitals = mapOf("France" to "Paris", "Japon" to "Tokyo")\nprintln(tags.size)\nprintln(capitals["France"])',
        practice:
            'Choisis la collection selon l’opération principale : ordre, unicité ou accès par clé.',
        mistakes: [
          r'''Traiter `map["clé"]` comme une valeur non nulle : le résultat est nullable car la clé peut manquer. Utilise `?:` pour une valeur de repli.''',
          r'''Utiliser une `List` puis `distinct()` après chaque ajout, alors qu’un `Set` garantit déjà l’unicité.''',
          r'''Vouloir modifier une `Map` créée avec `mapOf` : elle n’a pas de `put`, il faut `mutableMapOf`.''',
        ],
        java:
            r'''`"France" to "Paris"` crée une `Pair` : c’est plus concis que `Map.of("France", "Paris")` ou qu’une série de `put`.

L’accès `capitals["France"]` remplace `capitals.get("France")`.''',
        memo: [
          r'''`setOf`, `mutableSetOf` : aucun doublon.''',
          r'''`mapOf(clé to valeur)`, `mutableMapOf()`.''',
          r'''`map[clé]` renvoie un type nullable.''',
          r'''`for ((clé, valeur) in map)` parcourt les entrées.''',
        ],
        challenge:
            r'''Compte les occurrences de chaque mot dans `"le chat et le chien et le lapin"` avec une `mutableMapOf<String, Int>()`, puis refais-le en une ligne avec `groupingBy { it }.eachCount()`.''',
        icon: Icons.hub_rounded,
        level: 'Débutant',
      ),
      _lesson(
        id: 'beginner_review',
        title: 'Révision des fondations',
        subtitle: 'Assembler les concepts',
        concept:
            'Un petit programme complet combine fonctions, conditions et collections. La décomposition évite une fonction main gigantesque.',
        code:
            'fun average(values: List<Int>) = values.average()\n\nfun main() {\n    val scores = listOf(14, 18, 11)\n    val result = average(scores)\n    println(if (result >= 10) "Validé" else "À revoir")\n}',
        practice:
            'Avant de coder, écris les entrées, le résultat attendu et deux cas limites.',
        mistakes: [
          r'''Tout écrire dans `main` : isole chaque calcul dans une fonction que tu peux tester seule.''',
          r'''Oublier la liste vide : `emptyList<Int>().average()` renvoie `NaN`, et `NaN >= 10` est faux.''',
          r'''Mélanger calcul et affichage : une fonction qui renvoie une valeur se réutilise plus facilement qu’une fonction qui affiche.''',
        ],
        java:
            r'''En Java, le même programme demanderait une classe, une méthode statique `average` et un stream (`mapToInt(…).average().orElse(0)`).

En Kotlin, des fonctions de premier niveau et les fonctions de collection suffisent.''',
        memo: [
          r'''Une fonction, une responsabilité.''',
          r'''Des entrées et sorties explicites rendent le code testable.''',
          r'''Pense toujours aux cas limites : vide, zéro, négatif.''',
          r'''`if` est une expression utilisable directement dans `println`.''',
        ],
        challenge:
            r'''Écris un mini-bulletin : une `Map` qui associe un nom à une liste de notes. Pour chaque élève, affiche sa moyenne arrondie à une décimale suivie de « Validé » ou « À revoir ». Prévois un élève sans aucune note.''',
        icon: Icons.school_rounded,
        level: 'Débutant',
        duration: 22,
        xp: 70,
      ),
    ],
  ),
  LearningPath(
    id: 'intermediate',
    title: 'Kotlin orienté objet',
    subtitle: 'Intermédiaire · 10 leçons',
    color: AppColors.secondary,
    icon: Icons.widgets_rounded,
    lessons: [
      _lesson(
        id: 'classes',
        title: 'Classes & objets',
        subtitle: 'Modéliser un domaine',
        concept:
            'Une classe réunit état et comportement cohérents. Le constructeur principal se place dans l’en-tête de la classe.',
        code:
            'class BankAccount(val owner: String, initial: Double) {\n    var balance = initial\n        private set\n    fun deposit(amount: Double) {\n        require(amount > 0)\n        balance += amount\n    }\n}',
        practice:
            'Protège les invariants dans la classe plutôt que de laisser chaque appelant les vérifier.',
        mistakes: [
          r'''Exposer `var balance` en public : n’importe qui peut écrire `account.balance = -500.0`. `private set` garde la lecture publique et réserve l’écriture à la classe.''',
          r'''Confondre paramètre et propriété : sans `val`, `initial` n’est qu’un paramètre du constructeur, inaccessible depuis les méthodes.''',
          r'''Écrire `new BankAccount(…)` : Kotlin n’a pas de mot-clé `new`.''',
        ],
        java:
            r'''En Java, il faut déclarer les champs, un constructeur qui les affecte, puis des getters :

```java
public class BankAccount {
    private final String owner;
    private double balance;

    public BankAccount(String owner, double initial) {
        this.owner = owner;
        this.balance = initial;
    }

    public String getOwner() { return owner; }
    public double getBalance() { return balance; }
}
```

Une propriété Kotlin regroupe champ, getter et setter, et le constructeur principal tient dans l’en-tête de la classe.''',
        memo: [
          r'''`class Nom(val a: Type)` déclare et initialise une propriété en une fois.''',
          r'''Classes et membres sont `public` et `final` par défaut.''',
          r'''`private set` : lecture publique, écriture réservée à la classe.''',
          r'''`require(condition) { "message" }` lève une `IllegalArgumentException` si la condition est fausse.''',
        ],
        challenge:
            r'''Ajoute une méthode `withdraw(amount: Double)` qui refuse un montant négatif ou supérieur au solde, avec un message d’erreur explicite. Écris trois appels, dont un qui doit échouer, et vérifie le message obtenu.''',
        icon: Icons.category_rounded,
        level: 'Intermédiaire',
        duration: 20,
        xp: 65,
      ),
      _lesson(
        id: 'constructors',
        title: 'Constructeurs',
        subtitle: 'Initialiser correctement',
        concept:
            'Le constructeur principal définit les dépendances essentielles. init valide ou prépare l’état à la création.',
        code:
            'class User(val name: String, val age: Int) {\n    init {\n        require(name.isNotBlank())\n        require(age >= 0)\n    }\n}',
        practice:
            'Un objet valide dès sa construction réduit les vérifications ailleurs.',
        mistakes: [
          r'''Valider les données après la création : l’objet invalide a déjà circulé. `init` vérifie tout dès la construction.''',
          r'''Multiplier les constructeurs secondaires : des valeurs par défaut dans le constructeur principal suffisent presque toujours.''',
          r'''Utiliser une propriété dans `init` avant sa déclaration : initialiseurs et blocs `init` s’exécutent dans l’ordre où ils apparaissent dans la classe.''',
        ],
        java:
            r'''Java demande un constructeur par combinaison de paramètres, ou un pattern Builder.

En Kotlin, `class User(val name: String, val age: Int = 0)` accepte à la fois `User("Ada")` et `User("Ada", 36)`, et les arguments nommés rendent le Builder rarement nécessaire.''',
        memo: [
          r'''Le constructeur principal se place dans l’en-tête de la classe.''',
          r'''`init { … }` s’exécute à chaque création, dans l’ordre de déclaration.''',
          r'''Constructeur secondaire : `constructor(…) : this(…)`.''',
          r'''Paramètres par défaut et arguments nommés évitent les surcharges.''',
        ],
        challenge:
            r'''Crée une classe `Temperature(val celsius: Double)` qui refuse les valeurs inférieures à -273.15 dans `init`. Ajoute une propriété calculée `val fahrenheit get() = celsius * 9 / 5 + 32` et teste-la avec 0 et 100.''',
        icon: Icons.build_circle_rounded,
        level: 'Intermédiaire',
      ),
      _lesson(
        id: 'data',
        title: 'Data classes',
        subtitle: 'Des modèles concis',
        concept:
            'data class génère equals, hashCode, toString, componentN et copy à partir des propriétés principales.',
        code:
            'data class User(val id: Long, val name: String)\nval ada = User(1, "Ada")\nval updated = ada.copy(name = "Ada Lovelace")',
        practice: 'Réserve les data classes aux valeurs et modèles de données.',
        mistakes: [
          r'''Déclarer une propriété dans le corps de la classe en pensant qu’elle compte : seules les propriétés du constructeur principal participent à `equals`, `hashCode`, `toString` et `copy`.''',
          r'''Mettre des `var` dans une data class utilisée comme clé de `Map` ou élément de `Set` : modifier une propriété change le `hashCode` et l’objet devient introuvable.''',
          r'''Croire que `copy` fait une copie profonde : les objets référencés, comme une liste, sont partagés entre l’original et la copie.''',
        ],
        java: r'''Depuis Java 16, les `record` sont proches des data classes :

```java
record User(long id, String name) {}
```

Les records n’ont pas d’équivalent de `copy` : pour changer un champ, il faut rappeler le constructeur avec toutes les valeurs.''',
        memo: [
          r'''`data class` génère `equals`, `hashCode`, `toString`, `copy` et `componentN`.''',
          r'''`copy(name = …)` crée une variante en changeant seulement certaines propriétés.''',
          r'''Déstructuration : `val (id, name) = user`.''',
          r'''Préfère des propriétés `val`.''',
        ],
        challenge:
            r'''Modélise un `Product(val id: Long, val name: String, val price: Double)`. Crée une liste de trois produits, applique une remise de 10 % à tous avec `map { it.copy(…) }` et affiche le résultat. Vérifie que deux produits identiques sont égaux avec `==`.''',
        icon: Icons.inventory_2_rounded,
        level: 'Intermédiaire',
      ),
      _lesson(
        id: 'enums_sealed',
        title: 'Enum & sealed',
        subtitle: 'Modéliser des choix finis',
        concept:
            'enum représente des constantes proches. sealed interface permet des variantes portant chacune leurs données.',
        code:
            'sealed interface Result {\n    data class Success(val value: String) : Result\n    data class Failure(val message: String) : Result\n}\nfun label(result: Result) = when (result) {\n    is Result.Success -> result.value\n    is Result.Failure -> result.message\n}',
        practice:
            'Utilise une hiérarchie sealed pour rendre les états impossibles difficiles à représenter.',
        mistakes: [
          r'''Ajouter `else` à un `when` sur une hiérarchie sealed : le compilateur ne te prévient plus quand un nouveau cas apparaît.''',
          r'''Utiliser un enum alors que chaque cas porte des données différentes : c’est le rôle d’une hiérarchie sealed.''',
          r'''Représenter un état avec plusieurs booléens (`isLoading`, `hasError`…) : des combinaisons impossibles deviennent représentables.''',
        ],
        java:
            r'''Les enums sont très proches dans les deux langages. Java 17 a ajouté les `sealed interface … permits …`, et Java 21 le pattern matching dans `switch`.

Kotlin offre la même idée avec `when`, les smart casts et une syntaxe plus courte : les sous-types n’ont pas besoin d’être listés avec `permits`.''',
        memo: [
          r'''`enum class Direction { NORTH, SOUTH }` : un ensemble fixe de constantes.''',
          r'''`Direction.entries` liste toutes les valeurs.''',
          r'''`sealed interface` : des sous-types connus à la compilation, chacun avec ses propres données.''',
          r'''`data object` convient aux cas sans données, comme `Loading`.''',
          r'''Un `when` sur un type sealed est exhaustif : pas besoin de `else`.''',
        ],
        challenge:
            r'''Modélise l’état d’un écran avec `sealed interface UiState` : `data object Loading`, `Success(val items: List<String>)` et `Error(val message: String)`. Écris `render(state)` qui renvoie un texte pour chaque cas, sans `else`. Ajoute ensuite un état `Empty` et observe l’erreur du compilateur.''',
        icon: Icons.account_tree_rounded,
        level: 'Intermédiaire',
        duration: 20,
        xp: 70,
      ),
      _lesson(
        id: 'interfaces',
        title: 'Interfaces',
        subtitle: 'Définir des contrats',
        concept:
            'Une interface décrit une capacité sans imposer de stockage. Les classes peuvent implémenter plusieurs interfaces.',
        code:
            'interface Repository<T> {\n    fun findAll(): List<T>\n    fun save(value: T)\n}\nclass MemoryRepository<T> : Repository<T> {\n    private val values = mutableListOf<T>()\n    override fun findAll() = values.toList()\n    override fun save(value: T) { values += value }\n}',
        practice: 'Crée une abstraction lorsqu’elle exprime un vrai contrat.',
        mistakes: [
          r'''Créer une interface pour chaque classe « au cas où » : une abstraction qui n’a qu’une implémentation ajoute du code sans valeur.''',
          r'''Oublier `override` : en Kotlin, il est obligatoire pour implémenter un membre d’interface.''',
          r'''Renvoyer la liste interne mutable : ici, `findAll()` renvoie une copie avec `toList()` pour que personne ne modifie l’état depuis l’extérieur.''',
        ],
        java:
            r'''Comme en Java 8 et plus, une interface Kotlin peut contenir des méthodes avec une implémentation par défaut. Elle peut aussi déclarer des propriétés abstraites, comme `val name: String`.

Kotlin sait en plus déléguer toute une implémentation avec `by` :

```kotlin
class LoggedRepository<T>(private val inner: Repository<T>) : Repository<T> by inner
```''',
        memo: [
          r'''Une `interface` est un contrat, sans état stocké.''',
          r'''`override` est obligatoire pour chaque membre implémenté.''',
          r'''Une classe peut implémenter plusieurs interfaces.''',
          r'''`by` délègue l’implémentation à un autre objet.''',
        ],
        challenge:
            r'''Écris une interface `Notifier` avec `fun send(message: String)`, puis deux implémentations : `ConsoleNotifier` qui affiche le message et `FakeNotifier` qui le stocke dans une liste. Écris une fonction qui reçoit un `Notifier`, et utilise `FakeNotifier` pour vérifier qu’elle envoie le bon message.''',
        icon: Icons.handshake_rounded,
        level: 'Intermédiaire',
      ),
      _lesson(
        id: 'inheritance',
        title: 'Héritage & polymorphisme',
        subtitle: 'Partager un comportement',
        concept:
            'Les classes sont final par défaut. open autorise l’héritage, override rend les redéfinitions explicites.',
        code:
            'abstract class Shape { abstract fun area(): Double }\nclass Circle(private val radius: Double) : Shape() {\n    override fun area() = Math.PI * radius * radius\n}',
        practice:
            'Préfère la composition sauf lorsqu’une vraie relation « est un » existe.',
        mistakes: [
          r'''Oublier `open` : hériter d’une classe qui n’est pas `open` ne compile pas.''',
          r'''Construire de longues hiérarchies pour partager du code : la composition, c’est-à-dire une propriété qui fait le travail, est plus souple.''',
          r'''Appeler une fonction `open` depuis le constructeur de la classe parente : la sous-classe n’est pas encore initialisée à ce moment-là.''',
        ],
        java:
            r'''En Java, toute classe est héritable sauf si elle est `final`, et `@Override` est facultatif. Kotlin fait le choix inverse : tout est `final` par défaut et `override` est obligatoire.

L’appel au constructeur parent se fait directement dans l’en-tête : `class Circle(…) : Shape()`.''',
        memo: [
          r'''`open class` autorise l’héritage ; `open fun` autorise la redéfinition.''',
          r'''`abstract` : classe non instanciable, dont certains membres sont à implémenter.''',
          r'''`override` est obligatoire ; `final override` bloque les redéfinitions suivantes.''',
          r'''`super.methode()` appelle l’implémentation parente.''',
        ],
        challenge:
            r'''Ajoute `Rectangle(width, height)` et `Square(side)` à la hiérarchie `Shape`, puis calcule l’aire totale d’une `List<Shape>` avec `sumOf { it.area() }`. Réfléchis ensuite : `Square` doit-il hériter de `Rectangle` ?''',
        icon: Icons.polyline_rounded,
        level: 'Intermédiaire',
      ),
      _lesson(
        id: 'null',
        title: 'Null safety',
        subtitle: 'Maîtriser l’absence de valeur',
        concept:
            'Le type T? rend l’absence explicite. ?., ?:, let et les smart casts permettent de la traiter sans NullPointerException.',
        code:
            r'fun greeting(name: String?): String {\n    val clean = name?.trim()?.takeIf { it.isNotEmpty() }\n    return "Bonjour, ${clean ?: "inconnu"}"\n}',
        practice:
            'Évite !! : transforme, filtre ou fournis une valeur de remplacement.',
        mistakes: [
          r'''Utiliser `!!` pour faire taire le compilateur : c’est une `NullPointerException` qui attend son heure.''',
          r'''Tester `if (x != null)` sur une propriété `var` : le smart cast est impossible car la valeur peut changer entre le test et l’usage. Copie-la dans un `val` local ou utilise `?.let`.''',
          r'''Rendre tout nullable par précaution : chaque `?` impose de gérer l’absence partout où la valeur est utilisée.''',
        ],
        java:
            r'''En Java, toute référence peut être `null` et l’erreur n’apparaît qu’à l’exécution. `@Nullable` et `Optional` aident, mais restent facultatifs.

En Kotlin, la nullabilité fait partie du type : une `String` ne peut jamais contenir `null`. Attention aux valeurs venant de Java : leur type « plateforme » (`String!`) n’est pas vérifié par Kotlin.''',
        memo: [
          r'''`String?` accepte `null`, `String` jamais.''',
          r'''`?.` n’appelle la fonction que si la valeur n’est pas nulle.''',
          r'''`?:` fournit une valeur de repli.''',
          r'''`?.let { … }` n’exécute le bloc que si la valeur existe.''',
          r'''`takeIf { … }` renvoie `null` si la condition est fausse.''',
        ],
        challenge:
            r'''Écris `parseAge(raw: String?): Int?` qui renvoie `null` pour une entrée nulle, vide, non numérique ou hors de l’intervalle 0..150. N’utilise ni `!!` ni `if (raw == null)`. Indice : `?.trim()`, `toIntOrNull()` et `takeIf`.''',
        icon: Icons.shield_rounded,
        level: 'Intermédiaire',
        duration: 22,
        xp: 75,
      ),
      _lesson(
        id: 'extensions',
        title: 'Fonctions d’extension',
        subtitle: 'Enrichir une API',
        concept:
            'Une extension ajoute une fonction appelable sur un type sans modifier ni hériter de ce type.',
        code:
            'fun String.toSlug(): String = lowercase()\n    .trim()\n    .replace(Regex("[^a-z0-9]+"), "-")\n    .trim(\'-\')\nprintln("Kotlin Facile".toSlug())',
        practice:
            'Place les extensions près du domaine et évite les utilitaires vagues.',
        mistakes: [
          r'''Croire qu’une extension accède aux membres `private` : elle n’utilise que l’API publique du type.''',
          r'''Croire qu’une extension se redéfinit comme une méthode : elle est choisie selon le type déclaré à la compilation, pas selon le type réel de l’objet.''',
          r'''Créer des extensions trop générales sur `Any` ou `String` : elles encombrent l’autocomplétion dans tout le projet.''',
        ],
        java:
            r'''Java n’a pas d’extensions : on écrit des classes utilitaires statiques, comme `StringUtils.toSlug(text)`.

C’est d’ailleurs ainsi qu’une extension Kotlin est compilée : une fonction statique qui reçoit l’objet en premier paramètre. Kotlin permet simplement de l’appeler comme une méthode.''',
        memo: [
          r'''`fun Type.nom(): Retour` ; dans le corps, `this` désigne l’objet.''',
          r'''Une extension n’accède qu’aux membres publics.''',
          r'''Si une méthode membre a la même signature, c’est le membre qui l’emporte.''',
          r'''Les propriétés d’extension existent aussi : `val String.wordCount get() = split(" ").size`.''',
        ],
        challenge:
            r'''Écris `fun Int.isEven(): Boolean` et `fun List<Int>.median(): Double?`, qui renvoie `null` pour une liste vide. Teste la médiane sur une liste de taille paire et sur une liste de taille impaire.''',
        icon: Icons.extension_rounded,
        level: 'Intermédiaire',
      ),
      _lesson(
        id: 'scope_functions',
        title: 'Scope functions',
        subtitle: 'let, run, apply et also',
        concept:
            'Les scope functions exécutent un bloc dans le contexte d’un objet. Elles diffèrent par le récepteur et la valeur retournée.',
        code:
            r'val user = User(1, "Ada").also {\n    println("Création de $it")\n}\nval label = user.run { "#$id — $name" }',
        practice:
            'Choisis une scope function pour sa sémantique et évite de les imbriquer.',
        mistakes: [
          r'''Imbriquer plusieurs `let` ou `apply` : on ne sait plus à quoi `it` et `this` font référence.''',
          r'''Utiliser `apply` en attendant le résultat du bloc : `apply` renvoie l’objet, pas la dernière expression.''',
          r'''Remplacer chaque `if` par `?.let` : un simple `if` est souvent plus lisible.''',
        ],
        java:
            r'''Java n’a pas d’équivalent direct : on passe par des variables temporaires ou des chaînes de setters.

En Kotlin, `apply` remplace souvent un builder, et `also` permet d’insérer une journalisation au milieu d’une expression sans la casser.''',
        memo: [
          r'''`let` : l’objet est `it`, renvoie le résultat du bloc.''',
          r'''`run` : l’objet est `this`, renvoie le résultat du bloc.''',
          r'''`apply` : l’objet est `this`, renvoie l’objet (configuration).''',
          r'''`also` : l’objet est `it`, renvoie l’objet (effet secondaire).''',
          r'''`with(objet) { … }` : comme `run`, mais sans appel en chaîne.''',
        ],
        challenge:
            r'''Crée un `StringBuilder` configuré avec `apply` (trois `append`), journalise son contenu avec `also`, puis calcule sa longueur avec `let`. Pour chaque appel, explique ce qui est renvoyé.''',
        icon: Icons.center_focus_strong_rounded,
        level: 'Intermédiaire',
      ),
      _lesson(
        id: 'exceptions',
        title: 'Exceptions & Result',
        subtitle: 'Gérer les échecs',
        concept:
            'try est une expression. Les exceptions conviennent aux échecs exceptionnels ; Result transporte explicitement succès ou échec.',
        code:
            'fun parsePort(raw: String): Result<Int> = runCatching {\n    raw.toInt().also { require(it in 1..65535) }\n}\nparsePort("8080").onSuccess(::println)',
        practice:
            'Ne capture pas Exception sans stratégie : transforme, journalise ou propage avec du contexte.',
        mistakes: [
          r'''Capturer `Exception` puis l’ignorer : l’erreur disparaît sans laisser de trace.''',
          r'''Utiliser des exceptions pour le flux normal, par exemple pour savoir si un texte est un nombre : `toIntOrNull()` est plus simple.''',
          r'''Oublier que `runCatching` capture aussi les `CancellationException` des coroutines : dans du code suspendu, cela peut empêcher une annulation propre.''',
        ],
        java:
            r'''Java distingue les exceptions vérifiées, à déclarer avec `throws`, des exceptions non vérifiées. Kotlin n’a pas d’exceptions vérifiées : aucune signature ne les déclare.

`try` est aussi une expression :

```kotlin
val port = try { raw.toInt() } catch (e: NumberFormatException) { 8080 }
```''',
        memo: [
          r'''`try { … } catch (e: Type) { … } finally { … }` ; `try` renvoie une valeur.''',
          r'''`require` (argument invalide) et `check` (état invalide) lèvent des exceptions claires.''',
          r'''`runCatching { … }` renvoie un `Result<T>`.''',
          r'''Sur un `Result` : `getOrNull()`, `getOrDefault()`, `onSuccess`, `onFailure`, `map`, `fold`.''',
        ],
        challenge:
            r'''Écris `readConfig(lines: List<String>): Result<Map<String, String>>` qui lit des lignes au format `clé=valeur` et échoue avec un message clair sur une ligne mal formée. Affiche le résultat avec `fold(onSuccess = …, onFailure = …)`.''',
        icon: Icons.warning_amber_rounded,
        level: 'Intermédiaire',
        duration: 20,
        xp: 70,
      ),
    ],
  ),
  LearningPath(
    id: 'advanced',
    title: 'Kotlin avancé',
    subtitle: 'Avancé · 8 leçons',
    color: const Color(0xFFFF8A65),
    icon: Icons.bolt_rounded,
    lessons: [
      _lesson(
        id: 'coroutines',
        title: 'Coroutines',
        subtitle: 'Asynchrone structuré',
        concept:
            'Une coroutine suspend son travail sans bloquer le thread. La concurrence structurée lie les tâches à un scope.',
        code:
            'suspend fun loadDashboard(): Dashboard = coroutineScope {\n    val user = async { loadUser() }\n    val news = async { loadNews() }\n    Dashboard(user.await(), news.await())\n}',
        practice: 'N’utilise pas GlobalScope pour le travail applicatif.',
        mistakes: [
          r'''Lancer avec `GlobalScope.launch` : la coroutine n’est liée à rien, elle continue même quand l’écran qui l’a lancée a disparu, et ses erreurs passent inaperçues.''',
          r'''Appeler une fonction bloquante (`Thread.sleep`, lecture de fichier…) sur `Dispatchers.Main` : l’interface se fige. Utilise `delay` ou `withContext(Dispatchers.IO)`.''',
          r'''Attraper `CancellationException` sans la relancer : la coroutine ne peut plus être annulée proprement.''',
        ],
        java:
            r'''En Java, on passe par des threads, des `ExecutorService` ou des `CompletableFuture` enchaînés avec `thenApply` et `thenCombine`.

Les coroutines permettent d’écrire le même code asynchrone de façon séquentielle, et un seul thread peut porter des milliers de coroutines suspendues. Les threads virtuels de Java 21 répondent à une partie du même besoin.''',
        memo: [
          r'''Une `suspend fun` peut se suspendre sans bloquer le thread.''',
          r'''`launch` lance sans résultat ; `async` puis `await()` lance avec un résultat.''',
          r'''`coroutineScope { }` attend toutes ses coroutines enfants ; si l’une échoue, les autres sont annulées.''',
          r'''`withContext(Dispatchers.IO) { }` déplace un travail bloquant hors du thread principal.''',
          r'''Sur Android : `viewModelScope` et `lifecycleScope`.''',
        ],
        challenge:
            r'''Écris `suspend fun fetchAll(ids: List<Int>): List<String>` qui charge chaque id en parallèle avec `async`, en simulant le chargement avec `delay(100)`. Mesure la durée avec `measureTimeMillis` : elle doit rester proche de 100 ms, quel que soit le nombre d’ids.''',
        icon: Icons.sync_rounded,
        level: 'Avancé',
        duration: 30,
        xp: 100,
      ),
      _lesson(
        id: 'flow',
        title: 'Flow',
        subtitle: 'Flux réactifs',
        concept:
            'Flow représente un flux froid de valeurs asynchrones. Les opérateurs le transforment et collect déclenche son exécution.',
        code:
            'fun search(query: Flow<String>) = query\n    .debounce(300)\n    .distinctUntilChanged()\n    .flatMapLatest(repository::search)',
        practice:
            'Collecte un Flow dans un scope contrôlé et annule les travaux obsolètes.',
        mistakes: [
          r'''Oublier que rien ne se passe sans `collect` : un Flow froid n’exécute son bloc qu’au moment de la collecte.''',
          r'''Collecter un Flow dans `lifecycleScope.launch` sans `repeatOnLifecycle` : la collecte continue quand l’app passe en arrière-plan.''',
          r'''Utiliser `flatMapConcat` ou `flatMapMerge` pour une recherche : seul `flatMapLatest` annule la requête précédente quand une nouvelle saisie arrive.''',
        ],
        java:
            r'''La bibliothèque standard Java n’a pas d’équivalent pratique : `java.util.concurrent.Flow` n’est qu’une interface de bas niveau. On utilise des bibliothèques comme RxJava ou Reactor.

Kotlin Flow repose sur les coroutines : les opérateurs sont de simples fonctions `suspend`, et l’annulation suit automatiquement le scope.''',
        memo: [
          r'''`flow { emit(x) }` crée un flux froid.''',
          r'''`map`, `filter`, `debounce`, `distinctUntilChanged` et `flatMapLatest` le transforment.''',
          r'''`collect { }` démarre l’exécution.''',
          r'''`StateFlow` garde la dernière valeur (l’état d’un écran) ; `SharedFlow` diffuse des événements.''',
        ],
        challenge:
            r'''Crée un `flow` qui émet les nombres de 1 à 10 avec `delay(100)` entre chaque. Ne garde que les nombres pairs, transforme-les en texte et collecte-les. Ajoute ensuite `take(3)` et observe que le flux s’arrête de lui-même.''',
        icon: Icons.waves_rounded,
        level: 'Avancé',
        duration: 28,
        xp: 100,
      ),
      _lesson(
        id: 'generics',
        title: 'Génériques & variance',
        subtitle: 'APIs réutilisables et sûres',
        concept:
            'Les paramètres de type rendent une API réutilisable. out exprime un producteur, in un consommateur.',
        code:
            'interface Producer<out T> { fun next(): T }\ninterface Consumer<in T> { fun accept(value: T) }\nfun <T> List<T>.secondOrNull(): T? = getOrNull(1)',
        practice: 'Ajoute de la variance seulement lorsqu’elle améliore l’API.',
        mistakes: [
          r'''Croire qu’une `MutableList<String>` est une `MutableList<Any>` : sinon, on pourrait y ajouter un `Int`. La `List` en lecture seule, elle, est covariante.''',
          r'''Tester le type générique à l’exécution : `x is List<String>` est impossible car le paramètre de type est effacé. Une fonction `inline` avec `reified T` le permet.''',
          r'''Mettre `out` sur un type utilisé en entrée : le compilateur refuse `fun accept(value: T)` dans une interface `Producer<out T>`.''',
        ],
        java:
            r'''Java exprime la variance à chaque utilisation : `List<? extends Number>` ou `List<? super Integer>`.

Kotlin permet de la déclarer une fois pour toutes sur le type, comme `interface Producer<out T>`. `out` correspond à `? extends` et `in` à `? super`. La variance à l’utilisation existe aussi : `MutableList<out Number>`.''',
        memo: [
          r'''`class Box<T>(val value: T)` ; `fun <T> first(list: List<T>): T`.''',
          r'''`out T` : le type ne fait que produire des `T` (covariance).''',
          r'''`in T` : le type ne fait que consommer des `T` (contravariance).''',
          r'''`<T : Comparable<T>>` impose une borne supérieure.''',
          r'''`inline fun <reified T> …` rend `T` disponible à l’exécution.''',
        ],
        challenge:
            r'''Écris `fun <T : Comparable<T>> List<T>.largest(): T?` sans utiliser `maxOrNull()`, et teste-la avec des `Int` puis des `String`. Écris ensuite `inline fun <reified T> List<Any>.only(): List<T>` qui ne garde que les éléments de type `T`.''',
        icon: Icons.all_inclusive_rounded,
        level: 'Avancé',
        xp: 95,
      ),
      _lesson(
        id: 'higher_order',
        title: 'Fonctions d’ordre supérieur',
        subtitle: 'Fonctions comme valeurs',
        concept:
            'Une fonction peut recevoir ou retourner une fonction. Les lambdas séparent mécanisme et politique.',
        code:
            'fun <T> measure(block: () -> T): T {\n    val start = System.nanoTime()\n    return block().also { println(System.nanoTime() - start) }\n}',
        practice: 'Extrais une lambda complexe dans une fonction nommée.',
        mistakes: [
          r'''Passer des lambdas de vingt lignes en argument : extrais-les dans une fonction nommée et passe une référence comme `::validate`.''',
          r'''Se tromper sur `return` dans une lambda : dans une lambda `inline` comme celle de `forEach`, il quitte la fonction englobante. Utilise `return@forEach` pour ne quitter que la lambda.''',
          r'''Appeler une fonction qui prend une lambda dans une boucle très fréquente sans `inline` : chaque appel peut allouer un objet fonction.''',
        ],
        java:
            r'''Java 8 a introduit les lambdas, mais chaque type de fonction est une interface : `Function<T, R>`, `Supplier<T>`, `BiFunction`…

Kotlin a de vrais types de fonction, comme `(Int) -> String` ou `() -> Unit`. Grâce à `inline`, des fonctions comme `measure` ou `forEach` n’allouent aucun objet pour la lambda.''',
        memo: [
          r'''Type de fonction : `(A, B) -> R`.''',
          r'''Quand le dernier paramètre est une fonction, la lambda s’écrit après les parenthèses.''',
          r'''`it` désigne le paramètre unique d’une lambda.''',
          r'''Référence de fonction : `::nomFonction` ou `objet::methode`.''',
          r'''`inline` recopie le corps de la lambda à l’endroit de l’appel.''',
        ],
        challenge:
            r'''Écris `fun retry(times: Int, block: () -> Boolean): Boolean` qui réessaie le bloc jusqu’à ce qu’il renvoie `true`, au plus `times` fois. Teste-la avec une lambda qui ne réussit qu’au troisième essai, en comptant les appels dans une variable.''',
        icon: Icons.functions_rounded,
        level: 'Avancé',
        xp: 90,
      ),
      _lesson(
        id: 'dsl',
        title: 'Créer un DSL',
        subtitle: 'APIs déclaratives',
        concept:
            'Les lambdas avec récepteur et les builders créent un langage spécialisé lisible, comme Gradle ou Compose.',
        code:
            'class Menu {\n    val items = mutableListOf<String>()\n    fun item(label: String) { items += label }\n}\nfun menu(block: Menu.() -> Unit) = Menu().apply(block)\nval main = menu { item("Accueil"); item("Profil") }',
        practice:
            'Un DSL doit réduire l’ambiguïté ; ajoute @DslMarker si nécessaire.',
        mistakes: [
          r'''Laisser appeler `item` depuis un sous-bloc imbriqué sans le vouloir : sans `@DslMarker`, les récepteurs extérieurs restent accessibles.''',
          r'''Exposer l’état mutable du builder (ici `items`, public et modifiable) au lieu de produire un objet final immuable.''',
          r'''Créer un DSL pour une configuration de trois lignes : une simple fonction avec des arguments nommés est souvent plus claire.''',
        ],
        java:
            r'''Java n’a pas de lambdas avec récepteur : on écrit des builders en chaîne, comme `new Menu.Builder().item("Accueil").item("Profil").build()`.

En Kotlin, avec `Menu.() -> Unit`, l’objet devient le `this` implicite du bloc. C’est ce mécanisme qu’utilisent le Gradle Kotlin DSL, Ktor ou kotlinx.html.''',
        memo: [
          r'''`Type.() -> Unit` : lambda avec récepteur, `this` désigne l’objet.''',
          r'''`Type().apply(block)` crée l’objet puis exécute le bloc.''',
          r'''`@DslMarker` empêche d’utiliser par erreur un récepteur extérieur.''',
          r'''Un builder doit produire un résultat final immuable.''',
        ],
        challenge:
            r'''Étends le DSL pour décrire des sous-menus : `menu { item("Accueil"); submenu("Réglages") { item("Thème") } }`. Ajoute une fonction qui affiche le menu avec une indentation par niveau.''',
        icon: Icons.auto_fix_high_rounded,
        level: 'Avancé',
        xp: 100,
      ),
      _lesson(
        id: 'solid',
        title: 'SOLID en Kotlin',
        subtitle: 'Conception maintenable',
        concept:
            'SOLID aide à maintenir des responsabilités ciblées, des contrats stables et des dépendances orientées vers des abstractions.',
        code:
            'class CheckoutService(\n    private val payments: PaymentGateway,\n    private val orders: OrderRepository,\n) {\n    fun checkout(order: Order) {\n        payments.charge(order.total)\n        orders.save(order.paid())\n    }\n}',
        practice: 'Applique les principes pour résoudre une douleur concrète.',
        mistakes: [
          r'''Créer une interface par classe au nom de l’inversion des dépendances : une abstraction doit répondre à un vrai besoin, comme tester ou avoir plusieurs implémentations.''',
          r'''Transformer `CheckoutService` en fourre-tout (paiement, e-mails, export PDF…) : chaque responsabilité ajoutée est une raison de plus de le modifier.''',
          r'''Instancier les dépendances dans la classe (`private val payments = StripeGateway()`) : impossible de la tester sans déclencher un vrai paiement.''',
        ],
        java:
            r'''Les principes sont les mêmes en Java, mais Kotlin les rend moins coûteux à appliquer : injection par le constructeur principal en une ligne, interfaces fonctionnelles avec `fun interface`, délégation avec `by`.

Les classes `final` par défaut obligent aussi à réfléchir avant d’ouvrir une classe à l’héritage.''',
        memo: [
          r'''S : une classe, une seule raison de changer.''',
          r'''O : ajouter un comportement sans réécrire le code existant.''',
          r'''L : une sous-classe doit pouvoir remplacer sa classe mère sans surprise.''',
          r'''I : des interfaces petites et ciblées.''',
          r'''D : dépendre d’abstractions, injectées par le constructeur.''',
        ],
        challenge:
            r'''Écris un `FakePaymentGateway` qui enregistre les montants débités, puis un test de `CheckoutService` qui vérifie que le bon montant est débité et que la commande est sauvegardée comme payée, sans aucun vrai paiement.''',
        icon: Icons.architecture_rounded,
        level: 'Avancé',
        duration: 25,
        xp: 100,
      ),
      _lesson(
        id: 'testing',
        title: 'Tests unitaires',
        subtitle: 'Vérifier le comportement',
        concept:
            'Un test prépare un scénario, exécute une action puis vérifie un résultat observable. Les fonctions pures sont simples à tester.',
        code:
            '@Test fun `applies ten percent discount`() {\n    val result = PriceCalculator().total(100.0, 0.10)\n    assertEquals(90.0, result, 0.001)\n}',
        practice:
            'Teste les comportements et cas limites, pas les détails privés.',
        mistakes: [
          r'''Comparer des `Double` sans tolérance avec `assertEquals(90.0, result)` : les erreurs d’arrondi font échouer le test. Passe un écart accepté, comme `0.001` ici.''',
          r'''Tester plusieurs comportements dans un seul test : quand il échoue, on ne sait pas lequel est cassé.''',
          r'''Rendre un test dépendant de l’heure, du réseau ou de l’ordre d’exécution : il devient instable. Injecte une horloge ou un faux dépôt.''',
        ],
        java:
            r'''Les tests Kotlin utilisent les mêmes outils que Java : JUnit, MockK ou Mockito.

Kotlin autorise des noms de fonctions entre accents graves, qui décrivent le comportement en langage naturel. `kotlin.test` fournit des assertions communes à toutes les plateformes, et `runTest` permet de tester du code qui utilise des coroutines.''',
        memo: [
          r'''Structure Arrange / Act / Assert : préparer, agir, vérifier.''',
          r'''Un test, un comportement.''',
          r'''Teste les cas limites : vide, zéro, négatif, maximum.''',
          r'''Des faux objets (fakes) remplacent le réseau, la base de données et l’horloge.''',
          r'''`runTest { }` pour tester du code `suspend`.''',
        ],
        challenge:
            r'''Écris quatre tests pour `PriceCalculator.total(price, discount)` : remise nulle, remise de 100 %, remise négative (qui doit lever une exception) et prix à zéro. Fais d’abord échouer chaque test, puis corrige le code.''',
        icon: Icons.science_rounded,
        level: 'Avancé',
        xp: 100,
      ),
      _lesson(
        id: 'performance',
        title: 'Performance',
        subtitle: 'Mesurer avant d’optimiser',
        concept:
            'Les allocations et traversées répétées peuvent coûter cher. Un benchmark mesure une hypothèse dans des conditions contrôlées.',
        code:
            'val result = buildList {\n    for (value in source) {\n        if (value.isValid()) add(value.transform())\n    }\n}',
        practice:
            'Profile d’abord, optimise le point chaud mesuré, puis mesure à nouveau.',
        mistakes: [
          r'''Optimiser sans mesurer : le temps est souvent perdu ailleurs que là où on l’imagine.''',
          r'''Enchaîner `filter`, `map` et `take` sur une très grande collection : chaque étape crée une liste intermédiaire. `asSequence()` traite les éléments un par un.''',
          r'''Mesurer une seule exécution avec `System.currentTimeMillis()` : la JVM n’est pas encore « chaude ». Utilise un outil de benchmark comme JMH ou kotlinx-benchmark.''',
        ],
        java:
            r'''Kotlin compile vers le même bytecode JVM que Java : à code équivalent, les performances sont équivalentes.

Les points à surveiller sont propres à Kotlin : lambdas non `inline`, boxing des types nullables comme `Int?`, listes intermédiaires créées par les fonctions de collection. Les séquences Kotlin jouent le rôle des streams Java.''',
        memo: [
          r'''Mesure, optimise le point chaud, puis mesure à nouveau.''',
          r'''`asSequence()` évite les listes intermédiaires sur les grandes collections.''',
          r'''`buildList { }` construit une liste en une seule passe.''',
          r'''Un `Int?` stocké dans une collection implique du boxing.''',
          r'''Sur Android : le Profiler d’Android Studio et Macrobenchmark.''',
        ],
        challenge:
            r'''Crée une liste d’un million d’entiers et compare `filter { … }.map { … }.take(10)` avec la même chaîne précédée de `asSequence()`. Mesure chaque version plusieurs fois avec `measureTimeMillis` et explique la différence.''',
        icon: Icons.speed_rounded,
        level: 'Avancé',
        xp: 105,
      ),
    ],
  ),
  LearningPath(
    id: 'android',
    title: 'Android & Compose',
    subtitle: 'Spécialisation · 8 leçons',
    color: AppColors.success,
    icon: Icons.android_rounded,
    lessons: [
      _lesson(
        id: 'android_project',
        title: 'Projet Android',
        subtitle: 'Structure et cycle de vie',
        concept:
            'Une application Android sépare configuration, ressources, code et tests. Le cycle de vie contrôle le travail de l’interface.',
        code:
            'class MainActivity : ComponentActivity() {\n    override fun onCreate(state: Bundle?) {\n        super.onCreate(state)\n        setContent { KotlinLabTheme { App() } }\n    }\n}',
        practice: 'Ne conserve jamais une Activity dans un singleton.',
        icon: Icons.folder_special_rounded,
        level: 'Android',
        duration: 22,
        xp: 80,
      ),
      _lesson(
        id: 'compose',
        title: 'Jetpack Compose',
        subtitle: 'Interfaces déclaratives',
        concept:
            'Une fonction @Composable décrit l’interface pour un état donné. Quand l’état change, Compose recompose les parties nécessaires.',
        code:
            r'@Composable\nfun Greeting(name: String, onContinue: () -> Unit) {\n    Column(Modifier.padding(24.dp)) {\n        Text("Bonjour $name")\n        Button(onClick = onContinue) { Text("Continuer") }\n    }\n}',
        practice:
            'Remonte l’état au niveau qui le possède et garde les composables stateless.',
        icon: Icons.phone_android_rounded,
        level: 'Android',
        duration: 28,
        xp: 95,
      ),
      _lesson(
        id: 'compose_state',
        title: 'État dans Compose',
        subtitle: 'State et recomposition',
        concept:
            'remember conserve une valeur durant la composition. rememberSaveable survit aux recréations simples.',
        code:
            r'@Composable\nfun Counter() {\n    var count by rememberSaveable { mutableIntStateOf(0) }\n    Button(onClick = { count++ }) { Text("Compteur : $count") }\n}',
        practice:
            'Ne place pas de calcul coûteux directement dans une fonction composable.',
        icon: Icons.touch_app_rounded,
        level: 'Android',
        xp: 90,
      ),
      _lesson(
        id: 'navigation',
        title: 'Navigation',
        subtitle: 'Écrans et arguments',
        concept:
            'Navigation Compose associe des routes à des destinations. Les arguments transmis doivent rester minimaux.',
        code:
            r'NavHost(navController, startDestination = "home") {\n    composable("home") { HomeScreen(onUser = { id ->\n        navController.navigate("user/$id")\n    }) }\n    composable("user/{id}") { UserScreen() }\n}',
        practice:
            'Transmets un identifiant et recharge les données depuis la source de vérité.',
        icon: Icons.route_rounded,
        level: 'Android',
        xp: 90,
      ),
      _lesson(
        id: 'viewmodel',
        title: 'ViewModel & StateFlow',
        subtitle: 'État d’écran durable',
        concept:
            'ViewModel conserve la logique de présentation. StateFlow expose un état immuable observable par Compose.',
        code:
            'class UsersViewModel : ViewModel() {\n    private val _uiState = MutableStateFlow(UsersState())\n    val uiState = _uiState.asStateFlow()\n    fun refresh() = viewModelScope.launch {\n        _uiState.update { it.copy(loading = true) }\n    }\n}',
        practice:
            'Expose un StateFlow en lecture seule et des fonctions décrivant les intentions.',
        icon: Icons.account_tree_rounded,
        level: 'Android',
        duration: 28,
        xp: 100,
      ),
      _lesson(
        id: 'room',
        title: 'Room',
        subtitle: 'Persistance locale',
        concept:
            'Room vérifie les requêtes SQL à la compilation et mappe tables, DAO et objets Kotlin.',
        code:
            '@Entity data class Note(\n    @PrimaryKey val id: Long, val text: String\n)\n@Dao interface NoteDao {\n    @Query("SELECT * FROM Note") fun observeAll(): Flow<List<Note>>\n    @Insert suspend fun insert(note: Note)\n}',
        practice: 'Mappe les entités de la couche data vers le domaine.',
        icon: Icons.storage_rounded,
        level: 'Android',
        xp: 100,
      ),
      _lesson(
        id: 'retrofit',
        title: 'Retrofit & réseau',
        subtitle: 'Consommer une API REST',
        concept:
            'Retrofit transforme une interface annotée en client HTTP. Il faut distinguer les erreurs réseau, HTTP et de décodage.',
        code:
            'interface UsersApi {\n    @GET("users/{id}")\n    suspend fun user(@Path("id") id: Long): UserDto\n}\nclass UsersRepository(private val api: UsersApi) {\n    suspend fun user(id: Long) = api.user(id).toDomain()\n}',
        practice: 'Ne laisse pas les DTO réseau sortir de la couche data.',
        icon: Icons.cloud_download_rounded,
        level: 'Android',
        xp: 100,
      ),
      _lesson(
        id: 'android_testing',
        title: 'Tester une app Compose',
        subtitle: 'UI et ViewModel',
        concept:
            'Les tests de ViewModel valident les transitions d’état. Les tests Compose recherchent des nœuds sémantiques.',
        code:
            '@Test fun counter_increments() {\n    composeRule.setContent { Counter() }\n    composeRule.onNodeWithText("Compteur : 0").assertExists()\n    composeRule.onNodeWithRole(Role.Button).performClick()\n    composeRule.onNodeWithText("Compteur : 1").assertExists()\n}',
        practice:
            'Ajoute des descriptions sémantiques utiles aux tests et à l’accessibilité.',
        icon: Icons.fact_check_rounded,
        level: 'Android',
        duration: 25,
        xp: 105,
      ),
    ],
  ),
];

ExerciseItem _exercise({
  required String id,
  required String title,
  required String category,
  required String difficulty,
  required int xp,
  required IconData icon,
  required Color color,
  required String prompt,
  required List<String> options,
  required int correctIndex,
  required String explanation,
  String? code,
}) => ExerciseItem(
  id: id,
  title: title,
  category: category,
  difficulty: difficulty,
  xp: xp,
  icon: icon,
  color: color,
  prompt: prompt,
  options: options,
  correctIndex: correctIndex,
  explanation: explanation,
  code: code?.replaceAll(r'\n', '\n'),
);

final exercises = <ExerciseItem>[
  _exercise(
    id: 'ex1',
    title: 'Prédire la sortie',
    category: 'Variables',
    difficulty: 'Facile',
    xp: 20,
    icon: Icons.visibility_rounded,
    color: AppColors.secondary,
    prompt: 'Quelle sortie produit ce programme ?',
    code: r'val name = "Kotlin"\nprintln("Hello $name")',
    options: [
      'Bonjour Kotlin',
      'Hello Kotlin',
      'Kotlin Hello',
      'Erreur de compilation',
    ],
    correctIndex: 1,
    explanation:
        r'L’interpolation $name insère la valeur Kotlin dans la chaîne.',
  ),
  _exercise(
    id: 'ex2',
    title: 'Choisir val ou var',
    category: 'Variables',
    difficulty: 'Facile',
    xp: 20,
    icon: Icons.data_object_rounded,
    color: AppColors.primary,
    prompt: 'Quel mot-clé convient à une référence jamais réassignée ?',
    options: ['var', 'val', 'mutable', 'static'],
    correctIndex: 1,
    explanation:
        'val interdit la réassignation et doit être le choix par défaut.',
  ),
  _exercise(
    id: 'ex3',
    title: 'Compléter la condition',
    category: 'Conditions',
    difficulty: 'Facile',
    xp: 25,
    icon: Icons.code_rounded,
    color: AppColors.primary,
    prompt: 'Quel opérateur accepte aussi une personne de 18 ans ?',
    code: 'if (age __ 18) println("Accès autorisé")',
    options: ['>', '>=', '==', '<='],
    correctIndex: 1,
    explanation: 'Il faut utiliser >= pour inclure la valeur 18.',
  ),
  _exercise(
    id: 'ex4',
    title: 'Lire une expression when',
    category: 'Conditions',
    difficulty: 'Moyen',
    xp: 35,
    icon: Icons.alt_route_rounded,
    color: AppColors.accent,
    prompt: 'Quelle valeur prend label ?',
    code:
        'val score = 72\nval label = when {\n  score >= 80 -> "Très bien"\n  score >= 60 -> "Bien"\n  else -> "À revoir"\n}',
    options: ['Très bien', 'Bien', 'À revoir', 'null'],
    correctIndex: 1,
    explanation: '72 satisfait la deuxième branche score >= 60.',
  ),
  _exercise(
    id: 'ex5',
    title: 'Comprendre un range',
    category: 'Boucles',
    difficulty: 'Facile',
    xp: 25,
    icon: Icons.loop_rounded,
    color: AppColors.secondary,
    prompt: 'Combien de fois la boucle s’exécute-t-elle ?',
    code: 'for (i in 1..4) println(i)',
    options: ['3', '4', '5', 'À l’infini'],
    correctIndex: 1,
    explanation: '1..4 est inclusif : il contient quatre valeurs.',
  ),
  _exercise(
    id: 'ex6',
    title: 'Retour de fonction',
    category: 'Fonctions',
    difficulty: 'Facile',
    xp: 30,
    icon: Icons.functions_rounded,
    color: AppColors.primary,
    prompt: 'Quel est le type de retour inféré ?',
    code: 'fun double(value: Int) = value * 2',
    options: ['Unit', 'Double', 'Int', 'Number?'],
    correctIndex: 2,
    explanation:
        'Les deux opérandes sont des Int, la fonction renvoie donc Int.',
  ),
  _exercise(
    id: 'ex7',
    title: 'Filtrer une liste',
    category: 'Collections',
    difficulty: 'Moyen',
    xp: 40,
    icon: Icons.filter_alt_rounded,
    color: AppColors.success,
    prompt: 'Quelle opération conserve les nombres pairs ?',
    options: [
      'map { it % 2 == 0 }',
      'filter { it % 2 == 0 }',
      'forEach { it / 2 }',
      'sorted()',
    ],
    correctIndex: 1,
    explanation: 'filter conserve les éléments dont le prédicat vaut true.',
  ),
  _exercise(
    id: 'ex8',
    title: 'Transformer une liste',
    category: 'Collections',
    difficulty: 'Moyen',
    xp: 40,
    icon: Icons.transform_rounded,
    color: AppColors.secondary,
    prompt: 'Quelle est la valeur de result ?',
    code: 'val result = listOf(1, 2, 3).map { it * 10 }',
    options: ['[1, 2, 3]', '[10, 20, 30]', '[10]', '60'],
    correctIndex: 1,
    explanation: 'map transforme chaque élément et produit une nouvelle liste.',
  ),
  _exercise(
    id: 'ex9',
    title: 'Sécuriser un nullable',
    category: 'Null safety',
    difficulty: 'Moyen',
    xp: 45,
    icon: Icons.shield_rounded,
    color: const Color(0xFFFF8A65),
    prompt: 'Quelle expression renvoie 0 si name vaut null ?',
    options: [
      'name!!.length',
      'name.length',
      'name?.length ?: 0',
      'name?length',
    ],
    correctIndex: 2,
    explanation:
        '?. effectue l’accès sûr et ?: fournit la valeur de remplacement.',
  ),
  _exercise(
    id: 'ex10',
    title: 'Copier une data class',
    category: 'POO',
    difficulty: 'Moyen',
    xp: 45,
    icon: Icons.copy_rounded,
    color: AppColors.secondary,
    prompt: 'Comment créer un utilisateur identique avec un autre nom ?',
    code:
        'data class User(val id: Int, val name: String)\nval ada = User(1, "Ada")',
    options: [
      'ada.name = "Grace"',
      'ada.copy(name = "Grace")',
      'User.copy(ada)',
      'clone(ada)',
    ],
    correctIndex: 1,
    explanation:
        'copy est générée pour les data classes et remplace certaines propriétés.',
  ),
  _exercise(
    id: 'ex11',
    title: 'Reconnaître une extension',
    category: 'Extensions',
    difficulty: 'Moyen',
    xp: 45,
    icon: Icons.extension_rounded,
    color: AppColors.primary,
    prompt: 'Quelle déclaration ajoute isLong() à String ?',
    options: [
      'fun isLong(String): Boolean',
      'fun String.isLong() = length > 10',
      'extension String isLong()',
      'String::isLong = length > 10',
    ],
    correctIndex: 1,
    explanation: 'Le type récepteur String précède le nom de la fonction.',
  ),
  _exercise(
    id: 'ex12',
    title: 'Choisir une scope function',
    category: 'Scope functions',
    difficulty: 'Difficile',
    xp: 60,
    icon: Icons.center_focus_strong_rounded,
    color: AppColors.accent,
    prompt: 'Quelle fonction configure puis retourne l’objet ?',
    options: ['let', 'run', 'apply', 'with'],
    correctIndex: 2,
    explanation: 'apply utilise this et renvoie l’objet récepteur.',
  ),
  _exercise(
    id: 'ex13',
    title: 'Analyser une coroutine',
    category: 'Coroutines',
    difficulty: 'Difficile',
    xp: 70,
    icon: Icons.sync_rounded,
    color: const Color(0xFFFF8A65),
    prompt: 'Quel builder renvoie Deferred<T> ?',
    options: ['launch', 'async', 'withContext', 'runBlocking'],
    correctIndex: 1,
    explanation: 'async produit Deferred<T>, dont await récupère le résultat.',
  ),
  _exercise(
    id: 'ex14',
    title: 'Transformer un Flow',
    category: 'Flow',
    difficulty: 'Difficile',
    xp: 70,
    icon: Icons.waves_rounded,
    color: AppColors.secondary,
    prompt: 'Quel opérateur remplace le flux précédent ?',
    options: ['map', 'combine', 'flatMapLatest', 'catch'],
    correctIndex: 2,
    explanation:
        'flatMapLatest annule la collecte précédente et utilise le nouveau flux.',
  ),
  _exercise(
    id: 'ex15',
    title: 'État Compose',
    category: 'Android',
    difficulty: 'Moyen',
    xp: 50,
    icon: Icons.phone_android_rounded,
    color: AppColors.success,
    prompt: 'Quelle fonction survit à une recréation simple ?',
    options: [
      'mutableStateOf',
      'rememberSaveable',
      'derivedStateOf',
      'LaunchedEffect',
    ],
    correctIndex: 1,
    explanation: 'rememberSaveable sauvegarde les valeurs compatibles.',
  ),
  _exercise(
    id: 'ex16',
    title: 'Architecture ViewModel',
    category: 'Android',
    difficulty: 'Difficile',
    xp: 65,
    icon: Icons.account_tree_rounded,
    color: AppColors.success,
    prompt: 'Quelle exposition protège le MutableStateFlow ?',
    code: 'private val _state = MutableStateFlow(UiState())',
    options: [
      'val state = _state',
      'val state = _state.asStateFlow()',
      'var state = _state.value',
      'fun state() = mutableStateOf(_state)',
    ],
    correctIndex: 1,
    explanation: 'asStateFlow expose un StateFlow en lecture seule.',
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
