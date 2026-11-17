import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';
import '../../subscribers/data/subscribers_repository.dart';

class SalesSummary {
  final int totalVouchers;
  final double totalRevenue;
  final double totalCost;
  final double netProfit;
  final Map<String, int> vouchersByProfile;
  final Map<String, double> revenueByDate;

  SalesSummary({
    required this.totalVouchers,
    required this.totalRevenue,
    required this.totalCost,
    required this.netProfit,
    required this.vouchersByProfile,
    required this.revenueByDate,
  });
}

class HonestStockSummary {
  final int totalCards;
  final int unusedCards;
  final double unusedValue;
  final int activeCards;
  final double activeValue;
  final int expiredCards;
  final List<String> unpricedProfiles;

  const HonestStockSummary({
    required this.totalCards,
    required this.unusedCards,
    required this.unusedValue,
    required this.activeCards,
    required this.activeValue,
    required this.expiredCards,
    required this.unpricedProfiles,
  });
}

class HonestSalesPeriod {
  final int cardsCount;
  final double totalEstimatedAmount;
  final bool hasApproximateDates;

  const HonestSalesPeriod({
    required this.cardsCount,
    required this.totalEstimatedAmount,
    this.hasApproximateDates = false,
  });
}

class HonestEstimatedSales {
  final HonestSalesPeriod today;
  final HonestSalesPeriod last7Days;
  final HonestSalesPeriod last30Days;
  final HonestSalesPeriod allTime;
  final List<UsageObservationsTableData> recentObservations;

  const HonestEstimatedSales({
    required this.today,
    required this.last7Days,
    required this.last30Days,
    required this.allTime,
    required this.recentObservations,
  });
}

class HonestPaymentsSummary {
  final double totalPayments;
  final double estimatedSales;
  final double balance; // totalPayments - estimatedSales
  final List<PaymentsTableData> payments;

  const HonestPaymentsSummary({
    required this.totalPayments,
    required this.estimatedSales,
    required this.balance,
    required this.payments,
  });
}

class HonestReportData {
  final HonestStockSummary stock;
  final HonestEstimatedSales sales;
  final HonestPaymentsSummary payments;
  final Map<String, double> profilePrices;
  final SalesSummary legacySummary;

  const HonestReportData({
    required this.stock,
    required this.sales,
    required this.payments,
    required this.profilePrices,
    required this.legacySummary,
  });
}

class ReportsRepository {
  final AppDatabase _db;

  ReportsRepository(this._db);

  // =========================================================================
  // Legacy Sales Summary & Audit Logs (v2 compatibility)
  // =========================================================================

  Future<SalesSummary> getSalesSummary() async {
    final batches = await _db.select(_db.voucherBatchesTable).get();

    int totalVouchers = 0;
    double totalRevenue = 0.0;
    final Map<String, int> byProfile = {};
    final Map<String, double> byDate = {};

    for (final b in batches) {
      totalVouchers += b.quantity;
      totalRevenue += b.totalAmount;

      byProfile[b.profileName] = (byProfile[b.profileName] ?? 0) + b.quantity;

      final dateKey =
          '${b.generatedAt.year}-${b.generatedAt.month.toString().padLeft(2, '0')}-${b.generatedAt.day.toString().padLeft(2, '0')}';
      byDate[dateKey] = (byDate[dateKey] ?? 0.0) + b.totalAmount;
    }

    final totalCost = totalRevenue * 0.1;
    final netProfit = totalRevenue - totalCost;

    return SalesSummary(
      totalVouchers: totalVouchers,
      totalRevenue: totalRevenue,
      totalCost: totalCost,
      netProfit: netProfit,
      vouchersByProfile: byProfile,
      revenueByDate: byDate,
    );
  }

  Future<List<AuditLogsTableData>> getAuditLogs() async {
    return await (_db.select(_db.auditLogsTable)
          ..orderBy([(t) => OrderingTerm(expression: t.performedAt, mode: OrderingMode.desc)])
          ..limit(50))
        .get();
  }

  // =========================================================================
  // Phase U5: Profile Prices Management
  // =========================================================================

  Future<Map<String, double>> getProfilePrices(int connectionId) async {
    final records = await (_db.select(_db.profilePricesTable)
          ..where((t) => t.connectionId.equals(connectionId)))
        .get();

    final Map<String, double> map = {};
    for (final r in records) {
      map[r.profileName] = r.price;
    }
    return map;
  }

  Future<List<ProfilePricesTableData>> getAllProfilePriceRecords(int connectionId) async {
    return await (_db.select(_db.profilePricesTable)
          ..where((t) => t.connectionId.equals(connectionId)))
        .get();
  }

