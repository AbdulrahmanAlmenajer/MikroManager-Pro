import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../data/dashboard_repository.dart';
import '../domain/interfaces_traffic_notifier.dart';

class InterfacesTrafficScreen extends ConsumerWidget {
  const InterfacesTrafficScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(interfacesTrafficProvider);
    final notifier = ref.read(interfacesTrafficProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('مراقبة الواجهات والترافيك'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'تحديث الواجهات',
            onPressed: () => notifier.loadInterfaces(),
          ),
        ],
      ),
      body: state.isLoading && state.interfaces.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : state.errorMessage != null && state.interfaces.isEmpty
              ? _buildErrorView(context, notifier, state.errorMessage!)
              : RefreshIndicator(
                  onRefresh: () => notifier.loadInterfaces(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Live Monitor Card
                        _buildLiveTrafficCard(context, ref, state, notifier),
                        const SizedBox(height: 16),

                        // Interfaces List Header
                        Row(
                          children: [
                            const Icon(Icons.hub_outlined,
                                color: AppColors.cyanAccent, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'جميع الواجهات المتاحة (${state.interfaces.length})',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Interfaces List
                        if (state.interfaces.isEmpty)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32),
                              child:
                                  Text('لا توجد واجهات شبكة متاحة في الراوتر'),
                            ),
                          )
                        else
                          ...state.interfaces.map((iface) =>
                              _buildInterfaceCard(
                                  context, iface, state, notifier)),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildErrorView(BuildContext context,
      InterfacesTrafficNotifier notifier, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 54, color: AppColors.danger),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 14, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => notifier.loadInterfaces(),
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveTrafficCard(
    BuildContext context,
    WidgetRef ref,
    InterfacesTrafficState state,
    InterfacesTrafficNotifier notifier,
  ) {
    final selected = state.selectedInterface ?? 'اختر واجهة';

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.speed, color: AppColors.cyanAccent, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'الترافيك الحي: $selected',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
                TextButton.icon(
                  onPressed: state.isRecordingDaily
                      ? null
                      : () async {
                          await notifier.saveSnapshotToDaily();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('تم حفظ لقطة الترافيك اليومية بنجاح!'),
                                backgroundColor: AppColors.success,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                  icon: state.isRecordingDaily
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.bookmark_add_outlined, size: 16),
                  label: const Text('حفظ لقطة يومية',
                      style: TextStyle(fontSize: 12)),
                  style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Interface Chips Selector
            if (state.interfaces.isNotEmpty)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: state.interfaces.map((iface) {
                    final isSelected = state.selectedInterface == iface.name;
                    return Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: ChoiceChip(
                        label: Text(iface.name),
                        selected: isSelected,
                        selectedColor: AppColors.cyanAccent,
                        labelStyle: TextStyle(
                          color:
                              isSelected ? Colors.white : AppColors.textPrimary,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 12,
                        ),
                        onSelected: (_) => notifier.selectInterface(iface.name),
                      ),
                    );
                  }).toList(),
                ),
              ),
            const SizedBox(height: 16),

            // Current Speeds Indicators
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.cyanAccent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: AppColors.cyanAccent.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.download,
                                size: 16, color: AppColors.cyanAccent),
                            SizedBox(width: 4),
                            Text('التحميل (RX)',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${state.currentRxMbps.toStringAsFixed(2)} Mbps',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppColors.cyanAccent),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: AppColors.success.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.upload,
                                size: 16, color: AppColors.success),
                            SizedBox(width: 4),
                            Text('الرفع (TX)',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${state.currentTxMbps.toStringAsFixed(2)} Mbps',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppColors.success),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Traffic Chart
            SizedBox(
              height: 180,
              child: state.trafficHistory.isEmpty
                  ? const Center(child: Text('جاري قراءة تدفق البيانات...'))
                  : LineChart(
                      LineChartData(
                        gridData: const FlGridData(
                            show: true, drawVerticalLine: false),
                        titlesData: const FlTitlesData(
                          leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                  showTitles: true, reservedSize: 40)),
                          bottomTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: state.trafficHistory
                                .map((e) => FlSpot(e.time, e.rxMbps))
                                .toList(),
                            isCurved: true,
                            color: AppColors.cyanAccent,
                            barWidth: 2.5,
                            dotData: const FlDotData(show: false),
                          ),
                          LineChartBarData(
                            spots: state.trafficHistory
                                .map((e) => FlSpot(e.time, e.txMbps))
                                .toList(),
                            isCurved: true,
                            color: AppColors.success,
                            barWidth: 2.5,
                            dotData: const FlDotData(show: false),
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

  Widget _buildInterfaceCard(
    BuildContext context,
    InterfaceModel iface,
    InterfacesTrafficState state,
    InterfacesTrafficNotifier notifier,
  ) {
    final isSelected = state.selectedInterface == iface.name;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? AppColors.cyanAccent : Colors.transparent,
          width: isSelected ? 1.5 : 0,
        ),
      ),
      child: ListTile(
        onTap: () => notifier.selectInterface(iface.name),
        leading: CircleAvatar(
          backgroundColor: iface.running
              ? AppColors.success.withValues(alpha: 0.15)
              : AppColors.textSecondary.withValues(alpha: 0.15),
          child: Icon(
            iface.type.contains('wlan') ? Icons.wifi : Icons.settings_ethernet,
            color: iface.running ? AppColors.success : AppColors.textSecondary,
          ),
        ),
        title: Row(
          children: [
            Text(iface.name,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: iface.running
                    ? AppColors.success.withValues(alpha: 0.15)
                    : Colors.grey.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                iface.running
                    ? 'نشط (Running)'
                    : (iface.disabled ? 'معطل' : 'مفصول'),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: iface.running
                      ? AppColors.success
                      : AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'النوع: ${iface.type} | MTU: ${iface.mtu} | MAC: ${iface.macAddress}',
              style:
                  const TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 2),
            Text(
              'الإجمالي: RX ${_formatBytes(iface.rxBytes)} / TX ${_formatBytes(iface.txBytes)}',
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.navyPrimary),
            ),
          ],
        ),
        trailing: isSelected
            ? const Icon(Icons.check_circle, color: AppColors.cyanAccent)
            : const Icon(Icons.arrow_forward_ios,
                size: 14, color: AppColors.textSecondary),
      ),
    );
  }

  String _formatBytes(int bytes) {
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    int i = 0;
    double dBytes = bytes.toDouble();
    while (dBytes >= 1024 && i < suffixes.length - 1) {
      dBytes /= 1024;
      i++;
    }
    return '${dBytes.toStringAsFixed(1)} ${suffixes[i]}';
  }
}
