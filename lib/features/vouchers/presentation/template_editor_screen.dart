import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../core/constants/app_colors.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';

class TemplateElementConfig {
  final String key;
  final String label;
  double xPercent;
  double yPercent;
  double fontSize;
  bool isBold;
  bool isMonospace;
  int colorHex;
  double letterSpacing;
  double rotationDegrees;
  bool showBackgroundPill;
  int pillColorHex;
  bool isVisible;

  TemplateElementConfig({
    required this.key,
    required this.label,
    this.xPercent = 0.5,
    this.yPercent = 0.5,
    this.fontSize = 12.0,
    this.isBold = false,
    this.isMonospace = false,
    this.colorHex = 0xFF000000,
    this.letterSpacing = 0.0,
    this.rotationDegrees = 0.0,
    this.showBackgroundPill = false,
    this.pillColorHex = 0xAAFFFFFF,
    this.isVisible = true,
  });

  Map<String, dynamic> toJson() => {
        'key': key,
        'label': label,
        'xPercent': xPercent,
        'yPercent': yPercent,
        'fontSize': fontSize,
        'isBold': isBold,
        'isMonospace': isMonospace,
        'colorHex': colorHex,
        'letterSpacing': letterSpacing,
        'rotationDegrees': rotationDegrees,
        'showBackgroundPill': showBackgroundPill,
        'pillColorHex': pillColorHex,
        'isVisible': isVisible,
      };

  factory TemplateElementConfig.fromJson(
    Map<String, dynamic> json,
    String defaultLabel,
  ) {
    return TemplateElementConfig(
      key: json['key'] as String? ?? '',
      label: json['label'] as String? ?? defaultLabel,
      xPercent: (json['xPercent'] as num?)?.toDouble() ?? 0.5,
      yPercent: (json['yPercent'] as num?)?.toDouble() ?? 0.5,
      fontSize: (json['fontSize'] as num?)?.toDouble() ?? 12.0,
      isBold: json['isBold'] as bool? ?? false,
      isMonospace: json['isMonospace'] as bool? ?? false,
      colorHex: (json['colorHex'] as num?)?.toInt() ?? 0xFF000000,
      letterSpacing: (json['letterSpacing'] as num?)?.toDouble() ?? 0.0,
      rotationDegrees: (json['rotationDegrees'] as num?)?.toDouble() ?? 0.0,
      showBackgroundPill: json['showBackgroundPill'] as bool? ?? false,
      pillColorHex: (json['pillColorHex'] as num?)?.toInt() ?? 0xAAFFFFFF,
      isVisible: json['isVisible'] as bool? ?? true,
    );
  }
}

class TemplateEditorScreen extends ConsumerStatefulWidget {
  final VoucherTemplatesTableData? template;

  const TemplateEditorScreen({super.key, this.template});

  @override
  ConsumerState<TemplateEditorScreen> createState() =>
      _TemplateEditorScreenState();
}

class _TemplateEditorScreenState extends ConsumerState<TemplateEditorScreen> {
  final _nameCtrl = TextEditingController(text: 'قالب كروت جديد');
  final _bgPathCtrl = TextEditingController();
  final _headerCtrl = TextEditingController(text: 'شبكة الواي فاي');

  String _paperSize = 'A4';
  int _cardsPerRow = 3;
  int _cardsPerPage = 12;
  bool _isDefault = false;
  String _selectedElementKey = 'code';
  String? _bgImagePath;

  late Map<String, TemplateElementConfig> _elements;

  @override
  void initState() {
    super.initState();
    _initElements();

    if (widget.template != null) {
      final t = widget.template!;
      _nameCtrl.text = t.name;
      _headerCtrl.text = t.headerText ?? '';
      _bgPathCtrl.text = t.logoPath ?? '';
      _bgImagePath = t.logoPath;
      _paperSize = t.paperSize;
      _cardsPerRow = t.cardsPerRow;
      _cardsPerPage = t.cardsPerPage;
      _isDefault = t.isDefault;

      if (t.configJson != null && t.configJson!.isNotEmpty) {
        try {
          final decoded = jsonDecode(t.configJson!) as Map<String, dynamic>;
          final elementsJson = decoded['elements'] as Map<String, dynamic>?;
          if (elementsJson != null) {
            elementsJson.forEach((k, v) {
              if (_elements.containsKey(k) && v is Map<String, dynamic>) {
                _elements[k] = TemplateElementConfig.fromJson(
                    v, _elements[k]!.label);
              }
            });
          }
          if (decoded['bgImagePath'] != null) {
            _bgImagePath = decoded['bgImagePath'].toString();
            _bgPathCtrl.text = _bgImagePath!;
          }
        } catch (_) {}
      }
    }
  }

