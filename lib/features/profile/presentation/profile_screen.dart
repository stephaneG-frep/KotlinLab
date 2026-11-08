import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/progress_calculator.dart';
import '../../../shared/widgets/kit.dart';
import '../../learning/data/learning_catalog.dart';
import '../domain/badges.dart';
import 'profile_controller.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileControllerProvider);
    final controller = ref.read(profileControllerProvider.notifier);
    final week = controller.lastSevenDays();
    final weekMinutes = week.fold<int>(0, (sum, day) => sum + day.minutes);
    final badges = badgesFor(profile);
    final earnedBadges = badges.where((badge) => badge.earned).length;
    return ScreenBody(
      child: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            pinned: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: const Text('Mon profil'),
            actions: [
              IconButton.filledTonal(
                onPressed: () => _settings(context),
                icon: const Icon(Icons.settings_rounded),
                tooltip: 'Préférences',
              ),
              const SizedBox(width: 16),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
            sliver: SliverList.list(
              children: [
                _ProfileHero(profile: profile),
                const SizedBox(height: 22),
                Row(
                  children: [
                    StatPill(
                      icon: Icons.bolt_rounded,
                      value: '${profile.xp}',
                      label: 'XP',
                      color: AppColors.accent,
                    ),
                    const SizedBox(width: 10),
                    StatPill(
                      icon: Icons.menu_book_rounded,
                      value: '${profile.completedLessonIds.length}',
                      label: 'Leçons',
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 10),
                    StatPill(
                      icon: Icons.local_fire_department_rounded,
                      value: '${profile.streak}',
                      label: 'Jours',
                      color: const Color(0xFFFF7043),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                SectionHeader(
                  title: 'Activité cette semaine',
                  action: '${weekMinutes ~/ 60} h ${weekMinutes % 60}',
                ),
                const SizedBox(height: 12),
                _ActivityChart(days: week),
                const SizedBox(height: 28),
                SectionHeader(
                  title: 'Badges',
                  action: '$earnedBadges / ${badges.length}',
                ),
                const SizedBox(height: 12),
                _BadgeGrid(badges: badges),
                const SizedBox(height: 28),
                SectionHeader(
                  title: 'Précision des réponses',
                  action: profile.quizAttempts == 0
                      ? 'Pas encore tenté'
                      : '${((profile.quizCorrectAnswers / profile.quizAttempts) * 100).round()} %',
                ),
                const SizedBox(height: 12),
                _QuizStats(profile: profile),
                const SizedBox(height: 28),
                const SectionHeader(title: 'Ta progression'),
                const SizedBox(height: 12),
                _ProgressList(completedIds: profile.completedLessonIds),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _settings(BuildContext context) => showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    // Hauteur libre + défilement : le contenu ne déborde plus avec une
    // grande taille de texte ou un petit écran.
    isScrollControlled: true,
    // Consumer : la feuille se reconstruit quand les préférences changent.
    builder: (context) => Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(profileControllerProvider);
        final controller = ref.read(profileControllerProvider.notifier);
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Préférences',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 14),
                const ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.dark_mode_rounded),
                  title: Text('Thème'),
                ),
                SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<ThemeMode>(
                    // Sans icônes ni coche : les libellés tiennent sur une
                    // ligne même en grand texte.
                    showSelectedIcon: false,
                    segments: const [
                      ButtonSegment(
                        value: ThemeMode.system,
                        label: _SegmentLabel('Système'),
                      ),
                      ButtonSegment(
                        value: ThemeMode.light,
                        label: _SegmentLabel('Clair'),
                      ),
                      ButtonSegment(
                        value: ThemeMode.dark,
                        label: _SegmentLabel('Sombre'),
                      ),
                    ],
                    selected: {state.themeMode},
                    onSelectionChanged: (modes) =>
                        controller.setThemeMode(modes.first),
                  ),
                ),
                const SizedBox(height: 8),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.text_fields_rounded),
                  title: const Text('Taille du texte'),
                  subtitle: Slider(
                    value: state.textScale,
                    min: .9,
                    max: 1.25,
                    divisions: 7,
                    onChanged: controller.setTextScale,
                  ),
                ),
                const ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.language_rounded),
                  title: Text('Langue'),
                  trailing: Text('Français'),
                ),
                const ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.ios_share_rounded),
                  title: Text('Exporter mes progrès'),
                  trailing: Icon(Icons.chevron_right_rounded),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({required this.profile});
  final ProfileState profile;
  int get level => ProgressCalculator.levelForXp(profile.xp);
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 74,
            height: 74,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: Text(
                profile.displayName.characters.first,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.displayName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text('${ProgressCalculator.levelTitle(level)} · Niveau $level'),
                const SizedBox(height: 10),
                ProgressBar(
                  value: ProgressCalculator.levelProgress(profile.xp),
                ),
                const SizedBox(height: 5),
                Text(
                  '${ProgressCalculator.xpUntilNextLevel(profile.xp)} XP '
                  'avant le niveau ${level + 1}',
                  style: const TextStyle(fontSize: 11, color: AppColors.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _QuizStats extends StatelessWidget {
  const _QuizStats({required this.profile});

  final ProfileState profile;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Expanded(
            child: _QuizMetric(
              value: '${profile.quizAttempts}',
              label: 'Réponses',
              color: AppColors.primary,
            ),
          ),
          Expanded(
            child: _QuizMetric(
              value: '${profile.quizCorrectAnswers}',
              label: 'Correctes',
              color: AppColors.success,
            ),
          ),
          Expanded(
            child: _QuizMetric(
              value: '${profile.completedExerciseIds.length}',
              label: 'Validés',
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    ),
  );
}

class _QuizMetric extends StatelessWidget {
  const _QuizMetric({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        value,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w900,
        ),
      ),
      const SizedBox(height: 3),
      Text(label, style: Theme.of(context).textTheme.bodySmall),
    ],
  );
}

class _ActivityChart extends StatelessWidget {
  const _ActivityChart({required this.days});
  final List<({DateTime day, int minutes})> days;

  static const _weekdays = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 14),
      child: SizedBox(
        height: 180,
        child: BarChart(
          BarChartData(
            maxY: days
                .map((day) => day.minutes)
                .fold<int>(30, (max, minutes) => minutes > max ? minutes : max)
                .toDouble(),
            alignment: BarChartAlignment.spaceAround,
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            barTouchData: BarTouchData(enabled: false),
            titlesData: FlTitlesData(
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) => Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      _weekdays[days[value.toInt()].day.weekday - 1],
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                ),
              ),
            ),
            barGroups: days
                .map((day) => day.minutes)
                .toList()
                .asMap()
                .entries
                .map(
                  (entry) => BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: entry.value.toDouble(),
                        width: 17,
                        borderRadius: BorderRadius.circular(6),
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.secondary],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ),
    ),
  );
}

