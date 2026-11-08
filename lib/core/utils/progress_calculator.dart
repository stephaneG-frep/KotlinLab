abstract final class ProgressCalculator {
  static const xpPerLevel = 250;

  static double ratio(int completed, int total) {
    if (total <= 0) return 0;
    return (completed / total).clamp(0, 1);
  }

  static int levelForXp(int xp) {
    if (xp <= 0) return 1;
    return (xp ~/ xpPerLevel) + 1;
  }

  static int xpUntilNextLevel(int xp) {
    final nextThreshold = levelForXp(xp) * xpPerLevel;
    return nextThreshold - xp;
  }

  /// Avancement dans le niveau courant, entre 0 et 1.
  static double levelProgress(int xp) =>
      ratio(xpPerLevel - xpUntilNextLevel(xp), xpPerLevel);

  static String levelTitle(int level) => switch (level) {
    <= 2 => 'Débutant',
    <= 5 => 'Développeur curieux',
    <= 9 => 'Développeur confirmé',
    _ => 'Expert Kotlin',
  };
}