  void _initElements() {
    _elements = {
      'networkName': TemplateElementConfig(
        key: 'networkName',
        label: 'اسم الشبكة',
        xPercent: 0.5,
        yPercent: 0.12,
        fontSize: 14.0,
        isBold: true,
        colorHex: 0xFF0F172A,
      ),
      'profile': TemplateElementConfig(
        key: 'profile',
        label: 'الباقة / البروفايل',
        xPercent: 0.25,
        yPercent: 0.28,
        fontSize: 11.0,
        colorHex: 0xFF3B82F6,
        isBold: true,
      ),
      'price': TemplateElementConfig(
        key: 'price',
        label: 'سعر الكرت',
        xPercent: 0.75,
        yPercent: 0.28,
        fontSize: 12.0,
        isBold: true,
        colorHex: 0xFF0D9488,
      ),
      'code': TemplateElementConfig(
        key: 'code',
        label: 'رقم / كود الكرت',
        xPercent: 0.5,
        yPercent: 0.55,
        fontSize: 18.0,
        isBold: true,
        isMonospace: true,
        colorHex: 0xFF000000,
        letterSpacing: 2.0,
        showBackgroundPill: true,
      ),
      'password': TemplateElementConfig(
        key: 'password',
        label: 'كلمة المرور',
        xPercent: 0.5,
        yPercent: 0.72,
        fontSize: 12.0,
        isMonospace: true,
        colorHex: 0xFF334155,
        isVisible: false,
      ),
      'serial': TemplateElementConfig(
        key: 'serial',
        label: 'الرقم التسلسلي',
        xPercent: 0.5,
        yPercent: 0.88,
        fontSize: 9.0,
        colorHex: 0xFF64748B,
      ),
    };
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _bgPathCtrl.dispose();
    _headerCtrl.dispose();
    super.dispose();
  }

