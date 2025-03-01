import 'package:restaurant_app/data/local/models/favourite.dart';
import 'package:sqflite/sqflite.dart';

class SqliteService {
  static const String _databaseName = 'favouritelist.db';
  static const String _tableName = 'favourite';
  static const int _version = 1;

  Future<void> createTables(Database database) async {
    await database.execute("""
        CREATE TABLE $_tableName(
          id TEXT PRIMARY KEY NOT NULL,
          name TEXT,
          image TEXT,
          city TEXT,
          rating REAL
        )
      """);
  }

  Future<Database> _initializeDb() async {
    return openDatabase(_databaseName, version: _version,
        onCreate: (Database database, int version) async {
      await createTables(database);
    });
  }

  Future<int> insertItem(Favourite favourite) async {
    final db = await _initializeDb();

    final data = favourite.toJson();

    final id = await db.insert(_tableName, data,
        conflictAlgorithm: ConflictAlgorithm.replace);

    return id;
  }

  Future<List<Favourite>> getAllFavourite() async {
    final db = await _initializeDb();

    final results = await db.query(_tableName, orderBy: "id");

    return results.map((result) => Favourite.fromJson(result)).toList();
  }

  Future<Favourite?> getItemById(String id) async {
    final db = await _initializeDb();

    final results =
        await db.query(_tableName, where: "id = ?", whereArgs: [id], limit: 1);

    if (results.isNotEmpty) {
      return results.map((result) => Favourite.fromJson(result)).first;
    }
    return null;
  }

  Future<int> updateItem(String id, Favourite favourite) async {
    final db = await _initializeDb();

    final data = favourite.toJson();

    final result =
        await db.update(_tableName, data, where: "id = ?", whereArgs: [id]);

    return result;
  }

  Future<int> removeItem(String id) async {
    final db = await _initializeDb();

    final result =
        await db.delete(_tableName, where: "id = ?", whereArgs: [id]);

    return result;
  }
}
