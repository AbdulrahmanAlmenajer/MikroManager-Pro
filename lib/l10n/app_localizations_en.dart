// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'MikroManager Pro';

  @override
  String get appSubtitle => 'MikroTik Hotspot & Voucher Management';

  @override
  String get loginTitle => 'Login to Router';

  @override
  String get loginSubtitle =>
      'Enter your MikroTik connection details to access dashboard';

  @override
  String get hostOrIpLabel => 'IP Address or Hostname';

  @override
  String get hostOrIpHint => '192.168.88.1';

  @override
  String get portLabel => 'Port';

  @override
  String get portHint => '8728';

  @override
  String get usernameLabel => 'Username';

  @override
  String get usernameHint => 'admin';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordHint => 'Password (if set)';

  @override
  String get rememberMe => 'Remember this connection';

  @override
  String get useSsl => 'Use TLS/SSL (Port 8729)';

  @override
  String get acceptSelfSignedCert => 'Accept Self-Signed Certificate';

  @override
  String get certWarning =>
      'Warning: Accepting untrusted certificates might expose credentials to local interception.';

  @override
  String get savedConnections => 'Saved Connections';

  @override
  String get newConnection => 'New Connection';

  @override
  String get loginButton => 'Connect & Login';

  @override
  String get connecting => 'Connecting to MikroTik router...';

  @override
  String get testConnection => 'Test Port / Connection';

  @override
  String get tooManyAttempts =>
      'Too many failed attempts. Please wait 30 seconds.';

  @override
  String get logout => 'Logout';

  @override
  String get logoutConfirmTitle => 'Confirm Logout';

  @override
  String get logoutConfirmMessage =>
      'Are you sure you want to disconnect? You will be redirected to the login screen.';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get navHome => 'Home';

  @override
  String get navHotspot => 'Hotspot';

  @override
  String get navSubscribers => 'Subscribers';

  @override
  String get navVouchers => 'Vouchers';

  @override
  String get navReports => 'Reports';

  @override
  String get navSettings => 'Settings';

  @override
  String get navMore => 'More';

  @override
  String get safeExit => 'Safe Exit';

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get cpuUsage => 'CPU Usage';

  @override
  String get freeMemory => 'Free Memory';

  @override
  String get totalMemory => 'Total Memory';

  @override
  String get uptime => 'Uptime';

  @override
  String get activeUsers => 'Active Users';

  @override
  String get trafficMonitor => 'Live Traffic Monitor';

  @override
  String get selectInterface => 'Select Interface';

  @override
  String get rxRate => 'Download (Rx)';

  @override
  String get txRate => 'Upload (Tx)';

  @override
  String get hotspotTitle => 'Hotspot Management';

  @override
  String get tabUsers => 'Users';

  @override
  String get tabActive => 'Active Sessions';

  @override
  String get tabProfiles => 'Profiles';

  @override
  String get tabBindings => 'IP Bindings';

  @override
  String get addUser => 'Add User';

  @override
  String get kickUser => 'Kick User';

  @override
  String get deleteUser => 'Delete User';

  @override
  String get kickConfirm => 'Are you sure you want to kick this active user?';

  @override
  String get deleteConfirm =>
      'Are you sure you want to delete this record permanently?';

  @override
  String get searchHint => 'Search...';

  @override
  String get usermanTitle => 'User Manager';

  @override
  String get usermanProfiles => 'Profiles';

  @override
  String get usermanSessions => 'Active Sessions';

  @override
  String get voucherTitle => 'Voucher Generator';

  @override
  String get voucherCount => 'Vouchers Count';

  @override
  String get voucherPrefix => 'Code Prefix';

  @override
  String get voucherLength => 'User Code Length';

  @override
  String get charsetType => 'Character Set';

  @override
  String get charsetNumbers => 'Numbers Only (1-9)';

  @override
  String get charsetAlpha => 'Letters Only (No ambiguous)';

  @override
  String get charsetMixed => 'Alphanumeric';

  @override
  String get generateAndPreview => 'Generate & Preview';

  @override
  String get generatingVouchers => 'Creating vouchers on router...';

  @override
  String batchProgress(Object current, Object total) {
    return 'Generated $current of $total vouchers';
  }

  @override
  String get printPreviewTitle => 'Print Preview & Options';

  @override
  String get paperSizeA4 => 'A4 Grid (3 Columns)';

  @override
  String get paperSize58 => 'Thermal 58mm';

  @override
  String get paperSize80 => 'Thermal 80mm';

  @override
  String get printDirect => 'Print Directly';

  @override
  String get exportPdf => 'Export PDF';

  @override
  String get bluetoothPrinters => 'Bluetooth Printers';

  @override
  String get reportsTitle => 'Sales Reports & Analytics';

  @override
  String get dailySales => 'Daily Sales';

  @override
  String get monthlySales => 'Monthly Sales';

  @override
  String get exportCsv => 'Export CSV';

  @override
  String get totalRevenue => 'Total Revenue';

  @override
  String get totalCardsSold => 'Total Cards Sold';

  @override
  String get telegramTitle => 'Telegram Bot Settings';

  @override
  String get botToken => 'Bot Token';

  @override
  String get chatId => 'Chat ID';

  @override
  String get sendTestAlert => 'Send Test Message';

  @override
  String get alertRouterState => 'Alert when router goes down or comes up';

  @override
  String get alertHighCpu => 'Alert when CPU usage exceeds 90%';

  @override
  String get alertVoucherThreshold => 'Alert when vouchers run low';

  @override
  String get settingsTitle => 'General Settings';

  @override
  String get roleAdmin => 'Administrator';

  @override
  String get roleEngineer => 'Network Engineer';

  @override
  String get roleReseller => 'Voucher Reseller';

  @override
  String get currentRole => 'Current Account Role';

  @override
  String get auditLogs => 'Audit Logs';

  @override
  String get errorTimeout =>
      'Could not reach router (Connection timeout). Check IP and network.';

  @override
  String get errorPortClosed =>
      'Port closed or API service disabled on router. Enable it with: /ip service enable api';

  @override
  String get errorAuthFailed => 'Invalid username or password.';

  @override
  String get errorTlsFailed =>
      'TLS/SSL security verification failed. You may enable self-signed certificate acceptance.';

  @override
  String get errorMissingPolicy =>
      'Current user lacks API policy permissions on MikroTik router.';

  @override
  String errorGeneral(Object message) {
    return 'An unexpected error occurred: $message';
  }

  @override
  String get retry => 'Retry';

  @override
  String get emptyData => 'No data available';

  @override
  String get systemHotspot => 'Hotspot';

  @override
  String get systemUserManager => 'User Manager';

  @override
  String get previewDraft => 'Preview Draft';

  @override
  String get commitVouchers => 'Commit & Upload Cards to Router';

  @override
  String get cancelAndEdit => 'Cancel & Edit';

  @override
  String get discardDraftTitle => 'Discard Draft?';

  @override
  String get discardDraftMsg =>
      'Are you sure you want to discard this draft? Cards will not be saved on the router.';

  @override
  String get templateEditorTitle => 'Advanced Template Editor';

  @override
  String get serialNumber => 'Serial Number';

  @override
  String get serialPrefix => 'Serial Prefix';

  @override
  String get serialStart => 'Start Serial';

  @override
  String get serialPadding => 'Padding Digits';

  @override
  String get collisionDetected => 'Username collision detected on the router';

  @override
  String get commitSuccess =>
      'Vouchers committed and uploaded to router successfully!';

  @override
  String get umDiagnostics => 'User Manager Diagnostics';
}
