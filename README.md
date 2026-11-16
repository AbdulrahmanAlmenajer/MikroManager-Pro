# MikroManager Pro 🚀
### تطبيق متكامل لإدارة وطباعة كروت الميكروتك (Hotspot & User Manager)

تم بناء وتطوير هذا التطبيق بالكامل وفقاً لوثيقة الهندسة والمعمارية المعتمدة (إصدار 1.0) مع الالتزام الحرفي بالهيكلية والمعايير الفنية:
- **المنصات المدعومة:** Flutter (Android / iOS / Windows)
- **المعمارية:** Feature-First Clean Architecture + Riverpod + Drift (SQLite)
- **بروتوكولات الاتصال:** RouterOS Binary API (بورت 8728 / 8729) و REST API (بورت 80 / 443)
- **الطباعة:** PDF A4 (شبكة كروت مع QR Code) + طباعة حرارية (58mm / 80mm) عبر ESC/POS والبلوتوث
- **اللغة والتصميم:** واجهات عربية كاملة (RTL) مع لوحة ألوان احترافية وخط Cairo

---

## 🏗️ مراحل البناء المنجزة (6 مراحل بالكامل):

1. **المرحلة الأولى: التأسيس والبنية التحتية (Foundation & Infrastructure)**
   - دعم كامل لاتجاه اليمين لليسار (RTL) مع خط Cairo ومظهر Material 3.
   - إعداد GoRouter للملاحة السلسة والشاشات الثمانية الأساسية.
   - إعداد قاعدة البيانات المحلية Drift (SQLite) وجداول: `routers`, `voucher_batches`, `voucher_templates`, `sales_reports_cache`, `audit_logs`.
   - خدمة التخزين الآمن المشفر `FlutterSecureStorage` لتشفير كلمات مرور الراوترات وبوت تيليجرام.

2. **المرحلة الثانية: محرك الاتصال بـ API (RouterOS API Engine)**
   - `RouterOsSocketClient`: اتصال مباشر بالـ Binary API مع تشفير وفك طول الكلمات (Word Length Encoding)، ودعم المصادقة الحديثة (Post-6.43) والقديمة (MD5 Challenge).
   - `RouterOsRestClient`: اتصال عبر `dio` للراوترات الحديثة (RouterOS v7+).
   - `RouterOsAdapter`: طبقة موحدة تخفي الفروقات التقنية بين إصدارات v6 و v7.
   - شاشة إدارة الراوترات: فحص الاتصال الفوري (Ping/Socket Test)، إضافة وتعديل وحذف وتبديل الراوتر النشط.

3. **المرحلة الثالثة: إدارة Hotspot و User Manager**
   - إدارة متصلي الهوتس بوت (Active Users) مع إحصائيات البيانات (Bytes In/Out) وزر قطع الاتصال الفوري (Kick).
   - إدارة مستخدمي وبروفايلات الهوتس بوت (Hotspot Users & Profiles).
   - إدارة مشتركي وجلسات سيرفر User Manager (v6 و v7).
   - تسجيل وتوثيق كل العمليات تلقائياً في سجل التدقيق `audit_logs`.

4. **المرحلة الرابعة: محرك توليد وطباعة الكروت (Voucher Generator & Printing)**
   - محرك توليد أكواد كروت فريدة مع تحكم كامل بالبادئة، الطول، ونوع المحارف (أرقام أو حروف).
   - رفع الكروت مباشرة إلى الراوتر ومزامنتها محلياً في Drift لإعادة الطباعة دون الحاجة لراوتر.
   - معاينة وطباعة شبكة كروت A4 (3 كروت في الصف، 12 كرت بالصفحة مع رمز QR).
   - دعم تصدير أوامر الطباعة الحرارية (58mm و 80mm) عبر `esc_pos_utils_plus`.

5. **المرحلة الخامسة: التقارير والرسوم البيانية (Reports & Dashboard Monitoring)**
   - لوحة تحكم حية (Dashboard) ترصد استهلاك المعالج (CPU)، الذاكرة (RAM)، ومدة التشغيل (Uptime).
   - رسم بياني حي للترافيك اللحظي (Rx/Tx Live LineChart) بواسطة `fl_chart`.
   - تقارير المبيعات والأرباح مع رسم بياني بالأعمدة BarChart وتصدير تقارير مالية بصيغة PDF.
   - إعدادات طابعات البلوتوث وتكامل بوت تيليجرام (Telegram Bot) للتنبيهات الآلية.

6. **المرحلة السادسة: الاختبار والأمان والنشر (Testing & Security)**
   - اختبارات شاملة تغطي: خوارزمية الكروت، بروتوكول RouterOS، وقاعدة بيانات Drift.
   - تشفير البيانات الحساسة وحفظ كلمات المرور في مخزن النظام المشفر.
   - اجتياز جميع اختبارات `flutter test` و `flutter analyze` بنسبة 100% وبدون أي تحذيرات.

---

## 📁 هيكلية المشروع (lib/):
```
lib/
├── main.dart
├── core/
│   ├── constants/
│   │   ├── api_constants.dart
│   │   ├── app_colors.dart
│   │   └── app_theme.dart
│   ├── database/
│   │   ├── app_database.dart
│   │   ├── database_provider.dart
│   │   └── tables/
│   ├── network/
│   │   ├── routeros_adapter.dart
│   │   ├── routeros_rest_client.dart
│   │   └── routeros_socket_client.dart
│   ├── router/
│   │   └── app_router.dart
│   ├── security/
│   │   └── secure_storage_service.dart
│   └── utils/
│       ├── audit_logger.dart
│       ├── esc_pos_helper.dart
│       └── pdf_generator_helper.dart
└── features/
    ├── dashboard/
    ├── hotspot/
    ├── reports/
    ├── routers/
    ├── settings/
    ├── userman/
    └── vouchers/
```

---

## 🚀 تشغيل التطبيق (Run & Build):

### 1. تثبيت الحزم:
```bash
flutter pub get
```

### 2. تشغيل الاختبارات:
```bash
flutter test
```

### 3. تشغيل التطبيق على Windows أو Android:
```bash
flutter run
```

### 4. تحزيم وبناء التطبيق للإنتاج:
```bash
# لويندوز
flutter build windows

# للأندرويد
flutter build apk --release
```
