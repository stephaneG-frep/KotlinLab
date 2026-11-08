import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class GlossaryScreen extends StatefulWidget {
  const GlossaryScreen({super.key});
  @override
  State<GlossaryScreen> createState() => _GlossaryScreenState();
}

class _GlossaryScreenState extends State<GlossaryScreen> {
  String query = '';
  static const entries = [
    (
      'Coroutine',
      'Calcul suspendable et léger qui permet d’écrire du code asynchrone de façon séquentielle.',
      'launch { repository.refresh() }',
    ),
    (
      'Data class',
      'Classe conçue pour porter des données, avec equals, hashCode, toString et copy générés.',
      'data class User(val name: String)',
    ),
    (
      'Extension',
      'Fonction qui ajoute une API à un type existant sans héritage.',
      'fun String.initial() = first()',
    ),
    (
      'Flow',
      'Flux asynchrone qui émet plusieurs valeurs au fil du temps.',
      'flow { emit(loadData()) }',
    ),
    (
      'Null safety',
      'Système de types qui distingue les références nullables des références non nullables.',
      'val name: String? = null',
    ),
    (
      'Smart cast',
      'Conversion automatique après que Kotlin a prouvé le type d’une valeur.',
      'if (x is String) x.length',
    ),
    (
      'when',
      'Expression de branchement exhaustive et expressive.',
      'when (status) { Ready -> start() }',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final visible = entries
        .where((item) => item.$1.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Glossaire Kotlin')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              TextField(
                onChanged: (value) => setState(() => query = value),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search_rounded),
                  hintText: 'Rechercher un concept…',
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '${visible.length} définitions',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              ...visible.map(
                (item) => Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ExpansionTile(
                    shape: const Border(),
                    title: Text(
                      item.$1,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    subtitle: Text(
                      item.$2,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: .08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          item.$3,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CompareScreen extends StatelessWidget {
  const CompareScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Kotlin vs Java')),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Même intention. Beaucoup moins de bruit.',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            const Text(
              'Compare les idiomes des deux langages et comprends chaque simplification.',
            ),
            const SizedBox(height: 22),
            const _CodeCompare(
              title: 'Modèle de données',
              java: '''public final class User {
  private final String name;
  public User(String name) {
    this.name = name;
  }
  public String getName() {
    return name;
  }
}''',
              kotlin: 'data class User(\n  val name: String\n)',
            ),
            const SizedBox(height: 16),
            const _CodeCompare(
              title: 'Valeur nullable',
              java:
                  'String name = null;\nif (name != null) {\n  int size = name.length();\n}',
              kotlin: 'val name: String? = null\nval size = name?.length',
            ),
          ],
        ),
      ),
    ),
  );
}

class _CodeCompare extends StatelessWidget {
  const _CodeCompare({
    required this.title,
    required this.java,
    required this.kotlin,
  });
  final String title;
  final String java;
  final String kotlin;
  @override
  Widget build(BuildContext context) {
    final horizontal = MediaQuery.sizeOf(context).width > 650;
    final blocks = [
      Expanded(
        child: _CodeBlock(
          label: 'JAVA',
          code: java,
          color: const Color(0xFFFF8A65),
        ),
      ),
      if (horizontal) const SizedBox(width: 10) else const SizedBox(height: 10),
      Expanded(
        child: _CodeBlock(
          label: 'KOTLIN',
          code: kotlin,
          color: AppColors.primary,
        ),
      ),
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 14),
            SizedBox(
              height: horizontal ? 230 : 430,
              child: horizontal
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: blocks,
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: blocks,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CodeBlock extends StatelessWidget {
  const _CodeBlock({
    required this.label,
    required this.code,
    required this.color,
  });
  final String label;
  final String code;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0xFF201E2A),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: .8,
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: SingleChildScrollView(
            child: Text(
              code,
              style: const TextStyle(
                color: Color(0xFFEAE5FF),
                fontFamily: 'monospace',
                height: 1.5,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
