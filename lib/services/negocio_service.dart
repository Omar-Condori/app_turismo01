import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/models/negocio_model.dart';

class NegocioService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';
  static const String endpoint = '/negocios';

  Future<List<Negocio>> getNegocios() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl$endpoint'));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Negocio.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar negocios: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
} 