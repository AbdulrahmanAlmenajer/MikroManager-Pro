import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/database/app_database.dart';
import '../../hotspot/domain/hotspot_notifier.dart';
import '../domain/voucher_generator_engine.dart';
import '../domain/vouchers_notifier.dart';

class VoucherGeneratorScreen extends ConsumerStatefulWidget {
  const VoucherGeneratorScreen({super.key});

  @override
  ConsumerState<VoucherGeneratorScreen> createState() => _VoucherGeneratorScreenState();
}

class _VoucherGeneratorScreenState extends ConsumerState<VoucherGeneratorScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _formKey = GlobalKey<FormState>();
  final _quantityCtrl = TextEditingController(text: '20');
  final _prefixCtrl = TextEditingController(text: '');
  final _priceCtrl = TextEditingController(text: '500');
  final _netNameCtrl = TextEditingController(text: 'MikroManager Hotspot');

  int _codeLength = 6;
  int _passwordLength = 4;
  VoucherCodeType _codeType = VoucherCodeType.numeric;
  CredentialMode _credentialMode = CredentialMode.identical;
  bool _uploadToRouter = true;
  bool _isUserManager = false;
  String _selectedProfile = 'default';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _quantityCtrl.dispose();
    _prefixCtrl.dispose();
    _priceCtrl.dispose();
    _netNameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final voucherState = ref.watch(vouchersControllerProvider);
    final hotspotState = ref.watch(hotspotControllerProvider);
    final batchesAsync = ref.watch(voucherBatchesStreamProvider);

    // Update profile if available
    if (hotspotState.profiles.isNotEmpty && _selectedProfile == 'default') {
      _selectedProfile = hotspotState.profiles.first['name']?.toString() ?? 'default';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('توليد وطباعة الكروت'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.cyanAccent,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.generating_tokens_outlined), text: 'توليد دفعة جديدة'),
            Tab(icon: Icon(Icons.history_outlined), text: 'سجل الدفعات المولدة'),
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
          _buildGeneratorForm(voucherState, hotspotState),
          // Tab 2: Batches History
          _buildBatchesHistory(batchesAsync),
        ],
      ),
    );
  }

  Widget _buildGeneratorForm(VoucherGeneratorState voucherState, HotspotState hotspotState) {
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
                        style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      onPressed: () => context.push('/print-preview'),
                      child: const Text('معاينة وطباعة', style: TextStyle(fontSize: 12)),
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
                        style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),

            // Card 1: Network & Profile Info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('بيانات الشبكة والبروفايل',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _netNameCtrl,
                      decoration: const InputDecoration(
                        labelText: 'اسم الشبكة (يظهر على الكرت)',
                        prefixIcon: Icon(Icons.wifi),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'البروفايل *',
                              prefixIcon: Icon(Icons.tune),
                            ),
                            value: hotspotState.profiles.any((p) => p['name'] == _selectedProfile)
                                ? _selectedProfile
                                : null,
                            hint: const Text('اختر البروفايل'),
                            items: hotspotState.profiles.isEmpty
                                ? [const DropdownMenuItem(value: 'default', child: Text('default'))]
                                : hotspotState.profiles.map((p) {
                                    final name = p['name']?.toString() ?? 'default';
                                    return DropdownMenuItem(value: name, child: Text(name));
                                  }).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedProfile = val);
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
                            validator: (val) => val == null || val.isEmpty ? 'مطلوب' : null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Card 2: Voucher Quantity and Code Settings
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('خصائص كود الكرت',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
                              if (q == null || q <= 0) return 'أدخل عدداً صحيحاً';
                              if (q > 500) return 'الحد الأقصى 500 كرت بالدفعة';
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
                              DropdownMenuItem(value: 4, child: Text('4 خانات')),
                              DropdownMenuItem(value: 6, child: Text('6 خانات (مستحسن)')),
                              DropdownMenuItem(value: 8, child: Text('8 خانات')),
                              DropdownMenuItem(value: 10, child: Text('10 خانات')),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _codeLength = val);
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
                              DropdownMenuItem(value: VoucherCodeType.numeric, child: Text('أرقام فقط (0-9)')),
                              DropdownMenuItem(value: VoucherCodeType.alphanumeric, child: Text('أرقام وحروف إنجليزية')),
                              DropdownMenuItem(value: VoucherCodeType.alphaUpper, child: Text('حروف فقط (A-Z)')),
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
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ChoiceChip(
                          label: const Text('متطابقان (اسم = كلمة سر)'),
                          selected: _credentialMode == CredentialMode.identical,
                          selectedColor: AppColors.cyanAccent,
                          labelStyle: TextStyle(
                            color: _credentialMode == CredentialMode.identical ? Colors.white : AppColors.textPrimary,
                            fontSize: 11,
                          ),
                          onSelected: (_) => setState(() => _credentialMode = CredentialMode.identical),
                        ),
                        ChoiceChip(
                          label: const Text('اسم مستخدم فقط'),
                          selected: _credentialMode == CredentialMode.usernameOnly,
                          selectedColor: AppColors.cyanAccent,
                          labelStyle: TextStyle(
                            color: _credentialMode == CredentialMode.usernameOnly ? Colors.white : AppColors.textPrimary,
                            fontSize: 11,
                          ),
                          onSelected: (_) => setState(() => _credentialMode = CredentialMode.usernameOnly),
                        ),
                        ChoiceChip(
                          label: const Text('اسم + كلمة سر منفصلة'),
                          selected: _credentialMode == CredentialMode.usernameAndPassword,
                          selectedColor: AppColors.cyanAccent,
                          labelStyle: TextStyle(
                            color: _credentialMode == CredentialMode.usernameAndPassword ? Colors.white : AppColors.textPrimary,
                            fontSize: 11,
                          ),
                          onSelected: (_) => setState(() => _credentialMode = CredentialMode.usernameAndPassword),
                        ),
                      ],
                    ),
                    if (_credentialMode == CredentialMode.usernameAndPassword) ...[
                      const SizedBox(height: 10),
                      DropdownButtonFormField<int>(
                        decoration: const InputDecoration(
                          labelText: 'طول كلمة السر المنفصلة',
                          prefixIcon: Icon(Icons.pin),
                        ),
                        value: _passwordLength,
                        items: const [
                          DropdownMenuItem(value: 4, child: Text('4 أرقام (سريع وسهل)')),
                          DropdownMenuItem(value: 6, child: Text('6 أرقام')),
                          DropdownMenuItem(value: 8, child: Text('8 أرقام')),
                        ],
                        onChanged: (val) {
                          if (val != null) setState(() => _passwordLength = val);
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Card 3: Router Destination & Sync
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('وجهة الرفع والمزامنة',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('رفع الكروت مباشرة إلى الراوتر عند التوليد'),
                      subtitle: const Text('إضافة المستخدمين إلى سيرفر الميكروتك فوراً'),
                      value: _uploadToRouter,
                      onChanged: (val) => setState(() => _uploadToRouter = val),
                    ),
                    if (_uploadToRouter) ...[
                      const Divider(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<bool>(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('Hotspot', style: TextStyle(fontSize: 14)),
                              value: false,
                              groupValue: _isUserManager,
                              onChanged: (val) => setState(() => _isUserManager = val ?? false),
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<bool>(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('User Manager', style: TextStyle(fontSize: 14)),
                              value: true,
                              groupValue: _isUserManager,
                              onChanged: (val) => setState(() => _isUserManager = val ?? true),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Submit Buttons
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.cyanAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: voucherState.isGenerating ? null : _submitGenerate,
                icon: voucherState.isGenerating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Icon(Icons.flash_on),
                label: Text(
                  voucherState.isGenerating ? 'جاري التوليد والرفع...' : 'توليد الدفعة الآن',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBatchesHistory(AsyncValue<List<VoucherBatchesTableData>> batchesAsync) {
    return batchesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('خطأ في تحميل الدفعات: $e')),
      data: (batches) {
        if (batches.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history_toggle_off, size: 64, color: AppColors.textSecondary.withValues(alpha: 0.5)),
                const SizedBox(height: 12),
                const Text('لا توجد دفعات كروت سابقة',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const SizedBox(height: 8),
                const Text('قم بتوليد دفعة جديدة وستظهر هنا تلقائياً للجرد وإعادة الطباعة',
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
                          backgroundColor: AppColors.navyPrimary.withValues(alpha: 0.1),
                          child: Text('#${batch.id}',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.navyPrimary)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${batch.quantity} كرت - بروفايل: ${batch.profileName}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(dateStr, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                        Text(
                          '${batch.totalAmount.toStringAsFixed(0)} ر.ي',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.cyanAccent,
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
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.print_outlined, color: AppColors.cyanAccent),
                              tooltip: 'معاينة وطباعة هذه الدفعة',
                              onPressed: () {
                                ref.read(vouchersControllerProvider.notifier).loadFromBatch(batch);
                                context.push('/print-preview');
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: AppColors.danger),
                              tooltip: 'حذف من السجل',
                              onPressed: () => _confirmDeleteBatch(context, batch.id),
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

    String modeText = 'اسم مستخدم وكلمة مرور متطابقان';
    if (_credentialMode == CredentialMode.usernameOnly) {
      modeText = 'اسم مستخدم فقط (بدون كلمة مرور)';
    } else if (_credentialMode == CredentialMode.usernameAndPassword) {
      modeText = 'اسم مستخدم + كلمة مرور منفصلة ($_passwordLength أرقام)';
    }

    // 1. Pre-execution Summary Dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.assignment_outlined, color: AppColors.cyanAccent),
            SizedBox(width: 8),
            Text('ملخص عملية التوليد'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• عدد الكروت: $quantity كرت'),
            const SizedBox(height: 4),
            Text('• البروفايل: $_selectedProfile'),
            const SizedBox(height: 4),
            Text('• السعر الإجمالي: $totalAmount ريال'),
            const SizedBox(height: 4),
            Text('• نمط الدخول: $modeText'),
            const SizedBox(height: 4),
            Text('• الوجهة: ${_uploadToRouter ? (_isUserManager ? 'User Manager' : 'Hotspot') : 'محلياً فقط'}'),
            const Divider(height: 20),
            const Text(
              'هل ترغب في بدء التوليد والرفع إلى الراوتر الآن؟',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('إلغاء')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.cyanAccent, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('تأكيد وبدء التوليد'),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    // 2. Execute generation with progress and cancel support
    final future = ref.read(vouchersControllerProvider.notifier).generateAndSave(
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
          networkName: netName.isNotEmpty ? netName : 'MikroManager Hotspot',
        );

    // Show Progress Dialog
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
              title: const Text('جاري رفع الكروت إلى الراوتر'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LinearProgressIndicator(value: state.uploadProgress > 0 ? state.uploadProgress : null),
                  const SizedBox(height: 16),
                  Text('تم رفع ${state.uploadedCount} من أصل ${state.totalCount} كرت...'),
                  if (state.isCancelled)
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text('جاري إيقاف العملية...', style: TextStyle(color: AppColors.warning)),
                    ),
                ],
              ),
              actions: [
                if (!state.isCancelled)
                  TextButton(
                    onPressed: () => ref.read(vouchersControllerProvider.notifier).cancelGeneration(),
                    child: const Text('إلغاء العملية', style: TextStyle(color: AppColors.danger)),
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
          content: Text('🎉 تم توليد الدفعة بنجاح! يمكنك الآن معاينتها وطباعتها.'),
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
        content: Text('هل أنت متأكد من حذف الدفعة رقم #$batchId من السجل المحلي؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () async {
              await ref.read(vouchersControllerProvider.notifier).deleteBatch(batchId);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('حذف الدفعة'),
          ),
        ],
      ),
    );
  }
}
