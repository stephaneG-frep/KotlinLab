import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

@immutable
class ProfileState {
  const ProfileState({
    this.name = 'Alex',
    this.xp = 1240,
    this.streak = 7,
    this.studyMinutes = 286,
    this.completedLessons = 12,
    this.dailyMinutes = 18,
    this.dailyGoal = 25,
    this.themeMode = ThemeMode.light,
    this.textScale = 1,
    this.favoriteLessonIds = const {},
    this.completedLessonIds = const {'intro', 'hello'},
    this.completedExerciseIds = const {},
    this.quizAttempts = 0,
    this.quizCorrectAnswers = 0,
  });

  final String name;
  final int xp;
  final int streak;
  final int studyMinutes;
  final int completedLessons;
  final int dailyMinutes;
  final int dailyGoal;
  final ThemeMode themeMode;
  final double textScale;
  final Set<String> favoriteLessonIds;
  final Set<String> completedLessonIds;
  final Set<String> completedExerciseIds;
  final int quizAttempts;
  final int quizCorrectAnswers;

  ProfileState copyWith({
    String? name,
    int? xp,
    int? streak,
    int? studyMinutes,
    int? completedLessons,
    int? dailyMinutes,
    int? dailyGoal,
    ThemeMode? themeMode,
    double? textScale,
    Set<String>? favoriteLessonIds,
    Set<String>? completedLessonIds,
    Set<String>? completedExerciseIds,
    int? quizAttempts,
    int? quizCorrectAnswers,
  }) => ProfileState(
    name: name ?? this.name,
    xp: xp ?? this.xp,
    streak: streak ?? this.streak,
    studyMinutes: studyMinutes ?? this.studyMinutes,
    completedLessons: completedLessons ?? this.completedLessons,
    dailyMinutes: dailyMinutes ?? this.dailyMinutes,
    dailyGoal: dailyGoal ?? this.dailyGoal,
    themeMode: themeMode ?? this.themeMode,
    textScale: textScale ?? this.textScale,
    favoriteLessonIds: favoriteLessonIds ?? this.favoriteLessonIds,
    completedLessonIds: completedLessonIds ?? this.completedLessonIds,
    completedExerciseIds: completedExerciseIds ?? this.completedExerciseIds,
    quizAttempts: quizAttempts ?? this.quizAttempts,
    quizCorrectAnswers: quizCorrectAnswers ?? this.quizCorrectAnswers,
  );
}

class ProfileController extends Notifier<ProfileState> {
  Box<dynamic> get _box => Hive.box<dynamic>('kotlin_lab_progress');

  @override
  ProfileState build() => ProfileState(
    name: _box.get('name', defaultValue: 'Alex') as String,
    xp: _box.get('xp', defaultValue: 1240) as int,
    streak: _box.get('streak', defaultValue: 7) as int,
    studyMinutes: _box.get('studyMinutes', defaultValue: 286) as int,
    completedLessons: _box.get('completedLessons', defaultValue: 12) as int,
    dailyMinutes: _box.get('dailyMinutes', defaultValue: 18) as int,
    dailyGoal: _box.get('dailyGoal', defaultValue: 25) as int,
    themeMode: (_box.get('darkMode', defaultValue: false) as bool)
        ? ThemeMode.dark
        : ThemeMode.light,
    textScale: _box.get('textScale', defaultValue: 1.0) as double,
    favoriteLessonIds: Set<String>.from(
      _box.get('favoriteLessonIds', defaultValue: <String>[]) as List,
    ),
    completedLessonIds: Set<String>.from(
      _box.get('completedLessonIds', defaultValue: <String>['intro', 'hello'])
          as List,
    ),
    completedExerciseIds: Set<String>.from(
      _box.get('completedExerciseIds', defaultValue: <String>[]) as List,
    ),
    quizAttempts: _box.get('quizAttempts', defaultValue: 0) as int,
    quizCorrectAnswers: _box.get('quizCorrectAnswers', defaultValue: 0) as int,
  );

  void toggleTheme(bool dark) {
    state = state.copyWith(themeMode: dark ? ThemeMode.dark : ThemeMode.light);
    _box.put('darkMode', dark);
  }

  void setTextScale(double value) {
    state = state.copyWith(textScale: value);
    _box.put('textScale', value);
  }

  void setGoal(int value) {
    state = state.copyWith(dailyGoal: value);
    _box.put('dailyGoal', value);
  }

  bool completeLesson(String lessonId, int xp) {
    if (state.completedLessonIds.contains(lessonId)) return false;
    final completedIds = {...state.completedLessonIds, lessonId};
    state = state.copyWith(
      xp: state.xp + xp,
      completedLessons: state.completedLessons + 1,
      studyMinutes: state.studyMinutes + 12,
      dailyMinutes: state.dailyMinutes + 12,
      completedLessonIds: completedIds,
    );
    _box.putAll({
      'xp': state.xp,
      'completedLessons': state.completedLessons,
      'studyMinutes': state.studyMinutes,
      'dailyMinutes': state.dailyMinutes,
      'completedLessonIds': completedIds.toList(),
    });
    return true;
  }

  void toggleFavorite(String lessonId) {
    final favorites = {...state.favoriteLessonIds};
    favorites.contains(lessonId)
        ? favorites.remove(lessonId)
        : favorites.add(lessonId);
    state = state.copyWith(favoriteLessonIds: favorites);
    _box.put('favoriteLessonIds', favorites.toList());
  }

  bool submitExercise(String exerciseId, int xp, {required bool correct}) {
    final alreadyCompleted = state.completedExerciseIds.contains(exerciseId);
    final completed = {...state.completedExerciseIds};
    if (correct) completed.add(exerciseId);
    final reward = correct && !alreadyCompleted ? xp : 0;

    state = state.copyWith(
      xp: state.xp + reward,
      completedExerciseIds: completed,
      quizAttempts: state.quizAttempts + 1,
      quizCorrectAnswers: state.quizCorrectAnswers + (correct ? 1 : 0),
    );
    _box.putAll({
      'xp': state.xp,
      'completedExerciseIds': completed.toList(),
      'quizAttempts': state.quizAttempts,
      'quizCorrectAnswers': state.quizCorrectAnswers,
    });
    return reward > 0;
  }
}

final profileControllerProvider =
    NotifierProvider<ProfileController, ProfileState>(ProfileController.new);
