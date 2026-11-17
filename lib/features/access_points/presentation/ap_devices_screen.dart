import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/database/app_database.dart';
import '../../../core/session/session_controller.dart';
import '../domain/ap_notifier.dart';

class ApDevicesScreen extends ConsumerWidget {
  const ApDevicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(apNotifierProvider);
    final session = ref.watch(sessionControllerProvider).session;
    final connectionId = session?.connectionId ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة نقاط البث (Access Points)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.wifi_find_outlined),
            tooltip: 'اكتشاف الجيران (MNDP / CDP)',
            onPressed: session == null
                ? null
                : () async {
                    await ref.read(apNotifierProvider.notifier).discoverNeighbors(session.adapter);
                    if (context.mounted) {
                      _showDiscoveredBottomSheet(context, ref, connectionId);
                    }
                  },
          ),
          IconButton(
            icon: const Icon(Icons.network_ping),
            tooltip: 'فحص اتصال جميع الأجهزة',
            onPressed: () {
              ref.read(apNotifierProvider.notifier).checkAllHealth(connectionId);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('جاري فحص حالة اتصال جميع نقاط البث...')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'تحديث القائمة',
            onPressed: () => ref.read(apNotifierProvider.notifier).loadDevices(connectionId),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.cyanAccent,
        foregroundColor: Colors.white,
        onPressed: () => _showAddApDialog(context, ref, connectionId),
        icon: const Icon(Icons.add_circle_outline),
        label: const Text('إضافة نقطة بث يدوياً'),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.devices.isEmpty
              ? _buildEmptyState(context, ref, session)
              : _buildDevicesList(context, ref, state.devices, connectionId),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref, dynamic session) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.router_outlined, size: 72, color: AppColors.textSecondary.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            const Text(
              'لا توجد نقاط بث مسجلة بعد',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'يمكنك اكتشاف نقاط البث المتصلة بالراوتر تلقائياً عبر بروتوكولات MNDP/CDP أو إضافتها يدوياً.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (session != null)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.cardBackground,
                      foregroundColor: AppColors.cyanAccent,
                    ),
                    onPressed: () async {
                      await ref.read(apNotifierProvider.notifier).discoverNeighbors(session.adapter);
                      if (context.mounted) {
                        _showDiscoveredBottomSheet(context, ref, session.connectionId);
                      }
                    },
                    icon: const Icon(Icons.wifi_find),
                    label: const Text('اكتشاف تلقائي'),
                  ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () => _showAddApDialog(context, ref, session?.connectionId ?? 0),
                  icon: const Icon(Icons.add),
                  label: const Text('إضافة يدوية'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDevicesList(
      BuildContext context, WidgetRef ref, List<ApDevicesTableData> devices, int connectionId) {
    return ListView.builder(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 80),
      itemCount: devices.length,
      itemBuilder: (context, index) {
        final ap = devices[index];
        return _buildApCard(context, ref, ap, connectionId);
      },
    );
  }

  Widget _buildApCard(
      BuildContext context, WidgetRef ref, ApDevicesTableData ap, int connectionId) {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (ap.accessState) {
      case 'ok':
        statusColor = AppColors.success;
        statusText = 'متصل ومتاح';
        statusIcon = Icons.check_circle_outline;
        break;
      case 'unreachable':
        statusColor = AppColors.danger;
        statusText = 'غير متاح';
        statusIcon = Icons.cancel_outlined;
        break;
      case 'bad_credentials':
        statusColor = AppColors.warning;
        statusText = 'بيانات دخول خاطئة';
        statusIcon = Icons.lock_clock_outlined;
        break;
      default:
        statusColor = AppColors.textSecondary;
        statusText = 'غير مفحوص';
        statusIcon = Icons.help_outline;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: _getVendorColor(ap.vendor).withValues(alpha: 0.15),
                  child: Icon(Icons.router, color: _getVendorColor(ap.vendor)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ap.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            ap.ip,
                            style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.cyanAccent,
                                fontFamily: 'monospace'),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: _getVendorColor(ap.vendor).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              ap.vendor,
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: _getVendorColor(ap.vendor)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: statusColor.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, color: statusColor, size: 14),
                      const SizedBox(width: 4),
                      Text(statusText,
                          style: TextStyle(
                              color: statusColor, fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ap.lastCheckAt != null
                      ? 'آخر فحص: ${DateFormat('HH:mm  yyyy/MM/dd').format(ap.lastCheckAt!)}'
                      : 'لم يتم الفحص بعد',
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.refresh, size: 20),
                      tooltip: 'فحص الاتصال الفردي',
                      onPressed: () async {
                        final repo = ref.read(apRepositoryProvider);
                        await repo.refreshApState(ap.id, ap.ip);
                        ref.read(apNotifierProvider.notifier).loadDevices(connectionId);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.open_in_browser, color: AppColors.cyanAccent),
                      tooltip: 'فتح لوحة التحكم (Web UI)',
                      onPressed: () => _openApWebUi(context, ref, ap),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: AppColors.danger, size: 20),
                      tooltip: 'حذف',
                      onPressed: () => _confirmDelete(context, ref, ap.id, connectionId),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getVendorColor(String vendor) {
    switch (vendor.toLowerCase()) {
      case 'ubiquiti':
        return Colors.teal;
      case 'tp-link':
        return Colors.green;
      case 'cambium':
        return Colors.deepPurple;
      case 'mikrotik':
      default:
        return AppColors.cyanAccent;
    }
  }

  Future<void> _openApWebUi(BuildContext context, WidgetRef ref, ApDevicesTableData ap) async {
    final creds = await ref.read(apRepositoryProvider).getApCredentials(ap.id);
    final user = creds['username'];
    final pass = creds['password'];

    if ((user != null && user.isNotEmpty) || (pass != null && pass.isNotEmpty)) {
      if (pass != null && pass.isNotEmpty) {
        await Clipboard.setData(ClipboardData(text: pass));
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('اسم المستخدم: $user  |  تم نسخ كلمة المرور للحافظة تلقائياً!'),
              backgroundColor: AppColors.success,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    }

    final url = Uri.parse('http://${ap.ip}');
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تعذر فتح المتصفح: $e')),
        );
      }
    }
  }

  void _showDiscoveredBottomSheet(BuildContext context, WidgetRef ref, int connectionId) {
    final state = ref.read(apNotifierProvider);
    final discovered = state.discovered;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          expand: false,
          builder: (_, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'الأجهزة المكتشفة في الشبكة (MNDP/CDP)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'تم العثور على ${discovered.length} جهاز متصل عبر بروتوكولات الاكتشاف.',
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  const Divider(height: 24),
                  if (discovered.isEmpty)
                    const Expanded(
                      child: Center(
                        child: Text(
                          'لم يتم العثور على أجهزة جيران حالياً.\nتأكد من تفعيل MNDP / Discovery في أجهزة البث.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: discovered.length,
                        itemBuilder: (c, idx) {
                          final item = discovered[idx];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: const CircleAvatar(
                                backgroundColor: AppColors.cyanAccent,
                                child: Icon(Icons.wifi_tethering, color: Colors.white),
                              ),
                              title: Text(item.identity,
                                  style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                '${item.ip}  •  ${item.vendor}  •  ${item.interface}',
                                style: const TextStyle(
                                    fontSize: 11, color: AppColors.textSecondary),
                              ),
                              trailing: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.success,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                ),
                                onPressed: () async {
                                  final success = await ref
                                      .read(apNotifierProvider.notifier)
                                      .addDiscovered(connectionId, item);
                                  if (success && ctx.mounted) {
                                    Navigator.pop(ctx);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text('تمت إضافة ${item.identity} بنجاح!')),
                                    );
                                  }
                                },
                                child: const Text('إضافة'),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showAddApDialog(BuildContext context, WidgetRef ref, int connectionId) {
    final nameCtrl = TextEditingController();
    final ipCtrl = TextEditingController();
    final userCtrl = TextEditingController(text: 'admin');
    final passCtrl = TextEditingController();
    String selectedVendor = 'MikroTik';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('إضافة نقطة بث جديدة'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'اسم الجهاز (مثال: سكتر الشمال)',
                    prefixIcon: Icon(Icons.badge_outlined),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: ipCtrl,
                  keyboardType: TextInputType.datetime,
                  decoration: const InputDecoration(
                    labelText: 'عنوان IP (مثال: 192.168.88.20)',
                    prefixIcon: Icon(Icons.network_check),
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedVendor,
                  decoration: const InputDecoration(
                    labelText: 'نوع الجهاز (المصنّع)',
                    prefixIcon: Icon(Icons.business_outlined),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'MikroTik', child: Text('MikroTik RouterOS')),
                    DropdownMenuItem(value: 'Ubiquiti', child: Text('Ubiquiti AirMax / UniFi')),
                    DropdownMenuItem(value: 'TP-Link', child: Text('TP-Link Pharos / CPE')),
                    DropdownMenuItem(value: 'Cambium', child: Text('Cambium Networks')),
                    DropdownMenuItem(value: 'Generic', child: Text('أخرى (Generic)')),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => selectedVendor = val);
                  },
                ),
                const SizedBox(height: 14),
                const Divider(),
                const Text('بيانات دخول الويب (مشفرة في التخزين الآمن)',
                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                const SizedBox(height: 8),
                TextField(
                  controller: userCtrl,
                  decoration: const InputDecoration(
                    labelText: 'اسم مستخدم لوحة التحكم',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: passCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'كلمة المرور',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = nameCtrl.text.trim();
                final ip = ipCtrl.text.trim();
                if (name.isNotEmpty && ip.isNotEmpty) {
                  await ref.read(apNotifierProvider.notifier).addManual(
                        connectionId: connectionId,
                        name: name,
                        ip: ip,
                        vendor: selectedVendor,
                        username: userCtrl.text.trim().isEmpty ? null : userCtrl.text.trim(),
                        password: passCtrl.text.trim().isEmpty ? null : passCtrl.text.trim(),
                      );
                  if (ctx.mounted) Navigator.pop(ctx);
                }
              },
              child: const Text('حفظ الجهاز'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, int id, int connectionId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف نقطة البث'),
        content: const Text('هل أنت متأكد من حذف نقطة البث وبيانات دخولها؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            onPressed: () async {
              await ref.read(apNotifierProvider.notifier).deleteDevice(id, connectionId);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}
