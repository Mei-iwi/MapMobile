import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'mylocation.dart';

class MyDataBase {
  static final MyDataBase instance = MyDataBase._init();
  static Database? _database;
  MyDataBase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('myHistory.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE my_location (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          longitudeStart REAL NOT NULL,
          latitudeStart REAL NOT NULL,
          longitudeEnd REAL NOT NULL,
          latitudeEnd REAL NOT NULL,
          addressStart TEXT NOT NULL,
          addressEnd TEXT NOT NULL
      )
''');
  }

  Future<List<Mylocation>> getAllLocation() async {
    final db = await instance.database;
    final result = await db.query('my_location', orderBy: 'id DESC');
    return result.map((map) => Mylocation.fromMap(map)).toList();
  }

  Future<int> insertMyLocation(Mylocation mylocation) async {
    final db = await instance.database;
    return await db.insert('my_location', mylocation.toMap());
  }

  Future<int> updateMyLocation(Mylocation mylocation) async {
    final db = await instance.database;
    return await db.update(
      'my_location',
      mylocation.toMap(),
      where: 'id = ?',
      whereArgs: [mylocation.id],
    );
  }

  Future<int> deleteMyLocation(int id) async {
    final db = await instance.database;
    return await db.delete('my_location', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
