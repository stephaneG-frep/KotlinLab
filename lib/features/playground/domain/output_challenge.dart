/// Extrait Kotlin dont l'utilisateur doit prédire la sortie console.
class OutputChallenge {
  const OutputChallenge({
    required this.id,
    required this.title,
    required this.level,
    required this.code,
    required this.output,
    required this.explanation,
    this.xp = 20,
  });

  final String id;
  final String title;
  final String level;
  final String code;

  /// Sortie exacte du programme, une ligne par `println`.
  final String output;
  final String explanation;
  final int xp;

  /// Identifiant utilisé dans la progression (partagée avec les exercices).
  String get progressId => 'output:$id';

  /// Compare une prédiction à la sortie attendue, en ignorant les espaces
  /// en début/fin de ligne, les espaces répétés et les lignes vides
  /// autour du texte. La casse et la ponctuation comptent.
  bool matches(String prediction) =>
      _normalize(prediction) == _normalize(output);

  static String _normalize(String text) => text
      .replaceAll('\r\n', '\n')
      .split('\n')
      .map((line) => line.trim().replaceAll(RegExp(r'\s+'), ' '))
      .join('\n')
      .trim();
}
