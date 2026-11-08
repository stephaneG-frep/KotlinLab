import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/kit.dart';
import '../../profile/presentation/profile_controller.dart';
import '../data/output_challenges.dart';
import '../domain/output_challenge.dart';

/// Liste des extraits dont il faut deviner la sortie.
class PlaygroundScreen extends ConsumerWidget {
  const PlaygroundScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final done = ref.watch(profileControllerProvider).completedExerciseIds;
    final solved = outputChallenges
        .where((challenge) => done.contains(challenge.progressId))
        .length;
    return Scaffold(
      appBar: AppBar(title: const Text('Devine la sortie')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
            children: [
              Text(
                'Lis le programme, écris ce qu’il affiche, puis vérifie. '
                'Lire du code avant de l’exécuter est le meilleur moyen '
                'de comprendre Kotlin.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ProgressBar(value: solved / outputChallenges.length),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '$solved / ${outputChallenges.length}',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              for (final challenge in outputChallenges)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _ChallengeTile(
                    challenge: challenge,
                    solved: done.contains(challenge.progressId),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChallengeTile extends StatelessWidget {
  const _ChallengeTile({required this.challenge, required this.solved});
  final OutputChallenge challenge;
  final bool solved;

  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: CircleAvatar(
        backgroundColor: (solved ? AppColors.success : AppColors.primary)
            .withValues(alpha: .12),
        child: Icon(
          solved ? Icons.check_rounded : Icons.terminal_rounded,
          color: solved ? AppColors.success : AppColors.primary,
        ),
      ),
      title: Text(
        challenge.title,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      subtitle: Text('${challenge.level} · ${challenge.xp} XP'),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: () => context.push('/playground/${challenge.id}'),
    ),
  );
}

/// Un extrait : prédiction, vérification et explication.
class OutputChallengeScreen extends ConsumerStatefulWidget {
  const OutputChallengeScreen({super.key, required this.challenge});
  final OutputChallenge challenge;

  @override
  ConsumerState<OutputChallengeScreen> createState() =>
      _OutputChallengeScreenState();
}

class _OutputChallengeScreenState extends ConsumerState<OutputChallengeScreen> {
  final _controller = TextEditingController();

  /// null : pas encore vérifié.
  bool? _correct;
  bool _revealed = false;

  OutputChallenge get challenge => widget.challenge;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _check() {
    final correct = challenge.matches(_controller.text);
    final rewarded = ref
        .read(profileControllerProvider.notifier)
        .submitExercise(challenge.progressId, challenge.xp, correct: correct);
    setState(() {
      _correct = correct;
      if (correct) _revealed = true;
    });
    if (rewarded) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bien vu ! +${challenge.xp} XP'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _openNext(OutputChallenge next) =>
      context.pushReplacement('/playground/${next.id}');

  @override
  Widget build(BuildContext context) {
    final index = outputChallenges.indexOf(challenge);
    final next = index >= 0 && index < outputChallenges.length - 1
        ? outputChallenges[index + 1]
        : null;
    return Scaffold(
      appBar: AppBar(title: Text(challenge.title)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
            children: [
              Text(
                'Qu’affiche ce programme ?',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              _Code(text: challenge.code),
              const SizedBox(height: 16),
              TextField(
                controller: _controller,
                minLines: 2,
                maxLines: 8,
                enabled: !_revealed,
                autocorrect: false,
                enableSuggestions: false,
                textCapitalization: TextCapitalization.none,
                style: const TextStyle(fontFamily: 'monospace'),
                decoration: const InputDecoration(
                  labelText: 'Ta prédiction',
                  hintText: 'Une ligne par println',
                  alignLabelWithHint: true,
                ),
                onChanged: (_) => setState(() => _correct = null),
              ),
              const SizedBox(height: 12),
              if (_correct == false && !_revealed)
                const _Feedback(
                  correct: false,
                  text:
                      'Pas tout à fait. Relis le code ligne par ligne et réessaie.',
                ),
              if (!_revealed) ...[
                FilledButton.icon(
                  onPressed: _controller.text.trim().isEmpty ? null : _check,
                  icon: const Icon(Icons.check_rounded),
                  label: const Text('Vérifier'),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => setState(() => _revealed = true),
                  child: const Text('Voir la réponse'),
                ),
              ] else ...[
                _Feedback(
                  correct: _correct == true,
                  text: _correct == true
                      ? 'Exact !'
                      : 'Voici la sortie attendue.',
                ),
                const SizedBox(height: 12),
                _Code(text: challenge.output, label: 'SORTIE'),
                const SizedBox(height: 12),
                Text(
                  challenge.explanation,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(height: 1.55),
                ),
                const SizedBox(height: 20),
                if (next != null)
                  FilledButton.icon(
                    onPressed: () => _openNext(next),
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: const Text('Extrait suivant'),
                  )
                else
                  FilledButton(
                    onPressed: () => context.pop(),
                    child: const Text('Terminer'),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Code extends StatelessWidget {
  const _Code({required this.text, this.label});
  final String text;
  final String? label;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFF1D1B25),
      borderRadius: BorderRadius.circular(18),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: const TextStyle(
              color: AppColors.secondary,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: .8,
            ),
          ),
          const SizedBox(height: 8),
        ],
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SelectableText(
            text,
            style: const TextStyle(
              color: Color(0xFFEAE5FF),
              fontFamily: 'monospace',
              height: 1.5,
            ),
          ),
        ),
      ],
    ),
  );
}

class _Feedback extends StatelessWidget {
  const _Feedback({required this.correct, required this.text});
  final bool correct;
  final String text;

  @override
  Widget build(BuildContext context) {
    final color = correct ? AppColors.success : AppColors.error;
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            correct ? Icons.check_circle_rounded : Icons.error_outline_rounded,
            color: color,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
