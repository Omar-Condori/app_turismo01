// lib/data/models/api_response_model.dart
class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory ApiResponse.success(T data, [String message = 'Operación exitosa']) {
    return ApiResponse<T>(
      success: true,
      message: message,
      data: data,
    );
  }

  factory ApiResponse.error(String message) {
    return ApiResponse<T>(
      success: false,
      message: message,
      data: null,
    );
  }
}