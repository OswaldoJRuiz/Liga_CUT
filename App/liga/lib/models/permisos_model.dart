class Permiso {
  final int? id;
  final String nombre;
  final String? descripcion;

  Permiso({this.id, required this.nombre, this.descripcion});

  factory Permiso.fromJson(Map<String, dynamic> json) {
    return Permiso(
      id: json['id'] as int?, // ⚡ aseguramos int?
      nombre: json['nombre'] as String? ?? '', // ⚡ default '' para evitar null
      descripcion: json['descripcion'] as String?, // puede ser null
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nombre': nombre, 'descripcion': descripcion};
  }
}
