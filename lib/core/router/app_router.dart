import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/routers/presentation/routers_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/hotspot/presentation/hotspot_screen.dart';
import '../../features/userman/presentation/userman_screen.dart';
import '../../features/vouchers/presentation/voucher_generator_screen.dart';
import '../../features/vouchers/presentation/print_preview_screen.dart';
import '../../features/reports/presentation/reports_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/dashboard',
    routes: [
      ShellRoute(
        builder: (context, state, child) => MainShellNavigation(child: child),
        routes: [
          GoRoute(
            path: '/routers',
            builder: (context, state) => const RoutersScreen(),
          ),
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/hotspot',
            builder: (context, state) => const HotspotScreen(),
          ),
          GoRoute(
            path: '/vouchers',
            builder: (context, state) => const VoucherGeneratorScreen(),
          ),
          GoRoute(
            path: '/reports',
            builder: (context, state) => const ReportsScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/userman',
        builder: (context, state) => const UsermanScreen(),
      ),
      GoRoute(
        path: '/print-preview',
        builder: (context, state) => const PrintPreviewScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
});

class MainShellNavigation extends StatelessWidget {
  final Widget child;
  const MainShellNavigation({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/routers')) return 0;
    if (location.startsWith('/dashboard')) return 1;
    if (location.startsWith('/hotspot')) return 2;
    if (location.startsWith('/vouchers')) return 3;
    if (location.startsWith('/reports')) return 4;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (idx) {
          switch (idx) {
            case 0:
              context.go('/routers');
              break;
            case 1:
              context.go('/dashboard');
              break;
            case 2:
              context.go('/hotspot');
              break;
            case 3:
              context.go('/vouchers');
              break;
            case 4:
              context.go('/reports');
              break;
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.router_outlined),
            selectedIcon: Icon(Icons.router),
            label: 'الراوترات',
          ),
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'الرئيسية',
          ),
          NavigationDestination(
            icon: Icon(Icons.wifi_outlined),
            selectedIcon: Icon(Icons.wifi),
            label: 'الهوتس بوت',
          ),
          NavigationDestination(
            icon: Icon(Icons.confirmation_number_outlined),
            selectedIcon: Icon(Icons.confirmation_number),
            label: 'الكروت',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'التقارير',
          ),
        ],
      ),
    );
  }
}
