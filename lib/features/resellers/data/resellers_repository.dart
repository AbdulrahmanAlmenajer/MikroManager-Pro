import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';

class ResellerBalance {
  final String currency;
  final double totalAllocated;
  final double totalSettled;

  ResellerBalance({
    required this.currency,
    required this.totalAllocated,
    required this.totalSettled,
  });

  double get remainingDebt => totalAllocated - totalSettled;
}

class ResellersRepository {
  final AppDatabase _db;

  ResellersRepository(this._db);

  /// Create a reseller record
  Future<int> addReseller({
    required int connectionId,
    required String name,
    String phone = '',
    String notes = '',
  }) async {
    return await _db.into(_db.resellersTable).insert(
          ResellersTableCompanion.insert(
            connectionId: connectionId,
            name: name,
            phone: Value(phone),
            notes: Value(notes),
            createdAt: Value(DateTime.now()),
          ),
        );
  }

  /// Get all resellers for connection
  Future<List<ResellersTableData>> getResellers(int connectionId) async {
    return await (_db.select(_db.resellersTable)
          ..where((t) => t.connectionId.equals(connectionId))
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
  }

  /// Watch resellers stream
  Stream<List<ResellersTableData>> watchResellers(int connectionId) {
    return (_db.select(_db.resellersTable)
          ..where((t) => t.connectionId.equals(connectionId))
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  /// Record batch allocation to reseller
  Future<int> allocateVouchers({
    required int resellerId,
    required String batchId,
    required String profile,
    required int quantity,
    required String currency,
    required double unitPrice,
  }) async {
    final total = quantity * unitPrice;
    return await _db.into(_db.resellerAllocationsTable).insert(
          ResellerAllocationsTableCompanion.insert(
            resellerId: resellerId,
            batchId: batchId,
            profile: profile,
            quantity: quantity,
            currency: currency.toUpperCase(),
            unitPrice: unitPrice,
            totalValue: total,
            allocatedAt: Value(DateTime.now()),
          ),
        );
  }

  /// Record cash settlement
  Future<int> addSettlement({
    required int resellerId,
    required String currency,
    required double amountPaid,
    String notes = '',
  }) async {
    return await _db.into(_db.resellerSettlementsTable).insert(
          ResellerSettlementsTableCompanion.insert(
            resellerId: resellerId,
            currency: currency.toUpperCase(),
            amountPaid: amountPaid,
            notes: Value(notes),
            settledAt: Value(DateTime.now()),
          ),
        );
  }

  /// Compute balances strictly separated by currency (NEVER SUM ACROSS CURRENCIES)
  Future<List<ResellerBalance>> getResellerBalances(int resellerId) async {
    final allocations = await (_db.select(_db.resellerAllocationsTable)
          ..where((t) => t.resellerId.equals(resellerId)))
        .get();

    final settlements = await (_db.select(_db.resellerSettlementsTable)
          ..where((t) => t.resellerId.equals(resellerId)))
        .get();

    final Map<String, double> allocatedMap = {};
    for (final a in allocations) {
      final curr = a.currency.toUpperCase();
      allocatedMap[curr] = (allocatedMap[curr] ?? 0.0) + a.totalValue;
    }

    final Map<String, double> settledMap = {};
    for (final s in settlements) {
      final curr = s.currency.toUpperCase();
      settledMap[curr] = (settledMap[curr] ?? 0.0) + s.amountPaid;
    }

    final allCurrencies = {...allocatedMap.keys, ...settledMap.keys};
    return allCurrencies.map((curr) {
      return ResellerBalance(
        currency: curr,
        totalAllocated: allocatedMap[curr] ?? 0.0,
        totalSettled: settledMap[curr] ?? 0.0,
      );
    }).toList();
  }

  /// Watch allocations for a reseller
  Stream<List<ResellerAllocationsTableData>> watchAllocations(int resellerId) {
    return (_db.select(_db.resellerAllocationsTable)
          ..where((t) => t.resellerId.equals(resellerId))
          ..orderBy([(t) => OrderingTerm.desc(t.allocatedAt)]))
        .watch();
  }

  /// Watch settlements for a reseller
  Stream<List<ResellerSettlementsTableData>> watchSettlements(int resellerId) {
    return (_db.select(_db.resellerSettlementsTable)
          ..where((t) => t.resellerId.equals(resellerId))
          ..orderBy([(t) => OrderingTerm.desc(t.settledAt)]))
        .watch();
  }
}

final resellersRepositoryProvider = Provider<ResellersRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return ResellersRepository(db);
});
