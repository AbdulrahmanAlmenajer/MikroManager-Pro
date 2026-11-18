import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../data/subscribers_repository.dart';
import '../domain/subscribers_notifier.dart';

class SubscribersScreen extends ConsumerStatefulWidget {
  const SubscribersScreen({super.key});

  @override
  ConsumerState<SubscribersScreen> createState() => _SubscribersScreenState();
}

class _SubscribersScreenState extends ConsumerState<SubscribersScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        final tab = SubscriberType.values[_tabController.index];
        ref.read(subscribersProvider.notifier).switchTab(tab);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(subscribersProvider);
    final notifier = ref.read(subscribersProvider.notifier);
    final items = state.filteredList;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('إدارة المشتركين'),
        actions: [
          IconButton(
            icon: const Icon(Icons.troubleshoot_rounded),
            tooltip: 'استعلام وتشخيص الكرت',
            onPressed: () => context.push('/card-inquiry'),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'تحديث القائمة',
            onPressed: () => notifier.loadSubscribers(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: const Color(0xFF94A3B8),
          indicatorColor: AppColors.cyanAccent,
          indicatorWeight: 3,
          tabs: const [
            Tab(icon: Icon(Icons.wifi), text: 'الهوتسبوت (Hotspot)'),
            Tab(icon: Icon(Icons.manage_accounts), text: 'يوزر منجر (UM)'),
            Tab(icon: Icon(Icons.cable), text: 'اشتراكات PPPoE'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search and Filters Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: Column(
              children: [
                // Search Input
                TextField(
                  controller: _searchController,
                  onChanged: (val) => notifier.setSearchQuery(val),
                  decoration: InputDecoration(
                    hintText: 'بحث باسم المستخدم، البروفايل، MAC أو IP...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              notifier.setSearchQuery('');
                            },
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                  ),
                ),
                const SizedBox(height: 8),

                // Status Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('الكل (${state.subscribers.length})',
                          'all', state, notifier),
                      const SizedBox(width: 6),
                      _buildFilterChip(
                          'المتصلون حالياً', 'active', state, notifier),
                      const SizedBox(width: 6),
                      _buildFilterChip('المعطلون', 'disabled', state, notifier),
                      const SizedBox(width: 6),
                      _buildFilterChip('المنتهون', 'expired', state, notifier),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Main List View (Virtualized with ListView.builder)
          Expanded(
            child: state.isLoading && state.subscribers.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : state.errorMessage != null && state.subscribers.isEmpty
                    ? _buildErrorView(state.errorMessage!, notifier)
                    : items.isEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32),
                              child: Text('لا توجد نتائج مطابقة لبحثك'),
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: () => notifier.loadSubscribers(),
                            child: ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                final sub = items[index];
                                return _buildSubscriberCard(
                                    context, sub, notifier);
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    String filterValue,
    SubscribersState state,
    SubscribersNotifier notifier,
  ) {
    final isSelected = state.statusFilter == filterValue;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppColors.cyanAccent,
      labelStyle: TextStyle(
        fontSize: 11,
        color: isSelected ? Colors.white : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      onSelected: (selected) {
        if (selected) {
          notifier.setStatusFilter(filterValue);
        }
      },
    );
  }

  Widget _buildSubscriberCard(
    BuildContext context,
    SubscriberModel sub,
    SubscribersNotifier notifier,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: Stack(
          children: [
            CircleAvatar(
              backgroundColor: sub.isActive
                  ? AppColors.success.withValues(alpha: 0.15)
                  : (sub.isDisabled
                      ? AppColors.danger.withValues(alpha: 0.15)
                      : AppColors.surface),
              child: Icon(
                sub.type == SubscriberType.pppoe
                    ? Icons.cable
                    : (sub.type == SubscriberType.userMan
                        ? Icons.person
                        : Icons.wifi),
                color: sub.isActive
                    ? AppColors.success
                    : (sub.isDisabled
                        ? AppColors.danger
                        : AppColors.navyPrimary),
              ),
            ),
            if (sub.isActive)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                sub.username,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.cyanAccent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                sub.profile,
                style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.cyanAccent,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                if (sub.isActive) ...[
                  Text('IP: ${sub.ipAddress ?? '-'}',
                      style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.success,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(width: 8),
                  Text('المدة: ${sub.uptime ?? '-'}',
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textSecondary)),
                ] else if (sub.isDisabled) ...[
                  const Text('الحالة: معطل (Disabled)',
                      style: TextStyle(
                          fontSize: 11,
                          color: AppColors.danger,
                          fontWeight: FontWeight.w600)),
                ] else ...[
                  Text('غير متصل | MAC: ${sub.macAddress ?? 'غير مقيد'}',
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textSecondary)),
                ],
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, size: 20),
          onSelected: (value) async {
            if (value == 'diagnose') {
              context.push(
                  '/card-inquiry?card=${Uri.encodeComponent(sub.username)}');
            } else if (value == 'kick') {
              _confirmKick(context, sub, notifier);
            } else if (value == 'toggle') {
              await notifier.toggleSubscriberStatus(sub, sub.isDisabled);
            } else if (value == 'reset_mac') {
              await notifier.resetMacBinding(sub);
            }
          },
          itemBuilder: (ctx) => [
            const PopupMenuItem(
              value: 'diagnose',
              child: Row(
                children: [
                  Icon(Icons.troubleshoot,
                      size: 18, color: AppColors.cyanAccent),
                  SizedBox(width: 8),
                  Text('تشخيص الكرت'),
                ],
              ),
            ),
            if (sub.isActive)
              const PopupMenuItem(
                value: 'kick',
                child: Row(
                  children: [
                    Icon(Icons.power_settings_new,
                        size: 18, color: AppColors.danger),
                    SizedBox(width: 8),
                    Text('طرد الجلسة (Kick)'),
                  ],
                ),
              ),
            PopupMenuItem(
              value: 'toggle',
              child: Row(
                children: [
                  Icon(sub.isDisabled ? Icons.check : Icons.block, size: 18),
                  const SizedBox(width: 8),
                  Text(sub.isDisabled ? 'تفعيل الكرت' : 'تعطيل الكرت'),
                ],
              ),
            ),
            if (sub.macAddress != null && sub.macAddress!.isNotEmpty)
              const PopupMenuItem(
                value: 'reset_mac',
                child: Row(
                  children: [
                    Icon(Icons.link_off, size: 18, color: AppColors.warning),
                    SizedBox(width: 8),
                    Text('فك قيد MAC'),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _confirmKick(
      BuildContext context, SubscriberModel sub, SubscribersNotifier notifier) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد قطع اتصال المشترك'),
        content: Text(
            'هل تريد قطع اتصال المشترك (${sub.username}) وإنهاء جلسته الحالية فوراً؟'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () async {
              Navigator.pop(ctx);
              final ok = await notifier.kickSubscriber(sub);
              if (ok && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('تم إنهاء جلسة ${sub.username} بنجاح')),
                );
              }
            },
            child: const Text('قطع الاتصال (Kick)',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(String message, SubscribersNotifier notifier) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 54, color: AppColors.danger),
            const SizedBox(height: 16),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => notifier.loadSubscribers(),
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}
