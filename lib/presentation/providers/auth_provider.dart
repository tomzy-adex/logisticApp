import 'package:flutter/foundation.dart';
import '../../core/models/user.dart';
import '../../core/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _user != null;
  bool get isAdmin => _user?.isAdmin ?? false;
  bool get isUser => _user?.isUser ?? false;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      await AuthService.initializeSession();
      _user = AuthService.currentUser;
      _error = null;
    } catch (e) {
      _error = 'Failed to initialize session';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final success = await AuthService.login(email, password);
      if (success) {
        _user = AuthService.currentUser;
        _error = null;
      } else {
        _error = 'Invalid email or password';
      }
      return success;
    } catch (e) {
      _error = 'Login failed: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await AuthService.logout();
      _user = null;
      _error = null;
    } catch (e) {
      _error = 'Logout failed: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
} 