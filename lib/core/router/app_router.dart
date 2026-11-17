import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../session/session_controller.dart';
import 'route_guard.dart';
import '../../features/auth/presentation/router_login_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/dashboard/presentation/interfaces_traffic_screen.dart';
import '../../features/subscribers/presentation/subscribers_screen.dart';
import '../../features/subscribers/presentation/card_inquiry_screen.dart';
import '../../features/hotspot/presentation/hotspot_screen.dart';
import '../../features/vouchers/presentation/voucher_generator_screen.dart';
import '../../features/vouchers/presentation/print_preview_screen.dart';
import '../../features/reports/presentation/reports_screen.dart';
import '../../features/settings/presentation/more_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/userman/presentation/userman_screen.dart';
import '../../features/routers/presentation/routers_screen.dart';
import '../../features/telegram_bot/presentation/telegram_settings_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = ref.watch(sessionRefreshNotifierProvider);

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final sessionState = ref.read(sessionControllerProvider);
      final isAuthenticated = sessionState.isAuthenticated;
      final isLoggingIn = state.matchedLocation == '/login';

      // لا يُسمح بفتح أي مسار قبل تسجيل الدخول بالراوتر
      if (!isAuthenticated) {
        return isLoggingIn ? null : '/login';
      }

      // إذا تم تسجيل الدخول بنجاح وحاول فتح صفحة الدخول، يتم نقله للرئيسية
      if (isLoggingIn) {
        return '/dashboard';
      }

      return null;
    },
    routes: [
      // شاشة تسجيل الدخول خارج الـ Shell
      GoRoute(
        path: '/login',
        builder: (context, state) => const RouterLoginScreen(),
      ),

      // واجهات شريط التنقل السفلي الرئيسي (5 تبويبات)
      ShellRoute(
        builder: (context, state, child) => MainShellNavigation(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/subscribers',
            builder: (context, state) => const SubscribersScreen(),
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
          GoRoute(
            path: '/more',
            builder: (context, state) => const MoreScreen(),
          ),
        ],
      ),

      // مسارات الشاشات الفرعية والخدمات
      GoRoute(
        path: '/card-inquiry',
        builder: (context, state) => CardInquiryScreen(
          initialCardName: state.uri.queryParameters['card'],
        ),
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
        path: '/telegram',
        builder: (context, state) => const TelegramSettingsScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/routers',
        builder: (context, state) => const RoutersScreen(),
      ),
      GoRoute(
        path: '/interfaces',
        builder: (context, state) => const InterfacesTrafficScreen(),
      ),
    ],
  );
});

class MainShellNavigation extends StatelessWidget {
  final Widget child;
  const MainShellNavigation({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/dashboard')) return 0;
    if (location.startsWith('/subscribers') || location.startsWith('/hotspot')) return 1;
    if (location.startsWith('/vouchers')) return 2;
    if (location.startsWith('/reports')) return 3;
    if (location.startsWith('/more')) return 4;
    return 0;
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
              context.go('/dashboard');
              break;
            case 1:
              context.go('/subscribers');
              break;
            case 2:
              context.go('/vouchers');
              break;
            case 3:
              context.go('/reports');
              break;
            case 4:
              context.go('/more');
              break;
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'الرئيسية',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'المشتركون',
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
          NavigationDestination(
            icon: Icon(Icons.menu),
            selectedIcon: Icon(Icons.menu_open),
            label: 'المزيد',
          ),
        ],
      ),
    );
  }
}
