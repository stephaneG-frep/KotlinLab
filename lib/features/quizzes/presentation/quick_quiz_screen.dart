import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../profile/presentation/profile_controller.dart';
import '../data/quick_quiz_catalog.dart';

class QuickQuizScreen extends ConsumerStatefulWidget {
  const QuickQuizScreen({super.key});

  @override
  ConsumerState<QuickQuizScreen> createState() => _QuickQuizScreenState();
}

class _QuickQuizScreenState extends ConsumerState<QuickQuizScreen> {
  int questionIndex = 0;
  int score = 0;
  int? selectedIndex;
  bool checked = false;
  bool finished = false;
  int reward = 0;

  @override
  Widget build(BuildContext context) {
    if (finished) return _result(context);
    final question = quickQuizQuestions[questionIndex];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz rapide'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(5),
          child: LinearProgressIndicator(
            value: (questionIndex + 1) / quickQuizQuestions.length,
            minHeight: 5,
            backgroundColor: AppColors.primary.withValues(alpha: .12),
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 26, 20, 40),
            children: [
              Text(
                'QUESTION ${questionIndex + 1} SUR ${quickQuizQuestions.length}',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w900,
                  letterSpacing: .8,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                question.prompt,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  height: 1.2,
                ),
              ),
              if (question.code case final code?) ...[
                const SizedBox(height: 18),
                _CodeCard(code: code),
              ],
              const SizedBox(height: 22),
              ...List.generate(
                question.answers.length,
                (index) => _AnswerTile(
                  text: question.answers[index],
                  selected: index == selectedIndex,
                  correct: checked && index == question.correctIndex,
                  incorrect:
                      checked &&
                      index == selectedIndex &&
                      index != question.correctIndex,
                  onTap: checked
                      ? null
                      : () => setState(() => selectedIndex = index),
                ),
              ),
              if (checked) ...[
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(question.explanation),
                ),
              ],
              const SizedBox(height: 20),
              FilledButton(
                onPressed: selectedIndex == null ? null : _next,
                child: Text(
                  checked
                      ? questionIndex == quickQuizQuestions.length - 1
                            ? 'Voir mon résultat'
                            : 'Question suivante'
                      : 'Vérifier',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _next() {
    if (!checked) {
      setState(() {
        checked = true;
        if (selectedIndex == quickQuizQuestions[questionIndex].correctIndex) {
          score++;
        }
      });
      return;
    }
    if (questionIndex < quickQuizQuestions.length - 1) {
      setState(() {
        questionIndex++;
        selectedIndex = null;
        checked = false;
      });
      return;
    }
    reward = ref
        .read(profileControllerProvider.notifier)
        .completeQuiz(
          'quick_kotlin_basics',
          score: score,
          total: quickQuizQuestions.length,
        );
    setState(() => finished = true);
  }

  Widget _result(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Résultat')),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 112,
                height: 112,
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: .16),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.emoji_events_rounded,
                  color: Color(0xFFE09B00),
                  size: 62,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                '$score / ${quickQuizQuestions.length}',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 8),
              Text(
                score >= 4
                    ? 'Excellent travail !'
                    : 'Continue, tu progresses !',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                reward > 0
                    ? '+$reward XP ajoutés à ton profil.'
                    : 'Quiz déjà récompensé. Le résultat est ajouté à tes statistiques.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              FilledButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.check_rounded),
                label: const Text('Terminer'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(54),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _CodeCard extends StatelessWidget {
  const _CodeCard({required this.code});
  final String code;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(17),
    decoration: BoxDecoration(
      color: const Color(0xFF201E2A),
      borderRadius: BorderRadius.circular(18),
    ),
    child: Text(
      code,
      style: const TextStyle(
        color: Color(0xFFEDE9FF),
        fontFamily: 'monospace',
        height: 1.6,
      ),
    ),
  );
}

class _AnswerTile extends StatelessWidget {
  const _AnswerTile({
    required this.text,
    required this.selected,
    required this.correct,
    required this.incorrect,
    required this.onTap,
  });

  final String text;
  final bool selected;
  final bool correct;
  final bool incorrect;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = correct
        ? AppColors.success
        : incorrect
        ? AppColors.error
        : selected
        ? AppColors.primary
        : null;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color:
            color?.withValues(alpha: .1) ??
            Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(17),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(17),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  correct
                      ? Icons.check_circle_rounded
                      : incorrect
                      ? Icons.cancel_rounded
                      : selected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color: color ?? AppColors.muted,
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(text)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
