import '../network/routeros_adapter.dart';
import '../network/routeros_command_scheduler.dart';

enum UserRole {
  admin,
  engineer,
  reseller;

  String get displayNameArabic {
    switch (this) {
      case UserRole.admin:
        return 'مدير النظام (Admin)';
      case UserRole.engineer:
        return 'مهندس شبكة (Engineer)';
      case UserRole.reseller:
        return 'موزع كروت (Reseller)';
    }
  }

  bool get canAccessDashboard => this == UserRole.admin || this == UserRole.engineer;
  bool get canAccessHotspot => this == UserRole.admin || this == UserRole.engineer;
  bool get canAccessUserman => this == UserRole.admin || this == UserRole.engineer;
  bool get canAccessSettings => this == UserRole.admin || this == UserRole.engineer;
  bool get canAccessTelegram => this == UserRole.admin;
  bool get canGenerateVouchers => true;
  bool get canPrintVouchers => true;
  bool get canAccessReports => true;
}

class RouterSession {
  final int connectionId;
  final String host;
  final int port;
  final String username;
  final bool useSsl;
  final int majorVersion; // 6 or 7
  final String versionString;
  final String boardName;
  final String cpu;
  final String userGroup;
  final UserRole role;
  final RouterOsAdapter adapter;
  final DateTime loginTime;
  late final RouterOsCommandScheduler scheduler;

  RouterSession({
    required this.connectionId,
    required this.host,
    required this.port,
    required this.username,
    required this.useSsl,
    required this.majorVersion,
    required this.versionString,
    required this.boardName,
    required this.cpu,
    required this.userGroup,
    required this.role,
    required this.adapter,
    DateTime? loginTime,
  }) : loginTime = loginTime ?? DateTime.now() {
    scheduler = RouterOsCommandScheduler(
      adapter: adapter,
      connectionId: connectionId,
    );
  }

  bool get isV7 => majorVersion >= 7;

  void dispose() {
    scheduler.dispose();
  }
}

