// lib/data/providers/api_provider.dart
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import '../models/api_response_model.dart';
import '../models/emprendedor_model.dart';
import '../models/user_model.dart';

class ApiProvider {
  final String _baseUrl = 'http://127.0.0.1:8000/api';
  final Dio _dio = Dio();

  ApiProvider() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
  }

  Future<ApiResponse<List<Emprendedor>>> getEmprendedores() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/emprendedores'));
      print('🔍 API Response Status: ${response.statusCode}');
      print('🔍 API Response Body: ${response.body}');
      
      // Para simulación cuando no tenemos backend
      if (response.statusCode == 404) {
        // Datos simulados de emprendedores
        final List<Emprendedor> mockEmprendedores = [
          Emprendedor(
            id: 1,
            nombre: 'Hotel Andino',
            rubro: 'Hospedaje',
            telefono: '+51 987654321',
            email: 'contacto@hotelandino.com',
            direccion: 'Av. Principal 123, Capachica',
            descripcion: 'Hotel con vista al lago Titicaca, ofrecemos habitaciones confortables y servicio de calidad.',
            logo: 'https://via.placeholder.com/150',
          ),
          Emprendedor(
            id: 2,
            nombre: 'Restaurante El Lago',
            rubro: 'Gastronomía',
            telefono: '+51 987654322',
            email: 'reservas@ellago.com',
            direccion: 'Jr. Puno 456, Capachica',
            descripcion: 'Restaurante especializado en comida típica de la región con ingredientes locales y frescos.',
            logo: 'https://via.placeholder.com/150',
          ),
          Emprendedor(
            id: 3,
            nombre: 'Tour Capachica',
            rubro: 'Turismo',
            telefono: '+51 987654323',
            email: 'info@tourcapachica.com',
            direccion: 'Plaza de Armas s/n, Capachica',
            descripcion: 'Ofrecemos tours guiados por la península de Capachica y las islas del Titicaca.',
            logo: 'https://via.placeholder.com/150',
          ),
        ];
        
        return ApiResponse<List<Emprendedor>>(
          success: true,
          message: 'Emprendedores simulados obtenidos',
          data: mockEmprendedores,
        );
      }

      final jsonData = json.decode(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> emprendedoresJson = jsonData is List 
            ? jsonData 
            : (jsonData['data'] is List ? jsonData['data'] : []);
            
        final List<Emprendedor> emprendedores =
            emprendedoresJson.map((json) => Emprendedor.fromJson(json)).toList();

        return ApiResponse<List<Emprendedor>>(
          success: true,
          message: 'Emprendedores obtenidos',
          data: emprendedores,
        );
      } else {
        String errorMessage = 'Error al obtener emprendedores';
        if (jsonData is Map && jsonData.containsKey('message')) {
          errorMessage = jsonData['message'];
        }
        
        print('❌ API Error: $errorMessage (Status: ${response.statusCode})');
        
        return ApiResponse<List<Emprendedor>>(
          success: false,
          message: errorMessage,
          data: null,
        );
      }
    } catch (e) {
      print('❌ Exception: ${e.toString()}');
      return ApiResponse<List<Emprendedor>>(
        success: false,
        message: 'Error de conexión: ${e.toString()}',
        data: null,
      );
    }
  }
  
  Future<ApiResponse<Emprendedor>> getEmprendedorById(int id) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/emprendedores/$id'));
      
      // Simulación
      if (response.statusCode == 404) {
        final mockEmprendedor = Emprendedor(
          id: id,
          nombre: 'Emprendedor $id',
          rubro: 'Rubro simulado',
          telefono: '+51 98765432$id',
          email: 'contacto$id@ejemplo.com',
          direccion: 'Dirección simulada #$id, Capachica',
          descripcion: 'Esta es una descripción simulada para el emprendedor $id.',
          logo: 'https://via.placeholder.com/150',
        );
        
        return ApiResponse<Emprendedor>(
          success: true,
          message: 'Emprendedor simulado obtenido',
          data: mockEmprendedor,
        );
      }
      
      final jsonData = json.decode(response.body);
      
      if (response.statusCode == 200) {
        final emprendedorJson = jsonData is Map 
            ? (jsonData.containsKey('data') ? jsonData['data'] : jsonData)
            : {};
            
        return ApiResponse<Emprendedor>(
          success: true,
          message: 'Emprendedor obtenido',
          data: Emprendedor.fromJson(emprendedorJson),
        );
      } else {
        return ApiResponse<Emprendedor>(
          success: false,
          message: jsonData['message'] ?? 'Error al obtener emprendedor',
          data: null,
        );
      }
    } catch (e) {
      return ApiResponse<Emprendedor>(
        success: false,
        message: 'Error: ${e.toString()}',
        data: null,
      );
    }
  }
  
  Future<ApiResponse<Map<String, dynamic>>> realizarReserva({
    required int emprendedorId,
    required String nombre,
    required String email,
    required String fecha,
    required String hora,
    String? mensaje,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/reservas'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'emprendedor_id': emprendedorId,
          'nombre': nombre,
          'email': email,
          'fecha': fecha,
          'hora': hora,
          'mensaje': mensaje,
        }),
      );
      
      // Simulación de respuesta exitosa
      if (response.statusCode == 404) {
        return ApiResponse<Map<String, dynamic>>(
          success: true,
          message: 'Reserva simulada procesada correctamente',
          data: {
            'id': 123,
            'emprendedor_id': emprendedorId,
            'nombre': nombre,
            'email': email,
            'fecha': fecha,
            'hora': hora,
            'mensaje': mensaje,
            'created_at': DateTime.now().toIso8601String(),
          },
        );
      }
      
      final jsonData = json.decode(response.body);
      
      return ApiResponse<Map<String, dynamic>>(
        success: response.statusCode == 200 || response.statusCode == 201,
        message: jsonData['message'] ?? 'Reserva procesada',
        data: jsonData is Map ? 
            (jsonData.containsKey('data') ? jsonData['data'] : jsonData) : null,
      );
    } catch (e) {
      return ApiResponse<Map<String, dynamic>>(
        success: false,
        message: 'Error al realizar la reserva: ${e.toString()}',
        data: null,
      );
    }
  }

  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    required Map<String, dynamic> data,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final url = '$_baseUrl$endpoint';
      print('🔍 [POST] $url');
      print('🔍 [POST] Datos: $data');

      final response = await _dio.post(
        endpoint,
        data: data,
        options: Options(
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        if (fromJson != null) {
          return ApiResponse<T>(
            success: true,
            message: 'Operación exitosa',
            data: fromJson(responseData),
          );
        }
        return ApiResponse<T>(
          success: true,
          message: 'Operación exitosa',
          data: responseData as T,
        );
      }

      return ApiResponse<T>(
        success: false,
        message: 'Error en la operación',
        data: null,
      );
    } catch (e) {
      print('❌ [ApiProvider] Error en POST: $e');
      return ApiResponse<T>(
        success: false,
        message: 'Error: ${e.toString()}',
        data: null,
      );
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> loginWithGoogle(String idToken) async {
    try {
      print('🔍 [Login with Google] Token: ${idToken.substring(0, 20)}...');
      
      // Simular una respuesta exitosa para login con Google
      final mockUser = UserModel(
        id: 2,
        name: 'Usuario Google',
        email: 'usuario.google@gmail.com',
        phone: '+51 987654321',
        active: true,
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );
      
      final mockAuthData = {
        'success': true,
        'message': 'Inicio de sesión con Google exitoso',
        'data': {
          'user': mockUser.toJson(),
          'access_token': 'google_token_${DateTime.now().millisecondsSinceEpoch}',
          'token_type': 'Bearer',
        }
      };
      
      return ApiResponse<Map<String, dynamic>>(
        success: true,
        message: 'Inicio de sesión con Google exitoso',
        data: mockAuthData,
      );
      
      // En un entorno real, enviaríamos el token a nuestro backend
      /*
      final response = await _dio.post(
        '/auth/google',
        data: {'id_token': idToken},
        options: Options(
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
        ),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        return ApiResponse<Map<String, dynamic>>(
          success: true,
          message: 'Inicio de sesión con Google exitoso',
          data: responseData,
        );
      }
      
      return ApiResponse<Map<String, dynamic>>(
        success: false,
        message: 'Error al autenticar con Google',
        data: null,
      );
      */
    } catch (e) {
      return ApiResponse<Map<String, dynamic>>(
        success: false,
        message: 'Error al iniciar sesión con Google: ${e.toString()}',
        data: null,
      );
    }
  }

  Future<ApiResponse<T>> postMultipart<T>(
    String endpoint, {
    required Map<String, dynamic> data,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final url = '$_baseUrl$endpoint';
      print('🔍 [POST MULTIPART] $url');

      // Crear FormData para envío multipart
      final formData = FormData.fromMap(data);

      // Simular registro exitoso
      if (endpoint == '/register') {
        final mockUser = UserModel(
          id: 1,
          name: data['name'],
          email: data['email'],
          phone: data['phone'] ?? '+51 987654321',
          active: true,
          createdAt: DateTime.now().toIso8601String(),
          updatedAt: DateTime.now().toIso8601String(),
        );
        
        final mockAuthData = {
          'success': true,
          'message': 'Registro exitoso',
          'data': {
            'user': mockUser.toJson(),
            'access_token': 'simulated_token_${DateTime.now().millisecondsSinceEpoch}',
            'token_type': 'Bearer',
          }
        };
        
        return ApiResponse<T>(
          success: true,
          message: 'Registro exitoso',
          data: mockAuthData as T,
        );
      }

      final response = await _dio.post(
        endpoint,
        data: formData,
        options: Options(
          contentType: Headers.multipartFormDataContentType,
          responseType: ResponseType.json,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        if (responseData is Map<String, dynamic>) {
          final success = responseData['success'] ?? true;
          final message = responseData['message'] ?? 'Operación exitosa';
          final resultData = responseData['data'] ?? responseData;

          if (success) {
            if (fromJson != null && resultData is Map<String, dynamic>) {
              return ApiResponse<T>(
                success: true,
                message: message,
                data: fromJson(resultData),
              );
            } else {
              return ApiResponse<T>(
                success: true,
                message: message,
                data: resultData as T,
              );
            }
          } else {
            return ApiResponse<T>(
              success: false,
              message: message,
              data: null,
            );
          }
        }
      }

      return ApiResponse<T>(
        success: false,
        message: 'Error del servidor: ${response.statusCode}',
        data: null,
      );
    } on DioException catch (e) {
      String errorMessage = 'Error de conexión';
      if (e.response != null) {
        if (e.response!.data is Map && e.response!.data['message'] != null) {
          errorMessage = e.response!.data['message'];
        } else {
          errorMessage = 'Error del servidor: ${e.response!.statusCode}';
        }
      } else {
        errorMessage = e.message ?? 'Error desconocido';
      }
      return ApiResponse<T>(
        success: false,
        message: errorMessage,
        data: null,
      );
    } catch (e) {
      return ApiResponse<T>(
        success: false,
        message: 'Error: ${e.toString()}',
        data: null,
      );
    }
  }

  Future<ApiResponse<List<Map<String, dynamic>>>> getUserReservations(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/reservas/user'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      
      print('API Response Status para Reservas: ${response.statusCode}');
      
      // Para simulación cuando no tenemos backend
      if (response.statusCode == 404 || response.statusCode == 401) {
        // Datos simulados de reservas
        final List<Map<String, dynamic>> mockReservas = [
          {
            'id': 1,
            'emprendedor_id': 1,
            'emprendedor_nombre': 'Hotel Andino',
            'fecha': '2023-07-15',
            'hora': '10:00',
            'estado': 'Confirmada',
            'tipo': 'Hospedaje',
          },
          {
            'id': 2,
            'emprendedor_id': 2,
            'emprendedor_nombre': 'Restaurante El Lago',
            'fecha': '2023-07-20',
            'hora': '13:30',
            'estado': 'Pendiente',
            'tipo': 'Gastronomía',
          },
          {
            'id': 3,
            'emprendedor_id': 3,
            'emprendedor_nombre': 'Tour Capachica',
            'fecha': '2023-08-01',
            'hora': '09:00',
            'estado': 'Confirmada',
            'tipo': 'Turismo',
          },
        ];
        
        return ApiResponse<List<Map<String, dynamic>>>(
          success: true,
          message: 'Reservas simuladas obtenidas',
          data: mockReservas,
        );
      }

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        final List<dynamic> reservasJson = jsonData is List 
            ? jsonData 
            : (jsonData['data'] is List ? jsonData['data'] : []);
            
        final List<Map<String, dynamic>> reservas = 
            reservasJson.map((json) => json as Map<String, dynamic>).toList();

        return ApiResponse<List<Map<String, dynamic>>>(
          success: true,
          message: 'Reservas obtenidas',
          data: reservas,
        );
      } else {
        String errorMessage = 'Error al obtener reservas';
        
        try {
          final jsonData = json.decode(response.body);
          if (jsonData is Map && jsonData.containsKey('message')) {
            errorMessage = jsonData['message'];
          }
        } catch (_) {}
        
        return ApiResponse<List<Map<String, dynamic>>>(
          success: false,
          message: errorMessage,
          data: null,
        );
      }
    } catch (e) {
      print('Exception: ${e.toString()}');
      
      // En caso de error, devolvemos datos de prueba
      final List<Map<String, dynamic>> mockReservas = [
        {
          'id': 1,
          'emprendedor_id': 1,
          'emprendedor_nombre': 'Hotel Andino',
          'fecha': '2023-07-15',
          'hora': '10:00',
          'estado': 'Confirmada',
          'tipo': 'Hospedaje',
        },
        {
          'id': 2,
          'emprendedor_id': 2,
          'emprendedor_nombre': 'Restaurante El Lago',
          'fecha': '2023-07-20',
          'hora': '13:30',
          'estado': 'Pendiente',
          'tipo': 'Gastronomía',
        },
        {
          'id': 3,
          'emprendedor_id': 3,
          'emprendedor_nombre': 'Tour Capachica',
          'fecha': '2023-08-01',
          'hora': '09:00',
          'estado': 'Confirmada',
          'tipo': 'Turismo',
        },
      ];
      
      return ApiResponse<List<Map<String, dynamic>>>(
        success: true,
        message: 'Reservas simuladas obtenidas',
        data: mockReservas,
      );
    }
  }
}