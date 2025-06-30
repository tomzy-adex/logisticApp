import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/shipment.dart';
import '../models/log.dart';

class StorageService {
  static const String _userKey = 'current_user';
  static const String _shipmentsKey = 'shipments';
  static const String _logsKey = 'logs';

  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  static Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  static Future<void> saveShipments(List<Shipment> shipments) async {
    final prefs = await SharedPreferences.getInstance();
    final shipmentsJson = shipments.map((s) => s.toJson()).toList();
    await prefs.setString(_shipmentsKey, jsonEncode(shipmentsJson));
  }

  static Future<List<Shipment>> getShipments() async {
    final prefs = await SharedPreferences.getInstance();
    final shipmentsJson = prefs.getString(_shipmentsKey);
    if (shipmentsJson != null) {
      final List<dynamic> jsonList = jsonDecode(shipmentsJson);
      return jsonList.map((json) => Shipment.fromJson(json)).toList();
    }
    return [];
  }

  static Future<void> saveLogs(List<Log> logs) async {
    final prefs = await SharedPreferences.getInstance();
    final logsJson = logs.map((l) => l.toJson()).toList();
    await prefs.setString(_logsKey, jsonEncode(logsJson));
  }

  static Future<List<Log>> getLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final logsJson = prefs.getString(_logsKey);
    if (logsJson != null) {
      final List<dynamic> jsonList = jsonDecode(logsJson);
      return jsonList.map((json) => Log.fromJson(json)).toList();
    }
    return [];
  }

  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
} 