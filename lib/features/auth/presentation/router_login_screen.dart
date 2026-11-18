import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/database/app_database.dart';
import '../../../core/security/secure_storage_service.dart';
import '../../../core/session/session_controller.dart';
import '../../../core/utils/validators.dart';
import '../../routers/domain/routers_notifier.dart';

class RouterLoginScreen extends ConsumerStatefulWidget {
  const RouterLoginScreen({super.key});

  @override
  ConsumerState<RouterLoginScreen> createState() => _RouterLoginScreenState();
}

class _RouterLoginScreenState extends ConsumerState<RouterLoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController(text: 'الراوتر الرئيسي');
  final _ipController = TextEditingController(text: '192.168.88.1');
  final _portController = TextEditingController(text: '8728');
  final _userController = TextEditingController(text: 'admin');
  final _passController = TextEditingController();

  bool _obscurePassword = true;
  bool _useSsl = false;
  bool _acceptSelfSigned = true;
  bool _useRest = false;
  bool _rememberMe = true;
  int? _selectedSavedRouterId;
  bool? _testResult;
  bool _isTesting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialRouterData();
    });
  }

  Future<void> _loadInitialRouterData() async {
    final active = ref.read(routersControllerProvider).activeRouter;
    if (active != null) {
      _populateFromRouter(active);
    }
  }

  Future<void> _populateFromRouter(RoutersTableData router) async {
    setState(() {
      _selectedSavedRouterId = router.id;
      _nameController.text = router.name;
      _ipController.text = router.ipAddress;
      _portController.text = router.apiPort.toString();
      _userController.text = router.username;
      _useSsl = router.useSsl;
      _useRest = router.useRestApi;
      _rememberMe = true;
      _testResult = null;
    });

    final pass = await SecureStorageService.getRouterPassword(router.id);
    if (mounted) {
      setState(() {
        _passController.text = pass ?? '';
      });
    }
  }

  void _clearFormForNewRouter() {
    setState(() {
      _selectedSavedRouterId = null;
      _nameController.text = 'راوتر جديد';
      _ipController.text = '192.168.88.1';
      _portController.text =
          _useRest ? (_useSsl ? '443' : '80') : (_useSsl ? '8729' : '8728');
      _userController.text = 'admin';
      _passController.clear();
      _rememberMe = true;
      _testResult = null;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ipController.dispose();
    _portController.dispose();
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sessionState = ref.watch(sessionControllerProvider);
    final routersAsync = ref.watch(routersStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header & Logo Card
                    _buildHeaderCard(),
                    const SizedBox(height: 20),

                    // Saved Routers Selector (if any exist)
                    routersAsync.when(
                      data: (routers) {
                        if (routers.isEmpty) return const SizedBox.shrink();
                        return _buildSavedRoutersSelector(routers);
                      },
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 16),

                    // Login Credentials Card
                    _buildCredentialsCard(sessionState),
                    const SizedBox(height: 20),

                    // Error Message Banner (if any)
                    if (sessionState.errorMessage != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.danger.withValues(alpha: 0.1),
                          border: Border.all(
                              color: AppColors.danger.withValues(alpha: 0.3)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.error_outline,
                                color: AppColors.danger, size: 22),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                sessionState.errorMessage!,
                                style: const TextStyle(
                                  color: AppColors.danger,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Action Buttons (Login & Ping)
                    _buildActionButtons(sessionState),
                    const SizedBox(height: 24),

                    // Footer & Developer Info
                    _buildFooter(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cyanAccent.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.cyanAccent, width: 2),
            ),
            child: const Icon(
              Icons.router_rounded,
              size: 42,
              color: AppColors.cyanAccent,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'MikroManager Pro',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'تسجيل الدخول إلى راوتر الميكروتك',
            style: TextStyle(
              color: Color(0xFF38BDF8),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'سجل دخولك للوصول إلى لوحة التحكم وإدارة كروت الشبكة',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedRoutersSelector(List<RoutersTableData> routers) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.bookmarks_outlined,
                    size: 18, color: AppColors.cyanAccent),
                const SizedBox(width: 8),
                const Text(
                  'أجهزة الراوتر المحفوظة:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: _clearFormForNewRouter,
                  icon: const Icon(Icons.add, size: 16),
                  label:
                      const Text('راوتر جديد', style: TextStyle(fontSize: 12)),
                  style: TextButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: routers.map((r) {
                final isSelected = _selectedSavedRouterId == r.id;
                return ChoiceChip(
                  avatar: Icon(
                    isSelected ? Icons.check_circle : Icons.router,
                    size: 16,
                    color: isSelected ? Colors.white : AppColors.cyanAccent,
                  ),
                  label: Text('${r.name} (${r.ipAddress})'),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
                  selected: isSelected,
                  selectedColor: AppColors.cyanAccent,
                  backgroundColor: AppColors.surface,
                  onSelected: (selected) {
                    if (selected) {
                      _populateFromRouter(r);
                    }
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCredentialsCard(SessionState sessionState) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.lock_open_rounded,
                    color: AppColors.cyanAccent, size: 20),
                SizedBox(width: 8),
                Text(
                  'بيانات الاتصال والاعتماد',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
            const Divider(height: 24),

            // Router Name
            if (_selectedSavedRouterId == null && _rememberMe) ...[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'اسم الراوتر للتمييز',
                  hintText: 'مثال: الراوتر الرئيسي',
                  prefixIcon: Icon(Icons.bookmark_outline),
                ),
              ),
              const SizedBox(height: 14),
            ],

            // IP Address
            TextFormField(
              controller: _ipController,
              keyboardType: TextInputType.url,
              validator: (val) {
                if (val == null || val.trim().isEmpty)
                  return 'يرجى إدخال عنوان IP أو اسم المضيف';
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'عنوان IP / المضيف *',
                hintText: '192.168.88.1',
                prefixIcon: Icon(Icons.language_rounded),
              ),
            ),
            const SizedBox(height: 14),

            // Port and Username Row
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _portController,
                    keyboardType: TextInputType.number,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return 'مطلوب';
                      final p = int.tryParse(val.trim());
                      if (p == null || p < 1 || p > 65535) return '1-65535';
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'المنفذ *',
                      hintText: '8728',
                      prefixIcon: Icon(Icons.numbers),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _userController,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty)
                        return 'يرجى إدخال اسم المستخدم';
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'اسم المستخدم *',
                      hintText: 'admin',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Quick Port Chips (8728 / 8729)
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 6,
              runSpacing: 4,
              children: [
                const Text('منافذ سريعة:',
                    style: TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
                ActionChip(
                  label:
                      const Text('8728 (عادي)', style: TextStyle(fontSize: 11)),
                  onPressed: () {
                    setState(() {
                      _portController.text = '8728';
                      _useSsl = false;
                      _useRest = false;
                    });
                  },
                ),
                ActionChip(
                  label:
                      const Text('8729 (SSL)', style: TextStyle(fontSize: 11)),
                  onPressed: () {
                    setState(() {
                      _portController.text = '8729';
                      _useSsl = true;
                      _useRest = false;
                    });
                  },
                ),
              ],
            ),
            if (!_useSsl && _portController.text.trim() == '8728') ...[
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: AppColors.warning.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        size: 18, color: AppColors.warning),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'المنفذ 8728 غير مشفر. استخدم 8729 (API-SSL) لتأمين الاتصال.',
                        style: TextStyle(
                            fontSize: 11,
                            color: AppColors.warning,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _portController.text = '8729';
                          _useSsl = true;
                        });
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        visualDensity: VisualDensity.compact,
                      ),
                      child: const Text('تفعيل 8729',
                          style: TextStyle(
                              fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 14),

            // Password
            TextFormField(
              controller: _passController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'كلمة المرور',
                hintText: 'اتركه فارغاً إن لم تكن هناك كلمة سر',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Protocol Selection
            const Text(
              'بروتوكول الاتصال:',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    avatar: const Icon(Icons.cable, size: 16),
                    label: const Text('Socket API (8728)'),
                    labelStyle: TextStyle(
                      fontSize: 11,
                      fontWeight:
                          !_useRest ? FontWeight.bold : FontWeight.normal,
                      color: !_useRest ? Colors.white : AppColors.textPrimary,
                    ),
                    selected: !_useRest,
                    selectedColor: AppColors.navyPrimary,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _useRest = false;
                          _portController.text = _useSsl ? '8729' : '8728';
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    avatar: const Icon(Icons.http, size: 16),
                    label: const Text('REST API (v7)'),
                    labelStyle: TextStyle(
                      fontSize: 11,
                      fontWeight:
                          _useRest ? FontWeight.bold : FontWeight.normal,
                      color: _useRest ? Colors.white : AppColors.textPrimary,
                    ),
                    selected: _useRest,
                    selectedColor: AppColors.navyPrimary,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _useRest = true;
                          _portController.text = _useSsl ? '443' : '80';
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Switches: SSL & Self-Signed
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('استخدام تشفير TLS/SSL (منفذ 8729)',
                  style: TextStyle(fontSize: 13)),
              value: _useSsl,
              onChanged: (val) {
                setState(() {
                  _useSsl = val;
                  if (_useRest) {
                    _portController.text = _useSsl ? '443' : '80';
                  } else {
                    _portController.text = _useSsl ? '8729' : '8728';
                  }
                });
              },
            ),

            if (_useSsl) ...[
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('قبول الشهادات ذاتية التوقيع (Self-Signed)',
                    style: TextStyle(fontSize: 12)),
                subtitle: const Text(
                  'تنبيه: قبول الشهادات غير الموثوقة قد يعرض الاتصال لاعتراض البيانات على الشبكة المحلية.',
                  style: TextStyle(fontSize: 10, color: AppColors.warning),
                ),
                value: _acceptSelfSigned,
                onChanged: (val) =>
                    setState(() => _acceptSelfSigned = val ?? true),
              ),
            ],

            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('تذكر هذا الاتصال وحفظه للاتصال السريع',
                  style: TextStyle(fontSize: 13)),
              value: _rememberMe,
              onChanged: (val) => setState(() => _rememberMe = val ?? true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(SessionState sessionState) {
    final isLocked = sessionState.isLocked;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Main Login Button
        ElevatedButton(
          onPressed:
              (sessionState.isConnecting || isLocked) ? null : _handleLogin,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isLocked ? AppColors.textSecondary : AppColors.cyanAccent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 4,
          ),
          child: sessionState.isConnecting
              ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2.5, color: Colors.white),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'جاري التحقق والاتصال بالراوتر...',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              : FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(isLocked ? Icons.lock_clock : Icons.login_rounded,
                          size: 22),
                      const SizedBox(width: 8),
                      Text(
                        isLocked
                            ? 'محظور مؤقتاً (${sessionState.remainingLockSeconds} ثانية)'
                            : 'تسجيل الدخول والاتصال بالراوتر',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
        ),
        const SizedBox(height: 12),

        // Test Connection Button
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _isTesting ? null : _handleTestPing,
                icon: _isTesting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.network_check_rounded, size: 18),
                label: const Text('فحص الاتصال فقط (Ping/Port)',
                    style: TextStyle(fontSize: 13)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.navyPrimary,
                  side: const BorderSide(color: Color(0xFFCBD5E1)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            if (_testResult != null) ...[
              const SizedBox(width: 8),
              Chip(
                avatar: Icon(
                  _testResult! ? Icons.check_circle : Icons.cancel,
                  color: Colors.white,
                  size: 16,
                ),
                backgroundColor:
                    _testResult! ? AppColors.success : AppColors.danger,
                label: Text(
                  _testResult! ? 'متاح' : 'غير متاح',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        const Text(
          'تطبيق إدارة كروت وطباعة شبكات الميكروتك (MikroManager Pro)',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 4),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Icon(Icons.code, size: 14, color: AppColors.cyanAccent),
            const SizedBox(width: 6),
            Text(
              'تطوير: عبدالرحمن المنجر (Abdulrahman Al-Menajer)',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.navyPrimary.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final ip = _ipController.text.trim();
    final port = int.tryParse(_portController.text.trim()) ?? 8728;
    final username = _userController.text.trim();
    final password = _passController.text;
    final routerName = _nameController.text.trim();

    // Port & TLS security policy check: require confirmation if connecting over public IP unencrypted
    final isPrivate = AppValidators.isPrivateOrLoopbackHost(ip);
    if (!isPrivate && !_useSsl && mounted) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.security, color: AppColors.danger),
              SizedBox(width: 8),
              Text('تحذير أمني: اتصال غير مشفر'),
            ],
          ),
          content: Text(
            'العنوان ($ip) ليس عنوان شبكة داخلية خاصة (RFC 1918).\n\n'
            'الاتصال عبر المنفذ $port غير المشفر عبر الإنترنت العام يعرض بيانات الدخول لاعتراض المتسللين.\n\n'
            'هل ترغب بالمتابعة على مسؤوليتك أو التبديل إلى المنفذ 8729 المشفر (API-SSL)؟',
            style: const TextStyle(fontSize: 13),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(false);
                setState(() {
                  _portController.text = '8729';
                  _useSsl = true;
                });
              },
              child: const Text('التبديل إلى 8729 (SSL)'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              style:
                  ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
              child: const Text('متابعة بدون تشفير',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );

      if (confirm != true) return;
    }

    final success = await ref.read(sessionControllerProvider.notifier).login(
          host: ip,
          port: port,
          username: username,
          password: password,
          useSsl: _useSsl,
          acceptSelfSigned: _acceptSelfSigned,
          useRest: _useRest,
          label: routerName.isNotEmpty ? routerName : null,
          rememberMe: _rememberMe,
          existingConnectionId: _selectedSavedRouterId,
        );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ تم الاتصال وتسجيل الدخول بالراوتر بنجاح!'),
          backgroundColor: AppColors.success,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _handleTestPing() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isTesting = true;
      _testResult = null;
    });

    final ip = _ipController.text.trim();
    final port = int.tryParse(_portController.text.trim()) ?? 8728;
    final username = _userController.text.trim();
    final password = _passController.text;

    final ok =
        await ref.read(routersControllerProvider.notifier).testConnection(
              ipAddress: ip,
              apiPort: port,
              username: username,
              password: password,
              useSsl: _useSsl,
              useRestApi: _useRest,
            );

    if (mounted) {
      setState(() {
        _isTesting = false;
        _testResult = ok;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ok
                ? '✅ منفذ الراوتر والاتصال متاح بنجاح!'
                : '❌ تعذر الوصول إلى المنفذ $port على $ip',
          ),
          backgroundColor: ok ? AppColors.success : AppColors.danger,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
