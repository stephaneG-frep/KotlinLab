import 'package:flutter/material.dart';

enum LessonStatus { completed, current, locked }

class Lesson {
  const Lesson({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.xp,
    required this.status,
    required this.icon,
    this.content = '',
  });

  final String id;
  final String title;
  final String subtitle;
  final int duration;
  final int xp;
  final LessonStatus status;
  final IconData icon;
  final String content;
}

class LearningPath {
  const LearningPath({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
    required this.progress,
    required this.lessons,
  });

  final String id;
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;
  final double progress;
  final List<Lesson> lessons;
}

class ExerciseItem {
  const ExerciseItem({
    required this.id,
    required this.title,
    required this.category,
    required this.difficulty,
    required this.xp,
    required this.icon,
    required this.color,
  });

  final String id;
  final String title;
  final String category;
  final String difficulty;
  final int xp;
  final IconData icon;
  final Color color;
}

class ProjectItem {
  const ProjectItem({
    required this.id,
    required this.title,
    required this.description,
    required this.level,
    required this.duration,
    required this.tags,
    required this.color,
    required this.icon,
  });

  final String id;
  final String title;
  final String description;
  final String level;
  final String duration;
  final List<String> tags;
  final Color color;
  final IconData icon;
}
