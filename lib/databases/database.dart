import 'package:path/path.dart';
import 'package:recetario_relacional/modelos/receta.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'recetario.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE usuarios(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            correo TEXT NOT NULL UNIQUE,
            contrasena TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE recetas(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            usuarioId INTEGER NOT NULL,
            titulo TEXT NOT NULL,
            ingredientes TEXT NOT NULL,
            pasos TEXT NOT NULL,
            tiempoPreparacion INTEGER NOT NULL DEFAULT 0,
            rutaImagen TEXT,
            categoria TEXT NOT NULL,
            FOREIGN KEY (usuarioId) REFERENCES usuarios(id)
          )
        ''');
      },
    );
  }
//insertar la receta en la database
  Future<int> insertarReceta(Receta receta) async {
    final db = await database;
    return await db.insert(
      'recetas',
      receta.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
// guardar el usuario
  Future<int> registrarUsuario(String correo, String contrasena) async {
    final db = await database;
    return await db.insert(
      'usuarios',
      {'correo': correo, 'contrasena': contrasena},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<Map<String, dynamic>?> obtenerUsuario(String correo, String contrasena) async {
    final db = await database;
    var result = await db.query(
      'usuarios',
      where: 'correo = ? AND contrasena = ?',
      whereArgs: [correo, contrasena],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<List<Receta>> obtenerRecetasPorUsuario(int usuarioId) async {
    final db = await database;
    var result = await db.query(
      'recetas',
      where: 'usuarioId = ?',
      whereArgs: [usuarioId],
    );
    return result.map((json) => Receta.fromMap(json)).toList();
  }
//al editar la receta
  Future<int> actualizarReceta(Receta receta) async {
    final db = await database;
    return await db.update(
      'recetas',
      receta.toMap(),
      where: 'id = ?',
      whereArgs: [receta.id],
    );
  }
//metodo para eliminar una receta
  Future<int> eliminarReceta(int id) async {
    final db = await database;
    return await db.delete(
      'recetas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
