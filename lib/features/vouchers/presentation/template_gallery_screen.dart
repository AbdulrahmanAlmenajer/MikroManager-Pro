import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';

final voucherTemplatesStreamProvider = StreamProvider<List<VoucherTemplatesTableData>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.voucherTemplatesTable).watch();
});

class TemplateGalleryScreen extends ConsumerWidget {
  const TemplateGalleryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templatesAsync = ref.watch(voucherTemplatesStreamProvider);
    final db = ref.read(databaseProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('معرض ومحرر قوالب الكروت'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'إضافة قالب جديد',
            onPressed: () => _openTemplateEditor(context, db, null),
          ),
        ],
      ),
      body: templatesAsync.when(
        data: (templates) {
          if (templates.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.palette_outlined, size: 64, color: AppColors.textSecondary),
                  const SizedBox(height: 16),
                  const Text('لا توجد قوالب محفوظة حالياً'),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _openTemplateEditor(context, db, null),
                    icon: const Icon(Icons.add),
                    label: const Text('إنشاء قالب جديد'),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 400,
              mainAxisExtent: 280,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: templates.length,
            itemBuilder: (context, index) {
              final template = templates[index];
              return _buildTemplateCard(context, db, template);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('خطأ في تحميل القوالب: $e')),
      ),
    );
  }

  Widget _buildTemplateCard(BuildContext context, AppDatabase db, VoucherTemplatesTableData template) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: template.isDefault ? AppColors.cyanAccent : Colors.transparent,
          width: template.isDefault ? 2 : 0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        template.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'الحجم: ${template.paperSize} | ${template.cardsPerRow} كروت بالصف',
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                if (template.isDefault)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.cyanAccent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text('افتراضي', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
            const SizedBox(height: 10),

            // Live Mini Preview of Card
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            template.headerText ?? 'شبكة الواي فاي',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.navyPrimary),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          const Text('المستخدم: 77123456', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                          const Text('كلمة السر: 9876', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                          const SizedBox(height: 4),
                          const Text('السعر: 200 ريال', style: TextStyle(fontSize: 10, color: AppColors.cyanAccent, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    if (template.showQrCode) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
                        child: QrImageView(
                          data: 'http://login?user=77123456&pass=9876',
                          size: 60,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!template.isDefault)
                  TextButton(
                    onPressed: () async {
                      // Set default
                      await (db.update(db.voucherTemplatesTable)).write(
                        const VoucherTemplatesTableCompanion(isDefault: drift.Value(false)),
                      );
                      await (db.update(db.voucherTemplatesTable)..where((t) => t.id.equals(template.id))).write(
                        const VoucherTemplatesTableCompanion(isDefault: drift.Value(true)),
                      );
                    },
                    style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                    child: const Text('تعيين كافتراضي', style: TextStyle(fontSize: 11)),
                  ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  tooltip: 'تعديل القالب',
                  onPressed: () => _openTemplateEditor(context, db, template),
                ),
                if (!template.isDefault)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.danger),
                    tooltip: 'حذف',
                    onPressed: () async {
                      await (db.delete(db.voucherTemplatesTable)..where((t) => t.id.equals(template.id))).go();
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openTemplateEditor(BuildContext context, AppDatabase db, VoucherTemplatesTableData? template) {
    showDialog(
      context: context,
      builder: (ctx) => _TemplateEditorDialog(db: db, initialTemplate: template),
    );
  }
}

class _TemplateEditorDialog extends StatefulWidget {
  final AppDatabase db;
  final VoucherTemplatesTableData? initialTemplate;

  const _TemplateEditorDialog({required this.db, this.initialTemplate});

  @override
  State<_TemplateEditorDialog> createState() => _TemplateEditorDialogState();
}

class _TemplateEditorDialogState extends State<_TemplateEditorDialog> {
  final _nameCtrl = TextEditingController();
  final _headerCtrl = TextEditingController();
  final _footerCtrl = TextEditingController();

  String _paperSize = 'A4';
  int _cardsPerRow = 3;
  int _cardsPerPage = 12;
  bool _showQr = true;

  @override
  void initState() {
    super.initState();
    if (widget.initialTemplate != null) {
      final t = widget.initialTemplate!;
      _nameCtrl.text = t.name;
      _headerCtrl.text = t.headerText ?? '';
      _footerCtrl.text = t.footerText ?? '';
      _paperSize = t.paperSize;
      _cardsPerRow = t.cardsPerRow;
      _cardsPerPage = t.cardsPerPage;
      _showQr = t.showQrCode;
    } else {
      _nameCtrl.text = 'قالب مخصص';
      _headerCtrl.text = 'شبكة الواي فاي السريعة';
      _footerCtrl.text = 'للدعم الفني اتصل على 777000000';
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _headerCtrl.dispose();
    _footerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialTemplate == null ? 'تصميم قالب كروت جديد' : 'تعديل قالب الكروت'),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 450,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'اسم القالب *'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _headerCtrl,
                decoration: const InputDecoration(labelText: 'عنوان رأس الكرت (اسم الشبكة)'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _footerCtrl,
                decoration: const InputDecoration(labelText: 'نص تذييل الكرت (رقم الدعم/ملاحظات)'),
              ),
              const SizedBox(height: 14),

              // Paper Size Dropdown
              DropdownButtonFormField<String>(
                value: _paperSize,
                decoration: const InputDecoration(labelText: 'حجم الورق'),
                items: const [
                  DropdownMenuItem(value: 'A4', child: Text('ورق عادي A4 (شبكة كروت)')),
                  DropdownMenuItem(value: '58mm', child: Text('طابعة حرارية 58mm (إيصال)')),
                  DropdownMenuItem(value: '80mm', child: Text('طابعة حرارية 80mm (إيصال)')),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _paperSize = val;
                      if (val == '58mm' || val == '80mm') {
                        _cardsPerRow = 1;
                        _cardsPerPage = 1;
                      } else {
                        _cardsPerRow = 3;
                        _cardsPerPage = 12;
                      }
                    });
                  }
                },
              ),
              const SizedBox(height: 12),

              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('إظهار رمز الاستجابة السريعة (QR Code)', style: TextStyle(fontSize: 13)),
                value: _showQr,
                onChanged: (val) => setState(() => _showQr = val),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: () async {
            final name = _nameCtrl.text.trim();
            if (name.isEmpty) return;

            if (widget.initialTemplate == null) {
              await widget.db.into(widget.db.voucherTemplatesTable).insert(
                VoucherTemplatesTableCompanion.insert(
                  name: name,
                  paperSize: drift.Value(_paperSize),
                  cardsPerRow: drift.Value(_cardsPerRow),
                  cardsPerPage: drift.Value(_cardsPerPage),
                  showQrCode: drift.Value(_showQr),
                  headerText: drift.Value(_headerCtrl.text.trim()),
                  footerText: drift.Value(_footerCtrl.text.trim()),
                ),
              );
            } else {
              await (widget.db.update(widget.db.voucherTemplatesTable)
                    ..where((t) => t.id.equals(widget.initialTemplate!.id)))
                  .write(
                VoucherTemplatesTableCompanion(
                  name: drift.Value(name),
                  paperSize: drift.Value(_paperSize),
                  cardsPerRow: drift.Value(_cardsPerRow),
                  cardsPerPage: drift.Value(_cardsPerPage),
                  showQrCode: drift.Value(_showQr),
                  headerText: drift.Value(_headerCtrl.text.trim()),
                  footerText: drift.Value(_footerCtrl.text.trim()),
                ),
              );
            }

            if (context.mounted) Navigator.pop(context);
          },
          child: const Text('حفظ القالب'),
        ),
      ],
    );
  }
}
