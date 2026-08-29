class QuizQuestion {
  const QuizQuestion({
    required this.prompt,
    required this.answers,
    required this.correctIndex,
    required this.explanation,
    this.code,
  });

  final String prompt;
  final List<String> answers;
  final int correctIndex;
  final String explanation;
  final String? code;
}
