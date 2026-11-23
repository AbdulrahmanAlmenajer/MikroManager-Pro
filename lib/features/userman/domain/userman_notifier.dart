import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../hotspot/domain/hotspot_notifier.dart';
import '../../reports/domain/reports_notifier.dart';
import '../../routers/domain/active_router_provider.dart';
import '../../routers/domain/routers_notifier.dart';
import '../../vouchers/domain/unified_card_model.dart';
import '../data/userman_repository.dart';
import 'um_profile_model.dart';

final usermanRepositoryProvider = Provider<UsermanRepository>((ref) {
  final logger = ref.watch(auditLoggerProvider);
  return UsermanRepository(logger);
});

class UsermanState {
  final List<Map<String, dynamic>> users;
  final List<Map<String, dynamic>> profiles;
  final List<Map<String, dynamic>> sessions;
  final List<UmProfileModel> parsedProfiles;
  final List<UnifiedCardModel> parsedUsers;
  final bool isLoading;
  final String? errorMessage;
  final String searchQuery;
  final String? selectedProfileFilter;
  final String? statusFilter; // 'all', 'active', 'unused', 'disabled'

  UsermanState({
    this.users = const [],
    this.profiles = const [],
    this.sessions = const [],
    this.parsedProfiles = const [],
    this.parsedUsers = const [],
    this.isLoading = false,
    this.errorMessage,
    this.searchQuery = '',
    this.selectedProfileFilter,
    this.statusFilter,
  });

  List<UmProfileModel> get filteredProfiles {
    if (searchQuery.isEmpty) return parsedProfiles;
    final q = searchQuery.toLowerCase();
    return parsedProfiles.where((p) {
      return p.name.toLowerCase().contains(q) ||
          (p.nameForUsers != null && p.nameForUsers!.toLowerCase().contains(q));
    }).toList();
  }

  List<UnifiedCardModel> get filteredUsers {
    var list = parsedUsers;
    if (selectedProfileFilter != null && selectedProfileFilter!.isNotEmpty) {
      list = list.where((u) => u.profile == selectedProfileFilter).toList();
    }
    if (statusFilter != null && statusFilter != 'all') {
      if (statusFilter == 'active') {
        list = list
            .where((u) => u.status == CardStatus.active || u.isUsed)
            .toList();
      } else if (statusFilter == 'unused') {
        list = list
            .where((u) => !u.isUsed && u.status != CardStatus.disabled)
            .toList();
      } else if (statusFilter == 'disabled') {
        list = list.where((u) => u.status == CardStatus.disabled).toList();
      }
    }
    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      list = list.where((u) {
        return u.username.toLowerCase().contains(q) ||
            (u.comment != null && u.comment!.toLowerCase().contains(q)) ||
            u.profile.toLowerCase().contains(q);
      }).toList();
    }
    return list;
  }

  UsermanState copyWith({
    List<Map<String, dynamic>>? users,
    List<Map<String, dynamic>>? profiles,
    List<Map<String, dynamic>>? sessions,
    List<UmProfileModel>? parsedProfiles,
    List<UnifiedCardModel>? parsedUsers,
    bool? isLoading,
    String? errorMessage,
    String? searchQuery,
    String? selectedProfileFilter,
    String? statusFilter,
  }) {
    return UsermanState(
      users: users ?? this.users,
      profiles: profiles ?? this.profiles,
      sessions: sessions ?? this.sessions,
      parsedProfiles: parsedProfiles ?? this.parsedProfiles,
      parsedUsers: parsedUsers ?? this.parsedUsers,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedProfileFilter:
          selectedProfileFilter ?? this.selectedProfileFilter,
      statusFilter: statusFilter ?? this.statusFilter,
    );
  }
}

class UsermanNotifier extends StateNotifier<UsermanState> {
  final Ref _ref;
  final UsermanRepository _repo;