  Future<void> setProfilePrice({
    required int connectionId,
    required String profileName,
    required double price,
    String currency = 'YER',
  }) async {
    final existing = await (_db.select(_db.profilePricesTable)
          ..where((t) => t.connectionId.equals(connectionId) & t.profileName.equals(profileName)))
        .getSingleOrNull();

    if (existing != null) {
      await (_db.update(_db.profilePricesTable)..where((t) => t.id.equals(existing.id))).write(
        ProfilePricesTableCompanion(
          price: Value(price),
          currency: Value(currency),
          updatedAt: Value(DateTime.now()),
        ),
      );
    } else {
      await _db.into(_db.profilePricesTable).insert(
        ProfilePricesTableCompanion.insert(
          connectionId: connectionId,
          profileName: profileName,
          price: price,
          currency: Value(currency),
          updatedAt: Value(DateTime.now()),
        ),
      );
    }
  }

  // =========================================================================
  // Phase U5: Usage Observations (First-use detection for Honest Sales)
  // =========================================================================

  /// Scans active cards and records newly seen cards that have begun usage.
  /// Cards already expired before observation tracking started are flagged with dateIsApproximate = true.
  Future<int> recordUsageObservations({
    required int connectionId,
    required List<SubscriberModel> subscribers,
    bool isInitialSync = false,
  }) async {
    int newlyObserved = 0;

    // Fetch existing recorded card names for this connection to avoid N+1 queries
    final existingRows = await (_db.select(_db.usageObservationsTable)
          ..where((t) => t.connectionId.equals(connectionId)))
        .get();
    final Set<String> observedCardNames = existingRows.map((r) => r.cardName).toSet();

    for (final s in subscribers) {
      // Check if card has usage: uptime > 0 or traffic > 0
      final hasUptime = s.uptime != null && s.uptime!.isNotEmpty && s.uptime != '0s';
      final hasTraffic = (s.bytesIn + s.bytesOut) > 0;

      if (hasUptime || hasTraffic) {
        if (!observedCardNames.contains(s.username)) {
          // If the card is already expired at initial sync, we don't count it as a new sale,
          // but we record it with dateIsApproximate = true so it won't inflate today's numbers.
          final isApproximate = isInitialSync || s.isExpired;

          await _db.into(_db.usageObservationsTable).insert(
            UsageObservationsTableCompanion.insert(
              connectionId: connectionId,
              cardName: s.username,
              profile: s.profile,
              firstSeenAt: Value(DateTime.now()),
              dateIsApproximate: Value(isApproximate),
            ),
          );
          observedCardNames.add(s.username);
          newlyObserved++;
        }
      }
    }

    return newlyObserved;
  }

  Future<List<UsageObservationsTableData>> getUsageObservations(
    int connectionId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    var query = _db.select(_db.usageObservationsTable)
      ..where((t) => t.connectionId.equals(connectionId));

    if (startDate != null) {
      query = query..where((t) => t.firstSeenAt.isBiggerOrEqualValue(startDate));
    }
    if (endDate != null) {
      query = query..where((t) => t.firstSeenAt.isSmallerOrEqualValue(endDate));
    }

    query = query
      ..orderBy([(t) => OrderingTerm(expression: t.firstSeenAt, mode: OrderingMode.desc)]);

    return await query.get();
  }

  // =========================================================================
  // Phase U5: Manual Payments Management
  // =========================================================================

  Future<int> addPayment({
    required int connectionId,
    required double amount,
    String? note,
    DateTime? receivedAt,
  }) async {
    return await _db.into(_db.paymentsTable).insert(
      PaymentsTableCompanion.insert(
        connectionId: connectionId,
        amount: amount,
        note: Value(note),
        receivedAt: Value(receivedAt ?? DateTime.now()),
      ),
    );
  }

  Future<List<PaymentsTableData>> getPayments(int connectionId) async {
    return await (_db.select(_db.paymentsTable)
          ..where((t) => t.connectionId.equals(connectionId))
          ..orderBy([(t) => OrderingTerm(expression: t.receivedAt, mode: OrderingMode.desc)]))
        .get();
  }

  Future<int> deletePayment(int id) async {
    return await (_db.delete(_db.paymentsTable)..where((t) => t.id.equals(id))).go();
  }

  // =========================================================================
  // Phase U5: Card Events Logging (Generation / Deletion)
  // =========================================================================

  Future<int> recordCardEvent({
    required int connectionId,
    required String type,
    required int count,
    required String profile,
    DateTime? at,
  }) async {
    return await _db.into(_db.cardEventsTable).insert(
      CardEventsTableCompanion.insert(
        connectionId: connectionId,
        type: type,
        count: count,
        profile: profile,
        at: Value(at ?? DateTime.now()),
      ),
    );
  }

