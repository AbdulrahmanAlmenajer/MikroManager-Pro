import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MikroManager Pro'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // System Resources Row
            Row(
              children: [
                Expanded(child: _buildResourceCard('CPU', '45%', Icons.memory, AppColors.cyanAccent)),
                const SizedBox(width: 12),
                Expanded(child: _buildResourceCard('RAM', '62%', Icons.storage, AppColors.warning)),
                const SizedBox(width: 12),
                Expanded(child: _buildResourceCard('Uptime', '5d 3h', Icons.timer_outlined, AppColors.success)),
              ],
            ),
            const SizedBox(height: 16),
            // Connected Users Card
            _buildInfoCard('المتصلون حالياً', '23 مستخدم', Icons.people, AppColors.navyPrimary),
            const SizedBox(height: 16),
            // Traffic placeholder
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('ترافيك الشبكة اللحظي', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text('سيتم عرض الرسم البياني هنا - المرحلة الخامسة', style: TextStyle(color: AppColors.textSecondary)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: color)),
            Text(title, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color, child: Icon(icon, color: Colors.white)),
        title: Text(title, style: const TextStyle(color: AppColors.textSecondary)),
        trailing: Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: color)),
      ),
    );
  }
}
