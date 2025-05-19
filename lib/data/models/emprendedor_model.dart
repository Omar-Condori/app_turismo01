// lib/data/models/emprendedor_model.dart
class Emprendedor {
  final int id;
  final String nombre;
  final String? rubro;
  final String? telefono;
  final String? email;
  final String? direccion;
  final String? descripcion;
  final String? sitioWeb;
  final String? redesSociales;
  final String? logo;
  final String? createdAt;
  final String? updatedAt;

  Emprendedor({
    required this.id,
    required this.nombre,
    this.rubro,
    this.telefono,
    this.email,
    this.direccion,
    this.descripcion,
    this.sitioWeb,
    this.redesSociales,
    this.logo,
    this.createdAt,
    this.updatedAt,
  });

  // Getter para imagen que retorna el logo
  String? get imagen => logo;

  factory Emprendedor.fromJson(Map<String, dynamic> json) {
    return Emprendedor(
      id: json['id'] as int,
      nombre: json['nombre'] as String? ?? 'Sin nombre',
      rubro: json['rubro'] as String?,
      telefono: json['telefono'] as String?,
      email: json['email'] as String?,
      direccion: json['direccion'] as String?,
      descripcion: json['descripcion'] as String?,
      sitioWeb: json['sitio_web'] as String?,
      redesSociales: json['redes_sociales'] as String?,
      logo: json['logo'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }
}