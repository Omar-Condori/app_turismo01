class UserModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final bool active;
  final String? fotoPerfil;
  final String? country;
  final String? birthDate;
  final String? address;
  final String? gender;
  final String? preferredLanguage;
  final String? lastLogin;
  final String createdAt;
  final String updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.active,
    this.fotoPerfil,
    this.country,
    this.birthDate,
    this.address,
    this.gender,
    this.preferredLanguage,
    this.lastLogin,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      active: json['active'] ?? false,
      fotoPerfil: json['foto_perfil'],
      country: json['country'],
      birthDate: json['birth_date'],
      address: json['address'],
      gender: json['gender'],
      preferredLanguage: json['preferred_language'],
      lastLogin: json['last_login'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'active': active,
      'foto_perfil': fotoPerfil,
      'country': country,
      'birth_date': birthDate,
      'address': address,
      'gender': gender,
      'preferred_language': preferredLanguage,
      'last_login': lastLogin,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class AuthResponse {
  final bool success;
  final String message;
  final AuthData? data;

  AuthResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    try {
      print('🔍 [AuthResponse] Parseando JSON: $json');
      
      final data = json['data'];
      AuthData? authData;
      
      if (data != null && data is Map<String, dynamic>) {
        try {
          authData = AuthData.fromJson(data);
        } catch (e) {
          print('❌ [AuthResponse] Error al parsear AuthData: $e');
        }
      }

    return AuthResponse(
      success: json['success'] ?? false,
        message: json['message'] ?? 'No se recibió mensaje del servidor',
        data: authData,
    );
    } catch (e) {
      print('❌ [AuthResponse] Error al parsear JSON: $e');
      print('❌ [AuthResponse] JSON recibido: $json');
      rethrow;
    }
  }
}

class AuthData {
  final UserModel user;
  final List<String>? roles;
  final List<String>? permissions;
  final String? administraEmprendimientos;
  final String accessToken;
  final String tokenType;
  final String? emailVerified;

  AuthData({
    required this.user,
    this.roles,
    this.permissions,
    this.administraEmprendimientos,
    required this.accessToken,
    required this.tokenType,
    this.emailVerified,
  });

  factory AuthData.fromJson(Map<String, dynamic> json) {
    try {
      // Convert roles and permissions to List<String> if they are lists
      List<String>? rolesList;
      if (json['roles'] != null) {
        if (json['roles'] is List) {
          rolesList = List<String>.from(json['roles']);
        } else if (json['roles'] is String) {
          rolesList = [json['roles']];
        }
      }

      List<String>? permissionsList;
      if (json['permissions'] != null) {
        if (json['permissions'] is List) {
          permissionsList = List<String>.from(json['permissions']);
        } else if (json['permissions'] is String) {
          permissionsList = [json['permissions']];
        }
      }

      // Convertir emailVerified a String si es booleano
      String? emailVerifiedStr;
      if (json['email_verified'] != null) {
        if (json['email_verified'] is bool) {
          emailVerifiedStr = json['email_verified'].toString();
        } else if (json['email_verified'] is String) {
          emailVerifiedStr = json['email_verified'];
        }
      }

    return AuthData(
      user: UserModel.fromJson(json['user'] ?? {}),
        roles: rolesList,
        permissions: permissionsList,
        administraEmprendimientos: json['administra_emprendimientos']?.toString(),
        accessToken: json['access_token']?.toString() ?? '',
        tokenType: json['token_type']?.toString() ?? 'Bearer',
        emailVerified: emailVerifiedStr,
      );
    } catch (e) {
      print('❌ [AuthData] Error al parsear JSON: $e');
      print('❌ [AuthData] JSON recibido: $json');
      rethrow;
    }
  }
}