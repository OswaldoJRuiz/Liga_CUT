import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:liga/models/equipos_model.dart';

class DBEquiposHelper {
  static Database? _db;

  static Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  static Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), "equipos.db");
    return await openDatabase(
      path,
      version: 2, // aumentamos la versión para aplicar onUpgrade
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE equipos(
            id INTEGER PRIMARY KEY,
            nombre TEXT,
            director_tecnico TEXT,
            partidos_jugados INTEGER,
            victorias INTEGER,
            empates INTEGER,
            derrotas INTEGER,
            goles_a_favor INTEGER,
            goles_en_contra INTEGER,
            puntos INTEGER,
            propietario_id INTEGER
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Si ya existía la base, agregamos la columna propietario_id
          await db.execute(
            'ALTER TABLE equipos ADD COLUMN propietario_id INTEGER;',
          );
        }
      },
    );
  }

  static Future<void> insertEquipo(Equipo equipo, {int? propietarioId}) async {
    final db = await database;
    await db.insert("equipos", {
      'id': equipo.id,
      'nombre': equipo.nombre,
      'director_tecnico': equipo.directorTecnico,
      'partidos_jugados': equipo.partidosJugados,
      'victorias': equipo.victorias,
      'empates': equipo.empates,
      'derrotas': equipo.derrotas,
      'goles_a_favor': equipo.golesAFavor,
      'goles_en_contra': equipo.golesEnContra,
      'puntos': equipo.puntos,
      'propietario_id': propietarioId,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Equipo>> getEquipos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query("equipos");
    return maps.map((e) => Equipo.fromJson(e)).toList();
  }

  static Future<void> clearEquipos() async {
    final db = await database;
    await db.delete("equipos");
  }
}
