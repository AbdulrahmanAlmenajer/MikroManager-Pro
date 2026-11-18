import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/tasks/task_runner.dart';
import '../../routers/domain/routers_notifier.dart';

enum CardsToolCategory { all, create, manage, files }

class CardsToolItem {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final CardsToolCategory category;
  final String route;
  final Object? extra;

  const CardsToolItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.category,
    required this.route,
    this.extra,
  });
}

class CardsHubScreen extends ConsumerStatefulWidget {
  const CardsHubScreen({super.key});

  @override
  ConsumerState<CardsHubScreen> createState() => _CardsHubScreenState();
}

class _CardsHubScreenState extends ConsumerState<CardsHubScreen> {
  CardsToolCategory _selectedCategory = CardsToolCategory.all;
  String _searchQuery = '';
  final TextEditingController _searchCtrl = TextEditingController();

  static const List<CardsToolItem> _tools = [
    CardsToolItem(
      id: 'hotspot_generator',
      title: 'مولد كروت الهوتسبوت',
      subtitle:
          'توليد دفعات كروت هوتسبوت جماعية وتصديرها لملف PDF جاهز للطباعة',
      icon: Icons.wifi_tethering_rounded,
      iconColor: AppColors.cyanAccent,
      category: CardsToolCategory.create,
      route: '/vouchers/generate',
    ),
    CardsToolItem(
      id: 'userman_generator',
      title: 'مولد كروت User Manager',
      subtitle: 'إنشاء وتفعيل كروت اليوزر منجر مع دعم ملاك البروفايلات v6 و v7',
      icon: Icons.manage_accounts_rounded,
      iconColor: Color(0xFF8B5CF6),
      category: CardsToolCategory.create,
      route: '/vouchers/generate',
    ),
    CardsToolItem(
      id: 'card_inquiry',
      title: 'فاحص سلامة الكرت (تشخيص فوري)',
      subtitle:
          'الاستعلام عن حالة الكرت، الماك المرتبط، الرصيد المتبقي وفصل الارتباط',
      icon: Icons.search_rounded,
      iconColor: AppColors.success,
      category: CardsToolCategory.manage,
      route: '/card-inquiry',
    ),
    CardsToolItem(
      id: 'userman_manager',
      title: 'مشتركو وجلسات User Manager',
      subtitle: 'إدارة بطاقات اليوزر منجر والجلسات الحية النشطة وإلغاء الجلسات',
      icon: Icons.supervised_user_circle_rounded,
      iconColor: Color(0xFFF97316),
      category: CardsToolCategory.manage,
      route: '/userman',
    ),
    CardsToolItem(
      id: 'um_diagnostic',
      title: 'فاحص صحة User Manager (7 نقاط)',
      subtitle: 'فحص خادم RADIUS وحزم البروفايلات وصلاحيات المالك ومنافذ CoA',
      icon: Icons.health_and_safety_rounded,
      iconColor: Color(0xFFEC4899),
      category: CardsToolCategory.manage,
      route: '/um-diagnostic',
    ),
    CardsToolItem(
      id: 'template_gallery',
      title: 'معرض قوالب الكروت',
      subtitle: 'تخصيص وتعديل قوالب وتصاميم طباعة الكروت لشبكات A4 والحراري',
      icon: Icons.palette_rounded,
      iconColor: Color(0xFF3B82F6),
      category: CardsToolCategory.files,
      route: '/templates',
    ),
    CardsToolItem(
      id: 'pdf_archive',
      title: 'أرشيف طباعة PDF',
      subtitle:
          'استعراض وإعادة طباعة أو مشاركة دفعات الكروت السابقة المخزنة محلياً',
      icon: Icons.picture_as_pdf_rounded,
      iconColor: AppColors.danger,
      category: CardsToolCategory.files,
      route: '/pdf-archive',
    ),
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeRouter = ref.watch(routersControllerProvider).activeRouter;
    final connectionId = activeRouter?.id ?? 0;

    final filteredTools = _tools.where((tool) {
      if (_selectedCategory != CardsToolCategory.all &&
          tool.category != _selectedCategory) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        return tool.title.toLowerCase().contains(q) ||
            tool.subtitle.toLowerCase().contains(q);
      }
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('مركز أدوات البطاقات والكروت'),
        actions: [
          if (activeRouter != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Chip(
                avatar: const Icon(Icons.router, size: 16, color: Colors.white),
                label: Text(
                  activeRouter.name,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
                backgroundColor: AppColors.navyPrimary,
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Column(
              children: [
                TextField(
                  controller: _searchCtrl,
                  decoration: InputDecoration(
                    hintText: 'بحث في أدوات الكروت (توليد، قوالب، تشخيص...)...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchCtrl.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _searchCtrl.clear();
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                  ),
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val.trim();
                    });
                  },
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip(
                          'الكل (${_tools.length})', CardsToolCategory.all),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                          'إنشاء الكروت', CardsToolCategory.create),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                          'إدارة الكروت', CardsToolCategory.manage),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                          'الملفات والطباعة', CardsToolCategory.files),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Interrupted Batches Banner
          if (connectionId > 0)
            StreamBuilder<List<TaskCheckpointInfo>>(
              stream: ref
                  .watch(taskRunnerProvider)
                  .watchIncompleteTasks(connectionId),
              builder: (context, snapshot) {
                final tasks = snapshot.data ?? [];
                if (tasks.isEmpty) return const SizedBox.shrink();

                final firstTask = tasks.first;
                return Container(
                  margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.15),
                    border: Border.all(color: AppColors.warning),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.restore_page,
                          color: AppColors.warning, size: 24),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'يوجد دفعة كروت معلقة (${firstTask.processedItems}/${firstTask.totalItems}) يمكنك استئنافها.',
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFB45309)),
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.push('/vouchers'),
                        child: const Text('متابعة الدفعة'),
                      ),
                    ],
                  ),
                );
              },
            ),

          // Tools Grid / List
          Expanded(
            child: filteredTools.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off,
                            size: 64,
                            color:
                                AppColors.textSecondary.withValues(alpha: 0.4)),
                        const SizedBox(height: 12),
                        Text(
                          'لا توجد أدوات مطابقة لبحثك "$_searchQuery"',
                          style: const TextStyle(
                              fontSize: 15, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredTools.length,
                    itemBuilder: (context, index) {
                      final tool = filteredTools[index];
                      return _buildToolCard(context, tool);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, CardsToolCategory category) {
    final isSelected = _selectedCategory == category;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (val) {
        if (val) {
          setState(() {
            _selectedCategory = category;
          });
        }
      },
    );
  }

  Widget _buildToolCard(BuildContext context, CardsToolItem tool) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => context.push(tool.route, extra: tool.extra),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: tool.iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(tool.icon, color: tool.iconColor, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tool.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tool.subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios,
                  size: 16, color: Color(0xFFCBD5E1)),
            ],
          ),
        ),
      ),
    );
  }
}
