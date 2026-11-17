import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';
import '../../../core/network/routeros_adapter.dart';

class InterfaceModel {
  final String id;
  final String name;
  final String type;
  final bool running;
  final bool disabled;
  final String macAddress;
  final String mtu;
  final int rxBytes;
  final int txBytes;

  const InterfaceModel({
    required this.id,
    required this.name,
    required this.type,
    required this.running,
    required this.disabled,
    required this.macAddress,
    required this.mtu,
    required this.rxBytes,
    required this.txBytes,
  });

  factory InterfaceModel.fromMap(Map<String, dynamic> map) {
    return InterfaceModel(
      id: map['.id']?.toString() ?? '',
      name: map['name']?.toString() ?? 'unknown',
      type: map['type']?.toString() ?? 'ether',
      running: map['running'] == 'true' || map['running'] == true,
      disabled: map['disabled'] == 'true' || map['disabled'] == true,
      macAddress: map['mac-address']?.toString() ?? '-',
      mtu: map['mtu']?.toString() ?? '-',
      rxBytes: int.tryParse(map['rx-byte']?.toString() ?? '0') ?? 0,
      txBytes: int.tryParse(map['tx-byte']?.toString() ?? '0') ?? 0,
    );
  }
}

class DashboardRepository {
  Future<Map<String, dynamic>> getSystemResource(RouterOsAdapter adapter) async {
    return await adapter.getSystemResource();
  }

  Future<List<Map<String, dynamic>>> getInterfaces(RouterOsAdapter adapter) async {
    return await adapter.getInterfaces();
  }

  Future<List<InterfaceModel>> getDetailedInterfaces(RouterOsAdapter adapter) async {
    final res = await adapter.executeSentence(['/interface/print']);
    if (!res.isSuccess) return [];
    return res.data.map((m) => InterfaceModel.fromMap(m)).toList();
  }

  Future<bool> toggleInterface(RouterOsAdapter adapter, String id, bool enable) async {
    final res = await adapter.executeSentence([
      '/interface/set',
      '=.id=$id',
      '=disabled=${enable ? 'no' : 'yes'}',
    ]);
    return res.isSuccess;
  }

  Future<Map<String, int>> getTraffic(RouterOsAdapter adapter, String interfaceName) async {
    return await adapter.getInterfaceTraffic(interfaceName);
  }

  Future<int> getActiveUsersCount(RouterOsAdapter adapter) async {
    final active = await adapter.getHotspotActive();
    return active.length;
  }

  Future<void> recordDailySnapshot(
    AppDatabase db, {
    required int connectionId,
    required String interfaceName,
    required int rxBytes,
    required int txBytes,
  }) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    await db.into(db.interfaceDailyTable).insert(
      InterfaceDailyTableCompanion.insert(
        connectionId: connectionId,
        interface: interfaceName,
        date: today,
        rxBytes: Value(rxBytes),
        txBytes: Value(txBytes),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  Future<List<InterfaceDailyTableData>> getDailySnapshots(
    AppDatabase db, {
    required int connectionId,
    required String interfaceName,
  }) async {
    return await (db.select(db.interfaceDailyTable)
          ..where((t) => t.connectionId.equals(connectionId) & t.interface.equals(interfaceName))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .get();
  }
}
