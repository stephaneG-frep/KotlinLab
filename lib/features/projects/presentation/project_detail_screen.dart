import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../learning/domain/learning_models.dart';
import '../../profile/presentation/profile_controller.dart';

class ProjectDetailScreen extends ConsumerWidget {
  const ProjectDetailScreen({super.key, required this.project});

  final ProjectItem project;

  static const steps = [
    (
      'Comprendre le besoin',
      'Définis les entrées, les sorties et les règles métier.',
    ),
    ('Modéliser les données', 'Crée les types Kotlin nécessaires au domaine.'),
    ('Coder le cœur', 'Implémente les fonctions une étape après l’autre.'),
    (
      'Tester les cas limites',
      'Vérifie les erreurs, valeurs vides et scénarios extrêmes.',
    ),
    ('Finaliser', 'Nettoie le code et compare-le aux bonnes pratiques.'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final started = ref
        .watch(profileControllerProvider)
        .startedProjectIds
        .contains(project.id);
    return Scaffold(
      appBar: AppBar(title: Text(project.title)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 780),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 110),
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: project.color,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -12,
                      bottom: -25,
                      child: Icon(
                        project.icon,
                        size: 135,
                        color: Colors.white.withValues(alpha: .13),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(project.icon, color: Colors.white, size: 36),
                        const SizedBox(height: 18),
                        Text(
                          project.title,
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          project.description,
                          style: const TextStyle(
                            color: Color(0xEAFFFFFF),
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _Meta(
                              text: project.level,
                              icon: Icons.signal_cellular_alt_rounded,
                            ),
                            _Meta(
                              text: project.duration,
                              icon: Icons.schedule_rounded,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              Text(
                'Compétences travaillées',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: project.tags
                    .map((tag) => Chip(label: Text(tag)))
                    .toList(),
              ),
              const SizedBox(height: 26),
              Text(
                'Plan de réalisation',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              ...steps.asMap().entries.map(
                (entry) => Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 9,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: project.color.withValues(alpha: .12),
                      foregroundColor: project.color,
                      child: Text('${entry.key + 1}'),
                    ),
                    title: Text(
                      entry.value.$1,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    subtitle: Text(entry.value.$2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: started
                    ? null
                    : () {
                        ref
                            .read(profileControllerProvider.notifier)
                            .startProject(project.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Projet ajouté à ton parcours.'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                icon: Icon(
                  started ? Icons.check_rounded : Icons.rocket_launch_rounded,
                ),
                label: Text(
                  started ? 'Projet commencé' : 'Commencer ce projet',
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
  const _Meta({required this.text, required this.icon});
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: .17),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.white),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}
