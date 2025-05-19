import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../data/models/user_model.dart';

class StorageKeys {
  static const String token = 'auth_token';
  static const String user = 'user_data';
  static const String tokenType = 'token_type';
}

class StorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Guardar token
  Future<void> saveToken(String token) async {
    await _storage.write(key: StorageKeys.token, value: token);
  }

  // Obtener token
  Future<String?> getToken() async {
    return await _storage.read(key: StorageKeys.token);
  }

  // Guardar tipo de token
  Future<void> saveTokenType(String tokenType) async {
    await _storage.write(key: StorageKeys.tokenType, value: tokenType);
  }

  // Obtener tipo de token
  Future<String> getTokenType() async {
    return await _storage.read(key: StorageKeys.tokenType) ?? 'Bearer';
  }

  // Guardar usuario
  Future<void> saveUser(UserModel user) async {
    final String userJson = jsonEncode(user.toJson());
    await _storage.write(key: StorageKeys.user, value: userJson);
  }

  // Obtener usuario
  Future<UserModel?> getUser() async {
    final String? userJson = await _storage.read(key: StorageKeys.user);
    if (userJson != null) {
      return UserModel.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  // Guardar los datos de autenticación completos
  Future<void> saveAuthData(AuthData authData) async {
    if (authData.accessToken.isNotEmpty) {
    await saveToken(authData.accessToken);
    await saveTokenType(authData.tokenType);
    await saveUser(authData.user);
    } else {
      throw Exception('Token de acceso no válido');
    }
  }

  // Borrar datos de autenticación (logout)
  Future<void> clearAuthData() async {
    await _storage.delete(key: StorageKeys.token);
    await _storage.delete(key: StorageKeys.tokenType);
    await _storage.delete(key: StorageKeys.user);
  }

  // Verificar si el usuario está autenticado
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}