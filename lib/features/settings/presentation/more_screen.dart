import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/session/session_controller.dart';
import '../../../core/session/router_session.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionControllerProvider).session;
    final role = session?.role ?? UserRole.admin;

    return Scaffold(
      appBar: AppBar(
        title: const Text('المزيد من الخدمات'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // User & Router Info Card
            if (session != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: AppColors.cyanAccent.withValues(alpha: 0.15),
                        child: const Icon(Icons.person, color: AppColors.cyanAccent, size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              session.username,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${session.boardName} (${session.host})',
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.navyPrimary.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                role.displayNameArabic,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.navyPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),

            // Navigation Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: [
                // User Manager (Admin & Engineer only)
                if (role.canAccessUserman)
                  _buildMenuItem(
                    context,
                    title: 'مدير المستخدمين',
                    subtitle: 'User Manager v6/v7',
                    icon: Icons.manage_accounts_outlined,
                    color: Colors.blueAccent,
                    onTap: () => context.push('/userman'),
                  ),

                // Telegram Bot Alerts (Admin only)
                if (role.canAccessTelegram)
                  _buildMenuItem(
                    context,
                    title: 'بوت تيليجرام',
                    subtitle: 'تنبيهات السقوط والـ CPU',
                    icon: Icons.send_rounded,
                    color: const Color(0xFF0284C7),
                    onTap: () => context.push('/telegram'),
                  ),

                // Saved Routers
                _buildMenuItem(
                  context,
                  title: 'إدارة الراوترات',
                  subtitle: 'التبديل وإضافة أجهزة',
                  icon: Icons.router_outlined,
                  color: Colors.indigo,
                  onTap: () => context.push('/routers'),
                ),

                // Access Points (AP Management)
                _buildMenuItem(
                  context,
                  title: 'نقاط البث (APs)',
                  subtitle: 'إدارة واكتشاف الأكسسات',
                  icon: Icons.cell_tower,
                  color: Colors.deepPurple,
                  onTap: () => context.push('/access-points'),
                ),

                // Settings
                _buildMenuItem(
                  context,
                  title: 'الإعدادات العامة',
                  subtitle: 'الطابعات والقوالب',
                  icon: Icons.settings_outlined,
                  color: Colors.teal,
                  onTap: () => context.push('/settings'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.danger.withValues(alpha: 0.1),
                  foregroundColor: AppColors.danger,
                  elevation: 0,
                  side: const BorderSide(color: AppColors.danger, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => _confirmLogout(context, ref),
                icon: const Icon(Icons.power_settings_new),
                label: const Text(
                  'قطع الاتصال وتسجيل الخروج من الراوتر',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: color.withValues(alpha: 0.15),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد تسجيل الخروج'),
        content: const Text('هل أنت متأكد من قطع الاتصال بالراوتر وتسجيل الخروج؟ ستتم إعادتك لشاشة تسجيل الدخول.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(sessionControllerProvider.notifier).logout();
            },
            child: const Text('قطع الاتصال', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
