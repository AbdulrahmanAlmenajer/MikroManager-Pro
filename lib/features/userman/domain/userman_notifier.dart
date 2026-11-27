import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
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

enum UmDiagnosticStatus {
  ok,
  packageNotInstalled,
  noPermission,
  emptyProfiles,
  connectionError,
}

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
  final UmDiagnosticStatus diagnosticStatus;
  final String? diagnosticDetails;
  final bool isFromCache;

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
    this.diagnosticStatus = UmDiagnosticStatus.ok,
    this.diagnosticDetails,
    this.isFromCache = false,
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
    UmDiagnosticStatus? diagnosticStatus,
    String? diagnosticDetails,
    bool? isFromCache,
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
      diagnosticStatus: diagnosticStatus ?? this.diagnosticStatus,
      diagnosticDetails: diagnosticDetails ?? this.diagnosticDetails,
      isFromCache: isFromCache ?? this.isFromCache,
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

  Future<void> refreshFromRouter() async {
    await refreshAll();
  }

  Future<void> refreshAll() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final activeRouter = _ref.read(routersControllerProvider).activeRouter;
    final connId = activeRouter?.id ?? 1;

    try {
      final adapter = await _ref.read(activeAdapterProvider.future);
      if (adapter == null) {
        final cached = await _loadCachedProfiles(connId);
        state = state.copyWith(
          parsedProfiles: cached,
          isLoading: false,
          diagnosticStatus: UmDiagnosticStatus.connectionError,
          diagnosticDetails: 'لا يوجد اتصال بالراوتر حالياً (تم عرض البروفايلات المحفوظة)',
          isFromCache: cached.isNotEmpty,
          errorMessage: cached.isEmpty ? 'لا يوجد راوتر محدد حالياً' : null,
        );
        return;
      }

      // Fetch local prices if available
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

      // Save profiles into cache
      if (parsedProfiles.isNotEmpty) {
        await _cacheProfiles(connId, parsedProfiles);
      }

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
          systemType: adapter.isV7
              ? CardSystemType.usermanV7
              : CardSystemType.usermanV6,
          source: 'router',
          status: status,
          uptime: uptime,
          bytesIn: bIn,
          bytesOut: bOut,
          comment: u['comment']?.toString(),
        );
      }).toList();

      UmDiagnosticStatus diagnosticStatus = UmDiagnosticStatus.ok;
      String? diagnosticDetails;
      if (parsedProfiles.isEmpty) {
        diagnosticStatus = UmDiagnosticStatus.emptyProfiles;
        diagnosticDetails =
            'لا توجد بروفايلات منشأة حالياً في User Manager على هذا الراوتر';
      }

      state = state.copyWith(
        users: users,
        profiles: profiles,
        sessions: sessions,
        parsedProfiles: parsedProfiles,
        parsedUsers: parsedCards,
        isLoading: false,
        diagnosticStatus: diagnosticStatus,
        diagnosticDetails: diagnosticDetails,
        isFromCache: false,
      );
    } catch (e) {
      final cached = await _loadCachedProfiles(connId);
      final errorStr = e.toString().toLowerCase();

      UmDiagnosticStatus diag = UmDiagnosticStatus.connectionError;
      String diagMsg = 'فشل الاتصال بخدمة User Manager: $e';

      if (errorStr.contains('no such command') ||
          errorStr.contains('not found') ||
          errorStr.contains('package')) {
        diag = UmDiagnosticStatus.packageNotInstalled;
        diagMsg = 'حزمة User Manager غير مثبتة أو غير مفعلة على الراوتر';
      } else if (errorStr.contains('permission') || errorStr.contains('denied')) {
        diag = UmDiagnosticStatus.noPermission;
        diagMsg = 'صلاحيات غير كافية لحساب الميكروتك للوصول لبيانات User Manager';
      }

      state = state.copyWith(
        parsedProfiles: cached.isNotEmpty ? cached : state.parsedProfiles,
        isLoading: false,
        diagnosticStatus: diag,
        diagnosticDetails: diagMsg,
        errorMessage: e.toString(),
        isFromCache: cached.isNotEmpty,
      );
    }
  }

  Future<void> _cacheProfiles(
      int connectionId, List<UmProfileModel> profiles) async {
    try {
      final db = _ref.read(databaseProvider);
      await (db.delete(db.umProfilesCacheTable)
            ..where((t) => t.connectionId.equals(connectionId)))
          .go();
      if (profiles.isNotEmpty) {
        await db.batch((batch) {
          batch.insertAll(
            db.umProfilesCacheTable,
            profiles.map(
              (p) => UmProfilesCacheTableCompanion.insert(
                connectionId: connectionId,
                profileName: p.name,
                owner: Value(p.owner ?? 'admin'),
                validity: Value(p.validity ?? ''),
                price: Value(p.price.toString()),
                rawJson: Value(jsonEncode(p.toJson())),
              ),
            ),
          );
        });
      }
    } catch (_) {}
  }

  Future<List<UmProfileModel>> _loadCachedProfiles(int connectionId) async {
    try {
      final db = _ref.read(databaseProvider);
      final rows = await (db.select(db.umProfilesCacheTable)
            ..where((t) => t.connectionId.equals(connectionId)))
          .get();
      return rows.map((r) {
        try {
          final decoded = jsonDecode(r.rawJson) as Map<String, dynamic>;
          return UmProfileModel.fromJson(decoded);
        } catch (_) {
          return UmProfileModel(
            id: r.id.toString(),
            name: r.profileName,
            owner: r.owner,
            validity: r.validity,
            price: double.tryParse(r.price) ?? 0.0,
          );
        }
      }).toList();
    } catch (_) {
      return [];
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
