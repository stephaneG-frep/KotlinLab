import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/kit.dart';
import '../../profile/presentation/profile_controller.dart';
import '../data/learning_catalog.dart';
import '../domain/learning_models.dart';

class LearningScreen extends ConsumerStatefulWidget {
  const LearningScreen({super.key});

  @override
  ConsumerState<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends ConsumerState<LearningScreen> {
  String selected = 'beginner';

  @override
  Widget build(BuildContext context) {
    final path = learningPaths.firstWhere((item) => item.id == selected);
    final completedIds = ref
        .watch(profileControllerProvider)
        .completedLessonIds;
    final pathProgress = path.lessons.isEmpty
        ? 0.0
        : path.lessons
                  .where((lesson) => completedIds.contains(lesson.id))
                  .length /
              path.lessons.length;
    return ScreenBody(
      child: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            pinned: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: const Text('Ton parcours'),
            actions: [
              IconButton.filledTonal(
                onPressed: () {},
                icon: const Icon(Icons.search_rounded),
              ),
              const SizedBox(width: 16),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Avance à ton rythme, un concept après l’autre.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 45,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: learningPaths.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (_, index) {
                        final item = learningPaths[index];
                        return ChoiceChip(
                          selected: selected == item.id,
                          onSelected: (_) => setState(() => selected = item.id),
                          avatar: Icon(item.icon, size: 17),
                          label: Text(item.title.split(' ').first),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 22),
                  _PathHero(path: path, progress: pathProgress),
                  const SizedBox(height: 26),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Plan du cours',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      Text(
                        '${path.lessons.length} leçons',
                        style: const TextStyle(color: AppColors.muted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
            sliver: SliverList.separated(
              itemCount: path.lessons.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (_, index) => _LessonTile(
                lesson: path.lessons[index],
                number: index + 1,
                color: path.color,
                completed: completedIds.contains(path.lessons[index].id),
                unlocked:
                    index == 0 ||
                    completedIds.contains(path.lessons[index - 1].id),
              ).animate().fadeIn(delay: (index * 60).ms).slideX(begin: .05),
            ),
          ),
        ],
      ),
    );
  }
}

class _PathHero extends StatelessWidget {
  const _PathHero({required this.path, required this.progress});
  final LearningPath path;
  final double progress;
  @override
  Widget build(BuildContext context) => AnimatedContainer(
    duration: 300.ms,
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      color: path.color,
      borderRadius: BorderRadius.circular(28),
      boxShadow: [
        BoxShadow(
          color: path.color.withValues(alpha: .23),
          blurRadius: 26,
          offset: const Offset(0, 12),
        ),
      ],
    ),
    child: Stack(
      children: [
        Positioned(
          right: -15,
          bottom: -35,
          child: Icon(
            path.icon,
            color: Colors.white.withValues(alpha: .12),
            size: 140,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(path.icon, color: Colors.white, size: 31),
            const SizedBox(height: 16),
            Text(
              path.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              path.subtitle,
              style: const TextStyle(color: Color(0xDDFFFFFF)),
            ),
            const SizedBox(height: 20),
            ProgressBar(value: progress, color: Colors.white, height: 8),
            const SizedBox(height: 8),
            Text(
              '${(progress * 100).round()} % terminé',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _LessonTile extends StatelessWidget {
  const _LessonTile({
    required this.lesson,
    required this.number,
    required this.color,
    required this.completed,
    required this.unlocked,
  });
  final Lesson lesson;
  final int number;
  final Color color;
  final bool completed;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    final locked = !unlocked;
    return Card(
      child: InkWell(
        onTap: locked ? null : () => context.push('/lesson/${lesson.id}'),
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: (locked ? Colors.grey : color).withValues(alpha: .11),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: completed
                    ? const Icon(Icons.check_rounded, color: AppColors.success)
                    : Icon(
                        locked ? Icons.lock_outline_rounded : lesson.icon,
                        color: locked ? Colors.grey : color,
                      ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: locked ? Colors.grey : null,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      lesson.subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule_rounded,
                          size: 14,
                          color: AppColors.muted,
                        ),
                        Text(
                          ' ${lesson.duration} min',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.bolt_rounded,
                          size: 15,
                          color: AppColors.accent,
                        ),
                        Text(
                          ' ${lesson.xp} XP',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (!locked) const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
