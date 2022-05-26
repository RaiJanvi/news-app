import 'package:drift/drift.dart';

part 'drift_database.g.dart';

class Downloads extends Table {
  IntColumn get  id => integer().autoIncrement()();
  BlobColumn get news => blob()();
}

@DriftDatabase(tables: [Downloads])
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e): super(e);

  @override
  // TODO: implement schemaVersion
  int get schemaVersion => 1;

  //Future<List<Download>> getAllDownloads() => select(downloads).get();
  Stream<List<Download>> watchAllDownloads() => select(downloads).watch();
  Future insertNews(DownloadsCompanion download) => into(downloads).insert(download);
  Future deleteNews(Download download) => delete(downloads).delete(download);

  //Future updateNews(Download download) => update(downloads).replace(download);
}