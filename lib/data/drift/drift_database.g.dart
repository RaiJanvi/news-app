// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drift_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Download extends DataClass implements Insertable<Download> {
  final int id;
  final Uint8List news;
  Download({required this.id, required this.news});
  factory Download.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Download(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      news: const BlobType()
          .mapFromDatabaseResponse(data['${effectivePrefix}news'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['news'] = Variable<Uint8List>(news);
    return map;
  }

  DownloadsCompanion toCompanion(bool nullToAbsent) {
    return DownloadsCompanion(
      id: Value(id),
      news: Value(news),
    );
  }

  factory Download.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Download(
      id: serializer.fromJson<int>(json['id']),
      news: serializer.fromJson<Uint8List>(json['news']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'news': serializer.toJson<Uint8List>(news),
    };
  }

  Download copyWith({int? id, Uint8List? news}) => Download(
        id: id ?? this.id,
        news: news ?? this.news,
      );
  @override
  String toString() {
    return (StringBuffer('Download(')
          ..write('id: $id, ')
          ..write('news: $news')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, news);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Download && other.id == this.id && other.news == this.news);
}

class DownloadsCompanion extends UpdateCompanion<Download> {
  final Value<int> id;
  final Value<Uint8List> news;
  const DownloadsCompanion({
    this.id = const Value.absent(),
    this.news = const Value.absent(),
  });
  DownloadsCompanion.insert({
    this.id = const Value.absent(),
    required Uint8List news,
  }) : news = Value(news);
  static Insertable<Download> custom({
    Expression<int>? id,
    Expression<Uint8List>? news,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (news != null) 'news': news,
    });
  }

  DownloadsCompanion copyWith({Value<int>? id, Value<Uint8List>? news}) {
    return DownloadsCompanion(
      id: id ?? this.id,
      news: news ?? this.news,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (news.present) {
      map['news'] = Variable<Uint8List>(news.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DownloadsCompanion(')
          ..write('id: $id, ')
          ..write('news: $news')
          ..write(')'))
        .toString();
  }
}

class $DownloadsTable extends Downloads
    with TableInfo<$DownloadsTable, Download> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DownloadsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _newsMeta = const VerificationMeta('news');
  @override
  late final GeneratedColumn<Uint8List?> news = GeneratedColumn<Uint8List?>(
      'news', aliasedName, false,
      type: const BlobType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, news];
  @override
  String get aliasedName => _alias ?? 'downloads';
  @override
  String get actualTableName => 'downloads';
  @override
  VerificationContext validateIntegrity(Insertable<Download> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('news')) {
      context.handle(
          _newsMeta, news.isAcceptableOrUnknown(data['news']!, _newsMeta));
    } else if (isInserting) {
      context.missing(_newsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Download map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Download.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $DownloadsTable createAlias(String alias) {
    return $DownloadsTable(attachedDatabase, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $DownloadsTable downloads = $DownloadsTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [downloads];
}
