import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.shell});
  final StatefulNavigationShell shell;

  static const destinations = [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home_rounded),
      label: 'Accueil',
    ),
    NavigationDestination(
      icon: Icon(Icons.route_outlined),
      selectedIcon: Icon(Icons.route_rounded),
      label: 'Parcours',
    ),
    NavigationDestination(
      icon: Icon(Icons.psychology_alt_outlined),
      selectedIcon: Icon(Icons.psychology_alt_rounded),
      label: 'Exercices',
    ),
    NavigationDestination(
      icon: Icon(Icons.rocket_launch_outlined),
      selectedIcon: Icon(Icons.rocket_launch_rounded),
      label: 'Projets',
    ),
    NavigationDestination(
      icon: Icon(Icons.person_outline_rounded),
      selectedIcon: Icon(Icons.person_rounded),
      label: 'Profil',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 850;
    if (wide) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: MediaQuery.sizeOf(context).width >= 1050,
                selectedIndex: shell.currentIndex,
                onDestinationSelected: _go,
                leading: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  child: _Brand(compact: true),
                ),
                destinations: destinations
                    .map(
                      (item) => NavigationRailDestination(
                        icon: item.icon,
                        selectedIcon: item.selectedIcon,
                        label: Text(item.label),
                      ),
                    )
                    .toList(),
              ),
            ),
            const VerticalDivider(width: 1),
            Expanded(child: shell),
          ],
        ),
      );
    }
    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: _go,
        destinations: destinations,
      ),
    );
  }

  void _go(int index) =>
      shell.goBranch(index, initialLocation: index == shell.currentIndex);
}

class _Brand extends StatelessWidget {
  const _Brand({required this.compact});
  final bool compact;
  @override
  Widget build(BuildContext context) => Container(
    width: 44,
    height: 44,
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF7F52FF), Color(0xFF4CC2FF)],
      ),
      borderRadius: BorderRadius.circular(14),
    ),
    child: const Center(
      child: Text(
        'K',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: 23,
        ),
      ),
    ),
  );
}
