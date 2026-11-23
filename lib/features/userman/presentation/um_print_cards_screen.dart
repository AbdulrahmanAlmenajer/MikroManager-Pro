import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/pdf_generator_helper.dart';
import '../../routers/domain/routers_notifier.dart';
import '../../vouchers/domain/unified_card_model.dart';
import '../../vouchers/domain/vouchers_notifier.dart';
import '../../vouchers/presentation/template_gallery_screen.dart';
import '../domain/um_profile_model.dart';
import '../domain/userman_notifier.dart';

class UmPrintCardsScreen extends ConsumerStatefulWidget {
  final String? initialProfile;
  const UmPrintCardsScreen({super.key, this.initialProfile});

  @override
  ConsumerState<UmPrintCardsScreen> createState() => _UmPrintCardsScreenState();
}

class _UmPrintCardsScreenState extends ConsumerState<UmPrintCardsScreen> {
  String? _selectedProfile;
  String _cardFilter =
      'unprinted'; // 'all', 'unprinted', 'printed', 'new', 'used'
  final Set<String> _selectedCardUsernames = {};
  int _copies = 1;
  VoucherTemplatesTableData? _selectedTemplate;
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selectedProfile = widget.initialProfile;
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final usermanState = ref.watch(usermanControllerProvider);
    final activeRouter = ref.watch(routersControllerProvider).activeRouter;
    final templatesAsync = ref.watch(voucherTemplatesStreamProvider);
    final profiles = usermanState.parsedProfiles;

    // Auto-select first profile if none selected
    if (_selectedProfile == null && profiles.isNotEmpty) {
      _selectedProfile = profiles.first.name;
    }

    // Get cards for selected profile
    final allCards = usermanState.parsedUsers;
    final profileCards = _selectedProfile != null
        ? allCards.where((c) => c.profile == _selectedProfile).toList()
        : allCards;

    // Apply status filter
    final filteredCards = profileCards.where((c) {
      if (_searchQuery.isNotEmpty) {
        if (!c.username.toLowerCase().contains(_searchQuery.toLowerCase())) {
          return false;
        }
      }
      switch (_cardFilter) {
        case 'unprinted':
          return !c.isPrinted && !c.isUsed;
        case 'printed':
          return c.isPrinted;
        case 'new':
          return !c.isUsed && c.status != CardStatus.disabled;
        case 'used':
          return c.isUsed;
        case 'all':
        default:
          return true;
      }
    }).toList();

