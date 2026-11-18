// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/theme_provider.dart';
import '../../../core/security/secure_storage_service.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _botTokenCtrl = TextEditingController();
  final _chatIdCtrl = TextEditingController();
  bool _isSavingTelegram = false;
  bool _isTestingTelegram = false;

  String _paperSize = 'A4';
  int _cardsPerPage = 12;
  bool _showQrCode = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final token = await SecureStorageService.getTelegramBotToken();
    final chatId = await SecureStorageService.getTelegramChatId();
    if (token != null) _botTokenCtrl.text = token;
    if (chatId != null) _chatIdCtrl.text = chatId;
    setState(() {});
  }

  @override
  void dispose() {
    _botTokenCtrl.dispose();
    _chatIdCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات والتهيئة العامة')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Section 0: Appearance / Theme
          _buildSectionHeader('المظهر والسمة', Icons.palette_outlined),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('مظهر التطبيق (يدعم شاشات OLED الداكنة)',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<ThemeMode>(
                      segments: const [
                        ButtonSegment(
                          value: ThemeMode.light,
                          icon: Icon(Icons.light_mode, size: 18),
                          label: Text('فاتح'),
                        ),
                        ButtonSegment(
                          value: ThemeMode.dark,
                          icon: Icon(Icons.dark_mode, size: 18),
                          label: Text('داكن OLED'),
                        ),
                        ButtonSegment(
                          value: ThemeMode.system,
                          icon: Icon(Icons.settings_suggest, size: 18),
                          label: Text('النظام'),
                        ),
                      ],
                      selected: {ref.watch(themeModeProvider)},
                      onSelectionChanged: (newSelection) {
                        ref
                            .read(themeModeProvider.notifier)
                            .setThemeMode(newSelection.first);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Section 1: Printer Settings
          _buildSectionHeader('إعدادات الطابعات', Icons.print),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.cyanAccent,
                    child: Icon(Icons.bluetooth, color: Colors.white),
                  ),
                  title:
                      const Text('طابعة البلوتوث الحرارية (Thermal Printer)'),
                  subtitle: const Text(
                      'ربط الطابعات المحمولة 58mm / 80mm عبر Bluetooth'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _showBluetoothPrintersDialog(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.navyPrimary,
                    child: Icon(Icons.print_outlined, color: Colors.white),
                  ),
                  title: const Text('طابعات النظام والشبكة (A4)'),
                  subtitle: const Text(
                      'توجيه مباشر لطابعات Wi-Fi أو USB المتصلة بالنظام'),
                  trailing: const Icon(Icons.check, color: AppColors.success),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Section 2: Voucher Template Defaults
          _buildSectionHeader(
              'تخصيص قوالب الكروت', Icons.confirmation_number_outlined),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                        labelText: 'المقاس الافتراضي للطباعة'),
                    value: _paperSize,
                    items: const [
                      DropdownMenuItem(
                          value: 'A4', child: Text('ورق A4 (شبكة كروت)')),
                      DropdownMenuItem(
                          value: '58mm',
                          child: Text('طابعة حرارية 58mm (ميدانية)')),
                      DropdownMenuItem(
                          value: '80mm',
                          child: Text('طابعة حرارية 80mm (نقطة بيع)')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _paperSize = val);
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                        labelText: 'عدد الكروت الافتراضي بالصفحة (A4)'),
                    value: _cardsPerPage,
                    items: const [
                      DropdownMenuItem(value: 8, child: Text('8 كروت')),
                      DropdownMenuItem(
                          value: 12, child: Text('12 كرت (موصى به)')),
                      DropdownMenuItem(value: 15, child: Text('15 كرت')),
                      DropdownMenuItem(value: 18, child: Text('18 كرت')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _cardsPerPage = val);
                    },
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('تضمين رمز QR لتسجيل الدخول السريع'),
                    subtitle: const Text(
                        'مسح الكاميرا لتسجيل الدخول التلقائي بدون كتابة'),
                    value: _showQrCode,
                    onChanged: (val) => setState(() => _showQrCode = val),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Section 3: Telegram Bot Integration
          _buildSectionHeader('ربط بوت تيليجرام (Telegram Bot)', Icons.send),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'يتيح ربط البوت إرسال تقارير المبيعات اليومية وتنبيهات انقطاع الراوتر أو امتلاء المعالج مباشرة إلى هاتفك.',
                    style:
                        TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _botTokenCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Bot Token (من BotFather)',
                      prefixIcon: Icon(Icons.key),
                      hintText: '123456789:ABCdefGhIJKlmNoPQRsTUVwxyZ',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _chatIdCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Chat ID (معرف المحادثة أو القناة)',
                      prefixIcon: Icon(Icons.chat_bubble_outline),
                      hintText: 'مثال: 987654321 أو @my_channel',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed:
                              _isTestingTelegram ? null : _testTelegramAlert,
                          icon: _isTestingTelegram
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.notifications_active_outlined),
                          label: const Text('إرسال تنبيه تجريبي'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.cyanAccent),
                          onPressed:
                              _isSavingTelegram ? null : _saveTelegramSettings,
                          icon: const Icon(Icons.save),
                          label: const Text('حفظ الإعدادات'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Section 4: About App
          _buildSectionHeader('عن التطبيق', Icons.info_outline),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.navyPrimary,
                    child: Icon(Icons.router, size: 32, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  const Text('MikroManager Pro',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: AppColors.textPrimary)),
                  const Text('الإصدار 1.0.0 (Build 1) | معمارية Clean + Drift',
                      style: TextStyle(
                          fontSize: 12, color: AppColors.textSecondary)),
                  const SizedBox(height: 12),
                  const Text(
                    'تطبيق متكامل لإدارة وطباعة كروت الميكروتك (Hotspot & User Manager) عبر بروتوكول بورت API و REST مع دعم RTL والطباعة الحرارية الميدانية.',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, right: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.cyanAccent),
          const SizedBox(width: 6),
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  void _showBluetoothPrintersDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('طابعات البلوتوث الحرارية'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bluetooth_searching,
                size: 48, color: AppColors.cyanAccent),
            SizedBox(height: 12),
            Text(
                'تأكد من اقتران طابعة البلوتوث الميدانية (58mm/80mm) بجهازك أولاً من إعدادات البلوتوث في النظام.'),
            SizedBox(height: 8),
            Text(
                'يدعم التطبيق طابعات MPT-II, POS-58, Xprinter وجميع طابعات ESC/POS المتوافقة.',
                style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('إغلاق')),
        ],
      ),
    );
  }

  Future<void> _saveTelegramSettings() async {
    setState(() => _isSavingTelegram = true);
    await SecureStorageService.saveTelegramBotToken(_botTokenCtrl.text.trim());
    await SecureStorageService.saveTelegramChatId(_chatIdCtrl.text.trim());
    setState(() => _isSavingTelegram = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ تم حفظ إعدادات تيليجرام بأمان مشفرة!'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  Future<void> _testTelegramAlert() async {
    final token = _botTokenCtrl.text.trim();
    final chatId = _chatIdCtrl.text.trim();

    if (token.isEmpty || chatId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال Bot Token و Chat ID أولاً')),
      );
      return;
    }

    setState(() => _isTestingTelegram = true);

    try {
      final dio = Dio();
      final url = 'https://api.telegram.org/bot$token/sendMessage';
      final res = await dio.post(url, data: {
        'chat_id': chatId,
        'text':
            '🔔 تجربة الاتصال من MikroManager Pro:\nتم ربط بوت تيليجرام بنجاح! ستصلك هنا تقارير المبيعات وتنبيهات الشبكة.',
      });

      if (res.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ تم إرسال رسالة التنبيه بنجاح إلى تيليجرام!'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } else {
        throw Exception('رمز الاستجابة: ${res.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ فشل إرسال التنبيه: $e'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isTestingTelegram = false);
    }
  }
}
