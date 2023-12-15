import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _dbName = "Bookmarks.db";

  static Future<Database> _getDB() async {
    return openDatabase(
      join(await getDatabasesPath(), _dbName),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE bookmarks(
            id TEXT PRIMARY KEY,
            term TEXT,
            definition TEXT,
            stems TEXT,
            hwi TEXT,
            prs TEXT,
            fl TEXT,
            def TEXT
          )
        ''');
      },
      version: _version,
    );
  }

  static Future<void> insertBookmark(Map<String, dynamic> bookmark) async {
    final Database db = await _getDB();
    await db.insert('bookmarks', bookmark,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getAllBookmarks() async {
    final Database db = await _getDB();
    return db.query('bookmarks');
  }

  static Future<void> deleteBookmark(String id) async {
    final Database db = await _getDB();
    await db.delete('bookmarks', where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<Map<String, dynamic>>> getBookmarks() async {
    final Database db = await _getDB();
    return db.query('bookmarks');
  }

  static Future<bool> isBookmarked(String id) async {
    final Database db = await _getDB();
    final result =
        await db.query('bookmarks', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty;
  }
}
