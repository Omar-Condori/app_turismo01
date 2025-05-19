import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Método para iniciar sesión con Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Iniciar el flujo de autenticación
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      // Si el usuario cancela el login, retorna null
      if (googleUser == null) {
        print('Usuario canceló el login de Google');
        return null;
      }
      
      // Obtener detalles de autenticación del request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      // Crear una nueva credencial
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      // Iniciar sesión en Firebase con la credencial
      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      
      print('Usuario logueado: ${userCredential.user?.displayName} (${userCredential.user?.email})');
      
      return userCredential;
    } catch (e) {
      print('Error durante el inicio de sesión con Google: $e');
      return null;
    }
  }

  // Método para cerrar sesión
  Future<void> signOut() async {
    try {
      // Cerrar sesión en Firebase y Google Sign In
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
      print('Sesión cerrada correctamente');
    } catch (e) {
      print('Error al cerrar sesión: $e');
      rethrow;
    }
  }

  // Verificar si hay un usuario logueado
  bool get isSignedIn => _firebaseAuth.currentUser != null;
  
  // Obtener el usuario actual
  User? get currentUser => _firebaseAuth.currentUser;
  
  // Obtener token ID para backend
  Future<String?> getIdToken() async {
    if (_firebaseAuth.currentUser != null) {
      return await _firebaseAuth.currentUser!.getIdToken();
    }
    return null;
  }
} 