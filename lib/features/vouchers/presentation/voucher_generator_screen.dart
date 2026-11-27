import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/database/app_database.dart';
import '../../hotspot/domain/hotspot_notifier.dart';
import '../../routers/domain/routers_notifier.dart';
import '../../userman/domain/userman_notifier.dart';
import '../domain/unified_card_model.dart';
import '../domain/voucher_generator_engine.dart';
import '../domain/vouchers_notifier.dart';

class VoucherGeneratorScreen extends ConsumerStatefulWidget {
  final bool initialIsUserManager;

  const VoucherGeneratorScreen({
    super.key,
    this.initialIsUserManager = false,
  });

  @override
  ConsumerState<VoucherGeneratorScreen> createState() =>
      _VoucherGeneratorScreenState();
}

class _VoucherGeneratorScreenState extends ConsumerState<VoucherGeneratorScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _formKey = GlobalKey<FormState>();
  final _quantityCtrl = TextEditingController(text: '20');
  final _prefixCtrl = TextEditingController(text: '');
  final _priceCtrl = TextEditingController(text: '500');
  final _netNameCtrl = TextEditingController(text: 'MikroManager Hotspot');

  // Serial Number controls
  bool _enableSerial = false;
  final _serialPrefixCtrl = TextEditingController(text: 'SN-');
  final _serialStartCtrl = TextEditingController(text: '1');
  int _serialPadding = 4;

  int _codeLength = 6;
  int _passwordLength = 4;
  VoucherCodeType _codeType = VoucherCodeType.numeric;
  CredentialMode _credentialMode = CredentialMode.identical;
  bool _uploadToRouter = true;
  late bool _isUserManager;
  String _selectedProfile = 'default';

  @override
  void initState() {
    super.initState();
    _isUserManager = widget.initialIsUserManager;
    _tabController = TabController(length: 2, vsync: this);

    // Auto-fetch next serial number
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initSuggestedSerial();
    });
  }

  Future<void> _initSuggestedSerial() async {
    final activeRouter = ref.read(routersControllerProvider).activeRouter;
    if (activeRouter != null) {
      final repo = ref.read(vouchersRepositoryProvider);
      final lastSerial = await repo.getLastSerialEnd(activeRouter.id);
      if (lastSerial != null && mounted) {
        setState(() {
          _serialStartCtrl.text = (lastSerial + 1).toString();
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _quantityCtrl.dispose();
    _prefixCtrl.dispose();
    _priceCtrl.dispose();
    _netNameCtrl.dispose();
    _serialPrefixCtrl.dispose();
    _serialStartCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final voucherState = ref.watch(vouchersControllerProvider);
    final hotspotState = ref.watch(hotspotControllerProvider);
    final usermanState = ref.watch(usermanControllerProvider);
    final batchesAsync = ref.watch(voucherBatchesStreamProvider);
    final activeRouter = ref.watch(routersControllerProvider).activeRouter;

    // Strict profile resolution per system type
    if (_isUserManager) {
      if (usermanState.parsedProfiles.isNotEmpty &&
          !usermanState.parsedProfiles.any((p) => p.name == _selectedProfile)) {
        _selectedProfile = usermanState.parsedProfiles.first.name;
        if (usermanState.parsedProfiles.first.price > 0 &&
            _priceCtrl.text == '500') {
          _priceCtrl.text =
              usermanState.parsedProfiles.first.price.toStringAsFixed(0);
        }
      }
    } else {
      if (hotspotState.profiles.isNotEmpty &&
          !hotspotState.profiles.any((p) => p['name'] == _selectedProfile)) {
        _selectedProfile =
            hotspotState.profiles.first['name']?.toString() ?? 'default';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_isUserManager
            ? 'توليد كروت User Manager'
            : 'توليد كروت Hotspot'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: _isUserManager
              ? const Color(0xFF8B5CF6)
              : AppColors.cyanAccent,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(
                icon: Icon(Icons.generating_tokens_outlined),
                text: 'توليد دفعة جديدة'),
            Tab(
                icon: Icon(Icons.history_outlined),
                text: 'سجل الدفعات المولدة'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.palette_outlined),
            tooltip: 'معرض القوالب',
            onPressed: () => context.push('/templates'),
          ),
          if (voucherState.currentVouchers.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.print),
              tooltip: 'معاينة الطباعة',
              onPressed: () => context.push('/print-preview'),
            ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Generator Form
          _buildGeneratorForm(
              voucherState, hotspotState, usermanState, activeRouter),
          // Tab 2: Batches History
          _buildBatchesHistory(batchesAsync),
        ],
      ),
    );
  }

  Widget _buildGeneratorForm(
    VoucherGeneratorState voucherState,
    HotspotState hotspotState,
    UsermanState usermanState,
    RoutersTableData? activeRouter,
  ) {
    final systemColor =
        _isUserManager ? const Color(0xFF8B5CF6) : AppColors.cyanAccent;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status banner if any
            if (voucherState.message != null)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.success),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: AppColors.success),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        voucherState.message!,
                        style: const TextStyle(
                            color: AppColors.success,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                      ),
                      onPressed: () => context.push('/print-preview'),
                      child: const Text('معاينة وطباعة',
                          style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ),

            if (voucherState.errorMessage != null)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.danger.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.danger),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error, color: AppColors.danger),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        voucherState.errorMessage!,
                        style: const TextStyle(
                            color: AppColors.danger,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),

            // SECTION 1: System Selector & Active Router Header
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: systemColor.withValues(alpha: 0.4), width: 1.5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('نظام الكروت والراوتر:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14)),
                        if (activeRouter != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.navyPrimary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'الراوتر: ${activeRouter.name}${activeRouter.routerOsVersion != null ? " (${activeRouter.routerOsVersion})" : ""}',
                              style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.navyPrimary),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _isUserManager = false;
                                _netNameCtrl.text = 'MikroManager Hotspot';
                                if (hotspotState.profiles.isNotEmpty) {
                                  _selectedProfile = hotspotState
                                          .profiles.first['name']
                                          ?.toString() ??
                                      'default';
                                }
                              });
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: !_isUserManager
                                    ? AppColors.cyanAccent.withValues(alpha: 0.15)
                                    : Colors.grey.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: !_isUserManager
                                      ? AppColors.cyanAccent
                                      : Colors.transparent,
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.wifi_tethering,
                                      size: 20,
                                      color: !_isUserManager
                                          ? AppColors.cyanAccent
                                          : AppColors.textSecondary),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Hotspot',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: !_isUserManager
                                          ? AppColors.cyanAccent
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _isUserManager = true;
                                _netNameCtrl.text = 'MikroManager User Manager';
                                if (usermanState.parsedProfiles.isNotEmpty) {
                                  final first = usermanState.parsedProfiles.first;
                                  _selectedProfile = first.name;
                                  if (first.price > 0) {
                                    _priceCtrl.text =
                                        first.price.toStringAsFixed(0);
                                  }
                                }
                              });
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: _isUserManager
                                    ? const Color(0xFF8B5CF6).withValues(alpha: 0.15)
                                    : Colors.grey.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: _isUserManager
                                      ? const Color(0xFF8B5CF6)
                                      : Colors.transparent,
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.manage_accounts,
                                      size: 20,
                                      color: _isUserManager
                                          ? const Color(0xFF8B5CF6)
                                          : AppColors.textSecondary),
                                  const SizedBox(width: 8),
                                  Text(
                                    'User Manager',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: _isUserManager
                                          ? const Color(0xFF8B5CF6)
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // SECTION 2: Network & Profile Info (Strictly isolated)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isUserManager
                          ? 'بيانات شبكة وبروفايل User Manager'
                          : 'بيانات شبكة وبروفايل Hotspot',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _netNameCtrl,
                      decoration: const InputDecoration(
                        labelText: 'اسم الشبكة (يظهر على الكرت)',
                        prefixIcon: Icon(Icons.wifi),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // User Manager empty diagnostic warning
                    if (_isUserManager && usermanState.parsedProfiles.isEmpty) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: AppColors.warning.withValues(alpha: 0.6)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.warning_amber_rounded,
                                    color: AppColors.warning, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    usermanState.diagnosticDetails ??
                                        'لم يتم العثور على بروفايلات في User Manager لهذا الراوتر',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.warning),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  onPressed: () {
                                    ref
                                        .read(usermanControllerProvider.notifier)
                                        .refreshFromRouter();
                                  },
                                  icon: const Icon(Icons.refresh, size: 16),
                                  label: const Text('تحديث من الراوتر',
                                      style: TextStyle(fontSize: 11)),
                                ),
                                const SizedBox(width: 8),
                                OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    visualDensity: VisualDensity.compact,
                                    foregroundColor: const Color(0xFFEC4899),
                                  ),
                                  onPressed: () => context.push('/um-diagnostic'),
                                  icon: const Icon(Icons.health_and_safety,
                                      size: 16),
                                  label: const Text('فحص صحة UM',
                                      style: TextStyle(fontSize: 11)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'البروفايل *',
                              prefixIcon: Icon(Icons.tune),
                            ),
                            value: _isUserManager
                                ? (usermanState.parsedProfiles
                                        .any((p) => p.name == _selectedProfile)
                                    ? _selectedProfile
                                    : null)
                                : (hotspotState.profiles.any(
                                        (p) => p['name'] == _selectedProfile)
                                    ? _selectedProfile
                                    : null),
                            hint: const Text('اختر البروفايل'),
                            items: _isUserManager
                                ? (usermanState.parsedProfiles.isEmpty
                                    ? [
                                        const DropdownMenuItem(
                                            value: 'default',
                                            child: Text('default'))
                                      ]
                                    : usermanState.parsedProfiles.map((p) {
                                        return DropdownMenuItem(
                                            value: p.name,
                                            child: Text(
                                                '${p.displayName} (${p.price.toStringAsFixed(0)} YER)'));
                                      }).toList())
                                : (hotspotState.profiles.isEmpty
                                    ? [
                                        const DropdownMenuItem(
                                            value: 'default',
                                            child: Text('default'))
                                      ]
                                    : hotspotState.profiles.map((p) {
                                        final name =
                                            p['name']?.toString() ?? 'default';
                                        return DropdownMenuItem(
                                            value: name, child: Text(name));
                                      }).toList()),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  _selectedProfile = val;
                                  if (_isUserManager) {
                                    final match = usermanState.parsedProfiles
                                        .where((p) => p.name == val);
                                    if (match.isNotEmpty &&
                                        match.first.price > 0) {
                                      _priceCtrl.text =
                                          match.first.price.toStringAsFixed(0);
                                    }
                                  }
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _priceCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'سعر الكرت *',
                              prefixIcon: Icon(Icons.attach_money),
                            ),
                            validator: (val) =>
                                val == null || val.isEmpty ? 'مطلوب' : null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // SECTION 3: Voucher Code Properties
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('خصائص كود الكرت',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _quantityCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'عدد الكروت *',
                              prefixIcon: Icon(Icons.tag),
                            ),
                            validator: (val) {
                              final q = int.tryParse(val ?? '');
                              if (q == null || q <= 0) {
                                return 'أدخل عدداً صحيحاً';
                              }
                              if (q > 500) {
                                return 'الحد الأقصى 500 كرت بالدفعة';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _prefixCtrl,
                            decoration: const InputDecoration(
                              labelText: 'بادئة الكود (اختياري)',
                              hintText: 'مثال: 77 أو A-',
                              prefixIcon: Icon(Icons.short_text),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            decoration: const InputDecoration(
                              labelText: 'طول الكود',
                              prefixIcon: Icon(Icons.straighten),
                            ),
                            value: _codeLength,
                            items: const [
                              DropdownMenuItem(
                                  value: 4, child: Text('4 خانات')),
                              DropdownMenuItem(
                                  value: 6, child: Text('6 خانات (مستحسن)')),
                              DropdownMenuItem(
                                  value: 8, child: Text('8 خانات')),
                              DropdownMenuItem(
                                  value: 10, child: Text('10 خانات')),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => _codeLength = val);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<VoucherCodeType>(
                            decoration: const InputDecoration(
                              labelText: 'نوع المحارف',
                              prefixIcon: Icon(Icons.password),
                            ),
                            value: _codeType,
                            items: const [
                              DropdownMenuItem(
                                  value: VoucherCodeType.numeric,
                                  child: Text('أرقام فقط (0-9)')),
                              DropdownMenuItem(
                                  value: VoucherCodeType.alphanumeric,
                                  child: Text('أرقام وحروف إنجليزية')),
                              DropdownMenuItem(
                                  value: VoucherCodeType.alphaUpper,
                                  child: Text('حروف فقط (A-Z)')),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _codeType = val);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text('نمط بيانات الدخول (الحساب):',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ChoiceChip(
                          label: const Text('متطابقان (اسم = كلمة سر)'),
                          selected: _credentialMode == CredentialMode.identical,
                          selectedColor: systemColor,
                          labelStyle: TextStyle(
                            color: _credentialMode == CredentialMode.identical
                                ? Colors.white
                                : AppColors.textPrimary,
                            fontSize: 11,
                          ),
                          onSelected: (_) => setState(
                              () => _credentialMode = CredentialMode.identical),
                        ),
                        ChoiceChip(
                          label: const Text('اسم مستخدم فقط'),
                          selected:
                              _credentialMode == CredentialMode.usernameOnly,
                          selectedColor: systemColor,
                          labelStyle: TextStyle(
                            color:
                                _credentialMode == CredentialMode.usernameOnly
                                    ? Colors.white
                                    : AppColors.textPrimary,
                            fontSize: 11,
                          ),
                          onSelected: (_) => setState(() =>
                              _credentialMode = CredentialMode.usernameOnly),
                        ),
                        ChoiceChip(
                          label: const Text('اسم + كلمة سر منفصلة'),
                          selected: _credentialMode ==
                              CredentialMode.usernameAndPassword,
                          selectedColor: systemColor,
                          labelStyle: TextStyle(
                            color: _credentialMode ==
                                    CredentialMode.usernameAndPassword
                                ? Colors.white
                                : AppColors.textPrimary,
                            fontSize: 11,
                          ),
                          onSelected: (_) => setState(() => _credentialMode =
                              CredentialMode.usernameAndPassword),
                        ),
                      ],
                    ),
                    if (_credentialMode ==
                        CredentialMode.usernameAndPassword) ...[
                      const SizedBox(height: 10),
                      DropdownButtonFormField<int>(
                        decoration: const InputDecoration(
                          labelText: 'طول كلمة السر المنفصلة',
                          prefixIcon: Icon(Icons.pin),
                        ),
                        value: _passwordLength,
                        items: const [
                          DropdownMenuItem(
                              value: 4, child: Text('4 أرقام (سريع وسهل)')),
                          DropdownMenuItem(value: 6, child: Text('6 أرقام')),
                          DropdownMenuItem(value: 8, child: Text('8 أرقام')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _passwordLength = val);
                          }
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // SECTION 4: Serial Numbers Settings
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('الأرقام التسلسلية للكروت (Serial)',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        Switch(
                          value: _enableSerial,
                          activeColor: systemColor,
                          onChanged: (val) =>
                              setState(() => _enableSerial = val),
                        ),
                      ],
                    ),
                    if (_enableSerial) ...[
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _serialPrefixCtrl,
                              decoration: const InputDecoration(
                                labelText: 'بادئة التسلسل',
                                hintText: 'مثال: SN-',
                                prefixIcon: Icon(Icons.confirmation_number),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: _serialStartCtrl,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'رقم البداية',
                                prefixIcon: Icon(Icons.format_list_numbered),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              decoration: const InputDecoration(
                                labelText: 'الخانات',
                              ),
                              value: _serialPadding,
                              items: const [
                                DropdownMenuItem(value: 3, child: Text('001')),
                                DropdownMenuItem(value: 4, child: Text('0001')),
                                DropdownMenuItem(value: 5, child: Text('00001')),
                                DropdownMenuItem(value: 6, child: Text('000001')),
                              ],
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _serialPadding = val);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'مثال: ${_serialPrefixCtrl.text}${int.tryParse(_serialStartCtrl.text.trim())?.toString().padLeft(_serialPadding, "0") ?? "0001"}',
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // SECTION 5: Router Destination Switch
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('وجهة الرفع والمزامنة',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                          'رفع الكروت مباشرة إلى الراوتر عند التوليد'),
                      subtitle: Text(
                        _isUserManager
                            ? 'إضافة المستخدمين إلى سيرفر User Manager'
                            : 'إضافة المستخدمين إلى سيرفر Hotspot',
                      ),
                      value: _uploadToRouter,
                      activeColor: systemColor,
                      onChanged: (val) => setState(() => _uploadToRouter = val),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Action Buttons: Pre-Commit Preview + Direct Generate
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: systemColor, width: 1.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: voucherState.isGenerating
                        ? null
                        : _previewDraftBeforeCommit,
                    icon: Icon(Icons.remove_red_eye_outlined,
                        color: systemColor),
                    label: Text(
                      'معاينة قبل الاعتماد',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: systemColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: systemColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed:
                        voucherState.isGenerating ? null : _submitGenerate,
                    icon: voucherState.isGenerating
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2),
                          )
                        : const Icon(Icons.flash_on),
                    label: Text(
                      voucherState.isGenerating
                          ? 'جاري التوليد...'
                          : 'توليد واعتماد فوراً',
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _previewDraftBeforeCommit() {
    if (!_formKey.currentState!.validate()) return;

    final quantity = int.parse(_quantityCtrl.text.trim());
    final price = double.tryParse(_priceCtrl.text.trim()) ?? 0.0;
    final prefix = _prefixCtrl.text.trim();
    final netName = _netNameCtrl.text.trim();
    final serialStart = int.tryParse(_serialStartCtrl.text.trim()) ?? 1;

    final selectedRouter = ref.read(routersControllerProvider).activeRouter;
    final isRosV7 = selectedRouter?.routerOsVersion?.startsWith('7') ?? false;
    final systemType = _isUserManager
        ? (isRosV7 ? CardSystemType.usermanV7 : CardSystemType.usermanV6)
        : CardSystemType.hotspot;

    ref.read(vouchersControllerProvider.notifier).generateDraftVouchers(
          quantity: quantity,
          profile: _selectedProfile,
          price: price,
          prefix: prefix,
          codeLength: _codeLength,
          codeType: _codeType,
          credentialMode: _credentialMode,
          passwordLength: _passwordLength,
          networkName: netName.isNotEmpty
              ? netName
              : (_isUserManager
                  ? 'MikroManager User Manager'
                  : 'MikroManager Hotspot'),
          enableSerial: _enableSerial,
          serialPrefix: _serialPrefixCtrl.text.trim(),
          serialStart: serialStart,
          serialPadding: _serialPadding,
          isUserManager: _isUserManager,
          systemType: systemType,
          notes: null,
        );

    context.push('/print-preview');
  }

  Widget _buildBatchesHistory(
      AsyncValue<List<VoucherBatchesTableData>> batchesAsync) {
    return batchesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('خطأ في تحميل الدفعات: $e')),
      data: (batches) {
        if (batches.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history_toggle_off,
                    size: 64,
                    color: AppColors.textSecondary.withValues(alpha: 0.5)),
                const SizedBox(height: 12),
                const Text('لا توجد دفعات كروت سابقة',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 8),
                const Text(
                    'قم بتوليد دفعة جديدة وستظهر هنا تلقائياً للجرد وإعادة الطباعة',
                    style: TextStyle(color: AppColors.textSecondary)),
              ],
            ),
          );
        }

        final dateFormat = DateFormat('yyyy/MM/dd HH:mm');

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: batches.length,
          itemBuilder: (context, index) {
            final batch = batches[index];
            final dateStr = dateFormat.format(batch.generatedAt);
            final isUmBatch = batch.systemType.contains('userman');
            final badgeColor =
                isUmBatch ? const Color(0xFF8B5CF6) : AppColors.cyanAccent;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: badgeColor.withValues(alpha: 0.12),
                          child: Text('#${batch.id}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: badgeColor)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '${batch.quantity} كرت - ${batch.profileName}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: badgeColor.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      isUmBatch ? 'User Manager' : 'Hotspot',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: badgeColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(dateStr,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary)),
                              if (batch.serialPrefix != null &&
                                  batch.serialStart != null &&
                                  batch.serialEnd != null) ...[
                                const SizedBox(height: 2),
                                Text(
                                  'الأرقام: ${batch.serialPrefix}${batch.serialStart} - ${batch.serialPrefix}${batch.serialEnd}',
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textSecondary),
                                ),
                              ],
                            ],
                          ),
                        ),
                        Text(
                          '${batch.totalAmount.toStringAsFixed(0)} ر.ي',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: badgeColor,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'سعر الكرت: ${batch.unitPrice.toStringAsFixed(0)} | الطول: ${batch.codeLength}'
                          '${batch.prefix.isNotEmpty ? " | بادئة: ${batch.prefix}" : ""}',
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.textSecondary),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.print_outlined,
                                  color: badgeColor),
                              tooltip: 'معاينة وطباعة هذه الدفعة',
                              onPressed: () {
                                ref
                                    .read(vouchersControllerProvider.notifier)
                                    .loadFromBatch(batch);
                                context.push('/print-preview');
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: AppColors.danger),
                              tooltip: 'حذف من السجل',
                              onPressed: () =>
                                  _confirmDeleteBatch(context, batch.id),
                            ),
                          ],
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
    );
  }

  void _submitGenerate() async {
    if (!_formKey.currentState!.validate()) return;

    final quantity = int.parse(_quantityCtrl.text.trim());
    final price = double.tryParse(_priceCtrl.text.trim()) ?? 0.0;
    final prefix = _prefixCtrl.text.trim();
    final netName = _netNameCtrl.text.trim();
    final totalAmount = quantity * price;
    final serialStart = int.tryParse(_serialStartCtrl.text.trim()) ?? 1;

    String modeText = 'اسم مستخدم وكلمة مرور متطابقان';
    if (_credentialMode == CredentialMode.usernameOnly) {
      modeText = 'اسم مستخدم فقط (بدون كلمة مرور)';
    } else if (_credentialMode == CredentialMode.usernameAndPassword) {
      modeText = 'اسم مستخدم + كلمة مرور منفصلة ($_passwordLength أرقام)';
    }

    final systemName = _isUserManager ? 'User Manager' : 'Hotspot';

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.assignment_outlined, color: AppColors.cyanAccent),
            const SizedBox(width: 8),
            Text('تأكيد توليد كروت $systemName'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• النظام: $systemName'),
            const SizedBox(height: 4),
            Text('• عدد الكروت: $quantity كرت'),
            const SizedBox(height: 4),
            Text('• البروفايل: $_selectedProfile'),
            const SizedBox(height: 4),
            Text('• السعر الإجمالي: $totalAmount ريال'),
            const SizedBox(height: 4),
            Text('• نمط الدخول: $modeText'),
            if (_enableSerial) ...[
              const SizedBox(height: 4),
              Text('• الأرقام التسلسلية: مفعّلة (${_serialPrefixCtrl.text}$serialStart)'),
            ],
            const SizedBox(height: 4),
            Text('• الوجهة: ${_uploadToRouter ? "رفع إلى الراوتر فوراً" : "محلياً فقط"}'),
            const Divider(height: 20),
            const Text(
              'هل ترغب في بدء التوليد الآن؟',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('إلغاء')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: _isUserManager
                    ? const Color(0xFF8B5CF6)
                    : AppColors.cyanAccent,
                foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('تأكيد وبدء التوليد'),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    final future = ref
        .read(vouchersControllerProvider.notifier)
        .generateAndSave(
          quantity: quantity,
          profile: _selectedProfile,
          price: price,
          prefix: prefix,
          codeLength: _codeLength,
          codeType: _codeType,
          credentialMode: _credentialMode,
          passwordLength: _passwordLength,
          uploadToRouter: _uploadToRouter,
          isUserManager: _isUserManager,
          systemType: _isUserManager
              ? CardSystemType.usermanV7
              : CardSystemType.hotspot,
          networkName: netName.isNotEmpty
              ? netName
              : (_isUserManager
                  ? 'MikroManager User Manager'
                  : 'MikroManager Hotspot'),
          enableSerial: _enableSerial,
          serialPrefix: _serialPrefixCtrl.text.trim(),
          serialStart: serialStart,
          serialPadding: _serialPadding,
        );

    if (_uploadToRouter && mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogCtx) => Consumer(
          builder: (context, ref, _) {
            final state = ref.watch(vouchersControllerProvider);
            if (!state.isGenerating && !state.isUploading) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (Navigator.canPop(dialogCtx)) Navigator.pop(dialogCtx);
              });
            }

            return AlertDialog(
              title: Text('جاري رفع الكروت إلى $systemName'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LinearProgressIndicator(
                      value: state.uploadProgress > 0
                          ? state.uploadProgress
                          : null),
                  const SizedBox(height: 16),
                  Text(
                      'تم رفع ${state.uploadedCount} من أصل ${state.totalCount} كرت...'),
                  if (state.isCancelled)
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text('جاري إيقاف العملية...',
                          style: TextStyle(color: AppColors.warning)),
                    ),
                ],
              ),
              actions: [
                if (!state.isCancelled)
                  TextButton(
                    onPressed: () => ref
                        .read(vouchersControllerProvider.notifier)
                        .cancelGeneration(),
                    child: const Text('إلغاء العملية',
                        style: TextStyle(color: AppColors.danger)),
                  ),
              ],
            );
          },
        ),
      );
    }

    final success = await future;
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('🎉 تم توليد الدفعة بنجاح! يمكنك الآن معاينتها وطباعتها.'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  void _confirmDeleteBatch(BuildContext context, int batchId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد حذف الدفعة'),
        content:
            Text('هل أنت متأكد من حذف الدفعة رقم #$batchId من السجل المحلي؟'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () async {
              await ref
                  .read(vouchersControllerProvider.notifier)
                  .deleteBatch(batchId);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('حذف الدفعة'),
          ),
        ],
      ),
    );
  }
}
