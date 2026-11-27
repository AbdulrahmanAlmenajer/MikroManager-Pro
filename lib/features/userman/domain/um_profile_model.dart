class UmProfileModel {
  final String id;
  final String name;
  final String? nameForUsers;
  final String? owner; // For RouterOS v6 (Customer/Owner)
  final String? validity;
  final double price;
  final int sharedUsers;
  final String? startsWhen;
  final String? overrideSharedUsers;
  final String? rateLimit;
  final String? uptimeLimit;
  final String? transferLimit;
  final int usersCount;
  final int activeSessionsCount;
  final bool isV7;

  const UmProfileModel({
    required this.id,
    required this.name,
    this.nameForUsers,
    this.owner,
    this.validity,
    this.price = 0.0,
    this.sharedUsers = 1,
    this.startsWhen,
    this.overrideSharedUsers,
    this.rateLimit,
    this.uptimeLimit,
    this.transferLimit,
    this.usersCount = 0,
    this.activeSessionsCount = 0,
    this.isV7 = true,
  });

  String get displayName =>
      (nameForUsers != null && nameForUsers!.isNotEmpty) ? nameForUsers! : name;

  factory UmProfileModel.fromMap(
    Map<String, dynamic> map, {
    bool isV7 = true,
    int usersCount = 0,
    int activeSessionsCount = 0,
    double? fallbackPrice,
  }) {
    double parsedPrice = 0.0;
    if (map['price'] != null) {
      parsedPrice = double.tryParse(map['price'].toString()) ?? 0.0;
    }
    if (parsedPrice == 0.0 && fallbackPrice != null) {
      parsedPrice = fallbackPrice;
    }

    int parsedSharedUsers = 1;
    if (map['shared-users'] != null) {
      parsedSharedUsers = int.tryParse(map['shared-users'].toString()) ?? 1;
    } else if (map['override-shared-users'] != null) {
      parsedSharedUsers =
          int.tryParse(map['override-shared-users'].toString()) ?? 1;
    }

    return UmProfileModel(
      id: map['.id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      nameForUsers: map['name-for-users']?.toString(),
      owner: map['owner']?.toString(),
      validity: map['validity']?.toString(),
      price: parsedPrice,
      sharedUsers: parsedSharedUsers,
      startsWhen: map['starts-when']?.toString(),
      overrideSharedUsers: map['override-shared-users']?.toString(),
      rateLimit: (map['rate-limit'] ?? map['rateLimit'])?.toString(),
      uptimeLimit: (map['uptime-limit'] ?? map['uptimeLimit'])?.toString(),
      transferLimit:
          (map['transfer-limit'] ?? map['transferLimit'])?.toString(),
      usersCount: usersCount,
      activeSessionsCount: activeSessionsCount,
      isV7: isV7,
    );
  }

  UmProfileModel copyWith({
    String? id,
    String? name,
    String? nameForUsers,
    String? owner,
    String? validity,
    double? price,
    int? sharedUsers,
    String? startsWhen,
    String? overrideSharedUsers,
    String? rateLimit,
    String? uptimeLimit,
    String? transferLimit,
    int? usersCount,
    int? activeSessionsCount,
    bool? isV7,
  }) {
    return UmProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      nameForUsers: nameForUsers ?? this.nameForUsers,
      owner: owner ?? this.owner,
      validity: validity ?? this.validity,
      price: price ?? this.price,
      sharedUsers: sharedUsers ?? this.sharedUsers,
      startsWhen: startsWhen ?? this.startsWhen,
      overrideSharedUsers: overrideSharedUsers ?? this.overrideSharedUsers,
      rateLimit: rateLimit ?? this.rateLimit,
      uptimeLimit: uptimeLimit ?? this.uptimeLimit,
      transferLimit: transferLimit ?? this.transferLimit,
      usersCount: usersCount ?? this.usersCount,
      activeSessionsCount: activeSessionsCount ?? this.activeSessionsCount,
      isV7: isV7 ?? this.isV7,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'nameForUsers': nameForUsers,
        'owner': owner,
        'validity': validity,
        'price': price,
        'sharedUsers': sharedUsers,
        'startsWhen': startsWhen,
        'overrideSharedUsers': overrideSharedUsers,
        'rateLimit': rateLimit,
        'rate-limit': rateLimit,
        'uptimeLimit': uptimeLimit,
        'uptime-limit': uptimeLimit,
        'transferLimit': transferLimit,
        'transfer-limit': transferLimit,
        'usersCount': usersCount,
        'activeSessionsCount': activeSessionsCount,
        'isV7': isV7,
      };

  factory UmProfileModel.fromJson(Map<String, dynamic> json) {
    return UmProfileModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      nameForUsers: json['nameForUsers'] as String?,
      owner: json['owner'] as String?,
      validity: json['validity'] as String?,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      sharedUsers: (json['sharedUsers'] as num?)?.toInt() ?? 1,
      startsWhen: json['startsWhen'] as String?,
      overrideSharedUsers: json['overrideSharedUsers'] as String?,
      rateLimit: (json['rateLimit'] ?? json['rate-limit']) as String?,
      uptimeLimit: (json['uptimeLimit'] ?? json['uptime-limit']) as String?,
      transferLimit:
          (json['transferLimit'] ?? json['transfer-limit']) as String?,
      usersCount: (json['usersCount'] as num?)?.toInt() ?? 0,
      activeSessionsCount: (json['activeSessionsCount'] as num?)?.toInt() ?? 0,
      isV7: json['isV7'] as bool? ?? true,
    );
  }
}
