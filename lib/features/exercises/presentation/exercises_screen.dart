import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/kit.dart';
import '../../learning/data/learning_catalog.dart';
import '../../learning/domain/learning_models.dart';

class ExercisesScreen extends StatefulWidget {
  const ExercisesScreen({super.key});
  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  String filter = 'Tous';
  static const filters = ['Tous', 'Facile', 'Moyen', 'Difficile'];

  @override
  Widget build(BuildContext context) {
    final visible = filter == 'Tous'
        ? exercises
        : exercises.where((item) => item.difficulty == filter).toList();
    return ScreenBody(
      child: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            pinned: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: const Text('S’entraîner'),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 18),
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: .17),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.bolt_rounded,
                      color: Color(0xFFE09B00),
                      size: 18,
                    ),
                    Text(
                      ' 1 240 XP',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _QuizHero(),
                  const SizedBox(height: 26),
                  const SectionHeader(
                    title: 'Exercices par format',
                    action: '500+ activités',
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 42,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: filters.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (_, i) => ChoiceChip(
                        label: Text(filters[i]),
                        selected: filter == filters[i],
                        onSelected: (_) => setState(() => filter = filters[i]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
            sliver: SliverGrid.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.sizeOf(context).width >= 700 ? 2 : 1,
                mainAxisExtent: 118,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: visible.length,
              itemBuilder: (_, i) => _ExerciseCard(
                item: visible[i],
                onTap: () => _showExercise(context, visible[i]),
              ).animate().fadeIn(delay: (i * 60).ms),
            ),
          ),
        ],
      ),
    );
  }

  void _showExercise(BuildContext context, ExerciseItem item) =>
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (_) => _ExerciseSheet(item: item),
      );
}

class _QuizHero extends StatelessWidget {
  const _QuizHero();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF19172E), Color(0xFF40318D)],
      ),
      borderRadius: BorderRadius.circular(28),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'QUIZ RAPIDE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                '5 questions.\nPrêt à te tester ?',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.tonal(
                onPressed: () {},
                child: const Text('Commencer'),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 94,
          height: 94,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.psychology_alt_rounded,
            color: AppColors.secondary,
            size: 58,
          ),
        ),
      ],
    ),
  );
}

class _ExerciseCard extends StatelessWidget {
  const _ExerciseCard({required this.item, required this.onTap});
  final ExerciseItem item;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Card(
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: item.color.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(17),
              ),
              child: Icon(item.icon, color: item.color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.category} · ${item.difficulty}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.bolt_rounded, color: AppColors.accent),
                Text(
                  '+${item.xp}',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class _ExerciseSheet extends StatefulWidget {
  const _ExerciseSheet({required this.item});
  final ExerciseItem item;
  @override
  State<_ExerciseSheet> createState() => _ExerciseSheetState();
}

class _ExerciseSheetState extends State<_ExerciseSheet> {
  int? selected;
  bool checked = false;
  static const choices = [
    'Bonjour Kotlin',
    'Hello Kotlin',
    'Kotlin Hello',
    'Erreur de compilation',
  ];

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.item.title,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          const Text('Quelle sortie produit ce programme ?'),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF201E2A),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Text(
              r'''val name = "Kotlin"
println("Hello $name")''',
              style: TextStyle(
                color: Color(0xFFEDE9FF),
                fontFamily: 'monospace',
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 14),
          ...List.generate(
            choices.length,
            (i) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Material(
                color: checked && i == 1
                    ? AppColors.success.withValues(alpha: .13)
                    : (selected == i
                          ? AppColors.primary.withValues(alpha: .12)
                          : Theme.of(context).colorScheme.surface),
                borderRadius: BorderRadius.circular(15),
                child: InkWell(
                  onTap: checked ? null : () => setState(() => selected = i),
                  borderRadius: BorderRadius.circular(15),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 15,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          selected == i
                              ? Icons.radio_button_checked_rounded
                              : Icons.radio_button_unchecked_rounded,
                          color: selected == i
                              ? AppColors.primary
                              : AppColors.muted,
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Text(choices[i])),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (checked)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: (selected == 1 ? AppColors.success : AppColors.error)
                    .withValues(alpha: .1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                selected == 1
                    ? 'Excellent ! L’interpolation insère la valeur de name dans la chaîne.'
                    : r'Pas tout à fait. Avec $name, Kotlin insère directement la valeur « Kotlin ».',
              ),
            ),
          const SizedBox(height: 14),
          FilledButton(
            onPressed: selected == null
                ? null
                : () => setState(() => checked = true),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(54),
            ),
            child: Text(checked ? 'Continuer' : 'Vérifier'),
          ),
        ],
      ),
    ),
  );
}
