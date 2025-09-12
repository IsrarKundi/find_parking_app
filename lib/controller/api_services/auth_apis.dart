import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import '../utils/base_url.dart';

class AuthApis {
  final String _baseUrl = baseUrl;

  // Register API
  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    required String role,
    required double lng,
    required double lat,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/auth/register');

      final body = jsonEncode({
        'username': username,
        'email': email,
        'password': password,
        'role': role,
        'lng': lng,
        'lat': lat,
      });

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      final responseData = jsonDecode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201) && responseData['success'] == true) {
        return responseData;
      } else {
        // Handle different error response formats
        String errorMessage = 'Registration failed';
        if (responseData is Map && responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        } else if (responseData is Map && responseData.containsKey('error')) {
          errorMessage = responseData['error'];
        } else {
          errorMessage = 'Registration failed with status code: ${response.statusCode}';
        }

        return {
          'success': false,
          'message': errorMessage,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  // Login API
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/auth/login');

      final body = jsonEncode({
        'email': email,
        'password': password,
      });

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      final responseData = jsonDecode(response.body);
      log("Login response: ${response.body}");
      if (response.statusCode == 200 && responseData['success'] == true) {
        return responseData;
      } else {
        // Handle different error response formats
        String errorMessage = 'Login failed';
        if (responseData is Map && responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        } else if (responseData is Map && responseData.containsKey('error')) {
          errorMessage = responseData['error'];
        } else {
          errorMessage = 'Login failed with status code: ${response.statusCode}';
        }

        return {
          'success': false,
          'message': errorMessage,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  // Forgot Password API
  Future<Map<String, dynamic>> forgotPassword({
    required String email,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/auth/forget-password');

      final body = jsonEncode({
        'email': email,
      });

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      final responseData = jsonDecode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201) && responseData['success'] == true) {
        return responseData;
      } else {
        // Handle different error response formats
        String errorMessage = 'Failed to send OTP';
        if (responseData is Map && responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        } else if (responseData is Map && responseData.containsKey('error')) {
          errorMessage = responseData['error'];
        } else {
          errorMessage = 'Failed to send OTP with status code: ${response.statusCode}';
        }

        return {
          'success': false,
          'message': errorMessage,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  // Verify OTP API
  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/auth/verify-forget-password-otp');

      final body = jsonEncode({
        'email': email,
        'otp': otp,
      });

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      final responseData = jsonDecode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201) && responseData['success'] == true) {
        return responseData;
      } else {
        // Handle different error response formats
        String errorMessage = 'OTP verification failed';
        if (responseData is Map && responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        } else if (responseData is Map && responseData.containsKey('error')) {
          errorMessage = responseData['error'];
        } else {
          errorMessage = 'OTP verification failed with status code: ${response.statusCode}';
        }

        return {
          'success': false,
          'message': errorMessage,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  // Reset Password API
  Future<Map<String, dynamic>> resetPassword({
    required String resetToken,
    required String password,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/auth/reset-password');

      final body = jsonEncode({
        'resetToken': resetToken,
        'password': password,
      });

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      final responseData = jsonDecode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201) && responseData['success'] == true) {
        return responseData;
      } else {
        // Handle different error response formats
        String errorMessage = 'Password reset failed';
        if (responseData is Map && responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        } else if (responseData is Map && responseData.containsKey('error')) {
          errorMessage = responseData['error'];
        } else {
          errorMessage = 'Password reset failed with status code: ${response.statusCode}';
        }

        return {
          'success': false,
          'message': errorMessage,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }
}