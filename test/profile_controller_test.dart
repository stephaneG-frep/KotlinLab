import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:kotlin_lab/features/learning/data/learning_catalog.dart';
import 'package:kotlin_lab/features/profile/presentation/profile_controller.dart';

void main() {
  late Directory dir;
  late Box<dynamic> box;
  late DateTime now;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('kotlin_lab_test');
    Hive.init(dir.path);
    box = await Hive.openBox<dynamic>(progressBoxName);
    now = DateTime(2026, 3, 10, 9);
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    await dir.delete(recursive: true);
  });

  ProviderContainer createContainer() {
    final container = ProviderContainer(
      overrides: [
        progressBoxProvider.overrideWithValue(box),
        clockProvider.overrideWithValue(() => now),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  ProfileState read(ProviderContainer c) => c.read(profileControllerProvider);
  ProfileController ctrl(ProviderContainer c) =>
      c.read(profileControllerProvider.notifier);

  test('un nouveau profil démarre à zéro', () {
    final profile = read(createContainer());
    expect(profile.xp, 0);
    expect(profile.streak, 0);
    expect(profile.studyMinutes, 0);
    expect(profile.dailyMinutes, 0);
    expect(profile.completedLessonIds, isEmpty);
    expect(profile.displayName, isNotEmpty);
  });

  test('la série augmente les jours consécutifs et se casse après un trou', () {
    final c = createContainer();
    ctrl(c).completeLesson('intro', 40, minutes: 10);
    expect(read(c).streak, 1);
    expect(read(c).dailyMinutes, 10);

    now = DateTime(2026, 3, 11, 20);
    ctrl(c).refreshDay();
    expect(read(c).streak, 1, reason: 'la série tient jusqu’à la fin du jour');
    expect(read(c).dailyMinutes, 0, reason: 'nouveau jour, compteur remis à 0');

    ctrl(c).submitExercise('ex', 20, correct: false);
    expect(read(c).streak, 2);
    expect(read(c).dailyMinutes, exerciseMinutes);
    expect(read(c).studyMinutes, 10 + exerciseMinutes);

    now = DateTime(2026, 3, 13, 8);
    ctrl(c).refreshDay();
    expect(read(c).streak, 0);
  });

  test('la progression est relue depuis Hive', () {
    ctrl(createContainer()).completeLesson('intro', 40, minutes: 10);
    final profile = read(createContainer());
    expect(profile.xp, 40);
    expect(profile.completedLessonIds, {'intro'});
    expect(profile.streak, 1);
  });

  test('une leçon ne rapporte des XP qu’une fois', () {
    final c = createContainer();
    expect(ctrl(c).completeLesson('intro', 40, minutes: 10), isTrue);
    expect(ctrl(c).completeLesson('intro', 40, minutes: 10), isFalse);
    expect(read(c).xp, 40);
  });

  test('les 7 derniers jours se terminent aujourd’hui', () {
    final c = createContainer();
    ctrl(c).completeLesson('intro', 40, minutes: 15);
    final week = ctrl(c).lastSevenDays();
    expect(week, hasLength(7));
    expect(week.last.minutes, 15);
    expect(week.first.day.day, 4);
  });

  test('les anciennes données de démonstration sont migrées', () async {
    final lesson = learningPaths.first.lessons.first;
    await box.putAll({
      'xp': 1240 + lesson.xp,
      'streak': 7,
      'studyMinutes': 298,
      'completedLessons': 13,
      'completedLessonIds': [lesson.id],
      'darkMode': true,
    });
    final profile = read(createContainer());
    expect(profile.xp, lesson.xp);
    expect(profile.streak, 0);
    expect(profile.studyMinutes, 0);
    expect(profile.completedLessonIds, {lesson.id});
    expect(box.containsKey('completedLessons'), isFalse);
    expect(box.get('schemaVersion'), 1);
  });

  test('des valeurs corrompues ne font pas planter le chargement', () async {
    await box.putAll({
      'schemaVersion': 1,
      'xp': 'beaucoup',
      'textScale': 1,
      'completedLessonIds': 'intro',
      'activityLog': {'2026-03-10': 'dix'},
    });
    final profile = read(createContainer());
    expect(profile.xp, 0);
    expect(profile.textScale, 1.0);
    expect(profile.completedLessonIds, isEmpty);
    expect(profile.activityLog, isEmpty);
  });

  test(
    'le thème suit le système par défaut et reprend l’ancien réglage',
    () async {
      expect(read(createContainer()).themeMode, ThemeMode.system);

      await box.put('darkMode', true);
      expect(read(createContainer()).themeMode, ThemeMode.dark);

      final c = createContainer();
      ctrl(c).setThemeMode(ThemeMode.light);
      expect(read(createContainer()).themeMode, ThemeMode.light);
    },
  );
}
