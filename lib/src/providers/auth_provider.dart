import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:price_tracker/src/services/auth_service.dart';

enum AuthStatus { unauthenticated, authenticating, authenticated }

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  AuthStatus _status = AuthStatus.unauthenticated;
  String? _errorMessage;

  // Simple list of admin UIDs for demonstration.
  // For a production app, use a more secure method like Firebase Custom Claims.
  final List<String> _adminUids = ['REPLACE_WITH_YOUR_ADMIN_UID']; // TODO: Replace with a real Admin UID

  User? get user => _user;
  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isAdmin => _user != null && _adminUids.contains(_user!.uid);

  AuthProvider() {
    _authService.authStateChanges.listen((User? user) {
      _user = user;
      _status = user == null ? AuthStatus.unauthenticated : AuthStatus.authenticated;
      notifyListeners();
    });
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();
    try {
      _user = await _authService.signInWithEmailAndPassword(email, password);
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message;
    } finally {
      _status = _user == null ? AuthStatus.unauthenticated : AuthStatus.authenticated;
      notifyListeners();
    }
  }

  Future<void> createUserWithEmailAndPassword(String email, String password) async {
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();
    try {
      _user = await _authService.createUserWithEmailAndPassword(email, password);
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message;
    } finally {
      _status = _user == null ? AuthStatus.unauthenticated : AuthStatus.authenticated;
      notifyListeners();
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _authService.sendPasswordResetEmail(email);
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}