  TemplateElementConfig get _currentElement =>
      _elements[_selectedElementKey] ?? _elements.values.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.template != null ? 'تعديل القالب' : 'محرر القوالب المتقدم'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: 'حفظ القالب',
            onPressed: _saveTemplate,
          ),
        ],
      ),
      body: Column(
        children: [
          // Visual Card Canvas (Preview Area)
          Container(
            color: Colors.grey.shade200,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Center(
              child: AspectRatio(
                aspectRatio: 1.65, // Standard card aspect ratio
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final cardWidth = constraints.maxWidth;
                    final cardHeight = constraints.maxHeight;

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade400, width: 1.5),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          )
                        ],
                        image: (_bgImagePath != null &&
                                File(_bgImagePath!).existsSync())
                            ? DecorationImage(
                                image: FileImage(File(_bgImagePath!)),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          children: _elements.values
                              .where((el) => el.isVisible)
                              .map((el) => _buildCanvasElement(
                                  el, cardWidth, cardHeight))
                              .toList(),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // Elements selector chips
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _elements.values.map((el) {
                  final isSelected = el.key == _selectedElementKey;
                  return Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: ChoiceChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!el.isVisible)
                            const Icon(Icons.visibility_off,
                                size: 14, color: Colors.grey)
                          else
                            const SizedBox.shrink(),
                          const SizedBox(width: 4),
                          Text(el.label),
                        ],
                      ),
                      selected: isSelected,
                      selectedColor: AppColors.cyanAccent,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (_) {
                        setState(() => _selectedElementKey = el.key);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          const Divider(height: 1),

          // Controls Area
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSelectedElementControls(),
                  const SizedBox(height: 16),
                  _buildTemplateSettingsControls(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCanvasElement(
    TemplateElementConfig el,
    double cardWidth,
    double cardHeight,
  ) {
    final isSelected = el.key == _selectedElementKey;
    final textStyle = TextStyle(
      fontSize: el.fontSize,
      fontWeight: el.isBold ? FontWeight.bold : FontWeight.normal,
      fontFamily: el.isMonospace ? 'monospace' : 'Cairo',
      color: Color(el.colorHex),
      letterSpacing: el.letterSpacing,
    );

    String demoValue = '';
    switch (el.key) {
      case 'networkName':
        demoValue = _headerCtrl.text.isNotEmpty
            ? _headerCtrl.text
            : 'شبكة الواحة اللاسلكية';
        break;
      case 'profile':
        demoValue = 'باقة 2 ساعة (500MB)';
        break;
      case 'price':
        demoValue = '500 YER';
        break;
      case 'code':
        demoValue = '77894215';
        break;
      case 'password':
        demoValue = 'Pass: 4321';
        break;
      case 'serial':
        demoValue = 'SN-000124';
        break;
    }

    final posX = (el.xPercent * cardWidth) - 40;
    final posY = (el.yPercent * cardHeight) - 15;

    return Positioned(
      left: posX.clamp(0.0, cardWidth - 80),
      top: posY.clamp(0.0, cardHeight - 30),
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _selectedElementKey = el.key;
            el.xPercent = (el.xPercent + (details.delta.dx / cardWidth))
                .clamp(0.05, 0.95);
            el.yPercent = (el.yPercent + (details.delta.dy / cardHeight))
                .clamp(0.05, 0.95);
          });
        },
        onTap: () => setState(() => _selectedElementKey = el.key),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: el.showBackgroundPill
                ? Color(el.pillColorHex)
                : (isSelected
                    ? Colors.blue.withValues(alpha: 0.15)
                    : Colors.transparent),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isSelected ? AppColors.cyanAccent : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Text(demoValue, style: textStyle),
        ),
      ),
    );
  }

  Widget _buildSelectedElementControls() {
    final el = _currentElement;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'تحكم عنصر: ${el.label}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Row(
                  children: [
                    const Text('إظهار: ', style: TextStyle(fontSize: 12)),
                    Switch(
                      value: el.isVisible,
                      activeColor: AppColors.cyanAccent,
                      onChanged: (val) => setState(() => el.isVisible = val),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 16),

            // Nudge Position buttons
            const Text('التحريك الدقيق للموضع:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_upward),
                  tooltip: 'أعلى',
                  onPressed: () => setState(() =>
                      el.yPercent = (el.yPercent - 0.02).clamp(0.05, 0.95)),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_downward),
                  tooltip: 'أسفل',
                  onPressed: () => setState(() =>
                      el.yPercent = (el.yPercent + 0.02).clamp(0.05, 0.95)),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  tooltip: 'يسار',
                  onPressed: () => setState(() =>
                      el.xPercent = (el.xPercent - 0.02).clamp(0.05, 0.95)),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  tooltip: 'يمين',
                  onPressed: () => setState(() =>
                      el.xPercent = (el.xPercent + 0.02).clamp(0.05, 0.95)),
                ),
                const SizedBox(width: 12),
                Text(
                  'X: ${(el.xPercent * 100).toStringAsFixed(0)}% | Y: ${(el.yPercent * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Font size slider
            Row(
              children: [
                const Text('الحجم:', style: TextStyle(fontSize: 12)),
                Expanded(
                  child: Slider(
                    value: el.fontSize,
                    min: 8.0,
                    max: 32.0,
                    divisions: 24,
                    label: el.fontSize.toStringAsFixed(0),
                    onChanged: (val) => setState(() => el.fontSize = val),
                  ),
                ),
                Text('${el.fontSize.toStringAsFixed(0)}px',
                    style: const TextStyle(fontSize: 12)),
              ],
            ),

            // Spacing slider
            Row(
              children: [
                const Text('تباعد الأحرف:', style: TextStyle(fontSize: 12)),
                Expanded(
                  child: Slider(
                    value: el.letterSpacing,
                    min: 0.0,
                    max: 6.0,
                    divisions: 12,
                    label: el.letterSpacing.toStringAsFixed(1),
                    onChanged: (val) => setState(() => el.letterSpacing = val),
                  ),
                ),
                Text(el.letterSpacing.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 12)),
              ],
            ),

            // Styling toggles: Bold, Monospace, Background Pill
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilterChip(
                  label: const Text('عريض (Bold)'),
                  selected: el.isBold,
                  onSelected: (val) => setState(() => el.isBold = val),
                ),
                FilterChip(
                  label: const Text('خط أرقام (Monospace)'),
                  selected: el.isMonospace,
                  onSelected: (val) => setState(() => el.isMonospace = val),
                ),
                FilterChip(
                  label: const Text('إطار خلفية تباين (Pill)'),
                  selected: el.showBackgroundPill,
                  onSelected: (val) =>
                      setState(() => el.showBackgroundPill = val),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Color Palette
            const Text('لون النص:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              children: [
                0xFF000000,
                0xFFFFFFFF,
                0xFF0F172A,
                0xFF0284C7,
                0xFF0D9488,
                0xFFDC2626,
                0xFFD97706,
                0xFF7C3AED,
              ].map((c) {
                final isCur = el.colorHex == c;
                return GestureDetector(
                  onTap: () => setState(() => el.colorHex = c),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Color(c),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isCur ? AppColors.cyanAccent : Colors.grey.shade400,
                        width: isCur ? 3 : 1,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemplateSettingsControls() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('إعدادات القالب والورق',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 12),
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: 'اسم القالب',
                prefixIcon: Icon(Icons.title),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _headerCtrl,
              decoration: const InputDecoration(
                labelText: 'اسم الشبكة الافتراضي',
                prefixIcon: Icon(Icons.wifi),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _bgPathCtrl,
              decoration: InputDecoration(
                labelText: 'مسار صورة الخلفية (من الهاتف)',
                prefixIcon: const Icon(Icons.image),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.file_open),
                  tooltip: 'تطبيق المسار',
                  onPressed: () {
                    final path = _bgPathCtrl.text.trim();
                    if (path.isNotEmpty && File(path).existsSync()) {
                      setState(() => _bgImagePath = path);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تم تحميل صورة الخلفية بنجاح')),
                      );
                    } else if (path.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('الملف غير موجود في المسار المحدد')),
                      );
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'حجم الورق'),
                    value: _paperSize,
                    items: const [
                      DropdownMenuItem(value: 'A4', child: Text('A4 (عادي)')),
                      DropdownMenuItem(
                          value: '58mm', child: Text('58mm (حراري)')),
                      DropdownMenuItem(
                          value: '80mm', child: Text('80mm (حراري)')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _paperSize = val);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    decoration:
                        const InputDecoration(labelText: 'كروت بالصف'),
                    value: _cardsPerRow,
                    items: const [
                      DropdownMenuItem(value: 2, child: Text('2 أعمدة')),
                      DropdownMenuItem(value: 3, child: Text('3 أعمدة')),
                      DropdownMenuItem(value: 4, child: Text('4 أعمدة')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _cardsPerRow = val);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('تعيين كقالب افتراضي لطباعة الكروت'),
              value: _isDefault,
              activeColor: AppColors.cyanAccent,
              onChanged: (val) => setState(() => _isDefault = val),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveTemplate() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى كتابة اسم القالب')),
      );
      return;
    }

    final db = ref.read(databaseProvider);
    final elementsMap = _elements.map((k, v) => MapEntry(k, v.toJson()));
    final configData = {
      'elements': elementsMap,
      'bgImagePath': _bgImagePath,
      'headerText': _headerCtrl.text.trim(),
    };
    final configJson = jsonEncode(configData);

    try {
      if (_isDefault) {
        // Clear old default
        await (db.update(db.voucherTemplatesTable)).write(
          const VoucherTemplatesTableCompanion(isDefault: drift.Value(false)),
        );
      }

      if (widget.template != null) {
        await (db.update(db.voucherTemplatesTable)
              ..where((t) => t.id.equals(widget.template!.id)))
            .write(
          VoucherTemplatesTableCompanion(
            name: drift.Value(name),
            paperSize: drift.Value(_paperSize),
            cardsPerRow: drift.Value(_cardsPerRow),
            cardsPerPage: drift.Value(_cardsPerPage),
            headerText: drift.Value(_headerCtrl.text.trim()),
            logoPath: drift.Value(_bgImagePath),
            configJson: drift.Value(configJson),
            isDefault: drift.Value(_isDefault),
          ),
        );
      } else {
        await db.into(db.voucherTemplatesTable).insert(
              VoucherTemplatesTableCompanion.insert(
                name: name,
                paperSize: drift.Value(_paperSize),
                cardsPerRow: drift.Value(_cardsPerRow),
                cardsPerPage: drift.Value(_cardsPerPage),
                headerText: drift.Value(_headerCtrl.text.trim()),
                logoPath: drift.Value(_bgImagePath),
                configJson: drift.Value(configJson),
                isDefault: drift.Value(_isDefault),
              ),
            );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🎉 تم حفظ القالب بنجاح!'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل حفظ القالب: $e'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }
}
