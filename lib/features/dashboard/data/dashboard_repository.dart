import '../../../core/network/routeros_adapter.dart';

class DashboardRepository {
  Future<Map<String, dynamic>> getSystemResource(RouterOsAdapter adapter) async {
    return await adapter.getSystemResource();
  }

  Future<List<Map<String, dynamic>>> getInterfaces(RouterOsAdapter adapter) async {
    return await adapter.getInterfaces();
  }

  Future<Map<String, int>> getTraffic(RouterOsAdapter adapter, String interfaceName) async {
    return await adapter.getInterfaceTraffic(interfaceName);
  }

  Future<int> getActiveUsersCount(RouterOsAdapter adapter) async {
    final active = await adapter.getHotspotActive();
    return active.length;
  }
}
