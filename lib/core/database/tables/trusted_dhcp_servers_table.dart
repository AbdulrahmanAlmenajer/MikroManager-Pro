import 'package:drift/drift.dart';

class TrustedDhcpServersTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get connectionId => integer()();
  TextColumn get serverIp => text()();
  TextColumn get interface => text()();

  @override
  String get tableName => 'trusted_dhcp_servers';
}
