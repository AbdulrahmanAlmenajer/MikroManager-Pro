import 'dart:io';
import '../session/router_session.dart';

enum PlatformType {
  android,
  ios,
  windows,
  linux,
  macos,
  other,
}

enum BluetoothThermalSupport {
  full,       // Classic Bluetooth & BLE (Android)
  bleOnly,    // BLE only, PDF/Network recommended (iOS)
  unsupported,// Network printer / PDF recommended (Windows)
}

enum WebviewSupport {
  embedded,   // webview_flutter (Android, iOS)
  external,   // url_launcher / external browser (Windows)
}

enum BackgroundAlertsSupport {
  workmanager, // Android background worker
  limited,     // iOS (battery/system restricted)
  inAppOnly,   // Windows (while app is running)
}

class PlatformCapabilities {
  static PlatformType get currentPlatform {
    if (Platform.isAndroid) return PlatformType.android;
    if (Platform.isIOS) return PlatformType.ios;
    if (Platform.isWindows) return PlatformType.windows;
    if (Platform.isLinux) return PlatformType.linux;
    if (Platform.isMacOS) return PlatformType.macos;
    return PlatformType.other;
  }

  static BluetoothThermalSupport get bluetoothThermalSupport {
    switch (currentPlatform) {
      case PlatformType.android:
        return BluetoothThermalSupport.full;
      case PlatformType.ios:
        return BluetoothThermalSupport.bleOnly;
      case PlatformType.windows:
      default:
        return BluetoothThermalSupport.unsupported;
    }
  }

  static WebviewSupport get webviewSupport {
    switch (currentPlatform) {
      case PlatformType.android:
      case PlatformType.ios:
        return WebviewSupport.embedded;
      case PlatformType.windows:
      default:
        return WebviewSupport.external;
    }
  }

  static BackgroundAlertsSupport get backgroundAlertsSupport {
    switch (currentPlatform) {
      case PlatformType.android:
        return BackgroundAlertsSupport.workmanager;
      case PlatformType.ios:
        return BackgroundAlertsSupport.limited;
      case PlatformType.windows:
      default:
        return BackgroundAlertsSupport.inAppOnly;
    }
  }

  static bool get supportsSftpBackup => true; // dartssh2 works across all platforms

  /// Inspects RouterOS session capabilities
  static RouterCapabilities inspectRouter(RouterSession? session) {
    if (session == null) {
      return const RouterCapabilities(
        isRouterOs7: false,
        userRole: UserRole.reseller,
        canManageSystem: false,
        canManageHotspot: false,
        canManageUserMan: false,
        supportsWireGuard: false,
        supportsDhcpAlert: false,
      );
    }

    final isV7 = session.majorVersion >= 7;
    final role = session.role;
    final isAdmin = role == UserRole.admin;
    final isEngineer = role == UserRole.engineer || isAdmin;

    return RouterCapabilities(
      isRouterOs7: isV7,
      userRole: role,
      canManageSystem: isAdmin,
      canManageHotspot: isEngineer || role == UserRole.reseller,
      canManageUserMan: isEngineer,
      supportsWireGuard: isV7,
      supportsDhcpAlert: isEngineer,
    );
  }
}

class RouterCapabilities {
  final bool isRouterOs7;
  final UserRole userRole;
  final bool canManageSystem;
  final bool canManageHotspot;
  final bool canManageUserMan;
  final bool supportsWireGuard;
  final bool supportsDhcpAlert;

  const RouterCapabilities({
    required this.isRouterOs7,
    required this.userRole,
    required this.canManageSystem,
    required this.canManageHotspot,
    required this.canManageUserMan,
    required this.supportsWireGuard,
    required this.supportsDhcpAlert,
  });

  String getUserManagerPath() {
    return isRouterOs7 ? '/user-manager' : '/tool/user-manager';
  }
}
