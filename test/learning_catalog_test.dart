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

    test('chaque leçon a ses propres défi, comparaison Java et mémo', () {
      final lessons = learningPaths.expand((path) => path.lessons).toList();
      String section(String content, String title) {
        final start = content.indexOf('## $title');
        final end = content.indexOf('\n## ', start + 1);
        return content.substring(start, end == -1 ? content.length : end);
      }

      for (final title in [
        'Erreurs fréquentes',
        'Comparaison avec Java',
        'Mémo',
        'Défi',
      ]) {
        final sections = lessons.map((l) => section(l.content, title)).toSet();
        expect(
          sections.length,
          lessons.length,
          reason: 'la section « $title » est identique dans plusieurs leçons',
        );
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
