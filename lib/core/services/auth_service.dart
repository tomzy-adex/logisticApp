import '../models/user.dart';
import '../models/log.dart';
import 'storage_service.dart';
import '../../data/mock_data.dart';

class AuthService {
  static User? _currentUser;

  static User? get currentUser => _currentUser;

  static Future<bool> login(String email, String password) async {
    try {
      final user = MockData.authenticateUser(email, password);
      if (user != null) {
        _currentUser = user;
        await StorageService.saveUser(user);
        
        // Log the login activity
        await _logActivity(LogType.login, user, 'User logged in');
        
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<void> logout() async {
    if (_currentUser != null) {
      await _logActivity(LogType.login, _currentUser!, 'User logged out');
    }
    _currentUser = null;
    await StorageService.clearUser();
  }

  static Future<void> initializeSession() async {
    _currentUser = await StorageService.getUser();
  }

  static bool get isLoggedIn => _currentUser != null;
  static bool get isAdmin => _currentUser?.isAdmin ?? false;
  static bool get isUser => _currentUser?.isUser ?? false;

  static Future<void> _logActivity(LogType type, User user, String description) async {
    final log = Log(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: type,
      userId: user.id,
      userEmail: user.email,
      description: description,
      timestamp: DateTime.now(),
    );

    final logs = await StorageService.getLogs();
    logs.add(log);
    await StorageService.saveLogs(logs);
  }
} 