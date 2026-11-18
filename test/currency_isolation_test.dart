import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mikro_manager_pro/core/database/app_database.dart';
import 'package:mikro_manager_pro/features/resellers/data/resellers_repository.dart';

void main() {
  late AppDatabase db;
  late ResellersRepository repo;

  setUp(() {
    db = AppDatabase.forTesting(DatabaseConnection(NativeDatabase.memory()));
    repo = ResellersRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Multi-currency Isolation Ledger Tests (Phase U3)', () {
    test('Strict currency isolation: settlements reduce only matching currency',
        () async {
      // 1. Add reseller
      final resellerId = await repo.addReseller(
        connectionId: 1,
        name: 'وكيل المطار - عدن',
        phone: '777000111',
      );

      // 2. Allocate in YER: 100 cards @ 500 YER = 50,000 YER
      await repo.allocateVouchers(
        resellerId: resellerId,
        batchId: 'BATCH_YER_01',
        profile: '1Hour',
        quantity: 100,
        currency: 'YER',
        unitPrice: 500,
      );

      // 3. Allocate in SAR: 50 cards @ 10 SAR = 500 SAR
      await repo.allocateVouchers(
        resellerId: resellerId,
        batchId: 'BATCH_SAR_01',
        profile: '1Day',
        quantity: 50,
        currency: 'SAR',
        unitPrice: 10,
      );

      // 4. Allocate in USD: 10 cards @ 5 USD = 50 USD
      await repo.allocateVouchers(
        resellerId: resellerId,
        batchId: 'BATCH_USD_01',
        profile: '1Month',
        quantity: 10,
        currency: 'USD',
        unitPrice: 5,
      );

      // Verify preliminary debts
      var balances = await repo.getResellerBalances(resellerId);
      final yerBal = balances.firstWhere((b) => b.currency == 'YER');
      final sarBal = balances.firstWhere((b) => b.currency == 'SAR');
      final usdBal = balances.firstWhere((b) => b.currency == 'USD');

      expect(yerBal.totalAllocated, equals(50000.0));
      expect(yerBal.remainingDebt, equals(50000.0));

      expect(sarBal.totalAllocated, equals(500.0));
      expect(sarBal.remainingDebt, equals(500.0));

      expect(usdBal.totalAllocated, equals(50.0));
      expect(usdBal.remainingDebt, equals(50.0));

      // 5. Settle 20,000 YER
      await repo.addSettlement(
        resellerId: resellerId,
        currency: 'YER',
        amountPaid: 20000.0,
        notes: 'دفعة نقدية بالريال اليمني',
      );

      // 6. Verify that ONLY YER debt decreased, and SAR / USD remain untouched
      balances = await repo.getResellerBalances(resellerId);
      final yerBalAfter = balances.firstWhere((b) => b.currency == 'YER');
      final sarBalAfter = balances.firstWhere((b) => b.currency == 'SAR');
      final usdBalAfter = balances.firstWhere((b) => b.currency == 'USD');

      expect(yerBalAfter.totalSettled, equals(20000.0));
      expect(yerBalAfter.remainingDebt, equals(30000.0));

      // SAR and USD MUST BE EXACTLY THE SAME
      expect(sarBalAfter.totalSettled, equals(0.0));
      expect(sarBalAfter.remainingDebt, equals(500.0));

      expect(usdBalAfter.totalSettled, equals(0.0));
      expect(usdBalAfter.remainingDebt, equals(50.0));
    });
  });
}
