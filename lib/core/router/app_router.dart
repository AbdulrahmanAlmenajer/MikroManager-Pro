import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../database/app_database.dart';
import '../constants/app_colors.dart';
import '../session/session_controller.dart';
import 'route_guard.dart';
import '../../features/auth/presentation/router_login_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/dashboard/presentation/interfaces_traffic_screen.dart';
import '../../features/subscribers/presentation/subscribers_screen.dart';
import '../../features/subscribers/presentation/card_inquiry_screen.dart';
import '../../features/vouchers/presentation/template_gallery_screen.dart';
import '../../features/vouchers/presentation/template_editor_screen.dart';
import '../../features/vouchers/presentation/pdf_archive_screen.dart';
import '../../features/hotspot/presentation/hotspot_screen.dart';
import '../../features/vouchers/presentation/voucher_generator_screen.dart';
import '../../features/cards_hub/presentation/cards_hub_screen.dart';
import '../../features/vouchers/presentation/print_preview_screen.dart';
import '../../features/reports/presentation/reports_screen.dart';
import '../../features/settings/presentation/more_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/userman/presentation/userman_screen.dart';
import '../../features/userman/presentation/um_diagnostic_screen.dart';
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
            builder: (context, state) => const CardsHubScreen(),
          ),
          GoRoute(
            path: '/reports',
            builder: (context, state) => const ReportsScreen(),
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
            path: '/more',
            builder: (context, state) => const MoreScreen(),
          ),
        ],
      ),

      // مسارات الشاشات الفرعية والخدمات
      GoRoute(
        path: '/vouchers/generate',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final isUm = (extra?['isUserManager'] as bool?) ??
              (state.uri.queryParameters['isUserManager'] == 'true');
          final profile = (extra?['profile'] as String?) ??
              state.uri.queryParameters['profile'];
          return VoucherGeneratorScreen(
            initialIsUserManager: isUm,
            initialProfile: profile,
          );
        },
      ),
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
        path: '/userman/print',
        builder: (context, state) {
          final profile = state.uri.queryParameters['profile'];
          return VoucherGeneratorScreen(
            initialIsUserManager: true,
            initialProfile: profile,
          );
        },
      ),
      GoRoute(
        path: '/um-diagnostic',
        builder: (context, state) => const UmDiagnosticScreen(),
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
        path: '/routers',
        builder: (context, state) => const RoutersScreen(),
      ),
      GoRoute(
        path: '/interfaces',
        builder: (context, state) => const InterfacesTrafficScreen(),
      ),
      GoRoute(
        path: '/templates',
        builder: (context, state) => const TemplateGalleryScreen(),
      ),
      GoRoute(
        path: '/template-editor',
        builder: (context, state) {
          final template = state.extra as VoucherTemplatesTableData?;
          return TemplateEditorScreen(template: template);
        },
      ),
      GoRoute(
        path: '/pdf-archive',
        builder: (context, state) => const PdfArchiveScreen(),
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
    if (location.startsWith('/reports')) return 1;
    if (location.startsWith('/settings')) return 2;
    if (location.startsWith('/routers')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      body: child,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.addGreen,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        elevation: 4,
        onPressed: () => context.push('/vouchers/generate'),
        tooltip: 'تصميم وتوليد الكروت',
        child: const Icon(Icons.add_rounded, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        color: Colors.white,
        elevation: 8,
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              context,
              0,
              Icons.home_rounded,
              Icons.home_outlined,
              'الرئيسية',
              '/dashboard',
              selectedIndex == 0,
            ),
            _buildNavItem(
              context,
              1,
              Icons.analytics_rounded,
              Icons.analytics_outlined,
              'التقارير',
              '/reports',
              selectedIndex == 1,
            ),
            const SizedBox(width: 44), // Space for centered FloatingActionButton
            _buildNavItem(
              context,
              2,
              Icons.settings_rounded,
              Icons.settings_outlined,
              'الإعدادات',
              '/settings',
              selectedIndex == 2,
            ),
            _buildNavItem(
              context,
              3,
              Icons.router_rounded,
              Icons.router_outlined,
              'الراوترات',
              '/routers',
              selectedIndex == 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    int index,
    IconData activeIcon,
    IconData inactiveIcon,
    String label,
    String route,
    bool isSelected,
  ) {
    final color = isSelected ? AppColors.primary : AppColors.textSecondary;
    return InkWell(
      onTap: () => context.go(route),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isSelected ? activeIcon : inactiveIcon, color: color, size: 22),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
