import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/kit.dart';
import '../../learning/data/learning_catalog.dart';
import '../../learning/domain/learning_models.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) => ScreenBody(
    child: CustomScrollView(
      slivers: [
        SliverAppBar.large(
          pinned: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: const Text('Construire'),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Transforme tes connaissances en vraies applications.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 22),
                _FeaturedProject(onTap: () => context.push('/project/todo')),
                const SizedBox(height: 28),
                SectionHeader(
                  title: 'Projets guidés',
                  action: '${projects.length} projets',
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
          sliver: SliverGrid.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.sizeOf(context).width >= 720 ? 2 : 1,
              mainAxisExtent: 250,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
            ),
            itemCount: projects.length,
            itemBuilder: (_, index) => _ProjectCard(
              item: projects[index],
            ).animate().fadeIn(delay: (index * 70).ms).slideY(begin: .05),
          ),
        ),
      ],
    ),
  );
}

class _FeaturedProject extends StatelessWidget {
  const _FeaturedProject({required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF004D40), Color(0xFF00A77C)],
      ),
      borderRadius: BorderRadius.circular(28),
      boxShadow: [
        BoxShadow(
          color: AppColors.success.withValues(alpha: .18),
          blurRadius: 28,
          offset: const Offset(0, 12),
        ),
      ],
    ),
    child: Stack(
      children: [
        const Positioned(
          right: -20,
          bottom: -35,
          child: Icon(
            Icons.android_rounded,
            color: Color(0x22FFFFFF),
            size: 155,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'PROJET À LA UNE',
              style: TextStyle(
                color: AppColors.accent,
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: .8,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Une Todo moderne\navec Jetpack Compose',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Navigation · Room · StateFlow',
              style: TextStyle(color: Color(0xDDFFFFFF)),
            ),
            const SizedBox(height: 20),
            FilledButton.tonalIcon(
              onPressed: onTap,
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Découvrir le projet'),
            ),
          ],
        ),
      ],
    ),
  );
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.item});
  final ProjectItem item;
  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: () => context.push('/project/${item.id}'),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: item.color.withValues(alpha: .12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(item.icon, color: item.color),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: item.color.withValues(alpha: .09),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item.level,
                    style: TextStyle(
                      color: item.color,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(item.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 6),
            Text(
              item.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Wrap(
              spacing: 6,
              children: item.tags
                  .map(
                    (tag) => Chip(
                      label: Text(tag),
                      visualDensity: VisualDensity.compact,
                      labelStyle: const TextStyle(fontSize: 10),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.schedule_rounded,
                  size: 16,
                  color: AppColors.muted,
                ),
                Text(
                  ' ${item.duration}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const Spacer(),
                const Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
