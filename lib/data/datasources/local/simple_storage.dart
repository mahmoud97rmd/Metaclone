/// ═══════════════════════════════════════════════════════════
/// Simple Storage - بديل مبسط للـ Database
/// ═══════════════════════════════════════════════════════════
library;

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

class SimpleStorage {
  final SharedPreferences prefs;
  final Logger logger;

  SimpleStorage({
    required this.prefs,
    required this.logger,
  });

  // ════════════════════════════════════════════════════════════
  // Save/Load JSON Data
  // ════════════════════════════════════════════════════════════

  Future<void> saveData(String key, Map<String, dynamic> data) async {
    try {
      final jsonString = jsonEncode(data);
      await prefs.setString(key, jsonString);
      logger.d('Data saved: $key');
    } catch (e) {
      logger.e('Error saving data', error: e);
      rethrow;
    }
  }

  Map<String, dynamic>? loadData(String key) {
    try {
      final jsonString = prefs.getString(key);
      if (jsonString == null) return null;
      
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      logger.e('Error loading data', error: e);
      return null;
    }
  }

  Future<void> saveList(String key, List<Map<String, dynamic>> list) async {
    try {
      final jsonString = jsonEncode(list);
      await prefs.setString(key, jsonString);
      logger.d('List saved: $key');
    } catch (e) {
      logger.e('Error saving list', error: e);
      rethrow;
    }
  }

  List<Map<String, dynamic>> loadList(String key) {
    try {
      final jsonString = prefs.getString(key);
      if (jsonString == null) return [];
      
      final decoded = jsonDecode(jsonString) as List;
      return decoded.map((e) => e as Map<String, dynamic>).toList();
    } catch (e) {
      logger.e('Error loading list', error: e);
      return [];
    }
  }

  Future<void> clear() async {
    await prefs.clear();
    logger.d('Storage cleared');
  }
}
