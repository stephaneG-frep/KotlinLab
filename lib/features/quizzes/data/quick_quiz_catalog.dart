import '../domain/quiz_question.dart';

const quickQuizQuestions = <QuizQuestion>[
  QuizQuestion(
    prompt: 'Quel mot-clé déclare une référence non réassignable ?',
    answers: ['var', 'val', 'const', 'final'],
    correctIndex: 1,
    explanation:
        'val crée une référence en lecture seule. Il faut la préférer par défaut.',
  ),
  QuizQuestion(
    prompt: 'Quelle est la sortie de ce code ?',
    code: 'val language = "Kotlin"\nprintln(language.length)',
    answers: ['5', '6', '7', 'Erreur'],
    correctIndex: 1,
    explanation:
        'Le mot « Kotlin » contient six caractères. length renvoie donc 6.',
  ),
  QuizQuestion(
    prompt: 'Quel type accepte explicitement la valeur null ?',
    answers: ['String', 'String?', 'Nullable<String>', 'Optional<String>'],
    correctIndex: 1,
    explanation:
        'Le suffixe ? rend un type nullable : String? accepte une chaîne ou null.',
  ),
  QuizQuestion(
    prompt: 'Quelle expression remplace naturellement un switch Java ?',
    answers: ['match', 'select', 'when', 'case'],
    correctIndex: 2,
    explanation:
        'when est une expression Kotlin qui peut aussi renvoyer une valeur.',
  ),
  QuizQuestion(
    prompt: 'Quelle fonction transforme chaque élément d’une liste ?',
    answers: ['filter', 'map', 'forEach', 'reduce'],
    correctIndex: 1,
    explanation:
        'map applique une transformation et renvoie une nouvelle liste.',
  ),
];
