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
  final int hotspotCardsCount;
  final double hotspotValue;
  final int userManCardsCount;
  final double userManValue;

  const HonestStockSummary({
    required this.totalCards,
    required this.unusedCards,
    required this.unusedValue,
    required this.activeCards,
    required this.activeValue,
    required this.expiredCards,
    required this.unpricedProfiles,
    this.hotspotCardsCount = 0,
    this.hotspotValue = 0.0,
    this.userManCardsCount = 0,
    this.userManValue = 0.0,
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
  final double hotspotRevenue;
  final double userManRevenue;
  final int hotspotCardsCount;
  final int userManCardsCount;

  const HonestEstimatedSales({
    required this.today,
    required this.last7Days,
    required this.last30Days,
    required this.allTime,
    required this.recentObservations,
    this.hotspotRevenue = 0.0,
    this.userManRevenue = 0.0,
    this.hotspotCardsCount = 0,
    this.userManCardsCount = 0,
  });
}

class HonestComparisonSummary {
  final int hotspotTotalCards;
  final int hotspotActiveCards;
  final double hotspotRevenue;
  final double hotspotAveragePrice;
  final int userManTotalCards;
  final int userManActiveCards;
  final double userManRevenue;
  final double userManAveragePrice;
  final String leadingSystem; // 'Hotspot', 'User Manager', 'متساويان'
  final Map<String, int> topHotspotProfiles;
  final Map<String, int> topUserManProfiles;

  const HonestComparisonSummary({
    required this.hotspotTotalCards,
    required this.hotspotActiveCards,
    required this.hotspotRevenue,
    required this.hotspotAveragePrice,
    required this.userManTotalCards,
    required this.userManActiveCards,
    required this.userManRevenue,
    required this.userManAveragePrice,
    required this.leadingSystem,
    required this.topHotspotProfiles,
    required this.topUserManProfiles,
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
  final HonestComparisonSummary comparison;
  final List<CardSalesTableData> recordedSales;
  final double totalRecordedSalesRevenue;
  final Map<String, double> profilePrices;
  final SalesSummary legacySummary;

  const HonestReportData({
    required this.stock,
    required this.sales,
    required this.payments,
    required this.comparison,
    this.recordedSales = const [],
    this.totalRecordedSalesRevenue = 0.0,
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
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.performedAt, mode: OrderingMode.desc)
          ])
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

  Future<List<ProfilePricesTableData>> getAllProfilePriceRecords(
      int connectionId) async {
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
          ..where((t) =>
              t.connectionId.equals(connectionId) &
              t.profileName.equals(profileName)))
        .getSingleOrNull();

    if (existing != null) {
      await (_db.update(_db.profilePricesTable)
            ..where((t) => t.id.equals(existing.id)))
          .write(
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
  // Phase U5 & v4.1: Usage Observations (First-use detection for Honest Sales)
  // =========================================================================

  Future<int> recordUsageObservations({
    required int connectionId,
    required List<SubscriberModel> subscribers,
    bool isInitialSync = false,
  }) async {
    int newlyObserved = 0;

    final existingRows = await (_db.select(_db.usageObservationsTable)
          ..where((t) => t.connectionId.equals(connectionId)))
        .get();
    final Set<String> observedCardNames =
        existingRows.map((r) => r.cardName).toSet();

    for (final s in subscribers) {
      final hasUptime =
          s.uptime != null && s.uptime!.isNotEmpty && s.uptime != '0s';
      final hasTraffic = (s.bytesIn + s.bytesOut) > 0;

      if (hasUptime || hasTraffic) {
        if (!observedCardNames.contains(s.username)) {
          final isApproximate = isInitialSync || s.isExpired;
          final cardType =
              s.type == SubscriberType.userMan ? 'usermanager' : 'hotspot';

          await _db.into(_db.usageObservationsTable).insert(
                UsageObservationsTableCompanion.insert(
                  connectionId: connectionId,
                  cardName: s.username,
                  profile: s.profile,
                  cardType: Value(cardType),
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
    String? cardType,
  }) async {
    var query = _db.select(_db.usageObservationsTable)
      ..where((t) => t.connectionId.equals(connectionId));

    if (cardType != null && cardType != 'all') {
      query = query..where((t) => t.cardType.equals(cardType));
    }
    if (startDate != null) {
      query = query
        ..where((t) => t.firstSeenAt.isBiggerOrEqualValue(startDate));
    }
    if (endDate != null) {
      query = query..where((t) => t.firstSeenAt.isSmallerOrEqualValue(endDate));
    }

    query = query
      ..orderBy([
        (t) => OrderingTerm(expression: t.firstSeenAt, mode: OrderingMode.desc)
      ]);

    return await query.get();
  }

  // =========================================================================
  // v4.1 Card Sales Management & Idempotency (المهمة 9)
  // =========================================================================

  Future<bool> recordCardSale({
    required int connectionId,
    required String cardType, // 'hotspot' or 'usermanager'
    required String username,
    required String profile,
    required double price,
    double cost = 0.0,
    String soldBy = 'admin',
    String paymentMethod = 'cash',
    String? customerName,
    String? customerPhone,
    String? notes,
    String? customSaleId,
  }) async {
    final saleId = customSaleId ??
        'sale_${connectionId}_${username}_${DateTime.now().millisecondsSinceEpoch}';

    // Idempotency: verify this saleId does not already exist
    final existing = await (_db.select(_db.cardSalesTable)
          ..where((t) => t.saleId.equals(saleId)))
        .getSingleOrNull();
    if (existing != null) {
      return false; // Already recorded
    }

    // Secondary idempotency: prevent accidental double-tap within 5 seconds for same user
    final recent = await (_db.select(_db.cardSalesTable)
          ..where((t) =>
              t.connectionId.equals(connectionId) &
              t.username.equals(username) &
              t.soldAt.isBiggerOrEqualValue(
                  DateTime.now().subtract(const Duration(seconds: 5)))))
        .getSingleOrNull();
    if (recent != null) {
      return false;
    }

    await _db.into(_db.cardSalesTable).insert(
          CardSalesTableCompanion.insert(
            connectionId: connectionId,
            saleId: saleId,
            cardType: Value(cardType),
            username: username,
            profile: profile,
            price: Value(price),
            cost: Value(cost),
            soldBy: Value(soldBy),
            paymentMethod: Value(paymentMethod),
            customerName: Value(customerName),
            customerPhone: Value(customerPhone),
            notes: Value(notes),
            soldAt: Value(DateTime.now()),
          ),
        );

    return true;
  }

  Future<List<CardSalesTableData>> getCardSales(
    int connectionId, {
    String? cardType,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    var query = _db.select(_db.cardSalesTable)
      ..where((t) => t.connectionId.equals(connectionId));

    if (cardType != null && cardType != 'all') {
      query = query..where((t) => t.cardType.equals(cardType));
    }
    if (startDate != null) {
      query = query..where((t) => t.soldAt.isBiggerOrEqualValue(startDate));
    }
    if (endDate != null) {
      query = query..where((t) => t.soldAt.isSmallerOrEqualValue(endDate));
    }

    query = query
      ..orderBy(
          [(t) => OrderingTerm(expression: t.soldAt, mode: OrderingMode.desc)]);

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

  Future<List<PaymentsTableData>> getPayments(
    int connectionId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    var query = _db.select(_db.paymentsTable)
      ..where((t) => t.connectionId.equals(connectionId));

    if (startDate != null) {
      query = query..where((t) => t.receivedAt.isBiggerOrEqualValue(startDate));
    }
    if (endDate != null) {
      query = query..where((t) => t.receivedAt.isSmallerOrEqualValue(endDate));
    }

    query = query
      ..orderBy([
        (t) => OrderingTerm(expression: t.receivedAt, mode: OrderingMode.desc)
      ]);

    return await query.get();
  }

  Future<bool> deletePayment(int id) async {
    final deleted = await (_db.delete(_db.paymentsTable)
          ..where((t) => t.id.equals(id)))
        .go();
    return deleted > 0;
  }

  // =========================================================================
  // Phase U5 & v4.1: Comprehensive Honest Reports Aggregation
  // =========================================================================

  Future<HonestReportData> getHonestReportData({
    required int connectionId,
    required List<SubscriberModel> subscribers,
    String? resellerPrefix,
  }) async {
    final filteredSubscribers =
        (resellerPrefix != null && resellerPrefix.isNotEmpty)
            ? subscribers
                .where((s) => s.username.startsWith(resellerPrefix))
                .toList()
            : subscribers;

    final profilePrices = await getProfilePrices(connectionId);
    final Set<String> unpriced = {};

    int totalCards = filteredSubscribers.length;
    int unusedCards = 0;
    double unusedValue = 0.0;
    int activeCards = 0;
    double activeValue = 0.0;
    int expiredCards = 0;

    int hotspotCardsCount = 0;
    double hotspotValue = 0.0;
    int userManCardsCount = 0;
    double userManValue = 0.0;
    int hotspotActiveCount = 0;
    int userManActiveCount = 0;

    final Map<String, int> topHotspotProfiles = {};
    final Map<String, int> topUserManProfiles = {};

    for (final s in filteredSubscribers) {
      final price = profilePrices[s.profile];
      if (price == null) {
        unpriced.add(s.profile);
      }
      final unitPrice = price ?? 0.0;

      final isUserMan = s.type == SubscriberType.userMan;
      if (isUserMan) {
        userManCardsCount++;
        userManValue += unitPrice;
        topUserManProfiles[s.profile] =
            (topUserManProfiles[s.profile] ?? 0) + 1;
      } else {
        hotspotCardsCount++;
        hotspotValue += unitPrice;
        topHotspotProfiles[s.profile] =
            (topHotspotProfiles[s.profile] ?? 0) + 1;
      }

      final hasUptime =
          s.uptime != null && s.uptime!.isNotEmpty && s.uptime != '0s';
      final hasTraffic = (s.bytesIn + s.bytesOut) > 0;

      if (s.isExpired) {
        expiredCards++;
      } else if (!hasUptime && !hasTraffic) {
        unusedCards++;
        unusedValue += unitPrice;
      } else {
        activeCards++;
        activeValue += unitPrice;
        if (isUserMan) {
          userManActiveCount++;
        } else {
          hotspotActiveCount++;
        }
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
      hotspotCardsCount: hotspotCardsCount,
      hotspotValue: hotspotValue,
      userManCardsCount: userManCardsCount,
      userManValue: userManValue,
    );

    // 3. Estimated sales from usage observations
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));

    final observations = await getUsageObservations(connectionId);

    final filteredObservations =
        (resellerPrefix != null && resellerPrefix.isNotEmpty)
            ? observations
                .where((o) => o.cardName.startsWith(resellerPrefix))
                .toList()
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

    final todayObs = filteredObservations
        .where((o) => o.firstSeenAt.isAfter(todayStart))
        .toList();
    final weekObs = filteredObservations
        .where((o) => o.firstSeenAt.isAfter(sevenDaysAgo))
        .toList();
    final monthObs = filteredObservations
        .where((o) => o.firstSeenAt.isAfter(thirtyDaysAgo))
        .toList();

    // Breakdown by type
    double hotspotRevenue = 0.0;
    double userManRevenue = 0.0;
    int hotspotObsCount = 0;
    int userManObsCount = 0;

    for (final o in filteredObservations) {
      final p = profilePrices[o.profile] ?? 0.0;
      if (o.cardType == 'usermanager') {
        userManRevenue += p;
        userManObsCount++;
      } else {
        hotspotRevenue += p;
        hotspotObsCount++;
      }
    }

    final estimatedSales = HonestEstimatedSales(
      today: calculatePeriod(todayObs),
      last7Days: calculatePeriod(weekObs),
      last30Days: calculatePeriod(monthObs),
      allTime: calculatePeriod(filteredObservations),
      recentObservations: filteredObservations.take(50).toList(),
      hotspotRevenue: hotspotRevenue,
      userManRevenue: userManRevenue,
      hotspotCardsCount: hotspotObsCount,
      userManCardsCount: userManObsCount,
    );

    // 4. Comparison summary
    final hsAvg =
        hotspotCardsCount > 0 ? (hotspotValue / hotspotCardsCount) : 0.0;
    final umAvg =
        userManCardsCount > 0 ? (userManValue / userManCardsCount) : 0.0;

    String leader = 'متساويان';
    if (hotspotRevenue > userManRevenue) {
      leader = 'Hotspot متصدر بالمبيعات';
    } else if (userManRevenue > hotspotRevenue) {
      leader = 'User Manager متصدر بالمبيعات';
    }

    final comparison = HonestComparisonSummary(
      hotspotTotalCards: hotspotCardsCount,
      hotspotActiveCards: hotspotActiveCount,
      hotspotRevenue: hotspotRevenue,
      hotspotAveragePrice: hsAvg,
      userManTotalCards: userManCardsCount,
      userManActiveCards: userManActiveCount,
      userManRevenue: userManRevenue,
      userManAveragePrice: umAvg,
      leadingSystem: leader,
      topHotspotProfiles: topHotspotProfiles,
      topUserManProfiles: topUserManProfiles,
    );

    // 5. Payments
    final payments = await getPayments(connectionId);
    final totalPayments =
        payments.fold<double>(0.0, (acc, p) => acc + p.amount);
    final estimatedMonthSales = estimatedSales.last30Days.totalEstimatedAmount;
    final balance = totalPayments - estimatedMonthSales;

    final paymentsSummary = HonestPaymentsSummary(
      totalPayments: totalPayments,
      estimatedSales: estimatedMonthSales,
      balance: balance,
      payments: payments,
    );

    // 6. Explicit Recorded Card Sales
    final recordedSales = await getCardSales(connectionId);
    final recordedTotal =
        recordedSales.fold<double>(0.0, (acc, s) => acc + s.price);

    // 7. Legacy Sales Summary for compatibility
    final legacySummary = await getSalesSummary();

    return HonestReportData(
      stock: stockSummary,
      sales: estimatedSales,
      payments: paymentsSummary,
      comparison: comparison,
      recordedSales: recordedSales,
      totalRecordedSalesRevenue: recordedTotal,
      profilePrices: profilePrices,
      legacySummary: legacySummary,
    );
  }

  Future<int> cleanOldObservations(int connectionId,
      {int keepDays = 30}) async {
    final cutoff = DateTime.now().subtract(Duration(days: keepDays));
    return await (_db.delete(_db.usageObservationsTable)
          ..where((t) =>
              t.connectionId.equals(connectionId) &
              t.firstSeenAt.isSmallerThanValue(cutoff)))
        .go();
  }
}
