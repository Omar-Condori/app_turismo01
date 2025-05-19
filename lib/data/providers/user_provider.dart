import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  String? _token;

  UserModel? get user => _user;
  bool get isLoggedIn => _user != null && _token != null;
  String? get token => _token;

  // Verificar si el usuario es administrador
  bool get isAdmin => _user?.email == 'admin@example.com';

  void setUser(UserModel user, String token) {
    _user = user;
    _token = token;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    _token = null;
    notifyListeners();
  }

  // ✅ Método logout sin modificar lógica existente
  void logout() {
    clearUser();
  }
}
