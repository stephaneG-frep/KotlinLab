import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/kit.dart';
import 'profile_controller.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileControllerProvider);
    final controller = ref.read(profileControllerProvider.notifier);
    return ScreenBody(
      child: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            pinned: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: const Text('Mon profil'),
            actions: [
              IconButton.filledTonal(
                onPressed: () => _settings(context, profile, controller),
                icon: const Icon(Icons.settings_rounded),
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
                      value: '${profile.completedLessons}',
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
                const SectionHeader(
                  title: 'Activité cette semaine',
                  action: '4 h 46',
                ),
                const SizedBox(height: 12),
                const _ActivityChart(),
                const SizedBox(height: 28),
                const SectionHeader(title: 'Badges', action: '12 / 50'),
                const SizedBox(height: 12),
                const _BadgeGrid(),
                const SizedBox(height: 28),
                const SectionHeader(title: 'Ta progression'),
                const SizedBox(height: 12),
                const _ProgressList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _settings(
    BuildContext context,
    ProfileState state,
    ProfileController controller,
  ) => showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Préférences',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 14),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              secondary: const Icon(Icons.dark_mode_rounded),
              title: const Text('Mode sombre'),
              value: state.themeMode == ThemeMode.dark,
              onChanged: controller.toggleTheme,
            ),
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
    ),
  );
}

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({required this.profile});
  final ProfileState profile;
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
                profile.name.characters.first,
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
                  profile.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Text('Développeur curieux · Niveau 6'),
                const SizedBox(height: 10),
                const ProgressBar(value: .68),
                const SizedBox(height: 5),
                const Text(
                  '760 XP avant le niveau 7',
                  style: TextStyle(fontSize: 11, color: AppColors.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _ActivityChart extends StatelessWidget {
  const _ActivityChart();
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 14),
      child: SizedBox(
        height: 180,
        child: BarChart(
          BarChartData(
            maxY: 60,
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
                      const ['L', 'M', 'M', 'J', 'V', 'S', 'D'][value.toInt()],
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                ),
              ),
            ),
            barGroups: [22, 38, 16, 48, 32, 55, 18]
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
  const _BadgeGrid();
  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.local_fire_department_rounded, 'En feu', Color(0xFFFF7043)),
      (Icons.code_rounded, 'Codeur', AppColors.primary),
      (Icons.speed_rounded, 'Rapide', AppColors.secondary),
      (Icons.lock_rounded, 'À venir', Colors.grey),
    ];
    return Row(
      children: items
          .map(
            (item) => Expanded(
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
          )
          .toList(),
    );
  }
}

class _ProgressList extends StatelessWidget {
  const _ProgressList();
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: const [
          _ProgressRow(
            label: 'Fondations Kotlin',
            value: .38,
            color: AppColors.primary,
          ),
          SizedBox(height: 18),
          _ProgressRow(
            label: 'Kotlin orienté objet',
            value: .08,
            color: AppColors.secondary,
          ),
          SizedBox(height: 18),
          _ProgressRow(
            label: 'Kotlin avancé',
            value: 0,
            color: Color(0xFFFF8A65),
          ),
          SizedBox(height: 18),
          _ProgressRow(
            label: 'Android & Compose',
            value: 0,
            color: AppColors.success,
          ),
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
