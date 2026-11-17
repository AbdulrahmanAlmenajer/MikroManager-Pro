import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/session/session_controller.dart';
import '../domain/telegram_bot_notifier.dart';

class TelegramSettingsScreen extends ConsumerStatefulWidget {
  const TelegramSettingsScreen({super.key});

  @override
  ConsumerState<TelegramSettingsScreen> createState() => _TelegramSettingsScreenState();
}

class _TelegramSettingsScreenState extends ConsumerState<TelegramSettingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _tokenCtrl = TextEditingController();
  final _chatIdCtrl = TextEditingController();
  bool _alertDown = true;
  bool _alertCpu = true;
  bool _alertVouchers = true;
  bool _alertRogueDhcp = true;

  // Netwatch Generator
  final _netwatchApNameCtrl = TextEditingController(text: 'AP-Sector-1');
  final _netwatchApIpCtrl = TextEditingController(text: '192.168.88.20');
  String _generatedNetwatchScript = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    final s = ref.read(telegramBotControllerProvider);
    _tokenCtrl.text = s.botToken;
    _chatIdCtrl.text = s.chatId;
    _alertDown = s.alertRouterDown;
    _alertCpu = s.alertHighCpu;
    _alertVouchers = s.alertVoucherThreshold;
    _alertRogueDhcp = s.alertRogueDhcp;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _tokenCtrl.dispose();
    _chatIdCtrl.dispose();
    _netwatchApNameCtrl.dispose();
    _netwatchApIpCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(telegramBotControllerProvider);
    final session = ref.watch(sessionControllerProvider).session;
    final connectionId = session?.connectionId ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('التنبيهات المتقدمة وبوت تيليجرام'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.cyanAccent,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.send_rounded), text: 'بيانات البوت'),
            Tab(icon: Icon(Icons.security), text: 'DHCP الدخيل'),
            Tab(icon: Icon(Icons.bedtime_outlined), text: 'الهدوء & Netwatch'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBotConfigTab(state),
          _buildRogueDhcpTab(state, session, connectionId),
          _buildQuietHoursAndNetwatchTab(state, connectionId),
        ],
      ),
    );
  }

  // =========================================================================
  // Tab 1: Bot Credentials & Alerts Toggles
  // =========================================================================

  Widget _buildBotConfigTab(TelegramBotState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.send_rounded, color: AppColors.cyanAccent),
                      SizedBox(width: 8),
                      Text('بيانات اعتماد البوت',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const Divider(height: 20),
                  TextField(
                    controller: _tokenCtrl,
                    decoration: const InputDecoration(
                      labelText: 'رمز البوت (Bot Token)',
                      hintText: '123456789:ABCdefGhIJKlmNoPQRsTUVwxyZ',
                      prefixIcon: Icon(Icons.key),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _chatIdCtrl,
                    decoration: const InputDecoration(
                      labelText: 'معرف المحادثة (Chat ID)',
                      hintText: '987654321 أو -1001234567890',
                      prefixIcon: Icon(Icons.chat),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('أنواع التنبيهات الفورية',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const Divider(height: 20),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('تنبيه سقوط أو عودة الراوتر'),
                    subtitle: const Text('إشعار فوري عند انقطاع الاتصال أو عودته',
                        style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    value: _alertDown,
                    onChanged: (val) => setState(() => _alertDown = val),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('تنبيه ارتفاع استهلاك المعالج عن 90%'),
                    subtitle: const Text('إشعار عند حدوث ضغط غير طبيعي على المعالج',
                        style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    value: _alertCpu,
                    onChanged: (val) => setState(() => _alertCpu = val),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('تنبيه اقتراب نفاد كروت الهوتسبوت'),
                    subtitle: const Text('إشعار عندما يقل رصيد الكروت الجاهزة عن الحد الأدنى',
                        style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    value: _alertVouchers,
                    onChanged: (val) => setState(() => _alertVouchers = val),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('تنبيه خادم DHCP دخيل (Rogue DHCP)'),
                    subtitle: const Text('إشعار أحمر طارئ فوري عند ظهور سيرفر غير مصرح به',
                        style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    value: _alertRogueDhcp,
                    onChanged: (val) => setState(() => _alertRogueDhcp = val),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () async {
              await ref.read(telegramBotControllerProvider.notifier).saveSettings(
                    botToken: _tokenCtrl.text.trim(),
                    chatId: _chatIdCtrl.text.trim(),
                    alertRouterDown: _alertDown,
                    alertHighCpu: _alertCpu,
                    alertVoucherThreshold: _alertVouchers,
                    alertRogueDhcp: _alertRogueDhcp,
                  );
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('✅ تم حفظ إعدادات البوت والتنبيهات بنجاح')),
                );
              }
            },
            icon: const Icon(Icons.save),
            label: const Text('حفظ الإعدادات والتنبيهات'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: state.isSending
                ? null
                : () async {
                    final ok =
                        await ref.read(telegramBotControllerProvider.notifier).sendTestMessage();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(ok
                              ? '✅ تم إرسال الرسالة التجريبية بنجاح إلى تيليجرام'
                              : '❌ فشل الإرسال، تحقق من الـ Token والـ Chat ID'),
                          backgroundColor: ok ? AppColors.success : AppColors.danger,
                        ),
                      );
                    }
                  },
            icon: state.isSending
                ? const SizedBox(
                    width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.send),
            label: const Text('إرسال تنبيه تجريبي للاختبار'),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // Tab 2: Rogue DHCP Detection
  // =========================================================================

  Widget _buildRogueDhcpTab(TelegramBotState state, dynamic session, int connectionId) {
    final rogueServers = state.rogueAlerts.where((r) => !r.isTrusted).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Urgent Warning Banner if Rogue DHCP detected
        if (rogueServers.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.danger.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.danger, width: 1.5),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_rounded, color: AppColors.danger, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('تحذير: تم اكتشاف خادم DHCP دخيل!',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.danger)),
                      const SizedBox(height: 4),
                      Text(
                        'تم رصد خادم على IP: ${rogueServers.first.serverIp} الواجهة: ${rogueServers.first.interface}. قد يتسبب في فصل كروت المشتركين.',
                        style: const TextStyle(fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

        // Action Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('فحص خوادم DHCP الدخيلة بالراوتر',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.cardBackground,
                foregroundColor: AppColors.cyanAccent,
              ),
              onPressed: session == null || state.isScanningDhcp
                  ? null
                  : () async {
                      await ref
                          .read(telegramBotControllerProvider.notifier)
                          .scanRogueDhcp(session.adapter, connectionId);
                    },
              icon: state.isScanningDhcp
                  ? const SizedBox(
                      width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.radar, size: 18),
              label: const Text('فحص الآن'),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Detected List
        if (state.rogueAlerts.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(
                  state.isScanningDhcp
                      ? 'جاري فحص قائمة الـ Alerts وسجلات الراوتر...'
                      : 'اضغط على "فحص الآن" لاستعلام قائمة DHCP Alerts بالراوتر.',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
              ),
            ),
          )
        else
          ...state.rogueAlerts.map((alert) {
            final isRogue = !alert.isTrusted;
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              elevation: 2,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                      (isRogue ? AppColors.danger : AppColors.success).withValues(alpha: 0.15),
                  child: Icon(
                    isRogue ? Icons.gpp_bad : Icons.gpp_good,
                    color: isRogue ? AppColors.danger : AppColors.success,
                  ),
                ),
                title: Text(alert.serverIp, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('الواجهة: ${alert.interface}'),
                trailing: Chip(
                  label: Text(
                    isRogue ? 'دخيل (Rogue)' : 'موثوق',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isRogue ? AppColors.danger : AppColors.success,
                    ),
                  ),
                  backgroundColor:
                      (isRogue ? AppColors.danger : AppColors.success).withValues(alpha: 0.1),
                ),
              ),
            );
          }),

        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('قائمة الخوادم الموثوقة (Trusted Servers):',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            TextButton.icon(
              onPressed: () => _showAddTrustedDialog(context, connectionId),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('إضافة موثوق'),
            ),
          ],
        ),
        const SizedBox(height: 8),

        if (state.trustedServers.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: Text('لم يتم تسجيل خوادم موثوقة بعد. أضف سيرفر الراوتر الأساسي.',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            ),
          )
        else
          ...state.trustedServers.map((srv) {
            return Card(
              margin: const EdgeInsets.only(bottom: 6),
              child: ListTile(
                dense: true,
                leading: const Icon(Icons.verified, color: AppColors.success, size: 20),
                title: Text(srv.serverIp, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('الواجهة: ${srv.interface}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: AppColors.danger, size: 18),
                  onPressed: () => ref
                      .read(telegramBotControllerProvider.notifier)
                      .removeTrustedServer(srv.id, connectionId),
                ),
              ),
            );
          }),
      ],
    );
  }

  // =========================================================================
  // Tab 3: Quiet Hours & Router Netwatch Script Generator
  // =========================================================================

  Widget _buildQuietHoursAndNetwatchTab(TelegramBotState state, int connectionId) {
    final quiet = state.quietHours;
    final startHour = (quiet?.startMinute ?? 0) ~/ 60;
    final startMin = (quiet?.startMinute ?? 0) % 60;
    final endHour = (quiet?.endMinute ?? 360) ~/ 60;
    final endMin = (quiet?.endMinute ?? 360) % 60;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Quiet Hours Card
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.bedtime_outlined, color: AppColors.cyanAccent),
                      SizedBox(width: 8),
                      Text('ساعات الهدوء (كتم الإشعارات غير الحرجة)',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'يتم كتم التنبيهات العادية خلال هذه الساعات (مثلاً وقت النوم)، مع استمرار إرسال التنبيهات الطارئة (سقوط الراوتر أو DHCP دخيل).',
                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton.icon(
                        icon: const Icon(Icons.schedule),
                        label: Text(
                            'البداية: ${startHour.toString().padLeft(2, '0')}:${startMin.toString().padLeft(2, '0')}'),
                        onPressed: () async {
                          final t = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(hour: startHour, minute: startMin),
                          );
                          if (t != null) {
                            final newStart = t.hour * 60 + t.minute;
                            await ref.read(telegramBotControllerProvider.notifier).setQuietHours(
                                  connectionId: connectionId,
                                  startMinute: newStart,
                                  endMinute: quiet?.endMinute ?? 360,
                                );
                          }
                        },
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.schedule),
                        label: Text(
                            'النهاية: ${endHour.toString().padLeft(2, '0')}:${endMin.toString().padLeft(2, '0')}'),
                        onPressed: () async {
                          final t = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(hour: endHour, minute: endMin),
                          );
                          if (t != null) {
                            final newEnd = t.hour * 60 + t.minute;
                            await ref.read(telegramBotControllerProvider.notifier).setQuietHours(
                                  connectionId: connectionId,
                                  startMinute: quiet?.startMinute ?? 0,
                                  endMinute: newEnd,
                                );
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          final muteUntil = DateTime.now().add(const Duration(hours: 4));
                          ref
                              .read(telegramBotControllerProvider.notifier)
                              .muteQuietHoursUntil(connectionId, muteUntil);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('تم كتم التنبيهات لمدة 4 ساعات')),
                          );
                        },
                        icon: const Icon(Icons.notifications_off_outlined, size: 16),
                        label: const Text('كتم مؤقت 4 ساعات'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Router Netwatch Script Generator
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.terminal, color: AppColors.cyanAccent),
                      SizedBox(width: 8),
                      Text('مولد سكربت Netwatch للراوتر',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'يتيح للراوتر إرسال تنبيهات Telegram مباشرة عبر /tool/netwatch حتى لو كان تطبيق الهاتف مغلقاً تماماً.',
                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 12),

                  // Warning Box
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.warning),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 24),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '⚠️ تنبيه أمني: السكربت المولد سيحتوي على توكن البوت. لا تضعه في راوتر يدخل عليه أشخاص غير موثوقين.',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  TextField(
                    controller: _netwatchApNameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'اسم نقطة البث المراد مراقبتها',
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _netwatchApIpCtrl,
                    decoration: const InputDecoration(
                      labelText: 'عنوان IP لنقطة البث',
                      prefixIcon: Icon(Icons.network_check),
                    ),
                  ),
                  const SizedBox(height: 14),

                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.cardBackground,
                      foregroundColor: AppColors.cyanAccent,
                    ),
                    onPressed: () {
                      final alertsRepo = ref.read(alertsRepositoryProvider);
                      final script = alertsRepo.generateNetwatchScript(
                        apName: _netwatchApNameCtrl.text.trim(),
                        apIp: _netwatchApIpCtrl.text.trim(),
                        botToken: _tokenCtrl.text.trim(),
                        chatId: _chatIdCtrl.text.trim(),
                      );
                      setState(() => _generatedNetwatchScript = script);
                    },
                    icon: const Icon(Icons.code),
                    label: const Text('توليد أمر Netwatch'),
                  ),

                  if (_generatedNetwatchScript.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SelectableText(
                        _generatedNetwatchScript,
                        style: const TextStyle(
                            fontFamily: 'monospace', fontSize: 11, color: Colors.greenAccent),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await Clipboard.setData(ClipboardData(text: _generatedNetwatchScript));
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('تم نسخ سكربت Netwatch للحافظة!')),
                          );
                        }
                      },
                      icon: const Icon(Icons.copy),
                      label: const Text('نسخ السكربت للحافظة'),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddTrustedDialog(BuildContext context, int connectionId) {
    final ipCtrl = TextEditingController();
    final ifaceCtrl = TextEditingController(text: 'bridge1');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إضافة خادم DHCP موثوق'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: ipCtrl,
              decoration: const InputDecoration(
                labelText: 'عنوان IP الخادم (مثال: 192.168.88.1)',
                prefixIcon: Icon(Icons.network_check),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: ifaceCtrl,
              decoration: const InputDecoration(
                labelText: 'الواجهة (مثال: bridge1 أو ether1)',
                prefixIcon: Icon(Icons.settings_ethernet),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () async {
              final ip = ipCtrl.text.trim();
              final iface = ifaceCtrl.text.trim();
              if (ip.isNotEmpty) {
                await ref
                    .read(telegramBotControllerProvider.notifier)
                    .addTrustedServer(connectionId, ip, iface);
                if (ctx.mounted) Navigator.pop(ctx);
              }
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }
}
