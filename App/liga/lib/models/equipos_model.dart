class Equipo {
  final int? id;
  final String nombre;
  final String directorTecnico;
  int partidosJugados;
  int victorias;
  int empates;
  int derrotas;
  int golesAFavor;
  int golesEnContra;
  int puntos;

  // Nuevo campo
  final int? propietarioId;

  Equipo({
    this.id,
    required this.nombre,
    required this.directorTecnico,
    this.partidosJugados = 0,
    this.victorias = 0,
    this.empates = 0,
    this.derrotas = 0,
    this.golesAFavor = 0,
    this.golesEnContra = 0,
    this.puntos = 0,
    this.propietarioId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'director_tecnico': directorTecnico,
      'partidos_jugados': partidosJugados,
      'victorias': victorias,
      'empates': empates,
      'derrotas': derrotas,
      'goles_a_favor': golesAFavor,
      'goles_en_contra': golesEnContra,
      'puntos': puntos,
      'propietario_id': propietarioId, // <-- nuevo
    };
  }

  factory Equipo.fromJson(Map<String, dynamic> json) {
    return Equipo(
      id: json['id']?.toInt(),
      nombre: json['nombre'] ?? '',
      directorTecnico: json['director_tecnico'] ?? '',
      partidosJugados: (json['partidos_jugados'] ?? 0).toInt(),
      victorias: (json['victorias'] ?? 0).toInt(),
      empates: (json['empates'] ?? 0).toInt(),
      derrotas: (json['derrotas'] ?? 0).toInt(),
      golesAFavor: (json['goles_a_favor'] ?? 0).toInt(),
      golesEnContra: (json['goles_en_contra'] ?? 0).toInt(),
      puntos: (json['puntos'] ?? 0).toInt(),
      propietarioId: json['propietario_id']?.toInt(), // <-- nuevo
    );
  }
}
