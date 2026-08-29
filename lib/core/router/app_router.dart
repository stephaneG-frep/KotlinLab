import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/exercises/presentation/exercises_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/learning/data/learning_catalog.dart';
import '../../features/learning/presentation/learning_screen.dart';
import '../../features/learning/presentation/lesson_screen.dart';
import '../../features/learning/presentation/learning_tools_screen.dart';
import '../../features/learning/presentation/search_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/projects/presentation/project_detail_screen.dart';
import '../../features/projects/presentation/projects_screen.dart';
import '../../features/quizzes/presentation/quick_quiz_screen.dart';
import '../../shared/presentation/app_shell.dart';
import '../../shared/presentation/splash_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (_, _) => const SplashScreen()),
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => AppShell(shell: shell),
      branches: [
        StatefulShellBranch(
          routes: [GoRoute(path: '/', builder: (_, _) => const HomeScreen())],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/learning',
              builder: (_, _) => const LearningScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/exercises',
              builder: (_, _) => const ExercisesScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/projects',
              builder: (_, _) => const ProjectsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/profile', builder: (_, _) => const ProfileScreen()),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/lesson/:id',
      pageBuilder: (context, state) {
        final id = state.pathParameters['id'];
        final lesson = learningPaths
            .expand((path) => path.lessons)
            .firstWhere((item) => item.id == id);
        return MaterialPage(child: LessonScreen(lesson: lesson));
      },
    ),
    GoRoute(path: '/playground', builder: (_, _) => const PlaygroundScreen()),
    GoRoute(path: '/glossary', builder: (_, _) => const GlossaryScreen()),
    GoRoute(path: '/compare', builder: (_, _) => const CompareScreen()),
    GoRoute(path: '/search', builder: (_, _) => const SearchScreen()),
    GoRoute(path: '/quiz/quick', builder: (_, _) => const QuickQuizScreen()),
    GoRoute(
      path: '/project/:id',
      builder: (_, state) {
        final project = projects.firstWhere(
          (item) => item.id == state.pathParameters['id'],
        );
        return ProjectDetailScreen(project: project);
      },
    ),
  ],
);
