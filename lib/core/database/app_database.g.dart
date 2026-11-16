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
  static const VerificationMeta _primaryColorHexMeta =
      const VerificationMeta('primaryColorHex');
  @override
  late final GeneratedColumn<int> primaryColorHex = GeneratedColumn<int>(
      'primary_color_hex', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0xFF0F172A));
  static const VerificationMeta _fontFamilyMeta =
      const VerificationMeta('fontFamily');
  @override
  late final GeneratedColumn<String> fontFamily = GeneratedColumn<String>(
      'font_family', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Cairo'));
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
        showQrCode,
        showLogo,
        logoPath,
        headerText,
        footerText,
        primaryColorHex,
        fontFamily,
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
    if (data.containsKey('show_qr_code')) {
      context.handle(
          _showQrCodeMeta,
          showQrCode.isAcceptableOrUnknown(
              data['show_qr_code']!, _showQrCodeMeta));
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
    if (data.containsKey('primary_color_hex')) {
      context.handle(
          _primaryColorHexMeta,
          primaryColorHex.isAcceptableOrUnknown(
              data['primary_color_hex']!, _primaryColorHexMeta));
    }
    if (data.containsKey('font_family')) {
      context.handle(
          _fontFamilyMeta,
          fontFamily.isAcceptableOrUnknown(
              data['font_family']!, _fontFamilyMeta));
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
      showQrCode: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show_qr_code'])!,
      showLogo: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show_logo'])!,
      logoPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}logo_path']),
      headerText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}header_text']),
      footerText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}footer_text']),
      primaryColorHex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}primary_color_hex'])!,
      fontFamily: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}font_family'])!,
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
  final bool showQrCode;
  final bool showLogo;
  final String? logoPath;
  final String? headerText;
  final String? footerText;
  final int primaryColorHex;
  final String fontFamily;
  final bool isDefault;
  final DateTime createdAt;
  const VoucherTemplatesTableData(
      {required this.id,
      required this.name,
      required this.paperSize,
      required this.cardsPerRow,
      required this.cardsPerPage,
      required this.showQrCode,
      required this.showLogo,
      this.logoPath,
      this.headerText,
      this.footerText,
      required this.primaryColorHex,
      required this.fontFamily,
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
    map['show_qr_code'] = Variable<bool>(showQrCode);
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
    map['primary_color_hex'] = Variable<int>(primaryColorHex);
    map['font_family'] = Variable<String>(fontFamily);
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
      showQrCode: Value(showQrCode),
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
      primaryColorHex: Value(primaryColorHex),
      fontFamily: Value(fontFamily),
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
      showQrCode: serializer.fromJson<bool>(json['showQrCode']),
      showLogo: serializer.fromJson<bool>(json['showLogo']),
      logoPath: serializer.fromJson<String?>(json['logoPath']),
      headerText: serializer.fromJson<String?>(json['headerText']),
      footerText: serializer.fromJson<String?>(json['footerText']),
      primaryColorHex: serializer.fromJson<int>(json['primaryColorHex']),
      fontFamily: serializer.fromJson<String>(json['fontFamily']),
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
      'showQrCode': serializer.toJson<bool>(showQrCode),
      'showLogo': serializer.toJson<bool>(showLogo),
      'logoPath': serializer.toJson<String?>(logoPath),
      'headerText': serializer.toJson<String?>(headerText),
      'footerText': serializer.toJson<String?>(footerText),
      'primaryColorHex': serializer.toJson<int>(primaryColorHex),
      'fontFamily': serializer.toJson<String>(fontFamily),
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
          bool? showQrCode,
          bool? showLogo,
          Value<String?> logoPath = const Value.absent(),
          Value<String?> headerText = const Value.absent(),
          Value<String?> footerText = const Value.absent(),
          int? primaryColorHex,
          String? fontFamily,
          bool? isDefault,
          DateTime? createdAt}) =>
      VoucherTemplatesTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        paperSize: paperSize ?? this.paperSize,
        cardsPerRow: cardsPerRow ?? this.cardsPerRow,
        cardsPerPage: cardsPerPage ?? this.cardsPerPage,
        showQrCode: showQrCode ?? this.showQrCode,
        showLogo: showLogo ?? this.showLogo,
        logoPath: logoPath.present ? logoPath.value : this.logoPath,
        headerText: headerText.present ? headerText.value : this.headerText,
        footerText: footerText.present ? footerText.value : this.footerText,
        primaryColorHex: primaryColorHex ?? this.primaryColorHex,
        fontFamily: fontFamily ?? this.fontFamily,
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
      showQrCode:
          data.showQrCode.present ? data.showQrCode.value : this.showQrCode,
      showLogo: data.showLogo.present ? data.showLogo.value : this.showLogo,
      logoPath: data.logoPath.present ? data.logoPath.value : this.logoPath,
      headerText:
          data.headerText.present ? data.headerText.value : this.headerText,
      footerText:
          data.footerText.present ? data.footerText.value : this.footerText,
      primaryColorHex: data.primaryColorHex.present
          ? data.primaryColorHex.value
          : this.primaryColorHex,
      fontFamily:
          data.fontFamily.present ? data.fontFamily.value : this.fontFamily,
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
          ..write('showQrCode: $showQrCode, ')
          ..write('showLogo: $showLogo, ')
          ..write('logoPath: $logoPath, ')
          ..write('headerText: $headerText, ')
          ..write('footerText: $footerText, ')
          ..write('primaryColorHex: $primaryColorHex, ')
          ..write('fontFamily: $fontFamily, ')
          ..write('isDefault: $isDefault, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      paperSize,
      cardsPerRow,
      cardsPerPage,
      showQrCode,
      showLogo,
      logoPath,
      headerText,
      footerText,
      primaryColorHex,
      fontFamily,
      isDefault,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VoucherTemplatesTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.paperSize == this.paperSize &&
          other.cardsPerRow == this.cardsPerRow &&
          other.cardsPerPage == this.cardsPerPage &&
          other.showQrCode == this.showQrCode &&
          other.showLogo == this.showLogo &&
          other.logoPath == this.logoPath &&
          other.headerText == this.headerText &&
          other.footerText == this.footerText &&
          other.primaryColorHex == this.primaryColorHex &&
          other.fontFamily == this.fontFamily &&
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
  final Value<bool> showQrCode;
  final Value<bool> showLogo;
  final Value<String?> logoPath;
  final Value<String?> headerText;
  final Value<String?> footerText;
  final Value<int> primaryColorHex;
  final Value<String> fontFamily;
  final Value<bool> isDefault;
  final Value<DateTime> createdAt;
  const VoucherTemplatesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.paperSize = const Value.absent(),
    this.cardsPerRow = const Value.absent(),
    this.cardsPerPage = const Value.absent(),
    this.showQrCode = const Value.absent(),
    this.showLogo = const Value.absent(),
    this.logoPath = const Value.absent(),
    this.headerText = const Value.absent(),
    this.footerText = const Value.absent(),
    this.primaryColorHex = const Value.absent(),
    this.fontFamily = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  VoucherTemplatesTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.paperSize = const Value.absent(),
    this.cardsPerRow = const Value.absent(),
    this.cardsPerPage = const Value.absent(),
    this.showQrCode = const Value.absent(),
    this.showLogo = const Value.absent(),
    this.logoPath = const Value.absent(),
    this.headerText = const Value.absent(),
    this.footerText = const Value.absent(),
    this.primaryColorHex = const Value.absent(),
    this.fontFamily = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<VoucherTemplatesTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? paperSize,
    Expression<int>? cardsPerRow,
    Expression<int>? cardsPerPage,
    Expression<bool>? showQrCode,
    Expression<bool>? showLogo,
    Expression<String>? logoPath,
    Expression<String>? headerText,
    Expression<String>? footerText,
    Expression<int>? primaryColorHex,
    Expression<String>? fontFamily,
    Expression<bool>? isDefault,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (paperSize != null) 'paper_size': paperSize,
      if (cardsPerRow != null) 'cards_per_row': cardsPerRow,
      if (cardsPerPage != null) 'cards_per_page': cardsPerPage,
      if (showQrCode != null) 'show_qr_code': showQrCode,
      if (showLogo != null) 'show_logo': showLogo,
      if (logoPath != null) 'logo_path': logoPath,
      if (headerText != null) 'header_text': headerText,
      if (footerText != null) 'footer_text': footerText,
      if (primaryColorHex != null) 'primary_color_hex': primaryColorHex,
      if (fontFamily != null) 'font_family': fontFamily,
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
      Value<bool>? showQrCode,
      Value<bool>? showLogo,
      Value<String?>? logoPath,
      Value<String?>? headerText,
      Value<String?>? footerText,
      Value<int>? primaryColorHex,
      Value<String>? fontFamily,
      Value<bool>? isDefault,
      Value<DateTime>? createdAt}) {
    return VoucherTemplatesTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      paperSize: paperSize ?? this.paperSize,
      cardsPerRow: cardsPerRow ?? this.cardsPerRow,
      cardsPerPage: cardsPerPage ?? this.cardsPerPage,
      showQrCode: showQrCode ?? this.showQrCode,
      showLogo: showLogo ?? this.showLogo,
      logoPath: logoPath ?? this.logoPath,
      headerText: headerText ?? this.headerText,
      footerText: footerText ?? this.footerText,
      primaryColorHex: primaryColorHex ?? this.primaryColorHex,
      fontFamily: fontFamily ?? this.fontFamily,
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
    if (showQrCode.present) {
      map['show_qr_code'] = Variable<bool>(showQrCode.value);
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
    if (primaryColorHex.present) {
      map['primary_color_hex'] = Variable<int>(primaryColorHex.value);
    }
    if (fontFamily.present) {
      map['font_family'] = Variable<String>(fontFamily.value);
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
          ..write('showQrCode: $showQrCode, ')
          ..write('showLogo: $showLogo, ')
          ..write('logoPath: $logoPath, ')
          ..write('headerText: $headerText, ')
          ..write('footerText: $footerText, ')
          ..write('primaryColorHex: $primaryColorHex, ')
          ..write('fontFamily: $fontFamily, ')
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
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        routersTable,
        voucherBatchesTable,
        voucherTemplatesTable,
        salesReportsTable,
        auditLogsTable
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
  Value<bool> showQrCode,
  Value<bool> showLogo,
  Value<String?> logoPath,
  Value<String?> headerText,
  Value<String?> footerText,
  Value<int> primaryColorHex,
  Value<String> fontFamily,
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
  Value<bool> showQrCode,
  Value<bool> showLogo,
  Value<String?> logoPath,
  Value<String?> headerText,
  Value<String?> footerText,
  Value<int> primaryColorHex,
  Value<String> fontFamily,
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

  ColumnFilters<bool> get showQrCode => $composableBuilder(
      column: $table.showQrCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get showLogo => $composableBuilder(
      column: $table.showLogo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get logoPath => $composableBuilder(
      column: $table.logoPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get headerText => $composableBuilder(
      column: $table.headerText, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get footerText => $composableBuilder(
      column: $table.footerText, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get primaryColorHex => $composableBuilder(
      column: $table.primaryColorHex,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fontFamily => $composableBuilder(
      column: $table.fontFamily, builder: (column) => ColumnFilters(column));

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

  ColumnOrderings<bool> get showQrCode => $composableBuilder(
      column: $table.showQrCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get showLogo => $composableBuilder(
      column: $table.showLogo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get logoPath => $composableBuilder(
      column: $table.logoPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get headerText => $composableBuilder(
      column: $table.headerText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get footerText => $composableBuilder(
      column: $table.footerText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get primaryColorHex => $composableBuilder(
      column: $table.primaryColorHex,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fontFamily => $composableBuilder(
      column: $table.fontFamily, builder: (column) => ColumnOrderings(column));

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

  GeneratedColumn<bool> get showQrCode => $composableBuilder(
      column: $table.showQrCode, builder: (column) => column);

  GeneratedColumn<bool> get showLogo =>
      $composableBuilder(column: $table.showLogo, builder: (column) => column);

  GeneratedColumn<String> get logoPath =>
      $composableBuilder(column: $table.logoPath, builder: (column) => column);

  GeneratedColumn<String> get headerText => $composableBuilder(
      column: $table.headerText, builder: (column) => column);

  GeneratedColumn<String> get footerText => $composableBuilder(
      column: $table.footerText, builder: (column) => column);

  GeneratedColumn<int> get primaryColorHex => $composableBuilder(
      column: $table.primaryColorHex, builder: (column) => column);

  GeneratedColumn<String> get fontFamily => $composableBuilder(
      column: $table.fontFamily, builder: (column) => column);

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
            Value<bool> showQrCode = const Value.absent(),
            Value<bool> showLogo = const Value.absent(),
            Value<String?> logoPath = const Value.absent(),
            Value<String?> headerText = const Value.absent(),
            Value<String?> footerText = const Value.absent(),
            Value<int> primaryColorHex = const Value.absent(),
            Value<String> fontFamily = const Value.absent(),
            Value<bool> isDefault = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              VoucherTemplatesTableCompanion(
            id: id,
            name: name,
            paperSize: paperSize,
            cardsPerRow: cardsPerRow,
            cardsPerPage: cardsPerPage,
            showQrCode: showQrCode,
            showLogo: showLogo,
            logoPath: logoPath,
            headerText: headerText,
            footerText: footerText,
            primaryColorHex: primaryColorHex,
            fontFamily: fontFamily,
            isDefault: isDefault,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String> paperSize = const Value.absent(),
            Value<int> cardsPerRow = const Value.absent(),
            Value<int> cardsPerPage = const Value.absent(),
            Value<bool> showQrCode = const Value.absent(),
            Value<bool> showLogo = const Value.absent(),
            Value<String?> logoPath = const Value.absent(),
            Value<String?> headerText = const Value.absent(),
            Value<String?> footerText = const Value.absent(),
            Value<int> primaryColorHex = const Value.absent(),
            Value<String> fontFamily = const Value.absent(),
            Value<bool> isDefault = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              VoucherTemplatesTableCompanion.insert(
            id: id,
            name: name,
            paperSize: paperSize,
            cardsPerRow: cardsPerRow,
            cardsPerPage: cardsPerPage,
            showQrCode: showQrCode,
            showLogo: showLogo,
            logoPath: logoPath,
            headerText: headerText,
            footerText: footerText,
            primaryColorHex: primaryColorHex,
            fontFamily: fontFamily,
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
}