class _BadgeGrid extends StatelessWidget {
  const _BadgeGrid({required this.badges});
  final List<AchievementBadge> badges;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: badges
          .map(
            (badge) => (
              badge.earned ? badge.icon : Icons.lock_rounded,
              badge.label,
              badge.earned ? badge.color : Colors.grey,
              badge.hint,
            ),
          )
          .map(
            (item) => Expanded(
              child: Tooltip(
                message: item.$4,
                child: Column(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: item.$3.withValues(alpha: .12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(item.$1, color: item.$3),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.$2,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _ProgressList extends StatelessWidget {
  const _ProgressList({required this.completedIds});
  final Set<String> completedIds;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          for (final path in learningPaths) ...[
            if (path != learningPaths.first) const SizedBox(height: 18),
            _ProgressRow(
              label: path.title,
              value: ProgressCalculator.ratio(
                path.lessons
                    .where((lesson) => completedIds.contains(lesson.id))
                    .length,
                path.lessons.length,
              ),
              color: path.color,
            ),
          ],
        ],
      ),
    ),
  );
}

class _ProgressRow extends StatelessWidget {
  const _ProgressRow({
    required this.label,
    required this.value,
    required this.color,
  });
  final String label;
  final double value;
  final Color color;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          Text('${(value * 100).round()} %'),
        ],
      ),
      const SizedBox(height: 8),
      ProgressBar(value: value, color: color),
    ],
  );
}

/// Libellé réduit plutôt que coupé quand la place manque.
class _SegmentLabel extends StatelessWidget {
  const _SegmentLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => FittedBox(
    fit: BoxFit.scaleDown,
    child: Text(text, maxLines: 1, softWrap: false),
  );
}
