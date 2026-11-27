// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $RoutersTableTable extends RoutersTable
    with TableInfo<$RoutersTableTable, RoutersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _ipAddressMeta =
      const VerificationMeta('ipAddress');
  @override
  late final GeneratedColumn<String> ipAddress = GeneratedColumn<String>(
      'ip_address', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _apiPortMeta =
      const VerificationMeta('apiPort');
  @override
  late final GeneratedColumn<int> apiPort = GeneratedColumn<int>(
      'api_port', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(8728));
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('admin'));
  static const VerificationMeta _useSslMeta = const VerificationMeta('useSsl');
  @override
  late final GeneratedColumn<bool> useSsl = GeneratedColumn<bool>(
      'use_ssl', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("use_ssl" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _useRestApiMeta =
      const VerificationMeta('useRestApi');
  @override
  late final GeneratedColumn<bool> useRestApi = GeneratedColumn<bool>(
      'use_rest_api', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("use_rest_api" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _routerOsVersionMeta =
      const VerificationMeta('routerOsVersion');
  @override
  late final GeneratedColumn<String> routerOsVersion = GeneratedColumn<String>(
      'router_os_version', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _lastConnectedAtMeta =
      const VerificationMeta('lastConnectedAt');
  @override
  late final GeneratedColumn<DateTime> lastConnectedAt =
      GeneratedColumn<DateTime>('last_connected_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        ipAddress,
        apiPort,
        username,
        useSsl,
        useRestApi,
        routerOsVersion,
        isActive,
        createdAt,
        lastConnectedAt,
        notes
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routers';
  @override
  VerificationContext validateIntegrity(Insertable<RoutersTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('ip_address')) {
      context.handle(_ipAddressMeta,
          ipAddress.isAcceptableOrUnknown(data['ip_address']!, _ipAddressMeta));
    } else if (isInserting) {
      context.missing(_ipAddressMeta);
    }
    if (data.containsKey('api_port')) {
      context.handle(_apiPortMeta,
          apiPort.isAcceptableOrUnknown(data['api_port']!, _apiPortMeta));
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    }
    if (data.containsKey('use_ssl')) {
      context.handle(_useSslMeta,
          useSsl.isAcceptableOrUnknown(data['use_ssl']!, _useSslMeta));
    }
    if (data.containsKey('use_rest_api')) {
      context.handle(
          _useRestApiMeta,
          useRestApi.isAcceptableOrUnknown(
              data['use_rest_api']!, _useRestApiMeta));
    }
    if (data.containsKey('router_os_version')) {
      context.handle(
          _routerOsVersionMeta,
          routerOsVersion.isAcceptableOrUnknown(
              data['router_os_version']!, _routerOsVersionMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('last_connected_at')) {
      context.handle(
          _lastConnectedAtMeta,
          lastConnectedAt.isAcceptableOrUnknown(
              data['last_connected_at']!, _lastConnectedAtMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RoutersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoutersTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      ipAddress: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ip_address'])!,
      apiPort: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}api_port'])!,
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
      useSsl: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}use_ssl'])!,
      useRestApi: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}use_rest_api'])!,
      routerOsVersion: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}router_os_version']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      lastConnectedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_connected_at']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $RoutersTableTable createAlias(String alias) {
    return $RoutersTableTable(attachedDatabase, alias);
  }
}

class RoutersTableData extends DataClass
    implements Insertable<RoutersTableData> {
  final int id;
  final String name;
  final String ipAddress;
  final int apiPort;
  final String username;
  final bool useSsl;
  final bool useRestApi;
  final String? routerOsVersion;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? lastConnectedAt;
  final String? notes;
  const RoutersTableData(
      {required this.id,
      required this.name,
      required this.ipAddress,
      required this.apiPort,
      required this.username,
      required this.useSsl,
      required this.useRestApi,
      this.routerOsVersion,
      required this.isActive,
      required this.createdAt,
      this.lastConnectedAt,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['ip_address'] = Variable<String>(ipAddress);
    map['api_port'] = Variable<int>(apiPort);
    map['username'] = Variable<String>(username);
    map['use_ssl'] = Variable<bool>(useSsl);
    map['use_rest_api'] = Variable<bool>(useRestApi);
    if (!nullToAbsent || routerOsVersion != null) {
      map['router_os_version'] = Variable<String>(routerOsVersion);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || lastConnectedAt != null) {
      map['last_connected_at'] = Variable<DateTime>(lastConnectedAt);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  RoutersTableCompanion toCompanion(bool nullToAbsent) {
    return RoutersTableCompanion(
      id: Value(id),
      name: Value(name),
      ipAddress: Value(ipAddress),
      apiPort: Value(apiPort),
      username: Value(username),
      useSsl: Value(useSsl),
      useRestApi: Value(useRestApi),
      routerOsVersion: routerOsVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(routerOsVersion),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      lastConnectedAt: lastConnectedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastConnectedAt),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory RoutersTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoutersTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      ipAddress: serializer.fromJson<String>(json['ipAddress']),
      apiPort: serializer.fromJson<int>(json['apiPort']),
      username: serializer.fromJson<String>(json['username']),
      useSsl: serializer.fromJson<bool>(json['useSsl']),
      useRestApi: serializer.fromJson<bool>(json['useRestApi']),
      routerOsVersion: serializer.fromJson<String?>(json['routerOsVersion']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastConnectedAt: serializer.fromJson<DateTime?>(json['lastConnectedAt']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'ipAddress': serializer.toJson<String>(ipAddress),
      'apiPort': serializer.toJson<int>(apiPort),
      'username': serializer.toJson<String>(username),
      'useSsl': serializer.toJson<bool>(useSsl),
      'useRestApi': serializer.toJson<bool>(useRestApi),
      'routerOsVersion': serializer.toJson<String?>(routerOsVersion),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastConnectedAt': serializer.toJson<DateTime?>(lastConnectedAt),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  RoutersTableData copyWith(
          {int? id,
          String? name,
          String? ipAddress,
          int? apiPort,
          String? username,
          bool? useSsl,
          bool? useRestApi,
          Value<String?> routerOsVersion = const Value.absent(),
          bool? isActive,
          DateTime? createdAt,
          Value<DateTime?> lastConnectedAt = const Value.absent(),
          Value<String?> notes = const Value.absent()}) =>
      RoutersTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        ipAddress: ipAddress ?? this.ipAddress,
        apiPort: apiPort ?? this.apiPort,
        username: username ?? this.username,
        useSsl: useSsl ?? this.useSsl,
        useRestApi: useRestApi ?? this.useRestApi,
        routerOsVersion: routerOsVersion.present
            ? routerOsVersion.value
            : this.routerOsVersion,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
        lastConnectedAt: lastConnectedAt.present
            ? lastConnectedAt.value
            : this.lastConnectedAt,
        notes: notes.present ? notes.value : this.notes,
      );
  RoutersTableData copyWithCompanion(RoutersTableCompanion data) {
    return RoutersTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      ipAddress: data.ipAddress.present ? data.ipAddress.value : this.ipAddress,
      apiPort: data.apiPort.present ? data.apiPort.value : this.apiPort,
      username: data.username.present ? data.username.value : this.username,
      useSsl: data.useSsl.present ? data.useSsl.value : this.useSsl,
      useRestApi:
          data.useRestApi.present ? data.useRestApi.value : this.useRestApi,
      routerOsVersion: data.routerOsVersion.present
          ? data.routerOsVersion.value
          : this.routerOsVersion,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastConnectedAt: data.lastConnectedAt.present
          ? data.lastConnectedAt.value
          : this.lastConnectedAt,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoutersTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('ipAddress: $ipAddress, ')
          ..write('apiPort: $apiPort, ')
          ..write('username: $username, ')
          ..write('useSsl: $useSsl, ')
          ..write('useRestApi: $useRestApi, ')
          ..write('routerOsVersion: $routerOsVersion, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastConnectedAt: $lastConnectedAt, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      ipAddress,
      apiPort,
      username,
      useSsl,
      useRestApi,
      routerOsVersion,
      isActive,
      createdAt,
      lastConnectedAt,
      notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoutersTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.ipAddress == this.ipAddress &&
          other.apiPort == this.apiPort &&
          other.username == this.username &&
          other.useSsl == this.useSsl &&
          other.useRestApi == this.useRestApi &&
          other.routerOsVersion == this.routerOsVersion &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.lastConnectedAt == this.lastConnectedAt &&
          other.notes == this.notes);
}

class RoutersTableCompanion extends UpdateCompanion<RoutersTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> ipAddress;
  final Value<int> apiPort;
  final Value<String> username;
  final Value<bool> useSsl;
  final Value<bool> useRestApi;
  final Value<String?> routerOsVersion;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime?> lastConnectedAt;
  final Value<String?> notes;
  const RoutersTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.ipAddress = const Value.absent(),
    this.apiPort = const Value.absent(),
    this.username = const Value.absent(),
    this.useSsl = const Value.absent(),
    this.useRestApi = const Value.absent(),
    this.routerOsVersion = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastConnectedAt = const Value.absent(),
    this.notes = const Value.absent(),
  });
  RoutersTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String ipAddress,
    this.apiPort = const Value.absent(),
    this.username = const Value.absent(),
    this.useSsl = const Value.absent(),
    this.useRestApi = const Value.absent(),
    this.routerOsVersion = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastConnectedAt = const Value.absent(),
    this.notes = const Value.absent(),
  })  : name = Value(name),
        ipAddress = Value(ipAddress);
  static Insertable<RoutersTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? ipAddress,
    Expression<int>? apiPort,
    Expression<String>? username,
    Expression<bool>? useSsl,
    Expression<bool>? useRestApi,
    Expression<String>? routerOsVersion,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastConnectedAt,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (ipAddress != null) 'ip_address': ipAddress,
      if (apiPort != null) 'api_port': apiPort,
      if (username != null) 'username': username,
      if (useSsl != null) 'use_ssl': useSsl,
      if (useRestApi != null) 'use_rest_api': useRestApi,
      if (routerOsVersion != null) 'router_os_version': routerOsVersion,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (lastConnectedAt != null) 'last_connected_at': lastConnectedAt,
      if (notes != null) 'notes': notes,
    });
  }

  RoutersTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? ipAddress,
      Value<int>? apiPort,
      Value<String>? username,
      Value<bool>? useSsl,
      Value<bool>? useRestApi,
      Value<String?>? routerOsVersion,
      Value<bool>? isActive,
      Value<DateTime>? createdAt,
      Value<DateTime?>? lastConnectedAt,
      Value<String?>? notes}) {
    return RoutersTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      ipAddress: ipAddress ?? this.ipAddress,
      apiPort: apiPort ?? this.apiPort,
      username: username ?? this.username,
      useSsl: useSsl ?? this.useSsl,
      useRestApi: useRestApi ?? this.useRestApi,
      routerOsVersion: routerOsVersion ?? this.routerOsVersion,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      lastConnectedAt: lastConnectedAt ?? this.lastConnectedAt,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (ipAddress.present) {
      map['ip_address'] = Variable<String>(ipAddress.value);
    }
    if (apiPort.present) {
      map['api_port'] = Variable<int>(apiPort.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (useSsl.present) {
      map['use_ssl'] = Variable<bool>(useSsl.value);
    }
    if (useRestApi.present) {
      map['use_rest_api'] = Variable<bool>(useRestApi.value);
    }
    if (routerOsVersion.present) {
      map['router_os_version'] = Variable<String>(routerOsVersion.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastConnectedAt.present) {
      map['last_connected_at'] = Variable<DateTime>(lastConnectedAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutersTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('ipAddress: $ipAddress, ')
          ..write('apiPort: $apiPort, ')
          ..write('username: $username, ')
          ..write('useSsl: $useSsl, ')
          ..write('useRestApi: $useRestApi, ')
          ..write('routerOsVersion: $routerOsVersion, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastConnectedAt: $lastConnectedAt, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $VoucherBatchesTableTable extends VoucherBatchesTable
    with TableInfo<$VoucherBatchesTableTable, VoucherBatchesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VoucherBatchesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _routerIdMeta =
      const VerificationMeta('routerId');
  @override
  late final GeneratedColumn<int> routerId = GeneratedColumn<int>(
      'router_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _profileNameMeta =
      const VerificationMeta('profileName');
  @override
  late final GeneratedColumn<String> profileName = GeneratedColumn<String>(
      'profile_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _prefixMeta = const VerificationMeta('prefix');
  @override
  late final GeneratedColumn<String> prefix = GeneratedColumn<String>(
      'prefix', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _codeLengthMeta =
      const VerificationMeta('codeLength');
  @override
  late final GeneratedColumn<int> codeLength = GeneratedColumn<int>(
      'code_length', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(8));
  static const VerificationMeta _vouchersJsonMeta =
      const VerificationMeta('vouchersJson');
  @override
  late final GeneratedColumn<String> vouchersJson = GeneratedColumn<String>(
      'vouchers_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _unitPriceMeta =
      const VerificationMeta('unitPrice');
  @override
  late final GeneratedColumn<double> unitPrice = GeneratedColumn<double>(
      'unit_price', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _totalAmountMeta =
      const VerificationMeta('totalAmount');
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
      'total_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('generated'));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _systemTypeMeta =
      const VerificationMeta('systemType');
  @override
  late final GeneratedColumn<String> systemType = GeneratedColumn<String>(
      'system_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('hotspot'));
  static const VerificationMeta _serialPrefixMeta =
      const VerificationMeta('serialPrefix');
  @override
  late final GeneratedColumn<String> serialPrefix = GeneratedColumn<String>(
      'serial_prefix', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _serialStartMeta =
      const VerificationMeta('serialStart');
  @override
  late final GeneratedColumn<int> serialStart = GeneratedColumn<int>(
      'serial_start', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _serialPaddingMeta =
      const VerificationMeta('serialPadding');
  @override
  late final GeneratedColumn<int> serialPadding = GeneratedColumn<int>(
      'serial_padding', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _serialEndMeta =
      const VerificationMeta('serialEnd');
  @override
  late final GeneratedColumn<int> serialEnd = GeneratedColumn<int>(
      'serial_end', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _generatedAtMeta =
      const VerificationMeta('generatedAt');
  @override
  late final GeneratedColumn<DateTime> generatedAt = GeneratedColumn<DateTime>(
      'generated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _printedAtMeta =
      const VerificationMeta('printedAt');
  @override
  late final GeneratedColumn<DateTime> printedAt = GeneratedColumn<DateTime>(
      'printed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        routerId,
        profileName,
        quantity,
        prefix,
        codeLength,
        vouchersJson,
        unitPrice,
        totalAmount,
        status,
        notes,
        systemType,
        serialPrefix,
        serialStart,
        serialPadding,
        serialEnd,
        generatedAt,
        printedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'voucher_batches';
  @override
  VerificationContext validateIntegrity(
      Insertable<VoucherBatchesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('router_id')) {
      context.handle(_routerIdMeta,
          routerId.isAcceptableOrUnknown(data['router_id']!, _routerIdMeta));
    } else if (isInserting) {
      context.missing(_routerIdMeta);
    }
    if (data.containsKey('profile_name')) {
      context.handle(
          _profileNameMeta,
          profileName.isAcceptableOrUnknown(
              data['profile_name']!, _profileNameMeta));
    } else if (isInserting) {
      context.missing(_profileNameMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('prefix')) {
      context.handle(_prefixMeta,
          prefix.isAcceptableOrUnknown(data['prefix']!, _prefixMeta));
    }
    if (data.containsKey('code_length')) {
      context.handle(
          _codeLengthMeta,
          codeLength.isAcceptableOrUnknown(
              data['code_length']!, _codeLengthMeta));
    }
    if (data.containsKey('vouchers_json')) {
      context.handle(
          _vouchersJsonMeta,
          vouchersJson.isAcceptableOrUnknown(
              data['vouchers_json']!, _vouchersJsonMeta));
    } else if (isInserting) {
      context.missing(_vouchersJsonMeta);
    }
    if (data.containsKey('unit_price')) {
      context.handle(_unitPriceMeta,
          unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta));
    }
    if (data.containsKey('total_amount')) {
      context.handle(
          _totalAmountMeta,
          totalAmount.isAcceptableOrUnknown(
              data['total_amount']!, _totalAmountMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('system_type')) {
      context.handle(
          _systemTypeMeta,
          systemType.isAcceptableOrUnknown(
              data['system_type']!, _systemTypeMeta));
    }
    if (data.containsKey('serial_prefix')) {
      context.handle(
          _serialPrefixMeta,
          serialPrefix.isAcceptableOrUnknown(
              data['serial_prefix']!, _serialPrefixMeta));
    }
    if (data.containsKey('serial_start')) {
      context.handle(
          _serialStartMeta,
          serialStart.isAcceptableOrUnknown(
              data['serial_start']!, _serialStartMeta));
    }
    if (data.containsKey('serial_padding')) {
      context.handle(
          _serialPaddingMeta,
          serialPadding.isAcceptableOrUnknown(
              data['serial_padding']!, _serialPaddingMeta));
    }
    if (data.containsKey('serial_end')) {
      context.handle(_serialEndMeta,
          serialEnd.isAcceptableOrUnknown(data['serial_end']!, _serialEndMeta));
    }
    if (data.containsKey('generated_at')) {
      context.handle(
          _generatedAtMeta,
          generatedAt.isAcceptableOrUnknown(
              data['generated_at']!, _generatedAtMeta));
    }
    if (data.containsKey('printed_at')) {
      context.handle(_printedAtMeta,
          printedAt.isAcceptableOrUnknown(data['printed_at']!, _printedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VoucherBatchesTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VoucherBatchesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      routerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}router_id'])!,
      profileName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_name'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
      prefix: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}prefix'])!,
      codeLength: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}code_length'])!,
      vouchersJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}vouchers_json'])!,
      unitPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}unit_price'])!,
      totalAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_amount'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      systemType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}system_type'])!,
      serialPrefix: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}serial_prefix']),
      serialStart: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}serial_start']),
      serialPadding: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}serial_padding']),
      serialEnd: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}serial_end']),
      generatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}generated_at'])!,
      printedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}printed_at']),
    );
  }

  @override
  $VoucherBatchesTableTable createAlias(String alias) {
    return $VoucherBatchesTableTable(attachedDatabase, alias);
  }
}

class VoucherBatchesTableData extends DataClass
    implements Insertable<VoucherBatchesTableData> {
  final int id;
  final int routerId;
  final String profileName;
  final int quantity;
  final String prefix;
  final int codeLength;
  final String vouchersJson;
  final double unitPrice;
  final double totalAmount;
  final String status;
  final String? notes;
  final String systemType;
  final String? serialPrefix;
  final int? serialStart;
  final int? serialPadding;
  final int? serialEnd;
  final DateTime generatedAt;
  final DateTime? printedAt;
  const VoucherBatchesTableData(
      {required this.id,
      required this.routerId,
      required this.profileName,
      required this.quantity,
      required this.prefix,
      required this.codeLength,
      required this.vouchersJson,
      required this.unitPrice,
      required this.totalAmount,
      required this.status,
      this.notes,
      required this.systemType,
      this.serialPrefix,
      this.serialStart,
      this.serialPadding,
      this.serialEnd,
      required this.generatedAt,
      this.printedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['router_id'] = Variable<int>(routerId);
    map['profile_name'] = Variable<String>(profileName);
    map['quantity'] = Variable<int>(quantity);
    map['prefix'] = Variable<String>(prefix);
    map['code_length'] = Variable<int>(codeLength);
    map['vouchers_json'] = Variable<String>(vouchersJson);
    map['unit_price'] = Variable<double>(unitPrice);
    map['total_amount'] = Variable<double>(totalAmount);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['system_type'] = Variable<String>(systemType);
    if (!nullToAbsent || serialPrefix != null) {
      map['serial_prefix'] = Variable<String>(serialPrefix);
    }
    if (!nullToAbsent || serialStart != null) {
      map['serial_start'] = Variable<int>(serialStart);
    }
    if (!nullToAbsent || serialPadding != null) {
      map['serial_padding'] = Variable<int>(serialPadding);
    }
    if (!nullToAbsent || serialEnd != null) {
      map['serial_end'] = Variable<int>(serialEnd);
    }
    map['generated_at'] = Variable<DateTime>(generatedAt);
    if (!nullToAbsent || printedAt != null) {
      map['printed_at'] = Variable<DateTime>(printedAt);
    }
    return map;
  }

  VoucherBatchesTableCompanion toCompanion(bool nullToAbsent) {
    return VoucherBatchesTableCompanion(
      id: Value(id),
      routerId: Value(routerId),
      profileName: Value(profileName),
      quantity: Value(quantity),
      prefix: Value(prefix),
      codeLength: Value(codeLength),
      vouchersJson: Value(vouchersJson),
      unitPrice: Value(unitPrice),
      totalAmount: Value(totalAmount),
      status: Value(status),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      systemType: Value(systemType),
      serialPrefix: serialPrefix == null && nullToAbsent
          ? const Value.absent()
          : Value(serialPrefix),
      serialStart: serialStart == null && nullToAbsent
          ? const Value.absent()
          : Value(serialStart),
      serialPadding: serialPadding == null && nullToAbsent
          ? const Value.absent()
          : Value(serialPadding),
      serialEnd: serialEnd == null && nullToAbsent
          ? const Value.absent()
          : Value(serialEnd),
      generatedAt: Value(generatedAt),
      printedAt: printedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(printedAt),
    );
  }

  factory VoucherBatchesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VoucherBatchesTableData(
      id: serializer.fromJson<int>(json['id']),
      routerId: serializer.fromJson<int>(json['routerId']),
      profileName: serializer.fromJson<String>(json['profileName']),
      quantity: serializer.fromJson<int>(json['quantity']),
      prefix: serializer.fromJson<String>(json['prefix']),
      codeLength: serializer.fromJson<int>(json['codeLength']),
      vouchersJson: serializer.fromJson<String>(json['vouchersJson']),
      unitPrice: serializer.fromJson<double>(json['unitPrice']),
      totalAmount: serializer.fromJson<double>(json['totalAmount']),
      status: serializer.fromJson<String>(json['status']),
      notes: serializer.fromJson<String?>(json['notes']),
      systemType: serializer.fromJson<String>(json['systemType']),
      serialPrefix: serializer.fromJson<String?>(json['serialPrefix']),
      serialStart: serializer.fromJson<int?>(json['serialStart']),
      serialPadding: serializer.fromJson<int?>(json['serialPadding']),
      serialEnd: serializer.fromJson<int?>(json['serialEnd']),
      generatedAt: serializer.fromJson<DateTime>(json['generatedAt']),
      printedAt: serializer.fromJson<DateTime?>(json['printedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'routerId': serializer.toJson<int>(routerId),
      'profileName': serializer.toJson<String>(profileName),
      'quantity': serializer.toJson<int>(quantity),
      'prefix': serializer.toJson<String>(prefix),
      'codeLength': serializer.toJson<int>(codeLength),
      'vouchersJson': serializer.toJson<String>(vouchersJson),
      'unitPrice': serializer.toJson<double>(unitPrice),
      'totalAmount': serializer.toJson<double>(totalAmount),
      'status': serializer.toJson<String>(status),
      'notes': serializer.toJson<String?>(notes),
      'systemType': serializer.toJson<String>(systemType),
      'serialPrefix': serializer.toJson<String?>(serialPrefix),
      'serialStart': serializer.toJson<int?>(serialStart),
      'serialPadding': serializer.toJson<int?>(serialPadding),
      'serialEnd': serializer.toJson<int?>(serialEnd),
      'generatedAt': serializer.toJson<DateTime>(generatedAt),
      'printedAt': serializer.toJson<DateTime?>(printedAt),
    };
  }

  VoucherBatchesTableData copyWith(
          {int? id,
          int? routerId,
          String? profileName,
          int? quantity,
          String? prefix,
          int? codeLength,
          String? vouchersJson,
          double? unitPrice,
          double? totalAmount,
          String? status,
          Value<String?> notes = const Value.absent(),
          String? systemType,
          Value<String?> serialPrefix = const Value.absent(),
          Value<int?> serialStart = const Value.absent(),
          Value<int?> serialPadding = const Value.absent(),
          Value<int?> serialEnd = const Value.absent(),
          DateTime? generatedAt,
          Value<DateTime?> printedAt = const Value.absent()}) =>
      VoucherBatchesTableData(
        id: id ?? this.id,
        routerId: routerId ?? this.routerId,
        profileName: profileName ?? this.profileName,
        quantity: quantity ?? this.quantity,
        prefix: prefix ?? this.prefix,
        codeLength: codeLength ?? this.codeLength,
        vouchersJson: vouchersJson ?? this.vouchersJson,
        unitPrice: unitPrice ?? this.unitPrice,
        totalAmount: totalAmount ?? this.totalAmount,
        status: status ?? this.status,
        notes: notes.present ? notes.value : this.notes,
        systemType: systemType ?? this.systemType,
        serialPrefix:
            serialPrefix.present ? serialPrefix.value : this.serialPrefix,
        serialStart: serialStart.present ? serialStart.value : this.serialStart,
        serialPadding:
            serialPadding.present ? serialPadding.value : this.serialPadding,
        serialEnd: serialEnd.present ? serialEnd.value : this.serialEnd,
        generatedAt: generatedAt ?? this.generatedAt,
        printedAt: printedAt.present ? printedAt.value : this.printedAt,
      );
  VoucherBatchesTableData copyWithCompanion(VoucherBatchesTableCompanion data) {
    return VoucherBatchesTableData(
      id: data.id.present ? data.id.value : this.id,
      routerId: data.routerId.present ? data.routerId.value : this.routerId,
      profileName:
          data.profileName.present ? data.profileName.value : this.profileName,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      prefix: data.prefix.present ? data.prefix.value : this.prefix,
      codeLength:
          data.codeLength.present ? data.codeLength.value : this.codeLength,
      vouchersJson: data.vouchersJson.present
          ? data.vouchersJson.value
          : this.vouchersJson,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      totalAmount:
          data.totalAmount.present ? data.totalAmount.value : this.totalAmount,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
      systemType:
          data.systemType.present ? data.systemType.value : this.systemType,
      serialPrefix: data.serialPrefix.present
          ? data.serialPrefix.value
          : this.serialPrefix,
      serialStart:
          data.serialStart.present ? data.serialStart.value : this.serialStart,
      serialPadding: data.serialPadding.present
          ? data.serialPadding.value
          : this.serialPadding,
      serialEnd: data.serialEnd.present ? data.serialEnd.value : this.serialEnd,
      generatedAt:
          data.generatedAt.present ? data.generatedAt.value : this.generatedAt,
      printedAt: data.printedAt.present ? data.printedAt.value : this.printedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VoucherBatchesTableData(')
          ..write('id: $id, ')
          ..write('routerId: $routerId, ')
          ..write('profileName: $profileName, ')
          ..write('quantity: $quantity, ')
          ..write('prefix: $prefix, ')
          ..write('codeLength: $codeLength, ')
          ..write('vouchersJson: $vouchersJson, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('systemType: $systemType, ')
          ..write('serialPrefix: $serialPrefix, ')
          ..write('serialStart: $serialStart, ')
          ..write('serialPadding: $serialPadding, ')
          ..write('serialEnd: $serialEnd, ')
          ..write('generatedAt: $generatedAt, ')
          ..write('printedAt: $printedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      routerId,
      profileName,
      quantity,
      prefix,
      codeLength,
      vouchersJson,
      unitPrice,
      totalAmount,
      status,
      notes,
      systemType,
      serialPrefix,
      serialStart,
      serialPadding,
      serialEnd,
      generatedAt,
      printedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VoucherBatchesTableData &&
          other.id == this.id &&
          other.routerId == this.routerId &&
          other.profileName == this.profileName &&
          other.quantity == this.quantity &&
          other.prefix == this.prefix &&
          other.codeLength == this.codeLength &&
          other.vouchersJson == this.vouchersJson &&
          other.unitPrice == this.unitPrice &&
          other.totalAmount == this.totalAmount &&
          other.status == this.status &&
          other.notes == this.notes &&
          other.systemType == this.systemType &&
          other.serialPrefix == this.serialPrefix &&
          other.serialStart == this.serialStart &&
          other.serialPadding == this.serialPadding &&
          other.serialEnd == this.serialEnd &&
          other.generatedAt == this.generatedAt &&
          other.printedAt == this.printedAt);
}

class VoucherBatchesTableCompanion
    extends UpdateCompanion<VoucherBatchesTableData> {
  final Value<int> id;
  final Value<int> routerId;
  final Value<String> profileName;
  final Value<int> quantity;
  final Value<String> prefix;
  final Value<int> codeLength;
  final Value<String> vouchersJson;
  final Value<double> unitPrice;
  final Value<double> totalAmount;
  final Value<String> status;
  final Value<String?> notes;
  final Value<String> systemType;
  final Value<String?> serialPrefix;
  final Value<int?> serialStart;
  final Value<int?> serialPadding;
  final Value<int?> serialEnd;
  final Value<DateTime> generatedAt;
  final Value<DateTime?> printedAt;
  const VoucherBatchesTableCompanion({
    this.id = const Value.absent(),
    this.routerId = const Value.absent(),
    this.profileName = const Value.absent(),
    this.quantity = const Value.absent(),
    this.prefix = const Value.absent(),
    this.codeLength = const Value.absent(),
    this.vouchersJson = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.systemType = const Value.absent(),
    this.serialPrefix = const Value.absent(),
    this.serialStart = const Value.absent(),
    this.serialPadding = const Value.absent(),
    this.serialEnd = const Value.absent(),
    this.generatedAt = const Value.absent(),
    this.printedAt = const Value.absent(),
  });
  VoucherBatchesTableCompanion.insert({
    this.id = const Value.absent(),
    required int routerId,
    required String profileName,
    required int quantity,
    this.prefix = const Value.absent(),
    this.codeLength = const Value.absent(),
    required String vouchersJson,
    this.unitPrice = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.systemType = const Value.absent(),
    this.serialPrefix = const Value.absent(),
    this.serialStart = const Value.absent(),
    this.serialPadding = const Value.absent(),
    this.serialEnd = const Value.absent(),
    this.generatedAt = const Value.absent(),
    this.printedAt = const Value.absent(),
  })  : routerId = Value(routerId),
        profileName = Value(profileName),
        quantity = Value(quantity),
        vouchersJson = Value(vouchersJson);
  static Insertable<VoucherBatchesTableData> custom({
    Expression<int>? id,
    Expression<int>? routerId,
    Expression<String>? profileName,
    Expression<int>? quantity,
    Expression<String>? prefix,
    Expression<int>? codeLength,
    Expression<String>? vouchersJson,
    Expression<double>? unitPrice,
    Expression<double>? totalAmount,
    Expression<String>? status,
    Expression<String>? notes,
    Expression<String>? systemType,
    Expression<String>? serialPrefix,
    Expression<int>? serialStart,
    Expression<int>? serialPadding,
    Expression<int>? serialEnd,
    Expression<DateTime>? generatedAt,
    Expression<DateTime>? printedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (routerId != null) 'router_id': routerId,
      if (profileName != null) 'profile_name': profileName,
      if (quantity != null) 'quantity': quantity,
      if (prefix != null) 'prefix': prefix,
      if (codeLength != null) 'code_length': codeLength,
      if (vouchersJson != null) 'vouchers_json': vouchersJson,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (systemType != null) 'system_type': systemType,
      if (serialPrefix != null) 'serial_prefix': serialPrefix,
      if (serialStart != null) 'serial_start': serialStart,
      if (serialPadding != null) 'serial_padding': serialPadding,
      if (serialEnd != null) 'serial_end': serialEnd,
      if (generatedAt != null) 'generated_at': generatedAt,
      if (printedAt != null) 'printed_at': printedAt,
    });
  }

  VoucherBatchesTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? routerId,
      Value<String>? profileName,
      Value<int>? quantity,
      Value<String>? prefix,
      Value<int>? codeLength,
      Value<String>? vouchersJson,
      Value<double>? unitPrice,
      Value<double>? totalAmount,
      Value<String>? status,
      Value<String?>? notes,
      Value<String>? systemType,
      Value<String?>? serialPrefix,
      Value<int?>? serialStart,
      Value<int?>? serialPadding,
      Value<int?>? serialEnd,
      Value<DateTime>? generatedAt,
      Value<DateTime?>? printedAt}) {
    return VoucherBatchesTableCompanion(
      id: id ?? this.id,
      routerId: routerId ?? this.routerId,
      profileName: profileName ?? this.profileName,
      quantity: quantity ?? this.quantity,
      prefix: prefix ?? this.prefix,
      codeLength: codeLength ?? this.codeLength,
      vouchersJson: vouchersJson ?? this.vouchersJson,
      unitPrice: unitPrice ?? this.unitPrice,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      systemType: systemType ?? this.systemType,
      serialPrefix: serialPrefix ?? this.serialPrefix,
      serialStart: serialStart ?? this.serialStart,
      serialPadding: serialPadding ?? this.serialPadding,
      serialEnd: serialEnd ?? this.serialEnd,
      generatedAt: generatedAt ?? this.generatedAt,
      printedAt: printedAt ?? this.printedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (routerId.present) {
      map['router_id'] = Variable<int>(routerId.value);
    }
    if (profileName.present) {
      map['profile_name'] = Variable<String>(profileName.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (prefix.present) {
      map['prefix'] = Variable<String>(prefix.value);
    }
    if (codeLength.present) {
      map['code_length'] = Variable<int>(codeLength.value);
    }
    if (vouchersJson.present) {
      map['vouchers_json'] = Variable<String>(vouchersJson.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<double>(unitPrice.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (systemType.present) {
      map['system_type'] = Variable<String>(systemType.value);
    }
    if (serialPrefix.present) {
      map['serial_prefix'] = Variable<String>(serialPrefix.value);
    }
    if (serialStart.present) {
      map['serial_start'] = Variable<int>(serialStart.value);
    }
    if (serialPadding.present) {
      map['serial_padding'] = Variable<int>(serialPadding.value);
    }
    if (serialEnd.present) {
      map['serial_end'] = Variable<int>(serialEnd.value);
    }
    if (generatedAt.present) {
      map['generated_at'] = Variable<DateTime>(generatedAt.value);
    }
    if (printedAt.present) {
      map['printed_at'] = Variable<DateTime>(printedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VoucherBatchesTableCompanion(')
          ..write('id: $id, ')
          ..write('routerId: $routerId, ')
          ..write('profileName: $profileName, ')
          ..write('quantity: $quantity, ')
          ..write('prefix: $prefix, ')
          ..write('codeLength: $codeLength, ')
          ..write('vouchersJson: $vouchersJson, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('systemType: $systemType, ')
          ..write('serialPrefix: $serialPrefix, ')
          ..write('serialStart: $serialStart, ')
          ..write('serialPadding: $serialPadding, ')
          ..write('serialEnd: $serialEnd, ')
          ..write('generatedAt: $generatedAt, ')
          ..write('printedAt: $printedAt')
          ..write(')'))
        .toString();
  }
}

class $VoucherTemplatesTableTable extends VoucherTemplatesTable
    with TableInfo<$VoucherTemplatesTableTable, VoucherTemplatesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VoucherTemplatesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _paperSizeMeta =
      const VerificationMeta('paperSize');
  @override
  late final GeneratedColumn<String> paperSize = GeneratedColumn<String>(
      'paper_size', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('A4'));
  static const VerificationMeta _cardsPerRowMeta =
      const VerificationMeta('cardsPerRow');
  @override
  late final GeneratedColumn<int> cardsPerRow = GeneratedColumn<int>(
      'cards_per_row', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(3));
  static const VerificationMeta _cardsPerPageMeta =
      const VerificationMeta('cardsPerPage');
  @override
  late final GeneratedColumn<int> cardsPerPage = GeneratedColumn<int>(
      'cards_per_page', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(12));
  static const VerificationMeta _cardWidthMmMeta =
      const VerificationMeta('cardWidthMm');
  @override
  late final GeneratedColumn<double> cardWidthMm = GeneratedColumn<double>(
      'card_width_mm', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _cardHeightMmMeta =
      const VerificationMeta('cardHeightMm');
  @override
  late final GeneratedColumn<double> cardHeightMm = GeneratedColumn<double>(
      'card_height_mm', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _marginMmMeta =
      const VerificationMeta('marginMm');
  @override
  late final GeneratedColumn<double> marginMm = GeneratedColumn<double>(
      'margin_mm', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(4.0));
  static const VerificationMeta _fontSizeMeta =
      const VerificationMeta('fontSize');
  @override
  late final GeneratedColumn<double> fontSize = GeneratedColumn<double>(
      'font_size', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(10.0));
  static const VerificationMeta _titleFontSizeMeta =
      const VerificationMeta('titleFontSize');
  @override
  late final GeneratedColumn<double> titleFontSize = GeneratedColumn<double>(
      'title_font_size', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(12.0));
  static const VerificationMeta _primaryColorHexMeta =
      const VerificationMeta('primaryColorHex');
  @override
  late final GeneratedColumn<int> primaryColorHex = GeneratedColumn<int>(
      'primary_color_hex', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0xFF0F172A));
  static const VerificationMeta _backgroundColorHexMeta =
      const VerificationMeta('backgroundColorHex');
  @override
  late final GeneratedColumn<int> backgroundColorHex = GeneratedColumn<int>(
      'background_color_hex', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0xFFFFFFFF));
  static const VerificationMeta _textColorHexMeta =
      const VerificationMeta('textColorHex');
  @override
  late final GeneratedColumn<int> textColorHex = GeneratedColumn<int>(
      'text_color_hex', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0xFF1E293B));
  static const VerificationMeta _titleColorHexMeta =
      const VerificationMeta('titleColorHex');
  @override
  late final GeneratedColumn<int> titleColorHex = GeneratedColumn<int>(
      'title_color_hex', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0xFF0F172A));
  static const VerificationMeta _borderColorHexMeta =
      const VerificationMeta('borderColorHex');
  @override
  late final GeneratedColumn<int> borderColorHex = GeneratedColumn<int>(
      'border_color_hex', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0xFFCBD5E1));
  static const VerificationMeta _borderWidthMeta =
      const VerificationMeta('borderWidth');
  @override
  late final GeneratedColumn<double> borderWidth = GeneratedColumn<double>(
      'border_width', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(1.0));
  static const VerificationMeta _borderRadiusMeta =
      const VerificationMeta('borderRadius');
  @override
  late final GeneratedColumn<double> borderRadius = GeneratedColumn<double>(
      'border_radius', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(8.0));
  static const VerificationMeta _showQrCodeMeta =
      const VerificationMeta('showQrCode');
  @override
  late final GeneratedColumn<bool> showQrCode = GeneratedColumn<bool>(
      'show_qr_code', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("show_qr_code" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _showBarcodeMeta =
      const VerificationMeta('showBarcode');
  @override
  late final GeneratedColumn<bool> showBarcode = GeneratedColumn<bool>(
      'show_barcode', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("show_barcode" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _showLogoMeta =
      const VerificationMeta('showLogo');
  @override
  late final GeneratedColumn<bool> showLogo = GeneratedColumn<bool>(
      'show_logo', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("show_logo" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _logoPathMeta =
      const VerificationMeta('logoPath');
  @override
  late final GeneratedColumn<String> logoPath = GeneratedColumn<String>(
      'logo_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _headerTextMeta =
      const VerificationMeta('headerText');
  @override
  late final GeneratedColumn<String> headerText = GeneratedColumn<String>(
      'header_text', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _footerTextMeta =
      const VerificationMeta('footerText');
  @override
  late final GeneratedColumn<String> footerText = GeneratedColumn<String>(
      'footer_text', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fontFamilyMeta =
      const VerificationMeta('fontFamily');
  @override
  late final GeneratedColumn<String> fontFamily = GeneratedColumn<String>(
      'font_family', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Cairo'));
  static const VerificationMeta _showProfileMeta =
      const VerificationMeta('showProfile');
  @override
  late final GeneratedColumn<bool> showProfile = GeneratedColumn<bool>(
      'show_profile', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("show_profile" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _showPriceMeta =
      const VerificationMeta('showPrice');
  @override
  late final GeneratedColumn<bool> showPrice = GeneratedColumn<bool>(
      'show_price', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("show_price" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _showValidityMeta =
      const VerificationMeta('showValidity');
  @override
  late final GeneratedColumn<bool> showValidity = GeneratedColumn<bool>(
      'show_validity', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("show_validity" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _showUsernameMeta =
      const VerificationMeta('showUsername');
  @override
  late final GeneratedColumn<bool> showUsername = GeneratedColumn<bool>(
      'show_username', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("show_username" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _showPasswordMeta =
      const VerificationMeta('showPassword');
  @override
  late final GeneratedColumn<bool> showPassword = GeneratedColumn<bool>(
      'show_password', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("show_password" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _showInstructionsMeta =
      const VerificationMeta('showInstructions');
  @override
  late final GeneratedColumn<bool> showInstructions = GeneratedColumn<bool>(
      'show_instructions', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("show_instructions" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _instructionsTextMeta =
      const VerificationMeta('instructionsText');
  @override
  late final GeneratedColumn<String> instructionsText = GeneratedColumn<String>(
      'instructions_text', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _contactPhoneMeta =
      const VerificationMeta('contactPhone');
  @override
  late final GeneratedColumn<String> contactPhone = GeneratedColumn<String>(
      'contact_phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _customTextMeta =
      const VerificationMeta('customText');
  @override
  late final GeneratedColumn<String> customText = GeneratedColumn<String>(
      'custom_text', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _targetCardTypeMeta =
      const VerificationMeta('targetCardType');
  @override
  late final GeneratedColumn<String> targetCardType = GeneratedColumn<String>(
      'target_card_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('all'));
  static const VerificationMeta _configJsonMeta =
      const VerificationMeta('configJson');
  @override
  late final GeneratedColumn<String> configJson = GeneratedColumn<String>(
      'config_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isDefaultMeta =
      const VerificationMeta('isDefault');
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
      'is_default', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_default" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        paperSize,
        cardsPerRow,
        cardsPerPage,
        cardWidthMm,
        cardHeightMm,
        marginMm,
        fontSize,
        titleFontSize,
        primaryColorHex,
        backgroundColorHex,
        textColorHex,
        titleColorHex,
        borderColorHex,
        borderWidth,
        borderRadius,
        showQrCode,
        showBarcode,
        showLogo,
        logoPath,
        headerText,
        footerText,
        fontFamily,
        showProfile,
        showPrice,
        showValidity,
        showUsername,
        showPassword,
        showInstructions,
        instructionsText,
        contactPhone,
        customText,
        targetCardType,
        configJson,
        isDefault,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'voucher_templates';
  @override
  VerificationContext validateIntegrity(
      Insertable<VoucherTemplatesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('paper_size')) {
      context.handle(_paperSizeMeta,
          paperSize.isAcceptableOrUnknown(data['paper_size']!, _paperSizeMeta));
    }
    if (data.containsKey('cards_per_row')) {
      context.handle(
          _cardsPerRowMeta,
          cardsPerRow.isAcceptableOrUnknown(
              data['cards_per_row']!, _cardsPerRowMeta));
    }
    if (data.containsKey('cards_per_page')) {
      context.handle(
          _cardsPerPageMeta,
          cardsPerPage.isAcceptableOrUnknown(
              data['cards_per_page']!, _cardsPerPageMeta));
    }
    if (data.containsKey('card_width_mm')) {
      context.handle(
          _cardWidthMmMeta,
          cardWidthMm.isAcceptableOrUnknown(
              data['card_width_mm']!, _cardWidthMmMeta));
    }
    if (data.containsKey('card_height_mm')) {
      context.handle(
          _cardHeightMmMeta,
          cardHeightMm.isAcceptableOrUnknown(
              data['card_height_mm']!, _cardHeightMmMeta));
    }
    if (data.containsKey('margin_mm')) {
      context.handle(_marginMmMeta,
          marginMm.isAcceptableOrUnknown(data['margin_mm']!, _marginMmMeta));
    }
    if (data.containsKey('font_size')) {
      context.handle(_fontSizeMeta,
          fontSize.isAcceptableOrUnknown(data['font_size']!, _fontSizeMeta));
    }
    if (data.containsKey('title_font_size')) {
      context.handle(
          _titleFontSizeMeta,
          titleFontSize.isAcceptableOrUnknown(
              data['title_font_size']!, _titleFontSizeMeta));
    }
    if (data.containsKey('primary_color_hex')) {
      context.handle(
          _primaryColorHexMeta,
          primaryColorHex.isAcceptableOrUnknown(
              data['primary_color_hex']!, _primaryColorHexMeta));
    }
    if (data.containsKey('background_color_hex')) {
      context.handle(
          _backgroundColorHexMeta,
          backgroundColorHex.isAcceptableOrUnknown(
              data['background_color_hex']!, _backgroundColorHexMeta));
    }
    if (data.containsKey('text_color_hex')) {
      context.handle(
          _textColorHexMeta,
          textColorHex.isAcceptableOrUnknown(
              data['text_color_hex']!, _textColorHexMeta));
    }
    if (data.containsKey('title_color_hex')) {
      context.handle(
          _titleColorHexMeta,
          titleColorHex.isAcceptableOrUnknown(
              data['title_color_hex']!, _titleColorHexMeta));
    }
    if (data.containsKey('border_color_hex')) {
      context.handle(
          _borderColorHexMeta,
          borderColorHex.isAcceptableOrUnknown(
              data['border_color_hex']!, _borderColorHexMeta));
    }
    if (data.containsKey('border_width')) {
      context.handle(
          _borderWidthMeta,
          borderWidth.isAcceptableOrUnknown(
              data['border_width']!, _borderWidthMeta));
    }
    if (data.containsKey('border_radius')) {
      context.handle(
          _borderRadiusMeta,
          borderRadius.isAcceptableOrUnknown(
              data['border_radius']!, _borderRadiusMeta));
    }
    if (data.containsKey('show_qr_code')) {
      context.handle(
          _showQrCodeMeta,
          showQrCode.isAcceptableOrUnknown(
              data['show_qr_code']!, _showQrCodeMeta));
    }
    if (data.containsKey('show_barcode')) {
      context.handle(
          _showBarcodeMeta,
          showBarcode.isAcceptableOrUnknown(
              data['show_barcode']!, _showBarcodeMeta));
    }
    if (data.containsKey('show_logo')) {
      context.handle(_showLogoMeta,
          showLogo.isAcceptableOrUnknown(data['show_logo']!, _showLogoMeta));
    }
    if (data.containsKey('logo_path')) {
      context.handle(_logoPathMeta,
          logoPath.isAcceptableOrUnknown(data['logo_path']!, _logoPathMeta));
    }
    if (data.containsKey('header_text')) {
      context.handle(
          _headerTextMeta,
          headerText.isAcceptableOrUnknown(
              data['header_text']!, _headerTextMeta));
    }
    if (data.containsKey('footer_text')) {
      context.handle(
          _footerTextMeta,
          footerText.isAcceptableOrUnknown(
              data['footer_text']!, _footerTextMeta));
    }
    if (data.containsKey('font_family')) {
      context.handle(
          _fontFamilyMeta,
          fontFamily.isAcceptableOrUnknown(
              data['font_family']!, _fontFamilyMeta));
    }
    if (data.containsKey('show_profile')) {
      context.handle(
          _showProfileMeta,
          showProfile.isAcceptableOrUnknown(
              data['show_profile']!, _showProfileMeta));
    }
    if (data.containsKey('show_price')) {
      context.handle(_showPriceMeta,
          showPrice.isAcceptableOrUnknown(data['show_price']!, _showPriceMeta));
    }
    if (data.containsKey('show_validity')) {
      context.handle(
          _showValidityMeta,
          showValidity.isAcceptableOrUnknown(
              data['show_validity']!, _showValidityMeta));
    }
    if (data.containsKey('show_username')) {
      context.handle(
          _showUsernameMeta,
          showUsername.isAcceptableOrUnknown(
              data['show_username']!, _showUsernameMeta));
    }
    if (data.containsKey('show_password')) {
      context.handle(
          _showPasswordMeta,
          showPassword.isAcceptableOrUnknown(
              data['show_password']!, _showPasswordMeta));
    }
    if (data.containsKey('show_instructions')) {
      context.handle(
          _showInstructionsMeta,
          showInstructions.isAcceptableOrUnknown(
              data['show_instructions']!, _showInstructionsMeta));
    }
    if (data.containsKey('instructions_text')) {
      context.handle(
          _instructionsTextMeta,
          instructionsText.isAcceptableOrUnknown(
              data['instructions_text']!, _instructionsTextMeta));
    }
    if (data.containsKey('contact_phone')) {
      context.handle(
          _contactPhoneMeta,
          contactPhone.isAcceptableOrUnknown(
              data['contact_phone']!, _contactPhoneMeta));
    }
    if (data.containsKey('custom_text')) {
      context.handle(
          _customTextMeta,
          customText.isAcceptableOrUnknown(
              data['custom_text']!, _customTextMeta));
    }
    if (data.containsKey('target_card_type')) {
      context.handle(
          _targetCardTypeMeta,
          targetCardType.isAcceptableOrUnknown(
              data['target_card_type']!, _targetCardTypeMeta));
    }
    if (data.containsKey('config_json')) {
      context.handle(
          _configJsonMeta,
          configJson.isAcceptableOrUnknown(
              data['config_json']!, _configJsonMeta));
    }
    if (data.containsKey('is_default')) {
      context.handle(_isDefaultMeta,
          isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VoucherTemplatesTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VoucherTemplatesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      paperSize: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}paper_size'])!,
      cardsPerRow: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cards_per_row'])!,
      cardsPerPage: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cards_per_page'])!,
      cardWidthMm: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}card_width_mm']),
      cardHeightMm: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}card_height_mm']),
      marginMm: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}margin_mm'])!,
      fontSize: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}font_size'])!,
      titleFontSize: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}title_font_size'])!,
      primaryColorHex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}primary_color_hex'])!,
      backgroundColorHex: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}background_color_hex'])!,
      textColorHex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}text_color_hex'])!,
      titleColorHex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}title_color_hex'])!,
      borderColorHex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}border_color_hex'])!,
      borderWidth: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}border_width'])!,
      borderRadius: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}border_radius'])!,
      showQrCode: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show_qr_code'])!,
      showBarcode: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show_barcode'])!,
      showLogo: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show_logo'])!,
      logoPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}logo_path']),
      headerText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}header_text']),
      footerText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}footer_text']),
      fontFamily: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}font_family'])!,
      showProfile: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show_profile'])!,
      showPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show_price'])!,
      showValidity: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show_validity'])!,
      showUsername: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show_username'])!,
      showPassword: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show_password'])!,
      showInstructions: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}show_instructions'])!,
      instructionsText: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}instructions_text']),
      contactPhone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}contact_phone']),
      customText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}custom_text']),
      targetCardType: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}target_card_type'])!,
      configJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}config_json']),
      isDefault: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_default'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $VoucherTemplatesTableTable createAlias(String alias) {
    return $VoucherTemplatesTableTable(attachedDatabase, alias);
  }
}

class VoucherTemplatesTableData extends DataClass
    implements Insertable<VoucherTemplatesTableData> {
  final int id;
  final String name;
  final String paperSize;
  final int cardsPerRow;
  final int cardsPerPage;
  final double? cardWidthMm;
  final double? cardHeightMm;
  final double marginMm;
  final double fontSize;
  final double titleFontSize;
  final int primaryColorHex;
  final int backgroundColorHex;
  final int textColorHex;
  final int titleColorHex;
  final int borderColorHex;
  final double borderWidth;
  final double borderRadius;
  final bool showQrCode;
  final bool showBarcode;
  final bool showLogo;
  final String? logoPath;
  final String? headerText;
  final String? footerText;
  final String fontFamily;
  final bool showProfile;
  final bool showPrice;
  final bool showValidity;
  final bool showUsername;
  final bool showPassword;
  final bool showInstructions;
  final String? instructionsText;
  final String? contactPhone;
  final String? customText;
  final String targetCardType;
  final String? configJson;
  final bool isDefault;
  final DateTime createdAt;
  const VoucherTemplatesTableData(
      {required this.id,
      required this.name,
      required this.paperSize,
      required this.cardsPerRow,
      required this.cardsPerPage,
      this.cardWidthMm,
      this.cardHeightMm,
      required this.marginMm,
      required this.fontSize,
      required this.titleFontSize,
      required this.primaryColorHex,
      required this.backgroundColorHex,
      required this.textColorHex,
      required this.titleColorHex,
      required this.borderColorHex,
      required this.borderWidth,
      required this.borderRadius,
      required this.showQrCode,
      required this.showBarcode,
      required this.showLogo,
      this.logoPath,
      this.headerText,
      this.footerText,
      required this.fontFamily,
      required this.showProfile,
      required this.showPrice,
      required this.showValidity,
      required this.showUsername,
      required this.showPassword,
      required this.showInstructions,
      this.instructionsText,
      this.contactPhone,
      this.customText,
      required this.targetCardType,
      this.configJson,
      required this.isDefault,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['paper_size'] = Variable<String>(paperSize);
    map['cards_per_row'] = Variable<int>(cardsPerRow);
    map['cards_per_page'] = Variable<int>(cardsPerPage);
    if (!nullToAbsent || cardWidthMm != null) {
      map['card_width_mm'] = Variable<double>(cardWidthMm);
    }
    if (!nullToAbsent || cardHeightMm != null) {
      map['card_height_mm'] = Variable<double>(cardHeightMm);
    }
    map['margin_mm'] = Variable<double>(marginMm);
    map['font_size'] = Variable<double>(fontSize);
    map['title_font_size'] = Variable<double>(titleFontSize);
    map['primary_color_hex'] = Variable<int>(primaryColorHex);
    map['background_color_hex'] = Variable<int>(backgroundColorHex);
    map['text_color_hex'] = Variable<int>(textColorHex);
    map['title_color_hex'] = Variable<int>(titleColorHex);
    map['border_color_hex'] = Variable<int>(borderColorHex);
    map['border_width'] = Variable<double>(borderWidth);
    map['border_radius'] = Variable<double>(borderRadius);
    map['show_qr_code'] = Variable<bool>(showQrCode);
    map['show_barcode'] = Variable<bool>(showBarcode);
    map['show_logo'] = Variable<bool>(showLogo);
    if (!nullToAbsent || logoPath != null) {
      map['logo_path'] = Variable<String>(logoPath);
    }
    if (!nullToAbsent || headerText != null) {
      map['header_text'] = Variable<String>(headerText);
    }
    if (!nullToAbsent || footerText != null) {
      map['footer_text'] = Variable<String>(footerText);
    }
    map['font_family'] = Variable<String>(fontFamily);
    map['show_profile'] = Variable<bool>(showProfile);
    map['show_price'] = Variable<bool>(showPrice);
    map['show_validity'] = Variable<bool>(showValidity);
    map['show_username'] = Variable<bool>(showUsername);
    map['show_password'] = Variable<bool>(showPassword);
    map['show_instructions'] = Variable<bool>(showInstructions);
    if (!nullToAbsent || instructionsText != null) {
      map['instructions_text'] = Variable<String>(instructionsText);
    }
    if (!nullToAbsent || contactPhone != null) {
      map['contact_phone'] = Variable<String>(contactPhone);
    }
    if (!nullToAbsent || customText != null) {
      map['custom_text'] = Variable<String>(customText);
    }
    map['target_card_type'] = Variable<String>(targetCardType);
    if (!nullToAbsent || configJson != null) {
      map['config_json'] = Variable<String>(configJson);
    }
    map['is_default'] = Variable<bool>(isDefault);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  VoucherTemplatesTableCompanion toCompanion(bool nullToAbsent) {
    return VoucherTemplatesTableCompanion(
      id: Value(id),
      name: Value(name),
      paperSize: Value(paperSize),
      cardsPerRow: Value(cardsPerRow),
      cardsPerPage: Value(cardsPerPage),
      cardWidthMm: cardWidthMm == null && nullToAbsent
          ? const Value.absent()
          : Value(cardWidthMm),
      cardHeightMm: cardHeightMm == null && nullToAbsent
          ? const Value.absent()
          : Value(cardHeightMm),
      marginMm: Value(marginMm),
      fontSize: Value(fontSize),
      titleFontSize: Value(titleFontSize),
      primaryColorHex: Value(primaryColorHex),
      backgroundColorHex: Value(backgroundColorHex),
      textColorHex: Value(textColorHex),
      titleColorHex: Value(titleColorHex),
      borderColorHex: Value(borderColorHex),
      borderWidth: Value(borderWidth),
      borderRadius: Value(borderRadius),
      showQrCode: Value(showQrCode),
      showBarcode: Value(showBarcode),
      showLogo: Value(showLogo),
      logoPath: logoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(logoPath),
      headerText: headerText == null && nullToAbsent
          ? const Value.absent()
          : Value(headerText),
      footerText: footerText == null && nullToAbsent
          ? const Value.absent()
          : Value(footerText),
      fontFamily: Value(fontFamily),
      showProfile: Value(showProfile),
      showPrice: Value(showPrice),
      showValidity: Value(showValidity),
      showUsername: Value(showUsername),
      showPassword: Value(showPassword),
      showInstructions: Value(showInstructions),
      instructionsText: instructionsText == null && nullToAbsent
          ? const Value.absent()
          : Value(instructionsText),
      contactPhone: contactPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(contactPhone),
      customText: customText == null && nullToAbsent
          ? const Value.absent()
          : Value(customText),
      targetCardType: Value(targetCardType),
      configJson: configJson == null && nullToAbsent
          ? const Value.absent()
          : Value(configJson),
      isDefault: Value(isDefault),
      createdAt: Value(createdAt),
    );
  }

  factory VoucherTemplatesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VoucherTemplatesTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      paperSize: serializer.fromJson<String>(json['paperSize']),
      cardsPerRow: serializer.fromJson<int>(json['cardsPerRow']),
      cardsPerPage: serializer.fromJson<int>(json['cardsPerPage']),
      cardWidthMm: serializer.fromJson<double?>(json['cardWidthMm']),
      cardHeightMm: serializer.fromJson<double?>(json['cardHeightMm']),
      marginMm: serializer.fromJson<double>(json['marginMm']),
      fontSize: serializer.fromJson<double>(json['fontSize']),
      titleFontSize: serializer.fromJson<double>(json['titleFontSize']),
      primaryColorHex: serializer.fromJson<int>(json['primaryColorHex']),
      backgroundColorHex: serializer.fromJson<int>(json['backgroundColorHex']),
      textColorHex: serializer.fromJson<int>(json['textColorHex']),
      titleColorHex: serializer.fromJson<int>(json['titleColorHex']),
      borderColorHex: serializer.fromJson<int>(json['borderColorHex']),
      borderWidth: serializer.fromJson<double>(json['borderWidth']),
      borderRadius: serializer.fromJson<double>(json['borderRadius']),
      showQrCode: serializer.fromJson<bool>(json['showQrCode']),
      showBarcode: serializer.fromJson<bool>(json['showBarcode']),
      showLogo: serializer.fromJson<bool>(json['showLogo']),
      logoPath: serializer.fromJson<String?>(json['logoPath']),
      headerText: serializer.fromJson<String?>(json['headerText']),
      footerText: serializer.fromJson<String?>(json['footerText']),
      fontFamily: serializer.fromJson<String>(json['fontFamily']),
      showProfile: serializer.fromJson<bool>(json['showProfile']),
      showPrice: serializer.fromJson<bool>(json['showPrice']),
      showValidity: serializer.fromJson<bool>(json['showValidity']),
      showUsername: serializer.fromJson<bool>(json['showUsername']),
      showPassword: serializer.fromJson<bool>(json['showPassword']),
      showInstructions: serializer.fromJson<bool>(json['showInstructions']),
      instructionsText: serializer.fromJson<String?>(json['instructionsText']),
      contactPhone: serializer.fromJson<String?>(json['contactPhone']),
      customText: serializer.fromJson<String?>(json['customText']),
      targetCardType: serializer.fromJson<String>(json['targetCardType']),
      configJson: serializer.fromJson<String?>(json['configJson']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'paperSize': serializer.toJson<String>(paperSize),
      'cardsPerRow': serializer.toJson<int>(cardsPerRow),
      'cardsPerPage': serializer.toJson<int>(cardsPerPage),
      'cardWidthMm': serializer.toJson<double?>(cardWidthMm),
      'cardHeightMm': serializer.toJson<double?>(cardHeightMm),
      'marginMm': serializer.toJson<double>(marginMm),
      'fontSize': serializer.toJson<double>(fontSize),
      'titleFontSize': serializer.toJson<double>(titleFontSize),
      'primaryColorHex': serializer.toJson<int>(primaryColorHex),
      'backgroundColorHex': serializer.toJson<int>(backgroundColorHex),
      'textColorHex': serializer.toJson<int>(textColorHex),
      'titleColorHex': serializer.toJson<int>(titleColorHex),
      'borderColorHex': serializer.toJson<int>(borderColorHex),
      'borderWidth': serializer.toJson<double>(borderWidth),
      'borderRadius': serializer.toJson<double>(borderRadius),
      'showQrCode': serializer.toJson<bool>(showQrCode),
      'showBarcode': serializer.toJson<bool>(showBarcode),
      'showLogo': serializer.toJson<bool>(showLogo),
      'logoPath': serializer.toJson<String?>(logoPath),
      'headerText': serializer.toJson<String?>(headerText),
      'footerText': serializer.toJson<String?>(footerText),
      'fontFamily': serializer.toJson<String>(fontFamily),
      'showProfile': serializer.toJson<bool>(showProfile),
      'showPrice': serializer.toJson<bool>(showPrice),
      'showValidity': serializer.toJson<bool>(showValidity),
      'showUsername': serializer.toJson<bool>(showUsername),
      'showPassword': serializer.toJson<bool>(showPassword),
      'showInstructions': serializer.toJson<bool>(showInstructions),
      'instructionsText': serializer.toJson<String?>(instructionsText),
      'contactPhone': serializer.toJson<String?>(contactPhone),
      'customText': serializer.toJson<String?>(customText),
      'targetCardType': serializer.toJson<String>(targetCardType),
      'configJson': serializer.toJson<String?>(configJson),
      'isDefault': serializer.toJson<bool>(isDefault),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  VoucherTemplatesTableData copyWith(
          {int? id,
          String? name,
          String? paperSize,
          int? cardsPerRow,
          int? cardsPerPage,
          Value<double?> cardWidthMm = const Value.absent(),
          Value<double?> cardHeightMm = const Value.absent(),
          double? marginMm,
          double? fontSize,
          double? titleFontSize,
          int? primaryColorHex,
          int? backgroundColorHex,
          int? textColorHex,
          int? titleColorHex,
          int? borderColorHex,
          double? borderWidth,
          double? borderRadius,
          bool? showQrCode,
          bool? showBarcode,
          bool? showLogo,
          Value<String?> logoPath = const Value.absent(),
          Value<String?> headerText = const Value.absent(),
          Value<String?> footerText = const Value.absent(),
          String? fontFamily,
          bool? showProfile,
          bool? showPrice,
          bool? showValidity,
          bool? showUsername,
          bool? showPassword,
          bool? showInstructions,
          Value<String?> instructionsText = const Value.absent(),
          Value<String?> contactPhone = const Value.absent(),
          Value<String?> customText = const Value.absent(),
          String? targetCardType,
          Value<String?> configJson = const Value.absent(),
          bool? isDefault,
          DateTime? createdAt}) =>
      VoucherTemplatesTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        paperSize: paperSize ?? this.paperSize,
        cardsPerRow: cardsPerRow ?? this.cardsPerRow,
        cardsPerPage: cardsPerPage ?? this.cardsPerPage,
        cardWidthMm: cardWidthMm.present ? cardWidthMm.value : this.cardWidthMm,
        cardHeightMm:
            cardHeightMm.present ? cardHeightMm.value : this.cardHeightMm,
        marginMm: marginMm ?? this.marginMm,
        fontSize: fontSize ?? this.fontSize,
        titleFontSize: titleFontSize ?? this.titleFontSize,
        primaryColorHex: primaryColorHex ?? this.primaryColorHex,
        backgroundColorHex: backgroundColorHex ?? this.backgroundColorHex,
        textColorHex: textColorHex ?? this.textColorHex,
        titleColorHex: titleColorHex ?? this.titleColorHex,
        borderColorHex: borderColorHex ?? this.borderColorHex,
        borderWidth: borderWidth ?? this.borderWidth,
        borderRadius: borderRadius ?? this.borderRadius,
        showQrCode: showQrCode ?? this.showQrCode,
        showBarcode: showBarcode ?? this.showBarcode,
        showLogo: showLogo ?? this.showLogo,
        logoPath: logoPath.present ? logoPath.value : this.logoPath,
        headerText: headerText.present ? headerText.value : this.headerText,
        footerText: footerText.present ? footerText.value : this.footerText,
        fontFamily: fontFamily ?? this.fontFamily,
        showProfile: showProfile ?? this.showProfile,
        showPrice: showPrice ?? this.showPrice,
        showValidity: showValidity ?? this.showValidity,
        showUsername: showUsername ?? this.showUsername,
        showPassword: showPassword ?? this.showPassword,
        showInstructions: showInstructions ?? this.showInstructions,
        instructionsText: instructionsText.present
            ? instructionsText.value
            : this.instructionsText,
        contactPhone:
            contactPhone.present ? contactPhone.value : this.contactPhone,
        customText: customText.present ? customText.value : this.customText,
        targetCardType: targetCardType ?? this.targetCardType,
        configJson: configJson.present ? configJson.value : this.configJson,
        isDefault: isDefault ?? this.isDefault,
        createdAt: createdAt ?? this.createdAt,
      );
  VoucherTemplatesTableData copyWithCompanion(
      VoucherTemplatesTableCompanion data) {
    return VoucherTemplatesTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      paperSize: data.paperSize.present ? data.paperSize.value : this.paperSize,
      cardsPerRow:
          data.cardsPerRow.present ? data.cardsPerRow.value : this.cardsPerRow,
      cardsPerPage: data.cardsPerPage.present
          ? data.cardsPerPage.value
          : this.cardsPerPage,
      cardWidthMm:
          data.cardWidthMm.present ? data.cardWidthMm.value : this.cardWidthMm,
      cardHeightMm: data.cardHeightMm.present
          ? data.cardHeightMm.value
          : this.cardHeightMm,
      marginMm: data.marginMm.present ? data.marginMm.value : this.marginMm,
      fontSize: data.fontSize.present ? data.fontSize.value : this.fontSize,
      titleFontSize: data.titleFontSize.present
          ? data.titleFontSize.value
          : this.titleFontSize,
      primaryColorHex: data.primaryColorHex.present
          ? data.primaryColorHex.value
          : this.primaryColorHex,
      backgroundColorHex: data.backgroundColorHex.present
          ? data.backgroundColorHex.value
          : this.backgroundColorHex,
      textColorHex: data.textColorHex.present
          ? data.textColorHex.value
          : this.textColorHex,
      titleColorHex: data.titleColorHex.present
          ? data.titleColorHex.value
          : this.titleColorHex,
      borderColorHex: data.borderColorHex.present
          ? data.borderColorHex.value
          : this.borderColorHex,
      borderWidth:
          data.borderWidth.present ? data.borderWidth.value : this.borderWidth,
      borderRadius: data.borderRadius.present
          ? data.borderRadius.value
          : this.borderRadius,
      showQrCode:
          data.showQrCode.present ? data.showQrCode.value : this.showQrCode,
      showBarcode:
          data.showBarcode.present ? data.showBarcode.value : this.showBarcode,
      showLogo: data.showLogo.present ? data.showLogo.value : this.showLogo,
      logoPath: data.logoPath.present ? data.logoPath.value : this.logoPath,
      headerText:
          data.headerText.present ? data.headerText.value : this.headerText,
      footerText:
          data.footerText.present ? data.footerText.value : this.footerText,
      fontFamily:
          data.fontFamily.present ? data.fontFamily.value : this.fontFamily,
      showProfile:
          data.showProfile.present ? data.showProfile.value : this.showProfile,
      showPrice: data.showPrice.present ? data.showPrice.value : this.showPrice,
      showValidity: data.showValidity.present
          ? data.showValidity.value
          : this.showValidity,
      showUsername: data.showUsername.present
          ? data.showUsername.value
          : this.showUsername,
      showPassword: data.showPassword.present
          ? data.showPassword.value
          : this.showPassword,
      showInstructions: data.showInstructions.present
          ? data.showInstructions.value
          : this.showInstructions,
      instructionsText: data.instructionsText.present
          ? data.instructionsText.value
          : this.instructionsText,
      contactPhone: data.contactPhone.present
          ? data.contactPhone.value
          : this.contactPhone,
      customText:
          data.customText.present ? data.customText.value : this.customText,
      targetCardType: data.targetCardType.present
          ? data.targetCardType.value
          : this.targetCardType,
      configJson:
          data.configJson.present ? data.configJson.value : this.configJson,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VoucherTemplatesTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('paperSize: $paperSize, ')
          ..write('cardsPerRow: $cardsPerRow, ')
          ..write('cardsPerPage: $cardsPerPage, ')
          ..write('cardWidthMm: $cardWidthMm, ')
          ..write('cardHeightMm: $cardHeightMm, ')
          ..write('marginMm: $marginMm, ')
          ..write('fontSize: $fontSize, ')
          ..write('titleFontSize: $titleFontSize, ')
          ..write('primaryColorHex: $primaryColorHex, ')
          ..write('backgroundColorHex: $backgroundColorHex, ')
          ..write('textColorHex: $textColorHex, ')
          ..write('titleColorHex: $titleColorHex, ')
          ..write('borderColorHex: $borderColorHex, ')
          ..write('borderWidth: $borderWidth, ')
          ..write('borderRadius: $borderRadius, ')
          ..write('showQrCode: $showQrCode, ')
          ..write('showBarcode: $showBarcode, ')
          ..write('showLogo: $showLogo, ')
          ..write('logoPath: $logoPath, ')
          ..write('headerText: $headerText, ')
          ..write('footerText: $footerText, ')
          ..write('fontFamily: $fontFamily, ')
          ..write('showProfile: $showProfile, ')
          ..write('showPrice: $showPrice, ')
          ..write('showValidity: $showValidity, ')
          ..write('showUsername: $showUsername, ')
          ..write('showPassword: $showPassword, ')
          ..write('showInstructions: $showInstructions, ')
          ..write('instructionsText: $instructionsText, ')
          ..write('contactPhone: $contactPhone, ')
          ..write('customText: $customText, ')
          ..write('targetCardType: $targetCardType, ')
          ..write('configJson: $configJson, ')
          ..write('isDefault: $isDefault, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        name,
        paperSize,
        cardsPerRow,
        cardsPerPage,
        cardWidthMm,
        cardHeightMm,
        marginMm,
        fontSize,
        titleFontSize,
        primaryColorHex,
        backgroundColorHex,
        textColorHex,
        titleColorHex,
        borderColorHex,
        borderWidth,
        borderRadius,
        showQrCode,
        showBarcode,
        showLogo,
        logoPath,
        headerText,
        footerText,
        fontFamily,
        showProfile,
        showPrice,
        showValidity,
        showUsername,
        showPassword,
        showInstructions,
        instructionsText,
        contactPhone,
        customText,
        targetCardType,
        configJson,
        isDefault,
        createdAt
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VoucherTemplatesTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.paperSize == this.paperSize &&
          other.cardsPerRow == this.cardsPerRow &&
          other.cardsPerPage == this.cardsPerPage &&
          other.cardWidthMm == this.cardWidthMm &&
          other.cardHeightMm == this.cardHeightMm &&
          other.marginMm == this.marginMm &&
          other.fontSize == this.fontSize &&
          other.titleFontSize == this.titleFontSize &&
          other.primaryColorHex == this.primaryColorHex &&
          other.backgroundColorHex == this.backgroundColorHex &&
          other.textColorHex == this.textColorHex &&
          other.titleColorHex == this.titleColorHex &&
          other.borderColorHex == this.borderColorHex &&
          other.borderWidth == this.borderWidth &&
          other.borderRadius == this.borderRadius &&
          other.showQrCode == this.showQrCode &&
          other.showBarcode == this.showBarcode &&
          other.showLogo == this.showLogo &&
          other.logoPath == this.logoPath &&
          other.headerText == this.headerText &&
          other.footerText == this.footerText &&
          other.fontFamily == this.fontFamily &&
          other.showProfile == this.showProfile &&
          other.showPrice == this.showPrice &&
          other.showValidity == this.showValidity &&
          other.showUsername == this.showUsername &&
          other.showPassword == this.showPassword &&
          other.showInstructions == this.showInstructions &&
          other.instructionsText == this.instructionsText &&
          other.contactPhone == this.contactPhone &&
          other.customText == this.customText &&
          other.targetCardType == this.targetCardType &&
          other.configJson == this.configJson &&
          other.isDefault == this.isDefault &&
          other.createdAt == this.createdAt);
}

class VoucherTemplatesTableCompanion
    extends UpdateCompanion<VoucherTemplatesTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> paperSize;
  final Value<int> cardsPerRow;
  final Value<int> cardsPerPage;
  final Value<double?> cardWidthMm;
  final Value<double?> cardHeightMm;
  final Value<double> marginMm;
  final Value<double> fontSize;
  final Value<double> titleFontSize;
  final Value<int> primaryColorHex;
  final Value<int> backgroundColorHex;
  final Value<int> textColorHex;
  final Value<int> titleColorHex;
  final Value<int> borderColorHex;
  final Value<double> borderWidth;
  final Value<double> borderRadius;
  final Value<bool> showQrCode;
  final Value<bool> showBarcode;
  final Value<bool> showLogo;
  final Value<String?> logoPath;
  final Value<String?> headerText;
  final Value<String?> footerText;
  final Value<String> fontFamily;
  final Value<bool> showProfile;
  final Value<bool> showPrice;
  final Value<bool> showValidity;
  final Value<bool> showUsername;
  final Value<bool> showPassword;
  final Value<bool> showInstructions;
  final Value<String?> instructionsText;
  final Value<String?> contactPhone;
  final Value<String?> customText;
  final Value<String> targetCardType;
  final Value<String?> configJson;
  final Value<bool> isDefault;
  final Value<DateTime> createdAt;
  const VoucherTemplatesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.paperSize = const Value.absent(),
    this.cardsPerRow = const Value.absent(),
    this.cardsPerPage = const Value.absent(),
    this.cardWidthMm = const Value.absent(),
    this.cardHeightMm = const Value.absent(),
    this.marginMm = const Value.absent(),
    this.fontSize = const Value.absent(),
    this.titleFontSize = const Value.absent(),
    this.primaryColorHex = const Value.absent(),
    this.backgroundColorHex = const Value.absent(),
    this.textColorHex = const Value.absent(),
    this.titleColorHex = const Value.absent(),
    this.borderColorHex = const Value.absent(),
    this.borderWidth = const Value.absent(),
    this.borderRadius = const Value.absent(),
    this.showQrCode = const Value.absent(),
    this.showBarcode = const Value.absent(),
    this.showLogo = const Value.absent(),
    this.logoPath = const Value.absent(),
    this.headerText = const Value.absent(),
    this.footerText = const Value.absent(),
    this.fontFamily = const Value.absent(),
    this.showProfile = const Value.absent(),
    this.showPrice = const Value.absent(),
    this.showValidity = const Value.absent(),
    this.showUsername = const Value.absent(),
    this.showPassword = const Value.absent(),
    this.showInstructions = const Value.absent(),
    this.instructionsText = const Value.absent(),
    this.contactPhone = const Value.absent(),
    this.customText = const Value.absent(),
    this.targetCardType = const Value.absent(),
    this.configJson = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  VoucherTemplatesTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.paperSize = const Value.absent(),
    this.cardsPerRow = const Value.absent(),
    this.cardsPerPage = const Value.absent(),
    this.cardWidthMm = const Value.absent(),
    this.cardHeightMm = const Value.absent(),
    this.marginMm = const Value.absent(),
    this.fontSize = const Value.absent(),
    this.titleFontSize = const Value.absent(),
    this.primaryColorHex = const Value.absent(),
    this.backgroundColorHex = const Value.absent(),
    this.textColorHex = const Value.absent(),
    this.titleColorHex = const Value.absent(),
    this.borderColorHex = const Value.absent(),
    this.borderWidth = const Value.absent(),
    this.borderRadius = const Value.absent(),
    this.showQrCode = const Value.absent(),
    this.showBarcode = const Value.absent(),
    this.showLogo = const Value.absent(),
    this.logoPath = const Value.absent(),
    this.headerText = const Value.absent(),
    this.footerText = const Value.absent(),
    this.fontFamily = const Value.absent(),
    this.showProfile = const Value.absent(),
    this.showPrice = const Value.absent(),
    this.showValidity = const Value.absent(),
    this.showUsername = const Value.absent(),
    this.showPassword = const Value.absent(),
    this.showInstructions = const Value.absent(),
    this.instructionsText = const Value.absent(),
    this.contactPhone = const Value.absent(),
    this.customText = const Value.absent(),
    this.targetCardType = const Value.absent(),
    this.configJson = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<VoucherTemplatesTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? paperSize,
    Expression<int>? cardsPerRow,
    Expression<int>? cardsPerPage,
    Expression<double>? cardWidthMm,
    Expression<double>? cardHeightMm,
    Expression<double>? marginMm,
    Expression<double>? fontSize,
    Expression<double>? titleFontSize,
    Expression<int>? primaryColorHex,
    Expression<int>? backgroundColorHex,
    Expression<int>? textColorHex,
    Expression<int>? titleColorHex,
    Expression<int>? borderColorHex,
    Expression<double>? borderWidth,
    Expression<double>? borderRadius,
    Expression<bool>? showQrCode,
    Expression<bool>? showBarcode,
    Expression<bool>? showLogo,
    Expression<String>? logoPath,
    Expression<String>? headerText,
    Expression<String>? footerText,
    Expression<String>? fontFamily,
    Expression<bool>? showProfile,
    Expression<bool>? showPrice,
    Expression<bool>? showValidity,
    Expression<bool>? showUsername,
    Expression<bool>? showPassword,
    Expression<bool>? showInstructions,
    Expression<String>? instructionsText,
    Expression<String>? contactPhone,
    Expression<String>? customText,
    Expression<String>? targetCardType,
    Expression<String>? configJson,
    Expression<bool>? isDefault,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (paperSize != null) 'paper_size': paperSize,
      if (cardsPerRow != null) 'cards_per_row': cardsPerRow,
      if (cardsPerPage != null) 'cards_per_page': cardsPerPage,
      if (cardWidthMm != null) 'card_width_mm': cardWidthMm,
      if (cardHeightMm != null) 'card_height_mm': cardHeightMm,
      if (marginMm != null) 'margin_mm': marginMm,
      if (fontSize != null) 'font_size': fontSize,
      if (titleFontSize != null) 'title_font_size': titleFontSize,
      if (primaryColorHex != null) 'primary_color_hex': primaryColorHex,
      if (backgroundColorHex != null)
        'background_color_hex': backgroundColorHex,
      if (textColorHex != null) 'text_color_hex': textColorHex,
      if (titleColorHex != null) 'title_color_hex': titleColorHex,
      if (borderColorHex != null) 'border_color_hex': borderColorHex,
      if (borderWidth != null) 'border_width': borderWidth,
      if (borderRadius != null) 'border_radius': borderRadius,
      if (showQrCode != null) 'show_qr_code': showQrCode,
      if (showBarcode != null) 'show_barcode': showBarcode,
      if (showLogo != null) 'show_logo': showLogo,
      if (logoPath != null) 'logo_path': logoPath,
      if (headerText != null) 'header_text': headerText,
      if (footerText != null) 'footer_text': footerText,
      if (fontFamily != null) 'font_family': fontFamily,
      if (showProfile != null) 'show_profile': showProfile,
      if (showPrice != null) 'show_price': showPrice,
      if (showValidity != null) 'show_validity': showValidity,
      if (showUsername != null) 'show_username': showUsername,
      if (showPassword != null) 'show_password': showPassword,
      if (showInstructions != null) 'show_instructions': showInstructions,
      if (instructionsText != null) 'instructions_text': instructionsText,
      if (contactPhone != null) 'contact_phone': contactPhone,
      if (customText != null) 'custom_text': customText,
      if (targetCardType != null) 'target_card_type': targetCardType,
      if (configJson != null) 'config_json': configJson,
      if (isDefault != null) 'is_default': isDefault,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  VoucherTemplatesTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? paperSize,
      Value<int>? cardsPerRow,
      Value<int>? cardsPerPage,
      Value<double?>? cardWidthMm,
      Value<double?>? cardHeightMm,
      Value<double>? marginMm,
      Value<double>? fontSize,
      Value<double>? titleFontSize,
      Value<int>? primaryColorHex,
      Value<int>? backgroundColorHex,
      Value<int>? textColorHex,
      Value<int>? titleColorHex,
      Value<int>? borderColorHex,
      Value<double>? borderWidth,
      Value<double>? borderRadius,
      Value<bool>? showQrCode,
      Value<bool>? showBarcode,
      Value<bool>? showLogo,
      Value<String?>? logoPath,
      Value<String?>? headerText,
      Value<String?>? footerText,
      Value<String>? fontFamily,
      Value<bool>? showProfile,
      Value<bool>? showPrice,
      Value<bool>? showValidity,
      Value<bool>? showUsername,
      Value<bool>? showPassword,
      Value<bool>? showInstructions,
      Value<String?>? instructionsText,
      Value<String?>? contactPhone,
      Value<String?>? customText,
      Value<String>? targetCardType,
      Value<String?>? configJson,
      Value<bool>? isDefault,
      Value<DateTime>? createdAt}) {
    return VoucherTemplatesTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      paperSize: paperSize ?? this.paperSize,
      cardsPerRow: cardsPerRow ?? this.cardsPerRow,
      cardsPerPage: cardsPerPage ?? this.cardsPerPage,
      cardWidthMm: cardWidthMm ?? this.cardWidthMm,
      cardHeightMm: cardHeightMm ?? this.cardHeightMm,
      marginMm: marginMm ?? this.marginMm,
      fontSize: fontSize ?? this.fontSize,
      titleFontSize: titleFontSize ?? this.titleFontSize,
      primaryColorHex: primaryColorHex ?? this.primaryColorHex,
      backgroundColorHex: backgroundColorHex ?? this.backgroundColorHex,
      textColorHex: textColorHex ?? this.textColorHex,
      titleColorHex: titleColorHex ?? this.titleColorHex,
      borderColorHex: borderColorHex ?? this.borderColorHex,
      borderWidth: borderWidth ?? this.borderWidth,
      borderRadius: borderRadius ?? this.borderRadius,
      showQrCode: showQrCode ?? this.showQrCode,
      showBarcode: showBarcode ?? this.showBarcode,
      showLogo: showLogo ?? this.showLogo,
      logoPath: logoPath ?? this.logoPath,
      headerText: headerText ?? this.headerText,
      footerText: footerText ?? this.footerText,
      fontFamily: fontFamily ?? this.fontFamily,
      showProfile: showProfile ?? this.showProfile,
      showPrice: showPrice ?? this.showPrice,
      showValidity: showValidity ?? this.showValidity,
      showUsername: showUsername ?? this.showUsername,
      showPassword: showPassword ?? this.showPassword,
      showInstructions: showInstructions ?? this.showInstructions,
      instructionsText: instructionsText ?? this.instructionsText,
      contactPhone: contactPhone ?? this.contactPhone,
      customText: customText ?? this.customText,
      targetCardType: targetCardType ?? this.targetCardType,
      configJson: configJson ?? this.configJson,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (paperSize.present) {
      map['paper_size'] = Variable<String>(paperSize.value);
    }
    if (cardsPerRow.present) {
      map['cards_per_row'] = Variable<int>(cardsPerRow.value);
    }
    if (cardsPerPage.present) {
      map['cards_per_page'] = Variable<int>(cardsPerPage.value);
    }
    if (cardWidthMm.present) {
      map['card_width_mm'] = Variable<double>(cardWidthMm.value);
    }
    if (cardHeightMm.present) {
      map['card_height_mm'] = Variable<double>(cardHeightMm.value);
    }
    if (marginMm.present) {
      map['margin_mm'] = Variable<double>(marginMm.value);
    }
    if (fontSize.present) {
      map['font_size'] = Variable<double>(fontSize.value);
    }
    if (titleFontSize.present) {
      map['title_font_size'] = Variable<double>(titleFontSize.value);
    }
    if (primaryColorHex.present) {
      map['primary_color_hex'] = Variable<int>(primaryColorHex.value);
    }
    if (backgroundColorHex.present) {
      map['background_color_hex'] = Variable<int>(backgroundColorHex.value);
    }
    if (textColorHex.present) {
      map['text_color_hex'] = Variable<int>(textColorHex.value);
    }
    if (titleColorHex.present) {
      map['title_color_hex'] = Variable<int>(titleColorHex.value);
    }
    if (borderColorHex.present) {
      map['border_color_hex'] = Variable<int>(borderColorHex.value);
    }
    if (borderWidth.present) {
      map['border_width'] = Variable<double>(borderWidth.value);
    }
    if (borderRadius.present) {
      map['border_radius'] = Variable<double>(borderRadius.value);
    }
    if (showQrCode.present) {
      map['show_qr_code'] = Variable<bool>(showQrCode.value);
    }
    if (showBarcode.present) {
      map['show_barcode'] = Variable<bool>(showBarcode.value);
    }
    if (showLogo.present) {
      map['show_logo'] = Variable<bool>(showLogo.value);
    }
    if (logoPath.present) {
      map['logo_path'] = Variable<String>(logoPath.value);
    }
    if (headerText.present) {
      map['header_text'] = Variable<String>(headerText.value);
    }
    if (footerText.present) {
      map['footer_text'] = Variable<String>(footerText.value);
    }
    if (fontFamily.present) {
      map['font_family'] = Variable<String>(fontFamily.value);
    }
    if (showProfile.present) {
      map['show_profile'] = Variable<bool>(showProfile.value);
    }
    if (showPrice.present) {
      map['show_price'] = Variable<bool>(showPrice.value);
    }
    if (showValidity.present) {
      map['show_validity'] = Variable<bool>(showValidity.value);
    }
    if (showUsername.present) {
      map['show_username'] = Variable<bool>(showUsername.value);
    }
    if (showPassword.present) {
      map['show_password'] = Variable<bool>(showPassword.value);
    }
    if (showInstructions.present) {
      map['show_instructions'] = Variable<bool>(showInstructions.value);
    }
    if (instructionsText.present) {
      map['instructions_text'] = Variable<String>(instructionsText.value);
    }
    if (contactPhone.present) {
      map['contact_phone'] = Variable<String>(contactPhone.value);
    }
    if (customText.present) {
      map['custom_text'] = Variable<String>(customText.value);
    }
    if (targetCardType.present) {
      map['target_card_type'] = Variable<String>(targetCardType.value);
    }
    if (configJson.present) {
      map['config_json'] = Variable<String>(configJson.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VoucherTemplatesTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('paperSize: $paperSize, ')
          ..write('cardsPerRow: $cardsPerRow, ')
          ..write('cardsPerPage: $cardsPerPage, ')
          ..write('cardWidthMm: $cardWidthMm, ')
          ..write('cardHeightMm: $cardHeightMm, ')
          ..write('marginMm: $marginMm, ')
          ..write('fontSize: $fontSize, ')
          ..write('titleFontSize: $titleFontSize, ')
          ..write('primaryColorHex: $primaryColorHex, ')
          ..write('backgroundColorHex: $backgroundColorHex, ')
          ..write('textColorHex: $textColorHex, ')
          ..write('titleColorHex: $titleColorHex, ')
          ..write('borderColorHex: $borderColorHex, ')
          ..write('borderWidth: $borderWidth, ')
          ..write('borderRadius: $borderRadius, ')
          ..write('showQrCode: $showQrCode, ')
          ..write('showBarcode: $showBarcode, ')
          ..write('showLogo: $showLogo, ')
          ..write('logoPath: $logoPath, ')
          ..write('headerText: $headerText, ')
          ..write('footerText: $footerText, ')
          ..write('fontFamily: $fontFamily, ')
          ..write('showProfile: $showProfile, ')
          ..write('showPrice: $showPrice, ')
          ..write('showValidity: $showValidity, ')
          ..write('showUsername: $showUsername, ')
          ..write('showPassword: $showPassword, ')
          ..write('showInstructions: $showInstructions, ')
          ..write('instructionsText: $instructionsText, ')
          ..write('contactPhone: $contactPhone, ')
          ..write('customText: $customText, ')
          ..write('targetCardType: $targetCardType, ')
          ..write('configJson: $configJson, ')
          ..write('isDefault: $isDefault, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SalesReportsTableTable extends SalesReportsTable
    with TableInfo<$SalesReportsTableTable, SalesReportsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SalesReportsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _routerIdMeta =
      const VerificationMeta('routerId');
  @override
  late final GeneratedColumn<int> routerId = GeneratedColumn<int>(
      'router_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _reportTypeMeta =
      const VerificationMeta('reportType');
  @override
  late final GeneratedColumn<String> reportType = GeneratedColumn<String>(
      'report_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _reportDateMeta =
      const VerificationMeta('reportDate');
  @override
  late final GeneratedColumn<DateTime> reportDate = GeneratedColumn<DateTime>(
      'report_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _totalVouchersMeta =
      const VerificationMeta('totalVouchers');
  @override
  late final GeneratedColumn<int> totalVouchers = GeneratedColumn<int>(
      'total_vouchers', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _totalRevenueMeta =
      const VerificationMeta('totalRevenue');
  @override
  late final GeneratedColumn<double> totalRevenue = GeneratedColumn<double>(
      'total_revenue', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _totalCostMeta =
      const VerificationMeta('totalCost');
  @override
  late final GeneratedColumn<double> totalCost = GeneratedColumn<double>(
      'total_cost', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _netProfitMeta =
      const VerificationMeta('netProfit');
  @override
  late final GeneratedColumn<double> netProfit = GeneratedColumn<double>(
      'net_profit', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _detailsJsonMeta =
      const VerificationMeta('detailsJson');
  @override
  late final GeneratedColumn<String> detailsJson = GeneratedColumn<String>(
      'details_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        routerId,
        reportType,
        reportDate,
        totalVouchers,
        totalRevenue,
        totalCost,
        netProfit,
        detailsJson,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sales_reports_cache';
  @override
  VerificationContext validateIntegrity(
      Insertable<SalesReportsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('router_id')) {
      context.handle(_routerIdMeta,
          routerId.isAcceptableOrUnknown(data['router_id']!, _routerIdMeta));
    }
    if (data.containsKey('report_type')) {
      context.handle(
          _reportTypeMeta,
          reportType.isAcceptableOrUnknown(
              data['report_type']!, _reportTypeMeta));
    } else if (isInserting) {
      context.missing(_reportTypeMeta);
    }
    if (data.containsKey('report_date')) {
      context.handle(
          _reportDateMeta,
          reportDate.isAcceptableOrUnknown(
              data['report_date']!, _reportDateMeta));
    } else if (isInserting) {
      context.missing(_reportDateMeta);
    }
    if (data.containsKey('total_vouchers')) {
      context.handle(
          _totalVouchersMeta,
          totalVouchers.isAcceptableOrUnknown(
              data['total_vouchers']!, _totalVouchersMeta));
    }
    if (data.containsKey('total_revenue')) {
      context.handle(
          _totalRevenueMeta,
          totalRevenue.isAcceptableOrUnknown(
              data['total_revenue']!, _totalRevenueMeta));
    }
    if (data.containsKey('total_cost')) {
      context.handle(_totalCostMeta,
          totalCost.isAcceptableOrUnknown(data['total_cost']!, _totalCostMeta));
    }
    if (data.containsKey('net_profit')) {
      context.handle(_netProfitMeta,
          netProfit.isAcceptableOrUnknown(data['net_profit']!, _netProfitMeta));
    }
    if (data.containsKey('details_json')) {
      context.handle(
          _detailsJsonMeta,
          detailsJson.isAcceptableOrUnknown(
              data['details_json']!, _detailsJsonMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SalesReportsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SalesReportsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      routerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}router_id']),
      reportType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}report_type'])!,
      reportDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}report_date'])!,
      totalVouchers: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_vouchers'])!,
      totalRevenue: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_revenue'])!,
      totalCost: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_cost'])!,
      netProfit: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}net_profit'])!,
      detailsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}details_json']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SalesReportsTableTable createAlias(String alias) {
    return $SalesReportsTableTable(attachedDatabase, alias);
  }
}

class SalesReportsTableData extends DataClass
    implements Insertable<SalesReportsTableData> {
  final int id;
  final int? routerId;
  final String reportType;
  final DateTime reportDate;
  final int totalVouchers;
  final double totalRevenue;
  final double totalCost;
  final double netProfit;
  final String? detailsJson;
  final DateTime createdAt;
  const SalesReportsTableData(
      {required this.id,
      this.routerId,
      required this.reportType,
      required this.reportDate,
      required this.totalVouchers,
      required this.totalRevenue,
      required this.totalCost,
      required this.netProfit,
      this.detailsJson,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || routerId != null) {
      map['router_id'] = Variable<int>(routerId);
    }
    map['report_type'] = Variable<String>(reportType);
    map['report_date'] = Variable<DateTime>(reportDate);
    map['total_vouchers'] = Variable<int>(totalVouchers);
    map['total_revenue'] = Variable<double>(totalRevenue);
    map['total_cost'] = Variable<double>(totalCost);
    map['net_profit'] = Variable<double>(netProfit);
    if (!nullToAbsent || detailsJson != null) {
      map['details_json'] = Variable<String>(detailsJson);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SalesReportsTableCompanion toCompanion(bool nullToAbsent) {
    return SalesReportsTableCompanion(
      id: Value(id),
      routerId: routerId == null && nullToAbsent
          ? const Value.absent()
          : Value(routerId),
      reportType: Value(reportType),
      reportDate: Value(reportDate),
      totalVouchers: Value(totalVouchers),
      totalRevenue: Value(totalRevenue),
      totalCost: Value(totalCost),
      netProfit: Value(netProfit),
      detailsJson: detailsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(detailsJson),
      createdAt: Value(createdAt),
    );
  }

  factory SalesReportsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SalesReportsTableData(
      id: serializer.fromJson<int>(json['id']),
      routerId: serializer.fromJson<int?>(json['routerId']),
      reportType: serializer.fromJson<String>(json['reportType']),
      reportDate: serializer.fromJson<DateTime>(json['reportDate']),
      totalVouchers: serializer.fromJson<int>(json['totalVouchers']),
      totalRevenue: serializer.fromJson<double>(json['totalRevenue']),
      totalCost: serializer.fromJson<double>(json['totalCost']),
      netProfit: serializer.fromJson<double>(json['netProfit']),
      detailsJson: serializer.fromJson<String?>(json['detailsJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'routerId': serializer.toJson<int?>(routerId),
      'reportType': serializer.toJson<String>(reportType),
      'reportDate': serializer.toJson<DateTime>(reportDate),
      'totalVouchers': serializer.toJson<int>(totalVouchers),
      'totalRevenue': serializer.toJson<double>(totalRevenue),
      'totalCost': serializer.toJson<double>(totalCost),
      'netProfit': serializer.toJson<double>(netProfit),
      'detailsJson': serializer.toJson<String?>(detailsJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SalesReportsTableData copyWith(
          {int? id,
          Value<int?> routerId = const Value.absent(),
          String? reportType,
          DateTime? reportDate,
          int? totalVouchers,
          double? totalRevenue,
          double? totalCost,
          double? netProfit,
          Value<String?> detailsJson = const Value.absent(),
          DateTime? createdAt}) =>
      SalesReportsTableData(
        id: id ?? this.id,
        routerId: routerId.present ? routerId.value : this.routerId,
        reportType: reportType ?? this.reportType,
        reportDate: reportDate ?? this.reportDate,
        totalVouchers: totalVouchers ?? this.totalVouchers,
        totalRevenue: totalRevenue ?? this.totalRevenue,
        totalCost: totalCost ?? this.totalCost,
        netProfit: netProfit ?? this.netProfit,
        detailsJson: detailsJson.present ? detailsJson.value : this.detailsJson,
        createdAt: createdAt ?? this.createdAt,
      );
  SalesReportsTableData copyWithCompanion(SalesReportsTableCompanion data) {
    return SalesReportsTableData(
      id: data.id.present ? data.id.value : this.id,
      routerId: data.routerId.present ? data.routerId.value : this.routerId,
      reportType:
          data.reportType.present ? data.reportType.value : this.reportType,
      reportDate:
          data.reportDate.present ? data.reportDate.value : this.reportDate,
      totalVouchers: data.totalVouchers.present
          ? data.totalVouchers.value
          : this.totalVouchers,
      totalRevenue: data.totalRevenue.present
          ? data.totalRevenue.value
          : this.totalRevenue,
      totalCost: data.totalCost.present ? data.totalCost.value : this.totalCost,
      netProfit: data.netProfit.present ? data.netProfit.value : this.netProfit,
      detailsJson:
          data.detailsJson.present ? data.detailsJson.value : this.detailsJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SalesReportsTableData(')
          ..write('id: $id, ')
          ..write('routerId: $routerId, ')
          ..write('reportType: $reportType, ')
          ..write('reportDate: $reportDate, ')
          ..write('totalVouchers: $totalVouchers, ')
          ..write('totalRevenue: $totalRevenue, ')
          ..write('totalCost: $totalCost, ')
          ..write('netProfit: $netProfit, ')
          ..write('detailsJson: $detailsJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      routerId,
      reportType,
      reportDate,
      totalVouchers,
      totalRevenue,
      totalCost,
      netProfit,
      detailsJson,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SalesReportsTableData &&
          other.id == this.id &&
          other.routerId == this.routerId &&
          other.reportType == this.reportType &&
          other.reportDate == this.reportDate &&
          other.totalVouchers == this.totalVouchers &&
          other.totalRevenue == this.totalRevenue &&
          other.totalCost == this.totalCost &&
          other.netProfit == this.netProfit &&
          other.detailsJson == this.detailsJson &&
          other.createdAt == this.createdAt);
}

class SalesReportsTableCompanion
    extends UpdateCompanion<SalesReportsTableData> {
  final Value<int> id;
  final Value<int?> routerId;
  final Value<String> reportType;
  final Value<DateTime> reportDate;
  final Value<int> totalVouchers;
  final Value<double> totalRevenue;
  final Value<double> totalCost;
  final Value<double> netProfit;
  final Value<String?> detailsJson;
  final Value<DateTime> createdAt;
  const SalesReportsTableCompanion({
    this.id = const Value.absent(),
    this.routerId = const Value.absent(),
    this.reportType = const Value.absent(),
    this.reportDate = const Value.absent(),
    this.totalVouchers = const Value.absent(),
    this.totalRevenue = const Value.absent(),
    this.totalCost = const Value.absent(),
    this.netProfit = const Value.absent(),
    this.detailsJson = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SalesReportsTableCompanion.insert({
    this.id = const Value.absent(),
    this.routerId = const Value.absent(),
    required String reportType,
    required DateTime reportDate,
    this.totalVouchers = const Value.absent(),
    this.totalRevenue = const Value.absent(),
    this.totalCost = const Value.absent(),
    this.netProfit = const Value.absent(),
    this.detailsJson = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : reportType = Value(reportType),
        reportDate = Value(reportDate);
  static Insertable<SalesReportsTableData> custom({
    Expression<int>? id,
    Expression<int>? routerId,
    Expression<String>? reportType,
    Expression<DateTime>? reportDate,
    Expression<int>? totalVouchers,
    Expression<double>? totalRevenue,
    Expression<double>? totalCost,
    Expression<double>? netProfit,
    Expression<String>? detailsJson,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (routerId != null) 'router_id': routerId,
      if (reportType != null) 'report_type': reportType,
      if (reportDate != null) 'report_date': reportDate,
      if (totalVouchers != null) 'total_vouchers': totalVouchers,
      if (totalRevenue != null) 'total_revenue': totalRevenue,
      if (totalCost != null) 'total_cost': totalCost,
      if (netProfit != null) 'net_profit': netProfit,
      if (detailsJson != null) 'details_json': detailsJson,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SalesReportsTableCompanion copyWith(
      {Value<int>? id,
      Value<int?>? routerId,
      Value<String>? reportType,
      Value<DateTime>? reportDate,
      Value<int>? totalVouchers,
      Value<double>? totalRevenue,
      Value<double>? totalCost,
      Value<double>? netProfit,
      Value<String?>? detailsJson,
      Value<DateTime>? createdAt}) {
    return SalesReportsTableCompanion(
      id: id ?? this.id,
      routerId: routerId ?? this.routerId,
      reportType: reportType ?? this.reportType,
      reportDate: reportDate ?? this.reportDate,
      totalVouchers: totalVouchers ?? this.totalVouchers,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      totalCost: totalCost ?? this.totalCost,
      netProfit: netProfit ?? this.netProfit,
      detailsJson: detailsJson ?? this.detailsJson,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (routerId.present) {
      map['router_id'] = Variable<int>(routerId.value);
    }
    if (reportType.present) {
      map['report_type'] = Variable<String>(reportType.value);
    }
    if (reportDate.present) {
      map['report_date'] = Variable<DateTime>(reportDate.value);
    }
    if (totalVouchers.present) {
      map['total_vouchers'] = Variable<int>(totalVouchers.value);
    }
    if (totalRevenue.present) {
      map['total_revenue'] = Variable<double>(totalRevenue.value);
    }
    if (totalCost.present) {
      map['total_cost'] = Variable<double>(totalCost.value);
    }
    if (netProfit.present) {
      map['net_profit'] = Variable<double>(netProfit.value);
    }
    if (detailsJson.present) {
      map['details_json'] = Variable<String>(detailsJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SalesReportsTableCompanion(')
          ..write('id: $id, ')
          ..write('routerId: $routerId, ')
          ..write('reportType: $reportType, ')
          ..write('reportDate: $reportDate, ')
          ..write('totalVouchers: $totalVouchers, ')
          ..write('totalRevenue: $totalRevenue, ')
          ..write('totalCost: $totalCost, ')
          ..write('netProfit: $netProfit, ')
          ..write('detailsJson: $detailsJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $AuditLogsTableTable extends AuditLogsTable
    with TableInfo<$AuditLogsTableTable, AuditLogsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuditLogsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
      'action', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityTypeMeta =
      const VerificationMeta('entityType');
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
      'entity_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityIdMeta =
      const VerificationMeta('entityId');
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
      'entity_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _performedByMeta =
      const VerificationMeta('performedBy');
  @override
  late final GeneratedColumn<String> performedBy = GeneratedColumn<String>(
      'performed_by', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('admin'));
  static const VerificationMeta _metadataMeta =
      const VerificationMeta('metadata');
  @override
  late final GeneratedColumn<String> metadata = GeneratedColumn<String>(
      'metadata', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _performedAtMeta =
      const VerificationMeta('performedAt');
  @override
  late final GeneratedColumn<DateTime> performedAt = GeneratedColumn<DateTime>(
      'performed_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        action,
        entityType,
        entityId,
        description,
        performedBy,
        metadata,
        performedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audit_logs';
  @override
  VerificationContext validateIntegrity(Insertable<AuditLogsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('action')) {
      context.handle(_actionMeta,
          action.isAcceptableOrUnknown(data['action']!, _actionMeta));
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
          _entityTypeMeta,
          entityType.isAcceptableOrUnknown(
              data['entity_type']!, _entityTypeMeta));
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(_entityIdMeta,
          entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('performed_by')) {
      context.handle(
          _performedByMeta,
          performedBy.isAcceptableOrUnknown(
              data['performed_by']!, _performedByMeta));
    }
    if (data.containsKey('metadata')) {
      context.handle(_metadataMeta,
          metadata.isAcceptableOrUnknown(data['metadata']!, _metadataMeta));
    }
    if (data.containsKey('performed_at')) {
      context.handle(
          _performedAtMeta,
          performedAt.isAcceptableOrUnknown(
              data['performed_at']!, _performedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuditLogsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuditLogsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      action: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}action'])!,
      entityType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_type'])!,
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_id']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      performedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}performed_by'])!,
      metadata: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metadata']),
      performedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}performed_at'])!,
    );
  }

  @override
  $AuditLogsTableTable createAlias(String alias) {
    return $AuditLogsTableTable(attachedDatabase, alias);
  }
}

class AuditLogsTableData extends DataClass
    implements Insertable<AuditLogsTableData> {
  final int id;
  final String action;
  final String entityType;
  final String? entityId;
  final String description;
  final String performedBy;
  final String? metadata;
  final DateTime performedAt;
  const AuditLogsTableData(
      {required this.id,
      required this.action,
      required this.entityType,
      this.entityId,
      required this.description,
      required this.performedBy,
      this.metadata,
      required this.performedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['action'] = Variable<String>(action);
    map['entity_type'] = Variable<String>(entityType);
    if (!nullToAbsent || entityId != null) {
      map['entity_id'] = Variable<String>(entityId);
    }
    map['description'] = Variable<String>(description);
    map['performed_by'] = Variable<String>(performedBy);
    if (!nullToAbsent || metadata != null) {
      map['metadata'] = Variable<String>(metadata);
    }
    map['performed_at'] = Variable<DateTime>(performedAt);
    return map;
  }

  AuditLogsTableCompanion toCompanion(bool nullToAbsent) {
    return AuditLogsTableCompanion(
      id: Value(id),
      action: Value(action),
      entityType: Value(entityType),
      entityId: entityId == null && nullToAbsent
          ? const Value.absent()
          : Value(entityId),
      description: Value(description),
      performedBy: Value(performedBy),
      metadata: metadata == null && nullToAbsent
          ? const Value.absent()
          : Value(metadata),
      performedAt: Value(performedAt),
    );
  }

  factory AuditLogsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuditLogsTableData(
      id: serializer.fromJson<int>(json['id']),
      action: serializer.fromJson<String>(json['action']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String?>(json['entityId']),
      description: serializer.fromJson<String>(json['description']),
      performedBy: serializer.fromJson<String>(json['performedBy']),
      metadata: serializer.fromJson<String?>(json['metadata']),
      performedAt: serializer.fromJson<DateTime>(json['performedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'action': serializer.toJson<String>(action),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String?>(entityId),
      'description': serializer.toJson<String>(description),
      'performedBy': serializer.toJson<String>(performedBy),
      'metadata': serializer.toJson<String?>(metadata),
      'performedAt': serializer.toJson<DateTime>(performedAt),
    };
  }

  AuditLogsTableData copyWith(
          {int? id,
          String? action,
          String? entityType,
          Value<String?> entityId = const Value.absent(),
          String? description,
          String? performedBy,
          Value<String?> metadata = const Value.absent(),
          DateTime? performedAt}) =>
      AuditLogsTableData(
        id: id ?? this.id,
        action: action ?? this.action,
        entityType: entityType ?? this.entityType,
        entityId: entityId.present ? entityId.value : this.entityId,
        description: description ?? this.description,
        performedBy: performedBy ?? this.performedBy,
        metadata: metadata.present ? metadata.value : this.metadata,
        performedAt: performedAt ?? this.performedAt,
      );
  AuditLogsTableData copyWithCompanion(AuditLogsTableCompanion data) {
    return AuditLogsTableData(
      id: data.id.present ? data.id.value : this.id,
      action: data.action.present ? data.action.value : this.action,
      entityType:
          data.entityType.present ? data.entityType.value : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      description:
          data.description.present ? data.description.value : this.description,
      performedBy:
          data.performedBy.present ? data.performedBy.value : this.performedBy,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
      performedAt:
          data.performedAt.present ? data.performedAt.value : this.performedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuditLogsTableData(')
          ..write('id: $id, ')
          ..write('action: $action, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('description: $description, ')
          ..write('performedBy: $performedBy, ')
          ..write('metadata: $metadata, ')
          ..write('performedAt: $performedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, action, entityType, entityId, description,
      performedBy, metadata, performedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuditLogsTableData &&
          other.id == this.id &&
          other.action == this.action &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.description == this.description &&
          other.performedBy == this.performedBy &&
          other.metadata == this.metadata &&
          other.performedAt == this.performedAt);
}

class AuditLogsTableCompanion extends UpdateCompanion<AuditLogsTableData> {
  final Value<int> id;
  final Value<String> action;
  final Value<String> entityType;
  final Value<String?> entityId;
  final Value<String> description;
  final Value<String> performedBy;
  final Value<String?> metadata;
  final Value<DateTime> performedAt;
  const AuditLogsTableCompanion({
    this.id = const Value.absent(),
    this.action = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.description = const Value.absent(),
    this.performedBy = const Value.absent(),
    this.metadata = const Value.absent(),
    this.performedAt = const Value.absent(),
  });
  AuditLogsTableCompanion.insert({
    this.id = const Value.absent(),
    required String action,
    required String entityType,
    this.entityId = const Value.absent(),
    required String description,
    this.performedBy = const Value.absent(),
    this.metadata = const Value.absent(),
    this.performedAt = const Value.absent(),
  })  : action = Value(action),
        entityType = Value(entityType),
        description = Value(description);
  static Insertable<AuditLogsTableData> custom({
    Expression<int>? id,
    Expression<String>? action,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? description,
    Expression<String>? performedBy,
    Expression<String>? metadata,
    Expression<DateTime>? performedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (action != null) 'action': action,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (description != null) 'description': description,
      if (performedBy != null) 'performed_by': performedBy,
      if (metadata != null) 'metadata': metadata,
      if (performedAt != null) 'performed_at': performedAt,
    });
  }

  AuditLogsTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? action,
      Value<String>? entityType,
      Value<String?>? entityId,
      Value<String>? description,
      Value<String>? performedBy,
      Value<String?>? metadata,
      Value<DateTime>? performedAt}) {
    return AuditLogsTableCompanion(
      id: id ?? this.id,
      action: action ?? this.action,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      description: description ?? this.description,
      performedBy: performedBy ?? this.performedBy,
      metadata: metadata ?? this.metadata,
      performedAt: performedAt ?? this.performedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (performedBy.present) {
      map['performed_by'] = Variable<String>(performedBy.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(metadata.value);
    }
    if (performedAt.present) {
      map['performed_at'] = Variable<DateTime>(performedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuditLogsTableCompanion(')
          ..write('id: $id, ')
          ..write('action: $action, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('description: $description, ')
          ..write('performedBy: $performedBy, ')
          ..write('metadata: $metadata, ')
          ..write('performedAt: $performedAt')
          ..write(')'))
        .toString();
  }
}

class $ProfilePricesTableTable extends ProfilePricesTable
    with TableInfo<$ProfilePricesTableTable, ProfilePricesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfilePricesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _connectionIdMeta =
      const VerificationMeta('connectionId');
  @override
  late final GeneratedColumn<int> connectionId = GeneratedColumn<int>(
      'connection_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _profileNameMeta =
      const VerificationMeta('profileName');
  @override
  late final GeneratedColumn<String> profileName = GeneratedColumn<String>(
      'profile_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('YER'));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, connectionId, profileName, price, currency, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profile_prices';
  @override
  VerificationContext validateIntegrity(
      Insertable<ProfilePricesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('connection_id')) {
      context.handle(
          _connectionIdMeta,
          connectionId.isAcceptableOrUnknown(
              data['connection_id']!, _connectionIdMeta));
    } else if (isInserting) {
      context.missing(_connectionIdMeta);
    }
    if (data.containsKey('profile_name')) {
      context.handle(
          _profileNameMeta,
          profileName.isAcceptableOrUnknown(
              data['profile_name']!, _profileNameMeta));
    } else if (isInserting) {
      context.missing(_profileNameMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProfilePricesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProfilePricesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      connectionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}connection_id'])!,
      profileName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_name'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ProfilePricesTableTable createAlias(String alias) {
    return $ProfilePricesTableTable(attachedDatabase, alias);
  }
}

class ProfilePricesTableData extends DataClass
    implements Insertable<ProfilePricesTableData> {
  final int id;
  final int connectionId;
  final String profileName;
  final double price;
  final String currency;
  final DateTime updatedAt;
  const ProfilePricesTableData(
      {required this.id,
      required this.connectionId,
      required this.profileName,
      required this.price,
      required this.currency,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['connection_id'] = Variable<int>(connectionId);
    map['profile_name'] = Variable<String>(profileName);
    map['price'] = Variable<double>(price);
    map['currency'] = Variable<String>(currency);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProfilePricesTableCompanion toCompanion(bool nullToAbsent) {
    return ProfilePricesTableCompanion(
      id: Value(id),
      connectionId: Value(connectionId),
      profileName: Value(profileName),
      price: Value(price),
      currency: Value(currency),
      updatedAt: Value(updatedAt),
    );
  }

  factory ProfilePricesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProfilePricesTableData(
      id: serializer.fromJson<int>(json['id']),
      connectionId: serializer.fromJson<int>(json['connectionId']),
      profileName: serializer.fromJson<String>(json['profileName']),
      price: serializer.fromJson<double>(json['price']),
      currency: serializer.fromJson<String>(json['currency']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'connectionId': serializer.toJson<int>(connectionId),
      'profileName': serializer.toJson<String>(profileName),
      'price': serializer.toJson<double>(price),
      'currency': serializer.toJson<String>(currency),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ProfilePricesTableData copyWith(
          {int? id,
          int? connectionId,
          String? profileName,
          double? price,
          String? currency,
          DateTime? updatedAt}) =>
      ProfilePricesTableData(
        id: id ?? this.id,
        connectionId: connectionId ?? this.connectionId,
        profileName: profileName ?? this.profileName,
        price: price ?? this.price,
        currency: currency ?? this.currency,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  ProfilePricesTableData copyWithCompanion(ProfilePricesTableCompanion data) {
    return ProfilePricesTableData(
      id: data.id.present ? data.id.value : this.id,
      connectionId: data.connectionId.present
          ? data.connectionId.value
          : this.connectionId,
      profileName:
          data.profileName.present ? data.profileName.value : this.profileName,
      price: data.price.present ? data.price.value : this.price,
      currency: data.currency.present ? data.currency.value : this.currency,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProfilePricesTableData(')
          ..write('id: $id, ')
          ..write('connectionId: $connectionId, ')
          ..write('profileName: $profileName, ')
          ..write('price: $price, ')
          ..write('currency: $currency, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, connectionId, profileName, price, currency, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProfilePricesTableData &&
          other.id == this.id &&
          other.connectionId == this.connectionId &&
          other.profileName == this.profileName &&
          other.price == this.price &&
          other.currency == this.currency &&
          other.updatedAt == this.updatedAt);
}

class ProfilePricesTableCompanion
    extends UpdateCompanion<ProfilePricesTableData> {
  final Value<int> id;
  final Value<int> connectionId;
  final Value<String> profileName;
  final Value<double> price;
  final Value<String> currency;
  final Value<DateTime> updatedAt;
  const ProfilePricesTableCompanion({
    this.id = const Value.absent(),
    this.connectionId = const Value.absent(),
    this.profileName = const Value.absent(),
    this.price = const Value.absent(),
    this.currency = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ProfilePricesTableCompanion.insert({
    this.id = const Value.absent(),
    required int connectionId,
    required String profileName,
    required double price,
    this.currency = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : connectionId = Value(connectionId),
        profileName = Value(profileName),
        price = Value(price);
  static Insertable<ProfilePricesTableData> custom({
    Expression<int>? id,
    Expression<int>? connectionId,
    Expression<String>? profileName,
    Expression<double>? price,
    Expression<String>? currency,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (connectionId != null) 'connection_id': connectionId,
      if (profileName != null) 'profile_name': profileName,
      if (price != null) 'price': price,
      if (currency != null) 'currency': currency,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ProfilePricesTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? connectionId,
      Value<String>? profileName,
      Value<double>? price,
      Value<String>? currency,
      Value<DateTime>? updatedAt}) {
    return ProfilePricesTableCompanion(
      id: id ?? this.id,
      connectionId: connectionId ?? this.connectionId,
      profileName: profileName ?? this.profileName,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (connectionId.present) {
      map['connection_id'] = Variable<int>(connectionId.value);
    }
    if (profileName.present) {
      map['profile_name'] = Variable<String>(profileName.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilePricesTableCompanion(')
          ..write('id: $id, ')
          ..write('connectionId: $connectionId, ')
          ..write('profileName: $profileName, ')
          ..write('price: $price, ')
          ..write('currency: $currency, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $UsageObservationsTableTable extends UsageObservationsTable
    with TableInfo<$UsageObservationsTableTable, UsageObservationsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsageObservationsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _connectionIdMeta =
      const VerificationMeta('connectionId');
  @override
  late final GeneratedColumn<int> connectionId = GeneratedColumn<int>(
      'connection_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _cardNameMeta =
      const VerificationMeta('cardName');
  @override
  late final GeneratedColumn<String> cardName = GeneratedColumn<String>(
      'card_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _profileMeta =
      const VerificationMeta('profile');
  @override
  late final GeneratedColumn<String> profile = GeneratedColumn<String>(
      'profile', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cardTypeMeta =
      const VerificationMeta('cardType');
  @override
  late final GeneratedColumn<String> cardType = GeneratedColumn<String>(
      'card_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('hotspot'));
  static const VerificationMeta _firstSeenAtMeta =
      const VerificationMeta('firstSeenAt');
  @override
  late final GeneratedColumn<DateTime> firstSeenAt = GeneratedColumn<DateTime>(
      'first_seen_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _dateIsApproximateMeta =
      const VerificationMeta('dateIsApproximate');
  @override
  late final GeneratedColumn<bool> dateIsApproximate = GeneratedColumn<bool>(
      'date_is_approximate', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("date_is_approximate" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        connectionId,
        cardName,
        profile,
        cardType,
        firstSeenAt,
        dateIsApproximate
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'usage_observations';
  @override
  VerificationContext validateIntegrity(
      Insertable<UsageObservationsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('connection_id')) {
      context.handle(
          _connectionIdMeta,
          connectionId.isAcceptableOrUnknown(
              data['connection_id']!, _connectionIdMeta));
    } else if (isInserting) {
      context.missing(_connectionIdMeta);
    }
    if (data.containsKey('card_name')) {
      context.handle(_cardNameMeta,
          cardName.isAcceptableOrUnknown(data['card_name']!, _cardNameMeta));
    } else if (isInserting) {
      context.missing(_cardNameMeta);
    }
    if (data.containsKey('profile')) {
      context.handle(_profileMeta,
          profile.isAcceptableOrUnknown(data['profile']!, _profileMeta));
    } else if (isInserting) {
      context.missing(_profileMeta);
    }
    if (data.containsKey('card_type')) {
      context.handle(_cardTypeMeta,
          cardType.isAcceptableOrUnknown(data['card_type']!, _cardTypeMeta));
    }
    if (data.containsKey('first_seen_at')) {
      context.handle(
          _firstSeenAtMeta,
          firstSeenAt.isAcceptableOrUnknown(
              data['first_seen_at']!, _firstSeenAtMeta));
    }
    if (data.containsKey('date_is_approximate')) {
      context.handle(
          _dateIsApproximateMeta,
          dateIsApproximate.isAcceptableOrUnknown(
              data['date_is_approximate']!, _dateIsApproximateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UsageObservationsTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UsageObservationsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      connectionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}connection_id'])!,
      cardName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}card_name'])!,
      profile: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile'])!,
      cardType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}card_type'])!,
      firstSeenAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}first_seen_at'])!,
      dateIsApproximate: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}date_is_approximate'])!,
    );
  }

  @override
  $UsageObservationsTableTable createAlias(String alias) {
    return $UsageObservationsTableTable(attachedDatabase, alias);
  }
}

class UsageObservationsTableData extends DataClass
    implements Insertable<UsageObservationsTableData> {
  final int id;
  final int connectionId;
  final String cardName;
  final String profile;
  final String cardType;
  final DateTime firstSeenAt;
  final bool dateIsApproximate;
  const UsageObservationsTableData(
      {required this.id,
      required this.connectionId,
      required this.cardName,
      required this.profile,
      required this.cardType,
      required this.firstSeenAt,
      required this.dateIsApproximate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['connection_id'] = Variable<int>(connectionId);
    map['card_name'] = Variable<String>(cardName);
    map['profile'] = Variable<String>(profile);
    map['card_type'] = Variable<String>(cardType);
    map['first_seen_at'] = Variable<DateTime>(firstSeenAt);
    map['date_is_approximate'] = Variable<bool>(dateIsApproximate);
    return map;
  }

  UsageObservationsTableCompanion toCompanion(bool nullToAbsent) {
    return UsageObservationsTableCompanion(
      id: Value(id),
      connectionId: Value(connectionId),
      cardName: Value(cardName),
      profile: Value(profile),
      cardType: Value(cardType),
      firstSeenAt: Value(firstSeenAt),
      dateIsApproximate: Value(dateIsApproximate),
    );
  }

  factory UsageObservationsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UsageObservationsTableData(
      id: serializer.fromJson<int>(json['id']),
      connectionId: serializer.fromJson<int>(json['connectionId']),
      cardName: serializer.fromJson<String>(json['cardName']),
      profile: serializer.fromJson<String>(json['profile']),
      cardType: serializer.fromJson<String>(json['cardType']),
      firstSeenAt: serializer.fromJson<DateTime>(json['firstSeenAt']),
      dateIsApproximate: serializer.fromJson<bool>(json['dateIsApproximate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'connectionId': serializer.toJson<int>(connectionId),
      'cardName': serializer.toJson<String>(cardName),
      'profile': serializer.toJson<String>(profile),
      'cardType': serializer.toJson<String>(cardType),
      'firstSeenAt': serializer.toJson<DateTime>(firstSeenAt),
      'dateIsApproximate': serializer.toJson<bool>(dateIsApproximate),
    };
  }

  UsageObservationsTableData copyWith(
          {int? id,
          int? connectionId,
          String? cardName,
          String? profile,
          String? cardType,
          DateTime? firstSeenAt,
          bool? dateIsApproximate}) =>
      UsageObservationsTableData(
        id: id ?? this.id,
        connectionId: connectionId ?? this.connectionId,
        cardName: cardName ?? this.cardName,
        profile: profile ?? this.profile,
        cardType: cardType ?? this.cardType,
        firstSeenAt: firstSeenAt ?? this.firstSeenAt,
        dateIsApproximate: dateIsApproximate ?? this.dateIsApproximate,
      );
  UsageObservationsTableData copyWithCompanion(
      UsageObservationsTableCompanion data) {
    return UsageObservationsTableData(
      id: data.id.present ? data.id.value : this.id,
      connectionId: data.connectionId.present
          ? data.connectionId.value
          : this.connectionId,
      cardName: data.cardName.present ? data.cardName.value : this.cardName,
      profile: data.profile.present ? data.profile.value : this.profile,
      cardType: data.cardType.present ? data.cardType.value : this.cardType,
      firstSeenAt:
          data.firstSeenAt.present ? data.firstSeenAt.value : this.firstSeenAt,
      dateIsApproximate: data.dateIsApproximate.present
          ? data.dateIsApproximate.value
          : this.dateIsApproximate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UsageObservationsTableData(')
          ..write('id: $id, ')
          ..write('connectionId: $connectionId, ')
          ..write('cardName: $cardName, ')
          ..write('profile: $profile, ')
          ..write('cardType: $cardType, ')
          ..write('firstSeenAt: $firstSeenAt, ')
          ..write('dateIsApproximate: $dateIsApproximate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, connectionId, cardName, profile, cardType,
      firstSeenAt, dateIsApproximate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UsageObservationsTableData &&
          other.id == this.id &&
          other.connectionId == this.connectionId &&
          other.cardName == this.cardName &&
          other.profile == this.profile &&
          other.cardType == this.cardType &&
          other.firstSeenAt == this.firstSeenAt &&
          other.dateIsApproximate == this.dateIsApproximate);
}

class UsageObservationsTableCompanion
    extends UpdateCompanion<UsageObservationsTableData> {
  final Value<int> id;
  final Value<int> connectionId;
  final Value<String> cardName;
  final Value<String> profile;
  final Value<String> cardType;
  final Value<DateTime> firstSeenAt;
  final Value<bool> dateIsApproximate;
  const UsageObservationsTableCompanion({
    this.id = const Value.absent(),
    this.connectionId = const Value.absent(),
    this.cardName = const Value.absent(),
    this.profile = const Value.absent(),
    this.cardType = const Value.absent(),
    this.firstSeenAt = const Value.absent(),
    this.dateIsApproximate = const Value.absent(),
  });
  UsageObservationsTableCompanion.insert({
    this.id = const Value.absent(),
    required int connectionId,
    required String cardName,
    required String profile,
    this.cardType = const Value.absent(),
    this.firstSeenAt = const Value.absent(),
    this.dateIsApproximate = const Value.absent(),
  })  : connectionId = Value(connectionId),
        cardName = Value(cardName),
        profile = Value(profile);
  static Insertable<UsageObservationsTableData> custom({
    Expression<int>? id,
    Expression<int>? connectionId,
    Expression<String>? cardName,
    Expression<String>? profile,
    Expression<String>? cardType,
    Expression<DateTime>? firstSeenAt,
    Expression<bool>? dateIsApproximate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (connectionId != null) 'connection_id': connectionId,
      if (cardName != null) 'card_name': cardName,
      if (profile != null) 'profile': profile,
      if (cardType != null) 'card_type': cardType,
      if (firstSeenAt != null) 'first_seen_at': firstSeenAt,
      if (dateIsApproximate != null) 'date_is_approximate': dateIsApproximate,
    });
  }

  UsageObservationsTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? connectionId,
      Value<String>? cardName,
      Value<String>? profile,
      Value<String>? cardType,
      Value<DateTime>? firstSeenAt,
      Value<bool>? dateIsApproximate}) {
    return UsageObservationsTableCompanion(
      id: id ?? this.id,
      connectionId: connectionId ?? this.connectionId,
      cardName: cardName ?? this.cardName,
      profile: profile ?? this.profile,
      cardType: cardType ?? this.cardType,
      firstSeenAt: firstSeenAt ?? this.firstSeenAt,
      dateIsApproximate: dateIsApproximate ?? this.dateIsApproximate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (connectionId.present) {
      map['connection_id'] = Variable<int>(connectionId.value);
    }
    if (cardName.present) {
      map['card_name'] = Variable<String>(cardName.value);
    }
    if (profile.present) {
      map['profile'] = Variable<String>(profile.value);
    }
    if (cardType.present) {
      map['card_type'] = Variable<String>(cardType.value);
    }
    if (firstSeenAt.present) {
      map['first_seen_at'] = Variable<DateTime>(firstSeenAt.value);
    }
    if (dateIsApproximate.present) {
      map['date_is_approximate'] = Variable<bool>(dateIsApproximate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsageObservationsTableCompanion(')
          ..write('id: $id, ')
          ..write('connectionId: $connectionId, ')
          ..write('cardName: $cardName, ')
          ..write('profile: $profile, ')
          ..write('cardType: $cardType, ')
          ..write('firstSeenAt: $firstSeenAt, ')
          ..write('dateIsApproximate: $dateIsApproximate')
          ..write(')'))
        .toString();
  }
}

class $CardEventsTableTable extends CardEventsTable
    with TableInfo<$CardEventsTableTable, CardEventsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardEventsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _connectionIdMeta =
      const VerificationMeta('connectionId');
  @override
  late final GeneratedColumn<int> connectionId = GeneratedColumn<int>(
      'connection_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _countMeta = const VerificationMeta('count');
  @override
  late final GeneratedColumn<int> count = GeneratedColumn<int>(
      'count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _profileMeta =
      const VerificationMeta('profile');
  @override
  late final GeneratedColumn<String> profile = GeneratedColumn<String>(
      'profile', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<DateTime> at = GeneratedColumn<DateTime>(
      'at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, connectionId, type, count, profile, at];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'card_events';
  @override
  VerificationContext validateIntegrity(
      Insertable<CardEventsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('connection_id')) {
      context.handle(
          _connectionIdMeta,
          connectionId.isAcceptableOrUnknown(
              data['connection_id']!, _connectionIdMeta));
    } else if (isInserting) {
      context.missing(_connectionIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('count')) {
      context.handle(
          _countMeta, count.isAcceptableOrUnknown(data['count']!, _countMeta));
    } else if (isInserting) {
      context.missing(_countMeta);
    }
    if (data.containsKey('profile')) {
      context.handle(_profileMeta,
          profile.isAcceptableOrUnknown(data['profile']!, _profileMeta));
    } else if (isInserting) {
      context.missing(_profileMeta);
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CardEventsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CardEventsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      connectionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}connection_id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      count: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}count'])!,
      profile: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile'])!,
      at: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}at'])!,
    );
  }

  @override
  $CardEventsTableTable createAlias(String alias) {
    return $CardEventsTableTable(attachedDatabase, alias);
  }
}

class CardEventsTableData extends DataClass
    implements Insertable<CardEventsTableData> {
  final int id;
  final int connectionId;
  final String type;
  final int count;
  final String profile;
  final DateTime at;
  const CardEventsTableData(
      {required this.id,
      required this.connectionId,
      required this.type,
      required this.count,
      required this.profile,
      required this.at});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['connection_id'] = Variable<int>(connectionId);
    map['type'] = Variable<String>(type);
    map['count'] = Variable<int>(count);
    map['profile'] = Variable<String>(profile);
    map['at'] = Variable<DateTime>(at);
    return map;
  }

  CardEventsTableCompanion toCompanion(bool nullToAbsent) {
    return CardEventsTableCompanion(
      id: Value(id),
      connectionId: Value(connectionId),
      type: Value(type),
      count: Value(count),
      profile: Value(profile),
      at: Value(at),
    );
  }

  factory CardEventsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CardEventsTableData(
      id: serializer.fromJson<int>(json['id']),
      connectionId: serializer.fromJson<int>(json['connectionId']),
      type: serializer.fromJson<String>(json['type']),
      count: serializer.fromJson<int>(json['count']),
      profile: serializer.fromJson<String>(json['profile']),
      at: serializer.fromJson<DateTime>(json['at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'connectionId': serializer.toJson<int>(connectionId),
      'type': serializer.toJson<String>(type),
      'count': serializer.toJson<int>(count),
      'profile': serializer.toJson<String>(profile),
      'at': serializer.toJson<DateTime>(at),
    };
  }

  CardEventsTableData copyWith(
          {int? id,
          int? connectionId,
          String? type,
          int? count,
          String? profile,
          DateTime? at}) =>
      CardEventsTableData(
        id: id ?? this.id,
        connectionId: connectionId ?? this.connectionId,
        type: type ?? this.type,
        count: count ?? this.count,
        profile: profile ?? this.profile,
        at: at ?? this.at,
      );
  CardEventsTableData copyWithCompanion(CardEventsTableCompanion data) {
    return CardEventsTableData(
      id: data.id.present ? data.id.value : this.id,
      connectionId: data.connectionId.present
          ? data.connectionId.value
          : this.connectionId,
      type: data.type.present ? data.type.value : this.type,
      count: data.count.present ? data.count.value : this.count,
      profile: data.profile.present ? data.profile.value : this.profile,
      at: data.at.present ? data.at.value : this.at,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CardEventsTableData(')
          ..write('id: $id, ')
          ..write('connectionId: $connectionId, ')
          ..write('type: $type, ')
          ..write('count: $count, ')
          ..write('profile: $profile, ')
          ..write('at: $at')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, connectionId, type, count, profile, at);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardEventsTableData &&
          other.id == this.id &&
          other.connectionId == this.connectionId &&
          other.type == this.type &&
          other.count == this.count &&
          other.profile == this.profile &&
          other.at == this.at);
}

class CardEventsTableCompanion extends UpdateCompanion<CardEventsTableData> {
  final Value<int> id;
  final Value<int> connectionId;
  final Value<String> type;
  final Value<int> count;
  final Value<String> profile;
  final Value<DateTime> at;
  const CardEventsTableCompanion({
    this.id = const Value.absent(),
    this.connectionId = const Value.absent(),
    this.type = const Value.absent(),
    this.count = const Value.absent(),
    this.profile = const Value.absent(),
    this.at = const Value.absent(),
  });
  CardEventsTableCompanion.insert({
    this.id = const Value.absent(),
    required int connectionId,
    required String type,
    required int count,
    required String profile,
    this.at = const Value.absent(),
  })  : connectionId = Value(connectionId),
        type = Value(type),
        count = Value(count),
        profile = Value(profile);
  static Insertable<CardEventsTableData> custom({
    Expression<int>? id,
    Expression<int>? connectionId,
    Expression<String>? type,
    Expression<int>? count,
    Expression<String>? profile,
    Expression<DateTime>? at,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (connectionId != null) 'connection_id': connectionId,
      if (type != null) 'type': type,
      if (count != null) 'count': count,
      if (profile != null) 'profile': profile,
      if (at != null) 'at': at,
    });
  }

  CardEventsTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? connectionId,
      Value<String>? type,
      Value<int>? count,
      Value<String>? profile,
      Value<DateTime>? at}) {
    return CardEventsTableCompanion(
      id: id ?? this.id,
      connectionId: connectionId ?? this.connectionId,
      type: type ?? this.type,
      count: count ?? this.count,
      profile: profile ?? this.profile,
      at: at ?? this.at,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (connectionId.present) {
      map['connection_id'] = Variable<int>(connectionId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (count.present) {
      map['count'] = Variable<int>(count.value);
    }
    if (profile.present) {
      map['profile'] = Variable<String>(profile.value);
    }
    if (at.present) {
      map['at'] = Variable<DateTime>(at.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardEventsTableCompanion(')
          ..write('id: $id, ')
          ..write('connectionId: $connectionId, ')
          ..write('type: $type, ')
          ..write('count: $count, ')
          ..write('profile: $profile, ')
          ..write('at: $at')
          ..write(')'))
        .toString();
  }
}

class $PaymentsTableTable extends PaymentsTable
    with TableInfo<$PaymentsTableTable, PaymentsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _connectionIdMeta =
      const VerificationMeta('connectionId');
  @override
  late final GeneratedColumn<int> connectionId = GeneratedColumn<int>(
      'connection_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _receivedAtMeta =
      const VerificationMeta('receivedAt');
  @override
  late final GeneratedColumn<DateTime> receivedAt = GeneratedColumn<DateTime>(
      'received_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, connectionId, amount, note, receivedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payments';
  @override
  VerificationContext validateIntegrity(Insertable<PaymentsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('connection_id')) {
      context.handle(
          _connectionIdMeta,
          connectionId.isAcceptableOrUnknown(
              data['connection_id']!, _connectionIdMeta));
    } else if (isInserting) {
      context.missing(_connectionIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('received_at')) {
      context.handle(
          _receivedAtMeta,
          receivedAt.isAcceptableOrUnknown(
              data['received_at']!, _receivedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PaymentsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PaymentsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      connectionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}connection_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      receivedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}received_at'])!,
    );
  }

  @override
  $PaymentsTableTable createAlias(String alias) {
    return $PaymentsTableTable(attachedDatabase, alias);
  }
}

class PaymentsTableData extends DataClass
    implements Insertable<PaymentsTableData> {
  final int id;
  final int connectionId;
  final double amount;
  final String? note;
  final DateTime receivedAt;
  const PaymentsTableData(
      {required this.id,
      required this.connectionId,
      required this.amount,
      this.note,
      required this.receivedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['connection_id'] = Variable<int>(connectionId);
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['received_at'] = Variable<DateTime>(receivedAt);
    return map;
  }

  PaymentsTableCompanion toCompanion(bool nullToAbsent) {
    return PaymentsTableCompanion(
      id: Value(id),
      connectionId: Value(connectionId),
      amount: Value(amount),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      receivedAt: Value(receivedAt),
    );
  }

  factory PaymentsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PaymentsTableData(
      id: serializer.fromJson<int>(json['id']),
      connectionId: serializer.fromJson<int>(json['connectionId']),
      amount: serializer.fromJson<double>(json['amount']),
      note: serializer.fromJson<String?>(json['note']),
      receivedAt: serializer.fromJson<DateTime>(json['receivedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'connectionId': serializer.toJson<int>(connectionId),
      'amount': serializer.toJson<double>(amount),
      'note': serializer.toJson<String?>(note),
      'receivedAt': serializer.toJson<DateTime>(receivedAt),
    };
  }

  PaymentsTableData copyWith(
          {int? id,
          int? connectionId,
          double? amount,
          Value<String?> note = const Value.absent(),
          DateTime? receivedAt}) =>
      PaymentsTableData(
        id: id ?? this.id,
        connectionId: connectionId ?? this.connectionId,
        amount: amount ?? this.amount,
        note: note.present ? note.value : this.note,
        receivedAt: receivedAt ?? this.receivedAt,
      );
  PaymentsTableData copyWithCompanion(PaymentsTableCompanion data) {
    return PaymentsTableData(
      id: data.id.present ? data.id.value : this.id,
      connectionId: data.connectionId.present
          ? data.connectionId.value
          : this.connectionId,
      amount: data.amount.present ? data.amount.value : this.amount,
      note: data.note.present ? data.note.value : this.note,
      receivedAt:
          data.receivedAt.present ? data.receivedAt.value : this.receivedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PaymentsTableData(')
          ..write('id: $id, ')
          ..write('connectionId: $connectionId, ')
          ..write('amount: $amount, ')
          ..write('note: $note, ')
          ..write('receivedAt: $receivedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, connectionId, amount, note, receivedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaymentsTableData &&
          other.id == this.id &&
          other.connectionId == this.connectionId &&
          other.amount == this.amount &&
          other.note == this.note &&
          other.receivedAt == this.receivedAt);
}

class PaymentsTableCompanion extends UpdateCompanion<PaymentsTableData> {
  final Value<int> id;
  final Value<int> connectionId;
  final Value<double> amount;
  final Value<String?> note;
  final Value<DateTime> receivedAt;
  const PaymentsTableCompanion({
    this.id = const Value.absent(),
    this.connectionId = const Value.absent(),
    this.amount = const Value.absent(),
    this.note = const Value.absent(),
    this.receivedAt = const Value.absent(),
  });
  PaymentsTableCompanion.insert({
    this.id = const Value.absent(),
    required int connectionId,
    required double amount,
    this.note = const Value.absent(),
    this.receivedAt = const Value.absent(),
  })  : connectionId = Value(connectionId),
        amount = Value(amount);
  static Insertable<PaymentsTableData> custom({
    Expression<int>? id,
    Expression<int>? connectionId,
    Expression<double>? amount,
    Expression<String>? note,
    Expression<DateTime>? receivedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (connectionId != null) 'connection_id': connectionId,
      if (amount != null) 'amount': amount,
      if (note != null) 'note': note,
      if (receivedAt != null) 'received_at': receivedAt,
    });
  }

  PaymentsTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? connectionId,
      Value<double>? amount,
      Value<String?>? note,
      Value<DateTime>? receivedAt}) {
    return PaymentsTableCompanion(
      id: id ?? this.id,
      connectionId: connectionId ?? this.connectionId,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      receivedAt: receivedAt ?? this.receivedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (connectionId.present) {
      map['connection_id'] = Variable<int>(connectionId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (receivedAt.present) {
      map['received_at'] = Variable<DateTime>(receivedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentsTableCompanion(')
          ..write('id: $id, ')
          ..write('connectionId: $connectionId, ')
          ..write('amount: $amount, ')
          ..write('note: $note, ')
          ..write('receivedAt: $receivedAt')
          ..write(')'))
        .toString();
  }
}

class $PdfArchiveTableTable extends PdfArchiveTable
    with TableInfo<$PdfArchiveTableTable, PdfArchiveTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PdfArchiveTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _connectionIdMeta =
      const VerificationMeta('connectionId');
  @override
  late final GeneratedColumn<int> connectionId = GeneratedColumn<int>(
      'connection_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _batchIdMeta =
      const VerificationMeta('batchId');
  @override
  late final GeneratedColumn<String> batchId = GeneratedColumn<String>(
      'batch_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _filePathMeta =
      const VerificationMeta('filePath');
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
      'file_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _templateIdMeta =
      const VerificationMeta('templateId');
  @override
  late final GeneratedColumn<int> templateId = GeneratedColumn<int>(
      'template_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, connectionId, batchId, filePath, templateId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pdf_archive';
  @override
  VerificationContext validateIntegrity(
      Insertable<PdfArchiveTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('connection_id')) {
      context.handle(
          _connectionIdMeta,
          connectionId.isAcceptableOrUnknown(
              data['connection_id']!, _connectionIdMeta));
    } else if (isInserting) {
      context.missing(_connectionIdMeta);
    }
    if (data.containsKey('batch_id')) {
      context.handle(_batchIdMeta,
          batchId.isAcceptableOrUnknown(data['batch_id']!, _batchIdMeta));
    } else if (isInserting) {
      context.missing(_batchIdMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(_filePathMeta,
          filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta));
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('template_id')) {
      context.handle(
          _templateIdMeta,
          templateId.isAcceptableOrUnknown(
              data['template_id']!, _templateIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PdfArchiveTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PdfArchiveTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      connectionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}connection_id'])!,
      batchId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}batch_id'])!,
      filePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_path'])!,
      templateId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}template_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $PdfArchiveTableTable createAlias(String alias) {
    return $PdfArchiveTableTable(attachedDatabase, alias);
  }
}

class PdfArchiveTableData extends DataClass
    implements Insertable<PdfArchiveTableData> {
  final int id;
  final int connectionId;
  final String batchId;
  final String filePath;
  final int? templateId;
  final DateTime createdAt;
  const PdfArchiveTableData(
      {required this.id,
      required this.connectionId,
      required this.batchId,
      required this.filePath,
      this.templateId,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['connection_id'] = Variable<int>(connectionId);
    map['batch_id'] = Variable<String>(batchId);
    map['file_path'] = Variable<String>(filePath);
    if (!nullToAbsent || templateId != null) {
      map['template_id'] = Variable<int>(templateId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PdfArchiveTableCompanion toCompanion(bool nullToAbsent) {
    return PdfArchiveTableCompanion(
      id: Value(id),
      connectionId: Value(connectionId),
      batchId: Value(batchId),
      filePath: Value(filePath),
      templateId: templateId == null && nullToAbsent
          ? const Value.absent()
          : Value(templateId),
      createdAt: Value(createdAt),
    );
  }

  factory PdfArchiveTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PdfArchiveTableData(
      id: serializer.fromJson<int>(json['id']),
      connectionId: serializer.fromJson<int>(json['connectionId']),
      batchId: serializer.fromJson<String>(json['batchId']),
      filePath: serializer.fromJson<String>(json['filePath']),
      templateId: serializer.fromJson<int?>(json['templateId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'connectionId': serializer.toJson<int>(connectionId),
      'batchId': serializer.toJson<String>(batchId),
      'filePath': serializer.toJson<String>(filePath),
      'templateId': serializer.toJson<int?>(templateId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PdfArchiveTableData copyWith(
          {int? id,
          int? connectionId,
          String? batchId,
          String? filePath,
          Value<int?> templateId = const Value.absent(),
          DateTime? createdAt}) =>
      PdfArchiveTableData(
        id: id ?? this.id,
        connectionId: connectionId ?? this.connectionId,
        batchId: batchId ?? this.batchId,
        filePath: filePath ?? this.filePath,
        templateId: templateId.present ? templateId.value : this.templateId,
        createdAt: createdAt ?? this.createdAt,
      );
  PdfArchiveTableData copyWithCompanion(PdfArchiveTableCompanion data) {
    return PdfArchiveTableData(
      id: data.id.present ? data.id.value : this.id,
      connectionId: data.connectionId.present
          ? data.connectionId.value
          : this.connectionId,
      batchId: data.batchId.present ? data.batchId.value : this.batchId,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      templateId:
          data.templateId.present ? data.templateId.value : this.templateId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PdfArchiveTableData(')
          ..write('id: $id, ')
          ..write('connectionId: $connectionId, ')
          ..write('batchId: $batchId, ')
          ..write('filePath: $filePath, ')
          ..write('templateId: $templateId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, connectionId, batchId, filePath, templateId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PdfArchiveTableData &&
          other.id == this.id &&
          other.connectionId == this.connectionId &&
          other.batchId == this.batchId &&
          other.filePath == this.filePath &&
          other.templateId == this.templateId &&
          other.createdAt == this.createdAt);
}

class PdfArchiveTableCompanion extends UpdateCompanion<PdfArchiveTableData> {
  final Value<int> id;
  final Value<int> connectionId;
  final Value<String> batchId;
  final Value<String> filePath;
  final Value<int?> templateId;
  final Value<DateTime> createdAt;
  const PdfArchiveTableCompanion({
    this.id = const Value.absent(),
    this.connectionId = const Value.absent(),
    this.batchId = const Value.absent(),
    this.filePath = const Value.absent(),
    this.templateId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PdfArchiveTableCompanion.insert({
    this.id = const Value.absent(),
    required int connectionId,
    required String batchId,
    required String filePath,
    this.templateId = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : connectionId = Value(connectionId),
        batchId = Value(batchId),
        filePath = Value(filePath);
  static Insertable<PdfArchiveTableData> custom({
    Expression<int>? id,
    Expression<int>? connectionId,
    Expression<String>? batchId,
    Expression<String>? filePath,
    Expression<int>? templateId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (connectionId != null) 'connection_id': connectionId,
      if (batchId != null) 'batch_id': batchId,
      if (filePath != null) 'file_path': filePath,
      if (templateId != null) 'template_id': templateId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PdfArchiveTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? connectionId,
      Value<String>? batchId,
      Value<String>? filePath,
      Value<int?>? templateId,
      Value<DateTime>? createdAt}) {
    return PdfArchiveTableCompanion(
      id: id ?? this.id,
      connectionId: connectionId ?? this.connectionId,
      batchId: batchId ?? this.batchId,
      filePath: filePath ?? this.filePath,
      templateId: templateId ?? this.templateId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (connectionId.present) {
      map['connection_id'] = Variable<int>(connectionId.value);
    }
    if (batchId.present) {
      map['batch_id'] = Variable<String>(batchId.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (templateId.present) {
      map['template_id'] = Variable<int>(templateId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PdfArchiveTableCompanion(')
          ..write('id: $id, ')
          ..write('connectionId: $connectionId, ')
          ..write('batchId: $batchId, ')
          ..write('filePath: $filePath, ')
          ..write('templateId: $templateId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ApDevicesTableTable extends ApDevicesTable
    with TableInfo<$ApDevicesTableTable, ApDevicesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ApDevicesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _connectionIdMeta =
      const VerificationMeta('connectionId');
  @override
  late final GeneratedColumn<int> connectionId = GeneratedColumn<int>(
      'connection_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ipMeta = const VerificationMeta('ip');
  @override
  late final GeneratedColumn<String> ip = GeneratedColumn<String>(
      'ip', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _vendorMeta = const VerificationMeta('vendor');
  @override
  late final GeneratedColumn<String> vendor = GeneratedColumn<String>(
      'vendor', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('MikroTik'));
  static const VerificationMeta _lastCheckAtMeta =
      const VerificationMeta('lastCheckAt');
  @override
  late final GeneratedColumn<DateTime> lastCheckAt = GeneratedColumn<DateTime>(
      'last_check_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _accessStateMeta =
      const VerificationMeta('accessState');
  @override
  late final GeneratedColumn<String> accessState = GeneratedColumn<String>(
      'access_state', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('unknown'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, connectionId, name, ip, vendor, lastCheckAt, accessState];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ap_devices';
  @override
  VerificationContext validateIntegrity(Insertable<ApDevicesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('connection_id')) {
      context.handle(
          _connectionIdMeta,
          connectionId.isAcceptableOrUnknown(
              data['connection_id']!, _connectionIdMeta));
    } else if (isInserting) {
      context.missing(_connectionIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('ip')) {
      context.handle(_ipMeta, ip.isAcceptableOrUnknown(data['ip']!, _ipMeta));
    } else if (isInserting) {
      context.missing(_ipMeta);
    }
    if (data.containsKey('vendor')) {
      context.handle(_vendorMeta,
          vendor.isAcceptableOrUnknown(data['vendor']!, _vendorMeta));
    }
    if (data.containsKey('last_check_at')) {
      context.handle(
          _lastCheckAtMeta,
          lastCheckAt.isAcceptableOrUnknown(
              data['last_check_at']!, _lastCheckAtMeta));
    }
    if (data.containsKey('access_state')) {
      context.handle(
          _accessStateMeta,
          accessState.isAcceptableOrUnknown(
              data['access_state']!, _accessStateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ApDevicesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ApDevicesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      connectionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}connection_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      ip: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ip'])!,
      vendor: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}vendor'])!,
      lastCheckAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_check_at']),
      accessState: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}access_state'])!,
    );
  }

  @override
  $ApDevicesTableTable createAlias(String alias) {
    return $ApDevicesTableTable(attachedDatabase, alias);
  }
}

class ApDevicesTableData extends DataClass
    implements Insertable<ApDevicesTableData> {
  final int id;
  final int connectionId;
  final String name;
  final String ip;
  final String vendor;
  final DateTime? lastCheckAt;
  final String accessState;
  const ApDevicesTableData(
      {required this.id,
      required this.connectionId,
      required this.name,
      required this.ip,
      required this.vendor,
      this.lastCheckAt,
      required this.accessState});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['connection_id'] = Variable<int>(connectionId);
    map['name'] = Variable<String>(name);
    map['ip'] = Variable<String>(ip);
    map['vendor'] = Variable<String>(vendor);
    if (!nullToAbsent || lastCheckAt != null) {
      map['last_check_at'] = Variable<DateTime>(lastCheckAt);
    }
    map['access_state'] = Variable<String>(accessState);
    return map;
  }

  ApDevicesTableCompanion toCompanion(bool nullToAbsent) {
    return ApDevicesTableCompanion(
      id: Value(id),
      connectionId: Value(connectionId),
      name: Value(name),
      ip: Value(ip),
      vendor: Value(vendor),
      lastCheckAt: lastCheckAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastCheckAt),
      accessState: Value(accessState),
    );
  }

  factory ApDevicesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ApDevicesTableData(
      id: serializer.fromJson<int>(json['id']),
      connectionId: serializer.fromJson<int>(json['connectionId']),
      name: serializer.fromJson<String>(json['name']),
      ip: serializer.fromJson<String>(json['ip']),
      vendor: serializer.fromJson<String>(json['vendor']),
      lastCheckAt: serializer.fromJson<DateTime?>(json['lastCheckAt']),
      accessState: serializer.fromJson<String>(json['accessState']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'connectionId': serializer.toJson<int>(connectionId),
      'name': serializer.toJson<String>(name),
      'ip': serializer.toJson<String>(ip),
      'vendor': serializer.toJson<String>(vendor),
      'lastCheckAt': serializer.toJson<DateTime?>(lastCheckAt),
      'accessState': serializer.toJson<String>(accessState),
    };
  }

  ApDevicesTableData copyWith(
          {int? id,
          int? connectionId,
          String? name,
          String? ip,
          String? vendor,
          Value<DateTime?> lastCheckAt = const Value.absent(),
          String? accessState}) =>
      ApDevicesTableData(
        id: id ?? this.id,
        connectionId: connectionId ?? this.connectionId,
        name: name ?? this.name,
        ip: ip ?? this.ip,
        vendor: vendor ?? this.vendor,
        lastCheckAt: lastCheckAt.present ? lastCheckAt.value : this.lastCheckAt,
        accessState: accessState ?? this.accessState,
      );
  ApDevicesTableData copyWithCompanion(ApDevicesTableCompanion data) {
    return ApDevicesTableData(
      id: data.id.present ? data.id.value : this.id,
      connectionId: data.connectionId.present
          ? data.connectionId.value
          : this.connectionId,
      name: data.name.present ? data.name.value : this.name,
      ip: data.ip.present ? data.ip.value : this.ip,
      vendor: data.vendor.present ? data.vendor.value : this.vendor,
      lastCheckAt:
          data.lastCheckAt.present ? data.lastCheckAt.value : this.lastCheckAt,
      accessState:
          data.accessState.present ? data.accessState.value : this.accessState,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ApDevicesTableData(')
          ..write('id: $id, ')
          ..write('connectionId: $connectionId, ')
          ..write('name: $name, ')
          ..write('ip: $ip, ')
          ..write('vendor: $vendor, ')
          ..write('lastCheckAt: $lastCheckAt, ')
          ..write('accessState: $accessState')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, connectionId, name, ip, vendor, lastCheckAt, accessState);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ApDevicesTableData &&
          other.id == this.id &&
          other.connectionId == this.connectionId &&
          other.name == this.name &&
          other.ip == this.ip &&
          other.vendor == this.vendor &&
          other.lastCheckAt == this.lastCheckAt &&
          other.accessState == this.accessState);
}

class ApDevicesTableCompanion extends UpdateCompanion<ApDevicesTableData> {
  final Value<int> id;
  final Value<int> connectionId;
  final Value<String> name;
  final Value<String> ip;
  final Value<String> vendor;
  final Value<DateTime?> lastCheckAt;
  final Value<String> accessState;
  const ApDevicesTableCompanion({
    this.id = const Value.absent(),
    this.connectionId = const Value.absent(),
    this.name = const Value.absent(),
    this.ip = const Value.absent(),
    this.vendor = const Value.absent(),
    this.lastCheckAt = const Value.absent(),
    this.accessState = const Value.absent(),
  });
  ApDevicesTableCompanion.insert({
    this.id = const Value.absent(),
    required int connectionId,
    required String name,
    required String ip,
    this.vendor = const Value.absent(),
    this.lastCheckAt = const Value.absent(),
    this.accessState = const Value.absent(),
  })  : connectionId = Value(connectionId),
        name = Value(name),
        ip = Value(ip);
  static Insertable<ApDevicesTableData> custom({
    Expression<int>? id,
    Expression<int>? connectionId,
    Expression<String>? name,
    Expression<String>? ip,
    Expression<String>? vendor,
    Expression<DateTime>? lastCheckAt,
    Expression<String>? accessState,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (connectionId != null) 'connection_id': connectionId,
      if (name != null) 'name': name,
      if (ip != null) 'ip': ip,
      if (vendor != null) 'vendor': vendor,
      if (lastCheckAt != null) 'last_check_at': lastCheckAt,
      if (accessState != null) 'access_state': accessState,
    });
  }

  ApDevicesTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? connectionId,
      Value<String>? name,
      Value<String>? ip,
      Value<String>? vendor,
      Value<DateTime?>? lastCheckAt,
      Value<String>? accessState}) {
    return ApDevicesTableCompanion(
      id: id ?? this.id,
      connectionId: connectionId ?? this.connectionId,
      name: name ?? this.name,
      ip: ip ?? this.ip,
      vendor: vendor ?? this.vendor,
      lastCheckAt: lastCheckAt ?? this.lastCheckAt,
      accessState: accessState ?? this.accessState,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (connectionId.present) {
      map['connection_id'] = Variable<int>(connectionId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (ip.present) {
      map['ip'] = Variable<String>(ip.value);
    }
    if (vendor.present) {
      map['vendor'] = Variable<String>(vendor.value);
    }
    if (lastCheckAt.present) {
      map['last_check_at'] = Variable<DateTime>(lastCheckAt.value);
    }
    if (accessState.present) {
      map['access_state'] = Variable<String>(accessState.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ApDevicesTableCompanion(')
          ..write('id: $id, ')
          ..write('connectionId: $connectionId, ')
          ..write('name: $name, ')
          ..write('ip: $ip, ')
          ..write('vendor: $vendor, ')
          ..write('lastCheckAt: $lastCheckAt, ')
          ..write('accessState: $accessState')
          ..write(')'))
        .toString();
  }
}

class $UserApMatchesTableTable extends UserApMatchesTable
    with TableInfo<$UserApMatchesTableTable, UserApMatchesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserApMatchesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _connectionIdMeta =
      const VerificationMeta('connectionId');
  @override
  late final GeneratedColumn<int> connectionId = GeneratedColumn<int>(
      'connection_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _userMacMeta =
      const VerificationMeta('userMac');
  @override
  late final GeneratedColumn<String> userMac = GeneratedColumn<String>(
      'user_mac', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _apIdMeta = const VerificationMeta('apId');
  @override
  late final GeneratedColumn<int> apId = GeneratedColumn<int>(
      'ap_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _confidenceMeta =
      const VerificationMeta('confidence');
  @override
  late final GeneratedColumn<String> confidence = GeneratedColumn<String>(
      'confidence', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _evidenceMeta =
      const VerificationMeta('evidence');
  @override
  late final GeneratedColumn<String> evidence = GeneratedColumn<String>(
      'evidence', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<DateTime> at = GeneratedColumn<DateTime>(
      'at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, connectionId, userMac, apId, confidence, evidence, at];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_ap_matches';
  @override
  VerificationContext validateIntegrity(
      Insertable<UserApMatchesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('connection_id')) {
      context.handle(
          _connectionIdMeta,
          connectionId.isAcceptableOrUnknown(
              data['connection_id']!, _connectionIdMeta));
    } else if (isInserting) {
      context.missing(_connectionIdMeta);
    }
    if (data.containsKey('user_mac')) {
      context.handle(_userMacMeta,
          userMac.isAcceptableOrUnknown(data['user_mac']!, _userMacMeta));
    } else if (isInserting) {
      context.missing(_userMacMeta);
    }
    if (data.containsKey('ap_id')) {
      context.handle(
          _apIdMeta, apId.isAcceptableOrUnknown(data['ap_id']!, _apIdMeta));
    }
    if (data.containsKey('confidence')) {
      context.handle(
          _confidenceMeta,
          confidence.isAcceptableOrUnknown(
              data['confidence']!, _confidenceMeta));
    } else if (isInserting) {
      context.missing(_confidenceMeta);
    }
    if (data.containsKey('evidence')) {
      context.handle(_evidenceMeta,
          evidence.isAcceptableOrUnknown(data['evidence']!, _evidenceMeta));
    } else if (isInserting) {
      context.missing(_evidenceMeta);
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserApMatchesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserApMatchesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      connectionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}connection_id'])!,
      userMac: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_mac'])!,
      apId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ap_id']),
      confidence: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}confidence'])!,
      evidence: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}evidence'])!,
      at: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}at'])!,
    );
  }

  @override
  $UserApMatchesTableTable createAlias(String alias) {
    return $UserApMatchesTableTable(attachedDatabase, alias);
  }
}

class UserApMatchesTableData extends DataClass
    implements Insertable<UserApMatchesTableData> {
  final int id;
  final int connectionId;
  final String userMac;
  final int? apId;
  final String confidence;
  final String evidence;
  final DateTime at;
  const UserApMatchesTableData(
      {required this.id,
      required this.connectionId,
      required this.userMac,
      this.apId,
      required this.confidence,
      required this.evidence,
      required this.at});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['connection_id'] = Variable<int>(connectionId);
    map['user_mac'] = Variable<String>(userMac);
    if (!nullToAbsent || apId != null) {
      map['ap_id'] = Variable<int>(apId);
    }
    map['confidence'] = Variable<String>(confidence);
    map['evidence'] = Variable<String>(evidence);
    map['at'] = Variable<DateTime>(at);
    return map;
  }

  UserApMatchesTableCompanion toCompanion(bool nullToAbsent) {
    return UserApMatchesTableCompanion(
      id: Value(id),
      connectionId: Value(connectionId),
      userMac: Value(userMac),
      apId: apId == null && nullToAbsent ? const Value.absent() : Value(apId),
      confidence: Value(confidence),
      evidence: Value(evidence),
      at: Value(at),
    );
  }

  factory UserApMatchesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserApMatchesTableData(
      id: serializer.fromJson<int>(json['id']),
      connectionId: serializer.fromJson<int>(json['connectionId']),
      userMac: serializer.fromJson<String>(json['userMac']),
      apId: serializer.fromJson<int?>(json['apId']),
      confidence: serializer.fromJson<String>(json['confidence']),
      evidence: serializer.fromJson<String>(json['evidence']),
      at: serializer.fromJson<DateTime>(json['at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'connectionId': serializer.toJson<int>(connectionId),
      'userMac': serializer.toJson<String>(userMac),
      'apId': serializer.toJson<int?>(apId),
      'confidence': serializer.toJson<String>(confidence),
      'evidence': serializer.toJson<String>(evidence),
      'at': serializer.toJson<DateTime>(at),
    };
  }

  UserApMatchesTableData copyWith(
          {int? id,
          int? connectionId,
          String? userMac,
          Value<int?> apId = const Value.absent(),
          String? confidence,
          String? evidence,
          DateTime? at}) =>
      UserApMatchesTableData(
        id: id ?? this.id,
        connectionId: connectionId ?? this.connectionId,
        userMac: userMac ?? this.userMac,
        apId: apId.present ? apId.value : this.apId,
        confidence: confidence ?? this.confidence,
        evidence: evidence ?? this.evidence,
        at: at ?? this.at,
      );
  UserApMatchesTableData copyWithCompanion(UserApMatchesTableCompanion data) {
    return UserApMatchesTableData(
      id: data.id.present ? data.id.value : this.id,
      connectionId: data.connectionId.present
          ? data.connectionId.value
          : this.connectionId,
      userMac: data.userMac.present ? data.userMac.value : this.userMac,
      apId: data.apId.present ? data.apId.value : this.apId,
      confidence:
          data.confidence.present ? data.confidence.value : this.confidence,
      evidence: data.evidence.present ? data.evidence.value : this.evidence,
      at: data.at.present ? data.at.value : this.at,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserApMatchesTableData(')
          ..write('id: $id, ')
          ..write('connectionId: $connectionId, ')
          ..write('userMac: $userMac, ')
          ..write('apId: $apId, ')
          ..write('confidence: $confidence, ')
          ..write('evidence: $evidence, ')
          ..write('at: $at')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, connectionId, userMac, apId, confidence, evidence, at);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserApMatchesTableData &&
          other.id == this.id &&
          other.connectionId == this.connectionId &&
          other.userMac == this.userMac &&
          other.apId == this.apId &&
          other.confidence == this.confidence &&
          other.evidence == this.evidence &&
          other.at == this.at);
}

class UserApMatchesTableCompanion
    extends UpdateCompanion<UserApMatchesTableData> {
  final Value<int> id;
  final Value<int> connectionId;
  final Value<String> userMac;
  final Value<int?> apId;
  final Value<String> confidence;
  final Value<String> evidence;
  final Value<DateTime> at;
  const UserApMatchesTableCompanion({
    this.id = const Value.absent(),
    this.connectionId = const Value.absent(),
    this.userMac = const Value.absent(),
    this.apId = const Value.absent(),
    this.confidence = const Value.absent(),
    this.evidence = const Value.absent(),
    this.at = const Value.absent(),
  });
  UserApMatchesTableCompanion.insert({
    this.id = const Value.absent(),
    required int connectionId,
    required String userMac,
    this.apId = const Value.absent(),
    required String confidence,
    required String evidence,
    this.at = const Value.absent(),
  })  : connectionId = Value(connectionId),
        userMac = Value(userMac),
        confidence = Value(confidence),
        evidence = Value(evidence);
  static Insertable<UserApMatchesTableData> custom({
    Expression<int>? id,
    Expression<int>? connectionId,
    Expression<String>? userMac,
    Expression<int>? apId,
    Expression<String>? confidence,
    Expression<String>? evidence,
    Expression<DateTime>? at,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (connectionId != null) 'connection_id': connectionId,
      if (userMac != null) 'user_mac': userMac,
      if (apId != null) 'ap_id': apId,
      if (confidence != null) 'confidence': confidence,
      if (evidence != null) 'evidence': evidence,
      if (at != null) 'at': at,
    });
  }

  UserApMatchesTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? connectionId,
      Value<String>? userMac,
      Value<int?>? apId,
      Value<String>? confidence,
      Value<String>? evidence,
      Value<DateTime>? at}) {
    return UserApMatchesTableCompanion(
      id: id ?? this.id,
      connectionId: connectionId ?? this.connectionId,
      userMac: userMac ?? this.userMac,
      apId: apId ?? this.apId,
      confidence: confidence ?? this.confidence,
      evidence: evidence ?? this.evidence,
      at: at ?? this.at,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (connectionId.present) {
      map['connection_id'] = Variable<int>(connectionId.value);
    }
    if (userMac.present) {
      map['user_mac'] = Variable<String>(userMac.value);
    }
    if (apId.present) {
      map['ap_id'] = Variable<int>(apId.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<String>(confidence.value);
    }
    if (evidence.present) {
      map['evidence'] = Variable<String>(evidence.value);
    }
    if (at.present) {
      map['at'] = Variable<DateTime>(at.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserApMatchesTableCompanion(')
          ..write('id: $id, ')
          ..write('connectionId: $connectionId, ')
          ..write('userMac: $userMac, ')
          ..write('apId: $apId, ')
          ..write('confidence: $confidence, ')
          ..write('evidence: $evidence, ')
          ..write('at: $at')
          ..write(')'))
        .toString();
  }
}

class $TopologySnapshotsTableTable extends TopologySnapshotsTable
    with TableInfo<$TopologySnapshotsTableTable, TopologySnapshotsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TopologySnapshotsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _connectionIdMeta =
      const VerificationMeta('connectionId');
  @override
  late final GeneratedColumn<int> connectionId = GeneratedColumn<int>(
      'connection_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _graphJsonMeta =
      const VerificationMeta('graphJson');
  @override
  late final GeneratedColumn<String> graphJson = GeneratedColumn<String>(
      'graph_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _savedAtMeta =
      const VerificationMeta('savedAt');
  @override
  late final GeneratedColumn<DateTime> savedAt = GeneratedColumn<DateTime>(
      'saved_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, connectionId, graphJson, savedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'topology_snapshots';
  @override
  VerificationContext validateIntegrity(
      Insertable<TopologySnapshotsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('connection_id')) {
      context.handle(
          _connectionIdMeta,
          connectionId.isAcceptableOrUnknown(
              data['connection_id']!, _connectionIdMeta));
    } else if (isInserting) {
      context.missing(_connectionIdMeta);
    }
    if (data.containsKey('graph_json')) {
      context.handle(_graphJsonMeta,
          graphJson.isAcceptableOrUnknown(data['graph_json']!, _graphJsonMeta));
    } else if (isInserting) {
      context.missing(_graphJsonMeta);
    }
    if (data.containsKey('saved_at')) {
      context.handle(_savedAtMeta,
          savedAt.isAcceptableOrUnknown(data['saved_at']!, _savedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TopologySnapshotsTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TopologySnapshotsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      connectionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}connection_id'])!,
      graphJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}graph_json'])!,
      savedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}saved_at'])!,
    );
  }

  @override
  $TopologySnapshotsTableTable createAlias(String alias) {
    return $TopologySnapshotsTableTable(attachedDatabase, alias);
  }
}

class TopologySnapshotsTableData extends DataClass
    implements Insertable<TopologySnapshotsTableData> {
  final int id;
  final int connectionId;
  final String graphJson;
  final DateTime savedAt;
  const TopologySnapshotsTableData(
      {required this.id,
      required this.connectionId,
      required this.graphJson,
      required this.savedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['connection_id'] = Variable<int>(connectionId);
    map['graph_json'] = Variable<String>(graphJson);
    map['saved_at'] = Variable<DateTime>(savedAt);
    return map;
  }

  TopologySnapshotsTableCompanion toCompanion(bool nullToAbsent) {
    return TopologySnapshotsTableCompanion(
      id: Value(id),
      connectionId: Value(connectionId),
      graphJson: Value(graphJson),
      savedAt: Value(savedAt),
    );
  }

  factory TopologySnapshotsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TopologySnapshotsTableData(
      id: serializer.fromJson<int>(json['id']),
      connectionId: serializer.fromJson<int>(json['connectionId']),
      graphJson: serializer.fromJson<String>(json['graphJson']),
      savedAt: serializer.fromJson<DateTime>(json['savedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'connectionId': serializer.toJson<int>(connectionId),
      'graphJson': serializer.toJson<String>(graphJson),
      'savedAt': serializer.toJson<DateTime>(savedAt),
    };
  }

  TopologySnapshotsTableData copyWith(
          {int? id, int? connectionId, String? graphJson, DateTime? savedAt}) =>
      TopologySnapshotsTableData(
        id: id ?? this.id,
        connectionId: connectionId ?? this.connectionId,
        graphJson: graphJson ?? this.graphJson,
        savedAt: savedAt ?? this.savedAt,
      );
  TopologySnapshotsTableData copyWithCompanion(
      TopologySnapshotsTableCompanion data) {
    return TopologySnapshotsTableData(
      id: data.id.present ? data.id.value : this.id,
      connectionId: data.connectionId.present
          ? data.connectionId.value
          : this.connectionId,
      graphJson: data.graphJson.present ? data.graphJson.value : this.graphJson,
      savedAt: data.savedAt.present ? data.savedAt.value : this.savedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TopologySnapshotsTableData(')
          ..write('id: $id, ')
          ..write('connectionId: $connectionId, ')
          ..write('graphJson: $graphJson, ')
          ..write('savedAt: $savedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, connectionId, graphJson, savedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TopologySnapshotsTableData &&
          other.id == this.id &&
          other.connectionId == this.connectionId &&
          other.graphJson == this.graphJson &&
          other.savedAt == this.savedAt);
}

class TopologySnapshotsTableCompanion
    extends UpdateCompanion<TopologySnapshotsTableData> {
  final Value<int> id;
  final Value<int> connectionId;
  final Value<String> graphJson;
  final Value<DateTime> savedAt;
  const TopologySnapshotsTableCompanion({
    this.id = const Value.absent(),
    this.connectionId = const Value.absent(),
    this.graphJson = const Value.absent(),
    this.savedAt = const Value.absent(),
  });
  TopologySnapshotsTableCompanion.insert({
    this.id = const Value.absent(),
    required int connectionId,
    required String graphJson,
    this.savedAt = const Value.absent(),
  })  : connectionId = Value(connectionId),
        graphJson = Value(graphJson);
  static Insertable<TopologySnapshotsTableData> custom({
    Expression<int>? id,
    Expression<int>? connectionId,
    Expression<String>? graphJson,
    Expression<DateTime>? savedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (connectionId != null) 'connection_id': connectionId,
      if (graphJson != null) 'graph_json': graphJson,
      if (savedAt != null) 'saved_at': savedAt,
    });
  }

  TopologySnapshotsTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? connectionId,
      Value<String>? graphJson,
      Value<DateTime>? savedAt}) {
    return TopologySnapshotsTableCompanion(
      id: id ?? this.id,
      connectionId: connectionId ?? this.connectionId,
      graphJson: graphJson ?? this.graphJson,
      savedAt: savedAt ?? this.savedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (connectionId.present) {
      map['connection_id'] = Variable<int>(connectionId.value);
    }
    if (graphJson.present) {
      map['graph_json'] = Variable<String>(graphJson.value);
    }
    if (savedAt.present) {
      map['saved_at'] = Variable<DateTime>(savedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TopologySnapshotsTableCompanion(')
          ..write('id: $id, ')
          ..write('connectionId: $connectionId, ')
          ..write('graphJson: $graphJson, ')
          ..write('savedAt: $savedAt')
          ..write(')'))
        .toString();
  }
}

class $AlertRulesTableTable extends AlertRulesTable
    with TableInfo<$AlertRulesTableTable, AlertRulesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlertRulesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _connectionIdMeta =
      const VerificationMeta('connectionId');
  @override
  late final GeneratedColumn<int> connectionId = GeneratedColumn<int>(
      'connection_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _targetMeta = const VerificationMeta('target');
  @override
  late final GeneratedColumn<String> target = GeneratedColumn<String>(
      'target', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _thresholdMeta =
      const VerificationMeta('threshold');
  @override
  late final GeneratedColumn<double> threshold = GeneratedColumn<double>(
      'threshold', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _destinationMeta =
      const VerificationMeta('destination');
  @override
  late final GeneratedColumn<String> destination = GeneratedColumn<String>(
      'destination', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('phone'));
  static const VerificationMeta _enabledMeta =
      const VerificationMeta('enabled');
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
      'enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns =>
      [id, connectionId, type, target, threshold, destination, enabled];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'alert_rules';
  @override
  VerificationContext validateIntegrity(
      Insertable<AlertRulesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('connection_id')) {
      context.handle(
          _connectionIdMeta,
          connectionId.isAcceptableOrUnknown(
              data['connection_id']!, _connectionIdMeta));
    } else if (isInserting) {
      context.missing(_connectionIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('target')) {
      context.handle(_targetMeta,
          target.isAcceptableOrUnknown(data['target']!, _targetMeta));
    } else if (isInserting) {
      context.missing(_targetMeta);
    }
    if (data.containsKey('threshold')) {
      context.handle(_thresholdMeta,
          threshold.isAcceptableOrUnknown(data['threshold']!, _thresholdMeta));
    } else if (isInserting) {
      context.missing(_thresholdMeta);
    }
    if (data.containsKey('destination')) {
      context.handle(
          _destinationMeta,
          destination.isAcceptableOrUnknown(
              data['destination']!, _destinationMeta));
    }
    if (data.containsKey('enabled')) {
      context.handle(_enabledMeta,
          enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AlertRulesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AlertRulesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      connectionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}connection_id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      target: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}target'])!,
      threshold: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}threshold'])!,
      destination: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}destination'])!,
      enabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}enabled'])!,
    );
  }

  @override
  $AlertRulesTableTable createAlias(String alias) {
    return $AlertRulesTableTable(attachedDatabase, alias);
  }
}

class AlertRulesTableData extends DataClass
    implements Insertable<AlertRulesTableData> {
  final int id;
  final int connectionId;
  final String type;
  final String target;
  final double threshold;
  final String destination;
  final bool enabled;
  const AlertRulesTableData(
      {required this.id,
      required this.connectionId,
      required this.type,
      required this.target,
      required this.threshold,
      required this.destination,
      required this.enabled});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['connection_id'] = Variable<int>(connectionId);
    map['type'] = Variable<String>(type);
    map['target'] = Variable<String>(target);
    map['threshold'] = Variable<double>(threshold);
    map['destination'] = Variable<String>(destination);
    map['enabled'] = Variable<bool>(enabled);
    return map;
  }

  AlertRulesTableCompanion toCompanion(bool nullToAbsent) {
    return AlertRulesTableCompanion(
      id: Value(id),
      connectionId: Value(connectionId),
      type: Value(type),
      target: Value(target),
      threshold: Value(threshold),
      destination: Value(destination),
      enabled: Value(enabled),
    );
  }

  factory AlertRulesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AlertRulesTableData(
      id: serializer.fromJson<int>(json['id']),
      connectionId: serializer.fromJson<int>(json['connectionId']),
      type: serializer.fromJson<String>(json['type']),
      target: serializer.fromJson<String>(json['target']),
      threshold: serializer.fromJson<double>(json['threshold']),
      destination: serializer.fromJson<String>(json['destination']),
      enabled: serializer.fromJson<bool>(json['enabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'connectionId': serializer.toJson<int>(connectionId),
      'type': serializer.toJson<String>(type),
      'target': serializer.toJson<String>(target),
      'threshold': serializer.toJson<double>(threshold),
      'destination': serializer.toJson<String>(destination),
      'enabled': serializer.toJson<bool>(enabled),
    };
  }

  AlertRulesTableData copyWith(
          {int? id,
          int? connectionId,
          String? type,
          String? target,
          double? threshold,
          String? destination,
          bool? enabled}) =>
      AlertRulesTableData(
        id: id ?? this.id,
        connectionId: connectionId ?? this.connectionId,
        type: type ?? this.type,
        target: target ?? this.target,
        threshold: threshold ?? this.threshold,
        destination: destination ?? this.destination,
        enabled: enabled ?? this.enabled,
      );
  AlertRulesTableData copyWithCompanion(AlertRulesTableCompanion data) {
    return AlertRulesTableData(
      id: data.id.present ? data.id.value : this.id,
      connectionId: data.connectionId.present
          ? data.connectionId.value
          : this.connectionId,
      type: data.type.present ? data.type.value : this.type,
      target: data.target.present ? data.target.value : this.target,
      threshold: data.threshold.present ? data.threshold.value : this.threshold,
      destination:
          data.destination.present ? data.destination.value : this.destination,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AlertRulesTableData(')
          ..write('id: $id, ')
          ..write('connectionId: $connectionId, ')
          ..write('type: $type, ')
          ..write('target: $target, ')
          ..write('threshold: $threshold, ')
          ..write('destination: $destination, ')
          ..write('enabled: $enabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, connectionId, type, target, threshold, destination, enabled);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AlertRulesTableData &&
          other.id == this.id &&
          other.connectionId == this.connectionId &&
          other.type == this.type &&
          other.target == this.target &&
          other.threshold == this.threshold &&
          other.destination == this.destination &&
          other.enabled == this.enabled);
}

class AlertRulesTableCompanion extends UpdateCompanion<AlertRulesTableData> {
  final Value<int> id;
  final Value<int> connectionId;
  final Value<String> type;
  final Value<String> target;
  final Value<double> threshold;
  final Value<String> destination;
  final Value<bool> enabled;
  const AlertRulesTableCompanion({
    this.id = const Value.absent(),
    this.connectionId = const Value.absent(),
    this.type = const Value.absent(),
    this.target = const Value.absent(),
    this.threshold = const Value.absent(),
    this.destination = const Value.absent(),
    this.enabled = const Value.absent(),
  });
  AlertRulesTableCompanion.insert({
    this.id = const Value.absent(),
    required int connectionId,
    required String type,
    required String target,
    required double threshold,
    this.destination = const Value.absent(),
    this.enabled = const Value.absent(),
  })  : connectionId = Value(connectionId),
        type = Value(type),
        target = Value(target),
        threshold = Value(threshold);
  static Insertable<AlertRulesTableData> custom({
    Expression<int>? id,
    Expression<int>? connectionId,
    Expression<String>? type,
    Expression<String>? target,
    Expression<double>? threshold,
    Expression<String>? destination,
    Expression<bool>? enabled,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (connectionId != null) 'connection_id': connectionId,
      if (type != null) 'type': type,
      if (target != null) 'target': target,
      if (threshold != null) 'threshold': threshold,
      if (destination != null) 'destination': destination,
      if (enabled != null) 'enabled': enabled,
    });
  }

  AlertRulesTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? connectionId,
      Value<String>? type,
      Value<String>? target,
      Value<double>? threshold,
      Value<String>? destination,
      Value<bool>? enabled}) {
    return AlertRulesTableCompanion(
      id: id ?? this.id,
      connectionId: connectionId ?? this.connectionId,
      type: type ?? this.type,
      target: target ?? this.target,
      threshold: threshold ?? this.threshold,
      destination: destination ?? this.destination,
      enabled: enabled ?? this.enabled,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (connectionId.present) {
      map['connection_id'] = Variable<int>(connectionId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (target.present) {
      map['target'] = Variable<String>(target.value);
    }
    if (threshold.present) {
      map['threshold'] = Variable<double>(threshold.value);
    }
    if (destination.present) {
      map['destination'] = Variable<String>(destination.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlertRulesTableCompanion(')
          ..write('id: $id, ')
          ..write('connectionId: $connectionId, ')
          ..write('type: $type, ')
          ..write('target: $target, ')
          ..write('threshold: $threshold, ')
          ..write('destination: $destination, ')
          ..write('enabled: $enabled')
          ..write(')'))
        .toString();
  }
}

class $AlertEventsTableTable extends AlertEventsTable
    with TableInfo<$AlertEventsTableTable, AlertEventsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlertEventsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _connectionIdMeta =
      const VerificationMeta('connectionId');
  @override
  late final GeneratedColumn<int> connectionId = GeneratedColumn<int>(
      'connection_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _ruleIdMeta = const VerificationMeta('ruleId');
  @override
  late final GeneratedColumn<int> ruleId = GeneratedColumn<int>(
      'rule_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<DateTime> at = GeneratedColumn<DateTime>(
      'at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _detailsMeta =
      const VerificationMeta('details');
  @override
  late final GeneratedColumn<String> details = GeneratedColumn<String>(
      'details', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, connectionId, ruleId, status, at, details];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'alert_events';
  @override
  VerificationContext validateIntegrity(
      Insertable<AlertEventsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('connection_id')) {
      context.handle(
          _connectionIdMeta,
          connectionId.isAcceptableOrUnknown(
              data['connection_id']!, _connectionIdMeta));
    } else if (isInserting) {
      context.missing(_connectionIdMeta);
    }
    if (data.containsKey('rule_id')) {
      context.handle(_ruleIdMeta,
          ruleId.isAcceptableOrUnknown(data['rule_id']!, _ruleIdMeta));
    } else if (isInserting) {
      context.missing(_ruleIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    }
    if (data.containsKey('details')) {
      context.handle(_detailsMeta,
          details.isAcceptableOrUnknown(data['details']!, _detailsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AlertEventsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AlertEventsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      connectionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}connection_id'])!,
      ruleId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}rule_id'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      at: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}at'])!,
      details: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}details']),
    );
  }

  @override
  $AlertEventsTableTable createAlias(String alias) {
    return $AlertEventsTableTable(attachedDatabase, alias);
  }
}

class AlertEventsTableData extends DataClass
    implements Insertable<AlertEventsTableData> {
  final int id;
  final int connectionId;
  final int ruleId;
  final String status;
  final DateTime at;
  final String? details;
  const AlertEventsTableData(
      {required this.id,
      required this.connectionId,
      required this.ruleId,
      required this.status,
      required this.at,
      this.details});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['connection_id'] = Variable<int>(connectionId);
    map['rule_id'] = Variable<int>(ruleId);
    map['status'] = Variable<String>(status);
    map['at'] = Variable<DateTime>(at);
    if (!nullToAbsent || details != null) {
      map['details'] = Variable<String>(details);
    }
    return map;
  }

  AlertEventsTableCompanion toCompanion(bool nullToAbsent) {
    return AlertEventsTableCompanion(
      id: Value(id),
      connectionId: Value(connectionId),
      ruleId: Value(ruleId),
      status: Value(status),
      at: Value(at),
      details: details == null && nullToAbsent
          ? const Value.absent()
          : Value(details),
    );
  }

  factory AlertEventsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AlertEventsTableData(
      id: serializer.fromJson<int>(json['id']),
      connectionId: serializer.fromJson<int>(json['connectionId']),
      ruleId: serializer.fromJson<int>(json['ruleId']),
      status: serializer.fromJson<String>(json['status']),
      at: serializer.fromJson<DateTime>(json['at']),
      details: serializer.fromJson<String?>(json['details']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'connectionId': serializer.toJson<int>(connectionId),
      'ruleId': serializer.toJson<int>(ruleId),
      'status': serializer.toJson<String>(status),
      'at': serializer.toJson<DateTime>(at),
      'details': serializer.toJson<String?>(details),
    };
  }

  AlertEventsTableData copyWith(
          {int? id,
          int? connectionId,
          int? ruleId,
          String? status,
          DateTime? at,
          Value<String?> details = const Value.absent()}) =>
      AlertEventsTableData(
        id: id ?? this.id,
        connectionId: connectionId ?? this.connectionId,
        ruleId: ruleId ?? this.ruleId,
        status: status ?? this.status,
        at: at ?? this.at,
        details: details.present ? details.value : this.details,
      );
  AlertEventsTableData copyWithCompanion(AlertEventsTableCompanion data) {
    return AlertEventsTableData(
      id: data.id.present ? data.id.value : this.id,
      connectionId: data.connectionId.present
          ? data.connectionId.value
          : this.connectionId,
      ruleId: data.ruleId.present ? data.ruleId.value : this.ruleId,
      status: data.status.present ? data.status.value : this.status,
      at: data.at.present ? data.at.value : this.at,
      details: data.details.present ? data.details.value : this.details,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AlertEventsTableData(')
          ..write('id: $id, ')
          ..write('connectionId: $connectionId, ')
          ..write('ruleId: $ruleId, ')
          ..write('status: $status, ')
          ..write('at: $at, ')
          ..write('details: $details')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, connectionId, ruleId, status, at, details);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AlertEventsTableData &&
          other.id == this.id &&
          other.connectionId == this.connectionId &&
          other.ruleId == this.ruleId &&
          other.status == this.status &&
          other.at == this.at &&
          other.details == this.details);
}

class AlertEventsTableCompanion extends UpdateCompanion<AlertEventsTableData> {
  final Value<int> id;
  final Value<int> connectionId;
  final Value<int> ruleId;
  final Value<String> status;
  final Value<DateTime> at;
  final Value<String?> details;
  const AlertEventsTableCompanion({
    this.id = const Value.absent(),
    this.connectionId = const Value.absent(),
    this.ruleId = const Value.absent(),
    this.status = const Value.absent(),
    this.at = const Value.absent(),
    this.details = const Value.absent(),
  });
  AlertEventsTableCompanion.insert({
    this.id = const Value.absent(),
    required int connectionId,
    required int ruleId,
    required String status,
    this.at = const Value.absent(),
    this.details = const Value.absent(),
  })  : connectionId = Value(connectionId),
        ruleId = Value(ruleId),
        status = Value(status);
  static Insertable<AlertEventsTableData> custom({
    Expression<int>? id,
    Expression<int>? connectionId,
    Expression<int>? ruleId,
    Expression<String>? status,
    Expression<DateTime>? at,
    Expression<String>? details,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (connectionId != null) 'connection_id': connectionId,
      if (ruleId != null) 'rule_id': ruleId,
      if (status != null) 'status': status,
      if (at != null) 'at': at,
      if (details != null) 'details': details,
    });
  }

  AlertEventsTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? connectionId,
      Value<int>? ruleId,
      Value<String>? status,
      Value<DateTime>? at,
      Value<String?>? details}) {
    return AlertEventsTableCompanion(
      id: id ?? this.id,
      connectionId: connectionId ?? this.connectionId,
      ruleId: ruleId ?? this.ruleId,
      status: status ?? this.status,
      at: at ?? this.at,
      details: details ?? this.details,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (connectionId.present) {
      map['connection_id'] = Variable<int>(connectionId.value);
    }
    if (ruleId.present) {
      map['rule_id'] = Variable<int>(ruleId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (at.present) {
      map['at'] = Variable<DateTime>(at.value);
    }
    if (details.present) {
      map['details'] = Variable<String>(details.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlertEventsTableCompanion(')
          ..write('id: $id, ')
          ..write('connectionId: $connectionId, ')
          ..write('ruleId: $ruleId, ')
          ..write('status: $status, ')
          ..write('at: $at, ')
          ..write('details: $details')
          ..write(')'))
        .toString();
  }
}

class $QuietHoursTableTable extends QuietHoursTable
    with TableInfo<$QuietHoursTableTable, QuietHoursTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuietHoursTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _connectionIdMeta =
      const VerificationMeta('connectionId');
  @override
  late final GeneratedColumn<int> connectionId = GeneratedColumn<int>(
      'connection_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _startMinuteMeta =
      const VerificationMeta('startMinute');
  @override
  late final GeneratedColumn<int> startMinute = GeneratedColumn<int>(
      'start_minute', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _endMinuteMeta =
      const VerificationMeta('endMinute');
  @override
  late final GeneratedColumn<int> endMinute = GeneratedColumn<int>(
      'end_minute', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _daysMeta = const VerificationMeta('days');
  @override
  late final GeneratedColumn<String> days = GeneratedColumn<String>(
      'days', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('1,2,3,4,5,6,7'));
  static const VerificationMeta _muteUntilMeta =
      const VerificationMeta('muteUntil');
  @override
  late final GeneratedColumn<DateTime> muteUntil = GeneratedColumn<DateTime>(
      'mute_until', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, connectionId, startMinute, endMinute, days, muteUntil];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quiet_hours';
  @override
  VerificationContext validateIntegrity(
      Insertable<QuietHoursTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('connection_id')) {
      context.handle(
          _connectionIdMeta,
          connectionId.isAcceptableOrUnknown(
              data['connection_id']!, _connectionIdMeta));
    } else if (isInserting) {
      context.missing(_connectionIdMeta);
    }
    if (data.containsKey('start_minute')) {
      context.handle(
          _startMinuteMeta,
          startMinute.isAcceptableOrUnknown(
              data['start_minute']!, _startMinuteMeta));
    } else if (isInserting) {
      context.missing(_startMinuteMeta);
    }
    if (data.containsKey('end_minute')) {
      context.handle(_endMinuteMeta,
          endMinute.isAcceptableOrUnknown(data['end_minute']!, _endMinuteMeta));
    } else if (isInserting) {
      context.missing(_endMinuteMeta);
    }
    if (data.containsKey('days')) {
      context.handle(
          _daysMeta, days.isAcceptableOrUnknown(data['days']!, _daysMeta));
    }
    if (data.containsKey('mute_until')) {
      context.handle(_muteUntilMeta,
          muteUntil.isAcceptableOrUnknown(data['mute_until']!, _muteUntilMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuietHoursTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuietHoursTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      connectionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}connection_id'])!,
      startMinute: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}start_minute'])!,
      endMinute: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}end_minute'])!,
      days: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}days'])!,
      muteUntil: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}mute_until']),
    );
  }

  @override
  $QuietHoursTableTable createAlias(String alias) {
    return $QuietHoursTableTable(attachedDatabase, alias);
  }
}

class QuietHoursTableData extends DataClass
    implements Insertable<QuietHoursTableData> {
  final int id;
  final int connectionId;
  final int startMinute;
  final int endMinute;
  final String days;
  final DateTime? muteUntil;
  const QuietHoursTableData(
      {required this.id,
      required this.connectionId,
      required this.startMinute,
      required this.endMinute,
      required this.days,
      this.muteUntil});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['connection_id'] = Variable<int>(connectionId);
    map['start_minute'] = Variable<int>(startMinute);
    map['end_minute'] = Variable<int>(endMinute);
    map['days'] = Variable<String>(days);
    if (!nullToAbsent || muteUntil != null) {
      map['mute_until'] = Variable<DateTime>(muteUntil);
    }
    return map;
  }

  QuietHoursTableCompanion toCompanion(bool nullToAbsent) {
    return QuietHoursTableCompanion(
      id: Value(id),
      connectionId: Value(connectionId),
      startMinute: Value(startMinute),
      endMinute: Value(endMinute),
      days: Value(days),
      muteUntil: muteUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(muteUntil),
    );
  }

  factory QuietHoursTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuietHoursTableData(
      id: serializer.fromJson<int>(json['id']),
      connectionId: serializer.fromJson<int>(json['connectionId']),
      startMinute: serializer.fromJson<int>(json['startMinute']),
      endMinute: serializer.fromJson<int>(json['endMinute']),
      days: serializer.fromJson<String>(json['days']),
      muteUntil: serializer.fromJson<DateTime?>(json['muteUntil']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'connectionId': serializer.toJson<int>(connectionId),
      'startMinute': serializer.toJson<int>(startMinute),
      'endMinute': serializer.toJson<int>(endMinute),
      'days': serializer.toJson<String>(days),
      'muteUntil': serializer.toJson<DateTime?>(muteUntil),
    };
  }

  QuietHoursTableData copyWith(
          {int? id,
          int? connectionId,
          int? startMinute,
          int? endMinute,
          String? days,
          Value<DateTime?> muteUntil = const Value.absent()}) =>
      QuietHoursTableData(
        id: id ?? this.id,
        connectionId: connectionId ?? this.connectionId,
        startMinute: startMinute ?? this.startMinute,
        endMinute: endMinute ?? this.endMinute,
        days: days ?? this.days,
        muteUntil: muteUntil.present ? muteUntil.value : this.muteUntil,
      );
  QuietHoursTableData copyWithCompanion(QuietHoursTableCompanion data) {
    return QuietHoursTableData(
      id: data.id.present ? data.id.value : this.id,
      connectionId: data.connectionId.present
          ? data.connectionId.value
          : this.connectionId,
      startMinute:
          data.startMinute.present ? data.startMinute.value : this.startMinute,
      endMinute: data.endMinute.present ? data.endMinute.value : this.endMinute,
      days: data.days.present ? data.days.value : this.days,
      muteUntil: data.muteUntil.present ? data.muteUntil.value : this.muteUntil,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuietHoursTableData(')
          ..write('id: $id, ')
          ..write('connectionId: $connectionId, ')
          ..write('startMinute: $startMinute, ')
          ..write('endMinute: $endMinute, ')
          ..write('days: $days, ')
          ..write('muteUntil: $muteUntil')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, connectionId, startMinute, endMinute, days, muteUntil);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuietHoursTableData &&
          other.id == this.id &&
          other.connectionId == this.connectionId &&
          other.startMinute == this.startMinute &&
          other.endMinute == this.endMinute &&
          other.days == this.days &&
          other.muteUntil == this.muteUntil);
}

class QuietHoursTableCompanion extends UpdateCompanion<QuietHoursTableData> {
  final Value<int> id;
  final Value<int> connectionId;
  final Value<int> startMinute;
  final Value<int> endMinute;
  final Value<String> days;
  final Value<DateTime?> muteUntil;
  const QuietHoursTableCompanion({
    this.id = const Value.absent(),
    this.connectionId = const Value.absent(),
    this.startMinute = const Value.absent(),
    this.endMinute = const Value.absent(),
    this.days = const Value.absent(),
    this.muteUntil = const Value.absent(),
  });
  QuietHoursTableCompanion.insert({
    this.id = const Value.absent(),
    required int connectionId,
    required int startMinute,
    required int endMinute,
    this.days = const Value.absent(),
    this.muteUntil = const Value.absent(),
  })  : connectionId = Value(connectionId),
        startMinute = Value(startMinute),
        endMinute = Value(endMinute);
  static Insertable<QuietHoursTableData> custom({
    Expression<int>? id,
    Expression<int>? connectionId,
    Expression<int>? startMinute,
    Expression<int>? endMinute,
    Expression<String>? days,
    Expression<DateTime>? muteUntil,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (connectionId != null) 'connection_id': connectionId,
      if (startMinute != null) 'start_minute': startMinute,
      if (endMinute != null) 'end_minute': endMinute,
      if (days != null) 'days': days,
      if (muteUntil != null) 'mute_until': muteUntil,
    });
  }

  QuietHoursTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? connectionId,
      Value<int>? startMinute,
      Value<int>? endMinute,
      Value<String>? days,
      Value<DateTime?>? muteUntil}) {
    return QuietHoursTableCompanion(
      id: id ?? this.id,
      connectionId: connectionId ?? this.connectionId,
      startMinute: startMinute ?? this.startMinute,
      endMinute: endMinute ?? this.endMinute,
      days: days ?? this.days,
      muteUntil: muteUntil ?? this.muteUntil,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (connectionId.present) {
      map['connection_id'] = Variable<int>(connectionId.value);
    }
    if (startMinute.present) {
      map['start_minute'] = Variable<int>(startMinute.value);
    }
    if (endMinute.present) {
      map['end_minute'] = Variable<int>(endMinute.value);
    }
    if (days.present) {
      map['days'] = Variable<String>(days.value);
    }
    if (muteUntil.present) {
      map['mute_until'] = Variable<DateTime>(muteUntil.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuietHoursTableCompanion(')
          ..write('id: $id, ')
          ..write('connectionId: $connectionId, ')
          ..write('startMinute: $startMinute, ')
          ..write('endMinute: $endMinute, ')
          ..write('days: $days, ')
          ..write('muteUntil: $muteUntil')
          ..write(')'))
        .toString();
  }
}

class $TrustedDhcpServersTableTable extends TrustedDhcpServersTable
    with TableInfo<$TrustedDhcpServersTableTable, TrustedDhcpServersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrustedDhcpServersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _connectionIdMeta =
      const VerificationMeta('connectionId');
  @override
  late final GeneratedColumn<int> connectionId = GeneratedColumn<int>(
      'connection_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _serverIpMeta =
      const VerificationMeta('serverIp');
  @override
  late final GeneratedColumn<String> serverIp = GeneratedColumn<String>(
      'server_ip', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _interfaceMeta =
      const VerificationMeta('interface');
  @override
  late final GeneratedColumn<String> interface = GeneratedColumn<String>(
      'interface', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, connectionId, serverIp, interface];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trusted_dhcp_servers';
  @override
  VerificationContext validateIntegrity(
      Insertable<TrustedDhcpServersTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('connection_id')) {
      context.handle(
          _connectionIdMeta,
          connectionId.isAcceptableOrUnknown(
              data['connection_id']!, _connectionIdMeta));
    } else if (isInserting) {
      context.missing(_connectionIdMeta);
    }
    if (data.containsKey('server_ip')) {
      context.handle(_serverIpMeta,
          serverIp.isAcceptableOrUnknown(data['server_ip']!, _serverIpMeta));
    } else if (isInserting) {
      context.missing(_serverIpMeta);
    }
    if (data.containsKey('interface')) {
      context.handle(_interfaceMeta,
          interface.isAcceptableOrUnknown(data['interface']!, _interfaceMeta));
    } else if (isInserting) {
      context.missing(_interfaceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TrustedDhcpServersTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrustedDhcpServersTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      connectionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}connection_id'])!,
      serverIp: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}server_ip'])!,
      interface: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}interface'])!,
    );
  }

  @override
  $TrustedDhcpServersTableTable createAlias(String alias) {
    return $TrustedDhcpServersTableTable(attachedDatabase, alias);
  }
}

class TrustedDhcpServersTableData extends DataClass
    implements Insertable<TrustedDhcpServersTableData> {
  final int id;
  final int connectionId;
  final String serverIp;
  final String interface;
  const TrustedDhcpServersTableData(
      {required this.id,
      required this.connectionId,
      required this.serverIp,
      required this.interface});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['connection_id'] = Variable<int>(connectionId);
    map['server_ip'] = Variable<String>(serverIp);
    map['interface'] = Variable<String>(interface);
    return map;
  }

  TrustedDhcpServersTableCompanion toCompanion(bool nullToAbsent) {
    return TrustedDhcpServersTableCompanion(
      id: Value(id),
      connectionId: Value(connectionId),
      serverIp: Value(serverIp),
      interface: Value(interface),
    );
  }

  factory TrustedDhcpServersTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrustedDhcpServersTableData(
      id: serializer.fromJson<int>(json['id']),
      connectionId: serializer.fromJson<int>(json['connectionId']),
      serverIp: serializer.fromJson<String>(json['serverIp']),
      interface: serializer.fromJson<String>(json['interface']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'connectionId': serializer.toJson<int>(connectionId),
      'serverIp': serializer.toJson<String>(serverIp),
      'interface': serializer.toJson<String>(interface),
    };
  }

  TrustedDhcpServersTableData copyWith(
          {int? id, int? connectionId, String? serverIp, String? interface}) =>
      TrustedDhcpServersTableData(
        id: id ?? this.id,
        connectionId: connectionId ?? this.connectionId,
        serverIp: serverIp ?? this.serverIp,
        interface: interface ?? this.interface,
      );
  TrustedDhcpServersTableData copyWithCompanion(
      TrustedDhcpServersTableCompanion data) {
    return TrustedDhcpServersTableData(
      id: data.id.present ? data.id.value : this.id,
      connectionId: data.connectionId.present
          ? data.connectionId.value
          : this.connectionId,
      serverIp: data.serverIp.present ? data.serverIp.value : this.serverIp,
      interface: data.interface.present ? data.interface.value : this.interface,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrustedDhcpServersTableData(')
          ..write('id: $id, ')
          ..write('connectionId: $connectionId, ')
          ..write('serverIp: $serverIp, ')
          ..write('interface: $interface')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, connectionId, serverIp, interface);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrustedDhcpServersTableData &&
          other.id == this.id &&
          other.connectionId == this.connectionId &&
          other.serverIp == this.serverIp &&
          other.interface == this.interface);
}

class TrustedDhcpServersTableCompanion
    extends UpdateCompanion<TrustedDhcpServersTableData> {
  final Value<int> id;
  final Value<int> connectionId;
  final Value<String> serverIp;
  final Value<String> interface;
  const TrustedDhcpServersTableCompanion({
    this.id = const Value.absent(),
    this.connectionId = const Value.absent(),
    this.serverIp = const Value.absent(),
    this.interface = const Value.absent(),
  });
  TrustedDhcpServersTableCompanion.insert({
    this.id = const Value.absent(),
    required int connectionId,
    required String serverIp,
    required String interface,
  })  : connectionId = Value(connectionId),
        serverIp = Value(serverIp),
        interface = Value(interface);
  static Insertable<TrustedDhcpServersTableData> custom({
    Expression<int>? id,
    Expression<int>? connectionId,
    Expression<String>? serverIp,
    Expression<String>? interface,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (connectionId != null) 'connection_id': connectionId,
      if (serverIp != null) 'server_ip': serverIp,
      if (interface != null) 'interface': interface,
    });
  }

  TrustedDhcpServersTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? connectionId,
      Value<String>? serverIp,
      Value<String>? interface}) {
    return TrustedDhcpServersTableCompanion(
      id: id ?? this.id,
      connectionId: connectionId ?? this.connectionId,
      serverIp: serverIp ?? this.serverIp,
      interface: interface ?? this.interface,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (connectionId.present) {
      map['connection_id'] = Variable<int>(connectionId.value);
    }
    if (serverIp.present) {
      map['server_ip'] = Variable<String>(serverIp.value);
    }
    if (interface.present) {
      map['interface'] = Variable<String>(interface.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrustedDhcpServersTableCompanion(')
          ..write('id: $id, ')
          ..write('connectionId: $connectionId, ')
          ..write('serverIp: $serverIp, ')
          ..write('interface: $interface')
          ..write(')'))
        .toString();
  }
}

class $InterfaceDailyTableTable extends InterfaceDailyTable
    with TableInfo<$InterfaceDailyTableTable, InterfaceDailyTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InterfaceDailyTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _connectionIdMeta =
      const VerificationMeta('connectionId');
  @override
  late final GeneratedColumn<int> connectionId = GeneratedColumn<int>(
      'connection_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _interfaceMeta =
      const VerificationMeta('interface');
  @override
  late final GeneratedColumn<String> interface = GeneratedColumn<String>(
      'interface', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _rxBytesMeta =
      const VerificationMeta('rxBytes');
  @override
  late final GeneratedColumn<int> rxBytes = GeneratedColumn<int>(
      'rx_bytes', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _txBytesMeta =
      const VerificationMeta('txBytes');
  @override
  late final GeneratedColumn<int> txBytes = GeneratedColumn<int>(
      'tx_bytes', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns =>
      [id, connectionId, interface, date, rxBytes, txBytes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'interface_daily';
  @override
  VerificationContext validateIntegrity(
      Insertable<InterfaceDailyTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('connection_id')) {
      context.handle(
          _connectionIdMeta,
          connectionId.isAcceptableOrUnknown(
              data['connection_id']!, _connectionIdMeta));
    } else if (isInserting) {
      context.missing(_connectionIdMeta);
    }
    if (data.containsKey('interface')) {
      context.handle(_interfaceMeta,
          interface.isAcceptableOrUnknown(data['interface']!, _interfaceMeta));
    } else if (isInserting) {
      context.missing(_interfaceMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('rx_bytes')) {
      context.handle(_rxBytesMeta,
          rxBytes.isAcceptableOrUnknown(data['rx_bytes']!, _rxBytesMeta));
    }
    if (data.containsKey('tx_bytes')) {
      context.handle(_txBytesMeta,
          txBytes.isAcceptableOrUnknown(data['tx_bytes']!, _txBytesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InterfaceDailyTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InterfaceDailyTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      connectionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}connection_id'])!,
      interface: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}interface'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      rxBytes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}rx_bytes'])!,
      txBytes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tx_bytes'])!,
    );
  }

  @override
  $InterfaceDailyTableTable createAlias(String alias) {
    return $InterfaceDailyTableTable(attachedDatabase, alias);
  }
}

class InterfaceDailyTableData extends DataClass
    implements Insertable<InterfaceDailyTableData> {
  final int id;
  final int connectionId;
  final String interface;
  final DateTime date;
  final int rxBytes;
  final int txBytes;
  const InterfaceDailyTableData(
      {required this.id,
      required this.connectionId,
      required this.interface,
      required this.date,
      required this.rxBytes,
      required this.txBytes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['connection_id'] = Variable<int>(connectionId);
    map['interface'] = Variable<String>(interface);
    map['date'] = Variable<DateTime>(date);
    map['rx_bytes'] = Variable<int>(rxBytes);
    map['tx_bytes'] = Variable<int>(txBytes);
    return map;
  }

  InterfaceDailyTableCompanion toCompanion(bool nullToAbsent) {
    return InterfaceDailyTableCompanion(
      id: Value(id),
      connectionId: Value(connectionId),
      interface: Value(interface),
      date: Value(date),
      rxBytes: Value(rxBytes),
      txBytes: Value(txBytes),
    );
  }

  factory InterfaceDailyTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InterfaceDailyTableData(
      id: serializer.fromJson<int>(json['id']),
      connectionId: serializer.fromJson<int>(json['connectionId']),
      interface: serializer.fromJson<String>(json['interface']),
      date: serializer.fromJson<DateTime>(json['date']),
      rxBytes: serializer.fromJson<int>(json['rxBytes']),
      txBytes: serializer.fromJson<int>(json['txBytes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'connectionId': serializer.toJson<int>(connectionId),
      'interface': serializer.toJson<String>(interface),
      'date': serializer.toJson<DateTime>(date),
      'rxBytes': serializer.toJson<int>(rxBytes),
      'txBytes': serializer.toJson<int>(txBytes),
    };
  }

  InterfaceDailyTableData copyWith(
          {int? id,
          int? connectionId,
          String? interface,
          DateTime? date,
          int? rxBytes,
          int? txBytes}) =>
      InterfaceDailyTableData(
        id: id ?? this.id,
        connectionId: connectionId ?? this.connectionId,
        interface: interface ?? this.interface,
        date: date ?? this.date,
        rxBytes: rxBytes ?? this.rxBytes,
        txBytes: txBytes ?? this.txBytes,
      );
  InterfaceDailyTableData copyWithCompanion(InterfaceDailyTableCompanion data) {
    return InterfaceDailyTableData(
      id: data.id.present ? data.id.value : this.id,
      connectionId: data.connectionId.present
          ? data.connectionId.value
          : this.connectionId,
      interface: data.interface.present ? data.interface.value : this.interface,
      date: data.date.present ? data.date.value : this.date,
      rxBytes: data.rxBytes.present ? data.rxBytes.value : this.rxBytes,
      txBytes: data.txBytes.present ? data.txBytes.value : this.txBytes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InterfaceDailyTableData(')
          ..write('id: $id, ')
          ..write('connectionId: $connectionId, ')
          ..write('interface: $interface, ')
          ..write('date: $date, ')
          ..write('rxBytes: $rxBytes, ')
          ..write('txBytes: $txBytes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, connectionId, interface, date, rxBytes, txBytes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InterfaceDailyTableData &&
          other.id == this.id &&
          other.connectionId == this.connectionId &&
          other.interface == this.interface &&
          other.date == this.date &&
          other.rxBytes == this.rxBytes &&
          other.txBytes == this.txBytes);
}

class InterfaceDailyTableCompanion
    extends UpdateCompanion<InterfaceDailyTableData> {
  final Value<int> id;
  final Value<int> connectionId;
  final Value<String> interface;
  final Value<DateTime> date;
  final Value<int> rxBytes;
  final Value<int> txBytes;
  const InterfaceDailyTableCompanion({
    this.id = const Value.absent(),
    this.connectionId = const Value.absent(),
    this.interface = const Value.absent(),
    this.date = const Value.absent(),
    this.rxBytes = const Value.absent(),
    this.txBytes = const Value.absent(),
  });
  InterfaceDailyTableCompanion.insert({
    this.id = const Value.absent(),
    required int connectionId,
    required String interface,
    required DateTime date,
    this.rxBytes = const Value.absent(),
    this.txBytes = const Value.absent(),
  })  : connectionId = Value(connectionId),
        interface = Value(interface),
        date = Value(date);
  static Insertable<InterfaceDailyTableData> custom({
    Expression<int>? id,
    Expression<int>? connectionId,
    Expression<String>? interface,
    Expression<DateTime>? date,
    Expression<int>? rxBytes,
    Expression<int>? txBytes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (connectionId != null) 'connection_id': connectionId,
      if (interface != null) 'interface': interface,
      if (date != null) 'date': date,
      if (rxBytes != null) 'rx_bytes': rxBytes,
      if (txBytes != null) 'tx_bytes': txBytes,
    });
  }

  InterfaceDailyTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? connectionId,
      Value<String>? interface,
      Value<DateTime>? date,
      Value<int>? rxBytes,
      Value<int>? txBytes}) {
    return InterfaceDailyTableCompanion(
      id: id ?? this.id,
      connectionId: connectionId ?? this.connectionId,
      interface: interface ?? this.interface,
      date: date ?? this.date,
      rxBytes: rxBytes ?? this.rxBytes,
      txBytes: txBytes ?? this.txBytes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (connectionId.present) {
      map['connection_id'] = Variable<int>(connectionId.value);
    }
    if (interface.present) {
      map['interface'] = Variable<String>(interface.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (rxBytes.present) {
      map['rx_bytes'] = Variable<int>(rxBytes.value);
    }
    if (txBytes.present) {
      map['tx_bytes'] = Variable<int>(txBytes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InterfaceDailyTableCompanion(')
          ..write('id: $id, ')
          ..write('connectionId: $connectionId, ')
          ..write('interface: $interface, ')
          ..write('date: $date, ')
          ..write('rxBytes: $rxBytes, ')
          ..write('txBytes: $txBytes')
          ..write(')'))
        .toString();
  }
}

class $BackupLogTableTable extends BackupLogTable
    with TableInfo<$BackupLogTableTable, BackupLogTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BackupLogTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _connectionIdMeta =
      const VerificationMeta('connectionId');
  @override
  late final GeneratedColumn<int> connectionId = GeneratedColumn<int>(
      'connection_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
      'kind', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
      'path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, connectionId, kind, path, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'backup_log';
  @override
  VerificationContext validateIntegrity(Insertable<BackupLogTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('connection_id')) {
      context.handle(
          _connectionIdMeta,
          connectionId.isAcceptableOrUnknown(
              data['connection_id']!, _connectionIdMeta));
    } else if (isInserting) {
      context.missing(_connectionIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
          _kindMeta, kind.isAcceptableOrUnknown(data['kind']!, _kindMeta));
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
          _pathMeta, path.isAcceptableOrUnknown(data['path']!, _pathMeta));
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BackupLogTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BackupLogTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      connectionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}connection_id'])!,
      kind: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kind'])!,
      path: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}path'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $BackupLogTableTable createAlias(String alias) {
    return $BackupLogTableTable(attachedDatabase, alias);
  }
}

class BackupLogTableData extends DataClass
    implements Insertable<BackupLogTableData> {
  final int id;
  final int connectionId;
  final String kind;
  final String path;
  final DateTime createdAt;
  const BackupLogTableData(
      {required this.id,
      required this.connectionId,
      required this.kind,
      required this.path,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['connection_id'] = Variable<int>(connectionId);
    map['kind'] = Variable<String>(kind);
    map['path'] = Variable<String>(path);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BackupLogTableCompanion toCompanion(bool nullToAbsent) {
    return BackupLogTableCompanion(
      id: Value(id),
      connectionId: Value(connectionId),
      kind: Value(kind),
      path: Value(path),
      createdAt: Value(createdAt),
    );
  }

  factory BackupLogTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BackupLogTableData(
      id: serializer.fromJson<int>(json['id']),
      connectionId: serializer.fromJson<int>(json['connectionId']),
      kind: serializer.fromJson<String>(json['kind']),
      path: serializer.fromJson<String>(json['path']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'connectionId': serializer.toJson<int>(connectionId),
      'kind': serializer.toJson<String>(kind),
      'path': serializer.toJson<String>(path),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  BackupLogTableData copyWith(
          {int? id,
          int? connectionId,
          String? kind,
          String? path,
          DateTime? createdAt}) =>
      BackupLogTableData(
        id: id ?? this.id,
        connectionId: connectionId ?? this.connectionId,
        kind: kind ?? this.kind,
        path: path ?? this.path,
        createdAt: createdAt ?? this.createdAt,
      );
  BackupLogTableData copyWithCompanion(BackupLogTableCompanion data) {
    return BackupLogTableData(
      id: data.id.present ? data.id.value : this.id,
      connectionId: data.connectionId.present
          ? data.connectionId.value
          : this.connectionId,
      kind: data.kind.present ? data.kind.value : this.kind,
      path: data.path.present ? data.path.value : this.path,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BackupLogTableData(')
          ..write('id: $id, ')
          ..write('connectionId: $connectionId, ')
          ..write('kind: $kind, ')
          ..write('path: $path, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, connectionId, kind, path, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BackupLogTableData &&
          other.id == this.id &&
          other.connectionId == this.connectionId &&
          other.kind == this.kind &&
          other.path == this.path &&
          other.createdAt == this.createdAt);
}

class BackupLogTableCompanion extends UpdateCompanion<BackupLogTableData> {
  final Value<int> id;
  final Value<int> connectionId;
  final Value<String> kind;
  final Value<String> path;
  final Value<DateTime> createdAt;
  const BackupLogTableCompanion({
    this.id = const Value.absent(),
    this.connectionId = const Value.absent(),
    this.kind = const Value.absent(),
    this.path = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  BackupLogTableCompanion.insert({
    this.id = const Value.absent(),
    required int connectionId,
    required String kind,
    required String path,
    this.createdAt = const Value.absent(),
  })  : connectionId = Value(connectionId),
        kind = Value(kind),
        path = Value(path);
  static Insertable<BackupLogTableData> custom({
    Expression<int>? id,
    Expression<int>? connectionId,
    Expression<String>? kind,
    Expression<String>? path,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (connectionId != null) 'connection_id': connectionId,
      if (kind != null) 'kind': kind,
      if (path != null) 'path': path,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  BackupLogTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? connectionId,
      Value<String>? kind,
      Value<String>? path,
      Value<DateTime>? createdAt}) {
    return BackupLogTableCompanion(
      id: id ?? this.id,
      connectionId: connectionId ?? this.connectionId,
      kind: kind ?? this.kind,
      path: path ?? this.path,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (connectionId.present) {
      map['connection_id'] = Variable<int>(connectionId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BackupLogTableCompanion(')
          ..write('id: $id, ')
          ..write('connectionId: $connectionId, ')
          ..write('kind: $kind, ')
          ..write('path: $path, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $TaskCheckpointsTableTable extends TaskCheckpointsTable
    with TableInfo<$TaskCheckpointsTableTable, TaskCheckpointsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskCheckpointsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
      'task_id', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 128),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _connectionIdMeta =
      const VerificationMeta('connectionId');
  @override
  late final GeneratedColumn<int> connectionId = GeneratedColumn<int>(
      'connection_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _taskTypeMeta =
      const VerificationMeta('taskType');
  @override
  late final GeneratedColumn<String> taskType = GeneratedColumn<String>(
      'task_type', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 64),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _totalItemsMeta =
      const VerificationMeta('totalItems');
  @override
  late final GeneratedColumn<int> totalItems = GeneratedColumn<int>(
      'total_items', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _processedItemsMeta =
      const VerificationMeta('processedItems');
  @override
  late final GeneratedColumn<int> processedItems = GeneratedColumn<int>(
      'processed_items', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _succeededItemsMeta =
      const VerificationMeta('succeededItems');
  @override
  late final GeneratedColumn<int> succeededItems = GeneratedColumn<int>(
      'succeeded_items', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _failedItemsMeta =
      const VerificationMeta('failedItems');
  @override
  late final GeneratedColumn<int> failedItems = GeneratedColumn<int>(
      'failed_items', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _payloadMeta =
      const VerificationMeta('payload');
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
      'payload', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('{}'));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('running'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        taskId,
        connectionId,
        taskType,
        totalItems,
        processedItems,
        succeededItems,
        failedItems,
        payload,
        status,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_checkpoints_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<TaskCheckpointsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('task_id')) {
      context.handle(_taskIdMeta,
          taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta));
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('connection_id')) {
      context.handle(
          _connectionIdMeta,
          connectionId.isAcceptableOrUnknown(
              data['connection_id']!, _connectionIdMeta));
    } else if (isInserting) {
      context.missing(_connectionIdMeta);
    }
    if (data.containsKey('task_type')) {
      context.handle(_taskTypeMeta,
          taskType.isAcceptableOrUnknown(data['task_type']!, _taskTypeMeta));
    } else if (isInserting) {
      context.missing(_taskTypeMeta);
    }
    if (data.containsKey('total_items')) {
      context.handle(
          _totalItemsMeta,
          totalItems.isAcceptableOrUnknown(
              data['total_items']!, _totalItemsMeta));
    }
    if (data.containsKey('processed_items')) {
      context.handle(
          _processedItemsMeta,
          processedItems.isAcceptableOrUnknown(
              data['processed_items']!, _processedItemsMeta));
    }
    if (data.containsKey('succeeded_items')) {
      context.handle(
          _succeededItemsMeta,
          succeededItems.isAcceptableOrUnknown(
              data['succeeded_items']!, _succeededItemsMeta));
    }
    if (data.containsKey('failed_items')) {
      context.handle(
          _failedItemsMeta,
          failedItems.isAcceptableOrUnknown(
              data['failed_items']!, _failedItemsMeta));
    }
    if (data.containsKey('payload')) {
      context.handle(_payloadMeta,
          payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskCheckpointsTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskCheckpointsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      taskId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}task_id'])!,
      connectionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}connection_id'])!,
      taskType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}task_type'])!,
      totalItems: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_items'])!,
      processedItems: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}processed_items'])!,
      succeededItems: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}succeeded_items'])!,
      failedItems: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}failed_items'])!,
      payload: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $TaskCheckpointsTableTable createAlias(String alias) {
    return $TaskCheckpointsTableTable(attachedDatabase, alias);
  }
}

class TaskCheckpointsTableData extends DataClass
    implements Insertable<TaskCheckpointsTableData> {
  final int id;
  final String taskId;
  final int connectionId;
  final String taskType;
  final int totalItems;
  final int processedItems;
  final int succeededItems;
  final int failedItems;
  final String payload;

  /// running | completed | cancelled | failed
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TaskCheckpointsTableData(
      {required this.id,
      required this.taskId,
      required this.connectionId,
      required this.taskType,
      required this.totalItems,
      required this.processedItems,
      required this.succeededItems,
      required this.failedItems,
      required this.payload,
      required this.status,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['task_id'] = Variable<String>(taskId);
    map['connection_id'] = Variable<int>(connectionId);
    map['task_type'] = Variable<String>(taskType);
    map['total_items'] = Variable<int>(totalItems);
    map['processed_items'] = Variable<int>(processedItems);
    map['succeeded_items'] = Variable<int>(succeededItems);
    map['failed_items'] = Variable<int>(failedItems);
    map['payload'] = Variable<String>(payload);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TaskCheckpointsTableCompanion toCompanion(bool nullToAbsent) {
    return TaskCheckpointsTableCompanion(
      id: Value(id),
      taskId: Value(taskId),
      connectionId: Value(connectionId),
      taskType: Value(taskType),
      totalItems: Value(totalItems),
      processedItems: Value(processedItems),
      succeededItems: Value(succeededItems),
      failedItems: Value(failedItems),
      payload: Value(payload),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TaskCheckpointsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskCheckpointsTableData(
      id: serializer.fromJson<int>(json['id']),
      taskId: serializer.fromJson<String>(json['taskId']),
      connectionId: serializer.fromJson<int>(json['connectionId']),
      taskType: serializer.fromJson<String>(json['taskType']),
      totalItems: serializer.fromJson<int>(json['totalItems']),
      processedItems: serializer.fromJson<int>(json['processedItems']),
      succeededItems: serializer.fromJson<int>(json['succeededItems']),
      failedItems: serializer.fromJson<int>(json['failedItems']),
      payload: serializer.fromJson<String>(json['payload']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'taskId': serializer.toJson<String>(taskId),
      'connectionId': serializer.toJson<int>(connectionId),
      'taskType': serializer.toJson<String>(taskType),
      'totalItems': serializer.toJson<int>(totalItems),
      'processedItems': serializer.toJson<int>(processedItems),
      'succeededItems': serializer.toJson<int>(succeededItems),
      'failedItems': serializer.toJson<int>(failedItems),
      'payload': serializer.toJson<String>(payload),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TaskCheckpointsTableData copyWith(
          {int? id,
          String? taskId,
          int? connectionId,
          String? taskType,
          int? totalItems,
          int? processedItems,
          int? succeededItems,
          int? failedItems,
          String? payload,
          String? status,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      TaskCheckpointsTableData(
        id: id ?? this.id,
        taskId: taskId ?? this.taskId,
        connectionId: connectionId ?? this.connectionId,
        taskType: taskType ?? this.taskType,
        totalItems: totalItems ?? this.totalItems,
        processedItems: processedItems ?? this.processedItems,
        succeededItems: succeededItems ?? this.succeededItems,
        failedItems: failedItems ?? this.failedItems,
        payload: payload ?? this.payload,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  TaskCheckpointsTableData copyWithCompanion(
      TaskCheckpointsTableCompanion data) {
    return TaskCheckpointsTableData(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      connectionId: data.connectionId.present
          ? data.connectionId.value
          : this.connectionId,
      taskType: data.taskType.present ? data.taskType.value : this.taskType,
      totalItems:
          data.totalItems.present ? data.totalItems.value : this.totalItems,
      processedItems: data.processedItems.present
          ? data.processedItems.value
          : this.processedItems,
      succeededItems: data.succeededItems.present
          ? data.succeededItems.value
          : this.succeededItems,
      failedItems:
          data.failedItems.present ? data.failedItems.value : this.failedItems,
      payload: data.payload.present ? data.payload.value : this.payload,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskCheckpointsTableData(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('connectionId: $connectionId, ')
          ..write('taskType: $taskType, ')
          ..write('totalItems: $totalItems, ')
          ..write('processedItems: $processedItems, ')
          ..write('succeededItems: $succeededItems, ')
          ..write('failedItems: $failedItems, ')
          ..write('payload: $payload, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      taskId,
      connectionId,
      taskType,
      totalItems,
      processedItems,
      succeededItems,
      failedItems,
      payload,
      status,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskCheckpointsTableData &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.connectionId == this.connectionId &&
          other.taskType == this.taskType &&
          other.totalItems == this.totalItems &&
          other.processedItems == this.processedItems &&
          other.succeededItems == this.succeededItems &&
          other.failedItems == this.failedItems &&
          other.payload == this.payload &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TaskCheckpointsTableCompanion
    extends UpdateCompanion<TaskCheckpointsTableData> {
  final Value<int> id;
  final Value<String> taskId;
  final Value<int> connectionId;
  final Value<String> taskType;
  final Value<int> totalItems;
  final Value<int> processedItems;
  final Value<int> succeededItems;
  final Value<int> failedItems;
  final Value<String> payload;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const TaskCheckpointsTableCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.connectionId = const Value.absent(),
    this.taskType = const Value.absent(),
    this.totalItems = const Value.absent(),
    this.processedItems = const Value.absent(),
    this.succeededItems = const Value.absent(),
    this.failedItems = const Value.absent(),
    this.payload = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TaskCheckpointsTableCompanion.insert({
    this.id = const Value.absent(),
    required String taskId,
    required int connectionId,
    required String taskType,
    this.totalItems = const Value.absent(),
    this.processedItems = const Value.absent(),
    this.succeededItems = const Value.absent(),
    this.failedItems = const Value.absent(),
    this.payload = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : taskId = Value(taskId),
        connectionId = Value(connectionId),
        taskType = Value(taskType);
  static Insertable<TaskCheckpointsTableData> custom({
    Expression<int>? id,
    Expression<String>? taskId,
    Expression<int>? connectionId,
    Expression<String>? taskType,
    Expression<int>? totalItems,
    Expression<int>? processedItems,
    Expression<int>? succeededItems,
    Expression<int>? failedItems,
    Expression<String>? payload,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (connectionId != null) 'connection_id': connectionId,
      if (taskType != null) 'task_type': taskType,
      if (totalItems != null) 'total_items': totalItems,
      if (processedItems != null) 'processed_items': processedItems,
      if (succeededItems != null) 'succeeded_items': succeededItems,
      if (failedItems != null) 'failed_items': failedItems,
      if (payload != null) 'payload': payload,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TaskCheckpointsTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? taskId,
      Value<int>? connectionId,
      Value<String>? taskType,
      Value<int>? totalItems,
      Value<int>? processedItems,
      Value<int>? succeededItems,
      Value<int>? failedItems,
      Value<String>? payload,
      Value<String>? status,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return TaskCheckpointsTableCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      connectionId: connectionId ?? this.connectionId,
      taskType: taskType ?? this.taskType,
      totalItems: totalItems ?? this.totalItems,
      processedItems: processedItems ?? this.processedItems,
      succeededItems: succeededItems ?? this.succeededItems,
      failedItems: failedItems ?? this.failedItems,
      payload: payload ?? this.payload,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (connectionId.present) {
      map['connection_id'] = Variable<int>(connectionId.value);
    }
    if (taskType.present) {
      map['task_type'] = Variable<String>(taskType.value);
    }
    if (totalItems.present) {
      map['total_items'] = Variable<int>(totalItems.value);
    }
    if (processedItems.present) {
      map['processed_items'] = Variable<int>(processedItems.value);
    }
    if (succeededItems.present) {
      map['succeeded_items'] = Variable<int>(succeededItems.value);
    }
    if (failedItems.present) {
      map['failed_items'] = Variable<int>(failedItems.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskCheckpointsTableCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('connectionId: $connectionId, ')
          ..write('taskType: $taskType, ')
          ..write('totalItems: $totalItems, ')
          ..write('processedItems: $processedItems, ')
          ..write('succeededItems: $succeededItems, ')
          ..write('failedItems: $failedItems, ')
          ..write('payload: $payload, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $UmProfilesCacheTableTable extends UmProfilesCacheTable
    with TableInfo<$UmProfilesCacheTableTable, UmProfilesCacheTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UmProfilesCacheTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _connectionIdMeta =
      const VerificationMeta('connectionId');
  @override
  late final GeneratedColumn<int> connectionId = GeneratedColumn<int>(
      'connection_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _profileNameMeta =
      const VerificationMeta('profileName');
  @override
  late final GeneratedColumn<String> profileName = GeneratedColumn<String>(
      'profile_name', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 128),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _ownerMeta = const VerificationMeta('owner');
  @override
  late final GeneratedColumn<String> owner = GeneratedColumn<String>(
      'owner', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('admin'));
  static const VerificationMeta _validityMeta =
      const VerificationMeta('validity');
  @override
  late final GeneratedColumn<String> validity = GeneratedColumn<String>(
      'validity', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<String> price = GeneratedColumn<String>(
      'price', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('0'));
  static const VerificationMeta _rawJsonMeta =
      const VerificationMeta('rawJson');
  @override
  late final GeneratedColumn<String> rawJson = GeneratedColumn<String>(
      'raw_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('{}'));
  static const VerificationMeta _cachedAtMeta =
      const VerificationMeta('cachedAt');
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
      'cached_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        connectionId,
        profileName,
        owner,
        validity,
        price,
        rawJson,
        cachedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'um_profiles_cache_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<UmProfilesCacheTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('connection_id')) {
      context.handle(
          _connectionIdMeta,
          connectionId.isAcceptableOrUnknown(
              data['connection_id']!, _connectionIdMeta));
    } else if (isInserting) {
      context.missing(_connectionIdMeta);
    }
    if (data.containsKey('profile_name')) {
      context.handle(
          _profileNameMeta,
          profileName.isAcceptableOrUnknown(
              data['profile_name']!, _profileNameMeta));
    } else if (isInserting) {
      context.missing(_profileNameMeta);
    }
    if (data.containsKey('owner')) {
      context.handle(
          _ownerMeta, owner.isAcceptableOrUnknown(data['owner']!, _ownerMeta));
    }
    if (data.containsKey('validity')) {
      context.handle(_validityMeta,
          validity.isAcceptableOrUnknown(data['validity']!, _validityMeta));
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    }
    if (data.containsKey('raw_json')) {
      context.handle(_rawJsonMeta,
          rawJson.isAcceptableOrUnknown(data['raw_json']!, _rawJsonMeta));
    }
    if (data.containsKey('cached_at')) {
      context.handle(_cachedAtMeta,
          cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UmProfilesCacheTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UmProfilesCacheTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      connectionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}connection_id'])!,
      profileName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_name'])!,
      owner: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}owner'])!,
      validity: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}validity'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}price'])!,
      rawJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}raw_json'])!,
      cachedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}cached_at'])!,
    );
  }

  @override
  $UmProfilesCacheTableTable createAlias(String alias) {
    return $UmProfilesCacheTableTable(attachedDatabase, alias);
  }
}

class UmProfilesCacheTableData extends DataClass
    implements Insertable<UmProfilesCacheTableData> {
  final int id;
  final int connectionId;
  final String profileName;
  final String owner;
  final String validity;
  final String price;
  final String rawJson;
  final DateTime cachedAt;
  const UmProfilesCacheTableData(
      {required this.id,
      required this.connectionId,
      required this.profileName,
      required this.owner,
      required this.validity,
      required this.price,
      required this.rawJson,
      required this.cachedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['connection_id'] = Variable<int>(connectionId);
    map['profile_name'] = Variable<String>(profileName);
    map['owner'] = Variable<String>(owner);
    map['validity'] = Variable<String>(validity);
    map['price'] = Variable<String>(price);
    map['raw_json'] = Variable<String>(rawJson);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  UmProfilesCacheTableCompanion toCompanion(bool nullToAbsent) {
    return UmProfilesCacheTableCompanion(
      id: Value(id),
      connectionId: Value(connectionId),
      profileName: Value(profileName),
      owner: Value(owner),
      validity: Value(validity),
      price: Value(price),
      rawJson: Value(rawJson),
      cachedAt: Value(cachedAt),
    );
  }

  factory UmProfilesCacheTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UmProfilesCacheTableData(
      id: serializer.fromJson<int>(json['id']),
      connectionId: serializer.fromJson<int>(json['connectionId']),
      profileName: serializer.fromJson<String>(json['profileName']),
      owner: serializer.fromJson<String>(json['owner']),
      validity: serializer.fromJson<String>(json['validity']),
      price: serializer.fromJson<String>(json['price']),
      rawJson: serializer.fromJson<String>(json['rawJson']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'connectionId': serializer.toJson<int>(connectionId),
      'profileName': serializer.toJson<String>(profileName),
      'owner': serializer.toJson<String>(owner),
      'validity': serializer.toJson<String>(validity),
      'price': serializer.toJson<String>(price),
      'rawJson': serializer.toJson<String>(rawJson),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  UmProfilesCacheTableData copyWith(
          {int? id,
          int? connectionId,
          String? profileName,
          String? owner,
          String? validity,
          String? price,
          String? rawJson,
          DateTime? cachedAt}) =>
      UmProfilesCacheTableData(
        id: id ?? this.id,
        connectionId: connectionId ?? this.connectionId,
        profileName: profileName ?? this.profileName,
        owner: owner ?? this.owner,
        validity: validity ?? this.validity,
        price: price ?? this.price,
        rawJson: rawJson ?? this.rawJson,
        cachedAt: cachedAt ?? this.cachedAt,
      );
  UmProfilesCacheTableData copyWithCompanion(
      UmProfilesCacheTableCompanion data) {
    return UmProfilesCacheTableData(
      id: data.id.present ? data.id.value : this.id,
      connectionId: data.connectionId.present
          ? data.connectionId.value
          : this.connectionId,
      profileName:
          data.profileName.present ? data.profileName.value : this.profileName,
      owner: data.owner.present ? data.owner.value : this.owner,
      validity: data.validity.present ? data.validity.value : this.validity,
      price: data.price.present ? data.price.value : this.price,
      rawJson: data.rawJson.present ? data.rawJson.value : this.rawJson,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UmProfilesCacheTableData(')
          ..write('id: $id, ')
          ..write('connectionId: $connectionId, ')
          ..write('profileName: $profileName, ')
          ..write('owner: $owner, ')
          ..write('validity: $validity, ')
          ..write('price: $price, ')
          ..write('rawJson: $rawJson, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, connectionId, profileName, owner, validity, price, rawJson, cachedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UmProfilesCacheTableData &&
          other.id == this.id &&
          other.connectionId == this.connectionId &&
          other.profileName == this.profileName &&
          other.owner == this.owner &&
          other.validity == this.validity &&
          other.price == this.price &&
          other.rawJson == this.rawJson &&
          other.cachedAt == this.cachedAt);
}

class UmProfilesCacheTableCompanion
    extends UpdateCompanion<UmProfilesCacheTableData> {
  final Value<int> id;
  final Value<int> connectionId;
  final Value<String> profileName;
  final Value<String> owner;
  final Value<String> validity;
  final Value<String> price;
  final Value<String> rawJson;
  final Value<DateTime> cachedAt;
  const UmProfilesCacheTableCompanion({
    this.id = const Value.absent(),
    this.connectionId = const Value.absent(),
    this.profileName = const Value.absent(),
    this.owner = const Value.absent(),
    this.validity = const Value.absent(),
    this.price = const Value.absent(),
    this.rawJson = const Value.absent(),
    this.cachedAt = const Value.absent(),
  });
  UmProfilesCacheTableCompanion.insert({
    this.id = const Value.absent(),
    required int connectionId,
    required String profileName,
    this.owner = const Value.absent(),
    this.validity = const Value.absent(),
    this.price = const Value.absent(),
    this.rawJson = const Value.absent(),
    this.cachedAt = const Value.absent(),
  })  : connectionId = Value(connectionId),
        profileName = Value(profileName);
  static Insertable<UmProfilesCacheTableData> custom({
    Expression<int>? id,
    Expression<int>? connectionId,
    Expression<String>? profileName,
    Expression<String>? owner,
    Expression<String>? validity,
    Expression<String>? price,
    Expression<String>? rawJson,
    Expression<DateTime>? cachedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (connectionId != null) 'connection_id': connectionId,
      if (profileName != null) 'profile_name': profileName,
      if (owner != null) 'owner': owner,
      if (validity != null) 'validity': validity,
      if (price != null) 'price': price,
      if (rawJson != null) 'raw_json': rawJson,
      if (cachedAt != null) 'cached_at': cachedAt,
    });
  }

  UmProfilesCacheTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? connectionId,
      Value<String>? profileName,
      Value<String>? owner,
      Value<String>? validity,
      Value<String>? price,
      Value<String>? rawJson,
      Value<DateTime>? cachedAt}) {
    return UmProfilesCacheTableCompanion(
      id: id ?? this.id,
      connectionId: connectionId ?? this.connectionId,
      profileName: profileName ?? this.profileName,
      owner: owner ?? this.owner,
      validity: validity ?? this.validity,
      price: price ?? this.price,
      rawJson: rawJson ?? this.rawJson,
      cachedAt: cachedAt ?? this.cachedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (connectionId.present) {
      map['connection_id'] = Variable<int>(connectionId.value);
    }
    if (profileName.present) {
      map['profile_name'] = Variable<String>(profileName.value);
    }
    if (owner.present) {
      map['owner'] = Variable<String>(owner.value);
    }
    if (validity.present) {
      map['validity'] = Variable<String>(validity.value);
    }
    if (price.present) {
      map['price'] = Variable<String>(price.value);
    }
    if (rawJson.present) {
      map['raw_json'] = Variable<String>(rawJson.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UmProfilesCacheTableCompanion(')
          ..write('id: $id, ')
          ..write('connectionId: $connectionId, ')
          ..write('profileName: $profileName, ')
          ..write('owner: $owner, ')
          ..write('validity: $validity, ')
          ..write('price: $price, ')
          ..write('rawJson: $rawJson, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }
}

class $UmDiagnosticsLogTableTable extends UmDiagnosticsLogTable
    with TableInfo<$UmDiagnosticsLogTableTable, UmDiagnosticsLogTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UmDiagnosticsLogTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _connectionIdMeta =
      const VerificationMeta('connectionId');
  @override
  late final GeneratedColumn<int> connectionId = GeneratedColumn<int>(
      'connection_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _checkKeyMeta =
      const VerificationMeta('checkKey');
  @override
  late final GeneratedColumn<String> checkKey = GeneratedColumn<String>(
      'check_key', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 128),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('unknown'));
  static const VerificationMeta _detailsMeta =
      const VerificationMeta('details');
  @override
  late final GeneratedColumn<String> details = GeneratedColumn<String>(
      'details', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _checkedAtMeta =
      const VerificationMeta('checkedAt');
  @override
  late final GeneratedColumn<DateTime> checkedAt = GeneratedColumn<DateTime>(
      'checked_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, connectionId, checkKey, status, details, checkedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'um_diagnostics_log_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<UmDiagnosticsLogTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('connection_id')) {
      context.handle(
          _connectionIdMeta,
          connectionId.isAcceptableOrUnknown(
              data['connection_id']!, _connectionIdMeta));
    } else if (isInserting) {
      context.missing(_connectionIdMeta);
    }
    if (data.containsKey('check_key')) {
      context.handle(_checkKeyMeta,
          checkKey.isAcceptableOrUnknown(data['check_key']!, _checkKeyMeta));
    } else if (isInserting) {
      context.missing(_checkKeyMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('details')) {
      context.handle(_detailsMeta,
          details.isAcceptableOrUnknown(data['details']!, _detailsMeta));
    }
    if (data.containsKey('checked_at')) {
      context.handle(_checkedAtMeta,
          checkedAt.isAcceptableOrUnknown(data['checked_at']!, _checkedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UmDiagnosticsLogTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UmDiagnosticsLogTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      connectionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}connection_id'])!,
      checkKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}check_key'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      details: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}details'])!,
      checkedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}checked_at'])!,
    );
  }

  @override
  $UmDiagnosticsLogTableTable createAlias(String alias) {
    return $UmDiagnosticsLogTableTable(attachedDatabase, alias);
  }
}

class UmDiagnosticsLogTableData extends DataClass
    implements Insertable<UmDiagnosticsLogTableData> {
  final int id;
  final int connectionId;
  final String checkKey;

  /// pass | warn | fail | unknown
  final String status;
  final String details;
  final DateTime checkedAt;
  const UmDiagnosticsLogTableData(
      {required this.id,
      required this.connectionId,
      required this.checkKey,
      required this.status,
      required this.details,
      required this.checkedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['connection_id'] = Variable<int>(connectionId);
    map['check_key'] = Variable<String>(checkKey);
    map['status'] = Variable<String>(status);
    map['details'] = Variable<String>(details);
    map['checked_at'] = Variable<DateTime>(checkedAt);
    return map;
  }

  UmDiagnosticsLogTableCompanion toCompanion(bool nullToAbsent) {
    return UmDiagnosticsLogTableCompanion(
      id: Value(id),
      connectionId: Value(connectionId),
      checkKey: Value(checkKey),
      status: Value(status),
      details: Value(details),
      checkedAt: Value(checkedAt),
    );
  }

  factory UmDiagnosticsLogTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UmDiagnosticsLogTableData(
      id: serializer.fromJson<int>(json['id']),
      connectionId: serializer.fromJson<int>(json['connectionId']),
      checkKey: serializer.fromJson<String>(json['checkKey']),
      status: serializer.fromJson<String>(json['status']),
      details: serializer.fromJson<String>(json['details']),
      checkedAt: serializer.fromJson<DateTime>(json['checkedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'connectionId': serializer.toJson<int>(connectionId),
      'checkKey': serializer.toJson<String>(checkKey),
      'status': serializer.toJson<String>(status),
      'details': serializer.toJson<String>(details),
      'checkedAt': serializer.toJson<DateTime>(checkedAt),
    };
  }

  UmDiagnosticsLogTableData copyWith(
          {int? id,
          int? connectionId,
          String? checkKey,
          String? status,
          String? details,
          DateTime? checkedAt}) =>
      UmDiagnosticsLogTableData(
        id: id ?? this.id,
        connectionId: connectionId ?? this.connectionId,
        checkKey: checkKey ?? this.checkKey,
        status: status ?? this.status,
        details: details ?? this.details,
        checkedAt: checkedAt ?? this.checkedAt,
      );
  UmDiagnosticsLogTableData copyWithCompanion(
      UmDiagnosticsLogTableCompanion data) {
    return UmDiagnosticsLogTableData(
      id: data.id.present ? data.id.value : this.id,
      connectionId: data.connectionId.present
          ? data.connectionId.value
          : this.connectionId,
      checkKey: data.checkKey.present ? data.checkKey.value : this.checkKey,
      status: data.status.present ? data.status.value : this.status,
      details: data.details.present ? data.details.value : this.details,
      checkedAt: data.checkedAt.present ? data.checkedAt.value : this.checkedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UmDiagnosticsLogTableData(')
          ..write('id: $id, ')
          ..write('connectionId: $connectionId, ')
          ..write('checkKey: $checkKey, ')
          ..write('status: $status, ')
          ..write('details: $details, ')
          ..write('checkedAt: $checkedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, connectionId, checkKey, status, details, checkedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UmDiagnosticsLogTableData &&
          other.id == this.id &&
          other.connectionId == this.connectionId &&
          other.checkKey == this.checkKey &&
          other.status == this.status &&
          other.details == this.details &&
          other.checkedAt == this.checkedAt);
}

class UmDiagnosticsLogTableCompanion
    extends UpdateCompanion<UmDiagnosticsLogTableData> {
  final Value<int> id;
  final Value<int> connectionId;
  final Value<String> checkKey;
  final Value<String> status;
  final Value<String> details;
  final Value<DateTime> checkedAt;
  const UmDiagnosticsLogTableCompanion({
    this.id = const Value.absent(),
    this.connectionId = const Value.absent(),
    this.checkKey = const Value.absent(),
    this.status = const Value.absent(),
    this.details = const Value.absent(),
    this.checkedAt = const Value.absent(),
  });
  UmDiagnosticsLogTableCompanion.insert({
    this.id = const Value.absent(),
    required int connectionId,
    required String checkKey,
    this.status = const Value.absent(),
    this.details = const Value.absent(),
    this.checkedAt = const Value.absent(),
  })  : connectionId = Value(connectionId),
        checkKey = Value(checkKey);
  static Insertable<UmDiagnosticsLogTableData> custom({
    Expression<int>? id,
    Expression<int>? connectionId,
    Expression<String>? checkKey,
    Expression<String>? status,
    Expression<String>? details,
    Expression<DateTime>? checkedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (connectionId != null) 'connection_id': connectionId,
      if (checkKey != null) 'check_key': checkKey,
      if (status != null) 'status': status,
      if (details != null) 'details': details,
      if (checkedAt != null) 'checked_at': checkedAt,
    });
  }

  UmDiagnosticsLogTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? connectionId,
      Value<String>? checkKey,
      Value<String>? status,
      Value<String>? details,
      Value<DateTime>? checkedAt}) {
    return UmDiagnosticsLogTableCompanion(
      id: id ?? this.id,
      connectionId: connectionId ?? this.connectionId,
      checkKey: checkKey ?? this.checkKey,
      status: status ?? this.status,
      details: details ?? this.details,
      checkedAt: checkedAt ?? this.checkedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (connectionId.present) {
      map['connection_id'] = Variable<int>(connectionId.value);
    }
    if (checkKey.present) {
      map['check_key'] = Variable<String>(checkKey.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (details.present) {
      map['details'] = Variable<String>(details.value);
    }
    if (checkedAt.present) {
      map['checked_at'] = Variable<DateTime>(checkedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UmDiagnosticsLogTableCompanion(')
          ..write('id: $id, ')
          ..write('connectionId: $connectionId, ')
          ..write('checkKey: $checkKey, ')
          ..write('status: $status, ')
          ..write('details: $details, ')
          ..write('checkedAt: $checkedAt')
          ..write(')'))
        .toString();
  }
}

class $ResellersTableTable extends ResellersTable
    with TableInfo<$ResellersTableTable, ResellersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ResellersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _connectionIdMeta =
      const VerificationMeta('connectionId');
  @override
  late final GeneratedColumn<int> connectionId = GeneratedColumn<int>(
      'connection_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 128),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, connectionId, name, phone, notes, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'resellers_table';
  @override
  VerificationContext validateIntegrity(Insertable<ResellersTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('connection_id')) {
      context.handle(
          _connectionIdMeta,
          connectionId.isAcceptableOrUnknown(
              data['connection_id']!, _connectionIdMeta));
    } else if (isInserting) {
      context.missing(_connectionIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ResellersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ResellersTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      connectionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}connection_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ResellersTableTable createAlias(String alias) {
    return $ResellersTableTable(attachedDatabase, alias);
  }
}

class ResellersTableData extends DataClass
    implements Insertable<ResellersTableData> {
  final int id;
  final int connectionId;
  final String name;
  final String phone;
  final String notes;
  final DateTime createdAt;
  const ResellersTableData(
      {required this.id,
      required this.connectionId,
      required this.name,
      required this.phone,
      required this.notes,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['connection_id'] = Variable<int>(connectionId);
    map['name'] = Variable<String>(name);
    map['phone'] = Variable<String>(phone);
    map['notes'] = Variable<String>(notes);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ResellersTableCompanion toCompanion(bool nullToAbsent) {
    return ResellersTableCompanion(
      id: Value(id),
      connectionId: Value(connectionId),
      name: Value(name),
      phone: Value(phone),
      notes: Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory ResellersTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ResellersTableData(
      id: serializer.fromJson<int>(json['id']),
      connectionId: serializer.fromJson<int>(json['connectionId']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String>(json['phone']),
      notes: serializer.fromJson<String>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'connectionId': serializer.toJson<int>(connectionId),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String>(phone),
      'notes': serializer.toJson<String>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ResellersTableData copyWith(
          {int? id,
          int? connectionId,
          String? name,
          String? phone,
          String? notes,
          DateTime? createdAt}) =>
      ResellersTableData(
        id: id ?? this.id,
        connectionId: connectionId ?? this.connectionId,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        notes: notes ?? this.notes,
        createdAt: createdAt ?? this.createdAt,
      );
  ResellersTableData copyWithCompanion(ResellersTableCompanion data) {
    return ResellersTableData(
      id: data.id.present ? data.id.value : this.id,
      connectionId: data.connectionId.present
          ? data.connectionId.value
          : this.connectionId,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ResellersTableData(')
          ..write('id: $id, ')
          ..write('connectionId: $connectionId, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, connectionId, name, phone, notes, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ResellersTableData &&
          other.id == this.id &&
          other.connectionId == this.connectionId &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class ResellersTableCompanion extends UpdateCompanion<ResellersTableData> {
  final Value<int> id;
  final Value<int> connectionId;
  final Value<String> name;
  final Value<String> phone;
  final Value<String> notes;
  final Value<DateTime> createdAt;
  const ResellersTableCompanion({
    this.id = const Value.absent(),
    this.connectionId = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ResellersTableCompanion.insert({
    this.id = const Value.absent(),
    required int connectionId,
    required String name,
    this.phone = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : connectionId = Value(connectionId),
        name = Value(name);
  static Insertable<ResellersTableData> custom({
    Expression<int>? id,
    Expression<int>? connectionId,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (connectionId != null) 'connection_id': connectionId,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ResellersTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? connectionId,
      Value<String>? name,
      Value<String>? phone,
      Value<String>? notes,
      Value<DateTime>? createdAt}) {
    return ResellersTableCompanion(
      id: id ?? this.id,
      connectionId: connectionId ?? this.connectionId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (connectionId.present) {
      map['connection_id'] = Variable<int>(connectionId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ResellersTableCompanion(')
          ..write('id: $id, ')
          ..write('connectionId: $connectionId, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ResellerAllocationsTableTable extends ResellerAllocationsTable
    with
        TableInfo<$ResellerAllocationsTableTable,
            ResellerAllocationsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ResellerAllocationsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _resellerIdMeta =
      const VerificationMeta('resellerId');
  @override
  late final GeneratedColumn<int> resellerId = GeneratedColumn<int>(
      'reseller_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _batchIdMeta =
      const VerificationMeta('batchId');
  @override
  late final GeneratedColumn<String> batchId = GeneratedColumn<String>(
      'batch_id', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 64),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _profileMeta =
      const VerificationMeta('profile');
  @override
  late final GeneratedColumn<String> profile = GeneratedColumn<String>(
      'profile', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 128),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 8),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _unitPriceMeta =
      const VerificationMeta('unitPrice');
  @override
  late final GeneratedColumn<double> unitPrice = GeneratedColumn<double>(
      'unit_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _totalValueMeta =
      const VerificationMeta('totalValue');
  @override
  late final GeneratedColumn<double> totalValue = GeneratedColumn<double>(
      'total_value', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _allocatedAtMeta =
      const VerificationMeta('allocatedAt');
  @override
  late final GeneratedColumn<DateTime> allocatedAt = GeneratedColumn<DateTime>(
      'allocated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        resellerId,
        batchId,
        profile,
        quantity,
        currency,
        unitPrice,
        totalValue,
        allocatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reseller_allocations_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<ResellerAllocationsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('reseller_id')) {
      context.handle(
          _resellerIdMeta,
          resellerId.isAcceptableOrUnknown(
              data['reseller_id']!, _resellerIdMeta));
    } else if (isInserting) {
      context.missing(_resellerIdMeta);
    }
    if (data.containsKey('batch_id')) {
      context.handle(_batchIdMeta,
          batchId.isAcceptableOrUnknown(data['batch_id']!, _batchIdMeta));
    } else if (isInserting) {
      context.missing(_batchIdMeta);
    }
    if (data.containsKey('profile')) {
      context.handle(_profileMeta,
          profile.isAcceptableOrUnknown(data['profile']!, _profileMeta));
    } else if (isInserting) {
      context.missing(_profileMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('unit_price')) {
      context.handle(_unitPriceMeta,
          unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta));
    } else if (isInserting) {
      context.missing(_unitPriceMeta);
    }
    if (data.containsKey('total_value')) {
      context.handle(
          _totalValueMeta,
          totalValue.isAcceptableOrUnknown(
              data['total_value']!, _totalValueMeta));
    } else if (isInserting) {
      context.missing(_totalValueMeta);
    }
    if (data.containsKey('allocated_at')) {
      context.handle(
          _allocatedAtMeta,
          allocatedAt.isAcceptableOrUnknown(
              data['allocated_at']!, _allocatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ResellerAllocationsTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ResellerAllocationsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      resellerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}reseller_id'])!,
      batchId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}batch_id'])!,
      profile: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      unitPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}unit_price'])!,
      totalValue: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_value'])!,
      allocatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}allocated_at'])!,
    );
  }

  @override
  $ResellerAllocationsTableTable createAlias(String alias) {
    return $ResellerAllocationsTableTable(attachedDatabase, alias);
  }
}

class ResellerAllocationsTableData extends DataClass
    implements Insertable<ResellerAllocationsTableData> {
  final int id;
  final int resellerId;
  final String batchId;
  final String profile;
  final int quantity;

  /// ISO 4217 currency code, e.g. YER, SAR, USD
  final String currency;
  final double unitPrice;
  final double totalValue;
  final DateTime allocatedAt;
  const ResellerAllocationsTableData(
      {required this.id,
      required this.resellerId,
      required this.batchId,
      required this.profile,
      required this.quantity,
      required this.currency,
      required this.unitPrice,
      required this.totalValue,
      required this.allocatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['reseller_id'] = Variable<int>(resellerId);
    map['batch_id'] = Variable<String>(batchId);
    map['profile'] = Variable<String>(profile);
    map['quantity'] = Variable<int>(quantity);
    map['currency'] = Variable<String>(currency);
    map['unit_price'] = Variable<double>(unitPrice);
    map['total_value'] = Variable<double>(totalValue);
    map['allocated_at'] = Variable<DateTime>(allocatedAt);
    return map;
  }

  ResellerAllocationsTableCompanion toCompanion(bool nullToAbsent) {
    return ResellerAllocationsTableCompanion(
      id: Value(id),
      resellerId: Value(resellerId),
      batchId: Value(batchId),
      profile: Value(profile),
      quantity: Value(quantity),
      currency: Value(currency),
      unitPrice: Value(unitPrice),
      totalValue: Value(totalValue),
      allocatedAt: Value(allocatedAt),
    );
  }

  factory ResellerAllocationsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ResellerAllocationsTableData(
      id: serializer.fromJson<int>(json['id']),
      resellerId: serializer.fromJson<int>(json['resellerId']),
      batchId: serializer.fromJson<String>(json['batchId']),
      profile: serializer.fromJson<String>(json['profile']),
      quantity: serializer.fromJson<int>(json['quantity']),
      currency: serializer.fromJson<String>(json['currency']),
      unitPrice: serializer.fromJson<double>(json['unitPrice']),
      totalValue: serializer.fromJson<double>(json['totalValue']),
      allocatedAt: serializer.fromJson<DateTime>(json['allocatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'resellerId': serializer.toJson<int>(resellerId),
      'batchId': serializer.toJson<String>(batchId),
      'profile': serializer.toJson<String>(profile),
      'quantity': serializer.toJson<int>(quantity),
      'currency': serializer.toJson<String>(currency),
      'unitPrice': serializer.toJson<double>(unitPrice),
      'totalValue': serializer.toJson<double>(totalValue),
      'allocatedAt': serializer.toJson<DateTime>(allocatedAt),
    };
  }

  ResellerAllocationsTableData copyWith(
          {int? id,
          int? resellerId,
          String? batchId,
          String? profile,
          int? quantity,
          String? currency,
          double? unitPrice,
          double? totalValue,
          DateTime? allocatedAt}) =>
      ResellerAllocationsTableData(
        id: id ?? this.id,
        resellerId: resellerId ?? this.resellerId,
        batchId: batchId ?? this.batchId,
        profile: profile ?? this.profile,
        quantity: quantity ?? this.quantity,
        currency: currency ?? this.currency,
        unitPrice: unitPrice ?? this.unitPrice,
        totalValue: totalValue ?? this.totalValue,
        allocatedAt: allocatedAt ?? this.allocatedAt,
      );
  ResellerAllocationsTableData copyWithCompanion(
      ResellerAllocationsTableCompanion data) {
    return ResellerAllocationsTableData(
      id: data.id.present ? data.id.value : this.id,
      resellerId:
          data.resellerId.present ? data.resellerId.value : this.resellerId,
      batchId: data.batchId.present ? data.batchId.value : this.batchId,
      profile: data.profile.present ? data.profile.value : this.profile,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      currency: data.currency.present ? data.currency.value : this.currency,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      totalValue:
          data.totalValue.present ? data.totalValue.value : this.totalValue,
      allocatedAt:
          data.allocatedAt.present ? data.allocatedAt.value : this.allocatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ResellerAllocationsTableData(')
          ..write('id: $id, ')
          ..write('resellerId: $resellerId, ')
          ..write('batchId: $batchId, ')
          ..write('profile: $profile, ')
          ..write('quantity: $quantity, ')
          ..write('currency: $currency, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('totalValue: $totalValue, ')
          ..write('allocatedAt: $allocatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, resellerId, batchId, profile, quantity,
      currency, unitPrice, totalValue, allocatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ResellerAllocationsTableData &&
          other.id == this.id &&
          other.resellerId == this.resellerId &&
          other.batchId == this.batchId &&
          other.profile == this.profile &&
          other.quantity == this.quantity &&
          other.currency == this.currency &&
          other.unitPrice == this.unitPrice &&
          other.totalValue == this.totalValue &&
          other.allocatedAt == this.allocatedAt);
}

class ResellerAllocationsTableCompanion
    extends UpdateCompanion<ResellerAllocationsTableData> {
  final Value<int> id;
  final Value<int> resellerId;
  final Value<String> batchId;
  final Value<String> profile;
  final Value<int> quantity;
  final Value<String> currency;
  final Value<double> unitPrice;
  final Value<double> totalValue;
  final Value<DateTime> allocatedAt;
  const ResellerAllocationsTableCompanion({
    this.id = const Value.absent(),
    this.resellerId = const Value.absent(),
    this.batchId = const Value.absent(),
    this.profile = const Value.absent(),
    this.quantity = const Value.absent(),
    this.currency = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.totalValue = const Value.absent(),
    this.allocatedAt = const Value.absent(),
  });
  ResellerAllocationsTableCompanion.insert({
    this.id = const Value.absent(),
    required int resellerId,
    required String batchId,
    required String profile,
    required int quantity,
    required String currency,
    required double unitPrice,
    required double totalValue,
    this.allocatedAt = const Value.absent(),
  })  : resellerId = Value(resellerId),
        batchId = Value(batchId),
        profile = Value(profile),
        quantity = Value(quantity),
        currency = Value(currency),
        unitPrice = Value(unitPrice),
        totalValue = Value(totalValue);
  static Insertable<ResellerAllocationsTableData> custom({
    Expression<int>? id,
    Expression<int>? resellerId,
    Expression<String>? batchId,
    Expression<String>? profile,
    Expression<int>? quantity,
    Expression<String>? currency,
    Expression<double>? unitPrice,
    Expression<double>? totalValue,
    Expression<DateTime>? allocatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (resellerId != null) 'reseller_id': resellerId,
      if (batchId != null) 'batch_id': batchId,
      if (profile != null) 'profile': profile,
      if (quantity != null) 'quantity': quantity,
      if (currency != null) 'currency': currency,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (totalValue != null) 'total_value': totalValue,
      if (allocatedAt != null) 'allocated_at': allocatedAt,
    });
  }

  ResellerAllocationsTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? resellerId,
      Value<String>? batchId,
      Value<String>? profile,
      Value<int>? quantity,
      Value<String>? currency,
      Value<double>? unitPrice,
      Value<double>? totalValue,
      Value<DateTime>? allocatedAt}) {
    return ResellerAllocationsTableCompanion(
      id: id ?? this.id,
      resellerId: resellerId ?? this.resellerId,
      batchId: batchId ?? this.batchId,
      profile: profile ?? this.profile,
      quantity: quantity ?? this.quantity,
      currency: currency ?? this.currency,
      unitPrice: unitPrice ?? this.unitPrice,
      totalValue: totalValue ?? this.totalValue,
      allocatedAt: allocatedAt ?? this.allocatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (resellerId.present) {
      map['reseller_id'] = Variable<int>(resellerId.value);
    }
    if (batchId.present) {
      map['batch_id'] = Variable<String>(batchId.value);
    }
    if (profile.present) {
      map['profile'] = Variable<String>(profile.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<double>(unitPrice.value);
    }
    if (totalValue.present) {
      map['total_value'] = Variable<double>(totalValue.value);
    }
    if (allocatedAt.present) {
      map['allocated_at'] = Variable<DateTime>(allocatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ResellerAllocationsTableCompanion(')
          ..write('id: $id, ')
          ..write('resellerId: $resellerId, ')
          ..write('batchId: $batchId, ')
          ..write('profile: $profile, ')
          ..write('quantity: $quantity, ')
          ..write('currency: $currency, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('totalValue: $totalValue, ')
          ..write('allocatedAt: $allocatedAt')
          ..write(')'))
        .toString();
  }
}

class $ResellerSettlementsTableTable extends ResellerSettlementsTable
    with
        TableInfo<$ResellerSettlementsTableTable,
            ResellerSettlementsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ResellerSettlementsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _resellerIdMeta =
      const VerificationMeta('resellerId');
  @override
  late final GeneratedColumn<int> resellerId = GeneratedColumn<int>(
      'reseller_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 8),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _amountPaidMeta =
      const VerificationMeta('amountPaid');
  @override
  late final GeneratedColumn<double> amountPaid = GeneratedColumn<double>(
      'amount_paid', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _settledAtMeta =
      const VerificationMeta('settledAt');
  @override
  late final GeneratedColumn<DateTime> settledAt = GeneratedColumn<DateTime>(
      'settled_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, resellerId, currency, amountPaid, notes, settledAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reseller_settlements_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<ResellerSettlementsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('reseller_id')) {
      context.handle(
          _resellerIdMeta,
          resellerId.isAcceptableOrUnknown(
              data['reseller_id']!, _resellerIdMeta));
    } else if (isInserting) {
      context.missing(_resellerIdMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('amount_paid')) {
      context.handle(
          _amountPaidMeta,
          amountPaid.isAcceptableOrUnknown(
              data['amount_paid']!, _amountPaidMeta));
    } else if (isInserting) {
      context.missing(_amountPaidMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('settled_at')) {
      context.handle(_settledAtMeta,
          settledAt.isAcceptableOrUnknown(data['settled_at']!, _settledAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ResellerSettlementsTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ResellerSettlementsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      resellerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}reseller_id'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      amountPaid: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount_paid'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes'])!,
      settledAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}settled_at'])!,
    );
  }

  @override
  $ResellerSettlementsTableTable createAlias(String alias) {
    return $ResellerSettlementsTableTable(attachedDatabase, alias);
  }
}

class ResellerSettlementsTableData extends DataClass
    implements Insertable<ResellerSettlementsTableData> {
  final int id;
  final int resellerId;

  /// ISO 4217 currency code — MUST match allocation currency
  final String currency;
  final double amountPaid;
  final String notes;
  final DateTime settledAt;
  const ResellerSettlementsTableData(
      {required this.id,
      required this.resellerId,
      required this.currency,
      required this.amountPaid,
      required this.notes,
      required this.settledAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['reseller_id'] = Variable<int>(resellerId);
    map['currency'] = Variable<String>(currency);
    map['amount_paid'] = Variable<double>(amountPaid);
    map['notes'] = Variable<String>(notes);
    map['settled_at'] = Variable<DateTime>(settledAt);
    return map;
  }

  ResellerSettlementsTableCompanion toCompanion(bool nullToAbsent) {
    return ResellerSettlementsTableCompanion(
      id: Value(id),
      resellerId: Value(resellerId),
      currency: Value(currency),
      amountPaid: Value(amountPaid),
      notes: Value(notes),
      settledAt: Value(settledAt),
    );
  }

  factory ResellerSettlementsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ResellerSettlementsTableData(
      id: serializer.fromJson<int>(json['id']),
      resellerId: serializer.fromJson<int>(json['resellerId']),
      currency: serializer.fromJson<String>(json['currency']),
      amountPaid: serializer.fromJson<double>(json['amountPaid']),
      notes: serializer.fromJson<String>(json['notes']),
      settledAt: serializer.fromJson<DateTime>(json['settledAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'resellerId': serializer.toJson<int>(resellerId),
      'currency': serializer.toJson<String>(currency),
      'amountPaid': serializer.toJson<double>(amountPaid),
      'notes': serializer.toJson<String>(notes),
      'settledAt': serializer.toJson<DateTime>(settledAt),
    };
  }

  ResellerSettlementsTableData copyWith(
          {int? id,
          int? resellerId,
          String? currency,
          double? amountPaid,
          String? notes,
          DateTime? settledAt}) =>
      ResellerSettlementsTableData(
        id: id ?? this.id,
        resellerId: resellerId ?? this.resellerId,
        currency: currency ?? this.currency,
        amountPaid: amountPaid ?? this.amountPaid,
        notes: notes ?? this.notes,
        settledAt: settledAt ?? this.settledAt,
      );
  ResellerSettlementsTableData copyWithCompanion(
      ResellerSettlementsTableCompanion data) {
    return ResellerSettlementsTableData(
      id: data.id.present ? data.id.value : this.id,
      resellerId:
          data.resellerId.present ? data.resellerId.value : this.resellerId,
      currency: data.currency.present ? data.currency.value : this.currency,
      amountPaid:
          data.amountPaid.present ? data.amountPaid.value : this.amountPaid,
      notes: data.notes.present ? data.notes.value : this.notes,
      settledAt: data.settledAt.present ? data.settledAt.value : this.settledAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ResellerSettlementsTableData(')
          ..write('id: $id, ')
          ..write('resellerId: $resellerId, ')
          ..write('currency: $currency, ')
          ..write('amountPaid: $amountPaid, ')
          ..write('notes: $notes, ')
          ..write('settledAt: $settledAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, resellerId, currency, amountPaid, notes, settledAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ResellerSettlementsTableData &&
          other.id == this.id &&
          other.resellerId == this.resellerId &&
          other.currency == this.currency &&
          other.amountPaid == this.amountPaid &&
          other.notes == this.notes &&
          other.settledAt == this.settledAt);
}

class ResellerSettlementsTableCompanion
    extends UpdateCompanion<ResellerSettlementsTableData> {
  final Value<int> id;
  final Value<int> resellerId;
  final Value<String> currency;
  final Value<double> amountPaid;
  final Value<String> notes;
  final Value<DateTime> settledAt;
  const ResellerSettlementsTableCompanion({
    this.id = const Value.absent(),
    this.resellerId = const Value.absent(),
    this.currency = const Value.absent(),
    this.amountPaid = const Value.absent(),
    this.notes = const Value.absent(),
    this.settledAt = const Value.absent(),
  });
  ResellerSettlementsTableCompanion.insert({
    this.id = const Value.absent(),
    required int resellerId,
    required String currency,
    required double amountPaid,
    this.notes = const Value.absent(),
    this.settledAt = const Value.absent(),
  })  : resellerId = Value(resellerId),
        currency = Value(currency),
        amountPaid = Value(amountPaid);
  static Insertable<ResellerSettlementsTableData> custom({
    Expression<int>? id,
    Expression<int>? resellerId,
    Expression<String>? currency,
    Expression<double>? amountPaid,
    Expression<String>? notes,
    Expression<DateTime>? settledAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (resellerId != null) 'reseller_id': resellerId,
      if (currency != null) 'currency': currency,
      if (amountPaid != null) 'amount_paid': amountPaid,
      if (notes != null) 'notes': notes,
      if (settledAt != null) 'settled_at': settledAt,
    });
  }

  ResellerSettlementsTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? resellerId,
      Value<String>? currency,
      Value<double>? amountPaid,
      Value<String>? notes,
      Value<DateTime>? settledAt}) {
    return ResellerSettlementsTableCompanion(
      id: id ?? this.id,
      resellerId: resellerId ?? this.resellerId,
      currency: currency ?? this.currency,
      amountPaid: amountPaid ?? this.amountPaid,
      notes: notes ?? this.notes,
      settledAt: settledAt ?? this.settledAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (resellerId.present) {
      map['reseller_id'] = Variable<int>(resellerId.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (amountPaid.present) {
      map['amount_paid'] = Variable<double>(amountPaid.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (settledAt.present) {
      map['settled_at'] = Variable<DateTime>(settledAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ResellerSettlementsTableCompanion(')
          ..write('id: $id, ')
          ..write('resellerId: $resellerId, ')
          ..write('currency: $currency, ')
          ..write('amountPaid: $amountPaid, ')
          ..write('notes: $notes, ')
          ..write('settledAt: $settledAt')
          ..write(')'))
        .toString();
  }
}

class $CardSalesTableTable extends CardSalesTable
    with TableInfo<$CardSalesTableTable, CardSalesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardSalesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _connectionIdMeta =
      const VerificationMeta('connectionId');
  @override
  late final GeneratedColumn<int> connectionId = GeneratedColumn<int>(
      'connection_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _saleIdMeta = const VerificationMeta('saleId');
  @override
  late final GeneratedColumn<String> saleId = GeneratedColumn<String>(
      'sale_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _cardTypeMeta =
      const VerificationMeta('cardType');
  @override
  late final GeneratedColumn<String> cardType = GeneratedColumn<String>(
      'card_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('hotspot'));
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _profileMeta =
      const VerificationMeta('profile');
  @override
  late final GeneratedColumn<String> profile = GeneratedColumn<String>(
      'profile', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _costMeta = const VerificationMeta('cost');
  @override
  late final GeneratedColumn<double> cost = GeneratedColumn<double>(
      'cost', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _soldByMeta = const VerificationMeta('soldBy');
  @override
  late final GeneratedColumn<String> soldBy = GeneratedColumn<String>(
      'sold_by', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('admin'));
  static const VerificationMeta _paymentMethodMeta =
      const VerificationMeta('paymentMethod');
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
      'payment_method', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('cash'));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('completed'));
  static const VerificationMeta _customerNameMeta =
      const VerificationMeta('customerName');
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
      'customer_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _customerPhoneMeta =
      const VerificationMeta('customerPhone');
  @override
  late final GeneratedColumn<String> customerPhone = GeneratedColumn<String>(
      'customer_phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isPrintedMeta =
      const VerificationMeta('isPrinted');
  @override
  late final GeneratedColumn<bool> isPrinted = GeneratedColumn<bool>(
      'is_printed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_printed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _soldAtMeta = const VerificationMeta('soldAt');
  @override
  late final GeneratedColumn<DateTime> soldAt = GeneratedColumn<DateTime>(
      'sold_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        connectionId,
        saleId,
        cardType,
        username,
        profile,
        price,
        cost,
        soldBy,
        paymentMethod,
        status,
        customerName,
        customerPhone,
        notes,
        isPrinted,
        soldAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'card_sales';
  @override
  VerificationContext validateIntegrity(Insertable<CardSalesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('connection_id')) {
      context.handle(
          _connectionIdMeta,
          connectionId.isAcceptableOrUnknown(
              data['connection_id']!, _connectionIdMeta));
    } else if (isInserting) {
      context.missing(_connectionIdMeta);
    }
    if (data.containsKey('sale_id')) {
      context.handle(_saleIdMeta,
          saleId.isAcceptableOrUnknown(data['sale_id']!, _saleIdMeta));
    } else if (isInserting) {
      context.missing(_saleIdMeta);
    }
    if (data.containsKey('card_type')) {
      context.handle(_cardTypeMeta,
          cardType.isAcceptableOrUnknown(data['card_type']!, _cardTypeMeta));
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('profile')) {
      context.handle(_profileMeta,
          profile.isAcceptableOrUnknown(data['profile']!, _profileMeta));
    } else if (isInserting) {
      context.missing(_profileMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    }
    if (data.containsKey('cost')) {
      context.handle(
          _costMeta, cost.isAcceptableOrUnknown(data['cost']!, _costMeta));
    }
    if (data.containsKey('sold_by')) {
      context.handle(_soldByMeta,
          soldBy.isAcceptableOrUnknown(data['sold_by']!, _soldByMeta));
    }
    if (data.containsKey('payment_method')) {
      context.handle(
          _paymentMethodMeta,
          paymentMethod.isAcceptableOrUnknown(
              data['payment_method']!, _paymentMethodMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('customer_name')) {
      context.handle(
          _customerNameMeta,
          customerName.isAcceptableOrUnknown(
              data['customer_name']!, _customerNameMeta));
    }
    if (data.containsKey('customer_phone')) {
      context.handle(
          _customerPhoneMeta,
          customerPhone.isAcceptableOrUnknown(
              data['customer_phone']!, _customerPhoneMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('is_printed')) {
      context.handle(_isPrintedMeta,
          isPrinted.isAcceptableOrUnknown(data['is_printed']!, _isPrintedMeta));
    }
    if (data.containsKey('sold_at')) {
      context.handle(_soldAtMeta,
          soldAt.isAcceptableOrUnknown(data['sold_at']!, _soldAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CardSalesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CardSalesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      connectionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}connection_id'])!,
      saleId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sale_id'])!,
      cardType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}card_type'])!,
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
      profile: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      cost: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cost'])!,
      soldBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sold_by'])!,
      paymentMethod: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_method'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      customerName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_name']),
      customerPhone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_phone']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      isPrinted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_printed'])!,
      soldAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}sold_at'])!,
    );
  }

  @override
  $CardSalesTableTable createAlias(String alias) {
    return $CardSalesTableTable(attachedDatabase, alias);
  }
}

class CardSalesTableData extends DataClass
    implements Insertable<CardSalesTableData> {
  final int id;
  final int connectionId;
  final String saleId;
  final String cardType;
  final String username;
  final String profile;
  final double price;
  final double cost;
  final String soldBy;
  final String paymentMethod;
  final String status;
  final String? customerName;
  final String? customerPhone;
  final String? notes;
  final bool isPrinted;
  final DateTime soldAt;
  const CardSalesTableData(
      {required this.id,
      required this.connectionId,
      required this.saleId,
      required this.cardType,
      required this.username,
      required this.profile,
      required this.price,
      required this.cost,
      required this.soldBy,
      required this.paymentMethod,
      required this.status,
      this.customerName,
      this.customerPhone,
      this.notes,
      required this.isPrinted,
      required this.soldAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['connection_id'] = Variable<int>(connectionId);
    map['sale_id'] = Variable<String>(saleId);
    map['card_type'] = Variable<String>(cardType);
    map['username'] = Variable<String>(username);
    map['profile'] = Variable<String>(profile);
    map['price'] = Variable<double>(price);
    map['cost'] = Variable<double>(cost);
    map['sold_by'] = Variable<String>(soldBy);
    map['payment_method'] = Variable<String>(paymentMethod);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || customerName != null) {
      map['customer_name'] = Variable<String>(customerName);
    }
    if (!nullToAbsent || customerPhone != null) {
      map['customer_phone'] = Variable<String>(customerPhone);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_printed'] = Variable<bool>(isPrinted);
    map['sold_at'] = Variable<DateTime>(soldAt);
    return map;
  }

  CardSalesTableCompanion toCompanion(bool nullToAbsent) {
    return CardSalesTableCompanion(
      id: Value(id),
      connectionId: Value(connectionId),
      saleId: Value(saleId),
      cardType: Value(cardType),
      username: Value(username),
      profile: Value(profile),
      price: Value(price),
      cost: Value(cost),
      soldBy: Value(soldBy),
      paymentMethod: Value(paymentMethod),
      status: Value(status),
      customerName: customerName == null && nullToAbsent
          ? const Value.absent()
          : Value(customerName),
      customerPhone: customerPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(customerPhone),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      isPrinted: Value(isPrinted),
      soldAt: Value(soldAt),
    );
  }

  factory CardSalesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CardSalesTableData(
      id: serializer.fromJson<int>(json['id']),
      connectionId: serializer.fromJson<int>(json['connectionId']),
      saleId: serializer.fromJson<String>(json['saleId']),
      cardType: serializer.fromJson<String>(json['cardType']),
      username: serializer.fromJson<String>(json['username']),
      profile: serializer.fromJson<String>(json['profile']),
      price: serializer.fromJson<double>(json['price']),
      cost: serializer.fromJson<double>(json['cost']),
      soldBy: serializer.fromJson<String>(json['soldBy']),
      paymentMethod: serializer.fromJson<String>(json['paymentMethod']),
      status: serializer.fromJson<String>(json['status']),
      customerName: serializer.fromJson<String?>(json['customerName']),
      customerPhone: serializer.fromJson<String?>(json['customerPhone']),
      notes: serializer.fromJson<String?>(json['notes']),
      isPrinted: serializer.fromJson<bool>(json['isPrinted']),
      soldAt: serializer.fromJson<DateTime>(json['soldAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'connectionId': serializer.toJson<int>(connectionId),
      'saleId': serializer.toJson<String>(saleId),
      'cardType': serializer.toJson<String>(cardType),
      'username': serializer.toJson<String>(username),
      'profile': serializer.toJson<String>(profile),
      'price': serializer.toJson<double>(price),
      'cost': serializer.toJson<double>(cost),
      'soldBy': serializer.toJson<String>(soldBy),
      'paymentMethod': serializer.toJson<String>(paymentMethod),
      'status': serializer.toJson<String>(status),
      'customerName': serializer.toJson<String?>(customerName),
      'customerPhone': serializer.toJson<String?>(customerPhone),
      'notes': serializer.toJson<String?>(notes),
      'isPrinted': serializer.toJson<bool>(isPrinted),
      'soldAt': serializer.toJson<DateTime>(soldAt),
    };
  }

  CardSalesTableData copyWith(
          {int? id,
          int? connectionId,
          String? saleId,
          String? cardType,
          String? username,
          String? profile,
          double? price,
          double? cost,
          String? soldBy,
          String? paymentMethod,
          String? status,
          Value<String?> customerName = const Value.absent(),
          Value<String?> customerPhone = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          bool? isPrinted,
          DateTime? soldAt}) =>
      CardSalesTableData(
        id: id ?? this.id,
        connectionId: connectionId ?? this.connectionId,
        saleId: saleId ?? this.saleId,
        cardType: cardType ?? this.cardType,
        username: username ?? this.username,
        profile: profile ?? this.profile,
        price: price ?? this.price,
        cost: cost ?? this.cost,
        soldBy: soldBy ?? this.soldBy,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        status: status ?? this.status,
        customerName:
            customerName.present ? customerName.value : this.customerName,
        customerPhone:
            customerPhone.present ? customerPhone.value : this.customerPhone,
        notes: notes.present ? notes.value : this.notes,
        isPrinted: isPrinted ?? this.isPrinted,
        soldAt: soldAt ?? this.soldAt,
      );
  CardSalesTableData copyWithCompanion(CardSalesTableCompanion data) {
    return CardSalesTableData(
      id: data.id.present ? data.id.value : this.id,
      connectionId: data.connectionId.present
          ? data.connectionId.value
          : this.connectionId,
      saleId: data.saleId.present ? data.saleId.value : this.saleId,
      cardType: data.cardType.present ? data.cardType.value : this.cardType,
      username: data.username.present ? data.username.value : this.username,
      profile: data.profile.present ? data.profile.value : this.profile,
      price: data.price.present ? data.price.value : this.price,
      cost: data.cost.present ? data.cost.value : this.cost,
      soldBy: data.soldBy.present ? data.soldBy.value : this.soldBy,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      status: data.status.present ? data.status.value : this.status,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      customerPhone: data.customerPhone.present
          ? data.customerPhone.value
          : this.customerPhone,
      notes: data.notes.present ? data.notes.value : this.notes,
      isPrinted: data.isPrinted.present ? data.isPrinted.value : this.isPrinted,
      soldAt: data.soldAt.present ? data.soldAt.value : this.soldAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CardSalesTableData(')
          ..write('id: $id, ')
          ..write('connectionId: $connectionId, ')
          ..write('saleId: $saleId, ')
          ..write('cardType: $cardType, ')
          ..write('username: $username, ')
          ..write('profile: $profile, ')
          ..write('price: $price, ')
          ..write('cost: $cost, ')
          ..write('soldBy: $soldBy, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('status: $status, ')
          ..write('customerName: $customerName, ')
          ..write('customerPhone: $customerPhone, ')
          ..write('notes: $notes, ')
          ..write('isPrinted: $isPrinted, ')
          ..write('soldAt: $soldAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      connectionId,
      saleId,
      cardType,
      username,
      profile,
      price,
      cost,
      soldBy,
      paymentMethod,
      status,
      customerName,
      customerPhone,
      notes,
      isPrinted,
      soldAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardSalesTableData &&
          other.id == this.id &&
          other.connectionId == this.connectionId &&
          other.saleId == this.saleId &&
          other.cardType == this.cardType &&
          other.username == this.username &&
          other.profile == this.profile &&
          other.price == this.price &&
          other.cost == this.cost &&
          other.soldBy == this.soldBy &&
          other.paymentMethod == this.paymentMethod &&
          other.status == this.status &&
          other.customerName == this.customerName &&
          other.customerPhone == this.customerPhone &&
          other.notes == this.notes &&
          other.isPrinted == this.isPrinted &&
          other.soldAt == this.soldAt);
}

class CardSalesTableCompanion extends UpdateCompanion<CardSalesTableData> {
  final Value<int> id;
  final Value<int> connectionId;
  final Value<String> saleId;
  final Value<String> cardType;
  final Value<String> username;
  final Value<String> profile;
  final Value<double> price;
  final Value<double> cost;
  final Value<String> soldBy;
  final Value<String> paymentMethod;
  final Value<String> status;
  final Value<String?> customerName;
  final Value<String?> customerPhone;
  final Value<String?> notes;
  final Value<bool> isPrinted;
  final Value<DateTime> soldAt;
  const CardSalesTableCompanion({
    this.id = const Value.absent(),
    this.connectionId = const Value.absent(),
    this.saleId = const Value.absent(),
    this.cardType = const Value.absent(),
    this.username = const Value.absent(),
    this.profile = const Value.absent(),
    this.price = const Value.absent(),
    this.cost = const Value.absent(),
    this.soldBy = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.status = const Value.absent(),
    this.customerName = const Value.absent(),
    this.customerPhone = const Value.absent(),
    this.notes = const Value.absent(),
    this.isPrinted = const Value.absent(),
    this.soldAt = const Value.absent(),
  });
  CardSalesTableCompanion.insert({
    this.id = const Value.absent(),
    required int connectionId,
    required String saleId,
    this.cardType = const Value.absent(),
    required String username,
    required String profile,
    this.price = const Value.absent(),
    this.cost = const Value.absent(),
    this.soldBy = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.status = const Value.absent(),
    this.customerName = const Value.absent(),
    this.customerPhone = const Value.absent(),
    this.notes = const Value.absent(),
    this.isPrinted = const Value.absent(),
    this.soldAt = const Value.absent(),
  })  : connectionId = Value(connectionId),
        saleId = Value(saleId),
        username = Value(username),
        profile = Value(profile);
  static Insertable<CardSalesTableData> custom({
    Expression<int>? id,
    Expression<int>? connectionId,
    Expression<String>? saleId,
    Expression<String>? cardType,
    Expression<String>? username,
    Expression<String>? profile,
    Expression<double>? price,
    Expression<double>? cost,
    Expression<String>? soldBy,
    Expression<String>? paymentMethod,
    Expression<String>? status,
    Expression<String>? customerName,
    Expression<String>? customerPhone,
    Expression<String>? notes,
    Expression<bool>? isPrinted,
    Expression<DateTime>? soldAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (connectionId != null) 'connection_id': connectionId,
      if (saleId != null) 'sale_id': saleId,
      if (cardType != null) 'card_type': cardType,
      if (username != null) 'username': username,
      if (profile != null) 'profile': profile,
      if (price != null) 'price': price,
      if (cost != null) 'cost': cost,
      if (soldBy != null) 'sold_by': soldBy,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (status != null) 'status': status,
      if (customerName != null) 'customer_name': customerName,
      if (customerPhone != null) 'customer_phone': customerPhone,
      if (notes != null) 'notes': notes,
      if (isPrinted != null) 'is_printed': isPrinted,
      if (soldAt != null) 'sold_at': soldAt,
    });
  }

  CardSalesTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? connectionId,
      Value<String>? saleId,
      Value<String>? cardType,
      Value<String>? username,
      Value<String>? profile,
      Value<double>? price,
      Value<double>? cost,
      Value<String>? soldBy,
      Value<String>? paymentMethod,
      Value<String>? status,
      Value<String?>? customerName,
      Value<String?>? customerPhone,
      Value<String?>? notes,
      Value<bool>? isPrinted,
      Value<DateTime>? soldAt}) {
    return CardSalesTableCompanion(
      id: id ?? this.id,
      connectionId: connectionId ?? this.connectionId,
      saleId: saleId ?? this.saleId,
      cardType: cardType ?? this.cardType,
      username: username ?? this.username,
      profile: profile ?? this.profile,
      price: price ?? this.price,
      cost: cost ?? this.cost,
      soldBy: soldBy ?? this.soldBy,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      notes: notes ?? this.notes,
      isPrinted: isPrinted ?? this.isPrinted,
      soldAt: soldAt ?? this.soldAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (connectionId.present) {
      map['connection_id'] = Variable<int>(connectionId.value);
    }
    if (saleId.present) {
      map['sale_id'] = Variable<String>(saleId.value);
    }
    if (cardType.present) {
      map['card_type'] = Variable<String>(cardType.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (profile.present) {
      map['profile'] = Variable<String>(profile.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (cost.present) {
      map['cost'] = Variable<double>(cost.value);
    }
    if (soldBy.present) {
      map['sold_by'] = Variable<String>(soldBy.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (customerPhone.present) {
      map['customer_phone'] = Variable<String>(customerPhone.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isPrinted.present) {
      map['is_printed'] = Variable<bool>(isPrinted.value);
    }
    if (soldAt.present) {
      map['sold_at'] = Variable<DateTime>(soldAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardSalesTableCompanion(')
          ..write('id: $id, ')
          ..write('connectionId: $connectionId, ')
          ..write('saleId: $saleId, ')
          ..write('cardType: $cardType, ')
          ..write('username: $username, ')
          ..write('profile: $profile, ')
          ..write('price: $price, ')
          ..write('cost: $cost, ')
          ..write('soldBy: $soldBy, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('status: $status, ')
          ..write('customerName: $customerName, ')
          ..write('customerPhone: $customerPhone, ')
          ..write('notes: $notes, ')
          ..write('isPrinted: $isPrinted, ')
          ..write('soldAt: $soldAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RoutersTableTable routersTable = $RoutersTableTable(this);
  late final $VoucherBatchesTableTable voucherBatchesTable =
      $VoucherBatchesTableTable(this);
  late final $VoucherTemplatesTableTable voucherTemplatesTable =
      $VoucherTemplatesTableTable(this);
  late final $SalesReportsTableTable salesReportsTable =
      $SalesReportsTableTable(this);
  late final $AuditLogsTableTable auditLogsTable = $AuditLogsTableTable(this);
  late final $ProfilePricesTableTable profilePricesTable =
      $ProfilePricesTableTable(this);
  late final $UsageObservationsTableTable usageObservationsTable =
      $UsageObservationsTableTable(this);
  late final $CardEventsTableTable cardEventsTable =
      $CardEventsTableTable(this);
  late final $PaymentsTableTable paymentsTable = $PaymentsTableTable(this);
  late final $PdfArchiveTableTable pdfArchiveTable =
      $PdfArchiveTableTable(this);
  late final $ApDevicesTableTable apDevicesTable = $ApDevicesTableTable(this);
  late final $UserApMatchesTableTable userApMatchesTable =
      $UserApMatchesTableTable(this);
  late final $TopologySnapshotsTableTable topologySnapshotsTable =
      $TopologySnapshotsTableTable(this);
  late final $AlertRulesTableTable alertRulesTable =
      $AlertRulesTableTable(this);
  late final $AlertEventsTableTable alertEventsTable =
      $AlertEventsTableTable(this);
  late final $QuietHoursTableTable quietHoursTable =
      $QuietHoursTableTable(this);
  late final $TrustedDhcpServersTableTable trustedDhcpServersTable =
      $TrustedDhcpServersTableTable(this);
  late final $InterfaceDailyTableTable interfaceDailyTable =
      $InterfaceDailyTableTable(this);
  late final $BackupLogTableTable backupLogTable = $BackupLogTableTable(this);
  late final $TaskCheckpointsTableTable taskCheckpointsTable =
      $TaskCheckpointsTableTable(this);
  late final $UmProfilesCacheTableTable umProfilesCacheTable =
      $UmProfilesCacheTableTable(this);
  late final $UmDiagnosticsLogTableTable umDiagnosticsLogTable =
      $UmDiagnosticsLogTableTable(this);
  late final $ResellersTableTable resellersTable = $ResellersTableTable(this);
  late final $ResellerAllocationsTableTable resellerAllocationsTable =
      $ResellerAllocationsTableTable(this);
  late final $ResellerSettlementsTableTable resellerSettlementsTable =
      $ResellerSettlementsTableTable(this);
  late final $CardSalesTableTable cardSalesTable = $CardSalesTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        routersTable,
        voucherBatchesTable,
        voucherTemplatesTable,
        salesReportsTable,
        auditLogsTable,
        profilePricesTable,
        usageObservationsTable,
        cardEventsTable,
        paymentsTable,
        pdfArchiveTable,
        apDevicesTable,
        userApMatchesTable,
        topologySnapshotsTable,
        alertRulesTable,
        alertEventsTable,
        quietHoursTable,
        trustedDhcpServersTable,
        interfaceDailyTable,
        backupLogTable,
        taskCheckpointsTable,
        umProfilesCacheTable,
        umDiagnosticsLogTable,
        resellersTable,
        resellerAllocationsTable,
        resellerSettlementsTable,
        cardSalesTable
      ];
}

typedef $$RoutersTableTableCreateCompanionBuilder = RoutersTableCompanion
    Function({
  Value<int> id,
  required String name,
  required String ipAddress,
  Value<int> apiPort,
  Value<String> username,
  Value<bool> useSsl,
  Value<bool> useRestApi,
  Value<String?> routerOsVersion,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<DateTime?> lastConnectedAt,
  Value<String?> notes,
});
typedef $$RoutersTableTableUpdateCompanionBuilder = RoutersTableCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<String> ipAddress,
  Value<int> apiPort,
  Value<String> username,
  Value<bool> useSsl,
  Value<bool> useRestApi,
  Value<String?> routerOsVersion,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<DateTime?> lastConnectedAt,
  Value<String?> notes,
});

class $$RoutersTableTableFilterComposer
    extends Composer<_$AppDatabase, $RoutersTableTable> {
  $$RoutersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ipAddress => $composableBuilder(
      column: $table.ipAddress, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get apiPort => $composableBuilder(
      column: $table.apiPort, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get useSsl => $composableBuilder(
      column: $table.useSsl, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get useRestApi => $composableBuilder(
      column: $table.useRestApi, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get routerOsVersion => $composableBuilder(
      column: $table.routerOsVersion,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastConnectedAt => $composableBuilder(
      column: $table.lastConnectedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));
}

class $$RoutersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutersTableTable> {
  $$RoutersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ipAddress => $composableBuilder(
      column: $table.ipAddress, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get apiPort => $composableBuilder(
      column: $table.apiPort, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get useSsl => $composableBuilder(
      column: $table.useSsl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get useRestApi => $composableBuilder(
      column: $table.useRestApi, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get routerOsVersion => $composableBuilder(
      column: $table.routerOsVersion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastConnectedAt => $composableBuilder(
      column: $table.lastConnectedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));
}

class $$RoutersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutersTableTable> {
  $$RoutersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get ipAddress =>
      $composableBuilder(column: $table.ipAddress, builder: (column) => column);

  GeneratedColumn<int> get apiPort =>
      $composableBuilder(column: $table.apiPort, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<bool> get useSsl =>
      $composableBuilder(column: $table.useSsl, builder: (column) => column);

  GeneratedColumn<bool> get useRestApi => $composableBuilder(
      column: $table.useRestApi, builder: (column) => column);

  GeneratedColumn<String> get routerOsVersion => $composableBuilder(
      column: $table.routerOsVersion, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastConnectedAt => $composableBuilder(
      column: $table.lastConnectedAt, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$RoutersTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RoutersTableTable,
    RoutersTableData,
    $$RoutersTableTableFilterComposer,
    $$RoutersTableTableOrderingComposer,
    $$RoutersTableTableAnnotationComposer,
    $$RoutersTableTableCreateCompanionBuilder,
    $$RoutersTableTableUpdateCompanionBuilder,
    (
      RoutersTableData,
      BaseReferences<_$AppDatabase, $RoutersTableTable, RoutersTableData>
    ),
    RoutersTableData,
    PrefetchHooks Function()> {
  $$RoutersTableTableTableManager(_$AppDatabase db, $RoutersTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> ipAddress = const Value.absent(),
            Value<int> apiPort = const Value.absent(),
            Value<String> username = const Value.absent(),
            Value<bool> useSsl = const Value.absent(),
            Value<bool> useRestApi = const Value.absent(),
            Value<String?> routerOsVersion = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> lastConnectedAt = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              RoutersTableCompanion(
            id: id,
            name: name,
            ipAddress: ipAddress,
            apiPort: apiPort,
            username: username,
            useSsl: useSsl,
            useRestApi: useRestApi,
            routerOsVersion: routerOsVersion,
            isActive: isActive,
            createdAt: createdAt,
            lastConnectedAt: lastConnectedAt,
            notes: notes,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String ipAddress,
            Value<int> apiPort = const Value.absent(),
            Value<String> username = const Value.absent(),
            Value<bool> useSsl = const Value.absent(),
            Value<bool> useRestApi = const Value.absent(),
            Value<String?> routerOsVersion = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> lastConnectedAt = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              RoutersTableCompanion.insert(
            id: id,
            name: name,
            ipAddress: ipAddress,
            apiPort: apiPort,
            username: username,
            useSsl: useSsl,
            useRestApi: useRestApi,
            routerOsVersion: routerOsVersion,
            isActive: isActive,
            createdAt: createdAt,
            lastConnectedAt: lastConnectedAt,
            notes: notes,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$RoutersTableTable, RoutersTableData>(table),
                    BaseReferences<_$AppDatabase, $RoutersTableTable,
                        RoutersTableData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RoutersTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RoutersTableTable,
    RoutersTableData,
    $$RoutersTableTableFilterComposer,
    $$RoutersTableTableOrderingComposer,
    $$RoutersTableTableAnnotationComposer,
    $$RoutersTableTableCreateCompanionBuilder,
    $$RoutersTableTableUpdateCompanionBuilder,
    (
      RoutersTableData,
      BaseReferences<_$AppDatabase, $RoutersTableTable, RoutersTableData>
    ),
    RoutersTableData,
    PrefetchHooks Function()>;
typedef $$VoucherBatchesTableTableCreateCompanionBuilder
    = VoucherBatchesTableCompanion Function({
  Value<int> id,
  required int routerId,
  required String profileName,
  required int quantity,
  Value<String> prefix,
  Value<int> codeLength,
  required String vouchersJson,
  Value<double> unitPrice,
  Value<double> totalAmount,
  Value<String> status,
  Value<String?> notes,
  Value<String> systemType,
  Value<String?> serialPrefix,
  Value<int?> serialStart,
  Value<int?> serialPadding,
  Value<int?> serialEnd,
  Value<DateTime> generatedAt,
  Value<DateTime?> printedAt,
});
typedef $$VoucherBatchesTableTableUpdateCompanionBuilder
    = VoucherBatchesTableCompanion Function({
  Value<int> id,
  Value<int> routerId,
  Value<String> profileName,
  Value<int> quantity,
  Value<String> prefix,
  Value<int> codeLength,
  Value<String> vouchersJson,
  Value<double> unitPrice,
  Value<double> totalAmount,
  Value<String> status,
  Value<String?> notes,
  Value<String> systemType,
  Value<String?> serialPrefix,
  Value<int?> serialStart,
  Value<int?> serialPadding,
  Value<int?> serialEnd,
  Value<DateTime> generatedAt,
  Value<DateTime?> printedAt,
});

class $$VoucherBatchesTableTableFilterComposer
    extends Composer<_$AppDatabase, $VoucherBatchesTableTable> {
  $$VoucherBatchesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get routerId => $composableBuilder(
      column: $table.routerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profileName => $composableBuilder(
      column: $table.profileName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get prefix => $composableBuilder(
      column: $table.prefix, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get codeLength => $composableBuilder(
      column: $table.codeLength, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get vouchersJson => $composableBuilder(
      column: $table.vouchersJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get unitPrice => $composableBuilder(
      column: $table.unitPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get systemType => $composableBuilder(
      column: $table.systemType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get serialPrefix => $composableBuilder(
      column: $table.serialPrefix, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get serialStart => $composableBuilder(
      column: $table.serialStart, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get serialPadding => $composableBuilder(
      column: $table.serialPadding, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get serialEnd => $composableBuilder(
      column: $table.serialEnd, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get generatedAt => $composableBuilder(
      column: $table.generatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get printedAt => $composableBuilder(
      column: $table.printedAt, builder: (column) => ColumnFilters(column));
}

class $$VoucherBatchesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $VoucherBatchesTableTable> {
  $$VoucherBatchesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get routerId => $composableBuilder(
      column: $table.routerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profileName => $composableBuilder(
      column: $table.profileName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get prefix => $composableBuilder(
      column: $table.prefix, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get codeLength => $composableBuilder(
      column: $table.codeLength, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get vouchersJson => $composableBuilder(
      column: $table.vouchersJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get unitPrice => $composableBuilder(
      column: $table.unitPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get systemType => $composableBuilder(
      column: $table.systemType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get serialPrefix => $composableBuilder(
      column: $table.serialPrefix,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get serialStart => $composableBuilder(
      column: $table.serialStart, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get serialPadding => $composableBuilder(
      column: $table.serialPadding,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get serialEnd => $composableBuilder(
      column: $table.serialEnd, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get generatedAt => $composableBuilder(
      column: $table.generatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get printedAt => $composableBuilder(
      column: $table.printedAt, builder: (column) => ColumnOrderings(column));
}

class $$VoucherBatchesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $VoucherBatchesTableTable> {
  $$VoucherBatchesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get routerId =>
      $composableBuilder(column: $table.routerId, builder: (column) => column);

  GeneratedColumn<String> get profileName => $composableBuilder(
      column: $table.profileName, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get prefix =>
      $composableBuilder(column: $table.prefix, builder: (column) => column);

  GeneratedColumn<int> get codeLength => $composableBuilder(
      column: $table.codeLength, builder: (column) => column);

  GeneratedColumn<String> get vouchersJson => $composableBuilder(
      column: $table.vouchersJson, builder: (column) => column);

  GeneratedColumn<double> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

  GeneratedColumn<double> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get systemType => $composableBuilder(
      column: $table.systemType, builder: (column) => column);

  GeneratedColumn<String> get serialPrefix => $composableBuilder(
      column: $table.serialPrefix, builder: (column) => column);

  GeneratedColumn<int> get serialStart => $composableBuilder(
      column: $table.serialStart, builder: (column) => column);

  GeneratedColumn<int> get serialPadding => $composableBuilder(
      column: $table.serialPadding, builder: (column) => column);

  GeneratedColumn<int> get serialEnd =>
      $composableBuilder(column: $table.serialEnd, builder: (column) => column);

  GeneratedColumn<DateTime> get generatedAt => $composableBuilder(
      column: $table.generatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get printedAt =>
      $composableBuilder(column: $table.printedAt, builder: (column) => column);
}

class $$VoucherBatchesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $VoucherBatchesTableTable,
    VoucherBatchesTableData,
    $$VoucherBatchesTableTableFilterComposer,
    $$VoucherBatchesTableTableOrderingComposer,
    $$VoucherBatchesTableTableAnnotationComposer,
    $$VoucherBatchesTableTableCreateCompanionBuilder,
    $$VoucherBatchesTableTableUpdateCompanionBuilder,
    (
      VoucherBatchesTableData,
      BaseReferences<_$AppDatabase, $VoucherBatchesTableTable,
          VoucherBatchesTableData>
    ),
    VoucherBatchesTableData,
    PrefetchHooks Function()> {
  $$VoucherBatchesTableTableTableManager(
      _$AppDatabase db, $VoucherBatchesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VoucherBatchesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VoucherBatchesTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VoucherBatchesTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> routerId = const Value.absent(),
            Value<String> profileName = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<String> prefix = const Value.absent(),
            Value<int> codeLength = const Value.absent(),
            Value<String> vouchersJson = const Value.absent(),
            Value<double> unitPrice = const Value.absent(),
            Value<double> totalAmount = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String> systemType = const Value.absent(),
            Value<String?> serialPrefix = const Value.absent(),
            Value<int?> serialStart = const Value.absent(),
            Value<int?> serialPadding = const Value.absent(),
            Value<int?> serialEnd = const Value.absent(),
            Value<DateTime> generatedAt = const Value.absent(),
            Value<DateTime?> printedAt = const Value.absent(),
          }) =>
              VoucherBatchesTableCompanion(
            id: id,
            routerId: routerId,
            profileName: profileName,
            quantity: quantity,
            prefix: prefix,
            codeLength: codeLength,
            vouchersJson: vouchersJson,
            unitPrice: unitPrice,
            totalAmount: totalAmount,
            status: status,
            notes: notes,
            systemType: systemType,
            serialPrefix: serialPrefix,
            serialStart: serialStart,
            serialPadding: serialPadding,
            serialEnd: serialEnd,
            generatedAt: generatedAt,
            printedAt: printedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int routerId,
            required String profileName,
            required int quantity,
            Value<String> prefix = const Value.absent(),
            Value<int> codeLength = const Value.absent(),
            required String vouchersJson,
            Value<double> unitPrice = const Value.absent(),
            Value<double> totalAmount = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String> systemType = const Value.absent(),
            Value<String?> serialPrefix = const Value.absent(),
            Value<int?> serialStart = const Value.absent(),
            Value<int?> serialPadding = const Value.absent(),
            Value<int?> serialEnd = const Value.absent(),
            Value<DateTime> generatedAt = const Value.absent(),
            Value<DateTime?> printedAt = const Value.absent(),
          }) =>
              VoucherBatchesTableCompanion.insert(
            id: id,
            routerId: routerId,
            profileName: profileName,
            quantity: quantity,
            prefix: prefix,
            codeLength: codeLength,
            vouchersJson: vouchersJson,
            unitPrice: unitPrice,
            totalAmount: totalAmount,
            status: status,
            notes: notes,
            systemType: systemType,
            serialPrefix: serialPrefix,
            serialStart: serialStart,
            serialPadding: serialPadding,
            serialEnd: serialEnd,
            generatedAt: generatedAt,
            printedAt: printedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$VoucherBatchesTableTable,
                        VoucherBatchesTableData>(table),
                    BaseReferences<_$AppDatabase, $VoucherBatchesTableTable,
                        VoucherBatchesTableData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$VoucherBatchesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $VoucherBatchesTableTable,
    VoucherBatchesTableData,
    $$VoucherBatchesTableTableFilterComposer,
    $$VoucherBatchesTableTableOrderingComposer,
    $$VoucherBatchesTableTableAnnotationComposer,
    $$VoucherBatchesTableTableCreateCompanionBuilder,
    $$VoucherBatchesTableTableUpdateCompanionBuilder,
    (
      VoucherBatchesTableData,
      BaseReferences<_$AppDatabase, $VoucherBatchesTableTable,
          VoucherBatchesTableData>
    ),
    VoucherBatchesTableData,
    PrefetchHooks Function()>;
typedef $$VoucherTemplatesTableTableCreateCompanionBuilder
    = VoucherTemplatesTableCompanion Function({
  Value<int> id,
  required String name,
  Value<String> paperSize,
  Value<int> cardsPerRow,
  Value<int> cardsPerPage,
  Value<double?> cardWidthMm,
  Value<double?> cardHeightMm,
  Value<double> marginMm,
  Value<double> fontSize,
  Value<double> titleFontSize,
  Value<int> primaryColorHex,
  Value<int> backgroundColorHex,
  Value<int> textColorHex,
  Value<int> titleColorHex,
  Value<int> borderColorHex,
  Value<double> borderWidth,
  Value<double> borderRadius,
  Value<bool> showQrCode,
  Value<bool> showBarcode,
  Value<bool> showLogo,
  Value<String?> logoPath,
  Value<String?> headerText,
  Value<String?> footerText,
  Value<String> fontFamily,
  Value<bool> showProfile,
  Value<bool> showPrice,
  Value<bool> showValidity,
  Value<bool> showUsername,
  Value<bool> showPassword,
  Value<bool> showInstructions,
  Value<String?> instructionsText,
  Value<String?> contactPhone,
  Value<String?> customText,
  Value<String> targetCardType,
  Value<String?> configJson,
  Value<bool> isDefault,
  Value<DateTime> createdAt,
});
typedef $$VoucherTemplatesTableTableUpdateCompanionBuilder
    = VoucherTemplatesTableCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> paperSize,
  Value<int> cardsPerRow,
  Value<int> cardsPerPage,
  Value<double?> cardWidthMm,
  Value<double?> cardHeightMm,
  Value<double> marginMm,
  Value<double> fontSize,
  Value<double> titleFontSize,
  Value<int> primaryColorHex,
  Value<int> backgroundColorHex,
  Value<int> textColorHex,
  Value<int> titleColorHex,
  Value<int> borderColorHex,
  Value<double> borderWidth,
  Value<double> borderRadius,
  Value<bool> showQrCode,
  Value<bool> showBarcode,
  Value<bool> showLogo,
  Value<String?> logoPath,
  Value<String?> headerText,
  Value<String?> footerText,
  Value<String> fontFamily,
  Value<bool> showProfile,
  Value<bool> showPrice,
  Value<bool> showValidity,
  Value<bool> showUsername,
  Value<bool> showPassword,
  Value<bool> showInstructions,
  Value<String?> instructionsText,
  Value<String?> contactPhone,
  Value<String?> customText,
  Value<String> targetCardType,
  Value<String?> configJson,
  Value<bool> isDefault,
  Value<DateTime> createdAt,
});

class $$VoucherTemplatesTableTableFilterComposer
    extends Composer<_$AppDatabase, $VoucherTemplatesTableTable> {
  $$VoucherTemplatesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paperSize => $composableBuilder(
      column: $table.paperSize, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cardsPerRow => $composableBuilder(
      column: $table.cardsPerRow, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cardsPerPage => $composableBuilder(
      column: $table.cardsPerPage, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get cardWidthMm => $composableBuilder(
      column: $table.cardWidthMm, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get cardHeightMm => $composableBuilder(
      column: $table.cardHeightMm, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get marginMm => $composableBuilder(
      column: $table.marginMm, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get fontSize => $composableBuilder(
      column: $table.fontSize, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get titleFontSize => $composableBuilder(
      column: $table.titleFontSize, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get primaryColorHex => $composableBuilder(
      column: $table.primaryColorHex,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get backgroundColorHex => $composableBuilder(
      column: $table.backgroundColorHex,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get textColorHex => $composableBuilder(
      column: $table.textColorHex, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get titleColorHex => $composableBuilder(
      column: $table.titleColorHex, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get borderColorHex => $composableBuilder(
      column: $table.borderColorHex,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get borderWidth => $composableBuilder(
      column: $table.borderWidth, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get borderRadius => $composableBuilder(
      column: $table.borderRadius, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get showQrCode => $composableBuilder(
      column: $table.showQrCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get showBarcode => $composableBuilder(
      column: $table.showBarcode, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get showLogo => $composableBuilder(
      column: $table.showLogo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get logoPath => $composableBuilder(
      column: $table.logoPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get headerText => $composableBuilder(
      column: $table.headerText, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get footerText => $composableBuilder(
      column: $table.footerText, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fontFamily => $composableBuilder(
      column: $table.fontFamily, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get showProfile => $composableBuilder(
      column: $table.showProfile, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get showPrice => $composableBuilder(
      column: $table.showPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get showValidity => $composableBuilder(
      column: $table.showValidity, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get showUsername => $composableBuilder(
      column: $table.showUsername, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get showPassword => $composableBuilder(
      column: $table.showPassword, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get showInstructions => $composableBuilder(
      column: $table.showInstructions,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get instructionsText => $composableBuilder(
      column: $table.instructionsText,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contactPhone => $composableBuilder(
      column: $table.contactPhone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customText => $composableBuilder(
      column: $table.customText, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get targetCardType => $composableBuilder(
      column: $table.targetCardType,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get configJson => $composableBuilder(
      column: $table.configJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$VoucherTemplatesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $VoucherTemplatesTableTable> {
  $$VoucherTemplatesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paperSize => $composableBuilder(
      column: $table.paperSize, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cardsPerRow => $composableBuilder(
      column: $table.cardsPerRow, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cardsPerPage => $composableBuilder(
      column: $table.cardsPerPage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get cardWidthMm => $composableBuilder(
      column: $table.cardWidthMm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get cardHeightMm => $composableBuilder(
      column: $table.cardHeightMm,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get marginMm => $composableBuilder(
      column: $table.marginMm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get fontSize => $composableBuilder(
      column: $table.fontSize, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get titleFontSize => $composableBuilder(
      column: $table.titleFontSize,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get primaryColorHex => $composableBuilder(
      column: $table.primaryColorHex,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get backgroundColorHex => $composableBuilder(
      column: $table.backgroundColorHex,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get textColorHex => $composableBuilder(
      column: $table.textColorHex,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get titleColorHex => $composableBuilder(
      column: $table.titleColorHex,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get borderColorHex => $composableBuilder(
      column: $table.borderColorHex,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get borderWidth => $composableBuilder(
      column: $table.borderWidth, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get borderRadius => $composableBuilder(
      column: $table.borderRadius,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get showQrCode => $composableBuilder(
      column: $table.showQrCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get showBarcode => $composableBuilder(
      column: $table.showBarcode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get showLogo => $composableBuilder(
      column: $table.showLogo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get logoPath => $composableBuilder(
      column: $table.logoPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get headerText => $composableBuilder(
      column: $table.headerText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get footerText => $composableBuilder(
      column: $table.footerText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fontFamily => $composableBuilder(
      column: $table.fontFamily, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get showProfile => $composableBuilder(
      column: $table.showProfile, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get showPrice => $composableBuilder(
      column: $table.showPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get showValidity => $composableBuilder(
      column: $table.showValidity,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get showUsername => $composableBuilder(
      column: $table.showUsername,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get showPassword => $composableBuilder(
      column: $table.showPassword,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get showInstructions => $composableBuilder(
      column: $table.showInstructions,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get instructionsText => $composableBuilder(
      column: $table.instructionsText,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contactPhone => $composableBuilder(
      column: $table.contactPhone,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customText => $composableBuilder(
      column: $table.customText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get targetCardType => $composableBuilder(
      column: $table.targetCardType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get configJson => $composableBuilder(
      column: $table.configJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$VoucherTemplatesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $VoucherTemplatesTableTable> {
  $$VoucherTemplatesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get paperSize =>
      $composableBuilder(column: $table.paperSize, builder: (column) => column);

  GeneratedColumn<int> get cardsPerRow => $composableBuilder(
      column: $table.cardsPerRow, builder: (column) => column);

  GeneratedColumn<int> get cardsPerPage => $composableBuilder(
      column: $table.cardsPerPage, builder: (column) => column);

  GeneratedColumn<double> get cardWidthMm => $composableBuilder(
      column: $table.cardWidthMm, builder: (column) => column);

  GeneratedColumn<double> get cardHeightMm => $composableBuilder(
      column: $table.cardHeightMm, builder: (column) => column);

  GeneratedColumn<double> get marginMm =>
      $composableBuilder(column: $table.marginMm, builder: (column) => column);

  GeneratedColumn<double> get fontSize =>
      $composableBuilder(column: $table.fontSize, builder: (column) => column);

  GeneratedColumn<double> get titleFontSize => $composableBuilder(
      column: $table.titleFontSize, builder: (column) => column);

  GeneratedColumn<int> get primaryColorHex => $composableBuilder(
      column: $table.primaryColorHex, builder: (column) => column);

  GeneratedColumn<int> get backgroundColorHex => $composableBuilder(
      column: $table.backgroundColorHex, builder: (column) => column);

  GeneratedColumn<int> get textColorHex => $composableBuilder(
      column: $table.textColorHex, builder: (column) => column);

  GeneratedColumn<int> get titleColorHex => $composableBuilder(
      column: $table.titleColorHex, builder: (column) => column);

  GeneratedColumn<int> get borderColorHex => $composableBuilder(
      column: $table.borderColorHex, builder: (column) => column);

  GeneratedColumn<double> get borderWidth => $composableBuilder(
      column: $table.borderWidth, builder: (column) => column);

  GeneratedColumn<double> get borderRadius => $composableBuilder(
      column: $table.borderRadius, builder: (column) => column);

  GeneratedColumn<bool> get showQrCode => $composableBuilder(
      column: $table.showQrCode, builder: (column) => column);

  GeneratedColumn<bool> get showBarcode => $composableBuilder(
      column: $table.showBarcode, builder: (column) => column);

  GeneratedColumn<bool> get showLogo =>
      $composableBuilder(column: $table.showLogo, builder: (column) => column);

  GeneratedColumn<String> get logoPath =>
      $composableBuilder(column: $table.logoPath, builder: (column) => column);

  GeneratedColumn<String> get headerText => $composableBuilder(
      column: $table.headerText, builder: (column) => column);

  GeneratedColumn<String> get footerText => $composableBuilder(
      column: $table.footerText, builder: (column) => column);

  GeneratedColumn<String> get fontFamily => $composableBuilder(
      column: $table.fontFamily, builder: (column) => column);

  GeneratedColumn<bool> get showProfile => $composableBuilder(
      column: $table.showProfile, builder: (column) => column);

  GeneratedColumn<bool> get showPrice =>
      $composableBuilder(column: $table.showPrice, builder: (column) => column);

  GeneratedColumn<bool> get showValidity => $composableBuilder(
      column: $table.showValidity, builder: (column) => column);

  GeneratedColumn<bool> get showUsername => $composableBuilder(
      column: $table.showUsername, builder: (column) => column);

  GeneratedColumn<bool> get showPassword => $composableBuilder(
      column: $table.showPassword, builder: (column) => column);

  GeneratedColumn<bool> get showInstructions => $composableBuilder(
      column: $table.showInstructions, builder: (column) => column);

  GeneratedColumn<String> get instructionsText => $composableBuilder(
      column: $table.instructionsText, builder: (column) => column);

  GeneratedColumn<String> get contactPhone => $composableBuilder(
      column: $table.contactPhone, builder: (column) => column);

  GeneratedColumn<String> get customText => $composableBuilder(
      column: $table.customText, builder: (column) => column);

  GeneratedColumn<String> get targetCardType => $composableBuilder(
      column: $table.targetCardType, builder: (column) => column);

  GeneratedColumn<String> get configJson => $composableBuilder(
      column: $table.configJson, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$VoucherTemplatesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $VoucherTemplatesTableTable,
    VoucherTemplatesTableData,
    $$VoucherTemplatesTableTableFilterComposer,
    $$VoucherTemplatesTableTableOrderingComposer,
    $$VoucherTemplatesTableTableAnnotationComposer,
    $$VoucherTemplatesTableTableCreateCompanionBuilder,
    $$VoucherTemplatesTableTableUpdateCompanionBuilder,
    (
      VoucherTemplatesTableData,
      BaseReferences<_$AppDatabase, $VoucherTemplatesTableTable,
          VoucherTemplatesTableData>
    ),
    VoucherTemplatesTableData,
    PrefetchHooks Function()> {
  $$VoucherTemplatesTableTableTableManager(
      _$AppDatabase db, $VoucherTemplatesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VoucherTemplatesTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$VoucherTemplatesTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VoucherTemplatesTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> paperSize = const Value.absent(),
            Value<int> cardsPerRow = const Value.absent(),
            Value<int> cardsPerPage = const Value.absent(),
            Value<double?> cardWidthMm = const Value.absent(),
            Value<double?> cardHeightMm = const Value.absent(),
            Value<double> marginMm = const Value.absent(),
            Value<double> fontSize = const Value.absent(),
            Value<double> titleFontSize = const Value.absent(),
            Value<int> primaryColorHex = const Value.absent(),
            Value<int> backgroundColorHex = const Value.absent(),
            Value<int> textColorHex = const Value.absent(),
            Value<int> titleColorHex = const Value.absent(),
            Value<int> borderColorHex = const Value.absent(),
            Value<double> borderWidth = const Value.absent(),
            Value<double> borderRadius = const Value.absent(),
            Value<bool> showQrCode = const Value.absent(),
            Value<bool> showBarcode = const Value.absent(),
            Value<bool> showLogo = const Value.absent(),
            Value<String?> logoPath = const Value.absent(),
            Value<String?> headerText = const Value.absent(),
            Value<String?> footerText = const Value.absent(),
            Value<String> fontFamily = const Value.absent(),
            Value<bool> showProfile = const Value.absent(),
            Value<bool> showPrice = const Value.absent(),
            Value<bool> showValidity = const Value.absent(),
            Value<bool> showUsername = const Value.absent(),
            Value<bool> showPassword = const Value.absent(),
            Value<bool> showInstructions = const Value.absent(),
            Value<String?> instructionsText = const Value.absent(),
            Value<String?> contactPhone = const Value.absent(),
            Value<String?> customText = const Value.absent(),
            Value<String> targetCardType = const Value.absent(),
            Value<String?> configJson = const Value.absent(),
            Value<bool> isDefault = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              VoucherTemplatesTableCompanion(
            id: id,
            name: name,
            paperSize: paperSize,
            cardsPerRow: cardsPerRow,
            cardsPerPage: cardsPerPage,
            cardWidthMm: cardWidthMm,
            cardHeightMm: cardHeightMm,
            marginMm: marginMm,
            fontSize: fontSize,
            titleFontSize: titleFontSize,
            primaryColorHex: primaryColorHex,
            backgroundColorHex: backgroundColorHex,
            textColorHex: textColorHex,
            titleColorHex: titleColorHex,
            borderColorHex: borderColorHex,
            borderWidth: borderWidth,
            borderRadius: borderRadius,
            showQrCode: showQrCode,
            showBarcode: showBarcode,
            showLogo: showLogo,
            logoPath: logoPath,
            headerText: headerText,
            footerText: footerText,
            fontFamily: fontFamily,
            showProfile: showProfile,
            showPrice: showPrice,
            showValidity: showValidity,
            showUsername: showUsername,
            showPassword: showPassword,
            showInstructions: showInstructions,
            instructionsText: instructionsText,
            contactPhone: contactPhone,
            customText: customText,
            targetCardType: targetCardType,
            configJson: configJson,
            isDefault: isDefault,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String> paperSize = const Value.absent(),
            Value<int> cardsPerRow = const Value.absent(),
            Value<int> cardsPerPage = const Value.absent(),
            Value<double?> cardWidthMm = const Value.absent(),
            Value<double?> cardHeightMm = const Value.absent(),
            Value<double> marginMm = const Value.absent(),
            Value<double> fontSize = const Value.absent(),
            Value<double> titleFontSize = const Value.absent(),
            Value<int> primaryColorHex = const Value.absent(),
            Value<int> backgroundColorHex = const Value.absent(),
            Value<int> textColorHex = const Value.absent(),
            Value<int> titleColorHex = const Value.absent(),
            Value<int> borderColorHex = const Value.absent(),
            Value<double> borderWidth = const Value.absent(),
            Value<double> borderRadius = const Value.absent(),
            Value<bool> showQrCode = const Value.absent(),
            Value<bool> showBarcode = const Value.absent(),
            Value<bool> showLogo = const Value.absent(),
            Value<String?> logoPath = const Value.absent(),
            Value<String?> headerText = const Value.absent(),
            Value<String?> footerText = const Value.absent(),
            Value<String> fontFamily = const Value.absent(),
            Value<bool> showProfile = const Value.absent(),
            Value<bool> showPrice = const Value.absent(),
            Value<bool> showValidity = const Value.absent(),
            Value<bool> showUsername = const Value.absent(),
            Value<bool> showPassword = const Value.absent(),
            Value<bool> showInstructions = const Value.absent(),
            Value<String?> instructionsText = const Value.absent(),
            Value<String?> contactPhone = const Value.absent(),
            Value<String?> customText = const Value.absent(),
            Value<String> targetCardType = const Value.absent(),
            Value<String?> configJson = const Value.absent(),
            Value<bool> isDefault = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              VoucherTemplatesTableCompanion.insert(
            id: id,
            name: name,
            paperSize: paperSize,
            cardsPerRow: cardsPerRow,
            cardsPerPage: cardsPerPage,
            cardWidthMm: cardWidthMm,
            cardHeightMm: cardHeightMm,
            marginMm: marginMm,
            fontSize: fontSize,
            titleFontSize: titleFontSize,
            primaryColorHex: primaryColorHex,
            backgroundColorHex: backgroundColorHex,
            textColorHex: textColorHex,
            titleColorHex: titleColorHex,
            borderColorHex: borderColorHex,
            borderWidth: borderWidth,
            borderRadius: borderRadius,
            showQrCode: showQrCode,
            showBarcode: showBarcode,
            showLogo: showLogo,
            logoPath: logoPath,
            headerText: headerText,
            footerText: footerText,
            fontFamily: fontFamily,
            showProfile: showProfile,
            showPrice: showPrice,
            showValidity: showValidity,
            showUsername: showUsername,
            showPassword: showPassword,
            showInstructions: showInstructions,
            instructionsText: instructionsText,
            contactPhone: contactPhone,
            customText: customText,
            targetCardType: targetCardType,
            configJson: configJson,
            isDefault: isDefault,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$VoucherTemplatesTableTable,
                        VoucherTemplatesTableData>(table),
                    BaseReferences<_$AppDatabase, $VoucherTemplatesTableTable,
                        VoucherTemplatesTableData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$VoucherTemplatesTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $VoucherTemplatesTableTable,
        VoucherTemplatesTableData,
        $$VoucherTemplatesTableTableFilterComposer,
        $$VoucherTemplatesTableTableOrderingComposer,
        $$VoucherTemplatesTableTableAnnotationComposer,
        $$VoucherTemplatesTableTableCreateCompanionBuilder,
        $$VoucherTemplatesTableTableUpdateCompanionBuilder,
        (
          VoucherTemplatesTableData,
          BaseReferences<_$AppDatabase, $VoucherTemplatesTableTable,
              VoucherTemplatesTableData>
        ),
        VoucherTemplatesTableData,
        PrefetchHooks Function()>;
typedef $$SalesReportsTableTableCreateCompanionBuilder
    = SalesReportsTableCompanion Function({
  Value<int> id,
  Value<int?> routerId,
  required String reportType,
  required DateTime reportDate,
  Value<int> totalVouchers,
  Value<double> totalRevenue,
  Value<double> totalCost,
  Value<double> netProfit,
  Value<String?> detailsJson,
  Value<DateTime> createdAt,
});
typedef $$SalesReportsTableTableUpdateCompanionBuilder
    = SalesReportsTableCompanion Function({
  Value<int> id,
  Value<int?> routerId,
  Value<String> reportType,
  Value<DateTime> reportDate,
  Value<int> totalVouchers,
  Value<double> totalRevenue,
  Value<double> totalCost,
  Value<double> netProfit,
  Value<String?> detailsJson,
  Value<DateTime> createdAt,
});

class $$SalesReportsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SalesReportsTableTable> {
  $$SalesReportsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get routerId => $composableBuilder(
      column: $table.routerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reportType => $composableBuilder(
      column: $table.reportType, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get reportDate => $composableBuilder(
      column: $table.reportDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalVouchers => $composableBuilder(
      column: $table.totalVouchers, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalRevenue => $composableBuilder(
      column: $table.totalRevenue, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalCost => $composableBuilder(
      column: $table.totalCost, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get netProfit => $composableBuilder(
      column: $table.netProfit, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get detailsJson => $composableBuilder(
      column: $table.detailsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$SalesReportsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SalesReportsTableTable> {
  $$SalesReportsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get routerId => $composableBuilder(
      column: $table.routerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reportType => $composableBuilder(
      column: $table.reportType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get reportDate => $composableBuilder(
      column: $table.reportDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalVouchers => $composableBuilder(
      column: $table.totalVouchers,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalRevenue => $composableBuilder(
      column: $table.totalRevenue,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalCost => $composableBuilder(
      column: $table.totalCost, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get netProfit => $composableBuilder(
      column: $table.netProfit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get detailsJson => $composableBuilder(
      column: $table.detailsJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$SalesReportsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SalesReportsTableTable> {
  $$SalesReportsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get routerId =>
      $composableBuilder(column: $table.routerId, builder: (column) => column);

  GeneratedColumn<String> get reportType => $composableBuilder(
      column: $table.reportType, builder: (column) => column);

  GeneratedColumn<DateTime> get reportDate => $composableBuilder(
      column: $table.reportDate, builder: (column) => column);

  GeneratedColumn<int> get totalVouchers => $composableBuilder(
      column: $table.totalVouchers, builder: (column) => column);

  GeneratedColumn<double> get totalRevenue => $composableBuilder(
      column: $table.totalRevenue, builder: (column) => column);

  GeneratedColumn<double> get totalCost =>
      $composableBuilder(column: $table.totalCost, builder: (column) => column);

  GeneratedColumn<double> get netProfit =>
      $composableBuilder(column: $table.netProfit, builder: (column) => column);

  GeneratedColumn<String> get detailsJson => $composableBuilder(
      column: $table.detailsJson, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SalesReportsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SalesReportsTableTable,
    SalesReportsTableData,
    $$SalesReportsTableTableFilterComposer,
    $$SalesReportsTableTableOrderingComposer,
    $$SalesReportsTableTableAnnotationComposer,
    $$SalesReportsTableTableCreateCompanionBuilder,
    $$SalesReportsTableTableUpdateCompanionBuilder,
    (
      SalesReportsTableData,
      BaseReferences<_$AppDatabase, $SalesReportsTableTable,
          SalesReportsTableData>
    ),
    SalesReportsTableData,
    PrefetchHooks Function()> {
  $$SalesReportsTableTableTableManager(
      _$AppDatabase db, $SalesReportsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SalesReportsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SalesReportsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SalesReportsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> routerId = const Value.absent(),
            Value<String> reportType = const Value.absent(),
            Value<DateTime> reportDate = const Value.absent(),
            Value<int> totalVouchers = const Value.absent(),
            Value<double> totalRevenue = const Value.absent(),
            Value<double> totalCost = const Value.absent(),
            Value<double> netProfit = const Value.absent(),
            Value<String?> detailsJson = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SalesReportsTableCompanion(
            id: id,
            routerId: routerId,
            reportType: reportType,
            reportDate: reportDate,
            totalVouchers: totalVouchers,
            totalRevenue: totalRevenue,
            totalCost: totalCost,
            netProfit: netProfit,
            detailsJson: detailsJson,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> routerId = const Value.absent(),
            required String reportType,
            required DateTime reportDate,
            Value<int> totalVouchers = const Value.absent(),
            Value<double> totalRevenue = const Value.absent(),
            Value<double> totalCost = const Value.absent(),
            Value<double> netProfit = const Value.absent(),
            Value<String?> detailsJson = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SalesReportsTableCompanion.insert(
            id: id,
            routerId: routerId,
            reportType: reportType,
            reportDate: reportDate,
            totalVouchers: totalVouchers,
            totalRevenue: totalRevenue,
            totalCost: totalCost,
            netProfit: netProfit,
            detailsJson: detailsJson,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$SalesReportsTableTable, SalesReportsTableData>(
                        table),
                    BaseReferences<_$AppDatabase, $SalesReportsTableTable,
                        SalesReportsTableData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SalesReportsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SalesReportsTableTable,
    SalesReportsTableData,
    $$SalesReportsTableTableFilterComposer,
    $$SalesReportsTableTableOrderingComposer,
    $$SalesReportsTableTableAnnotationComposer,
    $$SalesReportsTableTableCreateCompanionBuilder,
    $$SalesReportsTableTableUpdateCompanionBuilder,
    (
      SalesReportsTableData,
      BaseReferences<_$AppDatabase, $SalesReportsTableTable,
          SalesReportsTableData>
    ),
    SalesReportsTableData,
    PrefetchHooks Function()>;
typedef $$AuditLogsTableTableCreateCompanionBuilder = AuditLogsTableCompanion
    Function({
  Value<int> id,
  required String action,
  required String entityType,
  Value<String?> entityId,
  required String description,
  Value<String> performedBy,
  Value<String?> metadata,
  Value<DateTime> performedAt,
});
typedef $$AuditLogsTableTableUpdateCompanionBuilder = AuditLogsTableCompanion
    Function({
  Value<int> id,
  Value<String> action,
  Value<String> entityType,
  Value<String?> entityId,
  Value<String> description,
  Value<String> performedBy,
  Value<String?> metadata,
  Value<DateTime> performedAt,
});

class $$AuditLogsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AuditLogsTableTable> {
  $$AuditLogsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get action => $composableBuilder(
      column: $table.action, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get performedBy => $composableBuilder(
      column: $table.performedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get metadata => $composableBuilder(
      column: $table.metadata, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get performedAt => $composableBuilder(
      column: $table.performedAt, builder: (column) => ColumnFilters(column));
}

class $$AuditLogsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AuditLogsTableTable> {
  $$AuditLogsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get action => $composableBuilder(
      column: $table.action, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get performedBy => $composableBuilder(
      column: $table.performedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get metadata => $composableBuilder(
      column: $table.metadata, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get performedAt => $composableBuilder(
      column: $table.performedAt, builder: (column) => ColumnOrderings(column));
}

class $$AuditLogsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuditLogsTableTable> {
  $$AuditLogsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get performedBy => $composableBuilder(
      column: $table.performedBy, builder: (column) => column);

  GeneratedColumn<String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);

  GeneratedColumn<DateTime> get performedAt => $composableBuilder(
      column: $table.performedAt, builder: (column) => column);
}

class $$AuditLogsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AuditLogsTableTable,
    AuditLogsTableData,
    $$AuditLogsTableTableFilterComposer,
    $$AuditLogsTableTableOrderingComposer,
    $$AuditLogsTableTableAnnotationComposer,
    $$AuditLogsTableTableCreateCompanionBuilder,
    $$AuditLogsTableTableUpdateCompanionBuilder,
    (
      AuditLogsTableData,
      BaseReferences<_$AppDatabase, $AuditLogsTableTable, AuditLogsTableData>
    ),
    AuditLogsTableData,
    PrefetchHooks Function()> {
  $$AuditLogsTableTableTableManager(
      _$AppDatabase db, $AuditLogsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuditLogsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuditLogsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuditLogsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> action = const Value.absent(),
            Value<String> entityType = const Value.absent(),
            Value<String?> entityId = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String> performedBy = const Value.absent(),
            Value<String?> metadata = const Value.absent(),
            Value<DateTime> performedAt = const Value.absent(),
          }) =>
              AuditLogsTableCompanion(
            id: id,
            action: action,
            entityType: entityType,
            entityId: entityId,
            description: description,
            performedBy: performedBy,
            metadata: metadata,
            performedAt: performedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String action,
            required String entityType,
            Value<String?> entityId = const Value.absent(),
            required String description,
            Value<String> performedBy = const Value.absent(),
            Value<String?> metadata = const Value.absent(),
            Value<DateTime> performedAt = const Value.absent(),
          }) =>
              AuditLogsTableCompanion.insert(
            id: id,
            action: action,
            entityType: entityType,
            entityId: entityId,
            description: description,
            performedBy: performedBy,
            metadata: metadata,
            performedAt: performedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$AuditLogsTableTable, AuditLogsTableData>(
                        table),
                    BaseReferences<_$AppDatabase, $AuditLogsTableTable,
                        AuditLogsTableData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AuditLogsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AuditLogsTableTable,
    AuditLogsTableData,
    $$AuditLogsTableTableFilterComposer,
    $$AuditLogsTableTableOrderingComposer,
    $$AuditLogsTableTableAnnotationComposer,
    $$AuditLogsTableTableCreateCompanionBuilder,
    $$AuditLogsTableTableUpdateCompanionBuilder,
    (
      AuditLogsTableData,
      BaseReferences<_$AppDatabase, $AuditLogsTableTable, AuditLogsTableData>
    ),
    AuditLogsTableData,
    PrefetchHooks Function()>;
typedef $$ProfilePricesTableTableCreateCompanionBuilder
    = ProfilePricesTableCompanion Function({
  Value<int> id,
  required int connectionId,
  required String profileName,
  required double price,
  Value<String> currency,
  Value<DateTime> updatedAt,
});
typedef $$ProfilePricesTableTableUpdateCompanionBuilder
    = ProfilePricesTableCompanion Function({
  Value<int> id,
  Value<int> connectionId,
  Value<String> profileName,
  Value<double> price,
  Value<String> currency,
  Value<DateTime> updatedAt,
});

class $$ProfilePricesTableTableFilterComposer
    extends Composer<_$AppDatabase, $ProfilePricesTableTable> {
  $$ProfilePricesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get connectionId => $composableBuilder(
      column: $table.connectionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profileName => $composableBuilder(
      column: $table.profileName, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$ProfilePricesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfilePricesTableTable> {
  $$ProfilePricesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get connectionId => $composableBuilder(
      column: $table.connectionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profileName => $composableBuilder(
      column: $table.profileName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ProfilePricesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfilePricesTableTable> {
  $$ProfilePricesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get connectionId => $composableBuilder(
      column: $table.connectionId, builder: (column) => column);

  GeneratedColumn<String> get profileName => $composableBuilder(
      column: $table.profileName, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ProfilePricesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProfilePricesTableTable,
    ProfilePricesTableData,
    $$ProfilePricesTableTableFilterComposer,
    $$ProfilePricesTableTableOrderingComposer,
    $$ProfilePricesTableTableAnnotationComposer,
    $$ProfilePricesTableTableCreateCompanionBuilder,
    $$ProfilePricesTableTableUpdateCompanionBuilder,
    (
      ProfilePricesTableData,
      BaseReferences<_$AppDatabase, $ProfilePricesTableTable,
          ProfilePricesTableData>
    ),
    ProfilePricesTableData,
    PrefetchHooks Function()> {
  $$ProfilePricesTableTableTableManager(
      _$AppDatabase db, $ProfilePricesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfilePricesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfilePricesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfilePricesTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> connectionId = const Value.absent(),
            Value<String> profileName = const Value.absent(),
            Value<double> price = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              ProfilePricesTableCompanion(
            id: id,
            connectionId: connectionId,
            profileName: profileName,
            price: price,
            currency: currency,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int connectionId,
            required String profileName,
            required double price,
            Value<String> currency = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              ProfilePricesTableCompanion.insert(
            id: id,
            connectionId: connectionId,
            profileName: profileName,
            price: price,
            currency: currency,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$ProfilePricesTableTable,
                        ProfilePricesTableData>(table),
                    BaseReferences<_$AppDatabase, $ProfilePricesTableTable,
                        ProfilePricesTableData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ProfilePricesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProfilePricesTableTable,
    ProfilePricesTableData,
    $$ProfilePricesTableTableFilterComposer,
    $$ProfilePricesTableTableOrderingComposer,
    $$ProfilePricesTableTableAnnotationComposer,
    $$ProfilePricesTableTableCreateCompanionBuilder,
    $$ProfilePricesTableTableUpdateCompanionBuilder,
    (
      ProfilePricesTableData,
      BaseReferences<_$AppDatabase, $ProfilePricesTableTable,
          ProfilePricesTableData>
    ),
    ProfilePricesTableData,
    PrefetchHooks Function()>;
typedef $$UsageObservationsTableTableCreateCompanionBuilder
    = UsageObservationsTableCompanion Function({
  Value<int> id,
  required int connectionId,
  required String cardName,
  required String profile,
  Value<String> cardType,
  Value<DateTime> firstSeenAt,
  Value<bool> dateIsApproximate,
});
typedef $$UsageObservationsTableTableUpdateCompanionBuilder
    = UsageObservationsTableCompanion Function({
  Value<int> id,
  Value<int> connectionId,
  Value<String> cardName,
  Value<String> profile,
  Value<String> cardType,
  Value<DateTime> firstSeenAt,
  Value<bool> dateIsApproximate,
});

class $$UsageObservationsTableTableFilterComposer
    extends Composer<_$AppDatabase, $UsageObservationsTableTable> {
  $$UsageObservationsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get connectionId => $composableBuilder(
      column: $table.connectionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cardName => $composableBuilder(
      column: $table.cardName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profile => $composableBuilder(
      column: $table.profile, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cardType => $composableBuilder(
      column: $table.cardType, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get firstSeenAt => $composableBuilder(
      column: $table.firstSeenAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get dateIsApproximate => $composableBuilder(
      column: $table.dateIsApproximate,
      builder: (column) => ColumnFilters(column));
}

class $$UsageObservationsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UsageObservationsTableTable> {
  $$UsageObservationsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get connectionId => $composableBuilder(
      column: $table.connectionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cardName => $composableBuilder(
      column: $table.cardName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profile => $composableBuilder(
      column: $table.profile, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cardType => $composableBuilder(
      column: $table.cardType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get firstSeenAt => $composableBuilder(
      column: $table.firstSeenAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get dateIsApproximate => $composableBuilder(
      column: $table.dateIsApproximate,
      builder: (column) => ColumnOrderings(column));
}

class $$UsageObservationsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsageObservationsTableTable> {
  $$UsageObservationsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get connectionId => $composableBuilder(
      column: $table.connectionId, builder: (column) => column);

  GeneratedColumn<String> get cardName =>
      $composableBuilder(column: $table.cardName, builder: (column) => column);

  GeneratedColumn<String> get profile =>
      $composableBuilder(column: $table.profile, builder: (column) => column);

  GeneratedColumn<String> get cardType =>
      $composableBuilder(column: $table.cardType, builder: (column) => column);

  GeneratedColumn<DateTime> get firstSeenAt => $composableBuilder(
      column: $table.firstSeenAt, builder: (column) => column);

  GeneratedColumn<bool> get dateIsApproximate => $composableBuilder(
      column: $table.dateIsApproximate, builder: (column) => column);
}

class $$UsageObservationsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsageObservationsTableTable,
    UsageObservationsTableData,
    $$UsageObservationsTableTableFilterComposer,
    $$UsageObservationsTableTableOrderingComposer,
    $$UsageObservationsTableTableAnnotationComposer,
    $$UsageObservationsTableTableCreateCompanionBuilder,
    $$UsageObservationsTableTableUpdateCompanionBuilder,
    (
      UsageObservationsTableData,
      BaseReferences<_$AppDatabase, $UsageObservationsTableTable,
          UsageObservationsTableData>
    ),
    UsageObservationsTableData,
    PrefetchHooks Function()> {
  $$UsageObservationsTableTableTableManager(
      _$AppDatabase db, $UsageObservationsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsageObservationsTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$UsageObservationsTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsageObservationsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> connectionId = const Value.absent(),
            Value<String> cardName = const Value.absent(),
            Value<String> profile = const Value.absent(),
            Value<String> cardType = const Value.absent(),
            Value<DateTime> firstSeenAt = const Value.absent(),
            Value<bool> dateIsApproximate = const Value.absent(),
          }) =>
              UsageObservationsTableCompanion(
            id: id,
            connectionId: connectionId,
            cardName: cardName,
            profile: profile,
            cardType: cardType,
            firstSeenAt: firstSeenAt,
            dateIsApproximate: dateIsApproximate,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int connectionId,
            required String cardName,
            required String profile,
            Value<String> cardType = const Value.absent(),
            Value<DateTime> firstSeenAt = const Value.absent(),
            Value<bool> dateIsApproximate = const Value.absent(),
          }) =>
              UsageObservationsTableCompanion.insert(
            id: id,
            connectionId: connectionId,
            cardName: cardName,
            profile: profile,
            cardType: cardType,
            firstSeenAt: firstSeenAt,
            dateIsApproximate: dateIsApproximate,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$UsageObservationsTableTable,
                        UsageObservationsTableData>(table),
                    BaseReferences<_$AppDatabase, $UsageObservationsTableTable,
                        UsageObservationsTableData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UsageObservationsTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $UsageObservationsTableTable,
        UsageObservationsTableData,
        $$UsageObservationsTableTableFilterComposer,
        $$UsageObservationsTableTableOrderingComposer,
        $$UsageObservationsTableTableAnnotationComposer,
        $$UsageObservationsTableTableCreateCompanionBuilder,
        $$UsageObservationsTableTableUpdateCompanionBuilder,
        (
          UsageObservationsTableData,
          BaseReferences<_$AppDatabase, $UsageObservationsTableTable,
              UsageObservationsTableData>
        ),
        UsageObservationsTableData,
        PrefetchHooks Function()>;
typedef $$CardEventsTableTableCreateCompanionBuilder = CardEventsTableCompanion
    Function({
  Value<int> id,
  required int connectionId,
  required String type,
  required int count,
  required String profile,
  Value<DateTime> at,
});
typedef $$CardEventsTableTableUpdateCompanionBuilder = CardEventsTableCompanion
    Function({
  Value<int> id,
  Value<int> connectionId,
  Value<String> type,
  Value<int> count,
  Value<String> profile,
  Value<DateTime> at,
});

class $$CardEventsTableTableFilterComposer
    extends Composer<_$AppDatabase, $CardEventsTableTable> {
  $$CardEventsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get connectionId => $composableBuilder(
      column: $table.connectionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get count => $composableBuilder(
      column: $table.count, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profile => $composableBuilder(
      column: $table.profile, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get at => $composableBuilder(
      column: $table.at, builder: (column) => ColumnFilters(column));
}

class $$CardEventsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CardEventsTableTable> {
  $$CardEventsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get connectionId => $composableBuilder(
      column: $table.connectionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get count => $composableBuilder(
      column: $table.count, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profile => $composableBuilder(
      column: $table.profile, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get at => $composableBuilder(
      column: $table.at, builder: (column) => ColumnOrderings(column));
}

class $$CardEventsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CardEventsTableTable> {
  $$CardEventsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get connectionId => $composableBuilder(
      column: $table.connectionId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get count =>
      $composableBuilder(column: $table.count, builder: (column) => column);

  GeneratedColumn<String> get profile =>
      $composableBuilder(column: $table.profile, builder: (column) => column);

  GeneratedColumn<DateTime> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);
}

class $$CardEventsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CardEventsTableTable,
    CardEventsTableData,
    $$CardEventsTableTableFilterComposer,
    $$CardEventsTableTableOrderingComposer,
    $$CardEventsTableTableAnnotationComposer,
    $$CardEventsTableTableCreateCompanionBuilder,
    $$CardEventsTableTableUpdateCompanionBuilder,
    (
      CardEventsTableData,
      BaseReferences<_$AppDatabase, $CardEventsTableTable, CardEventsTableData>
    ),
    CardEventsTableData,
    PrefetchHooks Function()> {
  $$CardEventsTableTableTableManager(
      _$AppDatabase db, $CardEventsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardEventsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardEventsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CardEventsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> connectionId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<int> count = const Value.absent(),
            Value<String> profile = const Value.absent(),
            Value<DateTime> at = const Value.absent(),
          }) =>
              CardEventsTableCompanion(
            id: id,
            connectionId: connectionId,
            type: type,
            count: count,
            profile: profile,
            at: at,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int connectionId,
            required String type,
            required int count,
            required String profile,
            Value<DateTime> at = const Value.absent(),
          }) =>
              CardEventsTableCompanion.insert(
            id: id,
            connectionId: connectionId,
            type: type,
            count: count,
            profile: profile,
            at: at,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$CardEventsTableTable, CardEventsTableData>(
                        table),
                    BaseReferences<_$AppDatabase, $CardEventsTableTable,
                        CardEventsTableData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CardEventsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CardEventsTableTable,
    CardEventsTableData,
    $$CardEventsTableTableFilterComposer,
    $$CardEventsTableTableOrderingComposer,
    $$CardEventsTableTableAnnotationComposer,
    $$CardEventsTableTableCreateCompanionBuilder,
    $$CardEventsTableTableUpdateCompanionBuilder,
    (
      CardEventsTableData,
      BaseReferences<_$AppDatabase, $CardEventsTableTable, CardEventsTableData>
    ),
    CardEventsTableData,
    PrefetchHooks Function()>;
typedef $$PaymentsTableTableCreateCompanionBuilder = PaymentsTableCompanion
    Function({
  Value<int> id,
  required int connectionId,
  required double amount,
  Value<String?> note,
  Value<DateTime> receivedAt,
});
typedef $$PaymentsTableTableUpdateCompanionBuilder = PaymentsTableCompanion
    Function({
  Value<int> id,
  Value<int> connectionId,
  Value<double> amount,
  Value<String?> note,
  Value<DateTime> receivedAt,
});

class $$PaymentsTableTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentsTableTable> {
  $$PaymentsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get connectionId => $composableBuilder(
      column: $table.connectionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get receivedAt => $composableBuilder(
      column: $table.receivedAt, builder: (column) => ColumnFilters(column));
}

class $$PaymentsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentsTableTable> {
  $$PaymentsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get connectionId => $composableBuilder(
      column: $table.connectionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get receivedAt => $composableBuilder(
      column: $table.receivedAt, builder: (column) => ColumnOrderings(column));
}

class $$PaymentsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentsTableTable> {
  $$PaymentsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get connectionId => $composableBuilder(
      column: $table.connectionId, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get receivedAt => $composableBuilder(
      column: $table.receivedAt, builder: (column) => column);
}

class $$PaymentsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PaymentsTableTable,
    PaymentsTableData,
    $$PaymentsTableTableFilterComposer,
    $$PaymentsTableTableOrderingComposer,
    $$PaymentsTableTableAnnotationComposer,
    $$PaymentsTableTableCreateCompanionBuilder,
    $$PaymentsTableTableUpdateCompanionBuilder,
    (
      PaymentsTableData,
      BaseReferences<_$AppDatabase, $PaymentsTableTable, PaymentsTableData>
    ),
    PaymentsTableData,
    PrefetchHooks Function()> {
  $$PaymentsTableTableTableManager(_$AppDatabase db, $PaymentsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> connectionId = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<DateTime> receivedAt = const Value.absent(),
          }) =>
              PaymentsTableCompanion(
            id: id,
            connectionId: connectionId,
            amount: amount,
            note: note,
            receivedAt: receivedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int connectionId,
            required double amount,
            Value<String?> note = const Value.absent(),
            Value<DateTime> receivedAt = const Value.absent(),
          }) =>
              PaymentsTableCompanion.insert(
            id: id,
            connectionId: connectionId,
            amount: amount,
            note: note,
            receivedAt: receivedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$PaymentsTableTable, PaymentsTableData>(table),
                    BaseReferences<_$AppDatabase, $PaymentsTableTable,
                        PaymentsTableData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PaymentsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PaymentsTableTable,
    PaymentsTableData,
    $$PaymentsTableTableFilterComposer,
    $$PaymentsTableTableOrderingComposer,
    $$PaymentsTableTableAnnotationComposer,
    $$PaymentsTableTableCreateCompanionBuilder,
    $$PaymentsTableTableUpdateCompanionBuilder,
    (
      PaymentsTableData,
      BaseReferences<_$AppDatabase, $PaymentsTableTable, PaymentsTableData>
    ),
    PaymentsTableData,
    PrefetchHooks Function()>;
typedef $$PdfArchiveTableTableCreateCompanionBuilder = PdfArchiveTableCompanion
    Function({
  Value<int> id,
  required int connectionId,
  required String batchId,
  required String filePath,
  Value<int?> templateId,
  Value<DateTime> createdAt,
});
typedef $$PdfArchiveTableTableUpdateCompanionBuilder = PdfArchiveTableCompanion
    Function({
  Value<int> id,
  Value<int> connectionId,
  Value<String> batchId,
  Value<String> filePath,
  Value<int?> templateId,
  Value<DateTime> createdAt,
});

class $$PdfArchiveTableTableFilterComposer
    extends Composer<_$AppDatabase, $PdfArchiveTableTable> {
  $$PdfArchiveTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get connectionId => $composableBuilder(
      column: $table.connectionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get batchId => $composableBuilder(
      column: $table.batchId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get templateId => $composableBuilder(
      column: $table.templateId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$PdfArchiveTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PdfArchiveTableTable> {
  $$PdfArchiveTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get connectionId => $composableBuilder(
      column: $table.connectionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get batchId => $composableBuilder(
      column: $table.batchId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get templateId => $composableBuilder(
      column: $table.templateId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$PdfArchiveTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PdfArchiveTableTable> {
  $$PdfArchiveTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get connectionId => $composableBuilder(
      column: $table.connectionId, builder: (column) => column);

  GeneratedColumn<String> get batchId =>
      $composableBuilder(column: $table.batchId, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<int> get templateId => $composableBuilder(
      column: $table.templateId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$PdfArchiveTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PdfArchiveTableTable,
    PdfArchiveTableData,
    $$PdfArchiveTableTableFilterComposer,
    $$PdfArchiveTableTableOrderingComposer,
    $$PdfArchiveTableTableAnnotationComposer,
    $$PdfArchiveTableTableCreateCompanionBuilder,
    $$PdfArchiveTableTableUpdateCompanionBuilder,
    (
      PdfArchiveTableData,
      BaseReferences<_$AppDatabase, $PdfArchiveTableTable, PdfArchiveTableData>
    ),
    PdfArchiveTableData,
    PrefetchHooks Function()> {
  $$PdfArchiveTableTableTableManager(
      _$AppDatabase db, $PdfArchiveTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PdfArchiveTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PdfArchiveTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PdfArchiveTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> connectionId = const Value.absent(),
            Value<String> batchId = const Value.absent(),
            Value<String> filePath = const Value.absent(),
            Value<int?> templateId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              PdfArchiveTableCompanion(
            id: id,
            connectionId: connectionId,
            batchId: batchId,
            filePath: filePath,
            templateId: templateId,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int connectionId,
            required String batchId,
            required String filePath,
            Value<int?> templateId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              PdfArchiveTableCompanion.insert(
            id: id,
            connectionId: connectionId,
            batchId: batchId,
            filePath: filePath,
            templateId: templateId,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$PdfArchiveTableTable, PdfArchiveTableData>(
                        table),
                    BaseReferences<_$AppDatabase, $PdfArchiveTableTable,
                        PdfArchiveTableData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PdfArchiveTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PdfArchiveTableTable,
    PdfArchiveTableData,
    $$PdfArchiveTableTableFilterComposer,
    $$PdfArchiveTableTableOrderingComposer,
    $$PdfArchiveTableTableAnnotationComposer,
    $$PdfArchiveTableTableCreateCompanionBuilder,
    $$PdfArchiveTableTableUpdateCompanionBuilder,
    (
      PdfArchiveTableData,
      BaseReferences<_$AppDatabase, $PdfArchiveTableTable, PdfArchiveTableData>
    ),
    PdfArchiveTableData,
    PrefetchHooks Function()>;
typedef $$ApDevicesTableTableCreateCompanionBuilder = ApDevicesTableCompanion
    Function({
  Value<int> id,
  required int connectionId,
  required String name,
  required String ip,
  Value<String> vendor,
  Value<DateTime?> lastCheckAt,
  Value<String> accessState,
});
typedef $$ApDevicesTableTableUpdateCompanionBuilder = ApDevicesTableCompanion
    Function({
  Value<int> id,
  Value<int> connectionId,
  Value<String> name,
  Value<String> ip,
  Value<String> vendor,
  Value<DateTime?> lastCheckAt,
  Value<String> accessState,
});

class $$ApDevicesTableTableFilterComposer
    extends Composer<_$AppDatabase, $ApDevicesTableTable> {
  $$ApDevicesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get connectionId => $composableBuilder(
      column: $table.connectionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ip => $composableBuilder(
      column: $table.ip, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get vendor => $composableBuilder(
      column: $table.vendor, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastCheckAt => $composableBuilder(
      column: $table.lastCheckAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get accessState => $composableBuilder(
      column: $table.accessState, builder: (column) => ColumnFilters(column));
}

class $$ApDevicesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ApDevicesTableTable> {
  $$ApDevicesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get connectionId => $composableBuilder(
      column: $table.connectionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ip => $composableBuilder(
      column: $table.ip, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get vendor => $composableBuilder(
      column: $table.vendor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastCheckAt => $composableBuilder(
      column: $table.lastCheckAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accessState => $composableBuilder(
      column: $table.accessState, builder: (column) => ColumnOrderings(column));
}

class $$ApDevicesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ApDevicesTableTable> {
  $$ApDevicesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get connectionId => $composableBuilder(
      column: $table.connectionId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get ip =>
      $composableBuilder(column: $table.ip, builder: (column) => column);

  GeneratedColumn<String> get vendor =>
      $composableBuilder(column: $table.vendor, builder: (column) => column);

  GeneratedColumn<DateTime> get lastCheckAt => $composableBuilder(
      column: $table.lastCheckAt, builder: (column) => column);

  GeneratedColumn<String> get accessState => $composableBuilder(
      column: $table.accessState, builder: (column) => column);
}

class $$ApDevicesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ApDevicesTableTable,
    ApDevicesTableData,
    $$ApDevicesTableTableFilterComposer,
    $$ApDevicesTableTableOrderingComposer,
    $$ApDevicesTableTableAnnotationComposer,
    $$ApDevicesTableTableCreateCompanionBuilder,
    $$ApDevicesTableTableUpdateCompanionBuilder,
    (
      ApDevicesTableData,
      BaseReferences<_$AppDatabase, $ApDevicesTableTable, ApDevicesTableData>
    ),
    ApDevicesTableData,
    PrefetchHooks Function()> {
  $$ApDevicesTableTableTableManager(
      _$AppDatabase db, $ApDevicesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ApDevicesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ApDevicesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ApDevicesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> connectionId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> ip = const Value.absent(),
            Value<String> vendor = const Value.absent(),
            Value<DateTime?> lastCheckAt = const Value.absent(),
            Value<String> accessState = const Value.absent(),
          }) =>
              ApDevicesTableCompanion(
            id: id,
            connectionId: connectionId,
            name: name,
            ip: ip,
            vendor: vendor,
            lastCheckAt: lastCheckAt,
            accessState: accessState,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int connectionId,
            required String name,
            required String ip,
            Value<String> vendor = const Value.absent(),
            Value<DateTime?> lastCheckAt = const Value.absent(),
            Value<String> accessState = const Value.absent(),
          }) =>
              ApDevicesTableCompanion.insert(
            id: id,
            connectionId: connectionId,
            name: name,
            ip: ip,
            vendor: vendor,
            lastCheckAt: lastCheckAt,
            accessState: accessState,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$ApDevicesTableTable, ApDevicesTableData>(
                        table),
                    BaseReferences<_$AppDatabase, $ApDevicesTableTable,
                        ApDevicesTableData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ApDevicesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ApDevicesTableTable,
    ApDevicesTableData,
    $$ApDevicesTableTableFilterComposer,
    $$ApDevicesTableTableOrderingComposer,
    $$ApDevicesTableTableAnnotationComposer,
    $$ApDevicesTableTableCreateCompanionBuilder,
    $$ApDevicesTableTableUpdateCompanionBuilder,
    (
      ApDevicesTableData,
      BaseReferences<_$AppDatabase, $ApDevicesTableTable, ApDevicesTableData>
    ),
    ApDevicesTableData,
    PrefetchHooks Function()>;
typedef $$UserApMatchesTableTableCreateCompanionBuilder
    = UserApMatchesTableCompanion Function({
  Value<int> id,
  required int connectionId,
  required String userMac,
  Value<int?> apId,
  required String confidence,
  required String evidence,
  Value<DateTime> at,
});
typedef $$UserApMatchesTableTableUpdateCompanionBuilder
    = UserApMatchesTableCompanion Function({
  Value<int> id,
  Value<int> connectionId,
  Value<String> userMac,
  Value<int?> apId,
  Value<String> confidence,
  Value<String> evidence,
  Value<DateTime> at,
});

class $$UserApMatchesTableTableFilterComposer
    extends Composer<_$AppDatabase, $UserApMatchesTableTable> {
  $$UserApMatchesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get connectionId => $composableBuilder(
      column: $table.connectionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userMac => $composableBuilder(
      column: $table.userMac, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get apId => $composableBuilder(
      column: $table.apId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get evidence => $composableBuilder(
      column: $table.evidence, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get at => $composableBuilder(
      column: $table.at, builder: (column) => ColumnFilters(column));
}

class $$UserApMatchesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UserApMatchesTableTable> {
  $$UserApMatchesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get connectionId => $composableBuilder(
      column: $table.connectionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userMac => $composableBuilder(
      column: $table.userMac, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get apId => $composableBuilder(
      column: $table.apId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get evidence => $composableBuilder(
      column: $table.evidence, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get at => $composableBuilder(
      column: $table.at, builder: (column) => ColumnOrderings(column));
}

class $$UserApMatchesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserApMatchesTableTable> {
  $$UserApMatchesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get connectionId => $composableBuilder(
      column: $table.connectionId, builder: (column) => column);

  GeneratedColumn<String> get userMac =>
      $composableBuilder(column: $table.userMac, builder: (column) => column);

  GeneratedColumn<int> get apId =>
      $composableBuilder(column: $table.apId, builder: (column) => column);

  GeneratedColumn<String> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => column);

  GeneratedColumn<String> get evidence =>
      $composableBuilder(column: $table.evidence, builder: (column) => column);

  GeneratedColumn<DateTime> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);
}

class $$UserApMatchesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserApMatchesTableTable,
    UserApMatchesTableData,
    $$UserApMatchesTableTableFilterComposer,
    $$UserApMatchesTableTableOrderingComposer,
    $$UserApMatchesTableTableAnnotationComposer,
    $$UserApMatchesTableTableCreateCompanionBuilder,
    $$UserApMatchesTableTableUpdateCompanionBuilder,
    (
      UserApMatchesTableData,
      BaseReferences<_$AppDatabase, $UserApMatchesTableTable,
          UserApMatchesTableData>
    ),
    UserApMatchesTableData,
    PrefetchHooks Function()> {
  $$UserApMatchesTableTableTableManager(
      _$AppDatabase db, $UserApMatchesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserApMatchesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserApMatchesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserApMatchesTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> connectionId = const Value.absent(),
            Value<String> userMac = const Value.absent(),
            Value<int?> apId = const Value.absent(),
            Value<String> confidence = const Value.absent(),
            Value<String> evidence = const Value.absent(),
            Value<DateTime> at = const Value.absent(),
          }) =>
              UserApMatchesTableCompanion(
            id: id,
            connectionId: connectionId,
            userMac: userMac,
            apId: apId,
            confidence: confidence,
            evidence: evidence,
            at: at,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int connectionId,
            required String userMac,
            Value<int?> apId = const Value.absent(),
            required String confidence,
            required String evidence,
            Value<DateTime> at = const Value.absent(),
          }) =>
              UserApMatchesTableCompanion.insert(
            id: id,
            connectionId: connectionId,
            userMac: userMac,
            apId: apId,
            confidence: confidence,
            evidence: evidence,
            at: at,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$UserApMatchesTableTable,
                        UserApMatchesTableData>(table),
                    BaseReferences<_$AppDatabase, $UserApMatchesTableTable,
                        UserApMatchesTableData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserApMatchesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserApMatchesTableTable,
    UserApMatchesTableData,
    $$UserApMatchesTableTableFilterComposer,
    $$UserApMatchesTableTableOrderingComposer,
    $$UserApMatchesTableTableAnnotationComposer,
    $$UserApMatchesTableTableCreateCompanionBuilder,
    $$UserApMatchesTableTableUpdateCompanionBuilder,
    (
      UserApMatchesTableData,
      BaseReferences<_$AppDatabase, $UserApMatchesTableTable,
          UserApMatchesTableData>
    ),
    UserApMatchesTableData,
    PrefetchHooks Function()>;
typedef $$TopologySnapshotsTableTableCreateCompanionBuilder
    = TopologySnapshotsTableCompanion Function({
  Value<int> id,
  required int connectionId,
  required String graphJson,
  Value<DateTime> savedAt,
});
typedef $$TopologySnapshotsTableTableUpdateCompanionBuilder
    = TopologySnapshotsTableCompanion Function({
  Value<int> id,
  Value<int> connectionId,
  Value<String> graphJson,
  Value<DateTime> savedAt,
});

class $$TopologySnapshotsTableTableFilterComposer
    extends Composer<_$AppDatabase, $TopologySnapshotsTableTable> {
  $$TopologySnapshotsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get connectionId => $composableBuilder(
      column: $table.connectionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get graphJson => $composableBuilder(
      column: $table.graphJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get savedAt => $composableBuilder(
      column: $table.savedAt, builder: (column) => ColumnFilters(column));
}

class $$TopologySnapshotsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TopologySnapshotsTableTable> {
  $$TopologySnapshotsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get connectionId => $composableBuilder(
      column: $table.connectionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get graphJson => $composableBuilder(
      column: $table.graphJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get savedAt => $composableBuilder(
      column: $table.savedAt, builder: (column) => ColumnOrderings(column));
}

class $$TopologySnapshotsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TopologySnapshotsTableTable> {
  $$TopologySnapshotsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get connectionId => $composableBuilder(
      column: $table.connectionId, builder: (column) => column);

  GeneratedColumn<String> get graphJson =>
      $composableBuilder(column: $table.graphJson, builder: (column) => column);

  GeneratedColumn<DateTime> get savedAt =>
      $composableBuilder(column: $table.savedAt, builder: (column) => column);
}

class $$TopologySnapshotsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TopologySnapshotsTableTable,
    TopologySnapshotsTableData,
    $$TopologySnapshotsTableTableFilterComposer,
    $$TopologySnapshotsTableTableOrderingComposer,
    $$TopologySnapshotsTableTableAnnotationComposer,
    $$TopologySnapshotsTableTableCreateCompanionBuilder,
    $$TopologySnapshotsTableTableUpdateCompanionBuilder,
    (
      TopologySnapshotsTableData,
      BaseReferences<_$AppDatabase, $TopologySnapshotsTableTable,
          TopologySnapshotsTableData>
    ),
    TopologySnapshotsTableData,
    PrefetchHooks Function()> {
  $$TopologySnapshotsTableTableTableManager(
      _$AppDatabase db, $TopologySnapshotsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TopologySnapshotsTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$TopologySnapshotsTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TopologySnapshotsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> connectionId = const Value.absent(),
            Value<String> graphJson = const Value.absent(),
            Value<DateTime> savedAt = const Value.absent(),
          }) =>
              TopologySnapshotsTableCompanion(
            id: id,
            connectionId: connectionId,
            graphJson: graphJson,
            savedAt: savedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int connectionId,
            required String graphJson,
            Value<DateTime> savedAt = const Value.absent(),
          }) =>
              TopologySnapshotsTableCompanion.insert(
            id: id,
            connectionId: connectionId,
            graphJson: graphJson,
            savedAt: savedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$TopologySnapshotsTableTable,
                        TopologySnapshotsTableData>(table),
                    BaseReferences<_$AppDatabase, $TopologySnapshotsTableTable,
                        TopologySnapshotsTableData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TopologySnapshotsTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $TopologySnapshotsTableTable,
        TopologySnapshotsTableData,
        $$TopologySnapshotsTableTableFilterComposer,
        $$TopologySnapshotsTableTableOrderingComposer,
        $$TopologySnapshotsTableTableAnnotationComposer,
        $$TopologySnapshotsTableTableCreateCompanionBuilder,
        $$TopologySnapshotsTableTableUpdateCompanionBuilder,
        (
          TopologySnapshotsTableData,
          BaseReferences<_$AppDatabase, $TopologySnapshotsTableTable,
              TopologySnapshotsTableData>
        ),
        TopologySnapshotsTableData,
        PrefetchHooks Function()>;
typedef $$AlertRulesTableTableCreateCompanionBuilder = AlertRulesTableCompanion
    Function({
  Value<int> id,
  required int connectionId,
  required String type,
  required String target,
  required double threshold,
  Value<String> destination,
  Value<bool> enabled,
});
typedef $$AlertRulesTableTableUpdateCompanionBuilder = AlertRulesTableCompanion
    Function({
  Value<int> id,
  Value<int> connectionId,
  Value<String> type,
  Value<String> target,
  Value<double> threshold,
  Value<String> destination,
  Value<bool> enabled,
});

class $$AlertRulesTableTableFilterComposer
    extends Composer<_$AppDatabase, $AlertRulesTableTable> {
  $$AlertRulesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get connectionId => $composableBuilder(
      column: $table.connectionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get target => $composableBuilder(
      column: $table.target, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get threshold => $composableBuilder(
      column: $table.threshold, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get destination => $composableBuilder(
      column: $table.destination, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get enabled => $composableBuilder(
      column: $table.enabled, builder: (column) => ColumnFilters(column));
}

class $$AlertRulesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AlertRulesTableTable> {
  $$AlertRulesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get connectionId => $composableBuilder(
      column: $table.connectionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get target => $composableBuilder(
      column: $table.target, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get threshold => $composableBuilder(
      column: $table.threshold, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get destination => $composableBuilder(
      column: $table.destination, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get enabled => $composableBuilder(
      column: $table.enabled, builder: (column) => ColumnOrderings(column));
}

class $$AlertRulesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AlertRulesTableTable> {
  $$AlertRulesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get connectionId => $composableBuilder(
      column: $table.connectionId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get target =>
      $composableBuilder(column: $table.target, builder: (column) => column);

  GeneratedColumn<double> get threshold =>
      $composableBuilder(column: $table.threshold, builder: (column) => column);

  GeneratedColumn<String> get destination => $composableBuilder(
      column: $table.destination, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);
}

class $$AlertRulesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AlertRulesTableTable,
    AlertRulesTableData,
    $$AlertRulesTableTableFilterComposer,
    $$AlertRulesTableTableOrderingComposer,
    $$AlertRulesTableTableAnnotationComposer,
    $$AlertRulesTableTableCreateCompanionBuilder,
    $$AlertRulesTableTableUpdateCompanionBuilder,
    (
      AlertRulesTableData,
      BaseReferences<_$AppDatabase, $AlertRulesTableTable, AlertRulesTableData>
    ),
    AlertRulesTableData,
    PrefetchHooks Function()> {
  $$AlertRulesTableTableTableManager(
      _$AppDatabase db, $AlertRulesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AlertRulesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AlertRulesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AlertRulesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> connectionId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> target = const Value.absent(),
            Value<double> threshold = const Value.absent(),
            Value<String> destination = const Value.absent(),
            Value<bool> enabled = const Value.absent(),
          }) =>
              AlertRulesTableCompanion(
            id: id,
            connectionId: connectionId,
            type: type,
            target: target,
            threshold: threshold,
            destination: destination,
            enabled: enabled,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int connectionId,
            required String type,
            required String target,
            required double threshold,
            Value<String> destination = const Value.absent(),
            Value<bool> enabled = const Value.absent(),
          }) =>
              AlertRulesTableCompanion.insert(
            id: id,
            connectionId: connectionId,
            type: type,
            target: target,
            threshold: threshold,
            destination: destination,
            enabled: enabled,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$AlertRulesTableTable, AlertRulesTableData>(
                        table),
                    BaseReferences<_$AppDatabase, $AlertRulesTableTable,
                        AlertRulesTableData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AlertRulesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AlertRulesTableTable,
    AlertRulesTableData,
    $$AlertRulesTableTableFilterComposer,
    $$AlertRulesTableTableOrderingComposer,
    $$AlertRulesTableTableAnnotationComposer,
    $$AlertRulesTableTableCreateCompanionBuilder,
    $$AlertRulesTableTableUpdateCompanionBuilder,
    (
      AlertRulesTableData,
      BaseReferences<_$AppDatabase, $AlertRulesTableTable, AlertRulesTableData>
    ),
    AlertRulesTableData,
    PrefetchHooks Function()>;
typedef $$AlertEventsTableTableCreateCompanionBuilder
    = AlertEventsTableCompanion Function({
  Value<int> id,
  required int connectionId,
  required int ruleId,
  required String status,
  Value<DateTime> at,
  Value<String?> details,
});
typedef $$AlertEventsTableTableUpdateCompanionBuilder
    = AlertEventsTableCompanion Function({
  Value<int> id,
  Value<int> connectionId,
  Value<int> ruleId,
  Value<String> status,
  Value<DateTime> at,
  Value<String?> details,
});

class $$AlertEventsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AlertEventsTableTable> {
  $$AlertEventsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get connectionId => $composableBuilder(
      column: $table.connectionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get ruleId => $composableBuilder(
      column: $table.ruleId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get at => $composableBuilder(
      column: $table.at, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get details => $composableBuilder(
      column: $table.details, builder: (column) => ColumnFilters(column));
}

class $$AlertEventsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AlertEventsTableTable> {
  $$AlertEventsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get connectionId => $composableBuilder(
      column: $table.connectionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get ruleId => $composableBuilder(
      column: $table.ruleId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get at => $composableBuilder(
      column: $table.at, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get details => $composableBuilder(
      column: $table.details, builder: (column) => ColumnOrderings(column));
}

class $$AlertEventsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AlertEventsTableTable> {
  $$AlertEventsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get connectionId => $composableBuilder(
      column: $table.connectionId, builder: (column) => column);

  GeneratedColumn<int> get ruleId =>
      $composableBuilder(column: $table.ruleId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);

  GeneratedColumn<String> get details =>
      $composableBuilder(column: $table.details, builder: (column) => column);
}

class $$AlertEventsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AlertEventsTableTable,
    AlertEventsTableData,
    $$AlertEventsTableTableFilterComposer,
    $$AlertEventsTableTableOrderingComposer,
    $$AlertEventsTableTableAnnotationComposer,
    $$AlertEventsTableTableCreateCompanionBuilder,
    $$AlertEventsTableTableUpdateCompanionBuilder,
    (
      AlertEventsTableData,
      BaseReferences<_$AppDatabase, $AlertEventsTableTable,
          AlertEventsTableData>
    ),
    AlertEventsTableData,
    PrefetchHooks Function()> {
  $$AlertEventsTableTableTableManager(
      _$AppDatabase db, $AlertEventsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AlertEventsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AlertEventsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AlertEventsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> connectionId = const Value.absent(),
            Value<int> ruleId = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> at = const Value.absent(),
            Value<String?> details = const Value.absent(),
          }) =>
              AlertEventsTableCompanion(
            id: id,
            connectionId: connectionId,
            ruleId: ruleId,
            status: status,
            at: at,
            details: details,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int connectionId,
            required int ruleId,
            required String status,
            Value<DateTime> at = const Value.absent(),
            Value<String?> details = const Value.absent(),
          }) =>
              AlertEventsTableCompanion.insert(
            id: id,
            connectionId: connectionId,
            ruleId: ruleId,
            status: status,
            at: at,
            details: details,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$AlertEventsTableTable, AlertEventsTableData>(
                        table),
                    BaseReferences<_$AppDatabase, $AlertEventsTableTable,
                        AlertEventsTableData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AlertEventsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AlertEventsTableTable,
    AlertEventsTableData,
    $$AlertEventsTableTableFilterComposer,
    $$AlertEventsTableTableOrderingComposer,
    $$AlertEventsTableTableAnnotationComposer,
    $$AlertEventsTableTableCreateCompanionBuilder,
    $$AlertEventsTableTableUpdateCompanionBuilder,
    (
      AlertEventsTableData,
      BaseReferences<_$AppDatabase, $AlertEventsTableTable,
          AlertEventsTableData>
    ),
    AlertEventsTableData,
    PrefetchHooks Function()>;
typedef $$QuietHoursTableTableCreateCompanionBuilder = QuietHoursTableCompanion
    Function({
  Value<int> id,
  required int connectionId,
  required int startMinute,
  required int endMinute,
  Value<String> days,
  Value<DateTime?> muteUntil,
});
typedef $$QuietHoursTableTableUpdateCompanionBuilder = QuietHoursTableCompanion
    Function({
  Value<int> id,
  Value<int> connectionId,
  Value<int> startMinute,
  Value<int> endMinute,
  Value<String> days,
  Value<DateTime?> muteUntil,
});

class $$QuietHoursTableTableFilterComposer
    extends Composer<_$AppDatabase, $QuietHoursTableTable> {
  $$QuietHoursTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get connectionId => $composableBuilder(
      column: $table.connectionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get startMinute => $composableBuilder(
      column: $table.startMinute, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get endMinute => $composableBuilder(
      column: $table.endMinute, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get days => $composableBuilder(
      column: $table.days, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get muteUntil => $composableBuilder(
      column: $table.muteUntil, builder: (column) => ColumnFilters(column));
}

class $$QuietHoursTableTableOrderingComposer
    extends Composer<_$AppDatabase, $QuietHoursTableTable> {
  $$QuietHoursTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get connectionId => $composableBuilder(
      column: $table.connectionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get startMinute => $composableBuilder(
      column: $table.startMinute, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get endMinute => $composableBuilder(
      column: $table.endMinute, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get days => $composableBuilder(
      column: $table.days, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get muteUntil => $composableBuilder(
      column: $table.muteUntil, builder: (column) => ColumnOrderings(column));
}

class $$QuietHoursTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuietHoursTableTable> {
  $$QuietHoursTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get connectionId => $composableBuilder(
      column: $table.connectionId, builder: (column) => column);

  GeneratedColumn<int> get startMinute => $composableBuilder(
      column: $table.startMinute, builder: (column) => column);

  GeneratedColumn<int> get endMinute =>
      $composableBuilder(column: $table.endMinute, builder: (column) => column);

  GeneratedColumn<String> get days =>
      $composableBuilder(column: $table.days, builder: (column) => column);

  GeneratedColumn<DateTime> get muteUntil =>
      $composableBuilder(column: $table.muteUntil, builder: (column) => column);
}

class $$QuietHoursTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $QuietHoursTableTable,
    QuietHoursTableData,
    $$QuietHoursTableTableFilterComposer,
    $$QuietHoursTableTableOrderingComposer,
    $$QuietHoursTableTableAnnotationComposer,
    $$QuietHoursTableTableCreateCompanionBuilder,
    $$QuietHoursTableTableUpdateCompanionBuilder,
    (
      QuietHoursTableData,
      BaseReferences<_$AppDatabase, $QuietHoursTableTable, QuietHoursTableData>
    ),
    QuietHoursTableData,
    PrefetchHooks Function()> {
  $$QuietHoursTableTableTableManager(
      _$AppDatabase db, $QuietHoursTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuietHoursTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuietHoursTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuietHoursTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> connectionId = const Value.absent(),
            Value<int> startMinute = const Value.absent(),
            Value<int> endMinute = const Value.absent(),
            Value<String> days = const Value.absent(),
            Value<DateTime?> muteUntil = const Value.absent(),
          }) =>
              QuietHoursTableCompanion(
            id: id,
            connectionId: connectionId,
            startMinute: startMinute,
            endMinute: endMinute,
            days: days,
            muteUntil: muteUntil,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int connectionId,
            required int startMinute,
            required int endMinute,
            Value<String> days = const Value.absent(),
            Value<DateTime?> muteUntil = const Value.absent(),
          }) =>
              QuietHoursTableCompanion.insert(
            id: id,
            connectionId: connectionId,
            startMinute: startMinute,
            endMinute: endMinute,
            days: days,
            muteUntil: muteUntil,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$QuietHoursTableTable, QuietHoursTableData>(
                        table),
                    BaseReferences<_$AppDatabase, $QuietHoursTableTable,
                        QuietHoursTableData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$QuietHoursTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $QuietHoursTableTable,
    QuietHoursTableData,
    $$QuietHoursTableTableFilterComposer,
    $$QuietHoursTableTableOrderingComposer,
    $$QuietHoursTableTableAnnotationComposer,
    $$QuietHoursTableTableCreateCompanionBuilder,
    $$QuietHoursTableTableUpdateCompanionBuilder,
    (
      QuietHoursTableData,
      BaseReferences<_$AppDatabase, $QuietHoursTableTable, QuietHoursTableData>
    ),
    QuietHoursTableData,
    PrefetchHooks Function()>;
typedef $$TrustedDhcpServersTableTableCreateCompanionBuilder
    = TrustedDhcpServersTableCompanion Function({
  Value<int> id,
  required int connectionId,
  required String serverIp,
  required String interface,
});
typedef $$TrustedDhcpServersTableTableUpdateCompanionBuilder
    = TrustedDhcpServersTableCompanion Function({
  Value<int> id,
  Value<int> connectionId,
  Value<String> serverIp,
  Value<String> interface,
});

class $$TrustedDhcpServersTableTableFilterComposer
    extends Composer<_$AppDatabase, $TrustedDhcpServersTableTable> {
  $$TrustedDhcpServersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get connectionId => $composableBuilder(
      column: $table.connectionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get serverIp => $composableBuilder(
      column: $table.serverIp, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get interface => $composableBuilder(
      column: $table.interface, builder: (column) => ColumnFilters(column));
}

class $$TrustedDhcpServersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TrustedDhcpServersTableTable> {
  $$TrustedDhcpServersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get connectionId => $composableBuilder(
      column: $table.connectionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get serverIp => $composableBuilder(
      column: $table.serverIp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get interface => $composableBuilder(
      column: $table.interface, builder: (column) => ColumnOrderings(column));
}

class $$TrustedDhcpServersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrustedDhcpServersTableTable> {
  $$TrustedDhcpServersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get connectionId => $composableBuilder(
      column: $table.connectionId, builder: (column) => column);

  GeneratedColumn<String> get serverIp =>
      $composableBuilder(column: $table.serverIp, builder: (column) => column);

  GeneratedColumn<String> get interface =>
      $composableBuilder(column: $table.interface, builder: (column) => column);
}

class $$TrustedDhcpServersTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TrustedDhcpServersTableTable,
    TrustedDhcpServersTableData,
    $$TrustedDhcpServersTableTableFilterComposer,
    $$TrustedDhcpServersTableTableOrderingComposer,
    $$TrustedDhcpServersTableTableAnnotationComposer,
    $$TrustedDhcpServersTableTableCreateCompanionBuilder,
    $$TrustedDhcpServersTableTableUpdateCompanionBuilder,
    (
      TrustedDhcpServersTableData,
      BaseReferences<_$AppDatabase, $TrustedDhcpServersTableTable,
          TrustedDhcpServersTableData>
    ),
    TrustedDhcpServersTableData,
    PrefetchHooks Function()> {
  $$TrustedDhcpServersTableTableTableManager(
      _$AppDatabase db, $TrustedDhcpServersTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrustedDhcpServersTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$TrustedDhcpServersTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TrustedDhcpServersTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> connectionId = const Value.absent(),
            Value<String> serverIp = const Value.absent(),
            Value<String> interface = const Value.absent(),
          }) =>
              TrustedDhcpServersTableCompanion(
            id: id,
            connectionId: connectionId,
            serverIp: serverIp,
            interface: interface,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int connectionId,
            required String serverIp,
            required String interface,
          }) =>
              TrustedDhcpServersTableCompanion.insert(
            id: id,
            connectionId: connectionId,
            serverIp: serverIp,
            interface: interface,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$TrustedDhcpServersTableTable,
                        TrustedDhcpServersTableData>(table),
                    BaseReferences<_$AppDatabase, $TrustedDhcpServersTableTable,
                        TrustedDhcpServersTableData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TrustedDhcpServersTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $TrustedDhcpServersTableTable,
        TrustedDhcpServersTableData,
        $$TrustedDhcpServersTableTableFilterComposer,
        $$TrustedDhcpServersTableTableOrderingComposer,
        $$TrustedDhcpServersTableTableAnnotationComposer,
        $$TrustedDhcpServersTableTableCreateCompanionBuilder,
        $$TrustedDhcpServersTableTableUpdateCompanionBuilder,
        (
          TrustedDhcpServersTableData,
          BaseReferences<_$AppDatabase, $TrustedDhcpServersTableTable,
              TrustedDhcpServersTableData>
        ),
        TrustedDhcpServersTableData,
        PrefetchHooks Function()>;
typedef $$InterfaceDailyTableTableCreateCompanionBuilder
    = InterfaceDailyTableCompanion Function({
  Value<int> id,
  required int connectionId,
  required String interface,
  required DateTime date,
  Value<int> rxBytes,
  Value<int> txBytes,
});
typedef $$InterfaceDailyTableTableUpdateCompanionBuilder
    = InterfaceDailyTableCompanion Function({
  Value<int> id,
  Value<int> connectionId,
  Value<String> interface,
  Value<DateTime> date,
  Value<int> rxBytes,
  Value<int> txBytes,
});

class $$InterfaceDailyTableTableFilterComposer
    extends Composer<_$AppDatabase, $InterfaceDailyTableTable> {
  $$InterfaceDailyTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get connectionId => $composableBuilder(
      column: $table.connectionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get interface => $composableBuilder(
      column: $table.interface, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get rxBytes => $composableBuilder(
      column: $table.rxBytes, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get txBytes => $composableBuilder(
      column: $table.txBytes, builder: (column) => ColumnFilters(column));
}

class $$InterfaceDailyTableTableOrderingComposer
    extends Composer<_$AppDatabase, $InterfaceDailyTableTable> {
  $$InterfaceDailyTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get connectionId => $composableBuilder(
      column: $table.connectionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get interface => $composableBuilder(
      column: $table.interface, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get rxBytes => $composableBuilder(
      column: $table.rxBytes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get txBytes => $composableBuilder(
      column: $table.txBytes, builder: (column) => ColumnOrderings(column));
}

class $$InterfaceDailyTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $InterfaceDailyTableTable> {
  $$InterfaceDailyTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get connectionId => $composableBuilder(
      column: $table.connectionId, builder: (column) => column);

  GeneratedColumn<String> get interface =>
      $composableBuilder(column: $table.interface, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get rxBytes =>
      $composableBuilder(column: $table.rxBytes, builder: (column) => column);

  GeneratedColumn<int> get txBytes =>
      $composableBuilder(column: $table.txBytes, builder: (column) => column);
}

class $$InterfaceDailyTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $InterfaceDailyTableTable,
    InterfaceDailyTableData,
    $$InterfaceDailyTableTableFilterComposer,
    $$InterfaceDailyTableTableOrderingComposer,
    $$InterfaceDailyTableTableAnnotationComposer,
    $$InterfaceDailyTableTableCreateCompanionBuilder,
    $$InterfaceDailyTableTableUpdateCompanionBuilder,
    (
      InterfaceDailyTableData,
      BaseReferences<_$AppDatabase, $InterfaceDailyTableTable,
          InterfaceDailyTableData>
    ),
    InterfaceDailyTableData,
    PrefetchHooks Function()> {
  $$InterfaceDailyTableTableTableManager(
      _$AppDatabase db, $InterfaceDailyTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InterfaceDailyTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InterfaceDailyTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InterfaceDailyTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> connectionId = const Value.absent(),
            Value<String> interface = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<int> rxBytes = const Value.absent(),
            Value<int> txBytes = const Value.absent(),
          }) =>
              InterfaceDailyTableCompanion(
            id: id,
            connectionId: connectionId,
            interface: interface,
            date: date,
            rxBytes: rxBytes,
            txBytes: txBytes,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int connectionId,
            required String interface,
            required DateTime date,
            Value<int> rxBytes = const Value.absent(),
            Value<int> txBytes = const Value.absent(),
          }) =>
              InterfaceDailyTableCompanion.insert(
            id: id,
            connectionId: connectionId,
            interface: interface,
            date: date,
            rxBytes: rxBytes,
            txBytes: txBytes,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$InterfaceDailyTableTable,
                        InterfaceDailyTableData>(table),
                    BaseReferences<_$AppDatabase, $InterfaceDailyTableTable,
                        InterfaceDailyTableData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$InterfaceDailyTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $InterfaceDailyTableTable,
    InterfaceDailyTableData,
    $$InterfaceDailyTableTableFilterComposer,
    $$InterfaceDailyTableTableOrderingComposer,
    $$InterfaceDailyTableTableAnnotationComposer,
    $$InterfaceDailyTableTableCreateCompanionBuilder,
    $$InterfaceDailyTableTableUpdateCompanionBuilder,
    (
      InterfaceDailyTableData,
      BaseReferences<_$AppDatabase, $InterfaceDailyTableTable,
          InterfaceDailyTableData>
    ),
    InterfaceDailyTableData,
    PrefetchHooks Function()>;
typedef $$BackupLogTableTableCreateCompanionBuilder = BackupLogTableCompanion
    Function({
  Value<int> id,
  required int connectionId,
  required String kind,
  required String path,
  Value<DateTime> createdAt,
});
typedef $$BackupLogTableTableUpdateCompanionBuilder = BackupLogTableCompanion
    Function({
  Value<int> id,
  Value<int> connectionId,
  Value<String> kind,
  Value<String> path,
  Value<DateTime> createdAt,
});

class $$BackupLogTableTableFilterComposer
    extends Composer<_$AppDatabase, $BackupLogTableTable> {
  $$BackupLogTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get connectionId => $composableBuilder(
      column: $table.connectionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kind => $composableBuilder(
      column: $table.kind, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get path => $composableBuilder(
      column: $table.path, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$BackupLogTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BackupLogTableTable> {
  $$BackupLogTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get connectionId => $composableBuilder(
      column: $table.connectionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kind => $composableBuilder(
      column: $table.kind, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get path => $composableBuilder(
      column: $table.path, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$BackupLogTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BackupLogTableTable> {
  $$BackupLogTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get connectionId => $composableBuilder(
      column: $table.connectionId, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$BackupLogTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BackupLogTableTable,
    BackupLogTableData,
    $$BackupLogTableTableFilterComposer,
    $$BackupLogTableTableOrderingComposer,
    $$BackupLogTableTableAnnotationComposer,
    $$BackupLogTableTableCreateCompanionBuilder,
    $$BackupLogTableTableUpdateCompanionBuilder,
    (
      BackupLogTableData,
      BaseReferences<_$AppDatabase, $BackupLogTableTable, BackupLogTableData>
    ),
    BackupLogTableData,
    PrefetchHooks Function()> {
  $$BackupLogTableTableTableManager(
      _$AppDatabase db, $BackupLogTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BackupLogTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BackupLogTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BackupLogTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> connectionId = const Value.absent(),
            Value<String> kind = const Value.absent(),
            Value<String> path = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              BackupLogTableCompanion(
            id: id,
            connectionId: connectionId,
            kind: kind,
            path: path,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int connectionId,
            required String kind,
            required String path,
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              BackupLogTableCompanion.insert(
            id: id,
            connectionId: connectionId,
            kind: kind,
            path: path,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$BackupLogTableTable, BackupLogTableData>(
                        table),
                    BaseReferences<_$AppDatabase, $BackupLogTableTable,
                        BackupLogTableData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BackupLogTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BackupLogTableTable,
    BackupLogTableData,
    $$BackupLogTableTableFilterComposer,
    $$BackupLogTableTableOrderingComposer,
    $$BackupLogTableTableAnnotationComposer,
    $$BackupLogTableTableCreateCompanionBuilder,
    $$BackupLogTableTableUpdateCompanionBuilder,
    (
      BackupLogTableData,
      BaseReferences<_$AppDatabase, $BackupLogTableTable, BackupLogTableData>
    ),
    BackupLogTableData,
    PrefetchHooks Function()>;
typedef $$TaskCheckpointsTableTableCreateCompanionBuilder
    = TaskCheckpointsTableCompanion Function({
  Value<int> id,
  required String taskId,
  required int connectionId,
  required String taskType,
  Value<int> totalItems,
  Value<int> processedItems,
  Value<int> succeededItems,
  Value<int> failedItems,
  Value<String> payload,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$TaskCheckpointsTableTableUpdateCompanionBuilder
    = TaskCheckpointsTableCompanion Function({
  Value<int> id,
  Value<String> taskId,
  Value<int> connectionId,
  Value<String> taskType,
  Value<int> totalItems,
  Value<int> processedItems,
  Value<int> succeededItems,
  Value<int> failedItems,
  Value<String> payload,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

class $$TaskCheckpointsTableTableFilterComposer
    extends Composer<_$AppDatabase, $TaskCheckpointsTableTable> {
  $$TaskCheckpointsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get taskId => $composableBuilder(
      column: $table.taskId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get connectionId => $composableBuilder(
      column: $table.connectionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get taskType => $composableBuilder(
      column: $table.taskType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalItems => $composableBuilder(
      column: $table.totalItems, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get processedItems => $composableBuilder(
      column: $table.processedItems,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get succeededItems => $composableBuilder(
      column: $table.succeededItems,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get failedItems => $composableBuilder(
      column: $table.failedItems, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$TaskCheckpointsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskCheckpointsTableTable> {
  $$TaskCheckpointsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get taskId => $composableBuilder(
      column: $table.taskId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get connectionId => $composableBuilder(
      column: $table.connectionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get taskType => $composableBuilder(
      column: $table.taskType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalItems => $composableBuilder(
      column: $table.totalItems, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get processedItems => $composableBuilder(
      column: $table.processedItems,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get succeededItems => $composableBuilder(
      column: $table.succeededItems,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get failedItems => $composableBuilder(
      column: $table.failedItems, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$TaskCheckpointsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskCheckpointsTableTable> {
  $$TaskCheckpointsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<int> get connectionId => $composableBuilder(
      column: $table.connectionId, builder: (column) => column);

  GeneratedColumn<String> get taskType =>
      $composableBuilder(column: $table.taskType, builder: (column) => column);

  GeneratedColumn<int> get totalItems => $composableBuilder(
      column: $table.totalItems, builder: (column) => column);

  GeneratedColumn<int> get processedItems => $composableBuilder(
      column: $table.processedItems, builder: (column) => column);

  GeneratedColumn<int> get succeededItems => $composableBuilder(
      column: $table.succeededItems, builder: (column) => column);

  GeneratedColumn<int> get failedItems => $composableBuilder(
      column: $table.failedItems, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TaskCheckpointsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TaskCheckpointsTableTable,
    TaskCheckpointsTableData,
    $$TaskCheckpointsTableTableFilterComposer,
    $$TaskCheckpointsTableTableOrderingComposer,
    $$TaskCheckpointsTableTableAnnotationComposer,
    $$TaskCheckpointsTableTableCreateCompanionBuilder,
    $$TaskCheckpointsTableTableUpdateCompanionBuilder,
    (
      TaskCheckpointsTableData,
      BaseReferences<_$AppDatabase, $TaskCheckpointsTableTable,
          TaskCheckpointsTableData>
    ),
    TaskCheckpointsTableData,
    PrefetchHooks Function()> {
  $$TaskCheckpointsTableTableTableManager(
      _$AppDatabase db, $TaskCheckpointsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskCheckpointsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskCheckpointsTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskCheckpointsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> taskId = const Value.absent(),
            Value<int> connectionId = const Value.absent(),
            Value<String> taskType = const Value.absent(),
            Value<int> totalItems = const Value.absent(),
            Value<int> processedItems = const Value.absent(),
            Value<int> succeededItems = const Value.absent(),
            Value<int> failedItems = const Value.absent(),
            Value<String> payload = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              TaskCheckpointsTableCompanion(
            id: id,
            taskId: taskId,
            connectionId: connectionId,
            taskType: taskType,
            totalItems: totalItems,
            processedItems: processedItems,
            succeededItems: succeededItems,
            failedItems: failedItems,
            payload: payload,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String taskId,
            required int connectionId,
            required String taskType,
            Value<int> totalItems = const Value.absent(),
            Value<int> processedItems = const Value.absent(),
            Value<int> succeededItems = const Value.absent(),
            Value<int> failedItems = const Value.absent(),
            Value<String> payload = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              TaskCheckpointsTableCompanion.insert(
            id: id,
            taskId: taskId,
            connectionId: connectionId,
            taskType: taskType,
            totalItems: totalItems,
            processedItems: processedItems,
            succeededItems: succeededItems,
            failedItems: failedItems,
            payload: payload,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$TaskCheckpointsTableTable,
                        TaskCheckpointsTableData>(table),
                    BaseReferences<_$AppDatabase, $TaskCheckpointsTableTable,
                        TaskCheckpointsTableData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TaskCheckpointsTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $TaskCheckpointsTableTable,
        TaskCheckpointsTableData,
        $$TaskCheckpointsTableTableFilterComposer,
        $$TaskCheckpointsTableTableOrderingComposer,
        $$TaskCheckpointsTableTableAnnotationComposer,
        $$TaskCheckpointsTableTableCreateCompanionBuilder,
        $$TaskCheckpointsTableTableUpdateCompanionBuilder,
        (
          TaskCheckpointsTableData,
          BaseReferences<_$AppDatabase, $TaskCheckpointsTableTable,
              TaskCheckpointsTableData>
        ),
        TaskCheckpointsTableData,
        PrefetchHooks Function()>;
typedef $$UmProfilesCacheTableTableCreateCompanionBuilder
    = UmProfilesCacheTableCompanion Function({
  Value<int> id,
  required int connectionId,
  required String profileName,
  Value<String> owner,
  Value<String> validity,
  Value<String> price,
  Value<String> rawJson,
  Value<DateTime> cachedAt,
});
typedef $$UmProfilesCacheTableTableUpdateCompanionBuilder
    = UmProfilesCacheTableCompanion Function({
  Value<int> id,
  Value<int> connectionId,
  Value<String> profileName,
  Value<String> owner,
  Value<String> validity,
  Value<String> price,
  Value<String> rawJson,
  Value<DateTime> cachedAt,
});

class $$UmProfilesCacheTableTableFilterComposer
    extends Composer<_$AppDatabase, $UmProfilesCacheTableTable> {
  $$UmProfilesCacheTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get connectionId => $composableBuilder(
      column: $table.connectionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profileName => $composableBuilder(
      column: $table.profileName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get owner => $composableBuilder(
      column: $table.owner, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get validity => $composableBuilder(
      column: $table.validity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rawJson => $composableBuilder(
      column: $table.rawJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
      column: $table.cachedAt, builder: (column) => ColumnFilters(column));
}

class $$UmProfilesCacheTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UmProfilesCacheTableTable> {
  $$UmProfilesCacheTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get connectionId => $composableBuilder(
      column: $table.connectionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profileName => $composableBuilder(
      column: $table.profileName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get owner => $composableBuilder(
      column: $table.owner, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get validity => $composableBuilder(
      column: $table.validity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rawJson => $composableBuilder(
      column: $table.rawJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
      column: $table.cachedAt, builder: (column) => ColumnOrderings(column));
}

class $$UmProfilesCacheTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UmProfilesCacheTableTable> {
  $$UmProfilesCacheTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get connectionId => $composableBuilder(
      column: $table.connectionId, builder: (column) => column);

  GeneratedColumn<String> get profileName => $composableBuilder(
      column: $table.profileName, builder: (column) => column);

  GeneratedColumn<String> get owner =>
      $composableBuilder(column: $table.owner, builder: (column) => column);

  GeneratedColumn<String> get validity =>
      $composableBuilder(column: $table.validity, builder: (column) => column);

  GeneratedColumn<String> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<String> get rawJson =>
      $composableBuilder(column: $table.rawJson, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$UmProfilesCacheTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UmProfilesCacheTableTable,
    UmProfilesCacheTableData,
    $$UmProfilesCacheTableTableFilterComposer,
    $$UmProfilesCacheTableTableOrderingComposer,
    $$UmProfilesCacheTableTableAnnotationComposer,
    $$UmProfilesCacheTableTableCreateCompanionBuilder,
    $$UmProfilesCacheTableTableUpdateCompanionBuilder,
    (
      UmProfilesCacheTableData,
      BaseReferences<_$AppDatabase, $UmProfilesCacheTableTable,
          UmProfilesCacheTableData>
    ),
    UmProfilesCacheTableData,
    PrefetchHooks Function()> {
  $$UmProfilesCacheTableTableTableManager(
      _$AppDatabase db, $UmProfilesCacheTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UmProfilesCacheTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UmProfilesCacheTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UmProfilesCacheTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> connectionId = const Value.absent(),
            Value<String> profileName = const Value.absent(),
            Value<String> owner = const Value.absent(),
            Value<String> validity = const Value.absent(),
            Value<String> price = const Value.absent(),
            Value<String> rawJson = const Value.absent(),
            Value<DateTime> cachedAt = const Value.absent(),
          }) =>
              UmProfilesCacheTableCompanion(
            id: id,
            connectionId: connectionId,
            profileName: profileName,
            owner: owner,
            validity: validity,
            price: price,
            rawJson: rawJson,
            cachedAt: cachedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int connectionId,
            required String profileName,
            Value<String> owner = const Value.absent(),
            Value<String> validity = const Value.absent(),
            Value<String> price = const Value.absent(),
            Value<String> rawJson = const Value.absent(),
            Value<DateTime> cachedAt = const Value.absent(),
          }) =>
              UmProfilesCacheTableCompanion.insert(
            id: id,
            connectionId: connectionId,
            profileName: profileName,
            owner: owner,
            validity: validity,
            price: price,
            rawJson: rawJson,
            cachedAt: cachedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$UmProfilesCacheTableTable,
                        UmProfilesCacheTableData>(table),
                    BaseReferences<_$AppDatabase, $UmProfilesCacheTableTable,
                        UmProfilesCacheTableData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UmProfilesCacheTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $UmProfilesCacheTableTable,
        UmProfilesCacheTableData,
        $$UmProfilesCacheTableTableFilterComposer,
        $$UmProfilesCacheTableTableOrderingComposer,
        $$UmProfilesCacheTableTableAnnotationComposer,
        $$UmProfilesCacheTableTableCreateCompanionBuilder,
        $$UmProfilesCacheTableTableUpdateCompanionBuilder,
        (
          UmProfilesCacheTableData,
          BaseReferences<_$AppDatabase, $UmProfilesCacheTableTable,
              UmProfilesCacheTableData>
        ),
        UmProfilesCacheTableData,
        PrefetchHooks Function()>;
typedef $$UmDiagnosticsLogTableTableCreateCompanionBuilder
    = UmDiagnosticsLogTableCompanion Function({
  Value<int> id,
  required int connectionId,
  required String checkKey,
  Value<String> status,
  Value<String> details,
  Value<DateTime> checkedAt,
});
typedef $$UmDiagnosticsLogTableTableUpdateCompanionBuilder
    = UmDiagnosticsLogTableCompanion Function({
  Value<int> id,
  Value<int> connectionId,
  Value<String> checkKey,
  Value<String> status,
  Value<String> details,
  Value<DateTime> checkedAt,
});

class $$UmDiagnosticsLogTableTableFilterComposer
    extends Composer<_$AppDatabase, $UmDiagnosticsLogTableTable> {
  $$UmDiagnosticsLogTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get connectionId => $composableBuilder(
      column: $table.connectionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get checkKey => $composableBuilder(
      column: $table.checkKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get details => $composableBuilder(
      column: $table.details, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get checkedAt => $composableBuilder(
      column: $table.checkedAt, builder: (column) => ColumnFilters(column));
}

class $$UmDiagnosticsLogTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UmDiagnosticsLogTableTable> {
  $$UmDiagnosticsLogTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get connectionId => $composableBuilder(
      column: $table.connectionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get checkKey => $composableBuilder(
      column: $table.checkKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get details => $composableBuilder(
      column: $table.details, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get checkedAt => $composableBuilder(
      column: $table.checkedAt, builder: (column) => ColumnOrderings(column));
}

class $$UmDiagnosticsLogTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UmDiagnosticsLogTableTable> {
  $$UmDiagnosticsLogTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get connectionId => $composableBuilder(
      column: $table.connectionId, builder: (column) => column);

  GeneratedColumn<String> get checkKey =>
      $composableBuilder(column: $table.checkKey, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get details =>
      $composableBuilder(column: $table.details, builder: (column) => column);

  GeneratedColumn<DateTime> get checkedAt =>
      $composableBuilder(column: $table.checkedAt, builder: (column) => column);
}

class $$UmDiagnosticsLogTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UmDiagnosticsLogTableTable,
    UmDiagnosticsLogTableData,
    $$UmDiagnosticsLogTableTableFilterComposer,
    $$UmDiagnosticsLogTableTableOrderingComposer,
    $$UmDiagnosticsLogTableTableAnnotationComposer,
    $$UmDiagnosticsLogTableTableCreateCompanionBuilder,
    $$UmDiagnosticsLogTableTableUpdateCompanionBuilder,
    (
      UmDiagnosticsLogTableData,
      BaseReferences<_$AppDatabase, $UmDiagnosticsLogTableTable,
          UmDiagnosticsLogTableData>
    ),
    UmDiagnosticsLogTableData,
    PrefetchHooks Function()> {
  $$UmDiagnosticsLogTableTableTableManager(
      _$AppDatabase db, $UmDiagnosticsLogTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UmDiagnosticsLogTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$UmDiagnosticsLogTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UmDiagnosticsLogTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> connectionId = const Value.absent(),
            Value<String> checkKey = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> details = const Value.absent(),
            Value<DateTime> checkedAt = const Value.absent(),
          }) =>
              UmDiagnosticsLogTableCompanion(
            id: id,
            connectionId: connectionId,
            checkKey: checkKey,
            status: status,
            details: details,
            checkedAt: checkedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int connectionId,
            required String checkKey,
            Value<String> status = const Value.absent(),
            Value<String> details = const Value.absent(),
            Value<DateTime> checkedAt = const Value.absent(),
          }) =>
              UmDiagnosticsLogTableCompanion.insert(
            id: id,
            connectionId: connectionId,
            checkKey: checkKey,
            status: status,
            details: details,
            checkedAt: checkedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$UmDiagnosticsLogTableTable,
                        UmDiagnosticsLogTableData>(table),
                    BaseReferences<_$AppDatabase, $UmDiagnosticsLogTableTable,
                        UmDiagnosticsLogTableData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UmDiagnosticsLogTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $UmDiagnosticsLogTableTable,
        UmDiagnosticsLogTableData,
        $$UmDiagnosticsLogTableTableFilterComposer,
        $$UmDiagnosticsLogTableTableOrderingComposer,
        $$UmDiagnosticsLogTableTableAnnotationComposer,
        $$UmDiagnosticsLogTableTableCreateCompanionBuilder,
        $$UmDiagnosticsLogTableTableUpdateCompanionBuilder,
        (
          UmDiagnosticsLogTableData,
          BaseReferences<_$AppDatabase, $UmDiagnosticsLogTableTable,
              UmDiagnosticsLogTableData>
        ),
        UmDiagnosticsLogTableData,
        PrefetchHooks Function()>;
typedef $$ResellersTableTableCreateCompanionBuilder = ResellersTableCompanion
    Function({
  Value<int> id,
  required int connectionId,
  required String name,
  Value<String> phone,
  Value<String> notes,
  Value<DateTime> createdAt,
});
typedef $$ResellersTableTableUpdateCompanionBuilder = ResellersTableCompanion
    Function({
  Value<int> id,
  Value<int> connectionId,
  Value<String> name,
  Value<String> phone,
  Value<String> notes,
  Value<DateTime> createdAt,
});

class $$ResellersTableTableFilterComposer
    extends Composer<_$AppDatabase, $ResellersTableTable> {
  $$ResellersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get connectionId => $composableBuilder(
      column: $table.connectionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$ResellersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ResellersTableTable> {
  $$ResellersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get connectionId => $composableBuilder(
      column: $table.connectionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$ResellersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ResellersTableTable> {
  $$ResellersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get connectionId => $composableBuilder(
      column: $table.connectionId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ResellersTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ResellersTableTable,
    ResellersTableData,
    $$ResellersTableTableFilterComposer,
    $$ResellersTableTableOrderingComposer,
    $$ResellersTableTableAnnotationComposer,
    $$ResellersTableTableCreateCompanionBuilder,
    $$ResellersTableTableUpdateCompanionBuilder,
    (
      ResellersTableData,
      BaseReferences<_$AppDatabase, $ResellersTableTable, ResellersTableData>
    ),
    ResellersTableData,
    PrefetchHooks Function()> {
  $$ResellersTableTableTableManager(
      _$AppDatabase db, $ResellersTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ResellersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ResellersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ResellersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> connectionId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> phone = const Value.absent(),
            Value<String> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              ResellersTableCompanion(
            id: id,
            connectionId: connectionId,
            name: name,
            phone: phone,
            notes: notes,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int connectionId,
            required String name,
            Value<String> phone = const Value.absent(),
            Value<String> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              ResellersTableCompanion.insert(
            id: id,
            connectionId: connectionId,
            name: name,
            phone: phone,
            notes: notes,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$ResellersTableTable, ResellersTableData>(
                        table),
                    BaseReferences<_$AppDatabase, $ResellersTableTable,
                        ResellersTableData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ResellersTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ResellersTableTable,
    ResellersTableData,
    $$ResellersTableTableFilterComposer,
    $$ResellersTableTableOrderingComposer,
    $$ResellersTableTableAnnotationComposer,
    $$ResellersTableTableCreateCompanionBuilder,
    $$ResellersTableTableUpdateCompanionBuilder,
    (
      ResellersTableData,
      BaseReferences<_$AppDatabase, $ResellersTableTable, ResellersTableData>
    ),
    ResellersTableData,
    PrefetchHooks Function()>;
typedef $$ResellerAllocationsTableTableCreateCompanionBuilder
    = ResellerAllocationsTableCompanion Function({
  Value<int> id,
  required int resellerId,
  required String batchId,
  required String profile,
  required int quantity,
  required String currency,
  required double unitPrice,
  required double totalValue,
  Value<DateTime> allocatedAt,
});
typedef $$ResellerAllocationsTableTableUpdateCompanionBuilder
    = ResellerAllocationsTableCompanion Function({
  Value<int> id,
  Value<int> resellerId,
  Value<String> batchId,
  Value<String> profile,
  Value<int> quantity,
  Value<String> currency,
  Value<double> unitPrice,
  Value<double> totalValue,
  Value<DateTime> allocatedAt,
});

class $$ResellerAllocationsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ResellerAllocationsTableTable> {
  $$ResellerAllocationsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get resellerId => $composableBuilder(
      column: $table.resellerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get batchId => $composableBuilder(
      column: $table.batchId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profile => $composableBuilder(
      column: $table.profile, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get unitPrice => $composableBuilder(
      column: $table.unitPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalValue => $composableBuilder(
      column: $table.totalValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get allocatedAt => $composableBuilder(
      column: $table.allocatedAt, builder: (column) => ColumnFilters(column));
}

class $$ResellerAllocationsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ResellerAllocationsTableTable> {
  $$ResellerAllocationsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get resellerId => $composableBuilder(
      column: $table.resellerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get batchId => $composableBuilder(
      column: $table.batchId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profile => $composableBuilder(
      column: $table.profile, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get unitPrice => $composableBuilder(
      column: $table.unitPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalValue => $composableBuilder(
      column: $table.totalValue, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get allocatedAt => $composableBuilder(
      column: $table.allocatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ResellerAllocationsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ResellerAllocationsTableTable> {
  $$ResellerAllocationsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get resellerId => $composableBuilder(
      column: $table.resellerId, builder: (column) => column);

  GeneratedColumn<String> get batchId =>
      $composableBuilder(column: $table.batchId, builder: (column) => column);

  GeneratedColumn<String> get profile =>
      $composableBuilder(column: $table.profile, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<double> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

  GeneratedColumn<double> get totalValue => $composableBuilder(
      column: $table.totalValue, builder: (column) => column);

  GeneratedColumn<DateTime> get allocatedAt => $composableBuilder(
      column: $table.allocatedAt, builder: (column) => column);
}

class $$ResellerAllocationsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ResellerAllocationsTableTable,
    ResellerAllocationsTableData,
    $$ResellerAllocationsTableTableFilterComposer,
    $$ResellerAllocationsTableTableOrderingComposer,
    $$ResellerAllocationsTableTableAnnotationComposer,
    $$ResellerAllocationsTableTableCreateCompanionBuilder,
    $$ResellerAllocationsTableTableUpdateCompanionBuilder,
    (
      ResellerAllocationsTableData,
      BaseReferences<_$AppDatabase, $ResellerAllocationsTableTable,
          ResellerAllocationsTableData>
    ),
    ResellerAllocationsTableData,
    PrefetchHooks Function()> {
  $$ResellerAllocationsTableTableTableManager(
      _$AppDatabase db, $ResellerAllocationsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ResellerAllocationsTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$ResellerAllocationsTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ResellerAllocationsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> resellerId = const Value.absent(),
            Value<String> batchId = const Value.absent(),
            Value<String> profile = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<double> unitPrice = const Value.absent(),
            Value<double> totalValue = const Value.absent(),
            Value<DateTime> allocatedAt = const Value.absent(),
          }) =>
              ResellerAllocationsTableCompanion(
            id: id,
            resellerId: resellerId,
            batchId: batchId,
            profile: profile,
            quantity: quantity,
            currency: currency,
            unitPrice: unitPrice,
            totalValue: totalValue,
            allocatedAt: allocatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int resellerId,
            required String batchId,
            required String profile,
            required int quantity,
            required String currency,
            required double unitPrice,
            required double totalValue,
            Value<DateTime> allocatedAt = const Value.absent(),
          }) =>
              ResellerAllocationsTableCompanion.insert(
            id: id,
            resellerId: resellerId,
            batchId: batchId,
            profile: profile,
            quantity: quantity,
            currency: currency,
            unitPrice: unitPrice,
            totalValue: totalValue,
            allocatedAt: allocatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$ResellerAllocationsTableTable,
                        ResellerAllocationsTableData>(table),
                    BaseReferences<
                        _$AppDatabase,
                        $ResellerAllocationsTableTable,
                        ResellerAllocationsTableData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ResellerAllocationsTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $ResellerAllocationsTableTable,
        ResellerAllocationsTableData,
        $$ResellerAllocationsTableTableFilterComposer,
        $$ResellerAllocationsTableTableOrderingComposer,
        $$ResellerAllocationsTableTableAnnotationComposer,
        $$ResellerAllocationsTableTableCreateCompanionBuilder,
        $$ResellerAllocationsTableTableUpdateCompanionBuilder,
        (
          ResellerAllocationsTableData,
          BaseReferences<_$AppDatabase, $ResellerAllocationsTableTable,
              ResellerAllocationsTableData>
        ),
        ResellerAllocationsTableData,
        PrefetchHooks Function()>;
typedef $$ResellerSettlementsTableTableCreateCompanionBuilder
    = ResellerSettlementsTableCompanion Function({
  Value<int> id,
  required int resellerId,
  required String currency,
  required double amountPaid,
  Value<String> notes,
  Value<DateTime> settledAt,
});
typedef $$ResellerSettlementsTableTableUpdateCompanionBuilder
    = ResellerSettlementsTableCompanion Function({
  Value<int> id,
  Value<int> resellerId,
  Value<String> currency,
  Value<double> amountPaid,
  Value<String> notes,
  Value<DateTime> settledAt,
});

class $$ResellerSettlementsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ResellerSettlementsTableTable> {
  $$ResellerSettlementsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get resellerId => $composableBuilder(
      column: $table.resellerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amountPaid => $composableBuilder(
      column: $table.amountPaid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get settledAt => $composableBuilder(
      column: $table.settledAt, builder: (column) => ColumnFilters(column));
}

class $$ResellerSettlementsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ResellerSettlementsTableTable> {
  $$ResellerSettlementsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get resellerId => $composableBuilder(
      column: $table.resellerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amountPaid => $composableBuilder(
      column: $table.amountPaid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get settledAt => $composableBuilder(
      column: $table.settledAt, builder: (column) => ColumnOrderings(column));
}

class $$ResellerSettlementsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ResellerSettlementsTableTable> {
  $$ResellerSettlementsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get resellerId => $composableBuilder(
      column: $table.resellerId, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<double> get amountPaid => $composableBuilder(
      column: $table.amountPaid, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get settledAt =>
      $composableBuilder(column: $table.settledAt, builder: (column) => column);
}

class $$ResellerSettlementsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ResellerSettlementsTableTable,
    ResellerSettlementsTableData,
    $$ResellerSettlementsTableTableFilterComposer,
    $$ResellerSettlementsTableTableOrderingComposer,
    $$ResellerSettlementsTableTableAnnotationComposer,
    $$ResellerSettlementsTableTableCreateCompanionBuilder,
    $$ResellerSettlementsTableTableUpdateCompanionBuilder,
    (
      ResellerSettlementsTableData,
      BaseReferences<_$AppDatabase, $ResellerSettlementsTableTable,
          ResellerSettlementsTableData>
    ),
    ResellerSettlementsTableData,
    PrefetchHooks Function()> {
  $$ResellerSettlementsTableTableTableManager(
      _$AppDatabase db, $ResellerSettlementsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ResellerSettlementsTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$ResellerSettlementsTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ResellerSettlementsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> resellerId = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<double> amountPaid = const Value.absent(),
            Value<String> notes = const Value.absent(),
            Value<DateTime> settledAt = const Value.absent(),
          }) =>
              ResellerSettlementsTableCompanion(
            id: id,
            resellerId: resellerId,
            currency: currency,
            amountPaid: amountPaid,
            notes: notes,
            settledAt: settledAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int resellerId,
            required String currency,
            required double amountPaid,
            Value<String> notes = const Value.absent(),
            Value<DateTime> settledAt = const Value.absent(),
          }) =>
              ResellerSettlementsTableCompanion.insert(
            id: id,
            resellerId: resellerId,
            currency: currency,
            amountPaid: amountPaid,
            notes: notes,
            settledAt: settledAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$ResellerSettlementsTableTable,
                        ResellerSettlementsTableData>(table),
                    BaseReferences<
                        _$AppDatabase,
                        $ResellerSettlementsTableTable,
                        ResellerSettlementsTableData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ResellerSettlementsTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $ResellerSettlementsTableTable,
        ResellerSettlementsTableData,
        $$ResellerSettlementsTableTableFilterComposer,
        $$ResellerSettlementsTableTableOrderingComposer,
        $$ResellerSettlementsTableTableAnnotationComposer,
        $$ResellerSettlementsTableTableCreateCompanionBuilder,
        $$ResellerSettlementsTableTableUpdateCompanionBuilder,
        (
          ResellerSettlementsTableData,
          BaseReferences<_$AppDatabase, $ResellerSettlementsTableTable,
              ResellerSettlementsTableData>
        ),
        ResellerSettlementsTableData,
        PrefetchHooks Function()>;
typedef $$CardSalesTableTableCreateCompanionBuilder = CardSalesTableCompanion
    Function({
  Value<int> id,
  required int connectionId,
  required String saleId,
  Value<String> cardType,
  required String username,
  required String profile,
  Value<double> price,
  Value<double> cost,
  Value<String> soldBy,
  Value<String> paymentMethod,
  Value<String> status,
  Value<String?> customerName,
  Value<String?> customerPhone,
  Value<String?> notes,
  Value<bool> isPrinted,
  Value<DateTime> soldAt,
});
typedef $$CardSalesTableTableUpdateCompanionBuilder = CardSalesTableCompanion
    Function({
  Value<int> id,
  Value<int> connectionId,
  Value<String> saleId,
  Value<String> cardType,
  Value<String> username,
  Value<String> profile,
  Value<double> price,
  Value<double> cost,
  Value<String> soldBy,
  Value<String> paymentMethod,
  Value<String> status,
  Value<String?> customerName,
  Value<String?> customerPhone,
  Value<String?> notes,
  Value<bool> isPrinted,
  Value<DateTime> soldAt,
});

class $$CardSalesTableTableFilterComposer
    extends Composer<_$AppDatabase, $CardSalesTableTable> {
  $$CardSalesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get connectionId => $composableBuilder(
      column: $table.connectionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get saleId => $composableBuilder(
      column: $table.saleId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cardType => $composableBuilder(
      column: $table.cardType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profile => $composableBuilder(
      column: $table.profile, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get cost => $composableBuilder(
      column: $table.cost, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get soldBy => $composableBuilder(
      column: $table.soldBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customerName => $composableBuilder(
      column: $table.customerName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customerPhone => $composableBuilder(
      column: $table.customerPhone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isPrinted => $composableBuilder(
      column: $table.isPrinted, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get soldAt => $composableBuilder(
      column: $table.soldAt, builder: (column) => ColumnFilters(column));
}

class $$CardSalesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CardSalesTableTable> {
  $$CardSalesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get connectionId => $composableBuilder(
      column: $table.connectionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get saleId => $composableBuilder(
      column: $table.saleId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cardType => $composableBuilder(
      column: $table.cardType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profile => $composableBuilder(
      column: $table.profile, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get cost => $composableBuilder(
      column: $table.cost, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get soldBy => $composableBuilder(
      column: $table.soldBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customerName => $composableBuilder(
      column: $table.customerName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customerPhone => $composableBuilder(
      column: $table.customerPhone,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isPrinted => $composableBuilder(
      column: $table.isPrinted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get soldAt => $composableBuilder(
      column: $table.soldAt, builder: (column) => ColumnOrderings(column));
}

class $$CardSalesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CardSalesTableTable> {
  $$CardSalesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get connectionId => $composableBuilder(
      column: $table.connectionId, builder: (column) => column);

  GeneratedColumn<String> get saleId =>
      $composableBuilder(column: $table.saleId, builder: (column) => column);

  GeneratedColumn<String> get cardType =>
      $composableBuilder(column: $table.cardType, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get profile =>
      $composableBuilder(column: $table.profile, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<double> get cost =>
      $composableBuilder(column: $table.cost, builder: (column) => column);

  GeneratedColumn<String> get soldBy =>
      $composableBuilder(column: $table.soldBy, builder: (column) => column);

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get customerName => $composableBuilder(
      column: $table.customerName, builder: (column) => column);

  GeneratedColumn<String> get customerPhone => $composableBuilder(
      column: $table.customerPhone, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isPrinted =>
      $composableBuilder(column: $table.isPrinted, builder: (column) => column);

  GeneratedColumn<DateTime> get soldAt =>
      $composableBuilder(column: $table.soldAt, builder: (column) => column);
}

class $$CardSalesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CardSalesTableTable,
    CardSalesTableData,
    $$CardSalesTableTableFilterComposer,
    $$CardSalesTableTableOrderingComposer,
    $$CardSalesTableTableAnnotationComposer,
    $$CardSalesTableTableCreateCompanionBuilder,
    $$CardSalesTableTableUpdateCompanionBuilder,
    (
      CardSalesTableData,
      BaseReferences<_$AppDatabase, $CardSalesTableTable, CardSalesTableData>
    ),
    CardSalesTableData,
    PrefetchHooks Function()> {
  $$CardSalesTableTableTableManager(
      _$AppDatabase db, $CardSalesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardSalesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardSalesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CardSalesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> connectionId = const Value.absent(),
            Value<String> saleId = const Value.absent(),
            Value<String> cardType = const Value.absent(),
            Value<String> username = const Value.absent(),
            Value<String> profile = const Value.absent(),
            Value<double> price = const Value.absent(),
            Value<double> cost = const Value.absent(),
            Value<String> soldBy = const Value.absent(),
            Value<String> paymentMethod = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> customerName = const Value.absent(),
            Value<String?> customerPhone = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<bool> isPrinted = const Value.absent(),
            Value<DateTime> soldAt = const Value.absent(),
          }) =>
              CardSalesTableCompanion(
            id: id,
            connectionId: connectionId,
            saleId: saleId,
            cardType: cardType,
            username: username,
            profile: profile,
            price: price,
            cost: cost,
            soldBy: soldBy,
            paymentMethod: paymentMethod,
            status: status,
            customerName: customerName,
            customerPhone: customerPhone,
            notes: notes,
            isPrinted: isPrinted,
            soldAt: soldAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int connectionId,
            required String saleId,
            Value<String> cardType = const Value.absent(),
            required String username,
            required String profile,
            Value<double> price = const Value.absent(),
            Value<double> cost = const Value.absent(),
            Value<String> soldBy = const Value.absent(),
            Value<String> paymentMethod = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> customerName = const Value.absent(),
            Value<String?> customerPhone = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<bool> isPrinted = const Value.absent(),
            Value<DateTime> soldAt = const Value.absent(),
          }) =>
              CardSalesTableCompanion.insert(
            id: id,
            connectionId: connectionId,
            saleId: saleId,
            cardType: cardType,
            username: username,
            profile: profile,
            price: price,
            cost: cost,
            soldBy: soldBy,
            paymentMethod: paymentMethod,
            status: status,
            customerName: customerName,
            customerPhone: customerPhone,
            notes: notes,
            isPrinted: isPrinted,
            soldAt: soldAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$CardSalesTableTable, CardSalesTableData>(
                        table),
                    BaseReferences<_$AppDatabase, $CardSalesTableTable,
                        CardSalesTableData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CardSalesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CardSalesTableTable,
    CardSalesTableData,
    $$CardSalesTableTableFilterComposer,
    $$CardSalesTableTableOrderingComposer,
    $$CardSalesTableTableAnnotationComposer,
    $$CardSalesTableTableCreateCompanionBuilder,
    $$CardSalesTableTableUpdateCompanionBuilder,
    (
      CardSalesTableData,
      BaseReferences<_$AppDatabase, $CardSalesTableTable, CardSalesTableData>
    ),
    CardSalesTableData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RoutersTableTableTableManager get routersTable =>
      $$RoutersTableTableTableManager(_db, _db.routersTable);
  $$VoucherBatchesTableTableTableManager get voucherBatchesTable =>
      $$VoucherBatchesTableTableTableManager(_db, _db.voucherBatchesTable);
  $$VoucherTemplatesTableTableTableManager get voucherTemplatesTable =>
      $$VoucherTemplatesTableTableTableManager(_db, _db.voucherTemplatesTable);
  $$SalesReportsTableTableTableManager get salesReportsTable =>
      $$SalesReportsTableTableTableManager(_db, _db.salesReportsTable);
  $$AuditLogsTableTableTableManager get auditLogsTable =>
      $$AuditLogsTableTableTableManager(_db, _db.auditLogsTable);
  $$ProfilePricesTableTableTableManager get profilePricesTable =>
      $$ProfilePricesTableTableTableManager(_db, _db.profilePricesTable);
  $$UsageObservationsTableTableTableManager get usageObservationsTable =>
      $$UsageObservationsTableTableTableManager(
          _db, _db.usageObservationsTable);
  $$CardEventsTableTableTableManager get cardEventsTable =>
      $$CardEventsTableTableTableManager(_db, _db.cardEventsTable);
  $$PaymentsTableTableTableManager get paymentsTable =>
      $$PaymentsTableTableTableManager(_db, _db.paymentsTable);
  $$PdfArchiveTableTableTableManager get pdfArchiveTable =>
      $$PdfArchiveTableTableTableManager(_db, _db.pdfArchiveTable);
  $$ApDevicesTableTableTableManager get apDevicesTable =>
      $$ApDevicesTableTableTableManager(_db, _db.apDevicesTable);
  $$UserApMatchesTableTableTableManager get userApMatchesTable =>
      $$UserApMatchesTableTableTableManager(_db, _db.userApMatchesTable);
  $$TopologySnapshotsTableTableTableManager get topologySnapshotsTable =>
      $$TopologySnapshotsTableTableTableManager(
          _db, _db.topologySnapshotsTable);
  $$AlertRulesTableTableTableManager get alertRulesTable =>
      $$AlertRulesTableTableTableManager(_db, _db.alertRulesTable);
  $$AlertEventsTableTableTableManager get alertEventsTable =>
      $$AlertEventsTableTableTableManager(_db, _db.alertEventsTable);
  $$QuietHoursTableTableTableManager get quietHoursTable =>
      $$QuietHoursTableTableTableManager(_db, _db.quietHoursTable);
  $$TrustedDhcpServersTableTableTableManager get trustedDhcpServersTable =>
      $$TrustedDhcpServersTableTableTableManager(
          _db, _db.trustedDhcpServersTable);
  $$InterfaceDailyTableTableTableManager get interfaceDailyTable =>
      $$InterfaceDailyTableTableTableManager(_db, _db.interfaceDailyTable);
  $$BackupLogTableTableTableManager get backupLogTable =>
      $$BackupLogTableTableTableManager(_db, _db.backupLogTable);
  $$TaskCheckpointsTableTableTableManager get taskCheckpointsTable =>
      $$TaskCheckpointsTableTableTableManager(_db, _db.taskCheckpointsTable);
  $$UmProfilesCacheTableTableTableManager get umProfilesCacheTable =>
      $$UmProfilesCacheTableTableTableManager(_db, _db.umProfilesCacheTable);
  $$UmDiagnosticsLogTableTableTableManager get umDiagnosticsLogTable =>
      $$UmDiagnosticsLogTableTableTableManager(_db, _db.umDiagnosticsLogTable);
  $$ResellersTableTableTableManager get resellersTable =>
      $$ResellersTableTableTableManager(_db, _db.resellersTable);
  $$ResellerAllocationsTableTableTableManager get resellerAllocationsTable =>
      $$ResellerAllocationsTableTableTableManager(
          _db, _db.resellerAllocationsTable);
  $$ResellerSettlementsTableTableTableManager get resellerSettlementsTable =>
      $$ResellerSettlementsTableTableTableManager(
          _db, _db.resellerSettlementsTable);
  $$CardSalesTableTableTableManager get cardSalesTable =>
      $$CardSalesTableTableTableManager(_db, _db.cardSalesTable);
}
