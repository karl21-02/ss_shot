// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ScreenshotsTable extends Screenshots
    with TableInfo<$ScreenshotsTable, Screenshot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScreenshotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  @override
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
    'local_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fullTextMeta = const VerificationMeta(
    'fullText',
  );
  @override
  late final GeneratedColumn<String> fullText = GeneratedColumn<String>(
    'full_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ocrJsonMeta = const VerificationMeta(
    'ocrJson',
  );
  @override
  late final GeneratedColumn<String> ocrJson = GeneratedColumn<String>(
    'ocr_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ScreenshotCategory, String>
  category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: Constant(ScreenshotCategory.other.name),
  ).withConverter<ScreenshotCategory>($ScreenshotsTable.$convertercategory);
  static const VerificationMeta _isOcrProcessedMeta = const VerificationMeta(
    'isOcrProcessed',
  );
  @override
  late final GeneratedColumn<bool> isOcrProcessed = GeneratedColumn<bool>(
    'is_ocr_processed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_ocr_processed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _capturedAtMeta = const VerificationMeta(
    'capturedAt',
  );
  @override
  late final GeneratedColumn<DateTime> capturedAt = GeneratedColumn<DateTime>(
    'captured_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    localId,
    filePath,
    fullText,
    ocrJson,
    category,
    isOcrProcessed,
    isSynced,
    isDeleted,
    capturedAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'screenshots';
  @override
  VerificationContext validateIntegrity(
    Insertable<Screenshot> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    } else if (isInserting) {
      context.missing(_localIdMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('full_text')) {
      context.handle(
        _fullTextMeta,
        fullText.isAcceptableOrUnknown(data['full_text']!, _fullTextMeta),
      );
    }
    if (data.containsKey('ocr_json')) {
      context.handle(
        _ocrJsonMeta,
        ocrJson.isAcceptableOrUnknown(data['ocr_json']!, _ocrJsonMeta),
      );
    }
    if (data.containsKey('is_ocr_processed')) {
      context.handle(
        _isOcrProcessedMeta,
        isOcrProcessed.isAcceptableOrUnknown(
          data['is_ocr_processed']!,
          _isOcrProcessedMeta,
        ),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('captured_at')) {
      context.handle(
        _capturedAtMeta,
        capturedAt.isAcceptableOrUnknown(data['captured_at']!, _capturedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_capturedAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Screenshot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Screenshot(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      localId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_id'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      fullText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_text'],
      ),
      ocrJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ocr_json'],
      ),
      category: $ScreenshotsTable.$convertercategory.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}category'],
        )!,
      ),
      isOcrProcessed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_ocr_processed'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      capturedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}captured_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ScreenshotsTable createAlias(String alias) {
    return $ScreenshotsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ScreenshotCategory, String, String>
  $convertercategory = const EnumNameConverter<ScreenshotCategory>(
    ScreenshotCategory.values,
  );
}

