import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _usernameKey = 'username';
  static const String _emailKey = 'email';
  static const String _roleKey = 'role';
  static const String _lngKey = 'lng';
  static const String _latKey = 'lat';
  static const String _isLoggedInKey = 'is_logged_in';

  // Save user data after successful login
  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_tokenKey, userData['token'] ?? '');
    await prefs.setString(_userIdKey, userData['_id'] ?? '');
    await prefs.setString(_usernameKey, userData['username'] ?? '');
    await prefs.setString(_emailKey, userData['email'] ?? '');
    await prefs.setString(_roleKey, userData['role'] ?? '');
    await prefs.setDouble(_lngKey, userData['lng'] ?? 0.0);
    await prefs.setDouble(_latKey, userData['lat'] ?? 0.0);
    await prefs.setBool(_isLoggedInKey, true);
  }

  // Get stored token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Get stored user data
  static Future<Map<String, dynamic>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      'token': prefs.getString(_tokenKey) ?? '',
      'userId': prefs.getString(_userIdKey) ?? '',
      'username': prefs.getString(_usernameKey) ?? '',
      'email': prefs.getString(_emailKey) ?? '',
      'role': prefs.getString(_roleKey) ?? '',
      'lng': prefs.getDouble(_lngKey) ?? 0.0,
      'lat': prefs.getDouble(_latKey) ?? 0.0,
      'isLoggedIn': prefs.getBool(_isLoggedInKey) ?? false,
    };
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Clear all stored data (logout)
  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Update specific user data
  static Future<void> updateUserData({
    String? username,
    String? email,
    String? role,
    double? lng,
    double? lat,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    if (username != null) await prefs.setString(_usernameKey, username);
    if (email != null) await prefs.setString(_emailKey, email);
    if (role != null) await prefs.setString(_roleKey, role);
    if (lng != null) await prefs.setDouble(_lngKey, lng);
    if (lat != null) await prefs.setDouble(_latKey, lat);
  }
}