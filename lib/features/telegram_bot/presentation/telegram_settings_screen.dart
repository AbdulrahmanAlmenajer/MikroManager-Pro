import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../domain/telegram_bot_notifier.dart';

class TelegramSettingsScreen extends ConsumerStatefulWidget {
  const TelegramSettingsScreen({super.key});

  @override
  ConsumerState<TelegramSettingsScreen> createState() => _TelegramSettingsScreenState();
}

class _TelegramSettingsScreenState extends ConsumerState<TelegramSettingsScreen> {
  final _tokenCtrl = TextEditingController();
  final _chatIdCtrl = TextEditingController();
  bool _alertDown = true;
  bool _alertCpu = true;
  bool _alertVouchers = true;

  @override
  void initState() {
    super.initState();
    final s = ref.read(telegramBotControllerProvider);
    _tokenCtrl.text = s.botToken;
    _chatIdCtrl.text = s.chatId;
    _alertDown = s.alertRouterDown;
    _alertCpu = s.alertHighCpu;
    _alertVouchers = s.alertVoucherThreshold;
  }

  @override
  void dispose() {
    _tokenCtrl.dispose();
    _chatIdCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(telegramBotControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('إعدادات بوت تيليجرام'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.send_rounded, color: AppColors.cyanAccent),
                        SizedBox(width: 8),
                        Text('بيانات اعتماد البوت', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('أنواع التنبيهات الفورية', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const Divider(height: 20),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('تنبيه سقوط أو عودة الراوتر'),
                      value: _alertDown,
                      onChanged: (val) => setState(() => _alertDown = val),
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('تنبيه ارتفاع استهلاك المعالج عن 90%'),
                      value: _alertCpu,
                      onChanged: (val) => setState(() => _alertCpu = val),
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('تنبيه اقتراب نفاد كروت الهوتسبوت'),
                      value: _alertVouchers,
                      onChanged: (val) => setState(() => _alertVouchers = val),
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
                    );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('✅ تم حفظ إعدادات البوت بنجاح')),
                  );
                }
              },
              icon: const Icon(Icons.save),
              label: const Text('حفظ الإعدادات'),
            ),
            const SizedBox(height: 12),

            OutlinedButton.icon(
              onPressed: state.isSending
                  ? null
                  : () async {
                      final ok = await ref.read(telegramBotControllerProvider.notifier).sendTestMessage();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(ok ? '✅ تم إرسال الرسالة التجريبية بنجاح إلى تيليجرام' : '❌ فشل الإرسال، تحقق من الـ Token والـ Chat ID'),
                            backgroundColor: ok ? AppColors.success : AppColors.danger,
                          ),
                        );
                      }
                    },
              icon: state.isSending
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.send),
              label: const Text('إرسال تنبيه تجريبي للاختبار'),
            ),
          ],
        ),
      ),
    );
  }
}
