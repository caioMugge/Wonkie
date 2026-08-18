import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'homepage.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('wonkie_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE baralhos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL
        )
    ''');

    await db.execute('''
      CREATE TABLE flashcard (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        baralho_id INTEGER NOT NULL,
        pergunta TEXT NOT NULL,
        resposta TEXT NOT NULL,
        repeticoes INTEGER NOT NULL DEFAULT 0,
        fatorFacilidade REAL NOT NULL DEFAULT 2.5,
        intervaloDias INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (baralho_id) REFERENCES baralhos (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<Baralho> insertBaralho(String nome) async {
    final db = await instance.database;
    final id = await db.insert(
      'baralhos', 
      {'nome': nome});
    return Baralho(
      id: id, 
      nome: nome, 
      cards: []);
  }

  Future<List<Baralho>> getBaralhosComCards() async {
    final db = await instance.database;
    final resultBaralhos = await db.query('baralhos');

    List<Baralho> listaBaralhos = [];

    for (var bMap in resultBaralhos) {
      final baralhoId = bMap['id'] as int;
      final resultCards = await db.query(
        'flascards',
        where: 'baralho_id = ?',
        whereArgs: [baralhoId],
      );

      List<Flashcard> cards = resultCards.map((c) => Flashcard.fromMap(c)).toList();

      listaBaralhos.add(Baralho(
        id: baralhoId,
        nome: bMap['nome'] as String,
        cards: cards,
      ));
    }
    return listaBaralhos;
  }

  Future<int> updateBaralho(int id, String novoNome) async {
    final db = await instance.database;
    return await db.update(
      'baralhos',
      {'nome': novoNome},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteBaralho(int id) async {
    final db = await instance.database;
    return await db.delete('baralhos', where: 'id = ?', whereArgs: [id]);
  }

  Future<Flashcard> insertFlashcard(int baralhoId, String pergunta, String resposta) async {
    final db = await instance.database;
    final cardMap = {
      'baralho_id': baralhoId,
      'pergunta': pergunta,
      'resposta': resposta,
      'repeticoes': 0,
      'fatorFacilidade': 2.5,
      'intervaloDias': 0,
    };
    final id = await db.insert('flashcards', cardMap);
    return Flashcard(
      id: id,
      baralhoId: baralhoId,
      pergunta: pergunta,
      resposta: resposta,
    );
  }

  Future<int> updateFlashcard(Flashcard card) async {
    final db = await instance.database;
    return await db.update(
      'flashcards',
      card.toMap(),
      where: 'id = ?',
      whereArgs: [card.id],
    );
  }

  Future<int> deleteFlashcard(int id) async {
    final db = await instance.database;
    return await db.delete(
      'flashcards',
      where: 'id = ?',
      whereArgs: [id],
      );
  }
}