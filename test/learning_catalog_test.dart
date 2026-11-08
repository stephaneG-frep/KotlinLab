import 'package:flutter_test/flutter_test.dart';
import 'package:kotlin_lab/features/learning/data/learning_catalog.dart';

void main() {
  group('Learning catalog', () {
    test('toutes les leçons possèdent un contenu pédagogique complet', () {
      final lessons = learningPaths.expand((path) => path.lessons).toList();

      expect(lessons.length, greaterThanOrEqualTo(35));
      expect(lessons.map((lesson) => lesson.id).toSet().length, lessons.length);
      for (final lesson in lessons) {
        expect(lesson.content, contains('## Objectifs'));
        expect(lesson.content, contains('## Erreurs fréquentes'));
        expect(lesson.content, contains('## Défi'));
      }
    });

    test('les parcours réécrits n’utilisent plus le texte générique', () {
      // Ajouter ici chaque parcours une fois son contenu réécrit.
      const rewrittenPaths = {'beginner', 'intermediate', 'advanced'};
      final generic = [
        ...genericMistakes,
        genericJava,
        ...genericMemo,
        genericChallenge,
      ];
      for (final path in learningPaths.where(
        (path) => rewrittenPaths.contains(path.id),
      )) {
        for (final lesson in path.lessons) {
          for (final text in generic) {
            expect(
              lesson.content.contains(text),
              isFalse,
              reason: '${lesson.id} contient encore : $text',
            );
          }
        }
      }
    });

    test('chaque exercice possède une seule réponse valide', () {
      expect(exercises.length, greaterThanOrEqualTo(15));
      expect(exercises.map((item) => item.id).toSet().length, exercises.length);
      for (final exercise in exercises) {
        expect(exercise.options.length, greaterThanOrEqualTo(3));
        expect(
          exercise.correctIndex,
          inInclusiveRange(0, exercise.options.length - 1),
        );
        expect(exercise.explanation.trim(), isNotEmpty);
      }
    });
  });
}
