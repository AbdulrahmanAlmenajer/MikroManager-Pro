import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/session/session_controller.dart';
import '../data/topology_repository.dart';
import '../domain/topology_notifier.dart';

class NetworkTopologyScreen extends ConsumerStatefulWidget {
  const NetworkTopologyScreen({super.key});

  @override
  ConsumerState<NetworkTopologyScreen> createState() =>
      _NetworkTopologyScreenState();
}

class _NetworkTopologyScreenState extends ConsumerState<NetworkTopologyScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TransformationController _transformationController =
      TransformationController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(topologyNotifierProvider);
    final session = ref.watch(sessionControllerProvider).session;

    return Scaffold(
      appBar: AppBar(
        title: const Text('خريطة المشتركين ومخطط الشبكة'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.cyanAccent,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.people_alt_outlined), text: 'توزيع المشتركين'),
            Tab(icon: Icon(Icons.hub_outlined), text: 'مخطط الشبكة (Topology)'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt_outlined),
            tooltip: 'حفظ لقطة المخطط',
            onPressed: () async {
              final ok = await ref
                  .read(topologyNotifierProvider.notifier)
                  .saveCurrentSnapshot();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(ok
                        ? 'تم حفظ لقطة المخطط بنجاح!'
                        : 'تعذر حفظ لقطة المخطط'),
                    backgroundColor: ok ? AppColors.success : AppColors.danger,
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'إعادة تحليل التفرع',
            onPressed: () =>
                ref.read(topologyNotifierProvider.notifier).refreshTopology(),
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('جاري تحليل تفرع الشبكة ومطابقة المشتركين بالأكسسات...'),
                ],
              ),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                _buildDistributionTab(state),
                _buildTopologyGraphTab(state, session),
              ],
            ),
    );
  }

  // =========================================================================
  // Tab 1: Subscribers Distribution
  // =========================================================================

  Widget _buildDistributionTab(TopologyState state) {
    if (state.aps.isEmpty && state.unmatchedUsers.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off_outlined,
                  size: 64,
                  color: AppColors.textSecondary.withValues(alpha: 0.5)),
              const SizedBox(height: 16),
              const Text('لا توجد بيانات توزيع حالياً',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text(
                  'تأكد من تسجيل نقاط البث ووجود مشتركين متصلين في الهوتسبوت.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary)),
            ],
          ),
        ),
      );
    }

    final totalMatched = state.matches.where((m) => m.apId != null).length;
    final totalUnmatched = state.unmatchedUsers.length;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Summary Header Cards
        Row(
          children: [
            Expanded(
              child: _buildCountCard('المشتركون الموزعون', '$totalMatched',
                  Icons.verified_user, AppColors.success),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildCountCard('غير محددين (Unmatched)',
                  '$totalUnmatched', Icons.help_outline, AppColors.warning),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildCountCard('نقاط البث المسجلة', '${state.aps.length}',
                  Icons.cell_tower, AppColors.cyanAccent),
            ),
          ],
        ),
        const SizedBox(height: 20),

        const Text('التوزيع حسب نقاط البث (Access Points):',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 10),

        ...state.aps.map((ap) {
          final users = state.apUsersMap[ap.id] ?? [];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            child: ExpansionTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.cyanAccent.withValues(alpha: 0.15),
                child:
                    const Icon(Icons.cell_tower, color: AppColors.cyanAccent),
              ),
              title: Row(
                children: [
                  Text(ap.name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.cyanAccent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${users.length} متصل',
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.cyanAccent),
                    ),
                  ),
                ],
              ),
              subtitle: Text('${ap.ip}  •  ${ap.vendor}',
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textSecondary)),
              children: [
                if (users.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('لا يوجد مشتركون متصلون عبر هذه النقطة حالياً.',
                        style: TextStyle(
                            color: AppColors.textSecondary, fontSize: 12)),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: users.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, idx) {
                      final u = users[idx];
                      final isConfirmed = u.confidence == 'confirmed';
                      return ListTile(
                        dense: true,
                        leading: Icon(
                          Icons.person_pin_circle,
                          color: isConfirmed
                              ? AppColors.success
                              : AppColors.warning,
                        ),
                        title: Text(u.username,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          '${u.ipAddress ?? "بدون IP"}  •  ${u.evidence}',
                          style: const TextStyle(
                              fontSize: 10, color: AppColors.textSecondary),
                        ),
                        trailing: Chip(
                          label: Text(
                            isConfirmed ? 'مؤكد' : 'مرجح',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isConfirmed
                                  ? AppColors.success
                                  : AppColors.warning,
                            ),
                          ),
                          backgroundColor: (isConfirmed
                                  ? AppColors.success
                                  : AppColors.warning)
                              .withValues(alpha: 0.1),
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        }),

        if (state.unmatchedUsers.isNotEmpty) ...[
          const SizedBox(height: 16),
          const Text('مشتركون بدون نقطة بث محددة:',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppColors.warning)),
          const SizedBox(height: 8),
          Card(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.unmatchedUsers.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, idx) {
                final u = state.unmatchedUsers[idx];
                return ListTile(
                  dense: true,
                  leading:
                      const Icon(Icons.help_outline, color: AppColors.warning),
                  title: Text(u.username,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    '${u.ipAddress ?? "IP غير معروف"}  •  ${u.evidence}',
                    style: const TextStyle(
                        fontSize: 10, color: AppColors.textSecondary),
                  ),
                  trailing: const Chip(
                    label: Text('غير محدد',
                        style:
                            TextStyle(fontSize: 10, color: AppColors.warning)),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  // =========================================================================
  // Tab 2: Interactive Topology Graph
  // =========================================================================

  Widget _buildTopologyGraphTab(TopologyState state, dynamic session) {
    return Stack(
      children: [
        InteractiveViewer(
          transformationController: _transformationController,
          boundaryMargin: const EdgeInsets.all(500),
          minScale: 0.4,
          maxScale: 3.0,
          child: Center(
            child: CustomPaint(
              size: const Size(800, 600),
              painter: TopologyPainter(
                routerName: session?.boardName ?? 'MikroTik Router',
                routerIp: session?.host ?? '192.168.88.1',
                aps: state.aps,
                apUsersMap: state.apUsersMap,
              ),
            ),
          ),
        ),
        // Controls overlay
        Positioned(
          left: 16,
          bottom: 16,
          child: Column(
            children: [
              FloatingActionButton.small(
                heroTag: 'zoom_in',
                backgroundColor: AppColors.cardBackground,
                foregroundColor: AppColors.cyanAccent,
                onPressed: () {
                  _transformationController.value =
                      _transformationController.value.clone()..scale(1.2);
                },
                child: const Icon(Icons.zoom_in),
              ),
              const SizedBox(height: 8),
              FloatingActionButton.small(
                heroTag: 'zoom_out',
                backgroundColor: AppColors.cardBackground,
                foregroundColor: AppColors.cyanAccent,
                onPressed: () {
                  _transformationController.value =
                      _transformationController.value.clone()..scale(0.8);
                },
                child: const Icon(Icons.zoom_out),
              ),
              const SizedBox(height: 8),
              FloatingActionButton.small(
                heroTag: 'recenter',
                backgroundColor: AppColors.cardBackground,
                foregroundColor: AppColors.cyanAccent,
                onPressed: () {
                  _transformationController.value = Matrix4.identity();
                },
                child: const Icon(Icons.center_focus_strong),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCountCard(
      String title, String count, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(count,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18, color: color)),
            const SizedBox(height: 4),
            Text(title,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: const TextStyle(
                    fontSize: 10, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

// =========================================================================
// Custom Painter for Topology Graph
// =========================================================================

class TopologyPainter extends CustomPainter {
  final String routerName;
  final String routerIp;
  final List<dynamic> aps;
  final Map<int, List<UserApMatchResult>> apUsersMap;

  TopologyPainter({
    required this.routerName,
    required this.routerIp,
    required this.aps,
    required this.apUsersMap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, 80);

    final linePaint = Paint()
      ..color = AppColors.cyanAccent.withValues(alpha: 0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final apCount = aps.length;
    if (apCount == 0) {
      _drawRouterNode(canvas, center);
      return;
    }

    const double startY = 320;
    final double spacing = size.width / (apCount + 1);

    for (int i = 0; i < apCount; i++) {
      final ap = aps[i];
      final apPos = Offset((i + 1) * spacing, startY);

      // Draw connecting curve from router to AP
      final path = Path()
        ..moveTo(center.dx, center.dy + 35)
        ..cubicTo(
          center.dx,
          (center.dy + apPos.dy) / 2,
          apPos.dx,
          (center.dy + apPos.dy) / 2,
          apPos.dx,
          apPos.dy - 35,
        );
      canvas.drawPath(path, linePaint);

      // Draw AP node
      final usersCount = apUsersMap[ap.id]?.length ?? 0;
      _drawApNode(canvas, apPos, ap.name, ap.ip, usersCount);
    }

    // Draw main router node
    _drawRouterNode(canvas, center);
  }

  void _drawRouterNode(Canvas canvas, Offset pos) {
    final rect = Rect.fromCenter(center: pos, width: 140, height: 65);
    final paint = Paint()..color = const Color(0xFF0F172A);
    final borderPaint = Paint()
      ..color = AppColors.cyanAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(12));
    canvas.drawRRect(rrect, paint);
    canvas.drawRRect(rrect, borderPaint);

    // Text: Name
    final textPainter = TextPainter(
      text: TextSpan(
        text: routerName,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
      ),
      textDirection: TextDirection.rtl,
    )..layout(maxWidth: 130);
    textPainter.paint(
        canvas, Offset(pos.dx - textPainter.width / 2, pos.dy - 20));

    // Text: IP
    final ipPainter = TextPainter(
      text: TextSpan(
        text: routerIp,
        style: const TextStyle(color: AppColors.cyanAccent, fontSize: 10),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: 130);
    ipPainter.paint(canvas, Offset(pos.dx - ipPainter.width / 2, pos.dy + 2));
  }

  void _drawApNode(
      Canvas canvas, Offset pos, String name, String ip, int usersCount) {
    final rect = Rect.fromCenter(center: pos, width: 120, height: 60);
    final paint = Paint()..color = const Color(0xFF1E293B);
    final borderPaint = Paint()
      ..color = Colors.tealAccent.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(10));
    canvas.drawRRect(rrect, paint);
    canvas.drawRRect(rrect, borderPaint);

    // Name
    final textPainter = TextPainter(
      text: TextSpan(
        text: name,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
      ),
      textDirection: TextDirection.rtl,
    )..layout(maxWidth: 110);
    textPainter.paint(
        canvas, Offset(pos.dx - textPainter.width / 2, pos.dy - 18));

    // IP
    final ipPainter = TextPainter(
      text: TextSpan(
        text: ip,
        style: const TextStyle(color: Colors.tealAccent, fontSize: 9),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: 110);
    ipPainter.paint(canvas, Offset(pos.dx - ipPainter.width / 2, pos.dy + 2));

    // Users Badge
    if (usersCount > 0) {
      final badgeCenter = Offset(pos.dx + 50, pos.dy - 25);
      final badgePaint = Paint()..color = AppColors.success;
      canvas.drawCircle(badgeCenter, 12, badgePaint);

      final badgeText = TextPainter(
        text: TextSpan(
          text: '$usersCount',
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      badgeText.paint(canvas,
          Offset(badgeCenter.dx - badgeText.width / 2, badgeCenter.dy - 6));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
