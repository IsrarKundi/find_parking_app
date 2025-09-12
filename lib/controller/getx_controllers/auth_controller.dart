import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:parking_app/views/screens/authentication/login_screen.dart';
import 'package:parking_app/views/screens/home/home_screen.dart';
import 'package:parking_app/views/screens/parking_dashboard/parking_dashboard_screen.dart';

import '../api_services/auth_apis.dart';
import '../utils/shared_preferences_service.dart';
import '../../views/screens/authentication/otp_verification_screen.dart';
import '../../views/screens/authentication/reset_password_screen.dart';

class AuthController extends GetxController {
  final AuthApis _authApis = AuthApis();

  // Observable variables
  var isLoading = false.obs;
  var selectedRole = 'user'.obs;
  var selectedLocation = Rx<Position?>(null);

  // Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Login controllers
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();

  // Forgot password controllers
  final forgotEmailController = TextEditingController();
  final otpController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();

  // Forgot password variables
  var resetToken = ''.obs;
  var userEmail = ''.obs;

  // Role options
  final List<String> roles = ['user', 'parking owner'];

  @override
  // void onClose() {
  //   nameController.dispose();
  //   emailController.dispose();
  //   passwordController.dispose();
  //   confirmPasswordController.dispose();
  //   loginEmailController.dispose();
  //   loginPasswordController.dispose();
  //   super.onClose();
  // }

