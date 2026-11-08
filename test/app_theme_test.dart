import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kotlin_lab/core/theme/app_theme.dart';

double _contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final hi = la > lb ? la : lb;
  final lo = la > lb ? lb : la;
  return (hi + .05) / (lo + .05);
}

void main() {
  for (final scale in [.9, 1.0, 1.25]) {
    test('le thème se construit avec une taille de texte de $scale', () {
      final light = AppTheme.light(scale);
      final dark = AppTheme.dark(scale);
      expect(light.textTheme.bodyLarge?.fontSize, isNotNull);
      expect(light.textTheme.bodyLarge?.fontFamily, AppTheme.fontFamily);
      expect(dark.textTheme.titleLarge?.fontFamily, AppTheme.fontFamily);
    });
  }

  for (final (name, theme) in [
    ('clair', AppTheme.light(1)),
    ('sombre', AppTheme.dark(1)),
  ]) {
    test('le texte du thème $name est lisible sur le fond', () {
      final styles = {
        'displaySmall': theme.textTheme.displaySmall,
        'headlineMedium': theme.textTheme.headlineMedium,
        'titleLarge': theme.textTheme.titleLarge,
        'titleMedium': theme.textTheme.titleMedium,
        'bodyLarge': theme.textTheme.bodyLarge,
        'bodyMedium': theme.textTheme.bodyMedium,
        'labelLarge': theme.textTheme.labelLarge,
      };
      for (final MapEntry(:key, :value) in styles.entries) {
        final color = value?.color;
        expect(color, isNotNull, reason: '$key sans couleur');
        for (final background in [
          theme.scaffoldBackgroundColor,
          theme.colorScheme.surface,
        ]) {
          expect(
            _contrast(color!, background),
            greaterThanOrEqualTo(4.5),
            reason: '$key peu lisible sur $background',
          );
        }
      }
    });
  }
}
