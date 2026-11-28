import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:drift/drift.dart' as drift;
import '../../../core/constants/app_colors.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../hotspot/domain/hotspot_notifier.dart';
import '../../routers/domain/routers_notifier.dart';
import '../../userman/domain/userman_notifier.dart';
import '../domain/unified_card_model.dart';
import '../domain/voucher_generator_engine.dart';
import '../domain/vouchers_notifier.dart';
import 'template_gallery_screen.dart';

class TabularCardRow {
  final String id;
  String title;
  String type; // netName, username, password, validity, price, dataLimit, serialNumber, customText
  bool isVisible;

  TabularCardRow({
    required this.id,
    required this.title,
    required this.type,
    this.isVisible = true,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'type': type,
        'isVisible': isVisible,
      };

  factory TabularCardRow.fromJson(Map<String, dynamic> json) => TabularCardRow(
        id: json['id'] as String? ?? UniqueKey().toString(),
        title: json['title'] as String? ?? '',
        type: json['type'] as String? ?? 'username',
        isVisible: json['isVisible'] as bool? ?? true,
      );
}

class VoucherGeneratorScreen extends ConsumerStatefulWidget {
  final bool initialIsUserManager;
  final String? initialProfile;

  const VoucherGeneratorScreen({
    super.key,
    this.initialIsUserManager = false,
    this.initialProfile,
  });

