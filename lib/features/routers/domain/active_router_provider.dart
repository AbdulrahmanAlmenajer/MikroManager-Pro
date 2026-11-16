import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/routeros_adapter.dart';
import '../../../core/security/secure_storage_service.dart';
import 'routers_notifier.dart';

final activeAdapterProvider = FutureProvider<RouterOsAdapter?>((ref) async {
  final routerState = ref.watch(routersControllerProvider);
  final router = routerState.activeRouter;
  if (router == null) return null;

  final password = await SecureStorageService.getRouterPassword(router.id) ?? '';

  final adapter = RouterOsAdapter.create(
    host: router.ipAddress,
    port: router.apiPort,
    username: router.username,
    password: password,
    useSsl: router.useSsl,
    useRest: router.useRestApi,
  );

  return adapter;
});

final activeConnectionProvider = FutureProvider<bool>((ref) async {
  final adapter = await ref.watch(activeAdapterProvider.future);
  if (adapter == null) return false;
  return await adapter.connect();
});
