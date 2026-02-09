import 'package:careme24/models/medcard/medcard_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('medcard.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE medcard(
        id TEXT PRIMARY KEY,
        personalInfo TEXT,
        medInfo TEXT,
        doctorReports TEXT,
        testsResults TEXT,
        certificates TEXT,
        status TEXT,
        detail TEXT,
        haveCard INTEGER,
        cardType TEXT,   
        animalMedCard TEXT,
        myCard INTEGER DEFAULT 0
      )
    ''');
  }

  Future<void> insertMedcard(MedcardModel medcard) async {
    final db = await instance.database;
    await db.insert(
      'medcard',
      medcard.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateMyCard(MedcardModel medcard) async {
    final db = await instance.database;

    await db.delete(
      'medcard',
      where: 'myCard = ?',
      whereArgs: [1],
    );

    await db.insert(
      'medcard',
      {
        ...medcard.toMap(),
        'myCard': 1,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateOtherCards(List<MedcardModel> otherCards) async {
    final db = await instance.database;

    await db.update(
      'medcard',
      {'myCard': 0},
      where: 'myCard = ?',
      whereArgs: [1],
    );

    // Вставляем новые карты
    for (var card in otherCards) {
      await db.insert(
        'medcard',
        card.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<MedcardModel>> fetchAllMedcards() async {
    final db = await database;
    final result =
        await db.query('medcard', where: 'myCard = ?', whereArgs: [0]);
    return result.map((map) => MedcardModel.fromMap(map)).toList();
  }

  Future<MedcardModel?> fetchMyCard() async {
    final db = await database;
    final result =
        await db.query('medcard', where: 'myCard = ?', whereArgs: [1]);

    if (result.isNotEmpty) {
      return MedcardModel.fromMap(result.first);
    }
    return null;
  }
}