  @override
  ConsumerState<VoucherGeneratorScreen> createState() =>
      _VoucherGeneratorScreenState();
}

class _VoucherGeneratorScreenState extends ConsumerState<VoucherGeneratorScreen>
    with SingleTickerProviderStateMixin {
  late TabController _mainTabController;

  // System & Profiles
  late bool _isUserManager;
  String _selectedUmProfile = '';
  String _selectedHsProfile = '';

  // Generator Basic Controls
  final _quantityCtrl = TextEditingController(text: '20');
  final _prefixCtrl = TextEditingController(text: '');
  final _priceCtrl = TextEditingController(text: '500');
  final _netNameCtrl = TextEditingController(text: 'MikroManager Hotspot');
  final _validityCtrl = TextEditingController(text: '1 شهر');
  final _dataLimitCtrl = TextEditingController(text: '10 GB');

  // Serial Number controls
  bool _enableSerial = false;
  final _serialPrefixCtrl = TextEditingController(text: 'SN-');
  final _serialStartCtrl = TextEditingController(text: '1');
  int _serialPadding = 4;

  int _codeLength = 6;
  int _passwordLength = 4;
  VoucherCodeType _codeType = VoucherCodeType.numeric;
  CredentialMode _credentialMode = CredentialMode.identical;

  // Template State & Selection
  VoucherTemplatesTableData? _selectedTemplate;
  final _templateNameCtrl = TextEditingController(text: 'قالب كروت جديد');
  String? _bgImagePath;

  // Group A: Page Data
  int _columnsCount = 3;
  int _rowsCount = 4;
  bool _autoFitA4 = true;
  double _marginH = 4.0; // mm
  double _marginV = 4.0; // mm
  final _pageNoteCtrl = TextEditingController();
  bool _enablePageNumber = true;
  double _pageNumberSize = 8.0;
  String _pageNumberFormat = 'صفحة {page} من {total}';

  // Group B: Card Specs
  double _borderWidth = 1.2;
  Color _borderColor = const Color(0xFFCBD5E1);
  double _borderRadius = 10.0;
  bool _useTabularLayout = false;
  late List<TabularCardRow> _tableRows;

  // Group C: Card Elements
  String _selectedElementKey = 'username';
  double _movementStepMm = 1.0;

  // Elements Configuration map (key -> attributes)
  late Map<String, Map<String, dynamic>> _elementsConfig;

  @override
  void initState() {
    super.initState();
    _isUserManager = widget.initialIsUserManager;
    if (widget.initialProfile != null && widget.initialProfile!.isNotEmpty) {
      if (_isUserManager) {
        _selectedUmProfile = widget.initialProfile!;
      } else {
        _selectedHsProfile = widget.initialProfile!;
      }
    }
    _mainTabController = TabController(length: 2, vsync: this);

    _initDefaultTableRows();
    _initDefaultElementsConfig();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initSuggestedSerial();
    });
  }

  void _initDefaultTableRows() {
    _tableRows = [
      TabularCardRow(id: '1', title: 'اسم الشبكة', type: 'netName'),
      TabularCardRow(id: '2', title: 'اسم المستخدم', type: 'username'),
      TabularCardRow(id: '3', title: 'كلمة المرور', type: 'password'),
      TabularCardRow(id: '4', title: 'الصلاحية', type: 'validity'),
      TabularCardRow(id: '5', title: 'السعر', type: 'price'),
      TabularCardRow(id: '6', title: 'الرقم التسلسلي', type: 'serialNumber'),
    ];
  }

  void _initDefaultElementsConfig() {
    _elementsConfig = {
      'username': {
        'label': 'اسم المستخدم',
        'visible': true,
        'x': 50.0,
        'y': 48.0,
        'fontSize': 13.0,
        'bold': true,
        'italic': false,
        'color': 0xFF0F172A,
      },
      'password': {
        'label': 'كلمة المرور',
        'visible': true,
        'x': 50.0,
        'y': 62.0,
        'fontSize': 11.0,
        'bold': false,
        'italic': false,
        'color': 0xFF334155,
      },
      'qrCode': {
        'label': 'الباركود / QR',
        'visible': true,
        'x': 82.0,
        'y': 55.0,
        'size': 36.0,
      },
      'networkName': {
        'label': 'اسم الشبكة',
        'visible': true,
        'x': 50.0,
        'y': 16.0,
        'fontSize': 12.0,
        'bold': true,
        'italic': false,
        'color': 0xFF0F766E,
      },
      'price': {
        'label': 'السعر',
        'visible': true,
        'x': 18.0,
        'y': 84.0,
        'fontSize': 11.0,
        'bold': true,
        'italic': false,
        'color': 0xFF0D7A5F,
      },
      'validity': {
        'label': 'الصلاحية',
        'visible': true,
        'x': 50.0,
        'y': 84.0,
        'fontSize': 9.5,
        'bold': false,
        'italic': false,
        'color': 0xFF64748B,
      },
      'printDate': {
        'label': 'تاريخ الطبعة',
        'visible': false,
        'x': 82.0,
        'y': 84.0,
        'fontSize': 8.5,
        'bold': false,
        'italic': false,
        'color': 0xFF94A3B8,
      },
      'serialNumber': {
        'label': 'الرقم التسلسلي',
        'visible': true,
        'x': 50.0,
        'y': 92.0,
        'fontSize': 9.0,
        'bold': false,
        'italic': false,
        'color': 0xFF64748B,
      },
    };
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
    _mainTabController.dispose();
    _quantityCtrl.dispose();
    _prefixCtrl.dispose();
    _priceCtrl.dispose();
    _netNameCtrl.dispose();
    _validityCtrl.dispose();
    _dataLimitCtrl.dispose();
    _serialPrefixCtrl.dispose();
    _serialStartCtrl.dispose();
    _templateNameCtrl.dispose();
    _pageNoteCtrl.dispose();
    super.dispose();
  }

  void _applyTemplate(VoucherTemplatesTableData t) {
    setState(() {
      _selectedTemplate = t;
      _templateNameCtrl.text = t.name;
      _columnsCount = t.cardsPerRow;
      _rowsCount = (t.cardsPerPage / t.cardsPerRow).ceil();
      _marginH = t.marginMm;
      _marginV = t.marginMm;
      _borderWidth = t.borderWidth;
      _borderRadius = t.borderRadius;
      _borderColor = Color(t.borderColorHex);
      _bgImagePath = t.logoPath;

      if (t.configJson != null && t.configJson!.isNotEmpty) {
        try {
          final decoded = jsonDecode(t.configJson!) as Map<String, dynamic>;
          if (decoded['useTabular'] != null) {
            _useTabularLayout = decoded['useTabular'] as bool;
          }
          if (decoded['tableRows'] is List) {
            _tableRows = (decoded['tableRows'] as List)
                .map((e) => TabularCardRow.fromJson(e as Map<String, dynamic>))
                .toList();
          }
          if (decoded['elements'] is Map) {
            final elMap = decoded['elements'] as Map<String, dynamic>;
            elMap.forEach((k, v) {
              if (_elementsConfig.containsKey(k) && v is Map) {
                _elementsConfig[k]!.addAll(Map<String, dynamic>.from(v));
              }
            });
          }
        } catch (_) {}
      }
    });
  }

  Future<void> _saveCurrentTemplate() async {
    final db = ref.read(databaseProvider);
    final name = _templateNameCtrl.text.trim().isEmpty
        ? 'قالب ${_isUserManager ? "User Manager" : "Hotspot"}'
        : _templateNameCtrl.text.trim();

    final config = {
      'useTabular': _useTabularLayout,
      'tableRows': _tableRows.map((r) => r.toJson()).toList(),
      'elements': _elementsConfig,
      'pageNote': _pageNoteCtrl.text,
      'autoFitA4': _autoFitA4,
    };

    final companion = VoucherTemplatesTableCompanion(
      name: drift.Value(name),
      paperSize: const drift.Value('A4'),
      cardsPerRow: drift.Value(_columnsCount),
      cardsPerPage: drift.Value(_columnsCount * _rowsCount),
      marginMm: drift.Value(_marginH),
      borderWidth: drift.Value(_borderWidth),
      borderRadius: drift.Value(_borderRadius),
      borderColorHex: drift.Value(_borderColor.toARGB32()),
      logoPath: drift.Value(_bgImagePath),
      configJson: drift.Value(jsonEncode(config)),
      headerText: drift.Value(_netNameCtrl.text),
      targetCardType: drift.Value(_isUserManager ? 'usermanager' : 'hotspot'),
    );

    if (_selectedTemplate != null && _selectedTemplate!.id > 0) {
      await (db.update(db.voucherTemplatesTable)
            ..where((t) => t.id.equals(_selectedTemplate!.id)))
          .write(companion);
    } else {
      await db.into(db.voucherTemplatesTable).insert(companion);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ تم حفظ قالب تصميم الكرت بنجاح!'),
          backgroundColor: AppColors.addGreen,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _deleteCurrentTemplate() async {
    if (_selectedTemplate == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف القالب'),
        content: Text('هل أنت متأكد من حذف القالب "${_selectedTemplate!.name}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.deleteRed),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('حذف', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final db = ref.read(databaseProvider);
      await (db.delete(db.voucherTemplatesTable)
            ..where((t) => t.id.equals(_selectedTemplate!.id)))
          .go();
      setState(() {
        _selectedTemplate = null;
        _templateNameCtrl.text = 'قالب جديد';
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حذف القالب')),
        );
      }
    }
  }

  void _handlePdfPreview() {
    final qty = int.tryParse(_quantityCtrl.text) ?? 20;
    final price = double.tryParse(_priceCtrl.text) ?? 500.0;
    final prefix = _prefixCtrl.text.trim();
    final profile = _isUserManager ? _selectedUmProfile : _selectedHsProfile;

    if (profile.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى اختيار باقة/بروفايل أولاً لتوليد الكروت.'),
          backgroundColor: AppColors.deleteRed,
        ),
      );
      return;
    }

    ref.read(vouchersControllerProvider.notifier).generateDraftVouchers(
          quantity: qty,
          profile: profile,
          price: price,
          prefix: prefix,
          codeLength: _codeLength,
          codeType: _codeType,
          credentialMode: _credentialMode,
          passwordLength: _passwordLength,
          validity: _validityCtrl.text,
          networkName: _netNameCtrl.text,
          enableSerial: _enableSerial,
          serialPrefix: _serialPrefixCtrl.text,
          serialStart: int.tryParse(_serialStartCtrl.text) ?? 1,
          serialPadding: _serialPadding,
          isUserManager: _isUserManager,
          systemType: _isUserManager ? CardSystemType.usermanV7 : CardSystemType.hotspot,
        );

    context.push('/print-preview');
  }

  @override
  Widget build(BuildContext context) {
    final hotspotState = ref.watch(hotspotControllerProvider);
    final usermanState = ref.watch(usermanControllerProvider);
    final templatesAsync = ref.watch(voucherTemplatesStreamProvider);
    final batchesAsync = ref.watch(voucherBatchesStreamProvider);

    // Initial Profile Sync
    if (_isUserManager) {
      if (usermanState.parsedProfiles.isNotEmpty &&
          (_selectedUmProfile.isEmpty ||
              !usermanState.parsedProfiles.any((p) => p.name == _selectedUmProfile))) {
        _selectedUmProfile = usermanState.parsedProfiles.first.name;
        if (usermanState.parsedProfiles.first.price > 0 && _priceCtrl.text == '500') {
          _priceCtrl.text = usermanState.parsedProfiles.first.price.toStringAsFixed(0);
        }
      }
    } else {
      if (hotspotState.profiles.isNotEmpty &&
          (_selectedHsProfile.isEmpty ||
              !hotspotState.profiles.any((p) => p['name'] == _selectedHsProfile))) {
        _selectedHsProfile =
            hotspotState.profiles.first['name']?.toString() ?? 'default';
      }
    }

    final templates = templatesAsync.value ?? [];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          _isUserManager ? 'تصميم وتوليد كروت User Manager' : 'تصميم وتوليد كروت Hotspot',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        bottom: TabBar(
          controller: _mainTabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.palette_outlined), text: 'تصميم ومواصفات الكرت'),
            Tab(icon: Icon(Icons.history_rounded), text: 'سجل الدفعات المولدة'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _mainTabController,
        children: [
          // Tab 1: Design & Generator Dock
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 2.1 Top Bar: Template Actions & Package Linkers
                      _buildTopTemplateBar(templates),
                      const SizedBox(height: 12),

                      // Package linkers with explicit separation
                      _buildPackageLinkers(hotspotState, usermanState),
                      const SizedBox(height: 16),

                      // 2.2 Clean Accordion Expansion Cards
                      // Group A: بيانات الصفحة
                      _buildPageDataAccordion(),
                      const SizedBox(height: 10),

                      // Group B: مواصفات الكرت
                      _buildCardSpecsAccordion(),
                      const SizedBox(height: 10),

                      // Group C: عناصر الكرت
                      _buildCardElementsAccordion(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // 2.3 Sticky Live Preview Dock
              _buildStickyLivePreviewDock(),
            ],
          ),

          // Tab 2: Batches History
          _buildBatchesHistoryTab(batchesAsync),
        ],
      ),
    );
  }

  // =========================================================================
  // 2.1 Top Bar & Package Linkers
  // =========================================================================

  Widget _buildTopTemplateBar(List<VoucherTemplatesTableData> templates) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Action Buttons: حفظ (أخضر مصمت) | جديد + (رمادي مزرق) | حذف (وردي فاتح)
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.addGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _saveCurrentTemplate,
                  icon: const Icon(Icons.save_rounded, size: 18),
                  label: const Text('حفظ القالب', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF475569),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedTemplate = null;
                      _templateNameCtrl.text = 'قالب مخصص ${DateTime.now().millisecond}';
                    });
                  },
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('جديد +', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: _deleteCurrentTemplate,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.deletePink,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.deleteRed.withValues(alpha: 0.3)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.deleteRed),
                      SizedBox(width: 4),
                      Text('حذف', style: TextStyle(color: AppColors.deleteRed, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Template Selector Dropdown
          DropdownButtonFormField<VoucherTemplatesTableData>(
            value: _selectedTemplate,
            decoration: InputDecoration(
              labelText: 'اختر قالب التصميم',
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
            items: templates.map((t) {
              return DropdownMenuItem(
                value: t,
                child: Text(t.name, maxLines: 1, overflow: TextOverflow.ellipsis),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) _applyTemplate(val);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPackageLinkers(HotspotState hotspotState, UsermanState usermanState) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // System Switcher Tab
          SegmentedButton<bool>(
            style: SegmentedButton.styleFrom(
              visualDensity: VisualDensity.compact,
            ),
            segments: const [
              ButtonSegment<bool>(
                value: false,
                icon: Icon(Icons.wifi_tethering_rounded, size: 16),
                label: Text('هوتسبوت Hotspot', style: TextStyle(fontSize: 12)),
              ),
              ButtonSegment<bool>(
                value: true,
                icon: Icon(Icons.manage_accounts_rounded, size: 16),
                label: Text('يوزر منجر User Manager', style: TextStyle(fontSize: 12)),
              ),
            ],
            selected: {_isUserManager},
            onSelectionChanged: (set) {
              setState(() {
                _isUserManager = set.first;
              });
            },
          ),
          const SizedBox(height: 16),

          // Distinct Package Dropdowns
          if (_isUserManager) ...[
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedUmProfile.isNotEmpty ? _selectedUmProfile : null,
                    decoration: InputDecoration(
                      labelText: 'ربطه مع باقة يوزرمنجر',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    items: usermanState.parsedProfiles.map((p) {
                      return DropdownMenuItem(
                        value: p.name,
                        child: Text('${p.name} (${p.price.toStringAsFixed(0)} YER)'),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedUmProfile = val);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                    shape: const CircleBorder(),
                  ),
                  icon: const Icon(Icons.refresh_rounded, color: Color(0xFF8B5CF6)),
                  tooltip: 'تحديث باقات اليوزر منجر من الراوتر',
                  onPressed: () => ref.read(usermanControllerProvider.notifier).refreshAll(),
                ),
              ],
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedHsProfile.isNotEmpty ? _selectedHsProfile : null,
                    decoration: InputDecoration(
                      labelText: 'ربطه مع باقة هوتسبوت',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    items: hotspotState.profiles.map((p) {
                      final name = p['name']?.toString() ?? 'default';
                      return DropdownMenuItem(
                        value: name,
                        child: Text(name),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedHsProfile = val);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFF0284C7).withValues(alpha: 0.1),
                    shape: const CircleBorder(),
                  ),
                  icon: const Icon(Icons.refresh_rounded, color: Color(0xFF0284C7)),
                  tooltip: 'تحديث باقات الهوتسبوت من الراوتر',
                  onPressed: () => ref.read(hotspotControllerProvider.notifier).refreshAll(),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // =========================================================================
  // 2.2 Clean Accordion Expansion Cards
  // =========================================================================

  // Group A: بيانات الصفحة
  Widget _buildPageDataAccordion() {
    return _buildCustomAccordion(
      title: 'بيانات الصفحة والترقيم',
      subtitle: 'الأعمدة، الصفوف (${_columnsCount * _rowsCount} كرت)، الهوامش والترقيم',
      icon: Icons.auto_stories_rounded,
      iconColor: AppColors.primary,
      children: [
        _buildStepper(
          label: 'عدد الأعمدة (Columns)',
          value: _columnsCount,
          min: 1,
          onDecrement: () => setState(() => _columnsCount = (_columnsCount - 1).clamp(1, 8)),
          onIncrement: () => setState(() => _columnsCount = (_columnsCount + 1).clamp(1, 8)),
        ),
        const SizedBox(height: 10),
        _buildStepper(
          label: 'عدد الصفوف (Rows)',
          value: _rowsCount,
          min: 1,
          onDecrement: () => setState(() => _rowsCount = (_rowsCount - 1).clamp(1, 30)),
          onIncrement: () => setState(() => _rowsCount = (_rowsCount + 1).clamp(1, 30)),
        ),
        const SizedBox(height: 10),
        // Calculated Info Card
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('إجمالي الكروت بالصفحة:', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold)),
              Text(
                '$_columnsCount × $_rowsCount = ${_columnsCount * _rowsCount} كرت',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('ملاءمة تلقائية لمقاس الكرت حسب A4', style: TextStyle(fontSize: 13)),
          value: _autoFitA4,
          activeColor: AppColors.addGreen,
          onChanged: (v) => setState(() => _autoFitA4 = v),
        ),
        const Divider(height: 14),
        // Margins between cards
        _buildStepper(
          label: 'الهامش الأفقي بين الكروت (مم)',
          value: _marginH,
          unit: 'مم',
          min: 0,
          onDecrement: () => setState(() => _marginH = (_marginH - 1).clamp(0, 20)),
          onIncrement: () => setState(() => _marginH = (_marginH + 1).clamp(0, 20)),
        ),
        const SizedBox(height: 8),
        _buildStepper(
          label: 'الهامش الرأسي بين الكروت (مم)',
          value: _marginV,
          unit: 'مم',
          min: 0,
          onDecrement: () => setState(() => _marginV = (_marginV - 1).clamp(0, 20)),
          onIncrement: () => setState(() => _marginV = (_marginV + 1).clamp(0, 20)),
        ),
        const Divider(height: 14),
        // Page Note
        TextField(
          controller: _pageNoteCtrl,
          decoration: InputDecoration(
            labelText: 'ملاحظة أو عنوان أعلى الصفحة',
            hintText: 'مثال: شبكة الريان - كروت باقة 1 شهر',
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        const Divider(height: 14),
        // Page Numbering
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('تفعيل ترقيم الصفحة', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          subtitle: const Text('يدعم المتغيرات {page} و {total}', style: TextStyle(fontSize: 11)),
          value: _enablePageNumber,
          activeColor: AppColors.addGreen,
          onChanged: (v) => setState(() => _enablePageNumber = v),
        ),
        if (_enablePageNumber) ...[
          _buildStepper(
            label: 'حجم خط رقم الصفحة',
            value: _pageNumberSize,
            min: 6,
            onDecrement: () => setState(() => _pageNumberSize = (_pageNumberSize - 0.5).clamp(6, 16)),
            onIncrement: () => setState(() => _pageNumberSize = (_pageNumberSize + 0.5).clamp(6, 16)),
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: _pageNumberFormat,
            decoration: InputDecoration(
              labelText: 'صيغة ترقيم الصفحة',
              hintText: 'صفحة {page} من {total}',
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onChanged: (val) => _pageNumberFormat = val,
          ),
        ],
      ],
    );
  }

  // Group B: مواصفات الكرت
  Widget _buildCardSpecsAccordion() {
    return _buildCustomAccordion(
      title: 'مواصفات وإطار وخلفية الكرت',
      subtitle: 'صورة القالب، الإطار، ونظام الجدول الافتراضي الموفر للحبر',
      icon: Icons.crop_portrait_rounded,
      iconColor: const Color(0xFF6366F1),
      children: [
        // Background Image Selection
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  _showImagePathDialog(context);
                },
                icon: const Icon(Icons.add_photo_alternate_outlined),
                label: Text(
                  _bgImagePath != null ? 'تغيير صورة القالب' : 'إدراج صورة قالب من الهاتف',
                  style: const TextStyle(fontSize: 12.5),
                ),
              ),
            ),
            if (_bgImagePath != null) ...[
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.clear, color: AppColors.deleteRed),
                tooltip: 'إلغاء الصورة واستخدام القالب الذكي',
                onPressed: () => setState(() => _bgImagePath = null),
              ),
            ],
          ],
        ),
        const SizedBox(height: 10),
        // Frame controls
        _buildStepper(
          label: 'سمك إطار الكرت (مم)',
          value: _borderWidth,
          min: 0,
          onDecrement: () => setState(() => _borderWidth = (_borderWidth - 0.2).clamp(0, 6)),
          onIncrement: () => setState(() => _borderWidth = (_borderWidth + 0.2).clamp(0, 6)),
        ),
        const SizedBox(height: 8),
        _buildStepper(
          label: 'استدارة حواف الكرت (Radius)',
          value: _borderRadius,
          min: 0,
          onDecrement: () => setState(() => _borderRadius = (_borderRadius - 1).clamp(0, 24)),
          onIncrement: () => setState(() => _borderRadius = (_borderRadius + 1).clamp(0, 24)),
        ),
        const Divider(height: 16),

        // Tabular Rows Mode (وضع القالب الجدولي الافتراضي)
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('تفعيل صفوف الكرت (القالب الجدولي)',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          subtitle: const Text('تصميم منظم يستهلك حبراً أقل ومثالي للطابعات العادية',
              style: TextStyle(fontSize: 11)),
          value: _useTabularLayout,
          activeColor: AppColors.addGreen,
          onChanged: (v) => setState(() => _useTabularLayout = v),
        ),

        if (_useTabularLayout) ...[
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _tableRows.length,
            itemBuilder: (context, idx) {
              final row = _tableRows[idx];
              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        row.isVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        size: 18,
                        color: row.isVisible ? AppColors.addGreen : AppColors.textSecondary,
                      ),
                      onPressed: () {
                        setState(() => row.isVisible = !row.isVisible);
                      },
                    ),
                    Expanded(
                      child: Text(
                        row.title,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          decoration: row.isVisible ? null : TextDecoration.lineThrough,
                        ),
                      ),
                    ),
                    if (idx > 0)
                      IconButton(
                        icon: const Icon(Icons.arrow_upward, size: 16),
                        onPressed: () {
                          setState(() {
                            final item = _tableRows.removeAt(idx);
                            _tableRows.insert(idx - 1, item);
                          });
                        },
                      ),
                    if (idx < _tableRows.length - 1)
                      IconButton(
                        icon: const Icon(Icons.arrow_downward, size: 16),
                        onPressed: () {
                          setState(() {
                            final item = _tableRows.removeAt(idx);
                            _tableRows.insert(idx + 1, item);
                          });
                        },
                      ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              style: TextButton.styleFrom(foregroundColor: AppColors.addGreen),
              onPressed: () {
                setState(() {
                  _tableRows.add(
                    TabularCardRow(
                      id: UniqueKey().toString(),
                      title: 'صف مخصص',
                      type: 'customText',
                    ),
                  );
                });
              },
              icon: const Icon(Icons.add, size: 16),
              label: const Text('+ إضافة صف للجدول', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ],
    );
  }

  // Group C: عناصر الكرت
  Widget _buildCardElementsAccordion() {
    return _buildCustomAccordion(
      title: 'عناصر الكرت والتحكم بالاتجاهات',
      subtitle: 'تحريك موضع كل عنصر بالمليمتر، الخط، الحجم، وصنف الكود',
      icon: Icons.tune_rounded,
      iconColor: const Color(0xFFD97706),
      children: [
        // Movement step selector
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('دقة حركة السهم (خطوة مم):', style: TextStyle(fontSize: 12.5)),
            DropdownButton<double>(
              value: _movementStepMm,
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(value: 0.25, child: Text('0.25 مم (دقيق جداً)')),
                DropdownMenuItem(value: 0.5, child: Text('0.5 مم (متوسط)')),
                DropdownMenuItem(value: 1.0, child: Text('1.0 مم (عادي)')),
                DropdownMenuItem(value: 2.0, child: Text('2.0 مم (سريع)')),
              ],
              onChanged: (v) {
                if (v != null) setState(() => _movementStepMm = v);
              },
            ),
          ],
        ),
        const Divider(height: 14),

        // Code & Serial generation settings
        ExpansionTile(
          initiallyExpanded: false,
          tilePadding: EdgeInsets.zero,
          title: const Text('إعدادات توليد الرموز والسيريال',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          leading: const Icon(Icons.password_rounded, color: AppColors.primary, size: 20),
          children: [
            _buildStepper(
              label: 'طول رمز الكرت (Username)',
              value: _codeLength.toDouble(),
              min: 3,
              max: 16,
              onDecrement: () => setState(() => _codeLength = (_codeLength - 1).clamp(3, 16)),
              onIncrement: () => setState(() => _codeLength = (_codeLength + 1).clamp(3, 16)),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('صنف الرمز:', style: TextStyle(fontSize: 12.5)),
                DropdownButton<VoucherCodeType>(
                  value: _codeType,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: VoucherCodeType.numeric, child: Text('أرقام فقط (0-9)')),
                    DropdownMenuItem(value: VoucherCodeType.alphanumeric, child: Text('حروف وأرقام')),
                    DropdownMenuItem(value: VoucherCodeType.alphaUpper, child: Text('حروف كبيرة فقط (A-Z)')),
                  ],
                  onChanged: (v) {
                    if (v != null) setState(() => _codeType = v);
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('نمط كلمة المرور:', style: TextStyle(fontSize: 12.5)),
                DropdownButton<CredentialMode>(
                  value: _credentialMode,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: CredentialMode.identical, child: Text('المستخدم وكلمة المرور متطابقان')),
                    DropdownMenuItem(value: CredentialMode.usernameAndPassword, child: Text('مستخدم وكلمة مرور منفصلة')),
                    DropdownMenuItem(value: CredentialMode.usernameOnly, child: Text('اسم مستخدم فقط (بدون كلمة مرور)')),
                  ],
                  onChanged: (v) {
                    if (v != null) setState(() => _credentialMode = v);
                  },
                ),
              ],
            ),
            if (_credentialMode == CredentialMode.usernameAndPassword) ...[
              const SizedBox(height: 8),
              _buildStepper(
                label: 'طول كلمة المرور',
                value: _passwordLength.toDouble(),
                min: 3,
                max: 16,
                onDecrement: () => setState(() => _passwordLength = (_passwordLength - 1).clamp(3, 16)),
                onIncrement: () => setState(() => _passwordLength = (_passwordLength + 1).clamp(3, 16)),
              ),
            ],
            const Divider(height: 14),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('تفعيل الرقم التسلسلي (Serial Number)',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              value: _enableSerial,
              activeColor: AppColors.addGreen,
              onChanged: (v) => setState(() => _enableSerial = v),
            ),
            if (_enableSerial) ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _serialPrefixCtrl,
                      decoration: InputDecoration(
                        labelText: 'بادئة السيريال',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _serialStartCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'بداية السيريال',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildStepper(
                label: 'خانات التعبئة (Padding)',
                value: _serialPadding.toDouble(),
                min: 1,
                max: 8,
                onDecrement: () => setState(() => _serialPadding = (_serialPadding - 1).clamp(1, 8)),
                onIncrement: () => setState(() => _serialPadding = (_serialPadding + 1).clamp(1, 8)),
              ),
            ],
          ],
        ),
        const Divider(height: 14),

        // List of elements
        ..._elementsConfig.entries.map((entry) {
          final key = entry.key;
          final cfg = entry.value;
          final label = cfg['label']?.toString() ?? key;
          final visible = cfg['visible'] as bool? ?? true;
          final isSelected = _selectedElementKey == key;

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary.withValues(alpha: 0.05) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: ExpansionTile(
              initiallyExpanded: isSelected,
              onExpansionChanged: (exp) {
                if (exp) setState(() => _selectedElementKey = key);
              },
              title: Row(
                children: [
                  Switch(
                    value: visible,
                    activeColor: AppColors.addGreen,
                    onChanged: (v) {
                      setState(() => cfg['visible'] = v);
                    },
                  ),
                  const SizedBox(width: 4),
                  Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
              childrenPadding: const EdgeInsets.all(12),
              children: [
                // Directional D-Pad Controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('تحريك المكان بالأسهم:', style: TextStyle(fontSize: 12)),
                    Row(
                      children: [
                        _buildArrowButton(Icons.arrow_upward, () {
                          setState(() {
                            final y = (cfg['y'] as num).toDouble();
                            cfg['y'] = (y - _movementStepMm).clamp(0.0, 100.0);
                          });
                        }),
                        const SizedBox(width: 4),
                        _buildArrowButton(Icons.arrow_downward, () {
                          setState(() {
                            final y = (cfg['y'] as num).toDouble();
                            cfg['y'] = (y + _movementStepMm).clamp(0.0, 100.0);
                          });
                        }),
                        const SizedBox(width: 4),
                        _buildArrowButton(Icons.arrow_back, () {
                          setState(() {
                            final x = (cfg['x'] as num).toDouble();
                            cfg['x'] = (x - _movementStepMm).clamp(0.0, 100.0);
                          });
                        }),
                        const SizedBox(width: 4),
                        _buildArrowButton(Icons.arrow_forward, () {
                          setState(() {
                            final x = (cfg['x'] as num).toDouble();
                            cfg['x'] = (x + _movementStepMm).clamp(0.0, 100.0);
                          });
                        }),
                      ],
                    ),
                  ],
                ),
                if (cfg.containsKey('fontSize')) ...[
                  const SizedBox(height: 8),
                  _buildStepper(
                    label: 'حجم الخط',
                    value: (cfg['fontSize'] as num).toDouble(),
                    min: 6,
                    onDecrement: () {
                      setState(() {
                        final fs = (cfg['fontSize'] as num).toDouble();
                        cfg['fontSize'] = (fs - 0.5).clamp(6.0, 36.0);
                      });
                    },
                    onIncrement: () {
                      setState(() {
                        final fs = (cfg['fontSize'] as num).toDouble();
                        cfg['fontSize'] = (fs + 0.5).clamp(6.0, 36.0);
                      });
                    },
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FilterChip(
                        label: const Text('غامق Bold'),
                        selected: cfg['bold'] as bool? ?? false,
                        onSelected: (v) => setState(() => cfg['bold'] = v),
                      ),
                      FilterChip(
                        label: const Text('مائل Italic'),
                        selected: cfg['italic'] as bool? ?? false,
                        onSelected: (v) => setState(() => cfg['italic'] = v),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildArrowButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: AppColors.primary),
      ),
    );
  }

  // =========================================================================
  // 2.3 Sticky Live Preview Dock
  // =========================================================================

  Widget _buildStickyLivePreviewDock() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Dock Header: معاينة 👁 + Active element
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.remove_red_eye_rounded, size: 16, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Text(
                        'معاينة 👁 (${_elementsConfig[_selectedElementKey]?['label'] ?? _selectedElementKey})',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '$_columnsCount × $_rowsCount = ${_columnsCount * _rowsCount} كرت/صفحة',
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              // Live Card Render
              _buildLiveCardPreviewWidget(),
              const SizedBox(height: 8),

              // Wide Emerald PDF Preview Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.addGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _handlePdfPreview,
                  icon: const Icon(Icons.picture_as_pdf_rounded),
                  label: const Text(
                    'معاينة PDF (A4)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLiveCardPreviewWidget() {
    return Container(
      height: 110,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_borderRadius),
        border: Border.all(color: _borderColor, width: _borderWidth),
        image: _bgImagePath != null && File(_bgImagePath!).existsSync()
            ? DecorationImage(
                image: FileImage(File(_bgImagePath!)),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: _useTabularLayout
          ? _buildTabularLiveCard()
          : _buildFreeformLiveCard(),
    );
  }

  Widget _buildTabularLiveCard() {
    final activeRows = _tableRows.where((r) => r.isVisible).take(4).toList();
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: activeRows.map((r) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                r.title,
                style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
              ),
              Text(
                _getMockValueForRow(r.type),
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  String _getMockValueForRow(String type) {
    switch (type) {
      case 'netName':
        return _netNameCtrl.text;
      case 'username':
        return '849201';
      case 'password':
        return '4591';
      case 'validity':
        return _validityCtrl.text;
      case 'price':
        return '${_priceCtrl.text} YER';
      case 'serialNumber':
        return '${_serialPrefixCtrl.text}0001';
      default:
        return 'قيمة الكرت';
    }
  }

  Widget _buildFreeformLiveCard() {
    final userCfg = _elementsConfig['username']!;
    final passCfg = _elementsConfig['password']!;
    final qrCfg = _elementsConfig['qrCode']!;
    final netCfg = _elementsConfig['networkName']!;
    final priceCfg = _elementsConfig['price']!;

    return Stack(
      children: [
        if (netCfg['visible'] as bool? ?? true)
          Positioned(
            top: 6,
            left: 0,
            right: 0,
            child: Text(
              _netNameCtrl.text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: netCfg['bold'] as bool? ?? true ? FontWeight.bold : FontWeight.normal,
                color: Color(netCfg['color'] as int? ?? 0xFF0F766E),
              ),
            ),
          ),
        if (qrCfg['visible'] as bool? ?? true)
          Positioned(
            left: 10,
            top: 28,
            child: QrImageView(
              data: 'http://login.hotspot/?user=849201',
              size: 40,
              padding: EdgeInsets.zero,
            ),
          ),
        Positioned(
          right: 12,
          top: 30,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (userCfg['visible'] as bool? ?? true)
                Text(
                  'كود: 849201',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: userCfg['bold'] as bool? ?? true ? FontWeight.bold : FontWeight.normal,
                    color: Color(userCfg['color'] as int? ?? 0xFF0F172A),
                  ),
                ),
              if (passCfg['visible'] as bool? ?? true)
                Text(
                  'كلمة السر: 4591',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(passCfg['color'] as int? ?? 0xFF334155),
                  ),
                ),
            ],
          ),
        ),
        if (priceCfg['visible'] as bool? ?? true)
          Positioned(
            right: 12,
            bottom: 6,
            child: Text(
              '${_priceCtrl.text} YER',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(priceCfg['color'] as int? ?? 0xFF0D7A5F),
              ),
            ),
          ),
      ],
    );
  }

  // =========================================================================
  // Accordion Wrapper
  // =========================================================================

  Widget _buildCustomAccordion({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: ExpansionTile(
        shape: const Border(),
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: iconColor),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary)),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        children: children,
      ),
    );
  }

  Widget _buildStepper({
    required String label,
    required num value,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
    String? unit,
    num min = 0,
    num? max,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: value > min ? onDecrement : null,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.deletePink,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.deleteRed.withValues(alpha: 0.2)),
                  ),
                  child: const Icon(Icons.remove, size: 16, color: AppColors.deleteRed),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              constraints: const BoxConstraints(minWidth: 44),
              alignment: Alignment.center,
              child: Text(
                unit != null ? '$value $unit' : '$value',
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: (max == null || value < max) ? onIncrement : null,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.addGreen,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.add, size: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showImagePathDialog(BuildContext context) {
    final ctrl = TextEditingController(text: _bgImagePath ?? '');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('مسار صورة خلفية الكرت'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: ctrl,
              decoration: const InputDecoration(
                hintText: '/storage/emulated/0/.../card_template.png',
                labelText: 'المسار المحلي للصورة',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.addGreen),
            onPressed: () {
              setState(() => _bgImagePath = ctrl.text.trim().isEmpty ? null : ctrl.text.trim());
              Navigator.pop(ctx);
            },
            child: const Text('تطبيق', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // Tab 2: Batches History
  // =========================================================================

  Widget _buildBatchesHistoryTab(
      AsyncValue<List<VoucherBatchesTableData>> batchesAsync) {
    return batchesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('خطأ في تحميل سجل الدفعات: $e')),
      data: (batches) {
        if (batches.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history_toggle_off_rounded,
                    size: 64, color: AppColors.textSecondary),
                SizedBox(height: 12),
                Text('لا توجد دفعات كروت سابقة',
                    style: TextStyle(fontSize: 16, color: AppColors.textSecondary)),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(14),
          itemCount: batches.length,
          itemBuilder: (context, idx) {
            final b = batches[idx];
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                  child: const Icon(Icons.style_rounded, color: AppColors.primary),
                ),
                title: Text(
                  '${b.profileName} (${b.quantity} كرت)',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'النظام: ${b.systemType} • ${DateFormat('yyyy/MM/dd HH:mm').format(b.generatedAt)}',
                  style: const TextStyle(fontSize: 11),
                ),
                trailing: Text(
                  '${b.totalAmount.toStringAsFixed(0)} YER',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: AppColors.addGreen),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
