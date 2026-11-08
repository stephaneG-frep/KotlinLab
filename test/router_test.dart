import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kotlin_lab/core/router/app_router.dart';
import 'package:kotlin_lab/shared/presentation/not_found_screen.dart';

void main() {
  for (final location in [
    '/lesson/inconnue',
    '/project/inconnu',
    '/nimporte',
  ]) {
    testWidgets('$location affiche la page introuvable', (tester) async {
      await tester.pumpWidget(MaterialApp.router(routerConfig: appRouter));
      appRouter.go(location);
      await tester.pumpAndSettle();
      expect(find.byType(NotFoundScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
