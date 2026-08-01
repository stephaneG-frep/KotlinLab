abstract final class ProgressCalculator {
  static double ratio(int completed, int total) {
    if (total <= 0) return 0;
    return (completed / total).clamp(0, 1);
  }

  static int levelForXp(int xp) {
    if (xp <= 0) return 1;
    return (xp ~/ 250) + 1;
  }

  static int xpUntilNextLevel(int xp) {
    final nextThreshold = levelForXp(xp) * 250;
    return nextThreshold - xp;
  }
}
