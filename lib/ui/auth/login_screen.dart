import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;

import '../../data/providers/api_provider.dart';
import '../../data/models/api_response_model.dart';
import '../../data/models/user_model.dart';
import '../../data/providers/user_provider.dart';
import '../../data/services/google_auth_service.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _isDarkMode = true; // Estado para el modo día/noche
  final GoogleAuthService _googleAuthService = GoogleAuthService();
  File? _profileImage;
  bool _rememberMe = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        _profileImage = File(photo.path);
      });
    }
  }

  // Función para alternar entre modo día y noche
  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    final apiProvider = ApiProvider();
    try {
      final Map<String, dynamic> data = {
        'email': _emailController.text.trim(),
        'password': _passwordController.text,
        'remember': _rememberMe ? '1' : '0',
      };
      if (_profileImage != null) {
        data['foto_perfil'] = await dio.MultipartFile.fromFile(_profileImage!.path, filename: _profileImage!.path.split('/').last);
      }
      final response = await apiProvider.postMultipart<Map<String, dynamic>>(
        '/login',
        data: data,
      );
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      if (response.success && response.data != null) {
        _showSuccessDialog(response.data!);
      } else {
        _showErrorSnackbar(response.message);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showErrorSnackbar('Error: ${e.toString()}');
      }
    }
  }

  void _showSuccessDialog(Map<String, dynamic> authData) {
    try {
      // Extraer datos del usuario para guardar en UserProvider
      final userData = authData['data']?['user'];
      final token = authData['data']?['access_token'];

      if (userData != null && token != null) {
        // Parsear a UserModel
        final userModel = UserModel.fromJson(userData);

        // Guardar en el provider
        Provider.of<UserProvider>(context, listen: false).setUser(userModel, token.toString());
      }

      // Mostrar diálogo de éxito
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Inicio de sesión exitoso'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('¡Bienvenido ${authData['data']?['user']?['name'] ?? 'Usuario'}!'),
              const SizedBox(height: 8),
              const Text('Has iniciado sesión correctamente.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Volver a la pantalla principal
                Navigator.of(context).pop();
              },
              child: const Text('Continuar', style: TextStyle(color: Color(0xFFFFA500))),
            ),
          ],
        ),
      );
    } catch (e) {
      print('Error al procesar datos de usuario: $e');
      _showErrorSnackbar('Error al procesar los datos de usuario');
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Colores basados en el modo actual
    final backgroundColor = _isDarkMode ? const Color(0xFF181C2E) : const Color(0xFFF5F5F5);
    final cardColor = _isDarkMode ? const Color(0xFF23284A) : Colors.white;
    final textColor = _isDarkMode ? Colors.white : Colors.black87;
    final hintColor = _isDarkMode ? Colors.white54 : Colors.grey;
    final iconColor = _isDarkMode ? Colors.white70 : Colors.grey.shade600;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header con flecha de retroceso y toggle de modo día/noche
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Flecha para retroceder
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: textColor,
                        size: 24,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    // Toggle modo día/noche
                    IconButton(
                      onPressed: _toggleDarkMode,
                      icon: Icon(
                        _isDarkMode ? Icons.light_mode : Icons.dark_mode,
                        color: _isDarkMode ? Colors.yellow : Colors.grey.shade700,
                        size: 28,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              // Imagen superior con bordes redondeados solo arriba
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 320,
                      child: _profileImage != null
                          ? Image.file(_profileImage!, fit: BoxFit.cover)
                          : Image.asset('assets/images/foto1.jpg', fit: BoxFit.cover),
                    ),
                    Positioned(
                      bottom: 24,
                      child: GestureDetector(
                        onTap: () async {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: cardColor,
                            builder: (context) => Container(
                              height: 120,
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: Icon(Icons.photo_camera, color: iconColor),
                                    title: Text('Tomar foto', style: TextStyle(color: textColor)),
                                    onTap: () {
                                      Navigator.pop(context);
                                      _takePhoto();
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.photo_library, color: iconColor),
                                    title: Text('Seleccionar de galería', style: TextStyle(color: textColor)),
                                    onTap: () {
                                      Navigator.pop(context);
                                      _pickImage();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(Icons.camera_alt, color: Color(0xFF181C2E), size: 28),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        'Welcome!',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 32),
                      Container(
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: _isDarkMode ? [] : [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: _emailController,
                          style: TextStyle(color: textColor),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.person, color: iconColor),
                            hintText: 'Username',
                            hintStyle: TextStyle(color: hintColor),
                            contentPadding: const EdgeInsets.symmetric(vertical: 20),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa tu usuario';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 18),
                      Container(
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: _isDarkMode ? [] : [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: TextStyle(color: textColor),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.lock, color: iconColor),
                            hintText: 'Password',
                            hintStyle: TextStyle(color: hintColor),
                            contentPadding: const EdgeInsets.symmetric(vertical: 20),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                color: iconColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa tu contraseña';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value ?? false;
                              });
                            },
                            activeColor: const Color(0xFF4ADE80),
                          ),
                          Text('Remember me', style: TextStyle(color: hintColor)),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                              );
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(color: Color(0xFF4ADE80), fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        height: 54,
                        child: _isLoading
                            ? const Center(child: CircularProgressIndicator(color: Color(0xFF4ADE80)))
                            : ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            elevation: 0,
                            backgroundColor: const Color(0xFF4ADE80),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text(
                            'LOGIN',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account?',
                            style: TextStyle(color: hintColor, fontSize: 15),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const RegisterScreen()),
                              );
                            },
                            child: const Text(
                              'Sign up',
                              style: TextStyle(
                                color: Color(0xFF4ADE80),
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loginWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Intentar inicio de sesión con Google usando Firebase
      final UserCredential? userCredential = await _googleAuthService.signInWithGoogle();

      if (userCredential == null || userCredential.user == null) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          _showErrorSnackbar('No se pudo completar el inicio de sesión con Google');
        }
        return;
      }

      // Obtener el token ID para enviar al backend
      final String? idToken = await userCredential.user!.getIdToken();

      if (idToken == null) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          _showErrorSnackbar('No se pudo obtener el token de autenticación');
        }
        return;
      }

      // Obtener información del usuario de Firebase
      final User user = userCredential.user!;

      // Crear un objeto UserModel con la información de Firebase
      final userModel = UserModel(
        id: 0, // El ID real vendrá del backend
        name: user.displayName ?? 'Usuario de Google',
        email: user.email ?? '',
        phone: user.phoneNumber ?? '',
        active: true,
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );

      // Simular respuesta exitosa (en producción llamaríamos al backend)
      final Map<String, dynamic> authData = {
        'success': true,
        'message': 'Inicio de sesión con Google exitoso',
        'data': {
          'user': userModel.toJson(),
          'access_token': idToken,
          'token_type': 'Bearer',
        }
      };

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        _showSuccessDialog(authData);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showErrorSnackbar('Error: ${e.toString()}');
      }
    }
  }
}