  UsermanNotifier(this._ref, this._repo) : super(UsermanState()) {
    refreshAll();
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query.trim());
  }

  void setProfileFilter(String? profile) {
    state = state.copyWith(selectedProfileFilter: profile);
  }

  void setStatusFilter(String? status) {
    state = state.copyWith(statusFilter: status);
  }

  Future<void> refreshAll() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final adapter = await _ref.read(activeAdapterProvider.future);
      if (adapter == null) {
        state = state.copyWith(
            isLoading: false, errorMessage: 'لا يوجد راوتر محدد حالياً');
        return;
      }

      // Fetch local prices if available
      final activeRouter = _ref.read(routersControllerProvider).activeRouter;
      final connId = activeRouter?.id ?? 1;
      final reportsRepo = _ref.read(reportsRepositoryProvider);
      final localPrices = await reportsRepo.getProfilePrices(connId);

      final users = await _repo.getUsers(adapter);
      final profiles = await _repo.getProfiles(adapter);
      final sessions = await _repo.getSessions(adapter);

      // Map active sessions
      final Set<String> activeUsernames = {};
      for (final s in sessions) {
        final u = s['user']?.toString() ?? '';
        final activeVal = s['active']?.toString();
        if (u.isNotEmpty && activeVal != 'false' && activeVal != 'no') {
          activeUsernames.add(u);
        }
      }

      // Parse rich profiles
      final parsedProfiles = await _repo.getParsedProfiles(
        adapter,
        localPrices: localPrices,
      );

      // Parse unified cards
      final parsedCards = users.map((u) {
        final name = u['username']?.toString() ?? u['name']?.toString() ?? '';
        final prof = u['actual-profile']?.toString() ??
            u['profile']?.toString() ??
            u['group']?.toString() ??
            'default';
        final price = localPrices[prof] ?? 0.0;
        final isDisabled = u['disabled']?.toString() == 'true' ||
            u['disabled']?.toString() == 'yes';
        final isActive = activeUsernames.contains(name);
        final uptime = u['uptime-used']?.toString() ?? u['uptime']?.toString();
        final bIn = int.tryParse(u['download-used']?.toString() ??
                u['bytes-in']?.toString() ??
                '0') ??
            0;
        final bOut = int.tryParse(u['upload-used']?.toString() ??
                u['bytes-out']?.toString() ??
                '0') ??
            0;

        CardStatus status = CardStatus.newCard;
        if (isDisabled) {
          status = CardStatus.disabled;
        } else if (isActive) {
          status = CardStatus.active;
        } else if ((uptime != null && uptime.isNotEmpty && uptime != '0s') ||
            (bIn + bOut > 0)) {
          status = CardStatus.active;
        }

        return UnifiedCardModel(
          id: u['.id']?.toString() ?? name,
          username: name,
          password: u['password']?.toString() ?? '',
          profile: prof,
          price: price,
          cardType: CardType.userMan,
          source: 'router',
          status: status,
          uptime: uptime,
          bytesIn: bIn,
          bytesOut: bOut,
          comment: u['comment']?.toString(),
        );
      }).toList();

      state = state.copyWith(
        users: users,
        profiles: profiles,
        sessions: sessions,
        parsedProfiles: parsedProfiles,
        parsedUsers: parsedCards,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Update local price for a profile
  Future<void> updateProfilePrice(String profileName, double price) async {
    try {
      final activeRouter = _ref.read(routersControllerProvider).activeRouter;
      final connId = activeRouter?.id ?? 1;
      final reportsRepo = _ref.read(reportsRepositoryProvider);
      await reportsRepo.setProfilePrice(
        connectionId: connId,
        profileName: profileName,
        price: price,
      );
      // Re-map parsed profiles with new price
      final updated = state.parsedProfiles.map((p) {
        if (p.name == profileName) {
          return p.copyWith(price: price);
        }
        return p;
      }).toList();
      state = state.copyWith(parsedProfiles: updated);
    } catch (e) {
      state = state.copyWith(errorMessage: 'تعذر حفظ سعر البروفايل: $e');
    }
  }

  Future<bool> addUser({
    required String username,
    required String password,
    String? profile,
    String? customer,
    String? comment,
  }) async {
    try {
      final adapter = await _ref.read(activeAdapterProvider.future);
      if (adapter == null) return false;

      final success = await _repo.addUser(
        adapter: adapter,
        username: username,
        password: password,
        profile: profile,
        customer: customer,
        comment: comment,
      );

      if (success) {
        await refreshAll();
      }
      return success;
    } on Exception catch (e) {
      state = state.copyWith(
          isLoading: false,
          errorMessage: 'فشل إضافة المستخدم: ${e.toString()}');
      return false;
    }
  }

  Future<bool> removeUser(String id, String username) async {
    try {
      final adapter = await _ref.read(activeAdapterProvider.future);
      if (adapter == null) return false;

      final success =
          await _repo.removeUser(adapter: adapter, id: id, username: username);
      if (success) {
        await refreshAll();
      }
      return success;
    } on Exception catch (e) {
      state = state.copyWith(
          isLoading: false, errorMessage: 'فشل حذف المستخدم: ${e.toString()}');
      return false;
    }
  }

  Future<bool> kickSession(String id, String username) async {
    try {
      final adapter = await _ref.read(activeAdapterProvider.future);
      if (adapter == null) return false;

      final success =
          await _repo.kickSession(adapter: adapter, id: id, username: username);
      if (success) {
        await refreshAll();
      }
      return success;
    } on Exception catch (e) {
      state = state.copyWith(
          isLoading: false, errorMessage: 'فشل إنهاء الجلسة: ${e.toString()}');
      return false;
    }
  }
}

final usermanControllerProvider =
    StateNotifierProvider<UsermanNotifier, UsermanState>((ref) {
  final repo = ref.watch(usermanRepositoryProvider);
  return UsermanNotifier(ref, repo);
});
