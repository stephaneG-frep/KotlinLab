import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/profile/presentation/profile_controller.dart';

class KotlinLabApp extends ConsumerWidget {
  const KotlinLabApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
