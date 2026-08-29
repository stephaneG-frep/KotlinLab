import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/kit.dart';
import '../../learning/data/learning_catalog.dart';
import '../../learning/domain/learning_models.dart';
import '../../profile/presentation/profile_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileControllerProvider);
    final resume = _nextLesson(profile.completedLessonIds);
    return ScreenBody(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
            sliver: SliverList.list(
              children: [
                _TopBar(name: profile.name),
                const SizedBox(height: 24),
                _WelcomeCard(profile: profile),
                const SizedBox(height: 24),
                Row(
                  children: [
                    StatPill(
                      icon: Icons.local_fire_department_rounded,
                      value: '${profile.streak} j',
                      label: 'Série',
                      color: const Color(0xFFFF7043),
                    ),
                    const SizedBox(width: 10),
                    StatPill(
                      icon: Icons.bolt_rounded,
                      value: '${profile.xp}',
                      label: 'XP total',
                      color: AppColors.accent,
                    ),
                    const SizedBox(width: 10),
                    StatPill(
                      icon: Icons.schedule_rounded,
                      value:
                          '${profile.studyMinutes ~/ 60}h ${profile.studyMinutes % 60}',
                      label: 'Étudié',
                      color: AppColors.secondary,
                    ),
                  ],
                ).animate().fadeIn(delay: 180.ms).slideY(begin: .1),
                const SizedBox(height: 28),
                SectionHeader(
                  title: 'Reprendre le cours',
                  action: 'Voir le parcours',
                  onTap: () => context.go('/learning'),
                ),
                const SizedBox(height: 12),
                _ContinueCard(
                  lesson: resume.lesson,
                  path: resume.path,
                  onTap: () => context.push('/lesson/${resume.lesson.id}'),
                ),
                const SizedBox(height: 28),
                const SectionHeader(title: 'Défi du jour', action: '+50 XP'),
                const SizedBox(height: 12),
                _DailyChallenge(onTap: () => context.go('/exercises')),
                const SizedBox(height: 28),
                const SectionHeader(title: 'Boîte à outils'),
                const SizedBox(height: 12),
                const _QuickTools(),
                const SizedBox(height: 28),
                const SectionHeader(
                  title: 'Tes derniers badges',
                  action: 'Tout voir',
                ),
                const SizedBox(height: 12),
                const _Badges(),
                const SizedBox(height: 26),
                const _QuoteCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ({Lesson lesson, LearningPath path}) _nextLesson(Set<String> completedIds) {
    for (final path in learningPaths) {
      for (var index = 0; index < path.lessons.length; index++) {
        final lesson = path.lessons[index];
        if (!completedIds.contains(lesson.id) &&
            (index == 0 || completedIds.contains(path.lessons[index - 1].id))) {
          return (lesson: lesson, path: path);
        }
      }
    }
    final path = learningPaths.last;
    return (lesson: path.lessons.last, path: path);
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text(
            'K',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bonjour $name 👋',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              'Prêt pour une nouvelle étape ?',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      IconButton.filledTonal(
        onPressed: () => context.push('/search'),
        icon: const Icon(Icons.search_rounded),
        tooltip: 'Rechercher',
      ),
      const SizedBox(width: 5),
      Badge(
        smallSize: 8,
        child: IconButton.filledTonal(
          onPressed: () => _showNotifications(context),
          icon: const Icon(Icons.notifications_none_rounded),
          tooltip: 'Notifications',
        ),
      ),
    ],
  );

  void _showNotifications(BuildContext context) => showModalBottomSheet<void>(
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
              'Notifications',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            const ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                child: Icon(Icons.local_fire_department_rounded),
              ),
              title: Text('Ta série continue aujourd’hui'),
              subtitle: Text(
                'Quelques minutes suffisent pour garder le rythme.',
              ),
            ),
            const ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(child: Icon(Icons.bolt_rounded)),
              title: Text('Un nouveau quiz est disponible'),
              subtitle: Text('Teste tes bases Kotlin en cinq questions.'),
            ),
          ],
        ),
      ),
    ),
  );
}

