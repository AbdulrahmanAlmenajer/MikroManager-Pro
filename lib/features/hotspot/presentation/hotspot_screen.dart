import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../domain/hotspot_notifier.dart';

class HotspotScreen extends ConsumerStatefulWidget {
  const HotspotScreen({super.key});

  @override
  ConsumerState<HotspotScreen> createState() => _HotspotScreenState();
}

class _HotspotScreenState extends ConsumerState<HotspotScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(hotspotControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الهوتس بوت (Hotspot)'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.cyanAccent,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(
              icon: const Icon(Icons.badge_outlined),
              text: 'المستخدمون (${state.users.length})',
            ),
            Tab(
              icon: const Icon(Icons.people_alt_outlined),
              text: 'المتصلون (${state.activeUsers.length})',
            ),
            Tab(
              icon: const Icon(Icons.tune_outlined),
              text: 'البروفايلات (${state.profiles.length})',
            ),
            Tab(
              icon: const Icon(Icons.link_outlined),
              text: 'ربط IP (${state.ipBindings.length})',
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'تحديث البيانات',
            onPressed: () =>
                ref.read(hotspotControllerProvider.notifier).refreshAll(),
          ),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton.extended(
              onPressed: () => _showAddUserDialog(context, state.profiles),
              backgroundColor: AppColors.cyanAccent,
              icon: const Icon(Icons.person_add, color: Colors.white),
              label: const Text('إضافة مستخدم',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            )
          : null,
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.errorMessage != null &&
                  state.activeUsers.isEmpty &&
                  state.users.isEmpty
              ? _buildErrorView(state.errorMessage!)
              : Column(
                  children: [
                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                      child: TextField(
                        controller: _searchCtrl,
                        decoration: InputDecoration(
                          hintText: 'بحث بالاسم، عنوان IP، أو الماك...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchQuery.isNotEmpty
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
                          isDense: true,
                        ),
                        onChanged: (val) {
                          setState(() {
                            _searchQuery = val.trim().toLowerCase();
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildUsersTab(state),
                          _buildActiveUsersTab(state),
                          _buildProfilesTab(state),
                          _buildIpBindingsTab(state),
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
            Icon(Icons.wifi_off_outlined,
                size: 64, color: AppColors.danger.withValues(alpha: 0.7)),
            const SizedBox(height: 16),
            const Text('تعذر الاتصال بخدمة الهوتس بوت',
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
                  ref.read(hotspotControllerProvider.notifier).refreshAll(),
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveUsersTab(HotspotState state) {
    final filtered = state.activeUsers.where((u) {
      final user = u['user']?.toString().toLowerCase() ?? '';
      final address = u['address']?.toString().toLowerCase() ?? '';
      final mac = u['mac-address']?.toString().toLowerCase() ?? '';
      return user.contains(_searchQuery) ||
          address.contains(_searchQuery) ||
          mac.contains(_searchQuery);
    }).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline,
                size: 64,
                color: AppColors.textSecondary.withValues(alpha: 0.5)),
            const SizedBox(height: 12),
            const Text('لا يوجد متصلون نشطون حالياً',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () =>
          ref.read(hotspotControllerProvider.notifier).refreshAll(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          final item = filtered[index];
          final id = item['.id']?.toString() ?? '';
          final username = item['user']?.toString() ?? 'غير معروف';
          final ip = item['address']?.toString() ?? '-';
          final mac = item['mac-address']?.toString() ?? '-';
          final uptime = item['uptime']?.toString() ?? '-';
          final bytesIn = _formatBytes(item['bytes-in']);
          final bytesOut = _formatBytes(item['bytes-out']);

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: AppColors.success,
                        radius: 18,
                        child:
                            Icon(Icons.person, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(username,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            Text('IP: $ip | MAC: $mac',
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      // Kick Button
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.danger,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () => _confirmKick(context, id, username),
                        icon: const Icon(Icons.power_settings_new, size: 16),
                        label: const Text('فصل (Kick)',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMiniInfo(Icons.timer_outlined, 'الوقت', uptime),
                      _buildMiniInfo(Icons.arrow_downward, 'تنزيل', bytesOut),
                      _buildMiniInfo(Icons.arrow_upward, 'رفع', bytesIn),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUsersTab(HotspotState state) {
    final filtered = state.users.where((u) {
      final name = u['name']?.toString().toLowerCase() ?? '';
      final profile = u['profile']?.toString().toLowerCase() ?? '';
      return name.contains(_searchQuery) || profile.contains(_searchQuery);
    }).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.badge_outlined,
                size: 64,
                color: AppColors.textSecondary.withValues(alpha: 0.5)),
            const SizedBox(height: 12),
            const Text('لا يوجد مستخدمون مطابقون للبحث',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () =>
          ref.read(hotspotControllerProvider.notifier).refreshAll(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          final item = filtered[index];
          final id = item['.id']?.toString() ?? '';
          final name = item['name']?.toString() ?? '';
          final profile = item['profile']?.toString() ?? 'default';
          final limitUptime = item['limit-uptime']?.toString();
          final uptime = item['uptime']?.toString() ?? '0s';
          final bytesOut = _formatBytes(item['bytes-out']);

          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.navyPrimary.withValues(alpha: 0.1),
                child: const Icon(Icons.account_circle,
                    color: AppColors.navyPrimary),
              ),
              title: Text(name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15)),
              subtitle: Text(
                'بروفايل: $profile | الاستهلاك: $bytesOut'
                '${limitUptime != null ? "\nالحد الزمني: $limitUptime (المستهلك: $uptime)" : ""}',
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, color: AppColors.danger),
                tooltip: 'حذف المستخدم',
                onPressed: () => _confirmDeleteUser(context, id, name),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfilesTab(HotspotState state) {
    if (state.profiles.isEmpty) {
      return const Center(child: Text('لا توجد بروفايلات متاحة'));
    }

    return RefreshIndicator(
      onRefresh: () =>
          ref.read(hotspotControllerProvider.notifier).refreshAll(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.profiles.length,
        itemBuilder: (context, index) {
          final profile = state.profiles[index];
          final name = profile['name']?.toString() ?? 'بدون اسم';
          final sharedUsers = profile['shared-users']?.toString() ?? '1';
          final rateLimit = profile['rate-limit']?.toString() ?? 'غير محدد';
          final sessionTimeout =
              profile['session-timeout']?.toString() ?? 'غير محدد';

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.tune, color: AppColors.cyanAccent),
                      const SizedBox(width: 8),
                      Text(name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const Spacer(),
                      Chip(
                        label: Text('$sharedUsers أجهزة',
                            style: const TextStyle(fontSize: 11)),
                        backgroundColor: AppColors.background,
                      ),
                    ],
                  ),
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('السرعة (Rate Limit): $rateLimit',
                          style: const TextStyle(
                              fontSize: 13, color: AppColors.textSecondary)),
                      Text('فترة الجلسة: $sessionTimeout',
                          style: const TextStyle(
                              fontSize: 13, color: AppColors.textSecondary)),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildIpBindingsTab(HotspotState state) {
    final filtered = state.ipBindings.where((b) {
      final mac = b['mac-address']?.toString().toLowerCase() ?? '';
      final address = b['to-address']?.toString().toLowerCase() ?? '';
      final comment = b['comment']?.toString().toLowerCase() ?? '';
      return mac.contains(_searchQuery) ||
          address.contains(_searchQuery) ||
          comment.contains(_searchQuery);
    }).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.link_off,
                size: 64,
                color: AppColors.textSecondary.withValues(alpha: 0.5)),
            const SizedBox(height: 12),
            const Text('لا توجد سجلات ربط عناوين IP حالياً',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () =>
          ref.read(hotspotControllerProvider.notifier).refreshAll(),
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          final item = filtered[index];
          final id = item['.id']?.toString() ?? '';
          final mac = item['mac-address']?.toString() ?? '-';
          final toAddress = item['to-address']?.toString() ?? 'Auto';
          final type = item['type']?.toString() ?? 'bypassed';
          final comment = item['comment']?.toString() ?? '';

          Color typeColor = AppColors.success;
          if (type == 'blocked') typeColor = AppColors.danger;
          if (type == 'regular') typeColor = AppColors.warning;

          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: typeColor.withValues(alpha: 0.15),
                child: Icon(Icons.link, color: typeColor),
              ),
              title: Text(mac,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14)),
              subtitle: Text(
                'العنوان: $toAddress | النوع: $type${comment.isNotEmpty ? " ($comment)" : ""}',
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Chip(
                    label: Text(type,
                        style:
                            const TextStyle(fontSize: 11, color: Colors.white)),
                    backgroundColor: typeColor,
                  ),
                  if (id.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.delete_outline,
                          size: 18, color: AppColors.danger),
                      tooltip: 'حذف ربط IP',
                      onPressed: () =>
                          _confirmDeleteIpBinding(context, id, mac),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMiniInfo(IconData icon, String title, String val) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text('$title: $val',
            style:
                const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }

  String _formatBytes(dynamic bytes) {
    final b = int.tryParse(bytes?.toString() ?? '0') ?? 0;
    if (b < 1024) return '$b B';
    if (b < 1024 * 1024) return '${(b / 1024).toStringAsFixed(1)} KB';
    if (b < 1024 * 1024 * 1024)
      return '${(b / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(b / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  void _confirmKick(BuildContext context, String id, String username) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد قطع الاتصال (Kick)'),
        content:
            Text('هل أنت متأكد من رغبتك في فصل المشترك "$username" فوراً؟'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () async {
              await ref
                  .read(hotspotControllerProvider.notifier)
                  .kickUser(id, username);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('فصل الاتصال الآن'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteUser(BuildContext context, String id, String username) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد حذف المستخدم'),
        content: Text(
            'هل أنت متأكد من حذف المستخدم "$username" من سيرفر الهوتس بوت؟'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () async {
              await ref
                  .read(hotspotControllerProvider.notifier)
                  .removeUser(id, username);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('حذف نهائياً'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteIpBinding(BuildContext context, String id, String mac) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد حذف ربط IP'),
        content: Text('هل أنت متأكد من حذف ربط IP للعنوان "$mac"؟'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () async {
              // Remove IP binding and refresh
              if (ctx.mounted) Navigator.pop(ctx);
              await ref.read(hotspotControllerProvider.notifier).refreshAll();
            },
            child: const Text('حذف نهائياً'),
          ),
        ],
      ),
    );
  }

  void _showAddUserDialog(
      BuildContext context, List<Map<String, dynamic>> profiles) {
    final nameCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    final uptimeCtrl = TextEditingController();
    final bytesCtrl = TextEditingController();
    final commentCtrl = TextEditingController();
    String selectedProfile = profiles.isNotEmpty
        ? profiles.first['name']?.toString() ?? 'default'
        : 'default';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('إضافة مستخدم هوتس بوت جديد'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                      labelText: 'اسم المستخدم (User) *',
                      prefixIcon: Icon(Icons.person)),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: passCtrl,
                  decoration: const InputDecoration(
                      labelText: 'كلمة المرور (Password) *',
                      prefixIcon: Icon(Icons.lock)),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                      labelText: 'البروفايل', prefixIcon: Icon(Icons.tune)),
                  value: selectedProfile,
                  items: profiles.isEmpty
                      ? [
                          const DropdownMenuItem(
                              value: 'default', child: Text('default'))
                        ]
                      : profiles.map((p) {
                          final name = p['name']?.toString() ?? 'default';
                          return DropdownMenuItem(
                              value: name, child: Text(name));
                        }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setDialogState(() => selectedProfile = val);
                    }
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: uptimeCtrl,
                  decoration: const InputDecoration(
                    labelText: 'الحد الزمني (مثال: 1h, 1d, 30m)',
                    prefixIcon: Icon(Icons.timer_outlined),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: bytesCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'حد البيانات بالبايت (limit-bytes-total)',
                    prefixIcon: Icon(Icons.data_usage),
                  ),
                ),
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
                if (nameCtrl.text.trim().isEmpty ||
                    passCtrl.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('اسم المستخدم وكلمة المرور مطلوبان')),
                  );
                  return;
                }

                await ref.read(hotspotControllerProvider.notifier).addUser(
                      name: nameCtrl.text.trim(),
                      password: passCtrl.text.trim(),
                      profile: selectedProfile,
                      limitUptime: uptimeCtrl.text.trim().isNotEmpty
                          ? uptimeCtrl.text.trim()
                          : null,
                      limitBytesTotal: bytesCtrl.text.trim().isNotEmpty
                          ? bytesCtrl.text.trim()
                          : null,
                      comment: commentCtrl.text.trim().isNotEmpty
                          ? commentCtrl.text.trim()
                          : null,
                    );

                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: const Text('إضافة المستخدم'),
            ),
          ],
        ),
      ),
    );
  }
}