class Screenshot extends DataClass implements Insertable<Screenshot> {
  final int id;
  final String localId;
  final String filePath;
  final String? fullText;
  final String? ocrJson;
  final ScreenshotCategory category;
  final bool isOcrProcessed;
  final bool isSynced;
  final bool isDeleted;
  final DateTime capturedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Screenshot({
    required this.id,
    required this.localId,
    required this.filePath,
    this.fullText,
    this.ocrJson,
    required this.category,
    required this.isOcrProcessed,
    required this.isSynced,
    required this.isDeleted,
    required this.capturedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['local_id'] = Variable<String>(localId);
    map['file_path'] = Variable<String>(filePath);
    if (!nullToAbsent || fullText != null) {
      map['full_text'] = Variable<String>(fullText);
    }
    if (!nullToAbsent || ocrJson != null) {
      map['ocr_json'] = Variable<String>(ocrJson);
    }
    {
      map['category'] = Variable<String>(
        $ScreenshotsTable.$convertercategory.toSql(category),
      );
    }
    map['is_ocr_processed'] = Variable<bool>(isOcrProcessed);
    map['is_synced'] = Variable<bool>(isSynced);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['captured_at'] = Variable<DateTime>(capturedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ScreenshotsCompanion toCompanion(bool nullToAbsent) {
    return ScreenshotsCompanion(
      id: Value(id),
      localId: Value(localId),
      filePath: Value(filePath),
      fullText: fullText == null && nullToAbsent
          ? const Value.absent()
          : Value(fullText),
      ocrJson: ocrJson == null && nullToAbsent
          ? const Value.absent()
          : Value(ocrJson),
      category: Value(category),
      isOcrProcessed: Value(isOcrProcessed),
      isSynced: Value(isSynced),
      isDeleted: Value(isDeleted),
      capturedAt: Value(capturedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Screenshot.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Screenshot(
      id: serializer.fromJson<int>(json['id']),
      localId: serializer.fromJson<String>(json['localId']),
      filePath: serializer.fromJson<String>(json['filePath']),
      fullText: serializer.fromJson<String?>(json['fullText']),
      ocrJson: serializer.fromJson<String?>(json['ocrJson']),
      category: $ScreenshotsTable.$convertercategory.fromJson(
        serializer.fromJson<String>(json['category']),
      ),
      isOcrProcessed: serializer.fromJson<bool>(json['isOcrProcessed']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      capturedAt: serializer.fromJson<DateTime>(json['capturedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'localId': serializer.toJson<String>(localId),
      'filePath': serializer.toJson<String>(filePath),
      'fullText': serializer.toJson<String?>(fullText),
      'ocrJson': serializer.toJson<String?>(ocrJson),
      'category': serializer.toJson<String>(
        $ScreenshotsTable.$convertercategory.toJson(category),
      ),
      'isOcrProcessed': serializer.toJson<bool>(isOcrProcessed),
      'isSynced': serializer.toJson<bool>(isSynced),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'capturedAt': serializer.toJson<DateTime>(capturedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Screenshot copyWith({
    int? id,
    String? localId,
    String? filePath,
    Value<String?> fullText = const Value.absent(),
    Value<String?> ocrJson = const Value.absent(),
    ScreenshotCategory? category,
    bool? isOcrProcessed,
    bool? isSynced,
    bool? isDeleted,
    DateTime? capturedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Screenshot(
    id: id ?? this.id,
    localId: localId ?? this.localId,
    filePath: filePath ?? this.filePath,
    fullText: fullText.present ? fullText.value : this.fullText,
    ocrJson: ocrJson.present ? ocrJson.value : this.ocrJson,
    category: category ?? this.category,
    isOcrProcessed: isOcrProcessed ?? this.isOcrProcessed,
    isSynced: isSynced ?? this.isSynced,
    isDeleted: isDeleted ?? this.isDeleted,
    capturedAt: capturedAt ?? this.capturedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Screenshot copyWithCompanion(ScreenshotsCompanion data) {
    return Screenshot(
      id: data.id.present ? data.id.value : this.id,
      localId: data.localId.present ? data.localId.value : this.localId,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      fullText: data.fullText.present ? data.fullText.value : this.fullText,
      ocrJson: data.ocrJson.present ? data.ocrJson.value : this.ocrJson,
      category: data.category.present ? data.category.value : this.category,
      isOcrProcessed: data.isOcrProcessed.present
          ? data.isOcrProcessed.value
          : this.isOcrProcessed,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      capturedAt: data.capturedAt.present
          ? data.capturedAt.value
          : this.capturedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Screenshot(')
          ..write('id: $id, ')
          ..write('localId: $localId, ')
          ..write('filePath: $filePath, ')
          ..write('fullText: $fullText, ')
          ..write('ocrJson: $ocrJson, ')
          ..write('category: $category, ')
          ..write('isOcrProcessed: $isOcrProcessed, ')
          ..write('isSynced: $isSynced, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('capturedAt: $capturedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    localId,
    filePath,
    fullText,
    ocrJson,
    category,
    isOcrProcessed,
    isSynced,
    isDeleted,
    capturedAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Screenshot &&
          other.id == this.id &&
          other.localId == this.localId &&
          other.filePath == this.filePath &&
          other.fullText == this.fullText &&
          other.ocrJson == this.ocrJson &&
          other.category == this.category &&
          other.isOcrProcessed == this.isOcrProcessed &&
          other.isSynced == this.isSynced &&
          other.isDeleted == this.isDeleted &&
          other.capturedAt == this.capturedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ScreenshotsCompanion extends UpdateCompanion<Screenshot> {
  final Value<int> id;
  final Value<String> localId;
  final Value<String> filePath;
  final Value<String?> fullText;
  final Value<String?> ocrJson;
  final Value<ScreenshotCategory> category;
  final Value<bool> isOcrProcessed;
  final Value<bool> isSynced;
  final Value<bool> isDeleted;
  final Value<DateTime> capturedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ScreenshotsCompanion({
    this.id = const Value.absent(),
    this.localId = const Value.absent(),
    this.filePath = const Value.absent(),
    this.fullText = const Value.absent(),
    this.ocrJson = const Value.absent(),
    this.category = const Value.absent(),
    this.isOcrProcessed = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.capturedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ScreenshotsCompanion.insert({
    this.id = const Value.absent(),
    required String localId,
    required String filePath,
    this.fullText = const Value.absent(),
    this.ocrJson = const Value.absent(),
    this.category = const Value.absent(),
    this.isOcrProcessed = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.isDeleted = const Value.absent(),
    required DateTime capturedAt,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : localId = Value(localId),
       filePath = Value(filePath),
       capturedAt = Value(capturedAt);
  static Insertable<Screenshot> custom({
    Expression<int>? id,
    Expression<String>? localId,
    Expression<String>? filePath,
    Expression<String>? fullText,
    Expression<String>? ocrJson,
    Expression<String>? category,
    Expression<bool>? isOcrProcessed,
    Expression<bool>? isSynced,
    Expression<bool>? isDeleted,
    Expression<DateTime>? capturedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (localId != null) 'local_id': localId,
      if (filePath != null) 'file_path': filePath,
      if (fullText != null) 'full_text': fullText,
      if (ocrJson != null) 'ocr_json': ocrJson,
      if (category != null) 'category': category,
      if (isOcrProcessed != null) 'is_ocr_processed': isOcrProcessed,
      if (isSynced != null) 'is_synced': isSynced,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (capturedAt != null) 'captured_at': capturedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ScreenshotsCompanion copyWith({
    Value<int>? id,
    Value<String>? localId,
    Value<String>? filePath,
    Value<String?>? fullText,
    Value<String?>? ocrJson,
    Value<ScreenshotCategory>? category,
    Value<bool>? isOcrProcessed,
    Value<bool>? isSynced,
    Value<bool>? isDeleted,
    Value<DateTime>? capturedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return ScreenshotsCompanion(
      id: id ?? this.id,
      localId: localId ?? this.localId,
      filePath: filePath ?? this.filePath,
      fullText: fullText ?? this.fullText,
      ocrJson: ocrJson ?? this.ocrJson,
      category: category ?? this.category,
      isOcrProcessed: isOcrProcessed ?? this.isOcrProcessed,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
      capturedAt: capturedAt ?? this.capturedAt,
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
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (fullText.present) {
      map['full_text'] = Variable<String>(fullText.value);
    }
    if (ocrJson.present) {
      map['ocr_json'] = Variable<String>(ocrJson.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(
        $ScreenshotsTable.$convertercategory.toSql(category.value),
      );
    }
    if (isOcrProcessed.present) {
      map['is_ocr_processed'] = Variable<bool>(isOcrProcessed.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (capturedAt.present) {
      map['captured_at'] = Variable<DateTime>(capturedAt.value);
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
    return (StringBuffer('ScreenshotsCompanion(')
          ..write('id: $id, ')
          ..write('localId: $localId, ')
          ..write('filePath: $filePath, ')
          ..write('fullText: $fullText, ')
          ..write('ocrJson: $ocrJson, ')
          ..write('category: $category, ')
          ..write('isOcrProcessed: $isOcrProcessed, ')
          ..write('isSynced: $isSynced, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('capturedAt: $capturedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $PendingSyncTable extends PendingSync
    with TableInfo<$PendingSyncTable, PendingSyncData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PendingSyncTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _screenshotIdMeta = const VerificationMeta(
    'screenshotId',
  );
  @override
  late final GeneratedColumn<int> screenshotId = GeneratedColumn<int>(
    'screenshot_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES screenshots (id)',
    ),
  );
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, screenshotId, action, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pending_sync';
  @override
  VerificationContext validateIntegrity(
    Insertable<PendingSyncData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('screenshot_id')) {
      context.handle(
        _screenshotIdMeta,
        screenshotId.isAcceptableOrUnknown(
          data['screenshot_id']!,
          _screenshotIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_screenshotIdMeta);
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PendingSyncData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PendingSyncData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      screenshotId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}screenshot_id'],
      )!,
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PendingSyncTable createAlias(String alias) {
    return $PendingSyncTable(attachedDatabase, alias);
  }
}

class PendingSyncData extends DataClass implements Insertable<PendingSyncData> {
  final int id;
  final int screenshotId;
  final String action;
  final DateTime createdAt;
  const PendingSyncData({
    required this.id,
    required this.screenshotId,
    required this.action,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['screenshot_id'] = Variable<int>(screenshotId);
    map['action'] = Variable<String>(action);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PendingSyncCompanion toCompanion(bool nullToAbsent) {
    return PendingSyncCompanion(
      id: Value(id),
      screenshotId: Value(screenshotId),
      action: Value(action),
      createdAt: Value(createdAt),
    );
  }

  factory PendingSyncData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PendingSyncData(
      id: serializer.fromJson<int>(json['id']),
      screenshotId: serializer.fromJson<int>(json['screenshotId']),
      action: serializer.fromJson<String>(json['action']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'screenshotId': serializer.toJson<int>(screenshotId),
      'action': serializer.toJson<String>(action),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PendingSyncData copyWith({
    int? id,
    int? screenshotId,
    String? action,
    DateTime? createdAt,
  }) => PendingSyncData(
    id: id ?? this.id,
    screenshotId: screenshotId ?? this.screenshotId,
    action: action ?? this.action,
    createdAt: createdAt ?? this.createdAt,
  );
  PendingSyncData copyWithCompanion(PendingSyncCompanion data) {
    return PendingSyncData(
      id: data.id.present ? data.id.value : this.id,
      screenshotId: data.screenshotId.present
          ? data.screenshotId.value
          : this.screenshotId,
      action: data.action.present ? data.action.value : this.action,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PendingSyncData(')
          ..write('id: $id, ')
          ..write('screenshotId: $screenshotId, ')
          ..write('action: $action, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, screenshotId, action, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingSyncData &&
          other.id == this.id &&
          other.screenshotId == this.screenshotId &&
          other.action == this.action &&
          other.createdAt == this.createdAt);
}

class PendingSyncCompanion extends UpdateCompanion<PendingSyncData> {
  final Value<int> id;
  final Value<int> screenshotId;
  final Value<String> action;
  final Value<DateTime> createdAt;
  const PendingSyncCompanion({
    this.id = const Value.absent(),
    this.screenshotId = const Value.absent(),
    this.action = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PendingSyncCompanion.insert({
    this.id = const Value.absent(),
    required int screenshotId,
    required String action,
    this.createdAt = const Value.absent(),
  }) : screenshotId = Value(screenshotId),
       action = Value(action);
  static Insertable<PendingSyncData> custom({
    Expression<int>? id,
    Expression<int>? screenshotId,
    Expression<String>? action,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (screenshotId != null) 'screenshot_id': screenshotId,
      if (action != null) 'action': action,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PendingSyncCompanion copyWith({
    Value<int>? id,
    Value<int>? screenshotId,
    Value<String>? action,
    Value<DateTime>? createdAt,
  }) {
    return PendingSyncCompanion(
      id: id ?? this.id,
      screenshotId: screenshotId ?? this.screenshotId,
      action: action ?? this.action,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (screenshotId.present) {
      map['screenshot_id'] = Variable<int>(screenshotId.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PendingSyncCompanion(')
          ..write('id: $id, ')
          ..write('screenshotId: $screenshotId, ')
          ..write('action: $action, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ScreenshotsTable screenshots = $ScreenshotsTable(this);
  late final $PendingSyncTable pendingSync = $PendingSyncTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    screenshots,
    pendingSync,
  ];
}

typedef $$ScreenshotsTableCreateCompanionBuilder =
    ScreenshotsCompanion Function({
      Value<int> id,
      required String localId,
      required String filePath,
      Value<String?> fullText,
      Value<String?> ocrJson,
      Value<ScreenshotCategory> category,
      Value<bool> isOcrProcessed,
      Value<bool> isSynced,
      Value<bool> isDeleted,
      required DateTime capturedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$ScreenshotsTableUpdateCompanionBuilder =
    ScreenshotsCompanion Function({
      Value<int> id,
      Value<String> localId,
      Value<String> filePath,
      Value<String?> fullText,
      Value<String?> ocrJson,
      Value<ScreenshotCategory> category,
      Value<bool> isOcrProcessed,
      Value<bool> isSynced,
      Value<bool> isDeleted,
      Value<DateTime> capturedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$ScreenshotsTableReferences
    extends BaseReferences<_$AppDatabase, $ScreenshotsTable, Screenshot> {
  $$ScreenshotsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PendingSyncTable, List<PendingSyncData>>
  _pendingSyncRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.pendingSync,
    aliasName: $_aliasNameGenerator(
      db.screenshots.id,
      db.pendingSync.screenshotId,
    ),
  );

  $$PendingSyncTableProcessedTableManager get pendingSyncRefs {
    final manager = $$PendingSyncTableTableManager(
      $_db,
      $_db.pendingSync,
    ).filter((f) => f.screenshotId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_pendingSyncRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ScreenshotsTableFilterComposer
    extends Composer<_$AppDatabase, $ScreenshotsTable> {
  $$ScreenshotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fullText => $composableBuilder(
    column: $table.fullText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ocrJson => $composableBuilder(
    column: $table.ocrJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ScreenshotCategory, ScreenshotCategory, String>
  get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get isOcrProcessed => $composableBuilder(
    column: $table.isOcrProcessed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> pendingSyncRefs(
    Expression<bool> Function($$PendingSyncTableFilterComposer f) f,
  ) {
    final $$PendingSyncTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pendingSync,
      getReferencedColumn: (t) => t.screenshotId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PendingSyncTableFilterComposer(
            $db: $db,
            $table: $db.pendingSync,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ScreenshotsTableOrderingComposer
    extends Composer<_$AppDatabase, $ScreenshotsTable> {
  $$ScreenshotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullText => $composableBuilder(
    column: $table.fullText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ocrJson => $composableBuilder(
    column: $table.ocrJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isOcrProcessed => $composableBuilder(
    column: $table.isOcrProcessed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ScreenshotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScreenshotsTable> {
  $$ScreenshotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get fullText =>
      $composableBuilder(column: $table.fullText, builder: (column) => column);

  GeneratedColumn<String> get ocrJson =>
      $composableBuilder(column: $table.ocrJson, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ScreenshotCategory, String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<bool> get isOcrProcessed => $composableBuilder(
    column: $table.isOcrProcessed,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> pendingSyncRefs<T extends Object>(
    Expression<T> Function($$PendingSyncTableAnnotationComposer a) f,
  ) {
    final $$PendingSyncTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pendingSync,
      getReferencedColumn: (t) => t.screenshotId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PendingSyncTableAnnotationComposer(
            $db: $db,
            $table: $db.pendingSync,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ScreenshotsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ScreenshotsTable,
          Screenshot,
          $$ScreenshotsTableFilterComposer,
          $$ScreenshotsTableOrderingComposer,
          $$ScreenshotsTableAnnotationComposer,
          $$ScreenshotsTableCreateCompanionBuilder,
          $$ScreenshotsTableUpdateCompanionBuilder,
          (Screenshot, $$ScreenshotsTableReferences),
          Screenshot,
          PrefetchHooks Function({bool pendingSyncRefs})
        > {
  $$ScreenshotsTableTableManager(_$AppDatabase db, $ScreenshotsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScreenshotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScreenshotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScreenshotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> localId = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<String?> fullText = const Value.absent(),
                Value<String?> ocrJson = const Value.absent(),
                Value<ScreenshotCategory> category = const Value.absent(),
                Value<bool> isOcrProcessed = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime> capturedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ScreenshotsCompanion(
                id: id,
                localId: localId,
                filePath: filePath,
                fullText: fullText,
                ocrJson: ocrJson,
                category: category,
                isOcrProcessed: isOcrProcessed,
                isSynced: isSynced,
                isDeleted: isDeleted,
                capturedAt: capturedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String localId,
                required String filePath,
                Value<String?> fullText = const Value.absent(),
                Value<String?> ocrJson = const Value.absent(),
                Value<ScreenshotCategory> category = const Value.absent(),
                Value<bool> isOcrProcessed = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                required DateTime capturedAt,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ScreenshotsCompanion.insert(
                id: id,
                localId: localId,
                filePath: filePath,
                fullText: fullText,
                ocrJson: ocrJson,
                category: category,
                isOcrProcessed: isOcrProcessed,
                isSynced: isSynced,
                isDeleted: isDeleted,
                capturedAt: capturedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ScreenshotsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({pendingSyncRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (pendingSyncRefs) db.pendingSync],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (pendingSyncRefs)
                    await $_getPrefetchedData<
                      Screenshot,
                      $ScreenshotsTable,
                      PendingSyncData
                    >(
                      currentTable: table,
                      referencedTable: $$ScreenshotsTableReferences
                          ._pendingSyncRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ScreenshotsTableReferences(
                            db,
                            table,
                            p0,
                          ).pendingSyncRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.screenshotId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ScreenshotsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ScreenshotsTable,
      Screenshot,
      $$ScreenshotsTableFilterComposer,
      $$ScreenshotsTableOrderingComposer,
      $$ScreenshotsTableAnnotationComposer,
      $$ScreenshotsTableCreateCompanionBuilder,
      $$ScreenshotsTableUpdateCompanionBuilder,
      (Screenshot, $$ScreenshotsTableReferences),
      Screenshot,
      PrefetchHooks Function({bool pendingSyncRefs})
    >;
typedef $$PendingSyncTableCreateCompanionBuilder =
    PendingSyncCompanion Function({
      Value<int> id,
      required int screenshotId,
      required String action,
      Value<DateTime> createdAt,
    });
typedef $$PendingSyncTableUpdateCompanionBuilder =
    PendingSyncCompanion Function({
      Value<int> id,
      Value<int> screenshotId,
      Value<String> action,
      Value<DateTime> createdAt,
    });

final class $$PendingSyncTableReferences
    extends BaseReferences<_$AppDatabase, $PendingSyncTable, PendingSyncData> {
  $$PendingSyncTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ScreenshotsTable _screenshotIdTable(_$AppDatabase db) =>
      db.screenshots.createAlias(
        $_aliasNameGenerator(db.pendingSync.screenshotId, db.screenshots.id),
      );

  $$ScreenshotsTableProcessedTableManager get screenshotId {
    final $_column = $_itemColumn<int>('screenshot_id')!;

    final manager = $$ScreenshotsTableTableManager(
      $_db,
      $_db.screenshots,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_screenshotIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PendingSyncTableFilterComposer
    extends Composer<_$AppDatabase, $PendingSyncTable> {
  $$PendingSyncTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ScreenshotsTableFilterComposer get screenshotId {
    final $$ScreenshotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.screenshotId,
      referencedTable: $db.screenshots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScreenshotsTableFilterComposer(
            $db: $db,
            $table: $db.screenshots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PendingSyncTableOrderingComposer
    extends Composer<_$AppDatabase, $PendingSyncTable> {
  $$PendingSyncTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ScreenshotsTableOrderingComposer get screenshotId {
    final $$ScreenshotsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.screenshotId,
      referencedTable: $db.screenshots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScreenshotsTableOrderingComposer(
            $db: $db,
            $table: $db.screenshots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PendingSyncTableAnnotationComposer
    extends Composer<_$AppDatabase, $PendingSyncTable> {
  $$PendingSyncTableAnnotationComposer({
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

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ScreenshotsTableAnnotationComposer get screenshotId {
    final $$ScreenshotsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.screenshotId,
      referencedTable: $db.screenshots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScreenshotsTableAnnotationComposer(
            $db: $db,
            $table: $db.screenshots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PendingSyncTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PendingSyncTable,
          PendingSyncData,
          $$PendingSyncTableFilterComposer,
          $$PendingSyncTableOrderingComposer,
          $$PendingSyncTableAnnotationComposer,
          $$PendingSyncTableCreateCompanionBuilder,
          $$PendingSyncTableUpdateCompanionBuilder,
          (PendingSyncData, $$PendingSyncTableReferences),
          PendingSyncData,
          PrefetchHooks Function({bool screenshotId})
        > {
  $$PendingSyncTableTableManager(_$AppDatabase db, $PendingSyncTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PendingSyncTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PendingSyncTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PendingSyncTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> screenshotId = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PendingSyncCompanion(
                id: id,
                screenshotId: screenshotId,
                action: action,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int screenshotId,
                required String action,
                Value<DateTime> createdAt = const Value.absent(),
              }) => PendingSyncCompanion.insert(
                id: id,
                screenshotId: screenshotId,
                action: action,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PendingSyncTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({screenshotId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (screenshotId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.screenshotId,
                                referencedTable: $$PendingSyncTableReferences
                                    ._screenshotIdTable(db),
                                referencedColumn: $$PendingSyncTableReferences
                                    ._screenshotIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PendingSyncTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PendingSyncTable,
      PendingSyncData,
      $$PendingSyncTableFilterComposer,
      $$PendingSyncTableOrderingComposer,
      $$PendingSyncTableAnnotationComposer,
      $$PendingSyncTableCreateCompanionBuilder,
      $$PendingSyncTableUpdateCompanionBuilder,
      (PendingSyncData, $$PendingSyncTableReferences),
      PendingSyncData,
      PrefetchHooks Function({bool screenshotId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ScreenshotsTableTableManager get screenshots =>
      $$ScreenshotsTableTableManager(_db, _db.screenshots);
  $$PendingSyncTableTableManager get pendingSync =>
      $$PendingSyncTableTableManager(_db, _db.pendingSync);
}
