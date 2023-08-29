import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class PokemonDatabaseHelper {
  static const String tableName = 'FavoritePokemons';
  static const String columnUserId = 'userId';
  static const String columnName = 'name';
  static const String columnIsFavorite = 'isFavorite';

  late final Database _database;

  PokemonDatabaseHelper() {
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final fullPath = path.join(dbPath, 'pokemon.db');

    _database = await openDatabase(
      fullPath,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE $tableName (
            id INTEGER PRIMARY KEY,
            $columnUserId TEXT,
            $columnName TEXT,
            $columnIsFavorite INTEGER
          )
        ''');
      },
    );
  }

  Future<void> addPokemon(String userId, Map<String, dynamic> pokemonJson) async {
    await _database.insert(
      tableName,
      {...pokemonJson, columnUserId: userId},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deletePokemon(String userId, String name) async {
    await _database.delete(
      tableName,
      where: '$columnUserId = ? AND $columnName = ?',
      whereArgs: [userId, name],
    );
  }

  Future<List<Map<String, dynamic>>> getPokemonsByUserId(String userId) async {
    final maps = await _database.query(
      tableName,
      where: '$columnUserId = ?',
      whereArgs: [userId],
    );
    return maps;
  }
}
