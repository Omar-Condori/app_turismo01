// services/emprendedor_service.dart
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../data/models/emprendedor_model.dart';

class EmprendedorService {
  // Para iOS simulator en macOS, necesitamos usar una dirección especial
  // Para acceder al host desde el emulador
  final String baseUrl = 'http://10.0.2.2:8000/api';

  // Si lo anterior no funciona, prueba con estas alternativas:
  // final String baseUrl = 'http://localhost:8000/api'; // Puede funcionar en algunos casos específicos
  // final String baseUrl = 'http://127.0.0.1:8000/api'; // Puede funcionar en algunos casos específicos
  // final String baseUrl = 'http://host.docker.internal:8000/api'; // Si usas Docker
  // final String baseUrl = 'http://192.168.X.X:8000/api'; // Usando tu IP real en la red local

  Future<List<Emprendedor>> getEmprendedores() async {
    try {
      // Imprimir para depuración
      print('📡 Intentando conectar a: $baseUrl/emprendedores');

      // Intentar múltiples direcciones si la primera falla
      List<String> alternativeUrls = [
        '$baseUrl/emprendedores',
        'http://10.0.2.2:8000/api/emprendedores',
        'http://127.0.0.1:8000/api/emprendedores',
        'http://localhost:8000/api/emprendedores'
      ];

      http.Response? response;
      Exception? lastError;

      // Intentar cada URL hasta que una funcione
      for (var url in alternativeUrls) {
        try {
          print('🔄 Probando URL: $url');
          response = await http.get(Uri.parse(url)).timeout(
            const Duration(seconds: 5),
            onTimeout: () {
              print('⏱ Timeout para $url');
              throw Exception('Timeout de conexión');
            },
          );

          if (response.statusCode == 200) {
            print('✅ Conexión exitosa a: $url');
            print('📦 Respuesta: ${response.body.substring(0, min(100, response.body.length))}...');
            break;
          } else {
            print('❌ Error en $url - Código: ${response.statusCode}');
          }
        } catch (e) {
          print('❌ Error intentando $url: $e');
          lastError = Exception('Error conectando a $url: $e');
        }
      }

      if (response == null) {
        throw lastError ?? Exception('No se pudo conectar a ninguna URL');
      }

      if (response.statusCode == 200) {
        try {
          final List<dynamic> data = json.decode(response.body);
          print('📊 Emprendedores recibidos: ${data.length}');
          return data.map((json) => Emprendedor.fromJson(json)).toList();
        } catch (e) {
          print('🛑 Error al parsear JSON: $e');
          print('🛑 Respuesta recibida: ${response.body}');
          throw Exception('Error al procesar los datos: $e');
        }
      } else {
        print('⚠️ Error HTTP ${response.statusCode}: ${response.body}');
        throw Exception('Error al cargar los emprendedores: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('🔴 Error de conexión general: $e');
      throw Exception('Error de conexión: $e');
    }
  }
}