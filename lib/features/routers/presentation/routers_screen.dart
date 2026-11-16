import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/database/app_database.dart';
import '../../../core/security/secure_storage_service.dart';
import '../domain/routers_notifier.dart';

class RoutersScreen extends ConsumerStatefulWidget {
  const RoutersScreen({super.key});

  @override
  ConsumerState<RoutersScreen> createState() => _RoutersScreenState();
}

class _RoutersScreenState extends ConsumerState<RoutersScreen> {
  final Map<int, bool?> _testStatus = {};

  @override
  Widget build(BuildContext context) {
    final routersAsync = ref.watch(routersStreamProvider);
    final routerState = ref.watch(routersControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة أجهزة الميكروتك'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'معلومات الاتصال',
            onPressed: () => _showInfoDialog(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddOrEditRouterDialog(context),
        backgroundColor: AppColors.cyanAccent,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('إضافة راوتر', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: routersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('خطأ في تحميل الراوترات: $err')),
        data: (routers) {
          if (routers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.router_outlined, size: 72, color: AppColors.textSecondary.withValues(alpha: 0.5)),
                  const SizedBox(height: 16),
                  const Text('لا توجد أجهزة راوتر مضافة حالياً',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  const Text('اضغط على "إضافة راوتر" لربط جهاز MikroTik جديد',
                      style: TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _showAddOrEditRouterDialog(context),
                    icon: const Icon(Icons.add),
                    label: const Text('إضافة راوتر الآن'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: routers.length,
            itemBuilder: (context, index) {
              final router = routers[index];
              final isActive = routerState.activeRouter?.id == router.id || router.isActive;
              final testResult = _testStatus[router.id];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: isActive ? 4 : 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: isActive ? AppColors.cyanAccent : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: isActive ? AppColors.success : AppColors.navyPrimary.withValues(alpha: 0.1),
                          child: Icon(
                            isActive ? Icons.router : Icons.router_outlined,
                            color: isActive ? Colors.white : AppColors.navyPrimary,
                          ),
                        ),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                router.name,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                            if (isActive)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'الراوتر النشط',
                                  style: TextStyle(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            'IP: ${router.ipAddress} | Port: ${router.apiPort} | User: ${router.username}'
                            '${router.useRestApi ? " | REST" : " | Socket"}'
                            '${router.useSsl ? " (SSL)" : ""}',
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'select') {
                              ref.read(routersControllerProvider.notifier).selectActiveRouter(router);
                            } else if (value == 'edit') {
                              _showAddOrEditRouterDialog(context, router: router);
                            } else if (value == 'delete') {
                              _confirmDelete(context, router);
                            }
                          },
                          itemBuilder: (ctx) => [
                            if (!isActive)
                              const PopupMenuItem(value: 'select', child: Text('تعيين كالراوتر النشط')),
                            const PopupMenuItem(value: 'edit', child: Text('تعديل البيانات')),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('حذف الراوتر', style: TextStyle(color: AppColors.danger)),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Test Connection Button
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.cyanAccent,
                              side: const BorderSide(color: AppColors.cyanAccent),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            onPressed: () => _testConnection(router),
                            icon: const Icon(Icons.network_check, size: 16),
                            label: const Text('فحص الاتصال (Ping/Socket)', style: TextStyle(fontSize: 12)),
                          ),
                          // Status Badge
                          if (testResult != null)
                            Chip(
                              avatar: Icon(
                                testResult ? Icons.check_circle : Icons.error,
                                size: 16,
                                color: Colors.white,
                              ),
                              label: Text(
                                testResult ? 'الاتصال ناجح' : 'فشل الاتصال',
                                style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              backgroundColor: testResult ? AppColors.success : AppColors.danger,
                              padding: EdgeInsets.zero,
                            )
                          else if (!isActive)
                            TextButton(
                              onPressed: () =>
                                  ref.read(routersControllerProvider.notifier).selectActiveRouter(router),
                              child: const Text('اتصال بهذا الراوتر', style: TextStyle(fontSize: 12)),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _testConnection(RoutersTableData router) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('جاري فحص الاتصال بـ ${router.name}...'),
        duration: const Duration(seconds: 1),
      ),
    );

    final password = await SecureStorageService.getRouterPassword(router.id) ?? '';
    final success = await ref.read(routersControllerProvider.notifier).testConnection(
          ipAddress: router.ipAddress,
          apiPort: router.apiPort,
          username: router.username,
          password: password,
          useSsl: router.useSsl,
          useRestApi: router.useRestApi,
        );

    setState(() {
      _testStatus[router.id] = success;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? '✅ تم الاتصال بنجاح بـ ${router.name}' : '❌ تعذر الاتصال بـ ${router.name}، تحقق من الإعدادات',
          ),
          backgroundColor: success ? AppColors.success : AppColors.danger,
        ),
      );
    }
  }

  void _showAddOrEditRouterDialog(BuildContext context, {RoutersTableData? router}) async {
    final isEditing = router != null;
    final nameCtrl = TextEditingController(text: router?.name ?? '');
    final ipCtrl = TextEditingController(text: router?.ipAddress ?? '192.168.88.1');
    final portCtrl = TextEditingController(text: (router?.apiPort ?? 8728).toString());
    final userCtrl = TextEditingController(text: router?.username ?? 'admin');
    final passCtrl = TextEditingController();
    bool useSsl = router?.useSsl ?? false;
    bool useRest = router?.useRestApi ?? false;
    final notesCtrl = TextEditingController(text: router?.notes ?? '');

    if (isEditing) {
      final existingPass = await SecureStorageService.getRouterPassword(router.id);
      passCtrl.text = existingPass ?? '';
    }

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(isEditing ? 'تعديل بيانات الراوتر' : 'إضافة راوتر جديد'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'اسم الراوتر *', prefixIcon: Icon(Icons.label_outline)),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: ipCtrl,
                  decoration: const InputDecoration(labelText: 'عنوان IP *', prefixIcon: Icon(Icons.language)),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: portCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'بورت API *', prefixIcon: Icon(Icons.numbers)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: userCtrl,
                        decoration: const InputDecoration(labelText: 'اسم المستخدم *', prefixIcon: Icon(Icons.person_outline)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: passCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'كلمة المرور', prefixIcon: Icon(Icons.lock_outline)),
                ),
                const SizedBox(height: 12),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('استخدام SSL (API-SSL)', style: TextStyle(fontSize: 14)),
                  value: useSsl,
                  onChanged: (val) {
                    setDialogState(() {
                      useSsl = val ?? false;
                      if (!useRest) {
                        portCtrl.text = useSsl ? '8729' : '8728';
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('استخدام REST API (RouterOS v7+)', style: TextStyle(fontSize: 14)),
                  subtitle: const Text('بورت 80 أو 443 للـ REST', style: TextStyle(fontSize: 11)),
                  value: useRest,
                  onChanged: (val) {
                    setDialogState(() {
                      useRest = val ?? false;
                      if (useRest) {
                        portCtrl.text = useSsl ? '443' : '80';
                      } else {
                        portCtrl.text = useSsl ? '8729' : '8728';
                      }
                    });
                  },
                ),
                TextField(
                  controller: notesCtrl,
                  decoration: const InputDecoration(labelText: 'ملاحظات إضافية (اختياري)', prefixIcon: Icon(Icons.notes)),
                  maxLines: 2,
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
                if (nameCtrl.text.trim().isEmpty || ipCtrl.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('يرجى ملء الحقول المطلوبة (*)')),
                  );
                  return;
                }

                final port = int.tryParse(portCtrl.text.trim()) ?? 8728;

                if (isEditing) {
                  await ref.read(routersControllerProvider.notifier).updateRouter(
                        id: router.id,
                        name: nameCtrl.text.trim(),
                        ipAddress: ipCtrl.text.trim(),
                        apiPort: port,
                        username: userCtrl.text.trim(),
                        password: passCtrl.text.isNotEmpty ? passCtrl.text : null,
                        useSsl: useSsl,
                        useRestApi: useRest,
                        notes: notesCtrl.text.trim().isNotEmpty ? notesCtrl.text.trim() : null,
                      );
                } else {
                  await ref.read(routersControllerProvider.notifier).addRouter(
                        name: nameCtrl.text.trim(),
                        ipAddress: ipCtrl.text.trim(),
                        apiPort: port,
                        username: userCtrl.text.trim(),
                        password: passCtrl.text,
                        useSsl: useSsl,
                        useRestApi: useRest,
                        notes: notesCtrl.text.trim().isNotEmpty ? notesCtrl.text.trim() : null,
                      );
                }

                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: Text(isEditing ? 'حفظ التعديلات' : 'إضافة الراوتر'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, RoutersTableData router) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد حذف الراوتر'),
        content: Text('هل أنت متأكد من حذف الراوتر "${router.name}"؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () async {
              await ref.read(routersControllerProvider.notifier).deleteRouter(router.id);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('حذف نهائياً'),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('بورتات MikroTik المدعومة'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• بورت 8728: Binary API العادي (RouterOS v6 & v7)'),
            SizedBox(height: 6),
            Text('• بورت 8729: API-SSL المشفر'),
            SizedBox(height: 6),
            Text('• بورت 80 / 443: REST API (RouterOS v7+)'),
            SizedBox(height: 12),
            Text('ملاحظة: تأكد من تفعيل خدمة API في راوترك عبر:\nIP -> Services -> api / api-ssl / www-ssl',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('حسناً')),
        ],
      ),
    );
  }
}
