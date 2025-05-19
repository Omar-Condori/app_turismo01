import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';
  
  // Headers comunes
  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Método genérico para peticiones GET
  static Future<dynamic> get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error en la petición: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Método genérico para peticiones POST
  static Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
        body: json.encode(data),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Error en la petición: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Método genérico para peticiones PUT
  static Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
        body: json.encode(data),
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error en la petición: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Método genérico para peticiones DELETE
  static Future<dynamic> delete(String endpoint) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
      );
      
      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        throw Exception('Error en la petición: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
} 