  Future<List<CardEventsTableData>> getCardEvents(int connectionId) async {
    return await (_db.select(_db.cardEventsTable)
          ..where((t) => t.connectionId.equals(connectionId))
          ..orderBy([(t) => OrderingTerm(expression: t.at, mode: OrderingMode.desc)]))
        .get();
  }

  // =========================================================================
  // Phase U5: Retention Policy (Clean old detailed observations)
  // =========================================================================

  Future<int> cleanOldObservations(int connectionId, {int keepDays = 30}) async {
    final cutoff = DateTime.now().subtract(Duration(days: keepDays));
    return await (_db.delete(_db.usageObservationsTable)
          ..where(
              (t) => t.connectionId.equals(connectionId) & t.firstSeenAt.isSmallerThanValue(cutoff)))
        .go();
  }

  // =========================================================================
  // Phase U5: Comprehensive Honest Reports Aggregation
  // =========================================================================

  Future<HonestReportData> getHonestReportData({
    required int connectionId,
    required List<SubscriberModel> subscribers,
    String? resellerPrefix,
  }) async {
    // 1. Filter subscribers if reseller scope applies
    final filteredSubscribers = (resellerPrefix != null && resellerPrefix.isNotEmpty)
        ? subscribers.where((s) => s.username.startsWith(resellerPrefix)).toList()
        : subscribers;

    // 2. Fetch profile prices
    final profilePrices = await getProfilePrices(connectionId);
    final Set<String> unpriced = {};

    int totalCards = filteredSubscribers.length;
    int unusedCards = 0;
    double unusedValue = 0.0;
    int activeCards = 0;
    double activeValue = 0.0;
    int expiredCards = 0;

    for (final s in filteredSubscribers) {
      final price = profilePrices[s.profile];
      if (price == null) {
        unpriced.add(s.profile);
      }
      final unitPrice = price ?? 0.0;

      final hasUptime = s.uptime != null && s.uptime!.isNotEmpty && s.uptime != '0s';
      final hasTraffic = (s.bytesIn + s.bytesOut) > 0;

      if (s.isExpired) {
        expiredCards++;
      } else if (!hasUptime && !hasTraffic) {
        unusedCards++;
        unusedValue += unitPrice;
      } else {
        activeCards++;
        activeValue += unitPrice;
      }
    }

    final stockSummary = HonestStockSummary(
      totalCards: totalCards,
      unusedCards: unusedCards,
      unusedValue: unusedValue,
      activeCards: activeCards,
      activeValue: activeValue,
      expiredCards: expiredCards,
      unpricedProfiles: unpriced.toList(),
    );

    // 3. Estimated sales from usage observations
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));

    final observations = await getUsageObservations(connectionId);

    // Filter observations for reseller if required
    final filteredObservations = (resellerPrefix != null && resellerPrefix.isNotEmpty)
        ? observations.where((o) => o.cardName.startsWith(resellerPrefix)).toList()
        : observations;

    HonestSalesPeriod calculatePeriod(List<UsageObservationsTableData> list) {
      double total = 0.0;
      bool hasApprox = false;
      for (final item in list) {
        final p = profilePrices[item.profile] ?? 0.0;
        total += p;
        if (item.dateIsApproximate) hasApprox = true;
      }
      return HonestSalesPeriod(
        cardsCount: list.length,
        totalEstimatedAmount: total,
        hasApproximateDates: hasApprox,
      );
    }

    final todayObs = filteredObservations.where((o) => o.firstSeenAt.isAfter(todayStart)).toList();
    final weekObs = filteredObservations.where((o) => o.firstSeenAt.isAfter(sevenDaysAgo)).toList();
    final monthObs =
        filteredObservations.where((o) => o.firstSeenAt.isAfter(thirtyDaysAgo)).toList();

    final estimatedSales = HonestEstimatedSales(
      today: calculatePeriod(todayObs),
      last7Days: calculatePeriod(weekObs),
      last30Days: calculatePeriod(monthObs),
      allTime: calculatePeriod(filteredObservations),
      recentObservations: filteredObservations.take(50).toList(),
    );

    // 4. Payments
    final payments = await getPayments(connectionId);
    final totalPayments = payments.fold<double>(0.0, (acc, p) => acc + p.amount);
    final estimatedMonthSales = estimatedSales.last30Days.totalEstimatedAmount;
    final balance = totalPayments - estimatedMonthSales;

    final paymentsSummary = HonestPaymentsSummary(
      totalPayments: totalPayments,
      estimatedSales: estimatedMonthSales,
      balance: balance,
      payments: payments,
    );

    // 5. Legacy Sales Summary for compatibility
    final legacySummary = await getSalesSummary();

    return HonestReportData(
      stock: stockSummary,
      sales: estimatedSales,
      payments: paymentsSummary,
      profilePrices: profilePrices,
      legacySummary: legacySummary,
    );
  }
}
