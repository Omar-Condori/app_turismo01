import 'api_service.dart';

class EmprendedorService {
  static const String _endpoint = '/emprendedores';

  // Obtener todos los emprendedores
  static Future<List<Map<String, dynamic>>> getEmprendedores() async {
    try {
      final response = await ApiService.get(_endpoint);
      return List<Map<String, dynamic>>.from(response['data']);
    } catch (e) {
      throw Exception('Error al obtener emprendedores: $e');
    }
  }

  // Obtener un emprendedor por ID
  static Future<Map<String, dynamic>> getEmprendedorById(String id) async {
    try {
      final response = await ApiService.get('$_endpoint/$id');
      return response['data'];
    } catch (e) {
      throw Exception('Error al obtener emprendedor: $e');
    }
  }

  // Crear un nuevo emprendedor
  static Future<Map<String, dynamic>> createEmprendedor(Map<String, dynamic> emprendedor) async {
    try {
      final response = await ApiService.post(_endpoint, emprendedor);
      return response['data'];
    } catch (e) {
      throw Exception('Error al crear emprendedor: $e');
    }
  }

  // Actualizar un emprendedor
  static Future<Map<String, dynamic>> updateEmprendedor(String id, Map<String, dynamic> emprendedor) async {
    try {
      final response = await ApiService.put('$_endpoint/$id', emprendedor);
      return response['data'];
    } catch (e) {
      throw Exception('Error al actualizar emprendedor: $e');
    }
  }

  // Eliminar un emprendedor
  static Future<bool> deleteEmprendedor(String id) async {
    try {
      await ApiService.delete('$_endpoint/$id');
      return true;
    } catch (e) {
      throw Exception('Error al eliminar emprendedor: $e');
    }
  }
} 