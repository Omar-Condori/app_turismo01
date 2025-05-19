class Negocio {
  final int id;
  final String nombre;
  final String descripcion;
  final String rubro;
  final String direccion;
  final String telefono;
  final String? email;
  final String? imagen;
  final bool activo;
  final DateTime createdAt;
  final DateTime updatedAt;

  Negocio({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.rubro,
    required this.direccion,
    required this.telefono,
    this.email,
    this.imagen,
    required this.activo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Negocio.fromJson(Map<String, dynamic> json) {
    return Negocio(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      rubro: json['rubro'],
      direccion: json['direccion'],
      telefono: json['telefono'],
      email: json['email'],
      imagen: json['imagen'],
      activo: json['activo'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'rubro': rubro,
      'direccion': direccion,
      'telefono': telefono,
      'email': email,
      'imagen': imagen,
      'activo': activo,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
} 