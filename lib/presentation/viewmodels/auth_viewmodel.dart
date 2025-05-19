import 'dart:io';

import 'package:flutter/material.dart';

import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../../services/storage_service.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  final StorageService _storageService = StorageService();
  
  AuthStatus _status = AuthStatus.initial;
  String _errorMessage = '';
  AuthData? _authData;

  AuthViewModel({required AuthRepository authRepository}) : _authRepository = authRepository {
    // Verificar si hay un usuario autenticado al iniciar
    _checkAuth();
  }

  AuthStatus get status => _status;
  String get errorMessage => _errorMessage;
  AuthData? get authData => _authData;
  UserModel? get user => _authData?.user;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  Future<void> _checkAuth() async {
    try {
      final isLoggedIn = await _storageService.isAuthenticated();
      if (isLoggedIn) {
        final userData = await _storageService.getUser();
        if (userData != null) {
          _status = AuthStatus.authenticated;
          // Reconstruir AuthData (parcialmente) con lo guardado
          final token = await _storageService.getToken() ?? '';
          final tokenType = await _storageService.getTokenType();
          _authData = AuthData(
            user: userData,
            accessToken: token,
            tokenType: tokenType,
          );
        } else {
          _status = AuthStatus.unauthenticated;
        }
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    try {
      _status = AuthStatus.loading;
      _errorMessage = '';
      notifyListeners();

      final response = await _authRepository.login(email, password);

      if (response.success && response.data != null) {
        _authData = response.data;
        _status = AuthStatus.authenticated;
        await _storageService.saveAuthData(response.data!);
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
      _errorMessage = 'Error al iniciar sesión: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    try {
      _status = AuthStatus.loading;
      notifyListeners();
      
      await _authRepository.logout();
      await _storageService.clearAuthData();
      
      _authData = null;
      _status = AuthStatus.unauthenticated;
    } catch (e) {
      _errorMessage = 'Error al cerrar sesión: ${e.toString()}';
    }
    notifyListeners();
  }

  Future<void> register({
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
    try {
      _status = AuthStatus.loading;
      _errorMessage = '';
      notifyListeners();

      // Mapear el género a los valores aceptados por el servidor
      String? mappedGender;
      if (gender != null) {
        switch (gender.toLowerCase()) {
          case 'masculino':
            mappedGender = 'male';
            break;
          case 'femenino':
            mappedGender = 'female';
            break;
          case 'otro':
            mappedGender = 'other';
            break;
          case 'prefiero no decir':
            mappedGender = 'prefer_not_to_say';
            break;
          default:
            mappedGender = null;
        }
      }

      final response = await _authRepository.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        phone: phone,
        fotoPerfil: fotoPerfil,
        country: country,
        birthDate: birthDate,
        address: address,
        gender: mappedGender,
        preferredLanguage: preferredLanguage,
      );

      if (response.success && response.data != null) {
        _authData = response.data;
        _status = AuthStatus.authenticated;
        await _storageService.saveAuthData(response.data!);
      } else {
        _status = AuthStatus.error;
        _errorMessage = response.message;
      }
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }
} 