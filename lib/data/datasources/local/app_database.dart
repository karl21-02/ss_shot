import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

/// 스크린샷 카테고리
enum ScreenshotCategory {
  all,
  finance,
  shopping,
  schedule,
  humor,
  other,
}

/// 스크린샷 테이블
class Screenshots extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get localId => text().unique()();
  TextColumn get filePath => text()();
  TextColumn get fullText => text().nullable()();
  TextColumn get ocrJson => text().nullable()();
  TextColumn get category => textEnum<ScreenshotCategory>()
      .withDefault(Constant(ScreenshotCategory.other.name))();
  BoolColumn get isOcrProcessed => boolean().withDefault(const Constant(false))();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get capturedAt => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// 동기화 대기열 테이블
class PendingSync extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get screenshotId => integer().references(Screenshots, #id)();
  TextColumn get action => text()(); // 'create', 'update', 'delete'
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [Screenshots, PendingSync])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Screenshot CRUD
  Future<List<Screenshot>> getAllScreenshots() =>
      (select(screenshots)..where((s) => s.isDeleted.equals(false))).get();

  Future<List<Screenshot>> getScreenshotsByCategory(ScreenshotCategory category) {
    if (category == ScreenshotCategory.all) {
      return getAllScreenshots();
    }
    return (select(screenshots)
          ..where((s) => s.category.equals(category.name))
          ..where((s) => s.isDeleted.equals(false)))
        .get();
  }

  Future<List<Screenshot>> searchScreenshots(String query) {
    return (select(screenshots)
          ..where((s) => s.fullText.like('%$query%'))
          ..where((s) => s.isDeleted.equals(false)))
        .get();
  }

  Future<Screenshot?> getScreenshotByLocalId(String localId) {
    return (select(screenshots)..where((s) => s.localId.equals(localId)))
        .getSingleOrNull();
  }

  Future<int> insertScreenshot(ScreenshotsCompanion screenshot) =>
      into(screenshots).insert(screenshot);

  Future<bool> updateScreenshot(ScreenshotsCompanion screenshot) =>
      update(screenshots).replace(screenshot as Screenshot);

  Future<int> updateScreenshotOcr(
    String localId,
    String fullText,
    String ocrJson,
    ScreenshotCategory category,
  ) {
    return (update(screenshots)..where((s) => s.localId.equals(localId))).write(
      ScreenshotsCompanion(
        fullText: Value(fullText),
        ocrJson: Value(ocrJson),
        category: Value(category),
        isOcrProcessed: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<int> markAsDeleted(String localId) {
    return (update(screenshots)..where((s) => s.localId.equals(localId))).write(
      ScreenshotsCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // Pending Sync
  Future<List<PendingSyncData>> getPendingSyncs() => select(pendingSync).get();

  Future<int> insertPendingSync(PendingSyncCompanion sync) =>
      into(pendingSync).insert(sync);

  Future<int> deletePendingSync(int id) =>
      (delete(pendingSync)..where((p) => p.id.equals(id))).go();

  // Stats
  Future<int> getUnprocessedCount() async {
    final query = selectOnly(screenshots)
      ..addColumns([screenshots.id.count()])
      ..where(screenshots.isOcrProcessed.equals(false))
      ..where(screenshots.isDeleted.equals(false));
    final result = await query.getSingle();
    return result.read(screenshots.id.count()) ?? 0;
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'ss_shot.db'));
    return NativeDatabase.createInBackground(file);
  });
}
