import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    showDialog(
      context: context,
      builder: (ctx) =>
          _TemplateEditorDialog(db: db, initialTemplate: template),
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

class _TemplateEditorDialogState extends State<_TemplateEditorDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _nameCtrl = TextEditingController();
  final _headerCtrl = TextEditingController();
  final _footerCtrl = TextEditingController();
  final _instructionsCtrl = TextEditingController();
  final _contactPhoneCtrl = TextEditingController();

  String _paperSize = 'A4';
  String _targetCardType = 'all';
  int _cardsPerRow = 3;
  int _cardsPerPage = 12;

  // Colors
  int _primaryColorHex = 0xFF0F172A;
  int _bgColorHex = 0xFFFFFFFF;
  int _textColorHex = 0xFF1E293B;
  int _borderColorHex = 0xFFCBD5E1;

  double _borderWidth = 1.0;
  double _borderRadius = 8.0;
  double _fontSize = 10.0;
  double _titleFontSize = 11.0;

  // Visibility Toggles
  bool _showQr = true;
  bool _showBarcode = false;
  bool _showProfile = true;
  bool _showPrice = true;
  bool _showValidity = true;
  bool _showUsername = true;
  bool _showPassword = true;
  bool _showInstructions = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    if (widget.initialTemplate != null) {
      final t = widget.initialTemplate!;
      _nameCtrl.text = t.name;
      _headerCtrl.text = t.headerText ?? '';
      _footerCtrl.text = t.footerText ?? '';
      _instructionsCtrl.text = t.instructionsText ?? '';
      _contactPhoneCtrl.text = t.contactPhone ?? '';
      _paperSize = t.paperSize;
      _targetCardType = t.targetCardType;
      _cardsPerRow = t.cardsPerRow;
      _cardsPerPage = t.cardsPerPage;
      _primaryColorHex = t.primaryColorHex;
      _bgColorHex = t.backgroundColorHex;
      _textColorHex = t.textColorHex;
      _borderColorHex = t.borderColorHex;
      _borderWidth = t.borderWidth;
      _borderRadius = t.borderRadius;
      _fontSize = t.fontSize;
      _titleFontSize = t.titleFontSize;
      _showQr = t.showQrCode;
      _showBarcode = t.showBarcode;
      _showProfile = t.showProfile;
      _showPrice = t.showPrice;
      _showValidity = t.showValidity;
      _showUsername = t.showUsername;
      _showPassword = t.showPassword;
      _showInstructions = t.showInstructions;
    } else {
      _nameCtrl.text = 'قالب مخصص';
      _headerCtrl.text = 'شبكة الواي فاي السريعة';
      _footerCtrl.text = 'شكراً لزيارتكم';
      _instructionsCtrl.text = 'أدخل الكود في صفحة تسجيل الدخول';
      _contactPhoneCtrl.text = '777000000';
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameCtrl.dispose();
    _headerCtrl.dispose();
    _footerCtrl.dispose();
    _instructionsCtrl.dispose();
    _contactPhoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialTemplate == null
          ? 'تصميم وتخصيص قالب كروت جديد'
          : 'تعديل وتخصيص قالب الكروت'),
      content: SizedBox(
        width: 520,
        height: 520,
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              labelColor: AppColors.cyanAccent,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.cyanAccent,
              tabs: const [
                Tab(icon: Icon(Icons.settings), text: 'البيانات والحجم'),
                Tab(icon: Icon(Icons.palette), text: 'المظهر والألوان'),
                Tab(icon: Icon(Icons.visibility), text: 'العناصر المعروضة'),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Tab 1: General & Paper Specs
                  _buildGeneralSpecsTab(),
                  // Tab 2: Appearance & Styling
                  _buildStylingTab(),
                  // Tab 3: Display Elements & Toggles
                  _buildElementsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.cyanAccent,
            foregroundColor: Colors.white,
          ),
          onPressed: () async {
            final name = _nameCtrl.text.trim();
            if (name.isEmpty) return;

            final companion = VoucherTemplatesTableCompanion(
              name: drift.Value(name),
              paperSize: drift.Value(_paperSize),
              cardsPerRow: drift.Value(_cardsPerRow),
              cardsPerPage: drift.Value(_cardsPerPage),
              primaryColorHex: drift.Value(_primaryColorHex),
              backgroundColorHex: drift.Value(_bgColorHex),
              textColorHex: drift.Value(_textColorHex),
              borderColorHex: drift.Value(_borderColorHex),
              borderWidth: drift.Value(_borderWidth),
              borderRadius: drift.Value(_borderRadius),
              fontSize: drift.Value(_fontSize),
              titleFontSize: drift.Value(_titleFontSize),
              showQrCode: drift.Value(_showQr),
              showBarcode: drift.Value(_showBarcode),
              showProfile: drift.Value(_showProfile),
              showPrice: drift.Value(_showPrice),
              showValidity: drift.Value(_showValidity),
              showUsername: drift.Value(_showUsername),
              showPassword: drift.Value(_showPassword),
              showInstructions: drift.Value(_showInstructions),
              headerText: drift.Value(_headerCtrl.text.trim()),
              footerText: drift.Value(_footerCtrl.text.trim()),
              instructionsText: drift.Value(_instructionsCtrl.text.trim()),
              contactPhone: drift.Value(_contactPhoneCtrl.text.trim()),
              targetCardType: drift.Value(_targetCardType),
            );

            if (widget.initialTemplate == null) {
              await widget.db
                  .into(widget.db.voucherTemplatesTable)
                  .insert(companion);
            } else {
              await (widget.db.update(widget.db.voucherTemplatesTable)
                    ..where((t) => t.id.equals(widget.initialTemplate!.id)))
                  .write(companion);
            }

            if (context.mounted) Navigator.pop(context);
          },
          child: const Text('حفظ القالب'),
        ),
      ],
    );
  }

  Widget _buildGeneralSpecsTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(labelText: 'اسم القالب *'),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: _targetCardType,
            decoration: const InputDecoration(labelText: 'نوع الكروت المخصصة'),
            items: const [
              DropdownMenuItem(
                  value: 'all', child: Text('كافة الكروت (مشترك)')),
              DropdownMenuItem(
                  value: 'hotspot', child: Text('كروت الهوتسبوت Hotspot')),
              DropdownMenuItem(
                  value: 'usermanager', child: Text('كروت User Manager')),
            ],
            onChanged: (val) {
              if (val != null) setState(() => _targetCardType = val);
            },
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _headerCtrl,
            decoration: const InputDecoration(
                labelText: 'عنوان رأس الكرت (اسم الشبكة)'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _footerCtrl,
            decoration: const InputDecoration(labelText: 'تذييل الكرت'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _contactPhoneCtrl,
            decoration:
                const InputDecoration(labelText: 'رقم هاتف الدعم الفني'),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: _paperSize,
            decoration: const InputDecoration(labelText: 'حجم الورق والتخطيط'),
            items: const [
              DropdownMenuItem(
                  value: 'A4', child: Text('ورق عادي A4 (شبكة كروت)')),
              DropdownMenuItem(
                  value: '58mm', child: Text('طابعة حرارية 58mm (إيصال)')),
              DropdownMenuItem(
                  value: '80mm', child: Text('طابعة حرارية 80mm (إيصال)')),
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
          if (_paperSize == 'A4') ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _cardsPerRow,
                    decoration: const InputDecoration(labelText: 'كروت بالصف'),
                    items: [2, 3, 4]
                        .map((c) =>
                            DropdownMenuItem(value: c, child: Text('$c كروت')))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _cardsPerRow = val);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _cardsPerPage,
                    decoration:
                        const InputDecoration(labelText: 'كروت بالصفحة'),
                    items: [8, 12, 15, 18, 24]
                        .map((c) =>
                            DropdownMenuItem(value: c, child: Text('$c كرت')))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _cardsPerPage = val);
                    },
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStylingTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Live Mini Preview Box
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: Color(_bgColorHex),
              border: Border.all(
                  color: Color(_borderColorHex), width: _borderWidth),
              borderRadius: BorderRadius.circular(_borderRadius),
            ),
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Color(_primaryColorHex),
                    borderRadius: BorderRadius.circular(
                        _borderRadius > 4 ? _borderRadius - 2 : 4),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _headerCtrl.text.isNotEmpty
                            ? _headerCtrl.text
                            : 'اسم الشبكة',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: _titleFontSize,
                            fontWeight: FontWeight.bold),
                      ),
                      if (_showProfile)
                        const Text('1GB-1Day',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 9)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_showQr)
                      Container(
                        padding: const EdgeInsets.all(2),
                        color: Colors.white,
                        child: QrImageView(data: 'demo-card', size: 36),
                      ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_showPrice)
                          const Text('500 YER',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  color: Colors.green)),
                        if (_showUsername)
                          Text('كود: 77123456',
                              style: TextStyle(
                                  color: Color(_textColorHex),
                                  fontWeight: FontWeight.bold,
                                  fontSize: _fontSize)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Color Palettes
          const Text('لون شريط الرأس الأساسي:',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          _buildColorPickerRow(
            current: _primaryColorHex,
            colors: const [
              0xFF0F172A,
              0xFF1E3A8A,
              0xFF065F46,
              0xFF7C2D12,
              0xFF4C1D95,
              0xFF0284C7
            ],
            onSelect: (c) => setState(() => _primaryColorHex = c),
          ),
          const SizedBox(height: 12),

          const Text('لون خلفية الكرت:',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          _buildColorPickerRow(
            current: _bgColorHex,
            colors: const [
              0xFFFFFFFF,
              0xFFF8FAFC,
              0xFFFFFBEB,
              0xFFF0FDF4,
              0xFFF1F5F9
            ],
            onSelect: (c) => setState(() => _bgColorHex = c),
          ),
          const SizedBox(height: 12),

          const Text('لون إطار الكرت:',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          _buildColorPickerRow(
            current: _borderColorHex,
            colors: const [
              0xFFCBD5E1,
              0xFF94A3B8,
              0xFF0F172A,
              0xFF0EA5E9,
              0xFF10B981
            ],
            onSelect: (c) => setState(() => _borderColorHex = c),
          ),
          const SizedBox(height: 14),

          // Sliders for geometry
          Text('انحناء الحواف: ${_borderRadius.toStringAsFixed(0)} px',
              style: const TextStyle(fontSize: 12)),
          Slider(
            value: _borderRadius,
            min: 0,
            max: 16,
            divisions: 16,
            onChanged: (val) => setState(() => _borderRadius = val),
          ),

          Text('سُمك الإطار: ${_borderWidth.toStringAsFixed(1)} px',
              style: const TextStyle(fontSize: 12)),
          Slider(
            value: _borderWidth,
            min: 0.5,
            max: 3.0,
            divisions: 5,
            onChanged: (val) => setState(() => _borderWidth = val),
          ),
        ],
      ),
    );
  }

  Widget _buildElementsTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('رمز الاستجابة السريعة (QR Code)'),
            value: _showQr,
            onChanged: (val) => setState(() => _showQr = val),
          ),
          SwitchListTile(
            title: const Text('الباركود الخطي (Barcode 128)'),
            value: _showBarcode,
            onChanged: (val) => setState(() => _showBarcode = val),
          ),
          SwitchListTile(
            title: const Text('إظهار اسم الفئة / البروفايل'),
            value: _showProfile,
            onChanged: (val) => setState(() => _showProfile = val),
          ),
          SwitchListTile(
            title: const Text('إظهار سعر الكرت'),
            value: _showPrice,
            onChanged: (val) => setState(() => _showPrice = val),
          ),
          SwitchListTile(
            title: const Text('إظهار مدة الصلاحية'),
            value: _showValidity,
            onChanged: (val) => setState(() => _showValidity = val),
          ),
          SwitchListTile(
            title: const Text('إظهار اسم المستخدم / الكود'),
            value: _showUsername,
            onChanged: (val) => setState(() => _showUsername = val),
          ),
          SwitchListTile(
            title: const Text('إظهار كلمة المرور (إذا كانت منفصلة)'),
            value: _showPassword,
            onChanged: (val) => setState(() => _showPassword = val),
          ),
          SwitchListTile(
            title: const Text('إظهار نص التعليمات والدعم في تذييل الكرت'),
            value: _showInstructions,
            onChanged: (val) => setState(() => _showInstructions = val),
          ),
          if (_showInstructions)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                controller: _instructionsCtrl,
                decoration: const InputDecoration(
                  labelText: 'نص التعليمات المخصص',
                  hintText: 'مثال: ادخل الكود ثم اضغط تسجيل الدخول',
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildColorPickerRow({
    required int current,
    required List<int> colors,
    required ValueChanged<int> onSelect,
  }) {
    return Row(
      children: colors.map((c) {
        final isSelected = c == current;
        return GestureDetector(
          onTap: () => onSelect(c),
          child: Container(
            margin: const EdgeInsets.only(left: 8),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Color(c),
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColors.cyanAccent : Colors.grey.shade400,
                width: isSelected ? 3 : 1,
              ),
            ),
            child: isSelected
                ? Icon(
                    Icons.check,
                    size: 16,
                    color: c == 0xFFFFFFFF ? Colors.black : Colors.white,
                  )
                : null,
          ),
        );
      }).toList(),
    );
  }
}
