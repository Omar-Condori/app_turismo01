class Reserva {
  final int id;
  final int emprendedorId;
  final String nombre;
  final String email;
  final String fecha;
  final String hora;
  final String? mensaje;
  final String? createdAt;
  final Map<String, dynamic>? emprendedor;

  Reserva({
    required this.id,
    required this.emprendedorId,
    required this.nombre,
    required this.email,
    required this.fecha,
    required this.hora,
    this.mensaje,
    this.createdAt,
    this.emprendedor,
  });

  factory Reserva.fromJson(Map<String, dynamic> json) {
    return Reserva(
      id: json['id'],
      emprendedorId: json['emprendedor_id'],
      nombre: json['nombre'],
      email: json['email'],
      fecha: json['fecha'],
      hora: json['hora'],
      mensaje: json['mensaje'],
      createdAt: json['created_at'],
      emprendedor: json['emprendedor'] is Map ? json['emprendedor'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'emprendedor_id': emprendedorId,
      'nombre': nombre,
      'email': email,
      'fecha': fecha,
      'hora': hora,
      'mensaje': mensaje,
      'created_at': createdAt,
      'emprendedor': emprendedor,
    };
  }

  // Método para obtener el nombre del emprendedor si está disponible
  String get emprendedorNombre {
    return emprendedor != null && emprendedor!.containsKey('nombre') 
        ? emprendedor!['nombre']
        : 'Emprendedor #$emprendedorId';
  }
} 