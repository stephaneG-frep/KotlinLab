import 'package:flutter_test/flutter_test.dart';
import 'package:kotlin_lab/core/theme/app_theme.dart';

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
}