  // Get current location
  Future<void> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar(
          'Location Error',
          'Location services are disabled. Please enable them.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar(
            'Location Error',
            'Location permissions are denied.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          'Location Error',
          'Location permissions are permanently denied.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      selectedLocation.value = position;
    } catch (e) {
      Get.snackbar(
        'Location Error',
        'Failed to get location: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Register user
  Future<void> register() async {
    if (!_validateRegisterForm()) return;

    isLoading.value = true;

    try {
      // Get location if role is user
      if (selectedRole.value == 'user') {
        await getCurrentLocation();
        if (selectedLocation.value == null) {
          isLoading.value = false;
          return;
        }
      }

      final response = await _authApis.register(
        username: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        role: selectedRole.value == 'parking owner' ? 'parking' : 'user',
        lng: selectedLocation.value?.longitude ?? 0.0,
        lat: selectedLocation.value?.latitude ?? 0.0,
      );

      if (response['success'] == true) {
        Get.snackbar(
          'Success',
          response['message'] ?? 'Account created successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // Navigate to login
        Get.offAll(LoginScreen());
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Registration failed',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Registration failed: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Login user
  Future<void> login() async {
    if (!_validateLoginForm()) return;

    isLoading.value = true;

    try {
      final response = await _authApis.login(
        email: loginEmailController.text.trim(),
        password: loginPasswordController.text,
      );

      if (response['success'] == true) {
        // Store user data in shared preferences
        final userData = response['data'];
        if (userData != null) {
          await SharedPreferencesService.saveUserData(userData);
          final role = userData['role'] ?? 'user';
          if (role == 'user') {
            Get.offAll(HomeScreen());
          } else {
            Get.offAll(ParkingDashboardScreen());
          }
        } else {
          Get.offAll(HomeScreen());
        }

        Get.snackbar(
          'Success',
          response['message'] ?? 'Login successful',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Login failed',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Login failed: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Validate register form
  bool _validateRegisterForm() {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter your name',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (emailController.text.trim().isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter your email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (!GetUtils.isEmail(emailController.text.trim())) {
      Get.snackbar(
        'Validation Error',
        'Please enter a valid email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (passwordController.text.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter your password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (passwordController.text.length < 6) {
      Get.snackbar(
        'Validation Error',
        'Password must be at least 6 characters',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar(
        'Validation Error',
        'Passwords do not match',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (selectedRole.value == 'parking owner' && selectedLocation.value == null) {
      Get.snackbar(
        'Validation Error',
        'Please select parking location',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }

  // Validate login form
  bool _validateLoginForm() {
    if (loginEmailController.text.trim().isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter your email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (!GetUtils.isEmail(loginEmailController.text.trim())) {
      Get.snackbar(
        'Validation Error',
        'Please enter a valid email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (loginPasswordController.text.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter your password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }

  // Set selected location (for parking owner)
  void setSelectedLocation(Position position) {
    selectedLocation.value = position;
  }

  // Clear form
  void clearForm() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    selectedRole.value = 'user';
    selectedLocation.value = null;
  }

  // Clear login form
  void clearLoginForm() {
    loginEmailController.clear();
    loginPasswordController.clear();
  }

  // Forgot password
  Future<void> forgotPassword() async {
    if (!_validateForgotPasswordForm()) return;

    isLoading.value = true;

    try {
      final response = await _authApis.forgotPassword(
        email: forgotEmailController.text.trim(),
      );

      if (response['success'] == true) {
        userEmail.value = forgotEmailController.text.trim();
        final otp = response['data']['otp'];
        Get.snackbar(
          'OTP Sent',
          'Your OTP is: $otp',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 10),
        );
        // Navigate to OTP screen
        Get.to(() => const OtpVerificationScreen());
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Failed to send OTP',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send OTP: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Verify OTP
  Future<void> verifyOtp() async {
    if (!_validateOtpForm()) return;

    isLoading.value = true;

    try {
      final response = await _authApis.verifyOtp(
        email: userEmail.value,
        otp: otpController.text.trim(),
      );

      if (response['success'] == true) {
        resetToken.value = response['data']['resetToken'];
        Get.snackbar(
          'Success',
          response['message'] ?? 'OTP verified successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // Navigate to reset password screen
        Get.to(() => const ResetPasswordScreen());
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'OTP verification failed',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'OTP verification failed: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Reset password
  Future<void> resetPassword() async {
    if (!_validateResetPasswordForm()) return;

    isLoading.value = true;

    try {
      final response = await _authApis.resetPassword(
        resetToken: resetToken.value,
        password: newPasswordController.text,
      );

      if (response['success'] == true) {
        Get.snackbar(
          'Success',
          response['message'] ?? 'Password reset successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // Navigate to login
        Get.offAll(LoginScreen());
        clearForgotPasswordForms();
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Password reset failed',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Password reset failed: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Validate forgot password form
  bool _validateForgotPasswordForm() {
    if (forgotEmailController.text.trim().isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter your email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (!GetUtils.isEmail(forgotEmailController.text.trim())) {
      Get.snackbar(
        'Validation Error',
        'Please enter a valid email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }

  // Validate OTP form
  bool _validateOtpForm() {
    if (otpController.text.trim().isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter the OTP',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (otpController.text.trim().length != 4) {
      Get.snackbar(
        'Validation Error',
        'Please enter a valid 4-digit OTP',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }

  // Validate reset password form
  bool _validateResetPasswordForm() {
    if (newPasswordController.text.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter your new password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (newPasswordController.text.length < 6) {
      Get.snackbar(
        'Validation Error',
        'Password must be at least 6 characters',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (newPasswordController.text != confirmNewPasswordController.text) {
      Get.snackbar(
        'Validation Error',
        'Passwords do not match',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }

  // Clear forgot password forms
  void clearForgotPasswordForms() {
    forgotEmailController.clear();
    otpController.clear();
    newPasswordController.clear();
    confirmNewPasswordController.clear();
    resetToken.value = '';
    userEmail.value = '';
  }

  // Logout method
  Future<void> logout() async {
    try {
      await SharedPreferencesService.clearAllData();
      clearForm();
      clearLoginForm();
      clearForgotPasswordForms();

      Get.snackbar(
        'Success',
        'Logged out successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Navigate to login
      Get.offAll(LoginScreen());
    } catch (e) {
      Get.snackbar(
        'Error',
        'Logout failed: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}