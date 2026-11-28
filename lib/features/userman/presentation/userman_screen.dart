import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../vouchers/domain/unified_card_model.dart';
import '../domain/um_profile_model.dart';
import '../domain/userman_notifier.dart';

class UsermanScreen extends ConsumerStatefulWidget {
  const UsermanScreen({super.key});

  @override
  ConsumerState<UsermanScreen> createState() => _UsermanScreenState();
}

class _UsermanScreenState extends ConsumerState<UsermanScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';
  String? _selectedProfileFilter;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(usermanControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة اليوزر منجر (User Manager)'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.cyanAccent,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          isScrollable: true,
          tabs: [
            Tab(
              icon: const Icon(Icons.people_alt_outlined),
              text: 'المستخدمون (${state.users.length})',
            ),
            Tab(
              icon: const Icon(Icons.folder_special_outlined),
              text: 'البروفايلات (${state.parsedProfiles.length})',
            ),
            Tab(
              icon: const Icon(Icons.flash_on_outlined),
              text: 'الجلسات الحية (${state.sessions.length})',
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.print_outlined),
            tooltip: 'توليد وطباعة كروت User Manager',
            onPressed: () => context.push('/vouchers/generate?isUserManager=true'),
          ),
          IconButton(
            icon: const Icon(Icons.health_and_safety_outlined),
            tooltip: 'فاحص صحة User Manager',
            onPressed: () => context.push('/um-diagnostic'),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'تحديث البيانات',
            onPressed: () =>
                ref.read(usermanControllerProvider.notifier).refreshAll(),
          ),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton.extended(
              onPressed: () => _showAddUserDialog(context, state.profiles),
              backgroundColor: AppColors.cyanAccent,
              icon: const Icon(Icons.person_add, color: Colors.white),
              label: const Text('إضافة مشترك',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            )
          : (_tabController.index == 1
              ? FloatingActionButton.extended(
                  onPressed: () => context.push('/vouchers/generate?isUserManager=true'),
                  backgroundColor: AppColors.navyPrimary,
                  icon: const Icon(Icons.print, color: Colors.white),
                  label: const Text('توليد كروت',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                )
              : null),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.errorMessage != null &&
                  state.users.isEmpty &&
                  state.parsedProfiles.isEmpty
              ? _buildErrorView(state.errorMessage!)
              : Column(
                  children: [
                    // Search & Filters bar
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchCtrl,
                              decoration: InputDecoration(
                                hintText: _tabController.index == 1
                                    ? 'بحث في البروفايلات...'
                                    : 'بحث في المشتركين أو الجلسات...',
                                prefixIcon: const Icon(Icons.search),
                                suffixIcon: _searchQuery.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.clear),
                                        onPressed: () {
                                          setState(() {
                                            _searchCtrl.clear();
                                            _searchQuery = '';
                                          });
                                          ref
                                              .read(usermanControllerProvider
                                                  .notifier)
                                              .setSearchQuery('');
                                        },
                                      )
                                    : null,
                                isDense: true,
                              ),
                              onChanged: (val) {
                                setState(() {
                                  _searchQuery = val.trim().toLowerCase();
                                });
                                ref
                                    .read(usermanControllerProvider.notifier)
                                    .setSearchQuery(val);
                              },
                            ),
                          ),
                          if (_tabController.index == 0 &&
                              state.parsedProfiles.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            DropdownButton<String?>(
                              value: _selectedProfileFilter,
                              hint: const Text('كل البروفايلات',
                                  style: TextStyle(fontSize: 12)),
                              underline: const SizedBox(),
                              items: [
                                const DropdownMenuItem(
                                    value: null, child: Text('الكل')),
                                ...state.parsedProfiles.map(
                                  (p) => DropdownMenuItem(
                                    value: p.name,
                                    child: Text(p.displayName,
                                        style: const TextStyle(fontSize: 13)),
                                  ),
                                ),
                              ],
                              onChanged: (val) {
                                setState(() => _selectedProfileFilter = val);
                                ref
                                    .read(usermanControllerProvider.notifier)
                                    .setProfileFilter(val);
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildUsersTab(state),
                          _buildProfilesTab(state),
                          _buildSessionsTab(state),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildErrorView(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.manage_accounts_outlined,
                size: 64, color: AppColors.danger.withValues(alpha: 0.7)),
            const SizedBox(height: 16),
            const Text('تعذر تحميل بيانات User Manager',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            Text(error,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () =>
                  ref.read(usermanControllerProvider.notifier).refreshAll(),
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsersTab(UsermanState state) {
    final filtered = state.filteredUsers;

    if (filtered.isEmpty) {
      final isSearching =
          _searchQuery.isNotEmpty || _selectedProfileFilter != null;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSearching
                  ? Icons.search_off_outlined
                  : Icons.person_off_outlined,
              size: 64,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 12),
            Text(
              isSearching
                  ? 'لا توجد بطاقات مطابقة لمعايير البحث'
                  : 'لا توجد بطاقات مسجلة في User Manager',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            if (isSearching) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _searchCtrl.clear();
                    _searchQuery = '';
                    _selectedProfileFilter = null;
                  });
                  ref
                      .read(usermanControllerProvider.notifier)
                      .setSearchQuery('');
                  ref
                      .read(usermanControllerProvider.notifier)
                      .setProfileFilter(null);
                },
                icon: const Icon(Icons.clear),
                label: const Text('مسح الفلاتر'),
              ),
            ],
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () =>
          ref.read(usermanControllerProvider.notifier).refreshAll(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          final user = filtered[index];
          final id = user.id;
          final username = user.username;
          final profile = user.profile;
          final uptime = user.uptime ?? '-';
          final comment = user.comment;

          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: user.status == CardStatus.active
                    ? AppColors.success.withValues(alpha: 0.15)
                    : (user.status == CardStatus.disabled
                        ? AppColors.danger.withValues(alpha: 0.15)
                        : AppColors.cyanAccent.withValues(alpha: 0.15)),
                child: Icon(
                  user.status == CardStatus.active
                      ? Icons.flash_on
                      : (user.status == CardStatus.disabled
                          ? Icons.block
                          : Icons.person),
                  color: user.status == CardStatus.active
                      ? AppColors.success
                      : (user.status == CardStatus.disabled
                          ? AppColors.danger
                          : AppColors.cyanAccent),
                ),
              ),
              title: Row(
                children: [
                  Expanded(
                    child: Text(username,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.navyPrimary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      user.status.labelArabic,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: user.status == CardStatus.active
                            ? AppColors.success
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              subtitle: Text(
                'البروفايل: $profile | الاستهلاك: $uptime'
                '${comment != null ? "\nملاحظة: $comment" : ""}',
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, color: AppColors.danger),
                tooltip: 'حذف المشترك',
                onPressed: () => _confirmDeleteUser(context, id, username),
              ),
            ),
          );
        },
      ),
    );
  }

  // =========================================================================
  // Tab 2: User Manager Profiles Tab (المهمة 3)
  // =========================================================================

  Widget _buildProfilesTab(UsermanState state) {
    final profiles = state.filteredProfiles;

    if (profiles.isEmpty) {
      final isSearching = _searchQuery.isNotEmpty;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSearching
                  ? Icons.search_off_outlined
                  : Icons.folder_off_outlined,
              size: 64,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 12),
            Text(
              isSearching
                  ? 'لا توجد بروفايلات مطابقة لبحثك "$_searchQuery"'
                  : (state.diagnosticDetails ??
                      'لا توجد بروفايلات مسجلة في User Manager'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () =>
                      ref.read(usermanControllerProvider.notifier).refreshAll(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('تحديث من الراوتر'),
                ),
                const SizedBox(width: 10),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFEC4899),
                    side: const BorderSide(color: Color(0xFFEC4899)),
                  ),
                  onPressed: () => context.push('/um-diagnostic'),
                  icon: const Icon(Icons.health_and_safety, size: 18),
                  label: const Text('فحص صحة UM'),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () =>
          ref.read(usermanControllerProvider.notifier).refreshAll(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: profiles.length,
        itemBuilder: (context, index) {
          final profile = profiles[index];
          return _buildProfileCard(context, profile);
        },
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, UmProfileModel profile) {
    final validityText =
        profile.validity != null && profile.validity!.isNotEmpty
            ? profile.validity!
            : 'غير محددة';
    final priceText = profile.price > 0
        ? '${profile.price.toStringAsFixed(0)} YER'
        : 'غير مسعر';

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row: Name & Price
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.cyanAccent.withValues(alpha: 0.15),
                  child: const Icon(Icons.tune, color: AppColors.cyanAccent),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.displayName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (profile.nameForUsers != null &&
                          profile.nameForUsers != profile.name)
                        Text(
                          'الاسم الأصلي: ${profile.name}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ),
                // Price chip (clickable to edit price)
                InkWell(
                  onTap: () => _showEditPriceDialog(context, profile),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: profile.price > 0
                          ? AppColors.success.withValues(alpha: 0.15)
                          : AppColors.warning.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: profile.price > 0
                            ? AppColors.success
                            : AppColors.warning,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          priceText,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: profile.price > 0
                                ? AppColors.success
                                : AppColors.warning,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.edit, size: 14),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 20),

            // Profile Specs Grid
            Row(
              children: [
                _buildProfileMetric(
                  icon: Icons.timer_outlined,
                  label: 'الصلاحية',
                  value: validityText,
                  color: AppColors.navyPrimary,
                ),
                _buildProfileMetric(
                  icon: Icons.group_outlined,
                  label: 'المشتركون',
                  value: '${profile.usersCount} كرت',
                  color: AppColors.cyanAccent,
                ),
                _buildProfileMetric(
                  icon: Icons.flash_on_outlined,
                  label: 'نشط حالياً',
                  value: '${profile.activeSessionsCount}',
                  color: AppColors.success,
                ),
                _buildProfileMetric(
                  icon: Icons.devices_outlined,
                  label: 'الأجهزة',
                  value: '${profile.sharedUsers}',
                  color: AppColors.textSecondary,
                ),
              ],
            ),

            if (profile.rateLimit != null && profile.rateLimit!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.speed,
                        size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    Text(
                      'تحديد السرعة: ${profile.rateLimit}',
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],

            if (profile.owner != null && profile.owner!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                'المالك (Customer): ${profile.owner}',
                style: const TextStyle(
                    fontSize: 11, color: AppColors.textSecondary),
              ),
            ],

            const SizedBox(height: 14),

            // Action Buttons Bar
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.cyanAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      context.push(
                          '/vouchers/generate?isUserManager=true&profile=${profile.name}');
                    },
                    icon: const Icon(Icons.print, size: 16),
                    label: const Text('طباعة كروت',
                        style: TextStyle(fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedProfileFilter = profile.name;
                        _tabController.index = 0;
                      });
                      ref
                          .read(usermanControllerProvider.notifier)
                          .setProfileFilter(profile.name);
                    },
                    icon: const Icon(Icons.people_outline, size: 16),
                    label: const Text('عرض الكروت',
                        style: TextStyle(fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.info_outline),
                  tooltip: 'تفاصيل إضافية',
                  onPressed: () => _showProfileDetailsSheet(context, profile),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileMetric({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(
                  fontSize: 10, color: AppColors.textSecondary)),
          Text(
            value,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _showEditPriceDialog(BuildContext context, UmProfileModel profile) {
    final priceCtrl = TextEditingController(
      text: profile.price > 0 ? profile.price.toStringAsFixed(0) : '',
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('تحديد سعر البروفايل: ${profile.displayName}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'أدخل السعر المحلي لكرت هذا البروفايل بالريال (يستخدم في تقارير المبيعات وطباعة الكروت):',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: priceCtrl,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'سعر الكرت (YER)',
                prefixIcon: Icon(Icons.attach_money),
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
            onPressed: () async {
              final newPrice = double.tryParse(priceCtrl.text.trim()) ?? 0.0;
              await ref
                  .read(usermanControllerProvider.notifier)
                  .updateProfilePrice(profile.name, newPrice);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('حفظ السعر'),
          ),
        ],
      ),
    );
  }

  void _showProfileDetailsSheet(BuildContext context, UmProfileModel profile) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.tune, color: AppColors.cyanAccent, size: 28),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'تفاصيل بروفايل: ${profile.displayName}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildDetailRow('معرف البروفايل (ID):', profile.id),
            _buildDetailRow('الاسم في النظام:', profile.name),
            if (profile.nameForUsers != null)
              _buildDetailRow('الاسم للمستخدمين:', profile.nameForUsers!),
            _buildDetailRow('مدة الصلاحية:', profile.validity ?? 'غير محددة'),
            _buildDetailRow(
                'السعر المسجل:', '${profile.price.toStringAsFixed(0)} YER'),
            _buildDetailRow(
                'عدد المستخدمين المشتركين:', '${profile.usersCount} كرت'),
            _buildDetailRow('الجلسات النشطة حالياً:',
                '${profile.activeSessionsCount} جلسة'),
            _buildDetailRow(
                'الأجهزة المتزامنة (Shared Users):', '${profile.sharedUsers}'),
            if (profile.startsWhen != null)
              _buildDetailRow(
                  'بدء الصلاحية (Starts When):', profile.startsWhen!),
            if (profile.rateLimit != null)
              _buildDetailRow('تحديد السرعة:', profile.rateLimit!),
            if (profile.owner != null)
              _buildDetailRow('المالك / Customer:', profile.owner!),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.cyanAccent,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  context.push(
                      '/vouchers/generate?isUserManager=true&profile=${profile.name}');
                },
                icon: const Icon(Icons.print, color: Colors.white),
                label: const Text('طباعة كروت هذا البروفايل',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
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
                  color: AppColors.textSecondary, fontSize: 13)),
          Text(value,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildSessionsTab(UsermanState state) {
    final filtered = state.sessions.where((s) {
      final user = (s['user'] ?? s['username'] ?? '').toString().toLowerCase();
      final ip =
          (s['user-ip'] ?? s['nas-ip-address'] ?? '').toString().toLowerCase();
      return user.contains(_searchQuery) || ip.contains(_searchQuery);
    }).toList();

    if (filtered.isEmpty) {
      final isSearching = _searchQuery.isNotEmpty;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSearching
                  ? Icons.search_off_outlined
                  : Icons.flash_off_outlined,
              size: 64,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 12),
            Text(
              isSearching
                  ? 'لا توجد جلسات حية مطابقة لبحثك "$_searchQuery"'
                  : 'لا توجد جلسات نشطة حالياً في User Manager',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            if (isSearching) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _searchCtrl.clear();
                    _searchQuery = '';
                  });
                },
                icon: const Icon(Icons.clear),
                label: const Text('مسح البحث'),
              ),
            ],
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () =>
          ref.read(usermanControllerProvider.notifier).refreshAll(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          final session = filtered[index];
          final id = session['.id']?.toString() ?? '';
          final username =
              (session['user'] ?? session['username'] ?? 'مجهول').toString();
          final ip =
              (session['user-ip'] ?? session['calling-station-id'] ?? '-')
                  .toString();
          final uptime = (session['uptime'] ?? '-').toString();

          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.success,
                radius: 18,
                child: Icon(Icons.flash_on, color: Colors.white, size: 20),
              ),
              title: Text(username,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15)),
              subtitle: Text('IP / Station: $ip | المدة: $uptime',
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary)),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.danger,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => _confirmKickSession(context, id, username),
                child: const Text('إنهاء الجلسة',
                    style:
                        TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ),
          );
        },
      ),
    );
  }

  void _confirmDeleteUser(BuildContext context, String id, String username) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد حذف المشترك'),
        content:
            Text('هل أنت متأكد من حذف المشترك "$username" من User Manager؟'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () async {
              await ref
                  .read(usermanControllerProvider.notifier)
                  .removeUser(id, username);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('حذف المشترك'),
          ),
        ],
      ),
    );
  }

  void _confirmKickSession(BuildContext context, String id, String username) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد إنهاء الجلسة'),
        content: Text('هل أنت متأكد من قطع الجلسة الحية للمشترك "$username"؟'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () async {
              await ref
                  .read(usermanControllerProvider.notifier)
                  .kickSession(id, username);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('إنهاء الجلسة الآن'),
          ),
        ],
      ),
    );
  }

  void _showAddUserDialog(
      BuildContext context, List<Map<String, dynamic>> profiles) {
    final userCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    final commentCtrl = TextEditingController();
    String? selectedProfile =
        profiles.isNotEmpty ? profiles.first['name']?.toString() : null;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('إضافة مشترك جديد (User Manager)'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: userCtrl,
                  decoration: const InputDecoration(
                      labelText: 'اسم المشترك *',
                      prefixIcon: Icon(Icons.person)),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: passCtrl,
                  decoration: const InputDecoration(
                      labelText: 'كلمة المرور *', prefixIcon: Icon(Icons.lock)),
                ),
                const SizedBox(height: 12),
                if (profiles.isNotEmpty) ...[
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                        labelText: 'البروفايل', prefixIcon: Icon(Icons.tune)),
                    value: selectedProfile,
                    items: profiles.map((p) {
                      final name = p['name']?.toString() ?? 'default';
                      return DropdownMenuItem(value: name, child: Text(name));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setDialogState(() => selectedProfile = val);
                      }
                    },
                  ),
                  () {
                    final profMap = profiles.firstWhere(
                      (p) => p['name'] == selectedProfile,
                      orElse: () => {},
                    );
                    final owner = profMap['owner']?.toString();
                    if (owner != null && owner.isNotEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Row(
                          children: [
                            const Icon(Icons.badge_outlined,
                                size: 16, color: AppColors.cyanAccent),
                            const SizedBox(width: 6),
                            Text(
                              'مالك البروفايل: $owner',
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }(),
                ],
                const SizedBox(height: 12),
                TextField(
                  controller: commentCtrl,
                  decoration: const InputDecoration(
                      labelText: 'ملاحظة (Comment)',
                      prefixIcon: Icon(Icons.notes)),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('إلغاء')),
            ElevatedButton(
              onPressed: () async {
                if (userCtrl.text.trim().isEmpty ||
                    passCtrl.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('اسم المشترك وكلمة المرور مطلوبان')),
                  );
                  return;
                }

                final profMap = profiles.firstWhere(
                  (p) => p['name'] == selectedProfile,
                  orElse: () => {},
                );
                final owner = profMap['owner']?.toString();

                await ref.read(usermanControllerProvider.notifier).addUser(
                      username: userCtrl.text.trim(),
                      password: passCtrl.text.trim(),
                      profile: selectedProfile,
                      customer: owner,
                      comment: commentCtrl.text.trim().isNotEmpty
                          ? commentCtrl.text.trim()
                          : null,
                    );

                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: const Text('إضافة المشترك'),
            ),
          ],
        ),
      ),
    );
  }
}
