import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../learning/data/learning_catalog.dart';

const progressBoxName = 'kotlin_lab_progress';

/// Version du format stocké dans la box Hive.
/// 0 (absente) : ancien format avec compteurs de démonstration.
/// 1 : journal d'activité quotidien, compteurs dérivés.
const _schemaVersion = 1;

/// Minutes comptabilisées pour une tentative d'exercice.
const exerciseMinutes = 2;

final progressBoxProvider = Provider<Box<dynamic>>(
  (ref) => Hive.box<dynamic>(progressBoxName),
);

/// Horloge injectable pour pouvoir tester la série quotidienne.
final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

/// Clé de jour locale au format `aaaa-mm-jj`.
String dayKey(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-'
    '${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';

DateTime _previousDay(DateTime date) =>
    DateTime(date.year, date.month, date.day - 1);

@immutable
class ProfileState {
  const ProfileState({
    this.name = '',
    this.xp = 0,
    this.streak = 0,
    this.studyMinutes = 0,
    this.dailyMinutes = 0,
    this.dailyGoal = 25,
    this.themeMode = ThemeMode.light,
    this.textScale = 1,
    this.favoriteLessonIds = const {},
    this.completedLessonIds = const {},
    this.completedExerciseIds = const {},
    this.quizAttempts = 0,
    this.quizCorrectAnswers = 0,
    this.completedQuizIds = const {},
    this.startedProjectIds = const {},
    this.activityLog = const {},
  });

  final String name;
  final int xp;

  /// Dérivés de [activityLog] par le contrôleur.
  final int streak;
  final int studyMinutes;
  final int dailyMinutes;

  final int dailyGoal;
  final ThemeMode themeMode;
  final double textScale;
  final Set<String> favoriteLessonIds;
  final Set<String> completedLessonIds;
  final Set<String> completedExerciseIds;
  final int quizAttempts;
  final int quizCorrectAnswers;
  final Set<String> completedQuizIds;
  final Set<String> startedProjectIds;

  /// Minutes d'étude par jour, indexées par [dayKey].
  final Map<String, int> activityLog;

  String get displayName => name.isEmpty ? 'Apprenant Kotlin' : name;

  ProfileState copyWith({
    String? name,
    int? xp,
    int? streak,
    int? studyMinutes,
    int? dailyMinutes,
    int? dailyGoal,
    ThemeMode? themeMode,
    double? textScale,
    Set<String>? favoriteLessonIds,
    Set<String>? completedLessonIds,
    Set<String>? completedExerciseIds,
    int? quizAttempts,
    int? quizCorrectAnswers,
    Set<String>? completedQuizIds,
    Set<String>? startedProjectIds,
    Map<String, int>? activityLog,
  }) => ProfileState(
    name: name ?? this.name,
    xp: xp ?? this.xp,
    streak: streak ?? this.streak,
    studyMinutes: studyMinutes ?? this.studyMinutes,
    dailyMinutes: dailyMinutes ?? this.dailyMinutes,
    dailyGoal: dailyGoal ?? this.dailyGoal,
    themeMode: themeMode ?? this.themeMode,
    textScale: textScale ?? this.textScale,
    favoriteLessonIds: favoriteLessonIds ?? this.favoriteLessonIds,
    completedLessonIds: completedLessonIds ?? this.completedLessonIds,
    completedExerciseIds: completedExerciseIds ?? this.completedExerciseIds,
    quizAttempts: quizAttempts ?? this.quizAttempts,
    quizCorrectAnswers: quizCorrectAnswers ?? this.quizCorrectAnswers,
    completedQuizIds: completedQuizIds ?? this.completedQuizIds,
    startedProjectIds: startedProjectIds ?? this.startedProjectIds,
    activityLog: activityLog ?? this.activityLog,
  );
}

class ProfileController extends Notifier<ProfileState> {
  Box<dynamic> get _box => ref.read(progressBoxProvider);
  DateTime _now() => ref.read(clockProvider)();

  @override
  ProfileState build() {
    _migrate();
    final state = ProfileState(
      name: _read('name', ''),
      xp: _read('xp', 0),
      dailyGoal: _read('dailyGoal', 25),
      themeMode: _read('darkMode', false) ? ThemeMode.dark : ThemeMode.light,
      textScale: _readDouble('textScale', 1),
      favoriteLessonIds: _readIds('favoriteLessonIds'),
      completedLessonIds: _readIds('completedLessonIds'),
      completedExerciseIds: _readIds('completedExerciseIds'),
      quizAttempts: _read('quizAttempts', 0),
      quizCorrectAnswers: _read('quizCorrectAnswers', 0),
      completedQuizIds: _readIds('completedQuizIds'),
      startedProjectIds: _readIds('startedProjectIds'),
      activityLog: _readLog(),
    );
    return _withDerivedActivity(state);
  }

  /// Recalcule la série et les minutes du jour (changement de date).
  void refreshDay() => state = _withDerivedActivity(state);

  /// Minutes étudiées chacun des 7 derniers jours, du plus ancien à aujourd'hui.
  List<({DateTime day, int minutes})> lastSevenDays() {
    var day = _now();
    final days = <({DateTime day, int minutes})>[];
    for (var i = 0; i < 7; i++) {
      days.insert(0, (day: day, minutes: state.activityLog[dayKey(day)] ?? 0));
      day = _previousDay(day);
    }
    return days;
  }

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

  bool completeLesson(String lessonId, int xp, {required int minutes}) {
    if (state.completedLessonIds.contains(lessonId)) return false;
    final completedIds = {...state.completedLessonIds, lessonId};
    state = state.copyWith(xp: state.xp + xp, completedLessonIds: completedIds);
    _recordActivity(minutes);
    _box.putAll({'xp': state.xp, 'completedLessonIds': completedIds.toList()});
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
    _recordActivity(exerciseMinutes);
    _box.putAll({
      'xp': state.xp,
      'completedExerciseIds': completed.toList(),
      'quizAttempts': state.quizAttempts,
      'quizCorrectAnswers': state.quizCorrectAnswers,
    });
    return reward > 0;
  }

  /// Un quiz compte une minute par question.
  int completeQuiz(String quizId, {required int score, required int total}) {
    final alreadyRewarded = state.completedQuizIds.contains(quizId);
    final quizIds = {...state.completedQuizIds, quizId};
    final reward = alreadyRewarded ? 0 : score * 10;
    state = state.copyWith(
      xp: state.xp + reward,
      quizAttempts: state.quizAttempts + total,
      quizCorrectAnswers: state.quizCorrectAnswers + score,
      completedQuizIds: quizIds,
    );
    _recordActivity(total);
    _box.putAll({
      'xp': state.xp,
      'quizAttempts': state.quizAttempts,
      'quizCorrectAnswers': state.quizCorrectAnswers,
      'completedQuizIds': quizIds.toList(),
    });
    return reward;
  }

  void startProject(String projectId) {
    final projects = {...state.startedProjectIds, projectId};
    state = state.copyWith(startedProjectIds: projects);
    _box.put('startedProjectIds', projects.toList());
  }

  // --- Activité quotidienne -------------------------------------------------

  void _recordActivity(int minutes) {
    final today = dayKey(_now());
    final log = {
      ...state.activityLog,
      today: (state.activityLog[today] ?? 0) + minutes,
    };
    state = _withDerivedActivity(state.copyWith(activityLog: log));
    _box.put('activityLog', log);
  }

  ProfileState _withDerivedActivity(ProfileState state) {
    final log = state.activityLog;
    final today = _now();
    var day = today;
    // La série reste active tant que la journée d'aujourd'hui n'est pas finie.
    if (!log.containsKey(dayKey(day))) day = _previousDay(day);
    var streak = 0;
    while (log.containsKey(dayKey(day))) {
      streak++;
      day = _previousDay(day);
    }
    return state.copyWith(
      streak: streak,
      dailyMinutes: log[dayKey(today)] ?? 0,
      studyMinutes: log.values.fold<int>(0, (sum, minutes) => sum + minutes),
    );
  }

  // --- Persistance ----------------------------------------------------------

  /// Les anciennes versions partaient de valeurs de démonstration (1240 XP,
  /// série de 7 jours…). On conserve préférences et éléments réellement
  /// terminés, on supprime les compteurs factices et on recalcule les XP.
  void _migrate() {
    if (_read('schemaVersion', 0) >= _schemaVersion) return;
    if (_box.isNotEmpty) {
      final lessonIds = _readIds('completedLessonIds');
      final exerciseIds = _readIds('completedExerciseIds');
      final xp =
          learningPaths
              .expand((path) => path.lessons)
              .where((lesson) => lessonIds.contains(lesson.id))
              .fold<int>(0, (sum, lesson) => sum + lesson.xp) +
          exercises
              .where((exercise) => exerciseIds.contains(exercise.id))
              .fold<int>(0, (sum, exercise) => sum + exercise.xp);
      // Les XP de quiz ne sont pas recalculables : on libère les quiz
      // pour qu'ils puissent de nouveau rapporter des XP.
      _box.deleteAll([
        'streak',
        'studyMinutes',
        'dailyMinutes',
        'completedLessons',
        'completedQuizIds',
      ]);
      _box.put('xp', xp);
    }
    _box.put('schemaVersion', _schemaVersion);
  }

  /// Lecture tolérante : une valeur absente ou d'un type inattendu
  /// est remplacée par [fallback] au lieu de faire planter l'application.
  T _read<T>(String key, T fallback) {
    final value = _box.get(key);
    return value is T ? value : fallback;
  }

  double _readDouble(String key, double fallback) {
    final value = _box.get(key);
    return value is num ? value.toDouble() : fallback;
  }

  Set<String> _readIds(String key) {
    final value = _box.get(key);
    return value is List ? value.whereType<String>().toSet() : <String>{};
  }

  Map<String, int> _readLog() {
    final value = _box.get('activityLog');
    if (value is! Map) return const {};
    return {
      for (final entry in value.entries)
        if (entry.key is String && entry.value is int)
          entry.key as String: entry.value as int,
    };
  }
}

final profileControllerProvider =
    NotifierProvider<ProfileController, ProfileState>(ProfileController.new);
