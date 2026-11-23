import '../../../core/utils/pdf_generator_helper.dart';
import '../../subscribers/data/subscribers_repository.dart';

enum CardType {
  hotspot,
  userMan;

  String get labelArabic => this == CardType.hotspot ? 'هوتسبوت' : 'يوزر منجر';
}

enum CardStatus {
  newCard,
  printed,
  sold,
  active,
  expired,
  disabled;

  String get labelArabic {
    switch (this) {
      case CardStatus.newCard:
        return 'جديد';
      case CardStatus.printed:
        return 'مطبوع';
      case CardStatus.sold:
        return 'مباع';
      case CardStatus.active:
        return 'نشط';
      case CardStatus.expired:
        return 'منتهي';
      case CardStatus.disabled:
        return 'معطل';
    }
  }
}

class UnifiedCardModel {
  final String id;
  final String username;
  final String password;
  final String profile;
  final double price;
  final CardType cardType;
  final String source; // 'router', 'local_batch'
  final CardStatus status;
  final String? validity;
  final String? uptime;
  final int bytesIn;
  final int bytesOut;
  final String? limitUptime;
  final int limitBytesTotal;
  final DateTime? createdAt;
  final DateTime? soldAt;
  final String? soldBy;
  final String? saleId;
  final bool isPrinted;
  final String? notes;
  final String? comment;
  final String? networkName;

  const UnifiedCardModel({
    required this.id,
    required this.username,
    required this.password,
    required this.profile,
    required this.price,
    required this.cardType,
    this.source = 'router',
    this.status = CardStatus.newCard,
    this.validity,
    this.uptime,
    this.bytesIn = 0,
    this.bytesOut = 0,
    this.limitUptime,
    this.limitBytesTotal = 0,
    this.createdAt,
    this.soldAt,
    this.soldBy,
    this.saleId,
    this.isPrinted = false,
    this.notes,
    this.comment,
    this.networkName,
  });

  bool get isUsed =>
      (uptime != null && uptime!.isNotEmpty && uptime != '0s') ||
      (bytesIn + bytesOut > 0);

  String get cardTypeTitle =>
      cardType == CardType.userMan ? 'User Manager' : 'Hotspot';

  bool get isExpired {
    if (limitBytesTotal > 0 && (bytesIn + bytesOut) >= limitBytesTotal) {
      return true;
    }
    return false;
  }

  VoucherCardData toVoucherCardData() {
    return VoucherCardData(
      username: username,
      password: password,
      profile: profile,
      price: price,
      validity: validity,
      networkName: networkName,
      cardType: cardType == CardType.hotspot ? 'hotspot' : 'usermanager',
      isPrinted: isPrinted,
    );
  }

  factory UnifiedCardModel.fromSubscriber(
    SubscriberModel sub, {
    double price = 0.0,
    bool isPrinted = false,
    String? networkName,
  }) {
    CardStatus status = CardStatus.newCard;
    if (sub.isDisabled) {
      status = CardStatus.disabled;
    } else if (sub.isExpired) {
      status = CardStatus.expired;
    } else if (sub.isActive) {
      status = CardStatus.active;
    } else if (isPrinted) {
      status = CardStatus.printed;
    }

    return UnifiedCardModel(
      id: sub.id,
      username: sub.username,
      password: sub.password ?? '',
      profile: sub.profile,
      price: price,
      cardType: sub.type == SubscriberType.userMan
          ? CardType.userMan
          : CardType.hotspot,
      source: 'router',
      status: status,
      uptime: sub.uptime,
      bytesIn: sub.bytesIn,
      bytesOut: sub.bytesOut,
      limitUptime: sub.limitUptime,
      limitBytesTotal: sub.limitBytesTotal,
      comment: sub.comment,
      isPrinted: isPrinted,
      networkName: networkName,
    );
  }

  factory UnifiedCardModel.fromVoucherCardData(
    VoucherCardData v, {
    String id = '',
    CardType cardType = CardType.hotspot,
    CardStatus status = CardStatus.newCard,
    bool isPrinted = false,
  }) {
    return UnifiedCardModel(
      id: id.isNotEmpty ? id : v.username,
      username: v.username,
      password: v.password,
      profile: v.profile,
      price: v.price,
      cardType: cardType,
      source: 'local_batch',
      status: isPrinted ? CardStatus.printed : status,
      validity: v.validity,
      networkName: v.networkName,
      isPrinted: isPrinted,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'password': password,
        'profile': profile,
        'price': price,
        'cardType': cardType.name,
        'source': source,
        'status': status.name,
        'validity': validity,
        'uptime': uptime,
        'bytesIn': bytesIn,
        'bytesOut': bytesOut,
        'limitUptime': limitUptime,
        'limitBytesTotal': limitBytesTotal,
        'createdAt': createdAt?.toIso8601String(),
        'soldAt': soldAt?.toIso8601String(),
        'soldBy': soldBy,
        'saleId': saleId,
        'isPrinted': isPrinted,
        'notes': notes,
        'comment': comment,
        'networkName': networkName,
      };

  factory UnifiedCardModel.fromJson(Map<String, dynamic> json) {
    return UnifiedCardModel(
      id: json['id'] as String? ?? '',
      username: json['username'] as String? ?? '',
      password: json['password'] as String? ?? '',
      profile: json['profile'] as String? ?? 'default',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      cardType:
          (json['cardType'] == 'userMan' || json['cardType'] == 'usermanager')
              ? CardType.userMan
              : CardType.hotspot,
      source: json['source'] as String? ?? 'router',
      status: CardStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => CardStatus.newCard,
      ),
      validity: json['validity'] as String?,
      uptime: json['uptime'] as String?,
      bytesIn: (json['bytesIn'] as num?)?.toInt() ?? 0,
      bytesOut: (json['bytesOut'] as num?)?.toInt() ?? 0,
      limitUptime: json['limitUptime'] as String?,
      limitBytesTotal: (json['limitBytesTotal'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      soldAt: json['soldAt'] != null
          ? DateTime.tryParse(json['soldAt'] as String)
          : null,
      soldBy: json['soldBy'] as String?,
      saleId: json['saleId'] as String?,
      isPrinted: json['isPrinted'] as bool? ?? false,
      notes: json['notes'] as String?,
      comment: json['comment'] as String?,
      networkName: json['networkName'] as String?,
    );
  }
}
