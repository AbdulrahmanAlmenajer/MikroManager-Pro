import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In ar, this message translates to:
  /// **'MikroManager Pro'**
  String get appTitle;

  /// No description provided for @appSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'إدارة وطباعة كروت شبكات الميكروتك'**
  String get appSubtitle;

  /// No description provided for @loginTitle.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول إلى الراوتر'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أدخل بيانات الاتصال بجهاز MikroTik للوصول إلى لوحة التحكم'**
  String get loginSubtitle;

  /// No description provided for @hostOrIpLabel.
  ///
  /// In ar, this message translates to:
  /// **'عنوان IP أو اسم المضيف'**
  String get hostOrIpLabel;

  /// No description provided for @hostOrIpHint.
  ///
  /// In ar, this message translates to:
  /// **'192.168.88.1'**
  String get hostOrIpHint;

  /// No description provided for @portLabel.
  ///
  /// In ar, this message translates to:
  /// **'منفذ الاتصال (Port)'**
  String get portLabel;

  /// No description provided for @portHint.
  ///
  /// In ar, this message translates to:
  /// **'8728'**
  String get portHint;

  /// No description provided for @usernameLabel.
  ///
  /// In ar, this message translates to:
  /// **'اسم المستخدم'**
  String get usernameLabel;

  /// No description provided for @usernameHint.
  ///
  /// In ar, this message translates to:
  /// **'admin'**
  String get usernameHint;

  /// No description provided for @passwordLabel.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور'**
  String get passwordLabel;

  /// No description provided for @passwordHint.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور (إن وجدت)'**
  String get passwordHint;

  /// No description provided for @rememberMe.
  ///
  /// In ar, this message translates to:
  /// **'تذكر بيانات هذا الراوتر'**
  String get rememberMe;

  /// No description provided for @useSsl.
  ///
  /// In ar, this message translates to:
  /// **'استخدام تشفير TLS/SSL (منفذ 8729)'**
  String get useSsl;

  /// No description provided for @acceptSelfSignedCert.
  ///
  /// In ar, this message translates to:
  /// **'قبول الشهادة ذاتية التوقيع (Self-Signed)'**
  String get acceptSelfSignedCert;

  /// No description provided for @certWarning.
  ///
  /// In ar, this message translates to:
  /// **'تنبيه: قبول الشهادات غير الموثوقة قد يعرض الاتصال لاعتراض البيانات على الشبكة المحلية.'**
  String get certWarning;

  /// No description provided for @savedConnections.
  ///
  /// In ar, this message translates to:
  /// **'الاتصالات المحفوظة'**
  String get savedConnections;

  /// No description provided for @newConnection.
  ///
  /// In ar, this message translates to:
  /// **'اتصال جديد'**
  String get newConnection;

  /// No description provided for @loginButton.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول والاتصال بالراوتر'**
  String get loginButton;

  /// No description provided for @connecting.
  ///
  /// In ar, this message translates to:
  /// **'جاري التحقق والاتصال بالراوتر...'**
  String get connecting;

  /// No description provided for @testConnection.
  ///
  /// In ar, this message translates to:
  /// **'فحص الاتصال فقط'**
  String get testConnection;

  /// No description provided for @tooManyAttempts.
  ///
  /// In ar, this message translates to:
  /// **'تم تجاوز عدد المحاولات المسموح بها. يُرجى الانتظار 30 ثانية.'**
  String get tooManyAttempts;

  /// No description provided for @logout.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الخروج'**
  String get logout;

  /// No description provided for @logoutConfirmTitle.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد تسجيل الخروج'**
  String get logoutConfirmTitle;

  /// No description provided for @logoutConfirmMessage.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من قطع الاتصال بالراوتر؟ ستتم إعادتك لشاشة تسجيل الدخول.'**
  String get logoutConfirmMessage;

  /// No description provided for @cancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد'**
  String get confirm;

  /// No description provided for @navHome.
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get navHome;

  /// No description provided for @navHotspot.
  ///
  /// In ar, this message translates to:
  /// **'الهوتسبوت'**
  String get navHotspot;

  /// No description provided for @navVouchers.
  ///
  /// In ar, this message translates to:
  /// **'الكروت'**
  String get navVouchers;

  /// No description provided for @navReports.
  ///
  /// In ar, this message translates to:
  /// **'التقارير'**
  String get navReports;

  /// No description provided for @navMore.
  ///
  /// In ar, this message translates to:
  /// **'المزيد'**
  String get navMore;

  /// No description provided for @dashboardTitle.
  ///
  /// In ar, this message translates to:
  /// **'لوحة التحكم'**
  String get dashboardTitle;

  /// No description provided for @cpuUsage.
  ///
  /// In ar, this message translates to:
  /// **'استخدام المعالج'**
  String get cpuUsage;

  /// No description provided for @freeMemory.
  ///
  /// In ar, this message translates to:
  /// **'الذاكرة المتاحة'**
  String get freeMemory;

  /// No description provided for @totalMemory.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي الذاكرة'**
  String get totalMemory;

  /// No description provided for @uptime.
  ///
  /// In ar, this message translates to:
  /// **'مدة التشغيل'**
  String get uptime;

  /// No description provided for @activeUsers.
  ///
  /// In ar, this message translates to:
  /// **'المستخدمون النشطون'**
  String get activeUsers;

  /// No description provided for @trafficMonitor.
  ///
  /// In ar, this message translates to:
  /// **'مراقبة حركة المرور اللحظية'**
  String get trafficMonitor;

  /// No description provided for @selectInterface.
  ///
  /// In ar, this message translates to:
  /// **'اختر واجهة الشبكة'**
  String get selectInterface;

  /// No description provided for @rxRate.
  ///
  /// In ar, this message translates to:
  /// **'الاستقبال (Rx)'**
  String get rxRate;

  /// No description provided for @txRate.
  ///
  /// In ar, this message translates to:
  /// **'الإرسال (Tx)'**
  String get txRate;

  /// No description provided for @hotspotTitle.
  ///
  /// In ar, this message translates to:
  /// **'إدارة الهوتسبوت'**
  String get hotspotTitle;

  /// No description provided for @tabUsers.
  ///
  /// In ar, this message translates to:
  /// **'المستخدمون'**
  String get tabUsers;

  /// No description provided for @tabActive.
  ///
  /// In ar, this message translates to:
  /// **'المتصلون النشطون'**
  String get tabActive;

  /// No description provided for @tabProfiles.
  ///
  /// In ar, this message translates to:
  /// **'ملفات السرعة (Profiles)'**
  String get tabProfiles;

  /// No description provided for @tabBindings.
  ///
  /// In ar, this message translates to:
  /// **'ربط العناوين (IP Bindings)'**
  String get tabBindings;

  /// No description provided for @addUser.
  ///
  /// In ar, this message translates to:
  /// **'إضافة مستخدم'**
  String get addUser;

  /// No description provided for @kickUser.
  ///
  /// In ar, this message translates to:
  /// **'فصل المتصل (Kick)'**
  String get kickUser;

  /// No description provided for @deleteUser.
  ///
  /// In ar, this message translates to:
  /// **'حذف المستخدم'**
  String get deleteUser;

  /// No description provided for @kickConfirm.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من فصل هذا المستخدم النشط؟'**
  String get kickConfirm;

  /// No description provided for @deleteConfirm.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من حذف هذا السجل نهائياً؟'**
  String get deleteConfirm;

  /// No description provided for @searchHint.
  ///
  /// In ar, this message translates to:
  /// **'بحث...'**
  String get searchHint;

  /// No description provided for @usermanTitle.
  ///
  /// In ar, this message translates to:
  /// **'مدير المستخدمين (User Manager)'**
  String get usermanTitle;

  /// No description provided for @usermanProfiles.
  ///
  /// In ar, this message translates to:
  /// **'الباقات والملفات'**
  String get usermanProfiles;

  /// No description provided for @usermanSessions.
  ///
  /// In ar, this message translates to:
  /// **'الجلسات النشطة'**
  String get usermanSessions;

  /// No description provided for @voucherTitle.
  ///
  /// In ar, this message translates to:
  /// **'توليد كروت الهوتسبوت'**
  String get voucherTitle;

  /// No description provided for @voucherCount.
  ///
  /// In ar, this message translates to:
  /// **'عدد الكروت'**
  String get voucherCount;

  /// No description provided for @voucherPrefix.
  ///
  /// In ar, this message translates to:
  /// **'بادئة الكود (Prefix)'**
  String get voucherPrefix;

  /// No description provided for @voucherLength.
  ///
  /// In ar, this message translates to:
  /// **'طول كود المستخدم'**
  String get voucherLength;

  /// No description provided for @charsetType.
  ///
  /// In ar, this message translates to:
  /// **'نوع الأحرف المستخدمة'**
  String get charsetType;

  /// No description provided for @charsetNumbers.
  ///
  /// In ar, this message translates to:
  /// **'أرقام فقط (1-9)'**
  String get charsetNumbers;

  /// No description provided for @charsetAlpha.
  ///
  /// In ar, this message translates to:
  /// **'حروف فقط (بدون حروف ملتبسة)'**
  String get charsetAlpha;

  /// No description provided for @charsetMixed.
  ///
  /// In ar, this message translates to:
  /// **'أرقام وحروف مدمجة'**
  String get charsetMixed;

  /// No description provided for @generateAndPreview.
  ///
  /// In ar, this message translates to:
  /// **'توليد ومعاينة الطباعة'**
  String get generateAndPreview;

  /// No description provided for @generatingVouchers.
  ///
  /// In ar, this message translates to:
  /// **'جاري إنشاء الكروت في الراوتر...'**
  String get generatingVouchers;

  /// No description provided for @batchProgress.
  ///
  /// In ar, this message translates to:
  /// **'تم إنشاء {current} من {total} كرت'**
  String batchProgress(Object current, Object total);

  /// No description provided for @printPreviewTitle.
  ///
  /// In ar, this message translates to:
  /// **'معاينة وخيارات الطباعة'**
  String get printPreviewTitle;

  /// No description provided for @paperSizeA4.
  ///
  /// In ar, this message translates to:
  /// **'ورق A4 (شبكة 3 أعمدة)'**
  String get paperSizeA4;

  /// No description provided for @paperSize58.
  ///
  /// In ar, this message translates to:
  /// **'طابعة حرارية 58mm'**
  String get paperSize58;

  /// No description provided for @paperSize80.
  ///
  /// In ar, this message translates to:
  /// **'طابعة حرارية 80mm'**
  String get paperSize80;

  /// No description provided for @printDirect.
  ///
  /// In ar, this message translates to:
  /// **'طباعة مباشرة'**
  String get printDirect;

  /// No description provided for @exportPdf.
  ///
  /// In ar, this message translates to:
  /// **'تصدير ملف PDF'**
  String get exportPdf;

  /// No description provided for @bluetoothPrinters.
  ///
  /// In ar, this message translates to:
  /// **'طابعات البلوتوث'**
  String get bluetoothPrinters;

  /// No description provided for @reportsTitle.
  ///
  /// In ar, this message translates to:
  /// **'تقارير المبيعات والإحصائيات'**
  String get reportsTitle;

  /// No description provided for @dailySales.
  ///
  /// In ar, this message translates to:
  /// **'المبيعات اليومية'**
  String get dailySales;

  /// No description provided for @monthlySales.
  ///
  /// In ar, this message translates to:
  /// **'المبيعات الشهرية'**
  String get monthlySales;

  /// No description provided for @exportCsv.
  ///
  /// In ar, this message translates to:
  /// **'تصدير CSV'**
  String get exportCsv;

  /// No description provided for @totalRevenue.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي الإيرادات'**
  String get totalRevenue;

  /// No description provided for @totalCardsSold.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي الكروت المباعة'**
  String get totalCardsSold;

  /// No description provided for @telegramTitle.
  ///
  /// In ar, this message translates to:
  /// **'إعدادات بوت تيليجرام'**
  String get telegramTitle;

  /// No description provided for @botToken.
  ///
  /// In ar, this message translates to:
  /// **'رمز البوت (Bot Token)'**
  String get botToken;

  /// No description provided for @chatId.
  ///
  /// In ar, this message translates to:
  /// **'معرّف المحادثة (Chat ID)'**
  String get chatId;

  /// No description provided for @sendTestAlert.
  ///
  /// In ar, this message translates to:
  /// **'إرسال رسالة تجريبية'**
  String get sendTestAlert;

  /// No description provided for @alertRouterState.
  ///
  /// In ar, this message translates to:
  /// **'تنبيه عند سقوط أو عودة الراوتر'**
  String get alertRouterState;

  /// No description provided for @alertHighCpu.
  ///
  /// In ar, this message translates to:
  /// **'تنبيه عند ارتفاع استهلاك المعالج عن 90%'**
  String get alertHighCpu;

  /// No description provided for @alertVoucherThreshold.
  ///
  /// In ar, this message translates to:
  /// **'تنبيه عند اقتراب نفاد الكروت'**
  String get alertVoucherThreshold;

  /// No description provided for @settingsTitle.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات العامة'**
  String get settingsTitle;

  /// No description provided for @roleAdmin.
  ///
  /// In ar, this message translates to:
  /// **'مدير النظام (Admin)'**
  String get roleAdmin;

  /// No description provided for @roleEngineer.
  ///
  /// In ar, this message translates to:
  /// **'مهندس شبكة (Engineer)'**
  String get roleEngineer;

  /// No description provided for @roleReseller.
  ///
  /// In ar, this message translates to:
  /// **'موزع / بائع (Reseller)'**
  String get roleReseller;

  /// No description provided for @currentRole.
  ///
  /// In ar, this message translates to:
  /// **'صلاحية الحساب الحالية'**
  String get currentRole;

  /// No description provided for @auditLogs.
  ///
  /// In ar, this message translates to:
  /// **'سجل العمليات والرقابة'**
  String get auditLogs;

  /// No description provided for @errorTimeout.
  ///
  /// In ar, this message translates to:
  /// **'تعذر الوصول إلى الراوتر (انتهت مهلة الاتصال). تحقق من عنوان IP والشبكة.'**
  String get errorTimeout;

  /// No description provided for @errorPortClosed.
  ///
  /// In ar, this message translates to:
  /// **'المنفذ مغلق أو خدمة API غير مفعّلة في الراوتر. قم بتفعيلها عبر: /ip service enable api'**
  String get errorPortClosed;

  /// No description provided for @errorAuthFailed.
  ///
  /// In ar, this message translates to:
  /// **'اسم المستخدم أو كلمة المرور غير صحيحة.'**
  String get errorAuthFailed;

  /// No description provided for @errorTlsFailed.
  ///
  /// In ar, this message translates to:
  /// **'فشل التحقق من أمان شهادة TLS/SSL. يمكنك تفعيل خيار قبول الشهادات ذاتية التوقيع.'**
  String get errorTlsFailed;

  /// No description provided for @errorMissingPolicy.
  ///
  /// In ar, this message translates to:
  /// **'المستخدم الحالي لا يملك صلاحية API على راوتر الميكروتك.'**
  String get errorMissingPolicy;

  /// No description provided for @errorGeneral.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ غير متوقع: {message}'**
  String errorGeneral(Object message);

  /// No description provided for @retry.
  ///
  /// In ar, this message translates to:
  /// **'إعادة المحاولة'**
  String get retry;

  /// No description provided for @emptyData.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد بيانات متاحة حالياً'**
  String get emptyData;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
