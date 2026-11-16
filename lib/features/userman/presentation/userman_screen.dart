import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../domain/userman_notifier.dart';

class UsermanScreen extends ConsumerStatefulWidget {
  const UsermanScreen({super.key});

  @override
  ConsumerState<UsermanScreen> createState() => _UsermanScreenState();
}

class _UsermanScreenState extends ConsumerState<UsermanScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
          tabs: [
            Tab(
              icon: const Icon(Icons.people_alt_outlined),
              text: 'المستخدمون (${state.users.length})',
            ),
            Tab(
              icon: const Icon(Icons.flash_on_outlined),
              text: 'الجلسات الحية (${state.sessions.length})',
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'تحديث البيانات',
            onPressed: () => ref.read(usermanControllerProvider.notifier).refreshAll(),
          ),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton.extended(
              onPressed: () => _showAddUserDialog(context, state.profiles),
              backgroundColor: AppColors.cyanAccent,
              icon: const Icon(Icons.person_add, color: Colors.white),
              label: const Text('إضافة مشترك', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )
          : null,
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.errorMessage != null && state.users.isEmpty
              ? _buildErrorView(state.errorMessage!)
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                      child: TextField(
                        controller: _searchCtrl,
                        decoration: InputDecoration(
                          hintText: 'بحث في المشتركين أو الجلسات...',
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
            Icon(Icons.manage_accounts_outlined, size: 64, color: AppColors.danger.withValues(alpha: 0.7)),
            const SizedBox(height: 16),
            const Text('تعذر تحميل بيانات User Manager',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            Text(error, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => ref.read(usermanControllerProvider.notifier).refreshAll(),
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsersTab(UsermanState state) {
    final filtered = state.users.where((u) {
      final name = (u['name'] ?? u['username'] ?? '').toString().toLowerCase();
      final profile = (u['profile'] ?? u['actual-profile'] ?? '').toString().toLowerCase();
      return name.contains(_searchQuery) || profile.contains(_searchQuery);
    }).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_off_outlined, size: 64, color: AppColors.textSecondary.withValues(alpha: 0.5)),
            const SizedBox(height: 12),
            const Text('لا يوجد مستخدمون في User Manager',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(usermanControllerProvider.notifier).refreshAll(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          final user = filtered[index];
          final id = user['.id']?.toString() ?? '';
          final username = (user['name'] ?? user['username'] ?? 'بدون اسم').toString();
          final profile = (user['profile'] ?? user['actual-profile'] ?? 'افتراضي').toString();
          final uptime = (user['uptime'] ?? '-').toString();
          final comment = user['comment']?.toString();

          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.cyanAccent.withValues(alpha: 0.15),
                child: const Icon(Icons.person, color: AppColors.cyanAccent),
              ),
              title: Text(username, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              subtitle: Text(
                'البروفايل: $profile | الاستهلاك: $uptime'
                '${comment != null ? "\nملاحظة: $comment" : ""}',
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
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

  Widget _buildSessionsTab(UsermanState state) {
    final filtered = state.sessions.where((s) {
      final user = (s['user'] ?? s['username'] ?? '').toString().toLowerCase();
      final ip = (s['user-ip'] ?? s['nas-ip-address'] ?? '').toString().toLowerCase();
      return user.contains(_searchQuery) || ip.contains(_searchQuery);
    }).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.flash_off_outlined, size: 64, color: AppColors.textSecondary.withValues(alpha: 0.5)),
            const SizedBox(height: 12),
            const Text('لا توجد جلسات حية حالياً في User Manager',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(usermanControllerProvider.notifier).refreshAll(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          final session = filtered[index];
          final id = session['.id']?.toString() ?? '';
          final username = (session['user'] ?? session['username'] ?? 'مجهول').toString();
          final ip = (session['user-ip'] ?? session['calling-station-id'] ?? '-').toString();
          final uptime = (session['uptime'] ?? '-').toString();

          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.success,
                radius: 18,
                child: Icon(Icons.flash_on, color: Colors.white, size: 20),
              ),
              title: Text(username, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              subtitle: Text('IP / Station: $ip | المدة: $uptime',
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.danger,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => _confirmKickSession(context, id, username),
                child: const Text('إنهاء الجلسة', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
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
        content: Text('هل أنت متأكد من حذف المشترك "$username" من User Manager؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () async {
              await ref.read(usermanControllerProvider.notifier).removeUser(id, username);
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
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () async {
              await ref.read(usermanControllerProvider.notifier).kickSession(id, username);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('إنهاء الجلسة الآن'),
          ),
        ],
      ),
    );
  }

  void _showAddUserDialog(BuildContext context, List<Map<String, dynamic>> profiles) {
    final userCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    final commentCtrl = TextEditingController();
    String? selectedProfile = profiles.isNotEmpty ? profiles.first['name']?.toString() : null;

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
                  decoration: const InputDecoration(labelText: 'اسم المشترك *', prefixIcon: Icon(Icons.person)),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: passCtrl,
                  decoration: const InputDecoration(labelText: 'كلمة المرور *', prefixIcon: Icon(Icons.lock)),
                ),
                const SizedBox(height: 12),
                if (profiles.isNotEmpty)
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'البروفايل', prefixIcon: Icon(Icons.tune)),
                    value: selectedProfile,
                    items: profiles.map((p) {
                      final name = p['name']?.toString() ?? 'default';
                      return DropdownMenuItem(value: name, child: Text(name));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setDialogState(() => selectedProfile = val);
                    },
                  ),
                const SizedBox(height: 12),
                TextField(
                  controller: commentCtrl,
                  decoration: const InputDecoration(labelText: 'ملاحظة (Comment)', prefixIcon: Icon(Icons.notes)),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
            ElevatedButton(
              onPressed: () async {
                if (userCtrl.text.trim().isEmpty || passCtrl.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('اسم المشترك وكلمة المرور مطلوبان')),
                  );
                  return;
                }

                await ref.read(usermanControllerProvider.notifier).addUser(
                      username: userCtrl.text.trim(),
                      password: passCtrl.text.trim(),
                      profile: selectedProfile,
                      comment: commentCtrl.text.trim().isNotEmpty ? commentCtrl.text.trim() : null,
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
