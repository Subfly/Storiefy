import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:story_way/common/constants/preferences_constants.dart';
import 'package:story_way/data/repository/local/story_database_repository.dart';

class StoryDatabaseRepositorySqfliteImpl implements StoryDatabaseRepository {
  static const String tableName = "SeenStories";
  static late Database _database;
  static bool _isInitialized = false;

  static Future<void> initStoriesDB() async {
    final databasesPath = await getDatabasesPath();
    final path =
        join(databasesPath, "${PreferencesConstants.DATABASE_NAME}.db");
    _database = await openDatabase(
      path,
      onCreate: (db, version) async {
        await db.execute(
            "CREATE TABLE IF NOT EXISTS $tableName (storyId STRING PRIMARY KEY)");
      },
      version: 1,
    );

    _isInitialized = true;
  }

  @override
  Future<void> addSeenStory({required String storyId}) async {
    if (_isInitialized) {
      await _database.insert(
        tableName,
        {"storyId": storyId},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  @override
  Future<void> clear() async {
    if (_isInitialized) {
      await _database.delete(tableName);
    }
  }

  @override
  Future<List<String>> getSeenStories() async {
    if (_isInitialized) {
      final items = await _database.query(tableName);
      if (kDebugMode) {
        print(items);
      }
      return [];
    }
    return [];
  }
}
