import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../profile/presentation/profile_controller.dart';
import '../data/learning_catalog.dart';
import '../domain/learning_models.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  String query = '';

  List<Lesson> get results {
    final lessons = learningPaths.expand((path) => path.lessons);
    if (query.trim().isEmpty) return lessons.take(6).toList();
    final normalized = query.toLowerCase().trim();
    return lessons.where((lesson) {
      return lesson.title.toLowerCase().contains(normalized) ||
          lesson.subtitle.toLowerCase().contains(normalized);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final favorites = ref.watch(profileControllerProvider).favoriteLessonIds;
    return Scaffold(
      appBar: AppBar(title: const Text('Rechercher')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
            children: [
              TextField(
                autofocus: true,
                onChanged: (value) => setState(() => query = value),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search_rounded),
                  hintText: 'Cours, fonction, mot-clé…',
                ),
              ),
              const SizedBox(height: 22),
              Text(
                query.isEmpty ? 'Suggestions' : '${results.length} résultat(s)',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              if (results.isEmpty)
                const _EmptySearch()
              else
                ...results.map(
                  (lesson) => Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      onTap: () => context.push('/lesson/${lesson.id}'),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: .1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(lesson.icon, color: AppColors.primary),
                      ),
                      title: Text(
                        lesson.title,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      subtitle: Text(
                        '${lesson.subtitle} · ${lesson.duration} min',
                      ),
                      trailing: Icon(
                        favorites.contains(lesson.id)
                            ? Icons.bookmark_rounded
                            : Icons.chevron_right_rounded,
                        color: favorites.contains(lesson.id)
                            ? AppColors.primary
                            : null,
                      ),
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

class _EmptySearch extends StatelessWidget {
  const _EmptySearch();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 70),
    child: Column(
      children: [
        Icon(
          Icons.search_off_rounded,
          size: 64,
          color: AppColors.primary.withValues(alpha: .45),
        ),
        const SizedBox(height: 16),
        Text('Aucun résultat', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 5),
        const Text('Essaie un autre concept Kotlin.'),
      ],
    ),
  );
}
