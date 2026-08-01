import 'package:flutter_test/flutter_test.dart';
import 'package:kotlin_lab/core/utils/progress_calculator.dart';

void main() {
  group('ProgressCalculator', () {
    test('calcule et borne une progression', () {
      expect(ProgressCalculator.ratio(3, 10), .3);
      expect(ProgressCalculator.ratio(12, 10), 1);
      expect(ProgressCalculator.ratio(3, 0), 0);
    });

    test('calcule le niveau depuis les XP', () {
      expect(ProgressCalculator.levelForXp(0), 1);
      expect(ProgressCalculator.levelForXp(249), 1);
      expect(ProgressCalculator.levelForXp(250), 2);
      expect(ProgressCalculator.xpUntilNextLevel(300), 200);
    });
  });
}
