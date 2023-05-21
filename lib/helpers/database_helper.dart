import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:encrypt/encrypt.dart';
import '../models/user_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String path = await getDatabasesPath();
    final String databasePath = join(path, 'user_database.db');

    return openDatabase(databasePath, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    final String query = '''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT,
        password TEXT
      )
    ''';

    await db.execute(query);
  }

  Future<int> insertUser(UserModel user) async {
    final Database db = await instance.database;

    final String encryptedPassword = _encryptText(user.password);

    final Map<String, dynamic> row = {
      'username': user.username,
      'password': encryptedPassword,
    };

    return db.insert('users', row);
  }

  Future<UserModel?> getUser(String username) async {
    final Database db = await instance.database;

    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (result.isNotEmpty) {
      final Map<String, dynamic> row = result.first;
      final String decryptedPassword = _decryptText(row['password']);
      return UserModel(username: row['username'], password: decryptedPassword);
    }

    return null;
  }

  String _encryptText(String text) {
    final key = Key.fromLength(32);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));

    final encrypted = encrypter.encrypt(text, iv: iv);
    return encrypted.base64;
  }

  String _decryptText(String encryptedText) {
    final key = Key.fromLength(32);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));

    final encrypted = Encrypted.from64(encryptedText);
    final decrypted = encrypter.decrypt(encrypted, iv: iv);
    return decrypted;
  }
}
