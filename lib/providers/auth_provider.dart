import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  User? _user;
  bool _isLoading = false;
  bool _isInitialized = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _initGoogleSignIn();
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<void> _initGoogleSignIn() async {
    try {
      await _googleSignIn.initialize();
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error al inicializar Google Sign-In: $e');
    }
  }

  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    try {
      // Proveedor directo de Google para Web y Móvil
      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      // Iniciar sesión con Popup de Firebase
      await _auth.signInWithPopup(googleProvider);

      _setLoading(false);
      return true;
    } catch (e) {
      debugPrint('Error al iniciar sesión con Google: $e');
      _setLoading(false);
      return false;
    }
  }

  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    await _auth.signOut();
    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}