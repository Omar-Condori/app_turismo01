// lib/data/repositories/auth_repository.dart

import 'dart:io';

import 'package:dio/dio.dart';

import '../../config/api_constants.dart';
import '../../services/storage_service.dart';
import '../models/api_response_model.dart';   // Aquí tienes ApiResponse<T>, AuthResponse y AuthData
import '../models/user_model.dart';
import '../providers/api_provider.dart';

class AuthRepository {
  final ApiProvider _apiProvider = ApiProvider();
  final StorageService _storageService = StorageService();

  /// Login: invoca POST /login y parsea el AuthResponse.
  Future<ApiResponse<AuthData>> login(String email, String password) async {
    try {
      final resp = await _apiProvider.post<Map<String, dynamic>>(
        ApiConstants.loginEndpoint,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (!resp.success || resp.data == null) {
        return ApiResponse.error(resp.message);
      }

      // Convierte el Map<String,dynamic> a AuthResponse
      final authResp = AuthResponse.fromJson(resp.data!);
      if (authResp.data == null) {
        return ApiResponse.error('No se recibieron datos de autenticación');
      }

      // Guarda token + usuario
      await _storageService.saveAuthData(authResp.data!);
      return ApiResponse.success(authResp.data!, authResp.message);
    } catch (e) {
      print('❌ [AuthRepository] Error en login: $e');
      return ApiResponse.error('Error al iniciar sesión: ${e.toString()}');
    }
  }

  /// Registro: invoca POST /register con multipart/form-data (foto opcional).
  Future<ApiResponse<AuthData>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? phone,
    File? fotoPerfil,
    String? country,
    String? birthDate,
    String? address,
    String? gender,
    String? preferredLanguage,
  }) async {
    // Construye el payload
    final formData = <String, dynamic>{
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
    };
    if (phone != null) formData['phone'] = phone;
    if (country != null) formData['country'] = country;
    if (birthDate != null) formData['birth_date'] = birthDate;
    if (address != null) formData['address'] = address;
    if (gender != null) formData['gender'] = gender;
    if (preferredLanguage != null) {
      formData['preferred_language'] = preferredLanguage;
    }
    if (fotoPerfil != null) {
      formData['foto_perfil'] = await MultipartFile.fromFile(
        fotoPerfil.path,
        filename: fotoPerfil.path.split('/').last,
      );
    }

    final resp = await _apiProvider.postMultipart<Map<String, dynamic>>(
      ApiConstants.registerEndpoint,
      data: formData,
      fromJson: null,
    );

    if (!resp.success || resp.data == null) {
      return ApiResponse.error(resp.message);
    }

    final authResp = AuthResponse.fromJson(resp.data!);
    if (authResp.data == null) {
      return ApiResponse.error('No se recibieron datos de autenticación');
    }

    await _storageService.saveAuthData(authResp.data!);
    return ApiResponse.success(authResp.data!, 'Registro exitoso');
  }

  /// Verifica si existe token válido.
  Future<bool> isAuthenticated() => _storageService.isAuthenticated();

  /// Extrae el usuario almacenado.
  Future<UserModel?> getCurrentUser() => _storageService.getUser();

  /// Limpia credenciales.
  Future<void> logout() => _storageService.clearAuthData();
}
