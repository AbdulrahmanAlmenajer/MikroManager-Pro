import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../domain/card_diagnosis_notifier.dart';

class CardInquiryScreen extends ConsumerStatefulWidget {
  final String? initialCardName;
  const CardInquiryScreen({super.key, this.initialCardName});

  @override
  ConsumerState<CardInquiryScreen> createState() => _CardInquiryScreenState();
}

class _CardInquiryScreenState extends ConsumerState<CardInquiryScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialCardName != null && widget.initialCardName!.isNotEmpty) {
      _searchController.text = widget.initialCardName!;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(cardDiagnosisProvider.notifier)
            .diagnose(widget.initialCardName!);
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _runDiagnosis() {
    final text = _searchController.text.trim();
    if (text.isEmpty) return;
    ref.read(cardDiagnosisProvider.notifier).diagnose(text);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cardDiagnosisProvider);
    final notifier = ref.read(cardDiagnosisProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('استعلام وتشخيص الكرت'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Search Input Card
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'أدخل اسم أو رقم الكرت للفحص الفوري:',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            textInputAction: TextInputAction.search,
                            onSubmitted: (_) => _runDiagnosis(),
                            decoration: InputDecoration(
                              hintText:
                                  'اسم الكرت أو الرقم التسلسلي (مثال: 77123456 أو SN-0001)',
                              prefixIcon: const Icon(
                                  Icons.confirmation_number_outlined),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear, size: 18),
                                      onPressed: () {
                                        _searchController.clear();
                                        setState(() {});
                                      },
                                    )
                                  : null,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 12),
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: state.isAnalyzing ? null : _runDiagnosis,
                          icon: state.isAnalyzing
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: Colors.white),
                                )
                              : const Icon(Icons.search),
                          label: const Text('فحص'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.cyanAccent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Error View
            if (state.errorMessage != null)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.danger.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppColors.danger.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.danger),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        state.errorMessage!,
                        style: const TextStyle(
                            color: AppColors.danger,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),

            // Loading View
            if (state.isAnalyzing) ...[
              const SizedBox(height: 40),
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                        'جاري فحص الكرت في جداول الهوتسبوت ومطابقة الجلسات...'),
                  ],
                ),
              ),
            ],

            // Result Card
            if (!state.isAnalyzing && state.result != null) ...[
              _buildDiagnosisResultCard(context, state, notifier),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDiagnosisResultCard(
    BuildContext context,
    CardDiagnosisState state,
    CardDiagnosisNotifier notifier,
  ) {
    final result = state.result!;
    final sub = result.subscriber;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Header
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: !result.exists
                      ? AppColors.danger.withValues(alpha: 0.15)
                      : (result.isCurrentlyActive
                          ? AppColors.success.withValues(alpha: 0.15)
                          : AppColors.cyanAccent.withValues(alpha: 0.15)),
                  child: Icon(
                    !result.exists
                        ? Icons.cancel
                        : (result.isCurrentlyActive
                            ? Icons.wifi
                            : Icons.check_circle_outline),
                    color: !result.exists
                        ? AppColors.danger
                        : (result.isCurrentlyActive
                            ? AppColors.success
                            : AppColors.cyanAccent),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'نتيجة الفحص: ${result.cardName}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        !result.exists
                            ? 'الكرت غير مسجل في الراوتر'
                            : (result.isCurrentlyActive
                                ? 'متصل حالياً بالشبكة'
                                : (sub?.isDisabled == true
                                    ? 'الكرت معطل'
                                    : 'الكرت مسجل ومفعل')),
                        style: TextStyle(
                          fontSize: 12,
                          color: !result.exists
                              ? AppColors.danger
                              : (result.isCurrentlyActive
                                  ? AppColors.success
                                  : AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),

            // Subscriber Details Table
            if (sub != null) ...[
              _buildDetailRow('البروفايل (الباقة)', sub.profile),
              _buildDetailRow('الحالة',
                  sub.isDisabled ? 'معطل (Disabled)' : 'مفعل (Enabled)'),
              _buildDetailRow('عنوان MAC المقيد',
                  sub.macAddress ?? 'غير مقيّد (متاح لأي جهاز)'),
              _buildDetailRow('المدة المستهلكة (Uptime)', sub.uptime ?? '0s'),
              if (sub.limitUptime != null)
                _buildDetailRow('أقصى مدة مسموحة', sub.limitUptime!),
              _buildDetailRow('استهلاك البيانات',
                  '${_formatBytes(sub.bytesIn + sub.bytesOut)} / ${_formatBytes(sub.limitBytesTotal)}'),
              if (result.isCurrentlyActive) ...[
                _buildDetailRow('IP الجلسة النشطة', result.activeIp ?? '-'),
                _buildDetailRow('MAC المتصل حالياً', result.activeMac ?? '-'),
              ],
              const Divider(height: 24),
            ],

            // Ranked Failure Reasons
            const Row(
              children: [
                Icon(Icons.help_outline, color: AppColors.warning, size: 20),
                SizedBox(width: 8),
                Text(
                  'تحليل سبب فشل الدخول أو حالة الكرت:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    result.rankedFailureReasons.asMap().entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${entry.key + 1}. ',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.cyanAccent),
                        ),
                        Expanded(
                          child: Text(
                            entry.value,
                            style: const TextStyle(fontSize: 13, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // Quick Resolution Actions
            if (sub != null) ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (sub.isDisabled)
                    ElevatedButton.icon(
                      onPressed: state.isActionInProgress
                          ? null
                          : () => notifier.reEnableCard(),
                      icon: const Icon(Icons.check, size: 16),
                      label: const Text('إعادة تفعيل الكرت'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                          foregroundColor: Colors.white),
                    ),
                  if (sub.macAddress != null && sub.macAddress!.isNotEmpty)
                    ElevatedButton.icon(
                      onPressed: state.isActionInProgress
                          ? null
                          : () => notifier.resetMac(),
                      icon: const Icon(Icons.link_off, size: 16),
                      label: const Text('فك قيد MAC'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.warning,
                          foregroundColor: Colors.white),
                    ),
                  if (result.isCurrentlyActive)
                    ElevatedButton.icon(
                      onPressed: state.isActionInProgress
                          ? null
                          : () => notifier.kickSession(),
                      icon: const Icon(Icons.power_settings_new, size: 16),
                      label: const Text('قطع الجلسة الحالية (Kick)'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.danger,
                          foregroundColor: Colors.white),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textSecondary)),
          Text(value,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  String _formatBytes(int bytes) {
    if (bytes <= 0) return '0 MB';
    final mb = bytes / (1024 * 1024);
    if (mb >= 1024) {
      return '${(mb / 1024).toStringAsFixed(2)} GB';
    }
    return '${mb.toStringAsFixed(1)} MB';
  }
}
