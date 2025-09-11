import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../api_services/profile_apis.dart';
import '../../models/get_user_profile_model.dart';

class ProfileController extends GetxController {
  final ProfileApis _profileApis = ProfileApis();

  // Observable variables
  var isLoading = false.obs;
  var userProfile = Rx<GetUserProfileModel?>(null);

  // Image picking variables
  var selectedImage = Rx<File?>(null);
  var imageUploadLoading = false.obs;
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    // Automatically fetch profile when controller is initialized
    fetchUserProfile();
  }

  // Fetch user profile
  Future<void> fetchUserProfile() async {
    isLoading.value = true;

    try {
      final response = await _profileApis.getUserProfile();

      if (response['success'] == true) {
        // Parse the response data to the model
        userProfile.value = GetUserProfileModel.fromJson(response);
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Failed to load profile',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        userProfile.value = null;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load profile: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      userProfile.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  // Update user profile
  Future<void> updateUserProfile({
    required String username,
    String? image,
  }) async {
    isLoading.value = true;

    try {
      final response = await _profileApis.updateUserProfile(
        username: username,
        image: image,
      );

      if (response['success'] == true) {
        Get.snackbar(
          'Success',
          response['message'] ?? 'Profile updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // Refresh profile data
        await fetchUserProfile();
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Failed to update profile',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh profile data
  Future<void> refreshProfile() async {
    await fetchUserProfile();
  }

  // Clear profile data (useful for logout)
  void clearProfile() {
    userProfile.value = null;
    selectedImage.value = null;
    isLoading.value = false;
    imageUploadLoading.value = false;
    _clearTempFiles();
  }

  // Clear temporary files created during image processing
  void _clearTempFiles() {
    try {
      final tempDir = Directory.systemTemp;
      final tempFiles = tempDir.listSync().where((entity) {
        return entity is File &&
               entity.path.contains('compressed_') &&
               entity.path.endsWith('.jpg');
      });

      for (final file in tempFiles) {
        try {
          file.deleteSync();
        } catch (e) {
          // Ignore errors when deleting temp files
        }
      }
    } catch (e) {
      // Ignore errors when clearing temp files
    }
  }

  // Image picking methods
  Future<void> pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920, // Limit image size to prevent memory issues
        maxHeight: 1920,
        imageQuality: 85, // Compress image quality
      );

      if (pickedFile != null) {
        final file = File(pickedFile.path);

        // Validate file exists and has content
        if (await file.exists()) {
          final fileSize = await file.length();
          if (fileSize > 0) {
            selectedImage.value = file;
          } else {
            Get.snackbar(
              'Error',
              'Selected image file is empty',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        } else {
          Get.snackbar(
            'Error',
            'Selected image file does not exist',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Upload selected image
  Future<String?> uploadSelectedImage() async {
    if (selectedImage.value == null) {
      Get.snackbar(
        'Error',
        'No image selected',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    }

    // Validate file before upload
    if (!await selectedImage.value!.exists()) {
      Get.snackbar(
        'Error',
        'Image file no longer exists',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      selectedImage.value = null;
      return null;
    }

    final fileSize = await selectedImage.value!.length();
    if (fileSize == 0) {
      Get.snackbar(
        'Error',
        'Image file is empty',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      selectedImage.value = null;
      return null;
    }

    imageUploadLoading.value = true;

    try {
      final response = await _profileApis.uploadProfileImage(
        imageFile: selectedImage.value!,
      );

      if (response['success'] == true) {
        final imageUrl = response['data']['imageUrl'] ?? response['data']['image'];
        if (imageUrl != null && imageUrl.toString().isNotEmpty) {
          return imageUrl.toString();
        } else {
          Get.snackbar(
            'Error',
            'Invalid image URL received from server',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return null;
        }
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Failed to upload image',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return null;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to upload image: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    } finally {
      imageUploadLoading.value = false;
    }
  }

  // Update profile with image upload
  Future<void> updateProfileWithImage({
    required String username,
  }) async {
    // Validate input
    if (username.trim().isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter a valid name',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      String? imageUrl;

      // Upload image if selected
      if (selectedImage.value != null) {
        imageUrl = await uploadSelectedImage();
        // Don't return here - continue with profile update even if image upload fails
        // The imageUrl will be null, which is fine for the API
      }

      // Update profile
      final response = await _profileApis.updateUserProfile(
        username: username.trim(),
        image: imageUrl,
      );

      if (response['success'] == true) {
        Get.snackbar(
          'Success',
          response['message'] ?? 'Profile updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // Clear selected image and refresh profile data
        selectedImage.value = null;
        await fetchUserProfile();
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Failed to update profile',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Get user display name
  String get userDisplayName {
    if (userProfile.value?.data.username != null) {
      return userProfile.value!.data.username;
    }
    return 'User';
  }

  // Get user email
  String get userEmail {
    if (userProfile.value?.data.email != null) {
      return userProfile.value!.data.email;
    }
    return '';
  }

  // Get user role
  String get userRole {
    if (userProfile.value?.data.role != null) {
      return userProfile.value!.data.role;
    }
    return 'user';
  }

  // Get user profile image
  String get userProfileImage {
    if (userProfile.value?.data.image != null && userProfile.value!.data.image.isNotEmpty) {
      return userProfile.value!.data.image;
    }
    return '';
  }

  // Check if profile has image
  bool get hasProfileImage {
    return userProfileImage.isNotEmpty;
  }

  // Get user coordinates
  double get userLatitude {
    return userProfile.value?.data.lat ?? 0.0;
  }

  double get userLongitude {
    return userProfile.value?.data.lng ?? 0.0;
  }
}