class ApiConstants {
  // Base URL
  static const String apiBaseUrl = 'http://127.0.0.1:8000';

  // Endpoints
  static const String loginEndpoint = '/api/login';
  static const String registerEndpoint = '/api/register';
  static const String logoutEndpoint = '/api/logout';
  static const String profileEndpoint = '/api/me';

  // Añade:
  static const String emprendedoresEndpoint = '/api/emprendedores';
  static const String reservasEndpoint = '/api/reservas';

  // Headers
  static Map<String, String> headers({String? token}) {
    final Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  // Content-Type para multipart/form-data (usado en registro)
  static Map<String, String> multipartHeaders({String? token}) {
    final Map<String, String> headers = {
      'Accept': 'application/json',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }
}