    final selectedProfileObj = profiles.firstWhere(
      (p) => p.name == _selectedProfile,
      orElse: () => UmProfileModel(id: '', name: _selectedProfile ?? 'default'),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('طباعة كروت User Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'تحديث بيانات الراوتر',
            onPressed: () =>
                ref.read(usermanControllerProvider.notifier).refreshAll(),
          ),
          IconButton(
            icon: const Icon(Icons.palette_outlined),
            tooltip: 'إدارة قوالب الطباعة',
            onPressed: () => context.push('/templates'),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'المحدد: ${_selectedCardUsernames.length} من أصل ${filteredCards.length} كرت',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    if (_selectedCardUsernames.isNotEmpty)
                      Text(
                        'إجمالي القيمة: ${(_selectedCardUsernames.length * selectedProfileObj.price).toStringAsFixed(0)} YER',
                        style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.success,
                            fontWeight: FontWeight.bold),
                      ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.cyanAccent,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _selectedCardUsernames.isEmpty
                    ? null
                    : () => _printSelectedCards(
                        context, filteredCards, selectedProfileObj),
                icon: const Icon(Icons.print),
                label: const Text('معاينة وطباعة',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
      body: usermanState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SECTION 1: Router Connection Info Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                                AppColors.navyPrimary.withValues(alpha: 0.1),
                            child: const Icon(Icons.router,
                                color: AppColors.navyPrimary),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  activeRouter != null
                                      ? 'الراوتر المتصل: ${activeRouter.name}'
                                      : 'الراوتر الافتراضي',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                                Text(
                                  activeRouter != null
                                      ? '${activeRouter.ipAddress}:${activeRouter.apiPort}'
                                      : 'متصل ومطابق',
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                            ),
                            onPressed: () => context.push('/routers'),
                            icon: const Icon(Icons.swap_horiz, size: 16),
                            label: const Text('تغيير الراوتر',
                                style: TextStyle(fontSize: 11)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // SECTION 2: Profile Selection & Specs Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '1. اختر بروفايل User Manager للطباعة',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(height: 12),
                          if (profiles.isEmpty)
                            const Text(
                              'لا توجد بروفايلات مسجلة في User Manager بالراوتر حالياً.',
                              style: TextStyle(color: AppColors.danger),
                            )
                          else
                            DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                labelText: 'بروفايل الكروت المطلوب طباعتها *',
                                prefixIcon: Icon(Icons.folder_special),
                              ),
                              value: _selectedProfile,
                              items: profiles.map((p) {
                                return DropdownMenuItem(
                                  value: p.name,
                                  child: Text(
                                    '${p.displayName} (${p.usersCount} كرت - ${p.price.toStringAsFixed(0)} YER)',
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                );
                              }).toList(),
                              onChanged: (val) {
                                setState(() {
                                  _selectedProfile = val;
                                  _selectedCardUsernames.clear();
                                });
                              },
                            ),
                          const SizedBox(height: 12),
                          // Selected profile metadata banner
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color:
                                  AppColors.cyanAccent.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'الصلاحية: ${selectedProfileObj.validity ?? "غير محددة"}',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'السعر: ${selectedProfileObj.price.toStringAsFixed(0)} YER',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.success),
                                ),
                                Text(
                                  'المشتركون: ${selectedProfileObj.usersCount} كرت',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // SECTION 3: Template & Layout Selection
                  templatesAsync.when(
                    data: (templates) {
                      if (_selectedTemplate == null && templates.isNotEmpty) {
                        _selectedTemplate = templates.firstWhere(
                          (t) => t.isDefault,
                          orElse: () => templates.first,
                        );
                      }
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    '2. قالب الطباعة المستخدم',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  TextButton.icon(
                                    onPressed: () => context.push('/templates'),
                                    icon: const Icon(Icons.add, size: 16),
                                    label: const Text('قالب جديد',
                                        style: TextStyle(fontSize: 12)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<
                                  VoucherTemplatesTableData>(
                                decoration: const InputDecoration(
                                  labelText: 'اختر القالب',
                                  prefixIcon: Icon(Icons.palette),
                                ),
                                value: _selectedTemplate,
                                items: templates.map((t) {
                                  return DropdownMenuItem(
                                    value: t,
                                    child: Text(
                                      '${t.name} (${t.paperSize} - ${t.cardsPerPage} كرت)',
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() => _selectedTemplate = val);
                                  }
                                },
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Text('عدد النسخ المطبوعة:',
                                      style: TextStyle(fontSize: 13)),
                                  const SizedBox(width: 12),
                                  DropdownButton<int>(
                                    value: _copies,
                                    items: [1, 2, 3, 4, 5].map((c) {
                                      return DropdownMenuItem(
                                          value: c, child: Text('$c نسخة'));
                                    }).toList(),
                                    onChanged: (val) {
                                      if (val != null) {
                                        setState(() => _copies = val);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 16),

                  // SECTION 4: Cards Selection & Filtering
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '3. تحديد الكروت المطلوبة',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              Row(
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _selectedCardUsernames.addAll(
                                            filteredCards
                                                .map((c) => c.username));
                                      });
                                    },
                                    child: const Text('تحديد الكل',
                                        style: TextStyle(fontSize: 12)),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _selectedCardUsernames.clear();
                                      });
                                    },
                                    child: const Text('إلغاء التحديد',
                                        style: TextStyle(fontSize: 12)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Filter Chips (الكل / غير المطبوعة / المطبوعة / الجديدة / المستخدمة)
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                ChoiceChip(
                                  label:
                                      const Text('غير المطبوعة (جاهزة للبيع)'),
                                  selected: _cardFilter == 'unprinted',
                                  onSelected: (val) {
                                    if (val) {
                                      setState(() => _cardFilter = 'unprinted');
                                    }
                                  },
                                ),
                                const SizedBox(width: 8),
                                ChoiceChip(
                                  label: const Text('الكروت الجديدة'),
                                  selected: _cardFilter == 'new',
                                  onSelected: (val) {
                                    if (val) {
                                      setState(() => _cardFilter = 'new');
                                    }
                                  },
                                ),
                                const SizedBox(width: 8),
                                ChoiceChip(
                                  label: const Text('المطبوعة سابقاً'),
                                  selected: _cardFilter == 'printed',
                                  onSelected: (val) {
                                    if (val) {
                                      setState(() => _cardFilter = 'printed');
                                    }
                                  },
                                ),
                                const SizedBox(width: 8),
                                ChoiceChip(
                                  label: const Text('جميع الكروت'),
                                  selected: _cardFilter == 'all',
                                  onSelected: (val) {
                                    if (val) {
                                      setState(() => _cardFilter = 'all');
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Search field
                          TextField(
                            controller: _searchCtrl,
                            decoration: const InputDecoration(
                              hintText: 'بحث في أرقام الكروت...',
                              prefixIcon: Icon(Icons.search, size: 20),
                              isDense: true,
                            ),
                            onChanged: (val) =>
                                setState(() => _searchQuery = val.trim()),
                          ),
                          const SizedBox(height: 12),

                          // Cards List with Checkboxes
                          if (filteredCards.isEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 24),
                              child: Center(
                                child: Text(
                                  'لا توجد كروت مطابقة لهذا البروفايل والفلتر.',
                                  style:
                                      TextStyle(color: AppColors.textSecondary),
                                ),
                              ),
                            )
                          else
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: filteredCards.length,
                              separatorBuilder: (_, __) =>
                                  const Divider(height: 1),
                              itemBuilder: (context, idx) {
                                final card = filteredCards[idx];
                                final isSelected = _selectedCardUsernames
                                    .contains(card.username);

                                return CheckboxListTile(
                                  value: isSelected,
                                  onChanged: (val) {
                                    setState(() {
                                      if (val == true) {
                                        _selectedCardUsernames
                                            .add(card.username);
                                      } else {
                                        _selectedCardUsernames
                                            .remove(card.username);
                                      }
                                    });
                                  },
                                  title: Text(
                                    card.username,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                  subtitle: Text(
                                    'كلمة السر: ${card.password.isNotEmpty ? card.password : "نفس الاسم"}  |  الاستهلاك: ${card.uptime ?? "0s"}',
                                    style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textSecondary),
                                  ),
                                  secondary: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: card.isPrinted
                                          ? AppColors.textSecondary
                                              .withValues(alpha: 0.1)
                                          : AppColors.success
                                              .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      card.isPrinted ? 'مطبوع' : 'جديد',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: card.isPrinted
                                            ? AppColors.textSecondary
                                            : AppColors.success,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _printSelectedCards(
    BuildContext context,
    List<UnifiedCardModel> allCards,
    UmProfileModel profile,
  ) {
    // Collect selected unified cards
    final selectedCards = allCards
        .where((c) => _selectedCardUsernames.contains(c.username))
        .toList();

    // Multiply by copies if > 1
    final List<VoucherCardData> printList = [];
    for (int i = 0; i < _copies; i++) {
      for (final card in selectedCards) {
        printList.add(card.toVoucherCardData());
      }
    }

    // Pass vouchers to vouchersControllerProvider so preview screen can display them
    ref
        .read(vouchersControllerProvider.notifier)
        .setVouchersForPreview(printList);

    context.push('/print-preview');
  }
}
