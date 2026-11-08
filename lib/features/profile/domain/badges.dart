import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../presentation/profile_controller.dart';

class AchievementBadge {
  const AchievementBadge({
    required this.icon,
    required this.label,
    required this.hint,
    required this.color,
    required this.earned,
  });

  final IconData icon;
  final String label;
  final String hint;
  final Color color;
  final bool earned;
}

/// Badges obtenus à partir de la progression réelle.
List<AchievementBadge> badgesFor(ProfileState profile) => [
  AchievementBadge(
    icon: Icons.school_rounded,
    label: 'Premier pas',
    hint: 'Termine une leçon',
    color: AppColors.success,
    earned: profile.completedLessonIds.isNotEmpty,
  ),
  AchievementBadge(
    icon: Icons.local_fire_department_rounded,
    label: 'En feu',
    hint: '3 jours de suite',
    color: const Color(0xFFFF7043),
    earned: profile.streak >= 3,
  ),
  AchievementBadge(
    icon: Icons.code_rounded,
    label: 'Codeur',
    hint: 'Valide 5 exercices',
    color: AppColors.primary,
    earned: profile.completedExerciseIds.length >= 5,
  ),
  AchievementBadge(
    icon: Icons.speed_rounded,
    label: 'Rapide',
    hint: 'Termine le quiz rapide',
    color: AppColors.secondary,
    earned: profile.completedQuizIds.isNotEmpty,
  ),
];
