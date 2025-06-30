import 'package:flutter/foundation.dart';
import '../../core/models/log.dart';
import '../../core/services/storage_service.dart';

class LogProvider with ChangeNotifier {
  List<Log> _logs = [];
  bool _isLoading = false;
  String? _error;

  List<Log> get logs => _logs;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Log> get sortedLogs {
    final sorted = List<Log>.from(_logs);
    sorted.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return sorted;
  }

  Future<void> loadLogs() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _logs = await StorageService.getLogs();
      _error = null;
    } catch (e) {
      _error = 'Failed to load logs: ${e.toString()}';
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