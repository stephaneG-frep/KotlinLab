import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/profile/presentation/profile_controller.dart';

class KotlinLabApp extends ConsumerStatefulWidget {
  const KotlinLabApp({super.key});

  @override
  ConsumerState<KotlinLabApp> createState() => _KotlinLabAppState();
}

class _KotlinLabAppState extends ConsumerState<KotlinLabApp> {
  // La série et l'objectif du jour dépendent de la date : on les recalcule
  // quand l'application revient au premier plan (passage de minuit).
  late final _lifecycle = AppLifecycleListener(
    onResume: () => ref.read(profileControllerProvider.notifier).refreshDay(),
  );

  @override
  void initState() {
    super.initState();
    _lifecycle;
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(profileControllerProvider);
    return MaterialApp.router(
      title: 'KotlinLab',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(settings.textScale),
      darkTheme: AppTheme.dark(settings.textScale),
      themeMode: settings.themeMode,
      routerConfig: appRouter,
    );
  }
}
