# تقرير الفجوات لترقية MikroManager Pro إلى الإصدار 3.1
## V3.1 Gap Analysis & Compliance Report

**تاريخ التقرير:** نوفمبر 2026  
**الفرع الحالي:** `feature/v3-upgrade`  
**المرجع الأساسي:** `MikroManager_Pro_Plan_v3.docx`  
**الهدف:** ترقية تطبيق MikroManager Pro من الإصدار 2.0 إلى 3.1 بأمان تام وبدون فقدان أي بيانات أو كود عامل.

---

### 1. ملخص التدقيق الأولي (Baseline Audit)

- **حالة التحليل (Flutter Analyze):** `No issues found!` (0 أخطاء و 0 تحذيرات).
- **حالة الاختبارات (Flutter Test):** 11 اختباراً نجحت جميعها بنسبة 100% (Drift DB, RouterOS Protocol, Voucher Generator, Route Guard & Session).
- **المعمارية:** Feature-First Clean Architecture (Presentation, Domain, Data) مع Riverpod 2.5, GoRouter 14.2, Drift 2.19, Secure Storage 9.2.
- **التصميم:** Cairo Font, Material 3, RTL كامل، لوحة ألوان رسمية (#0F172A, #0284C7, #10B981, #F59E0B, #EF4444).

---

### 2. مصفوفة التحقق من المتطلبات الصارمة (Hard Requirements)

| الرقم | المتطلب الصارم (Hard Requirement) | الحالة الحالية | الملفات ذات الصلة | التغيير المطلوب في v3.1 |
|---|---|---|---|---|
| **HR-1** | التطبيق يبدأ من `/login` ولا يُفتح أي مسار قبل التحقق الفعلي من الراوتر عبر `GoRouter.redirect` | **DONE** | `lib/core/router/app_router.dart`, `route_guard.dart` | الحفاظ التام عليه، وتحديث المسارات الجديدة في ShellRoute. |
| **HR-2** | تسجيل دخول حقيقي عبر Socket مع دعم v6.43+ و MD5، واكتشاف v6/v7 واستنتاج الأدوار | **DONE** | `routeros_socket_client.dart`, `session_controller.dart` | الحفاظ عليه وتزويد تقارير أخطاء واضحة بالعربية. |
| **HR-3** | سياسة المنفذ والـ TLS: الافتراضي 8728 محلياً مع تحذير غير مشفر؛ فرض TLS إذا كان العنوان غير خاص (ليس RFC1918) مع تنبيه وزر لـ 8729 | **PARTIAL** | `router_login_screen.dart`, `validators.dart` | إضافة فحص نطاق RFC1918 / Loopback ومنع 8728 للشبكات العامة دون تأكيد صريح من المستخدم. |
| **HR-4** | الأسرار (كلمات مرور الراوتر، الأكسسات، بوت تيليجرام) في `flutter_secure_storage` فقط، وتأمين المحاولات الفاشلة (5 محاولات = حظر 30 ثانية) | **DONE** | `secure_storage_service.dart`, `session_controller.dart` | استمرار التخزين المشفر وإضافة مفاتيح الأكسسات الجديدة. |
| **HR-5** | قاعدة بيانات Drift مشفرة (SQLCipher) بمفتاح في SecureStorage لحماية كلمات مرور الكروت والأرشيف | **PARTIAL** | `app_database.dart`, `pubspec.yaml` | ترقية Drift لتشغيل التشفير وتوليد وحفظ مفتاح التشفير الآمن في SecureStorage. |
| **HR-6** | خلو كود الإنتاج من البيانات الوهمية (kDebugMode فقط)، معالجة حالات Loading/Empty/Error مع إعادة المحاولة، تعريب ARB كامل، تأكيد الإجراءات المدمرة وتسجيلها في AuditLog | **DONE** | `audit_logger.dart`, `app_ar.arb`, `app_en.arb` | توسيع التغطية للشاشات الجديدة المضافة في v3.1. |
| **HR-7** | الأرقام الصادقة (Honest Numbers): فصل المخزون عن المبيعات التقديرية عن التحصيل الفعلي، وعدم احتساب الكروت المنتهية قبل الخدمة كمبيعات، ومصدر المبيعات الوحيد هو `usage_observations` | **MISSING** | `lib/features/reports/`, `lib/core/database/` | بناء محرك الرصد اليومي وجداول `usage_observations`, `profile_prices`, `payments`, `card_events`. |
| **HR-8** | إظهار الحالات غير المعروفة كـ 'unknown' وعدم إخفاء المستخدمين غير المطابقين للأكسس، وعدم تنفيذ أي إجراء مدمر تلقائياً | **MISSING** | ميزات الأكسسات والخرائط الجديدة | تطبيق المبدأ في خوارزميات فحص الشبكة والأكسسات. |
| **HR-9** | اعتماد القدرات على إصدار RouterOS والحزم والمجموعات مع توضيح سبب عدم التوفر | **PARTIAL** | `session_controller.dart`, `router_session.dart` | إنشاء خدمة `PlatformCapabilities` مركزية تستعلم حزم وقدرات الراوتر. |
| **HR-10**| عدم نسخ أي هوية بصرية أو علامات تجارية لتطبيقات خارجية | **DONE** | تصميم وهوية مستقلة لـ MikroManager Pro | استمرار الهوية والتصميم المستقل. |

---

### 3. تدقيق تفصيلي لمراحل خطة v3.1 (Phases Classification)

#### المرحلة U0: التأسيس والتصحيحات القاعدية (Foundation Fixes)
- **جدولة مركزية للأوامر (Central RouterOS Command Scheduler):** `MISSING` — مطلوب إنشاء `RouterOsCommandScheduler` يدير طابور الاستعلامات، ويدمج الطلبات المتطابقة (de-duplication)، ويتحكم بتردد الفحص لمنع إجهاد المعالج.
- **تشفير قاعدة Drift ودعم ترقية المخطط (Schema Migration):** `PARTIAL` — schemaVersion حالياً = 1؛ يجب رفعها مع كتابة `onUpgrade` وحفظ نسخة احتياطية من ملف قاعدة البيانات قبل الترقية واختبار الترقية.
- **خدمة قدرات المنصة والراوتر (PlatformCapabilities):** `MISSING` — تمييز منصات التشغيل (Android / iOS / Windows) وإمكانيات الراوتر.

#### المرحلة U1: الداشبورد وحالات الواجهات والترافيك
- **عرض موارد النظام والمستخدمين والترافيك الحي:** `DONE` — موجود في `dashboard_screen.dart` و `dashboard_notifier.dart`.
- **حالات الواجهات ومراقبة الواجهات الفردية (Interfaces & Monitor-Traffic):** `PARTIAL` — يوجد قراءة أساسية، ينقص شاشة تفاصيل الواجهات وتسجيل اللقطات اليومية في `interface_daily`.

#### المرحلة U2: المشتركون والتشخيص الموحد (Subscribers & Card Inquiry)
- **شاشة المشتركين الموحدة (Hotspot / User Manager / PPPoE):** `PARTIAL` — الهوتسبوت ويوزر منجر موجودان كشاشات منفصلة، بينما تنقص واجهة PPPoE (`/ppp/secret`, `/ppp/active`) والبحث الموحد والترقيم والتحميل الكسول.
- **استعلام وتشخيص الكرت (Card Inquiry & Diagnosis):** `MISSING` — شاشة فحص الكرت (بالاسم أو الـ QR)، وتحليل سبب فشل الدخول (معطل، منتهٍ، استهلاك الحصة، ربط MAC، shared-users) مع ترتيب الاحتمالات وتوفير إجراءات الإصلاح السريعة.

#### المرحلة U3: الكروت وتوليدها ومعرض القوالب (Vouchers & Template Gallery)
- **محرك توليد الكروت بالأمان العالي:** `DONE` — موجود بدفعات 50 واستخدام `Random.secure()`.
- **الأنماط الثلاثة لبيانات الدخول:** `PARTIAL` — يدعم حالياً كرت مع كلمة مرور؛ ينقص خيار "اسم مستخدم فقط" و "اسم وكلمة مرور متطابقين".
- **معرض القوالب ومحرر التصميم:** `PARTIAL` — يوجد قالب افتراضي A4؛ ينقص معرض القوالب المتعددة ومحرر التصميم المباشر (اسم الشبكة، الشعار، الألوان، QR، أحجام 58mm و 80mm و A4).

#### المرحلة U4: الطباعة وأرشيف الـ PDF (Printing & PDF Archive)
- **الطباعة A4 و ESC/POS مع تحويل النصوص العربية إلى صور نقطية:** `DONE` — منفذة في `pdf_generator_helper.dart` و `esc_pos_helper.dart`.
- **أرشيف الـ PDF (`pdf_archive`):** `MISSING` — تخزين سجلات ملفات الـ PDF المولدة في جدول `pdf_archive` مع مسار الملف والدفعة لإعادة الطباعة.

#### المرحلة U5: محرك تقارير الكروت والأرقام الصادقة (Honest Card Reports Engine)
- **تسعير البروفايلات (`profile_prices`):** `MISSING`.
- **رصد أول استخدام (`usage_observations`):** `MISSING` — فحص `uptime > 0` أو استهلاك البيانات أو جلسات UM مع تعليم التاريخ التقريبي.
- **فصل المخزون عن المبيعات التقديرية عن التحصيل الفعلي:** `MISSING`.
- **سجل أحداث الكروت (`card_events`) والدفعات اليدوية (`payments`):** `MISSING`.
- **سياسة الاحتفاظ والتجميع وتصفية دور الوكيل (Reseller):** `MISSING`.

#### المرحلة U6: إدارة أجهزة الأكسس بوينت (Access Points Management)
- **اكتشاف الأكسسات (`/ip/neighbor`, IP ranges, manual):** `MISSING`.
- **بيانات اعتماد خاصة بكل جهاز في SecureStorage:** `MISSING`.
- **فتح واجهة الإدارة بمتصفح مدمج أو خارجي حسب المنصة:** `MISSING`.
- **حالة الوصول لكل جهاز (متاح / غير متاح / بيانات خاطئة):** `MISSING`.

#### المرحلة U7: خريطة المستخدمين وخريطة الشبكة (Users Map & Network Topology)
- **خريطة المستخدمين على الأكسسات بسلّم الأدلة:** `MISSING` (مؤكد عبر client list أو registration-table، مرجح عبر bridge host + neighbor، أو غير مطابق).
- **خريطة الشبكة (Topology Graph):** `MISSING` — رسم شجري من الجيران مع حفظ اللقطات وإضافة عقد يدوية بـ `InteractiveViewer` و `CustomPainter`.

#### المرحلة U8: التنبيهات المتقدمة وتيليجرام وDHCP الدخيل (Alerts & Rogue DHCP)
- **التنبيهات الذكية وساعات الهدوء:** `MISSING` — تنبيه بعد N إخفاقات وإشعار تعافٍ وساعات هدوء وقواعد محددة.
- **فحص DHCP الدخيل (Rogue DHCP Alert):** `MISSING` — قراءة تنبيهات الراوتر وقائمة الخوادم الموثوقة `trusted_dhcp_servers`.
- **مساعد سكربت Netwatch للراوتر:** `MISSING` — توليد السكربت مع تحذير أمان التوكن وعرضه للموافقة.

#### المرحلة U9: النسخ الاحتياطي (Backup System)
- **نسخ بيانات التطبيق مشفرة:** `MISSING` — تصدير واستيراد قاعدة Drift مع كلمة مرور.
- **نسخ إعدادات الراوتر وUser Manager:** `MISSING` — عبر SFTP/SSH بـ `dartssh2`.

#### المرحلة U10: الميزات الإضافية (Could Features)
- **معاينة صفحات دخول الهوتسبوت:** `MISSING`.
- **مساعد إعداد WireGuard VPN:** `MISSING`.
- **طبقة رايات الميزات (Feature Flags):** `MISSING`.
- **تكامل اللغتين العربية والإنجليزية ARB:** `PARTIAL` — مكتمل بنسبة 80% للشاشات الأساسية.

#### المرحلة U11: ضمان الجودة والنشر (QA & Release)
- **تغطية الاختبارات:** `PARTIAL` — 11 اختباراً تغطي النواة الأساسية، وتتطلب التوسيع لتغطي الجدولة والتقارير والتشخيص والمسارات.
- **بناء الحزم:** تم التحقق من بناء APK وسلامة التحليل.

---

### 4. هيكل الجداول الجديد المطلوب في Drift (Database Schema v2)

1. `profile_prices` (connectionId, profileName, price, currency, updatedAt)
2. `usage_observations` (connectionId, cardName, profile, firstSeenAt, dateIsApproximate)
3. `card_events` (connectionId, type, count, profile, at)
4. `payments` (connectionId, amount, note, receivedAt)
5. `pdf_archive` (id, batchId, filePath, templateId, createdAt)
6. `ap_devices` (id, connectionId, name, ip, vendor, lastCheckAt, accessState)
7. `user_ap_matches` (connectionId, userMac, apId, confidence, evidence, at)
8. `topology_snapshots` (connectionId, graphJson, savedAt)
9. `alert_rules` (id, connectionId, type, target, threshold, destination, enabled)
10. `alert_events` (id, ruleId, status, at, details)
11. `quiet_hours` (connectionId, startMinute, endMinute, days, muteUntil)
12. `trusted_dhcp_servers` (connectionId, serverIp, interface)
13. `interface_daily` (connectionId, interface, date, rxBytes, txBytes)
14. `backup_log` (id, connectionId, kind, path, createdAt)

---

### 5. خطة التنفيذ المرحلية (Execution Roadmap)

- **Phase U0:** إنشاء `RouterOsCommandScheduler`، تحديث Drift schema مع دعم ترقية آمنة، إنشاء `PlatformCapabilities`، وتطبيق التحقق الصارم من RFC1918 في شاشة الدخول.
- **Phase U1:** شاشة الواجهات والترافيك واللقطات اليومية المجدولة.
- **Phase U2:** شاشة المشتركين الموحدة (Hotspot/UM/PPPoE) + أداة تشخيص الكروت.
- **Phase U3:** محرر ومعرض قوالب الكروت وأنماط الحسابات الثلاثة.
- **Phase U4:** ربط أرشيف PDF مع الطباعة.
- **Phase U5:** محرك التقارير المالية الصادقة (المخزون، المبيعات التقديرية، التحصيل).
- **Phase U6:** إدارة واكتشاف الأكسس بوينت وحساباتها المنفصلة.
- **Phase U7:** خريطة المستخدمين وخريطة الشبكة التفاعلية.
- **Phase U8:** التنبيهات المتقدمة وفحص DHCP الدخيل ومولد Netwatch.
- **Phase U9:** نظام النسخ الاحتياطي للتطبيق والراوتر.
- **Phase U10:** صفحات الهوتسبوت ومساعد WireGuard وFeature Flags.
- **Phase U11:** الاختبارات النهائية وضمان الجودة وحزم التوزيع.