class _WelcomeCard extends StatelessWidget {
  const _WelcomeCard({required this.profile});
  final ProfileState profile;

  @override
  Widget build(BuildContext context) {
    final progress = profile.dailyMinutes / profile.dailyGoal;
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5C33D5), AppColors.primary, Color(0xFF7B73FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: .25),
            blurRadius: 30,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Stack(
        children: [
          const Positioned(
            right: -18,
            top: -35,
            child: Icon(
              Icons.data_object_rounded,
              color: Color(0x22FFFFFF),
              size: 150,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .16),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'NIVEAU 6 · DÉVELOPPEUR CURIEUX',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: .6,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Ta régularité\nfait la différence.',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  height: 1.05,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: ProgressBar(
                      value: progress,
                      color: AppColors.accent,
                      height: 9,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${profile.dailyMinutes}/${profile.dailyGoal} min',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 7),
              const Text(
                'Objectif quotidien',
                style: TextStyle(color: Color(0xCCFFFFFF), fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: .08, curve: Curves.easeOutCubic);
  }
}

class _ContinueCard extends StatelessWidget {
  const _ContinueCard({
    required this.onTap,
    required this.lesson,
    required this.path,
  });
  final VoidCallback onTap;
  final Lesson lesson;
  final LearningPath path;
  @override
  Widget build(BuildContext context) => Card(
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            GradientIcon(icon: lesson.icon, size: 58),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${path.title} · Leçon ${path.lessons.indexOf(lesson) + 1}',
                  ),
                  const SizedBox(height: 12),
                  ProgressBar(
                    value:
                        (path.lessons.indexOf(lesson) + 1) /
                        path.lessons.length,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Container(
              width: 46,
              height: 46,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _DailyChallenge extends StatelessWidget {
  const _DailyChallenge({required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Card(
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: .18),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.emoji_events_rounded,
                color: Color(0xFFE09B00),
                size: 30,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Le mot mystère',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 3),
                  const Text('Complète une fonction qui inverse une chaîne.'),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    ),
  );
}

class _QuickTools extends StatelessWidget {
  const _QuickTools();
  @override
  Widget build(BuildContext context) {
    const tools = [
      (Icons.terminal_rounded, 'Playground', '/playground', AppColors.primary),
      (Icons.menu_book_rounded, 'Glossaire', '/glossary', AppColors.secondary),
      (
        Icons.compare_arrows_rounded,
        'Kotlin / Java',
        '/compare',
        AppColors.success,
      ),
    ];
    return Row(
      children: tools
          .map(
            (tool) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: tool == tools.last ? 0 : 9),
                child: Material(
                  color: tool.$4.withValues(alpha: .09),
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    onTap: () => context.push(tool.$3),
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 17,
                        horizontal: 5,
                      ),
                      child: Column(
                        children: [
                          Icon(tool.$1, color: tool.$4),
                          const SizedBox(height: 7),
                          Text(
                            tool.$2,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _Badges extends StatelessWidget {
  const _Badges();
  @override
  Widget build(BuildContext context) {
    const badges = [
      (Icons.local_fire_department_rounded, Color(0xFFFF7043), '7 jours'),
      (Icons.code_rounded, AppColors.primary, 'Codeur'),
      (Icons.auto_awesome_rounded, AppColors.secondary, 'Curieux'),
    ];
    return Row(
      children: badges
          .map(
            (badge) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: badge == badges.last ? 0 : 10),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 17),
                    child: Column(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: badge.$2.withValues(alpha: .12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(badge.$1, color: badge.$2),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          badge.$3,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _QuoteCard extends StatelessWidget {
  const _QuoteCard();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.secondary.withValues(alpha: .09),
      borderRadius: BorderRadius.circular(24),
    ),
    child: const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.format_quote_rounded, color: AppColors.secondary, size: 34),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            'Le meilleur moment pour apprendre était hier. Le deuxième meilleur, c’est maintenant.',
            style: TextStyle(fontWeight: FontWeight.w600, height: 1.45),
          ),
        ),
      ],
    ),
  );
}
