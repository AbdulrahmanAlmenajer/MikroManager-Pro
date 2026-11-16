import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RouterItem {
  final String id, name, ip;
  final int port;
  final bool isConnected;
  RouterItem({required this.id, required this.name, required this.ip, required this.port, required this.isConnected});
}

final routersListProvider = StateProvider<List<RouterItem>>((ref) => [
  RouterItem(id: '1', name: 'الراوتر الرئيسي (المركز)', ip: '192.168.88.1', port: 8728, isConnected: true),
  RouterItem(id: '2', name: 'راوتر الفرع الثاني', ip: '10.0.0.1', port: 8729, isConnected: false),
]);

class RoutersScreen extends ConsumerWidget {
  const RoutersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routers = ref.watch(routersListProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('إدارة أجهزة الميكروتك')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddRouterDialog(context, ref),
        backgroundColor: const Color(0xFF0284C7),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('إضافة راوتر', style: TextStyle(color: Colors.white)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: routers.length,
        itemBuilder: (context, index) {
          final item = routers[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: item.isConnected ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                child: Icon(
                  item.isConnected ? Icons.router : Icons.router_outlined,
                  color: Colors.white,
                ),
              ),
              title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('IP: ${item.ip}  |  Port: ${item.port}'),
              trailing: Chip(
                label: Text(
                  item.isConnected ? 'متصل' : 'غير متصل',
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
                backgroundColor: item.isConnected ? const Color(0xFF10B981) : const Color(0xFFEF4444),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAddRouterDialog(BuildContext context, WidgetRef ref) {
    final nameCtrl = TextEditingController();
    final ipCtrl = TextEditingController(text: '192.168.88.1');
    final portCtrl = TextEditingController(text: '8728');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إضافة راوتر جديد'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'اسم الراوتر')),
            const SizedBox(height: 8),
            TextField(controller: ipCtrl, decoration: const InputDecoration(labelText: 'عنوان IP')),
            const SizedBox(height: 8),
            TextField(
              controller: portCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'بورت API'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.isNotEmpty) {
                ref.read(routersListProvider.notifier).update((state) => [
                  ...state,
                  RouterItem(
                    id: DateTime.now().toString(),
                    name: nameCtrl.text,
                    ip: ipCtrl.text,
                    port: int.tryParse(portCtrl.text) ?? 8728,
                    isConnected: false,
                  ),
                ]);
                Navigator.pop(ctx);
              }
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }
}
