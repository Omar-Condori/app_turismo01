import 'dart:io';
import 'package:flutter/foundation.dart';
import '../data/models/user_model.dart';
import '../data/models/api_response_model.dart';
import '../data/repositories/auth_repository.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error
}

class AuthViewModel with ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  AuthStatus _status = AuthStatus.initial;
  UserModel? _user;
  String _errorMessage = '';
  bool _isInitialized = false;

  // Getters
  AuthStatus get status => _status;
  UserModel? get user => _user;
  String get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  AuthViewModel() {
    _init();
  }

  // Inicializar el estado de autenticación
  Future<void> _init() async {
    if (_isInitialized) return;

    _status = AuthStatus.loading;
    notifyListeners();

    try {
      final isAuth = await _authRepository.isAuthenticated();

      if (isAuth) {
        _user = await _authRepository.getCurrentUser();
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString();
    }

    _isInitialized = true;
    notifyListeners();
  }

  // Login
  Future<bool> login(String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      print('🔍 [AuthViewModel] Iniciando proceso de login para: $email');
      final ApiResponse<AuthData> response = await _authRepository.login(email, password);
      print('✅ [AuthViewModel] Respuesta del login: '
          'success=${response.success}, '
          'message=${response.message}');

      if (response.success && response.data != null) {
        print('✅ [AuthViewModel] Login exitoso para usuario: ${response.data!.user.name}');
        _user = response.data!.user;
        _status = AuthStatus.authenticated;
        notifyListeners();
        return true;
      } else {
        print('❌ [AuthViewModel] Error en login: ${response.message}');
        _status = AuthStatus.error;
        _errorMessage = response.message;
        notifyListeners();
        return false;
      }
    } catch (e) {
      print('❌ [AuthViewModel] Excepción en login: $e');
      _status = AuthStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Registro
  Future<bool> register({
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
    _status = AuthStatus.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      final ApiResponse<AuthData> response = await _authRepository.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        phone: phone,
        fotoPerfil: fotoPerfil,
        country: country,
        birthDate: birthDate,
        address: address,
        gender: gender,
        preferredLanguage: preferredLanguage,
      );

      if (response.success && response.data != null) {
        _user = response.data!.user;
        _status = AuthStatus.authenticated;
        notifyListeners();
        return true;
      } else {
        _status = AuthStatus.error;
        _errorMessage = response.message;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    _status = AuthStatus.loading;
    notifyListeners();

    try {
      await _authRepository.logout();
      _user = null;
      _status = AuthStatus.unauthenticated;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }
}