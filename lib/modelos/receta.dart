class Receta {
  final int id;
  final int usuarioId;
  final String titulo;
  final String ingredientes;
  final String pasos;
  final int tiempoPreparacion;
  final String rutaImagen;
  final String categoria;

  Receta({
    required this.id,
    required this.usuarioId,
    required this.titulo,
    required this.ingredientes,
    required this.pasos,
    required this.tiempoPreparacion,
    required this.categoria,
    required this.rutaImagen,
  });

  // Convertir Receta a un Map
  Map<String, dynamic> toMap() {
    return {
      if (id != 0) 'id': id, // Solo incluir id si es diferente de 0
      'usuarioId': usuarioId,
      'titulo': titulo,
      'ingredientes': ingredientes,
      'pasos': pasos,
      'tiempoPreparacion': tiempoPreparacion,
      'rutaImagen': rutaImagen,
      'categoria': categoria,
    };
  }

  // Convertir un Map a Receta
  static Receta fromMap(Map<String, dynamic> map) {
    return Receta(
      id: map['id'],
      usuarioId: map['usuarioId'],
      titulo: map['titulo'],
      ingredientes: map['ingredientes'],
      pasos: map['pasos'],
      tiempoPreparacion: map['tiempoPreparacion'],
      rutaImagen: map['rutaImagen'] ?? '', // Proporcionar valor por defecto si es null
      categoria: map['categoria'],
    );
  }
}
