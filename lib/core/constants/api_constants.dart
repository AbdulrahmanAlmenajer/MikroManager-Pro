class ApiConstants {
  // RouterOS Binary API Ports
  static const int binaryApiPort = 8728;
  static const int binaryApiSslPort = 8729;

  // RouterOS REST API Ports
  static const int restApiPort = 80;
  static const int restApiSslPort = 443;

  // REST API Paths
  static const String hotspotUsersPath = '/rest/ip/hotspot/user';
  static const String hotspotActivePath = '/rest/ip/hotspot/active';
  static const String hotspotProfilesPath = '/rest/ip/hotspot/user/profile';
  static const String userManagerUsersPath = '/rest/user-manager/user';
  static const String userManagerProfilesPath = '/rest/user-manager/profile';
  static const String systemResourcePath = '/rest/system/resource';
  static const String interfacesPath = '/rest/interface';
  static const String interfaceStatsPath = '/rest/interface/monitor-traffic';

  // Connection Timeouts
  static const int connectTimeoutMs = 10000;
  static const int readTimeoutMs = 15000;
  static const int sendTimeoutMs = 10000;

  // Polling Intervals
  static const int trafficPollingSeconds = 3;
  static const int resourcePollingSeconds = 5;

  // SecureStorage Keys
  static const String routerPasswordPrefix = 'router_pass_';
  static const String selectedRouterKey = 'selected_router_id';
}
