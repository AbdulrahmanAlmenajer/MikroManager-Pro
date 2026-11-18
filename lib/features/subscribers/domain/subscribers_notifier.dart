import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/session/session_controller.dart';
import '../../../core/utils/audit_logger.dart';
import '../data/subscribers_repository.dart';

final subscribersRepositoryProvider = Provider<SubscribersRepository>((ref) {
  final auditLogger = ref.watch(auditLoggerProvider);
  return SubscribersRepository(auditLogger);
});

class SubscribersState {
  final SubscriberType selectedTab;
  final List<SubscriberModel> subscribers;
  final String searchQuery;
  final String statusFilter; // 'all', 'active', 'disabled', 'expired'
  final bool isLoading;
  final String? errorMessage;

  const SubscribersState({
    this.selectedTab = SubscriberType.hotspot,
    this.subscribers = const [],
    this.searchQuery = '',
    this.statusFilter = 'all',
    this.isLoading = false,
    this.errorMessage,
  });

  List<SubscriberModel> get filteredList {
    var list = subscribers;

    // Filter by status
    if (statusFilter == 'active') {
      list = list.where((s) => s.isActive).toList();
    } else if (statusFilter == 'disabled') {
      list = list.where((s) => s.isDisabled).toList();
    } else if (statusFilter == 'expired') {
      list = list.where((s) => s.isExpired).toList();
    }

    // Filter by search query
    if (searchQuery.trim().isNotEmpty) {
      final q = searchQuery.trim().toLowerCase();
      list = list.where((s) {
        return s.username.toLowerCase().contains(q) ||
            s.profile.toLowerCase().contains(q) ||
            (s.ipAddress?.toLowerCase().contains(q) ?? false) ||
            (s.macAddress?.toLowerCase().contains(q) ?? false);
      }).toList();
    }

    return list;
  }

  SubscribersState copyWith({
    SubscriberType? selectedTab,
    List<SubscriberModel>? subscribers,
    String? searchQuery,
    String? statusFilter,
    bool? isLoading,
    String? errorMessage,
  }) {
    return SubscribersState(
      selectedTab: selectedTab ?? this.selectedTab,
      subscribers: subscribers ?? this.subscribers,
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: statusFilter ?? this.statusFilter,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class SubscribersNotifier extends StateNotifier<SubscribersState> {
  final Ref _ref;
  final SubscribersRepository _repo;

  SubscribersNotifier(this._ref, this._repo) : super(const SubscribersState()) {
    loadSubscribers();
  }

  Future<void> loadSubscribers() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final session = _ref.read(sessionControllerProvider).session;
      if (session == null) {
        state = state.copyWith(
            isLoading: false, errorMessage: 'لا توجد جلسة راوتر نشطة');
        return;
      }

      List<SubscriberModel> items = [];
      switch (state.selectedTab) {
        case SubscriberType.hotspot:
          items = await _repo.getHotspotSubscribers(session.adapter);
          break;
        case SubscriberType.userMan:
          items = await _repo.getUserManSubscribers(session.adapter);
          break;
        case SubscriberType.pppoe:
          items = await _repo.getPppoeSubscribers(session.adapter);
          break;
      }

      state = state.copyWith(
        subscribers: items,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'فشل تحميل بيانات المشتركين: ${e.toString()}',
      );
    }
  }

  void switchTab(SubscriberType tab) {
    if (state.selectedTab == tab) return;
    state = state.copyWith(selectedTab: tab, subscribers: [], searchQuery: '');
    loadSubscribers();
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setStatusFilter(String filter) {
    state = state.copyWith(statusFilter: filter);
  }

  Future<bool> kickSubscriber(SubscriberModel sub) async {
    final session = _ref.read(sessionControllerProvider).session;
    if (session == null) return false;

    bool success = false;
    if (sub.type == SubscriberType.hotspot) {
      success = await _repo.kickHotspotActive(session.adapter, sub.username);
    } else if (sub.type == SubscriberType.pppoe) {
      success = await _repo.kickPppoeActive(session.adapter, sub.username);
    } else if (sub.type == SubscriberType.userMan) {
      success = await _repo.kickHotspotActive(session.adapter, sub.username);
    }

    if (success) {
      await loadSubscribers();
    }
    return success;
  }

  Future<bool> toggleSubscriberStatus(SubscriberModel sub, bool enable) async {
    final session = _ref.read(sessionControllerProvider).session;
    if (session == null) return false;

    final success =
        await _repo.toggleSubscriberStatus(session.adapter, sub, enable);
    if (success) {
      await loadSubscribers();
    }
    return success;
  }

  Future<bool> resetMacBinding(SubscriberModel sub) async {
    final session = _ref.read(sessionControllerProvider).session;
    if (session == null) return false;

    final success = await _repo.resetMacBinding(session.adapter, sub.username);
    if (success) {
      await loadSubscribers();
    }
    return success;
  }
}

final subscribersProvider =
    StateNotifierProvider.autoDispose<SubscribersNotifier, SubscribersState>(
        (ref) {
  final repo = ref.watch(subscribersRepositoryProvider);
  return SubscribersNotifier(ref, repo);
});
