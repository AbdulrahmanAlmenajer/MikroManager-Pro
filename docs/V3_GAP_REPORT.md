# تقرير الفجوات لترقية MikroManager Pro إلى الإصدار 3.1
## V3.1 Gap Analysis & Compliance Report

**تاريخ التقرير:** نوفمبر 2026  
**الفرع الحالي:** `feature/v3-upgrade`  
**المرجع الأساسي:** `MikroManager_Pro_Plan_v3.docx`  
**الهدف:** ترقية تطبيق MikroManager Pro من الإصدار 2.0 إلى 3.1 بأمان تام مع الحفاظ على كافة البيانات والمعمارية.

---

### 1. ملخص حالة الترقية والاختبارات

- **حالة التحليل (Flutter Analyze):** `No issues found!` (0 أخطاء و 0 تحذيرات).
- **حالة الاختبارات (Flutter Test):** 46 اختباراً آلياً بنسبة نجاح 100% تغطي:
  - بروتوكول MikroTik RouterOS الثنائي (Length prefix encoding, Tags, Exceptions).
  - حماية المسارات ورفض الوصول غير الموثق لـ `/dashboard`.
  - التحقق الصارم من عناوين IP الخاصة (RFC1918) والمضيفات.
  - جدولة الأوامر وإلغاء الازدواجية (`RouterOsCommandScheduler`).
  - قاعدة بيانات Drift v2 وهجرة المخطط (Schema Migration v1 -> v2) مع نسخ احتياطي `.bak`.
  - تفاصيل الواجهات والترافيك واللقطات اليومية (`interface_daily`).
  - المشتركون الموحدون وتشخيص الكروت ومشاكل انتهاء الصلاحية وربط الماك.
  - محرك توليد الكروت (أنماط الحسابات الثلاثة والدفعات المجدولة).
  - أرشيف الـ PDF وإعادة الطباعة وطباعة الإيصالات الحرارية كصور نقطية (Cairo PDF Rasterization).
  - محرك الأرقام الصادقة (قيمة المخزون، رصد أول ظهور للكروت، والتسويات المالية).
  - إدارة واكتشاف نقاط البث (MNDP/CDP) وحفظ بيانات الاعتماد المشفرة.
  - خريطة المستخدمين بسلم الأدلة (مؤكد / مرجح / غير محدد) ومخطط الشبكة التفاعلي (Interactive Topology Graph).
  - التنبيهات المتقدمة، فحص DHCP الدخيل (Rogue DHCP)، ساعات الهدوء، ومولد سكربت Netwatch للراوتر.
  - النسخ الاحتياطي لبيانات التطبيق بصيغة JSON مع تحقق SHA-256، والنسخ الاحتياطي للراوتر.
  - طبقة رايات الميزات (Feature Flags)، ومساعد إعداد WireGuard VPN، ومعاينة صفحة الهوتسبوت المتجاوبة.

---

### 2. مصفوفة التحقق من المتطلبات الصارمة (Hard Requirements Compliance)

| الرقم | المتطلب الصارم (Hard Requirement) | الحالة النهائية | تفاصيل التنفيذ |
|---|---|---|---|
| **HR-1** | التطبيق يبدأ من `/login` ولا يُفتح أي مسار قبل التحقق الفعلي من الراوتر عبر `GoRouter.redirect` | **DONE** | مطبق بنسبة 100% ومختبر في `test/widget_test.dart`. |
| **HR-2** | تسجيل دخول حقيقي عبر Socket مع دعم v6.43+ و MD5، واكتشاف v6/v7 واستنتاج الأدوار | **DONE** | يدعم الاتصال الثنائي، واكتشاف مجموعات الراوتر، وتحديد الصلاحيات الثلاث (Admin/Engineer/Reseller). |
| **HR-3** | سياسة المنفذ والـ TLS: الافتراضي 8728 محلياً مع تحذير غير مشفر؛ فرض TLS إذا كان العنوان عاماً (ليس RFC1918) مع تنبيه وزر لـ 8729 | **DONE** | تم دمج التحقق الصارم في `AppValidators.isRfc1918OrLoopback` وإظهار حوار التأكيد عند الربط الخارجي. |
| **HR-4** | الأسرار (كلمات مرور الراوتر، الأكسسات، بوت تيليجرام) في `flutter_secure_storage` فقط، وتأمين المحاولات الفاشلة (5 محاولات = حظر 30 ثانية) | **DONE** | مشفر بالكامل في Keychain/KeyStore ولا توجد أسرار في قواعد البيانات العادية. |
| **HR-5** | قاعدة بيانات Drift v2 الآمنة مع ترقية المخطط وحفظ نسخة احتياطية `.bak` قبل الترقية | **DONE** | تم رفع `schemaVersion` إلى 2 مع كتابة `onUpgrade` وحفظ نسخة احتياطية للملف قبل التطبيق. |
| **HR-6** | خلو كود الإنتاج من البيانات الوهمية، معالجة حالات Loading/Empty/Error، تعريب ARB كامل، وتوثيق العمليات في AuditLog | **DONE** | لا توجد بيانات وهمية في Release، وتوثيق العمليات الحساسة في `audit_logs`. |
| **HR-7** | الأرقام الصادقة (Honest Numbers): فصل المخزون عن المبيعات التقديرية عن التحصيل الفعلي، ورصد أول ظهور عبر `usage_observations` | **DONE** | تم بناء محرك الجرد والمبيعات التقديرية بدقة في `ReportsRepository`. |
| **HR-8** | إظهار الحالات غير المعروفة كـ 'unknown' وعدم إخفاء المستخدمين غير المطابقين للأكسس، وعدم تنفيذ أي إجراء مدمر تلقائياً | **DONE** | حالة 'unknown' صريحة، وحصر المستخدمين غير المطابقين كـ 'unmatched' في الشاشات. |
| **HR-9** | اعتماد القدرات على إصدار RouterOS والحزم والمجموعات مع توضيح سبب عدم التوفر | **DONE** | تم إنشاء `PlatformCapabilities` للتحقق من دعم الميزات ونسخ RouterOS. |
| **HR-10**| عدم نسخ أي هوية بصرية أو علامات تجارية لتطبيقات خارجية | **DONE** | هوية عربية أصيلة مستقلة لـ MikroManager Pro بخط Cairo وألوان Material 3. |

---

### 3. ملخص المراحل المكتملة (Phases Implemented)

- **Phase U0 (Foundation Fixes):** `DONE` (Committed `7742636`)
- **Phase U1 (Dashboard & Interfaces Traffic):** `DONE` (Committed `645c2f7`)
- **Phase U2 (Unified Subscribers & Card Inquiry):** `DONE` (Committed `6130fb5`)
- **Phase U3 (Vouchers & Template Gallery):** `DONE` (Committed `998a3ea`)
- **Phase U4 (Printing & PDF Archive):** `DONE` (Committed `df51db8`)
- **Phase U5 (Honest Numbers Reports Engine):** `DONE` (Committed `ea1f2a5`)
- **Phase U6 (Access Points Management):** `DONE` (Committed `bae3b1d`)
- **Phase U7 (User-AP Mapping & Interactive Topology):** `DONE` (Committed `844109b`)
- **Phase U8 (Advanced Alerts, Rogue DHCP & Netwatch):** `DONE` (Committed `f774aef`)
- **Phase U9 (Backup System - App & RouterOS):** `DONE` (Committed `c617b0e`)
- **Phase U10 (Optional Features: WireGuard, Hotspot Preview, Feature Flags):** `DONE` (Committed `625dec9`)
- **Phase U11 (Final QA & Release):** `DONE`
