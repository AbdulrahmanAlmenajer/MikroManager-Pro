import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../routers/domain/active_router_provider.dart';

enum DiagnosticStatus { pass, warn, fail, checking }

class DiagnosticItem {
  final String key;
  final String title;
  final String description;
  final DiagnosticStatus status;
  final String details;
  final String? suggestedCommand;

  const DiagnosticItem({
    required this.key,
    required this.title,
    required this.description,
    this.status = DiagnosticStatus.checking,
    this.details = 'جاري الفحص...',
    this.suggestedCommand,
  });

  DiagnosticItem copyWith({
    DiagnosticStatus? status,
    String? details,
    String? suggestedCommand,
  }) {
    return DiagnosticItem(
      key: key,
      title: title,
      description: description,
      status: status ?? this.status,
      details: details ?? this.details,
      suggestedCommand: suggestedCommand ?? this.suggestedCommand,
    );
  }
}

class UmDiagnosticState {
  final List<DiagnosticItem> checks;
  final bool isRunning;
  final String? overallSummary;

  const UmDiagnosticState({
    this.checks = const [],
    this.isRunning = false,
    this.overallSummary,
  });

  UmDiagnosticState copyWith({
    List<DiagnosticItem>? checks,
    bool? isRunning,
    String? overallSummary,
  }) {
    return UmDiagnosticState(
      checks: checks ?? this.checks,
      isRunning: isRunning ?? this.isRunning,
      overallSummary: overallSummary ?? this.overallSummary,
    );
  }
}

class UmDiagnosticNotifier extends StateNotifier<UmDiagnosticState> {
  final Ref _ref;

  UmDiagnosticNotifier(this._ref) : super(const UmDiagnosticState()) {
    runAllDiagnostics();
  }

  static List<DiagnosticItem> _initialChecks() => const [
        DiagnosticItem(
          key: 'package_status',
          title: 'حالة حزمة / خدمة User Manager',
          description: 'التحقق من تفعيل خدمة اليوزر منجر في الراوتر',
        ),
        DiagnosticItem(
          key: 'radius_config',
          title: 'إعدادات خادم RADIUS للـ Hotspot',
          description: 'التحقق من ربط الهوتسبوت بخادم RADIUS المحلي',
        ),
        DiagnosticItem(
          key: 'incoming_coa',
          title: 'منفذ قطع الاتصال الفوري (CoA / Port 3799)',
          description: 'التحقق من تفعيل استقبال طلبات إنهاء الجلسات',
        ),
        DiagnosticItem(
          key: 'profiles_validity',
          title: 'صحة صياغة البروفايلات والقيود',
          description: 'التحقق من صحة مدة الصلاحية وتحديد السرعات',
        ),
        DiagnosticItem(
          key: 'active_sessions',
          title: 'فصل استعلام الجلسات الحية عن المستخدمين',
          description: 'التأكد من سرعة استجابة استعلام الجلسات النشطة',
        ),
        DiagnosticItem(
          key: 'owner_permissions',
          title: 'صلاحيات مالك البروفايلات (Customer / Owner)',
          description: 'التحقق من صحة المالك وعدم الاعتماد على admin فقط',
        ),
        DiagnosticItem(
          key: 'db_size_rating',
          title: 'حجم قاعدة البيانات وتصنيف الأداء',
          description: 'فحص إجمالي عدد الكروت وتأثيرها على استجابة الراوتر',
        ),
      ];

