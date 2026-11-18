// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'MikroManager Pro';

  @override
  String get appSubtitle => 'إدارة وطباعة كروت شبكات الميكروتك';

  @override
  String get loginTitle => 'تسجيل الدخول إلى الراوتر';

  @override
  String get loginSubtitle =>
      'أدخل بيانات الاتصال بجهاز MikroTik للوصول إلى لوحة التحكم';

  @override
  String get hostOrIpLabel => 'عنوان IP أو اسم المضيف';

  @override
  String get hostOrIpHint => '192.168.88.1';

  @override
  String get portLabel => 'منفذ الاتصال (Port)';

  @override
  String get portHint => '8728';

  @override
  String get usernameLabel => 'اسم المستخدم';

  @override
  String get usernameHint => 'admin';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get passwordHint => 'كلمة المرور (إن وجدت)';

  @override
  String get rememberMe => 'تذكر بيانات هذا الراوتر';

  @override
  String get useSsl => 'استخدام تشفير TLS/SSL (منفذ 8729)';

  @override
  String get acceptSelfSignedCert => 'قبول الشهادة ذاتية التوقيع (Self-Signed)';

  @override
  String get certWarning =>
      'تنبيه: قبول الشهادات غير الموثوقة قد يعرض الاتصال لاعتراض البيانات على الشبكة المحلية.';

  @override
  String get savedConnections => 'الاتصالات المحفوظة';

  @override
  String get newConnection => 'اتصال جديد';

  @override
  String get loginButton => 'تسجيل الدخول والاتصال بالراوتر';

  @override
  String get connecting => 'جاري التحقق والاتصال بالراوتر...';

  @override
  String get testConnection => 'فحص الاتصال فقط';

  @override
  String get tooManyAttempts =>
      'تم تجاوز عدد المحاولات المسموح بها. يُرجى الانتظار 30 ثانية.';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get logoutConfirmTitle => 'تأكيد تسجيل الخروج';

  @override
  String get logoutConfirmMessage =>
      'هل أنت متأكد من قطع الاتصال بالراوتر؟ ستتم إعادتك لشاشة تسجيل الدخول.';

  @override
  String get cancel => 'إلغاء';

  @override
  String get confirm => 'تأكيد';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navHotspot => 'الهوتسبوت';

  @override
  String get navSubscribers => 'المشتركون';

  @override
  String get navVouchers => 'الكروت';

  @override
  String get navReports => 'التقارير';

  @override
  String get navMore => 'المزيد';

  @override
  String get dashboardTitle => 'لوحة التحكم';

  @override
  String get cpuUsage => 'استخدام المعالج';

  @override
  String get freeMemory => 'الذاكرة المتاحة';

  @override
  String get totalMemory => 'إجمالي الذاكرة';

  @override
  String get uptime => 'مدة التشغيل';

  @override
  String get activeUsers => 'المستخدمون النشطون';

  @override
  String get trafficMonitor => 'مراقبة حركة المرور اللحظية';

  @override
  String get selectInterface => 'اختر واجهة الشبكة';

  @override
  String get rxRate => 'الاستقبال (Rx)';

  @override
  String get txRate => 'الإرسال (Tx)';

  @override
  String get hotspotTitle => 'إدارة الهوتسبوت';

  @override
  String get tabUsers => 'المستخدمون';

  @override
  String get tabActive => 'المتصلون النشطون';

  @override
  String get tabProfiles => 'ملفات السرعة (Profiles)';

  @override
  String get tabBindings => 'ربط العناوين (IP Bindings)';

  @override
  String get addUser => 'إضافة مستخدم';

  @override
  String get kickUser => 'فصل المتصل (Kick)';

  @override
  String get deleteUser => 'حذف المستخدم';

  @override
  String get kickConfirm => 'هل أنت متأكد من فصل هذا المستخدم النشط؟';

  @override
  String get deleteConfirm => 'هل أنت متأكد من حذف هذا السجل نهائياً؟';

  @override
  String get searchHint => 'بحث...';

  @override
  String get usermanTitle => 'مدير المستخدمين (User Manager)';

  @override
  String get usermanProfiles => 'الباقات والملفات';

  @override
  String get usermanSessions => 'الجلسات النشطة';

  @override
  String get voucherTitle => 'توليد كروت الهوتسبوت';

  @override
  String get voucherCount => 'عدد الكروت';

  @override
  String get voucherPrefix => 'بادئة الكود (Prefix)';

  @override
  String get voucherLength => 'طول كود المستخدم';

  @override
  String get charsetType => 'نوع الأحرف المستخدمة';

  @override
  String get charsetNumbers => 'أرقام فقط (1-9)';

  @override
  String get charsetAlpha => 'حروف فقط (بدون حروف ملتبسة)';

  @override
  String get charsetMixed => 'أرقام وحروف مدمجة';

  @override
  String get generateAndPreview => 'توليد ومعاينة الطباعة';

  @override
  String get generatingVouchers => 'جاري إنشاء الكروت في الراوتر...';

  @override
  String batchProgress(Object current, Object total) {
    return 'تم إنشاء $current من $total كرت';
  }

  @override
  String get printPreviewTitle => 'معاينة وخيارات الطباعة';

  @override
  String get paperSizeA4 => 'ورق A4 (شبكة 3 أعمدة)';

  @override
  String get paperSize58 => 'طابعة حرارية 58mm';

  @override
  String get paperSize80 => 'طابعة حرارية 80mm';

  @override
  String get printDirect => 'طباعة مباشرة';

  @override
  String get exportPdf => 'تصدير ملف PDF';

  @override
  String get bluetoothPrinters => 'طابعات البلوتوث';

  @override
  String get reportsTitle => 'تقارير المبيعات والإحصائيات';

  @override
  String get dailySales => 'المبيعات اليومية';

  @override
  String get monthlySales => 'المبيعات الشهرية';

  @override
  String get exportCsv => 'تصدير CSV';

  @override
  String get totalRevenue => 'إجمالي الإيرادات';

  @override
  String get totalCardsSold => 'إجمالي الكروت المباعة';

  @override
  String get telegramTitle => 'إعدادات بوت تيليجرام';

  @override
  String get botToken => 'رمز البوت (Bot Token)';

  @override
  String get chatId => 'معرّف المحادثة (Chat ID)';

  @override
  String get sendTestAlert => 'إرسال رسالة تجريبية';

  @override
  String get alertRouterState => 'تنبيه عند سقوط أو عودة الراوتر';

  @override
  String get alertHighCpu => 'تنبيه عند ارتفاع استهلاك المعالج عن 90%';

  @override
  String get alertVoucherThreshold => 'تنبيه عند اقتراب نفاد الكروت';

  @override
  String get settingsTitle => 'الإعدادات العامة';

  @override
  String get roleAdmin => 'مدير النظام (Admin)';

  @override
  String get roleEngineer => 'مهندس شبكة (Engineer)';

  @override
  String get roleReseller => 'موزع / بائع (Reseller)';

  @override
  String get currentRole => 'صلاحية الحساب الحالية';

  @override
  String get auditLogs => 'سجل العمليات والرقابة';

  @override
  String get errorTimeout =>
      'تعذر الوصول إلى الراوتر (انتهت مهلة الاتصال). تحقق من عنوان IP والشبكة.';

  @override
  String get errorPortClosed =>
      'المنفذ مغلق أو خدمة API غير مفعّلة في الراوتر. قم بتفعيلها عبر: /ip service enable api';

  @override
  String get errorAuthFailed => 'اسم المستخدم أو كلمة المرور غير صحيحة.';

  @override
  String get errorTlsFailed =>
      'فشل التحقق من أمان شهادة TLS/SSL. يمكنك تفعيل خيار قبول الشهادات ذاتية التوقيع.';

  @override
  String get errorMissingPolicy =>
      'المستخدم الحالي لا يملك صلاحية API على راوتر الميكروتك.';

  @override
  String errorGeneral(Object message) {
    return 'حدث خطأ غير متوقع: $message';
  }

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get emptyData => 'لا توجد بيانات متاحة حالياً';
}
