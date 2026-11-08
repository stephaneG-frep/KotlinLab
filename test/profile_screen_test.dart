import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:kotlin_lab/core/theme/app_theme.dart';
import 'package:kotlin_lab/features/profile/presentation/profile_controller.dart';
import 'package:kotlin_lab/features/profile/presentation/profile_screen.dart';

void main() {
  testWidgets(
    'les préférences ne débordent pas sur petit écran en grand texte',
    (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      late Box<dynamic> box;
      await tester.runAsync(() async {
        box = await Hive.openBox<dynamic>(
          'profile_screen_test',
          bytes: Uint8List(0),
        );
      });
      final container = ProviderContainer(
        overrides: [progressBoxProvider.overrideWithValue(box)],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.light(1.25),
            home: const ProfileScreen(),
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.byTooltip('Préférences'));
      await tester.pumpAndSettle();

      expect(find.text('Thème'), findsOneWidget);
      for (final label in ['Système', 'Clair', 'Sombre']) {
        final paragraph = tester.renderObject<RenderParagraph>(
          find.text(label),
        );
        expect(
          paragraph.didExceedMaxLines ||
              paragraph.getMaxIntrinsicWidth(double.infinity) >
                  paragraph.size.width + .5,
          isFalse,
          reason: '« $label » est coupé',
        );
      }
      expect(tester.takeException(), isNull);
    },
  );
}