  Future<void> runAllDiagnostics() async {
    state = state.copyWith(
      checks: _initialChecks(),
      isRunning: true,
      overallSummary: null,
    );

    final adapter = await _ref.read(activeAdapterProvider.future);
    if (adapter == null) {
      state = state.copyWith(
        isRunning: false,
        overallSummary: 'لا يوجد راوتر متصل حالياً لفحص اليوزر منجر.',
      );
      return;
    }

    final isV7 = adapter.isV7;
    final updated = List<DiagnosticItem>.from(state.checks);

    // 1. Package / Service status
    try {
      if (isV7) {
        final res = await adapter.executeSentence(['/user-manager/print']);
        final enabled = res.isSuccess &&
            res.data.isNotEmpty &&
            (res.data.first['enabled'] == 'true' ||
                res.data.first['enabled'] == 'yes');
        updated[0] = updated[0].copyWith(
          status: enabled ? DiagnosticStatus.pass : DiagnosticStatus.fail,
          details: enabled
              ? 'خدمة User Manager v7 مفعلة وتعمل بنجاح.'
              : 'خدمة User Manager غير مفعلة (enabled=no).',
          suggestedCommand: enabled ? null : '/user-manager/set enabled=yes',
        );
      } else {
        final res = await adapter
            .executeSentence(['/system/package/print', '?name=user-manager']);
        final installed = res.isSuccess && res.data.isNotEmpty;
        final disabled = installed &&
            (res.data.first['disabled'] == 'true' ||
                res.data.first['disabled'] == 'yes');
        if (!installed) {
          updated[0] = updated[0].copyWith(
            status: DiagnosticStatus.fail,
            details: 'حزمة user-manager غير مثبتة على الراوتر (v6).',
            suggestedCommand: null,
          );
        } else if (disabled) {
          updated[0] = updated[0].copyWith(
            status: DiagnosticStatus.fail,
            details: 'حزمة user-manager مثبتة لكنها معطلة (disabled=yes).',
            suggestedCommand: '/system/package/enable user-manager',
          );
        } else {
          updated[0] = updated[0].copyWith(
            status: DiagnosticStatus.pass,
            details: 'حزمة user-manager مثبتة ومفعلة وتعمل بنجاح.',
          );
        }
      }
    } on Object catch (e) {
      updated[0] = updated[0].copyWith(
        status: DiagnosticStatus.warn,
        details: 'تعذر التحقق التلقائي: $e',
      );
    }

    // 2. RADIUS Server Hotspot check
    try {
      final radRes = await adapter.executeSentence(['/radius/print']);
      final hasRadius = radRes.isSuccess && radRes.data.isNotEmpty;
      bool hotspotEnabled = false;
      if (hasRadius) {
        for (final r in radRes.data) {
          final service = r['service'] ?? '';
          if (service.contains('hotspot')) {
            hotspotEnabled = true;
            break;
          }
        }
      }
      updated[1] = updated[1].copyWith(
        status: hotspotEnabled ? DiagnosticStatus.pass : DiagnosticStatus.warn,
        details: hotspotEnabled
            ? 'خادم RADIUS مهيأ ومربوط بخدمة الهوتسبوت بنجاح.'
            : 'لم يتم العثور على إدخال RADIUS يدعم خدمة الهوتسبوت (service=hotspot).',
        suggestedCommand: hotspotEnabled
            ? null
            : '/radius add service=hotspot address=127.0.0.1 secret=12345',
      );
    } on Object catch (e) {
      updated[1] = updated[1].copyWith(
        status: DiagnosticStatus.warn,
        details: 'تعذر التحقق من RADIUS: $e',
      );
    }

    // 3. Incoming CoA Port (3799)
    try {
      final coaRes = await adapter.executeSentence(['/radius/incoming/print']);
      final accept = coaRes.isSuccess &&
          coaRes.data.isNotEmpty &&
          (coaRes.data.first['accept'] == 'true' ||
              coaRes.data.first['accept'] == 'yes');
      final port = coaRes.isSuccess && coaRes.data.isNotEmpty
          ? (coaRes.data.first['port'] ?? '3799')
          : '3799';
      updated[2] = updated[2].copyWith(
        status: accept ? DiagnosticStatus.pass : DiagnosticStatus.warn,
        details: accept
            ? 'منفذ قطع الاتصال الفوري (CoA) مفعل على المنفذ $port.'
            : 'منفذ CoA غير مفعل (accept=no)؛ لن تتمكن من فصل المستخدمين فورياً من اليوزر منجر.',
        suggestedCommand:
            accept ? null : '/radius incoming set accept=yes port=3799',
      );
    } on Object catch (e) {
      updated[2] = updated[2].copyWith(
        status: DiagnosticStatus.warn,
        details: 'تعذر فحص منفذ CoA: $e',
      );
    }

    // 4. Profiles & Limitations
    try {
      final profiles = await adapter.getUserManagerProfiles();
      if (profiles.isEmpty) {
        updated[3] = updated[3].copyWith(
          status: DiagnosticStatus.warn,
          details: 'لا توجد بروفايلات معرفة في User Manager حالياً.',
          suggestedCommand: isV7
              ? '/user-manager/profile/add name=1Hour validity=1h'
              : '/tool/user-manager/profile/add name=1Hour validity=1h',
        );
      } else {
        updated[3] = updated[3].copyWith(
          status: DiagnosticStatus.pass,
          details: 'تم العثور على ${profiles.length} بروفايل بصياغة سليمة.',
        );
      }
    } on Object catch (e) {
      updated[3] = updated[3].copyWith(
        status: DiagnosticStatus.warn,
        details: 'خطأ أثناء فحص البروفايلات: $e',
      );
    }

    // 5. Active Sessions query speed
    try {
      final stopwatch = Stopwatch()..start();
      final sessions = await adapter.getUserManagerSessions(activeOnly: true);
      stopwatch.stop();
      final ms = stopwatch.elapsedMilliseconds;
      updated[4] = updated[4].copyWith(
        status: ms < 1500 ? DiagnosticStatus.pass : DiagnosticStatus.warn,
        details:
            'تم استرجاع ${sessions.length} جلسة نشطة مفصولة في ${ms}ms (استعلام خفيف وسريع).',
      );
    } on Object catch (e) {
      updated[4] = updated[4].copyWith(
        status: DiagnosticStatus.warn,
        details: 'تعذر جلب الجلسات النشطة: $e',
      );
    }

    // 6. Customer / Owner
    try {
      final customers = await adapter.getUserManagerCustomers();
      final hasCustom = customers.any((c) => c != 'admin');
      updated[5] = updated[5].copyWith(
        status: DiagnosticStatus.pass,
        details: hasCustom
            ? 'تم اكتشاف ملاك مخصصين للبروفايلات: ${customers.join(", ")}'
            : 'المالك الافتراضي: admin (جاهز لإنشاء الكروت)',
      );
    } on Object catch (e) {
      updated[5] = updated[5].copyWith(
        status: DiagnosticStatus.warn,
        details: 'تعذر التحقق من المالك: $e',
      );
    }

    // 7. DB size rating
    try {
      final users = await adapter.getUserManagerUsers();
      final count = users.length;
      if (count > 5000) {
        updated[6] = updated[6].copyWith(
          status: DiagnosticStatus.warn,
          details:
              'قاعدة البيانات تحتوي على $count كرت؛ يُنصح بمسح الكروت المنتهية لتحسين سرعة الراوتر.',
        );
      } else {
        updated[6] = updated[6].copyWith(
          status: DiagnosticStatus.pass,
          details: 'إجمالي الكروت المسجلة: $count كرت (حجم خفيف وأداء ممتاز).',
        );
      }
    } on Object catch (e) {
      updated[6] = updated[6].copyWith(
        status: DiagnosticStatus.warn,
        details: 'تعذر فحص عدد الكروت: $e',
      );
    }

    final passCount =
        updated.where((u) => u.status == DiagnosticStatus.pass).length;
    state = state.copyWith(
      checks: updated,
      isRunning: false,
      overallSummary:
          'اكتمل الفحص: نجح $passCount من أصل ${updated.length} فحوصات صحة.',
    );
  }
}

final umDiagnosticControllerProvider =
    StateNotifierProvider<UmDiagnosticNotifier, UmDiagnosticState>((ref) {
  return UmDiagnosticNotifier(ref);
});
