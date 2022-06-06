import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE cities(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT)
      """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'my_weather_nes.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new city
  static Future<int> createItem(String name) async {
    final db = await SQLHelper.db();

    final data = {'name': name};
    final id = await db.insert('cities', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all items (journals)
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('cities', orderBy: "id");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('cities', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<List<Map<String, dynamic>>> checkItem(String name) async {
    final db = await SQLHelper.db();
    return db.query('cities', where: "name = ?", whereArgs: [name], limit: 1);
  }

  // Update an item by id
  static Future<int> updateItem(int id, String name) async {
    final db = await SQLHelper.db();

    final data = {
      'name': name,
    };

    final result =
        await db.update('cities', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("cities", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      null;
    }
  }
}
