import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;

import '../utils/base_url.dart';
import '../utils/shared_preferences_service.dart';
import '../../models/get_user_profile_model.dart';

class ProfileApis {
  final String _baseUrl = baseUrl; 

  // Get User Profile API
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      // Get token from shared preferences
      final token = await SharedPreferencesService.getToken();

      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'message': 'No authentication token found',
        };
      }

      final url = Uri.parse('$_baseUrl/user/profile');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      log("get profile response: ${response.body}");
      final responseData = jsonDecode(response.body);

      // Log the image field specifically
      if (responseData['success'] == true && responseData['data'] != null) {
        log("Profile image field: ${responseData['data']['image']}");
      }

      if (response.statusCode == 200 && responseData['success'] == true) {
        return responseData;
      } else {
        // Handle different error response formats
        String errorMessage = 'Failed to get profile';
        if (responseData is Map && responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        } else if (responseData is Map && responseData.containsKey('error')) {
          errorMessage = responseData['error'];
        } else {
          errorMessage = 'Failed to get profile with status code: ${response.statusCode}';
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

  // Update User Profile API
  Future<Map<String, dynamic>> updateUserProfile({
    required String username,
    String? image,
  }) async {
    try {
      // Get token from shared preferences
      final token = await SharedPreferencesService.getToken();

      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'message': 'No authentication token found',
        };
      }

      final url = Uri.parse('$_baseUrl/user/profile');

      final body = jsonEncode({
        'username': username,
        if (image != null) 'image': image,
      });

      log("Update profile request - username: $username, image: $image");
      log("Update profile request body: $body");

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      final responseData = jsonDecode(response.body);
      log("Update profile response: ${response.body}");

      if ((response.statusCode == 200 || response.statusCode == 201) && responseData['success'] == true) {
        return responseData;
      } else {
        // Handle different error response formats
        String errorMessage = 'Failed to update profile';
        if (responseData is Map && responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        } else if (responseData is Map && responseData.containsKey('error')) {
          errorMessage = responseData['error'];
        } else {
          errorMessage = 'Failed to update profile with status code: ${response.statusCode}';
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

  // Upload Profile Image API
  Future<Map<String, dynamic>> uploadProfileImage({
    required File imageFile,
  }) async {
    try {
      // Get token from shared preferences
      final token = await SharedPreferencesService.getToken();

      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'message': 'No authentication token found',
        };
      }

      // Validate file exists and is readable
      if (!await imageFile.exists()) {
        return {
          'success': false,
          'message': 'Image file does not exist',
        };
      }

      final fileSize = await imageFile.length();
      if (fileSize == 0) {
        return {
          'success': false,
          'message': 'Image file is empty',
        };
      }

      // Compress image if too large (> 5MB)
      File fileToUpload = imageFile;
      if (fileSize > 5 * 1024 * 1024) { // 5MB
        fileToUpload = await _compressImage(imageFile);
      }

      final url = Uri.parse('$_baseUrl/user/upload-image');

      // Create multipart request
      var request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'Bearer $token';

      // Determine content type based on file extension
      final extension = path.extension(fileToUpload.path).toLowerCase();
      MediaType contentType;
      switch (extension) {
        case '.jpg':
        case '.jpeg':
          contentType = MediaType('image', 'jpeg');
          break;
        case '.png':
          contentType = MediaType('image', 'png');
          break;
        case '.gif':
          contentType = MediaType('image', 'gif');
          break;
        case '.webp':
          contentType = MediaType('image', 'webp');
          break;
        default:
          contentType = MediaType('image', 'jpeg');
      }

      // Create a new file stream to avoid Android ImageReader issues
      final fileBytes = await fileToUpload.readAsBytes();
      final multipartFile = http.MultipartFile.fromBytes(
        'image',
        fileBytes,
        filename: path.basename(fileToUpload.path),
        contentType: contentType,
      );

      request.files.add(multipartFile);
      log("Uploading file: ${fileToUpload.path}, size: ${fileBytes.length} bytes");
      // Send request with timeout
      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Upload timeout');
        },
      );

      final response = await http.Response.fromStream(streamedResponse);
      final responseData = jsonDecode(response.body);
      log("responseData: $responseData");

      if ((response.statusCode == 200 || response.statusCode == 201)) {
        return responseData;
      } else {
        // Handle different error response formats
        String errorMessage = 'Failed to upload image';
        if (responseData is Map && responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        } else if (responseData is Map && responseData.containsKey('error')) {
          errorMessage = responseData['error'];
        } else {
          errorMessage = 'Failed to upload image with status code: ${response.statusCode}';
        }

        return {
          'success': false,
          'message': errorMessage,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Upload error: $e',
      };
    }
  }

  // Compress image to reduce file size
  Future<File> _compressImage(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) {
        return imageFile; // Return original if decoding fails
      }

      // Calculate new dimensions (max 1920px width/height)
      int newWidth = image.width;
      int newHeight = image.height;

      if (image.width > 1920 || image.height > 1920) {
        if (image.width > image.height) {
          newWidth = 1920;
          newHeight = (image.height * 1920 / image.width).round();
        } else {
          newHeight = 1920;
          newWidth = (image.width * 1920 / image.height).round();
        }
      }

      // Resize image
      final resizedImage = img.copyResize(
        image,
        width: newWidth,
        height: newHeight,
        interpolation: img.Interpolation.linear,
      );

      // Compress image (80% quality)
      final compressedBytes = img.encodeJpg(resizedImage, quality: 80);

      // Create temporary file
      final tempDir = Directory.systemTemp;
      final tempFile = File('${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await tempFile.writeAsBytes(compressedBytes);

      return tempFile;
    } catch (e) {
      // Return original file if compression fails
      return imageFile;
    }
  }
}