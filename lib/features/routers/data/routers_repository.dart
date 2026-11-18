import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';
import '../../../core/security/secure_storage_service.dart';
import '../../../core/network/routeros_adapter.dart';

class RoutersRepository {
  final AppDatabase _db;

  RoutersRepository(this._db);

  Stream<List<RoutersTableData>> watchAllRouters() {
    return _db.select(_db.routersTable).watch();
  }

  Future<List<RoutersTableData>> getAllRouters() async {
    return await _db.select(_db.routersTable).get();
  }

  Future<RoutersTableData?> getRouterById(int id) async {
    return await (_db.select(_db.routersTable)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<int> addRouter({
    required String name,
    required String ipAddress,
    required int apiPort,
    required String username,
    required String password,
    bool useSsl = false,
    bool useRestApi = false,
    String? notes,
  }) async {
    final id = await _db.into(_db.routersTable).insert(
          RoutersTableCompanion.insert(
            name: name,
            ipAddress: ipAddress,
            apiPort: Value(apiPort),
            username: Value(username),
            useSsl: Value(useSsl),
            useRestApi: Value(useRestApi),
            notes: Value(notes),
            createdAt: Value(DateTime.now()),
          ),
        );

    // Save password securely
    await SecureStorageService.saveRouterPassword(id, password);
    return id;
  }

  Future<bool> updateRouter({
    required int id,
    required String name,
    required String ipAddress,
    required int apiPort,
    required String username,
    String? password,
    bool useSsl = false,
    bool useRestApi = false,
    String? notes,
  }) async {
    final updated = await (_db.update(_db.routersTable)
          ..where((tbl) => tbl.id.equals(id)))
        .write(
      RoutersTableCompanion(
        name: Value(name),
        ipAddress: Value(ipAddress),
        apiPort: Value(apiPort),
        username: Value(username),
        useSsl: Value(useSsl),
        useRestApi: Value(useRestApi),
        notes: Value(notes),
      ),
    );

    if (password != null && password.isNotEmpty) {
      await SecureStorageService.saveRouterPassword(id, password);
    }

    return updated > 0;
  }

  Future<bool> deleteRouter(int id) async {
    final deleted = await (_db.delete(_db.routersTable)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
    await SecureStorageService.deleteRouterPassword(id);
    return deleted > 0;
  }

  Future<void> setActiveRouter(int id) async {
    // Unset all
    await (_db.update(_db.routersTable)).write(
      const RoutersTableCompanion(isActive: Value(false)),
    );
    // Set active
    await (_db.update(_db.routersTable)..where((tbl) => tbl.id.equals(id)))
        .write(
      RoutersTableCompanion(
        isActive: const Value(true),
        lastConnectedAt: Value(DateTime.now()),
      ),
    );
    await SecureStorageService.setSelectedRouter(id.toString());
  }

  Future<bool> testRouterConnection({
    required String ipAddress,
    required int apiPort,
    required String username,
    required String password,
    bool useSsl = false,
    bool useRestApi = false,
  }) async {
    try {
      final adapter = RouterOsAdapter.create(
        host: ipAddress,
        port: apiPort,
        username: username,
        password: password,
        useSsl: useSsl,
        useRest: useRestApi,
      );
      return await adapter.testConnection();
    } catch (_) {
      return false;
    }
  }
}
