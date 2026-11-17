/// Typed exceptions for RouterOS API communications
abstract class RouterOsException implements Exception {
  final String message;
  final String? technicalDetails;

  const RouterOsException(this.message, [this.technicalDetails]);

  @override
  String toString() => technicalDetails != null ? '$message ($technicalDetails)' : message;
}

class RouterOsTimeoutException extends RouterOsException {
  const RouterOsTimeoutException([String? details])
      : super('تعذر الوصول إلى الراوتر (انتهت مهلة الاتصال). يرجى التحقق من عنوان IP والاتصال بالشبكة.', details);
}

class RouterOsUnreachableException extends RouterOsException {
  const RouterOsUnreachableException([String? details])
      : super('المضيف غير متاح أو لا يمكن الوصول إليه.', details);
}

class RouterOsPortClosedException extends RouterOsException {
  const RouterOsPortClosedException([String? details])
      : super('المنفذ مغلق أو خدمة API غير مفعّلة في الراوتر. قم بتفعيلها عبر: /ip service enable api', details);
}

class RouterOsAuthException extends RouterOsException {
  const RouterOsAuthException([String? details])
      : super('اسم المستخدم أو كلمة المرور غير صحيحة (فشل تسجيل الدخول).', details);
}

class RouterOsTlsException extends RouterOsException {
  const RouterOsTlsException([String? details])
      : super('فشل التحقق من أمان شهادة TLS/SSL. يمكنك تفعيل خيار قبول الشهادات ذاتية التوقيع.', details);
}

class RouterOsMissingPolicyException extends RouterOsException {
  const RouterOsMissingPolicyException([String? details])
      : super('المستخدم الحالي لا يملك صلاحية API (/user group policy api) على راوتر الميكروتك.', details);
}

class RouterOsProtocolException extends RouterOsException {
  const RouterOsProtocolException(super.message, [super.technicalDetails]);
}
