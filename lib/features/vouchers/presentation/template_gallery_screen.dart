import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';

final voucherTemplatesStreamProvider =
    StreamProvider<List<VoucherTemplatesTableData>>((ref) {
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
                  const Icon(Icons.palette_outlined,
                      size: 64, color: AppColors.textSecondary),
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

  Widget _buildTemplateCard(BuildContext context, AppDatabase db,
      VoucherTemplatesTableData template) {
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
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'الحجم: ${template.paperSize} | ${template.cardsPerRow} كروت بالصف',
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                if (template.isDefault)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.cyanAccent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text('افتراضي',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),
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
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: AppColors.navyPrimary),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          const Text('المستخدم: 77123456',
                              style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.bold)),
                          const Text('كلمة السر: 9876',
                              style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textSecondary)),
                          const SizedBox(height: 4),
                          const Text('السعر: 200 ريال',
                              style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.cyanAccent,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    if (template.showQrCode) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6)),
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
                        const VoucherTemplatesTableCompanion(
                            isDefault: drift.Value(false)),
                      );
                      await (db.update(db.voucherTemplatesTable)
                            ..where((t) => t.id.equals(template.id)))
                          .write(
                        const VoucherTemplatesTableCompanion(
                            isDefault: drift.Value(true)),
                      );
                    },
                    style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact),
                    child: const Text('تعيين كافتراضي',
                        style: TextStyle(fontSize: 11)),
                  ),
                IconButton(
                  icon: const Icon(Icons.copy_outlined, size: 18),
                  tooltip: 'استنساخ القالب',
                  onPressed: () async {
                    await db.into(db.voucherTemplatesTable).insert(
                          VoucherTemplatesTableCompanion.insert(
                            name: 'نسخة من ${template.name}',
                            paperSize: drift.Value(template.paperSize),
                            cardsPerRow: drift.Value(template.cardsPerRow),
                            cardsPerPage: drift.Value(template.cardsPerPage),
                            cardWidthMm: drift.Value(template.cardWidthMm),
                            cardHeightMm: drift.Value(template.cardHeightMm),
                            marginMm: drift.Value(template.marginMm),
                            fontSize: drift.Value(template.fontSize),
                            titleFontSize: drift.Value(template.titleFontSize),
                            primaryColorHex:
                                drift.Value(template.primaryColorHex),
                            backgroundColorHex:
                                drift.Value(template.backgroundColorHex),
                            textColorHex: drift.Value(template.textColorHex),
                            titleColorHex: drift.Value(template.titleColorHex),
                            borderColorHex:
                                drift.Value(template.borderColorHex),
                            borderWidth: drift.Value(template.borderWidth),
                            borderRadius: drift.Value(template.borderRadius),
                            showLogo: drift.Value(template.showLogo),
                            showQrCode: drift.Value(template.showQrCode),
                            showBarcode: drift.Value(template.showBarcode),
                            showProfile: drift.Value(template.showProfile),
                            showPrice: drift.Value(template.showPrice),
                            showValidity: drift.Value(template.showValidity),
                            showUsername: drift.Value(template.showUsername),
                            showPassword: drift.Value(template.showPassword),
                            showInstructions:
                                drift.Value(template.showInstructions),
                            headerText: drift.Value(template.headerText),
                            footerText: drift.Value(template.footerText),
                            instructionsText:
                                drift.Value(template.instructionsText),
                            contactPhone: drift.Value(template.contactPhone),
                            customText: drift.Value(template.customText),
                            targetCardType:
                                drift.Value(template.targetCardType),
                          ),
                        );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  tooltip: 'تعديل القالب',
                  onPressed: () => _openTemplateEditor(context, db, template),
                ),
                if (!template.isDefault)
                  IconButton(
                    icon: const Icon(Icons.delete_outline,
                        size: 18, color: AppColors.danger),
                    tooltip: 'حذف',
                    onPressed: () async {
                      await (db.delete(db.voucherTemplatesTable)
                            ..where((t) => t.id.equals(template.id)))
                          .go();
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openTemplateEditor(BuildContext context, AppDatabase db,
      VoucherTemplatesTableData? template) {
    context.push('/template-editor', extra: template);
  }
}
