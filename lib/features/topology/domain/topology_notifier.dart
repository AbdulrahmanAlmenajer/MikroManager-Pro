import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/session/session_controller.dart';
import '../../access_points/domain/ap_notifier.dart';
import '../../subscribers/data/subscribers_repository.dart';
import '../../subscribers/domain/subscribers_notifier.dart';
import '../data/topology_repository.dart';

final topologyRepositoryProvider = Provider<TopologyRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return TopologyRepository(db);
});

class TopologyState {
  final List<UserApMatchResult> matches;
  final Map<int, List<UserApMatchResult>> apUsersMap;
  final List<UserApMatchResult> unmatchedUsers;
  final List<ApDevicesTableData> aps;
  final bool isLoading;
  final String? errorMessage;

  const TopologyState({
    this.matches = const [],
    this.apUsersMap = const {},
    this.unmatchedUsers = const [],
    this.aps = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  TopologyState copyWith({
    List<UserApMatchResult>? matches,
    Map<int, List<UserApMatchResult>>? apUsersMap,
    List<UserApMatchResult>? unmatchedUsers,
    List<ApDevicesTableData>? aps,
    bool? isLoading,
    String? errorMessage,
  }) {
    return TopologyState(
      matches: matches ?? this.matches,
      apUsersMap: apUsersMap ?? this.apUsersMap,
      unmatchedUsers: unmatchedUsers ?? this.unmatchedUsers,
      aps: aps ?? this.aps,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class TopologyNotifier extends StateNotifier<TopologyState> {
  final Ref _ref;
  final TopologyRepository _repo;

  TopologyNotifier(this._ref, this._repo) : super(const TopologyState());

  Future<void> refreshTopology() async {
    final session = _ref.read(sessionControllerProvider).session;
    if (session == null) return;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final apRepo = _ref.read(apRepositoryProvider);
      final subscribersRepo = _ref.read(subscribersRepositoryProvider);

      // Fetch APs and subscribers
      final aps = await apRepo.getAllAps(session.connectionId);
      List<SubscriberModel> subscribers = [];
      try {
        subscribers = await subscribersRepo.getHotspotSubscribers(session.adapter);
      } catch (_) {}

      // Match subscribers to APs using Evidence Ladder
      final matches = await _repo.matchSubscribersToAps(
        connectionId: session.connectionId,
        subscribers: subscribers,
        aps: aps,
      );

      final Map<int, List<UserApMatchResult>> map = {};
      final List<UserApMatchResult> unmatched = [];

      for (final m in matches) {
        if (m.apId != null) {
          map.putIfAbsent(m.apId!, () => []).add(m);
        } else {
          unmatched.add(m);
        }
      }

      state = state.copyWith(
        matches: matches,
        apUsersMap: map,
        unmatchedUsers: unmatched,
        aps: aps,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'تعذر تحليل تفرع الشبكة: $e');
    }
  }

  Future<bool> saveCurrentSnapshot() async {
    final session = _ref.read(sessionControllerProvider).session;
    if (session == null) return false;

    final graphData = {
      'router': {
        'host': session.host,
        'boardName': session.boardName,
      },
      'aps': state.aps.map((a) => {'id': a.id, 'name': a.name, 'ip': a.ip, 'vendor': a.vendor}).toList(),
      'distribution': state.apUsersMap.map((key, val) => MapEntry(key.toString(), val.length)),
      'unmatchedCount': state.unmatchedUsers.length,
      'timestamp': DateTime.now().toIso8601String(),
    };

    try {
      await _repo.saveSnapshot(connectionId: session.connectionId, graphData: graphData);
      return true;
    } catch (_) {
      return false;
    }
  }
}

final topologyNotifierProvider =
    StateNotifierProvider<TopologyNotifier, TopologyState>((ref) {
  final repo = ref.watch(topologyRepositoryProvider);
  final notifier = TopologyNotifier(ref, repo);
  notifier.refreshTopology();
  return notifier;
});
