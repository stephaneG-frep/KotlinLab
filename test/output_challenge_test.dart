import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:kotlin_lab/features/playground/data/output_challenges.dart';
import 'package:kotlin_lab/features/playground/domain/output_challenge.dart';
import 'package:kotlin_lab/features/playground/presentation/playground_screen.dart';
import 'package:kotlin_lab/features/profile/presentation/profile_controller.dart';

void main() {
  group('Comparaison de la prédiction', () {
    const challenge = OutputChallenge(
      id: 't',
      title: 't',
      level: 'Débutant',
      code: '',
      output: '123\n10 6 2',
      explanation: '',
    );

    test('tolère espaces et lignes vides autour', () {
      expect(challenge.matches('123\n10 6 2'), isTrue);
      expect(challenge.matches('  123  \r\n10   6 2 \n\n'), isTrue);
    });

    test('refuse une sortie différente', () {
      expect(challenge.matches('123 10 6 2'), isFalse);
      expect(challenge.matches('123\n10 6 2 -2'), isFalse);
      expect(challenge.matches(''), isFalse);
    });

    test('la casse compte', () {
      const shout = OutputChallenge(
        id: 's',
        title: 's',
        level: 'Débutant',
        code: '',
        output: 'KOTLIN',
        explanation: '',
      );
      expect(shout.matches('kotlin'), isFalse);
    });
  });

  test('le catalogue est cohérent', () {
    expect(outputChallenges.length, greaterThanOrEqualTo(12));
    final ids = outputChallenges.map((item) => item.id).toSet();
    expect(ids.length, outputChallenges.length);
    for (final item in outputChallenges) {
      expect(item.code, contains('println'));
      expect(item.output.trim(), isNotEmpty);
      expect(item.explanation.trim(), isNotEmpty);
      expect(item.matches(item.output), isTrue);
    }
  });

  testWidgets('une bonne réponse rapporte des XP une seule fois', (
    tester,
  ) async {
    // Box en mémoire : aucune écriture disque dans l'horloge simulée.
    late Box<dynamic> box;
    await tester.runAsync(() async {
      box = await Hive.openBox<dynamic>(
        'output_challenge_widget_test',
        bytes: Uint8List(0),
      );
    });
    final container = ProviderContainer(
      overrides: [progressBoxProvider.overrideWithValue(box)],
    );
    addTearDown(container.dispose);

    final challenge = outputChallenges.first;
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(home: OutputChallengeScreen(challenge: challenge)),
      ),
    );

    await tester.enterText(find.byType(TextField), 'faux');
    await tester.pump();
    await tester.ensureVisible(find.text('Vérifier'));
    await tester.tap(find.text('Vérifier'));
    await tester.pump();
    expect(find.textContaining('Pas tout à fait'), findsOneWidget);
    expect(container.read(profileControllerProvider).xp, 0);

    await tester.enterText(find.byType(TextField), challenge.output);
    await tester.pump();
    await tester.ensureVisible(find.text('Vérifier'));
    await tester.tap(find.text('Vérifier'));
    await tester.pump();
    expect(find.text('Exact !'), findsOneWidget);
    expect(container.read(profileControllerProvider).xp, challenge.xp);
    expect(
      container.read(profileControllerProvider).completedExerciseIds,
      contains(challenge.progressId),
    );
  });
}
