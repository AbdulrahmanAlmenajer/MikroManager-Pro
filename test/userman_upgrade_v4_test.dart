import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mikro_manager_pro/core/database/app_database.dart';
import 'package:mikro_manager_pro/core/utils/pdf_generator_helper.dart';
import 'package:mikro_manager_pro/features/reports/data/reports_repository.dart';
import 'package:mikro_manager_pro/features/subscribers/data/subscribers_repository.dart';
import 'package:mikro_manager_pro/features/userman/domain/um_profile_model.dart';
import 'package:mikro_manager_pro/features/vouchers/domain/unified_card_model.dart';

void main() {
  group('UnifiedCardModel & UM Domain Tests', () {
    test(
        'UnifiedCardModel converts correctly from and to JSON and VoucherCardData',
        () {
      const card = UnifiedCardModel(
        id: '*10',
        username: 'um_user_77',
        password: 'pass_123',
        profile: '1Day',
        cardType: CardType.userMan,
        status: CardStatus.newCard,
        price: 500.0,
        validity: '1d',
        uptime: '0s',
        bytesIn: 0,
        bytesOut: 0,
        isPrinted: false,
      );

      expect(card.isUsed, isFalse);
      expect(card.cardTypeTitle, equals('User Manager'));

      final json = card.toJson();
      expect(json['username'], equals('um_user_77'));
      expect(json['cardType'], equals('userMan'));

      final fromJson = UnifiedCardModel.fromJson(json);
      expect(fromJson.username, equals('um_user_77'));
      expect(fromJson.cardType, equals(CardType.userMan));

      final voucher = card.toVoucherCardData();
      expect(voucher.username, equals('um_user_77'));
      expect(voucher.password, equals('pass_123'));
      expect(voucher.profile, equals('1Day'));
      expect(voucher.price, equals(500.0));
      expect(voucher.validity, equals('1d'));
    });

    test('UmProfileModel calculates active and total counts accurately', () {
      const profile = UmProfileModel(
        id: '*P1',
        name: 'VIP_1Month',
        price: 3000.0,
        validity: '30d',
        usersCount: 150,
        activeSessionsCount: 42,
        rateLimit: '5M/5M',
        isV7: true,
      );

      expect(profile.displayName, equals('VIP_1Month'));
      expect(profile.usersCount, equals(150));
      expect(profile.activeSessionsCount, equals(42));
      expect(profile.price, equals(3000.0));
    });
  });

  group('Card Sales & Idempotency in ReportsRepository', () {
    late AppDatabase db;
    late ReportsRepository repo;

    setUp(() {
      db = AppDatabase.forTesting(DatabaseConnection(NativeDatabase.memory()));
      repo = ReportsRepository(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('recordCardSale correctly inserts and prevents duplicate clicks',
        () async {
      // 1. Record first sale
      final success1 = await repo.recordCardSale(
        connectionId: 1,
        cardType: 'usermanager',
        username: 'um_card_001',
        profile: '3Hours',
        price: 250.0,
        soldBy: 'cashier1',
        customerName: 'Ahmed',
      );
      expect(success1, isTrue);

      // 2. Immediate duplicate attempt (same username within 5 seconds)
      final duplicateSuccess = await repo.recordCardSale(
        connectionId: 1,
        cardType: 'usermanager',
        username: 'um_card_001',
        profile: '3Hours',
        price: 250.0,
        soldBy: 'cashier1',
      );
      // Idempotency: should return false and NOT create a new row
      expect(duplicateSuccess, isFalse);

      final allSales = await repo.getCardSales(1);
      expect(allSales.length, equals(1));
      expect(allSales.first.username, equals('um_card_001'));
      expect(allSales.first.cardType, equals('usermanager'));
      expect(allSales.first.price, equals(250.0));
    });

    test(
        'HonestComparisonSummary accurately reports Hotspot vs User Manager breakdown',
        () async {
      final subscribers = [
        // Hotspot cards
        const SubscriberModel(
          id: '*H1',
          username: 'hs_user_1',
          profile: '1Hour',
          type: SubscriberType.hotspot,
          uptime: '10m',
          bytesIn: 1024,
          bytesOut: 2048,
        ),
        const SubscriberModel(
          id: '*H2',
          username: 'hs_user_2',
          profile: '1Hour',
          type: SubscriberType.hotspot,
          uptime: '0s',
          bytesIn: 0,
          bytesOut: 0,
        ),
        // User Manager cards
        const SubscriberModel(
          id: '*U1',
          username: 'um_user_1',
          profile: '1Day',
          type: SubscriberType.userMan,
          uptime: '2h',
          bytesIn: 5000000,
          bytesOut: 2000000,
        ),
        const SubscriberModel(
          id: '*U2',
          username: 'um_user_2',
          profile: '1Day',
          type: SubscriberType.userMan,
          uptime: '4h',
          bytesIn: 9000000,
          bytesOut: 3000000,
        ),
      ];

      // Set prices
      await repo.setProfilePrice(
          connectionId: 1, profileName: '1Hour', price: 100.0);
      await repo.setProfilePrice(
          connectionId: 1, profileName: '1Day', price: 500.0);

      // Record observations
      await repo.recordUsageObservations(
          connectionId: 1, subscribers: subscribers);

      // Fetch Honest Report Data
      final data = await repo.getHonestReportData(
          connectionId: 1, subscribers: subscribers);

      final comp = data.comparison;
      expect(comp.hotspotTotalCards, equals(2));
      expect(comp.hotspotActiveCards, equals(1));
      expect(comp.hotspotRevenue, equals(100.0));

      expect(comp.userManTotalCards, equals(2));
      expect(comp.userManActiveCards, equals(2));
      expect(comp.userManRevenue, equals(1000.0));

      // User Manager has higher revenue (1000 > 100)
      expect(comp.leadingSystem, contains('User Manager'));
      expect(comp.topHotspotProfiles['1Hour'], equals(2));
      expect(comp.topUserManProfiles['1Day'], equals(2));
    });

    test('Voucher templates store and retrieve all 25 custom styling fields',
        () async {
      final insertedId = await db.into(db.voucherTemplatesTable).insert(
            VoucherTemplatesTableCompanion.insert(
              name: 'Modern Dark Neon',
              paperSize: const Value('A4'),
              cardsPerRow: const Value(3),
              cardsPerPage: const Value(12),
              primaryColorHex: const Value(0xFF0F172A),
              backgroundColorHex: const Value(0xFF000000),
              textColorHex: const Value(0xFFFFFFFF),
              borderColorHex: const Value(0xFF0EA5E9),
              borderWidth: const Value(2.0),
              borderRadius: const Value(12.0),
              fontSize: const Value(11.0),
              titleFontSize: const Value(13.0),
              showQrCode: const Value(true),
              showBarcode: const Value(true),
              showProfile: const Value(true),
              showPrice: const Value(true),
              showValidity: const Value(true),
              showUsername: const Value(true),
              showPassword: const Value(true),
              showInstructions: const Value(true),
              headerText: const Value('شبكة النجوم'),
              footerText: const Value('خدمة العملاء 777000111'),
              instructionsText: const Value('امسح الرمز أو أدخل الكود'),
              contactPhone: const Value('777000111'),
              targetCardType: const Value('usermanager'),
            ),
          );

      final template = await (db.select(db.voucherTemplatesTable)
            ..where((t) => t.id.equals(insertedId)))
          .getSingle();

      expect(template.name, equals('Modern Dark Neon'));
      expect(template.backgroundColorHex, equals(0xFF000000));
      expect(template.borderColorHex, equals(0xFF0EA5E9));
      expect(template.borderWidth, equals(2.0));
      expect(template.borderRadius, equals(12.0));
      expect(template.showBarcode, isTrue);
      expect(template.targetCardType, equals('usermanager'));
      expect(template.contactPhone, equals('777000111'));
    });

    test(
        'PdfGeneratorHelper generates valid PDF document bytes with custom template',
        () async {
      final vouchers = [
        VoucherCardData(
          username: '77001',
          password: 'pass',
          profile: '2Hours',
          price: 200.0,
          validity: '2h',
          networkName: 'Test WiFi',
        ),
        VoucherCardData(
          username: '77002',
          password: 'pass',
          profile: '2Hours',
          price: 200.0,
          validity: '2h',
          networkName: 'Test WiFi',
        ),
      ];

      final pdfBytes = await PdfGeneratorHelper.generateA4VouchersPdf(
        vouchers: vouchers,
        cardsPerRow: 2,
        cardsPerPage: 8,
        showQrCode: true,
      );

      expect(pdfBytes, isA<Uint8List>());
      expect(pdfBytes.length, greaterThan(1000));

      final thermalBytes = await PdfGeneratorHelper.generateThermalReceiptPdf(
        voucher: vouchers.first,
        is80mm: true,
      );
      expect(thermalBytes, isA<Uint8List>());
      expect(thermalBytes.length, greaterThan(500));
    });

    test('UmProfileModel stores and exposes uptimeLimit and transferLimit', () {
      const profile = UmProfileModel(
        id: '*P2',
        name: 'Limited_Profile',
        price: 500.0,
        validity: '1d',
        rateLimit: '2M/2M',
        uptimeLimit: '12h',
        transferLimit: '5GiB',
        isV7: true,
      );

      expect(profile.uptimeLimit, equals('12h'));
      expect(profile.transferLimit, equals('5GiB'));
      expect(profile.rateLimit, equals('2M/2M'));

      final json = profile.toJson();
      expect(json['uptime-limit'], equals('12h'));
      expect(json['transfer-limit'], equals('5GiB'));

      final fromJson = UmProfileModel.fromJson(json);
      expect(fromJson.uptimeLimit, equals('12h'));
      expect(fromJson.transferLimit, equals('5GiB'));
    });
  });
}
