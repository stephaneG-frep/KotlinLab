import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../profile/presentation/profile_controller.dart';
import '../domain/learning_models.dart';

class LessonScreen extends ConsumerStatefulWidget {
  const LessonScreen({super.key, required this.lesson});
  final Lesson lesson;

  @override
  ConsumerState<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends ConsumerState<LessonScreen> {
  double progress = .35;

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileControllerProvider);
    final isFavorite = profile.favoriteLessonIds.contains(widget.lesson.id);
    final isCompleted = profile.completedLessonIds.contains(widget.lesson.id);
    final body = widget.lesson.content;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson.title),
        actions: [
          IconButton(
            onPressed: () => ref
                .read(profileControllerProvider.notifier)
                .toggleFavorite(widget.lesson.id),
            icon: Icon(
              isFavorite
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_border_rounded,
            ),
            tooltip: isFavorite ? 'Retirer des favoris' : 'Ajouter aux favoris',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 4,
            backgroundColor: AppColors.primary.withValues(alpha: .12),
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
            children: [
              Row(
                children: [
                  _Meta(
                    icon: Icons.signal_cellular_alt_rounded,
                    text: widget.lesson.level,
                  ),
                  const SizedBox(width: 8),
                  _Meta(
                    icon: Icons.schedule_rounded,
                    text: '${widget.lesson.duration} min',
                  ),
                  const SizedBox(width: 8),
                  _Meta(
                    icon: Icons.bolt_rounded,
                    text: '${widget.lesson.xp} XP',
                  ),
                ],
              ),
              const SizedBox(height: 18),
              MarkdownBody(
                data: body,
                selectable: true,
                styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                    .copyWith(
                      h1: Theme.of(context).textTheme.headlineMedium,
                      h2: Theme.of(context).textTheme.titleLarge,
                      p: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(height: 1.65),
                      code: const TextStyle(
                        fontFamily: 'monospace',
                        color: AppColors.primary,
                        fontSize: 14,
                      ),
                      codeblockDecoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF24232A)
                            : const Color(0xFFF0EEFA),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      blockquoteDecoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: .12),
                        border: const Border(
                          left: BorderSide(color: AppColors.accent, width: 4),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
              ),
              const SizedBox(height: 28),
              FilledButton.icon(
                onPressed: isCompleted
                    ? null
                    : () {
                        final rewarded = ref
                            .read(profileControllerProvider.notifier)
                            .completeLesson(widget.lesson.id, widget.lesson.xp);
                        setState(() => progress = 1);
                        if (rewarded) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Bravo ! +${widget.lesson.xp} XP'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                icon: Icon(
                  isCompleted
                      ? Icons.check_rounded
                      : Icons.check_circle_outline_rounded,
                ),
                label: Text(
                  isCompleted ? 'Leçon terminée' : 'Terminer la leçon',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.text});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
    decoration: BoxDecoration(
      color: AppColors.primary.withValues(alpha: .08),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 15),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
      ],
    ),
  );
}
