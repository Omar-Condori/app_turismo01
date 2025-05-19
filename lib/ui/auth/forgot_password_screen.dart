import 'package:flutter/material.dart';
import '../../data/providers/api_provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final apiProvider = ApiProvider();
    try {
      final response = await apiProvider.post<Map<String, dynamic>>(
        '/forgot-password',
        data: {
          'email': _emailController.text.trim(),
        },
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
          if (response.success) {
            _emailSent = true;
          }
        });
      }

      if (!response.success) {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar Contraseña'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _emailSent ? _buildSuccessView() : _buildFormView(),
        ),
      ),
    );
  }

  Widget _buildFormView() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          Container(
            alignment: Alignment.center,
            child: const Icon(
              Icons.lock_reset,
              size: 80,
              color: Color(0xFFFFA500),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Recuperar Contraseña',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'Ingresa tu correo electrónico y te enviaremos un enlace para restablecer tu contraseña.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 30),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Correo electrónico',
              hintText: 'ejemplo@correo.com',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa tu correo electrónico';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Ingresa un correo electrónico válido';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 50,
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFFFA500),
                    ),
                  )
                : ElevatedButton(
                    onPressed: _resetPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFA500),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Enviar instrucciones',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Volver a iniciar sesión',
              style: TextStyle(color: Color(0xFFFFA500)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 40),
        Container(
          alignment: Alignment.center,
          child: const Icon(
            Icons.check_circle,
            size: 100,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          '¡Correo enviado!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        const Text(
          'Hemos enviado un correo electrónico con instrucciones para restablecer tu contraseña.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(
          'Revisa tu bandeja de entrada en: ${_emailController.text}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFA500),
              foregroundColor: Colors.white,
            ),
            child: const Text(
              'Volver a inicio de sesión',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
} 