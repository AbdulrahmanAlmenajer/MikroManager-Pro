import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/routeros_adapter.dart';
import '../../../core/session/session_controller.dart';
import '../../../core/security/secure_storage_service.dart';
import 'routers_notifier.dart';

final activeAdapterProvider = FutureProvider<RouterOsAdapter?>((ref) async {
  final sessionState = ref.watch(sessionControllerProvider);
  if (sessionState.session != null &&
      sessionState.session!.adapter.isConnected) {
    return sessionState.session!.adapter;
  }

  final routerState = ref.watch(routersControllerProvider);
  final router = routerState.activeRouter;
  if (router == null || !routerState.isConnected) return null;

  final password =
      await SecureStorageService.getRouterPassword(router.id) ?? '';

  final adapter = RouterOsAdapter.create(
    host: router.ipAddress,
    port: router.apiPort,
    username: router.username,
    password: password,
    useSsl: router.useSsl,
    useRest: router.useRestApi,
  );

  final connected = await adapter.connect();
  if (!connected) return null;

  ref.onDispose(() {
    adapter.disconnect();
  });

  return adapter;
});

final activeConnectionProvider = FutureProvider<bool>((ref) async {
  final adapter = await ref.watch(activeAdapterProvider.future);
  return adapter != null && adapter.isConnected;
});
