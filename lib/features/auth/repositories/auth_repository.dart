import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/auth_constants.dart';
import '../models/user.dart';
import '../services/auth_api_service.dart';

class AuthRepository {
  final AuthApiService _apiService = AuthApiService();

  Future<User> login(String email, String password) async {
    try {
      final response = await _apiService.post(
        AuthConstants.loginEndpoint,
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        print('Login response: ${response.data}');
        final user = User.fromJson(response.data['data']);
        print('Parsed user: $user');
        await _saveUserData(user);
        return user;
      } else {
        throw Exception('Login failed: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<User> signup(String name, String email, String password) async {
    try {
      final response = await _apiService.post(
        AuthConstants.signupEndpoint,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'role': 'staff',
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('Signup response: ${response.data}');
        final user = User.fromJson(response.data['data']);
        print('Parsed user: $user');
        await _saveUserData(user);
        return user;
      } else {
        throw Exception('Signup failed: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Signup failed: $e');
    }
  }

  Future<void> logout() async {
    try {
      await _apiService.post(AuthConstants.logoutEndpoint);
    } catch (e) {
      // Even if logout API fails, we should clear local data
      print('Logout API failed: $e');
    } finally {
      // Clear local data and cookies
      await _clearUserData();
      await _apiService.clearCookies();
    }
  }

  Future<User?> getCurrentUser() async {
    try {
      print('AuthRepository: getCurrentUser called');
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(AuthConstants.userKey);
      print('AuthRepository: userJson from prefs: $userJson');
      if (userJson != null) {
        Map<String, dynamic> userMap;

        // Try to parse as JSON first
        try {
          userMap = json.decode(userJson) as Map<String, dynamic>;
        } catch (e) {
          // If JSON parsing fails, try to parse as Dart map string
          print('AuthRepository: JSON parsing failed, trying Dart map parsing');
          // Remove the curly braces and parse manually
          final cleanString = userJson.replaceAll('{', '').replaceAll('}', '');
          final pairs = cleanString.split(',');
          userMap = {};

          for (final pair in pairs) {
            final keyValue = pair.split(':');
            if (keyValue.length == 2) {
              final key = keyValue[0].trim();
              final value = keyValue[1].trim();
              userMap[key] = value;
            }
          }
        }

        print('AuthRepository: userMap: $userMap');
        final user = User.fromJson(userMap);
        print('AuthRepository: parsed user: $user');
        return user;
      }
      print('AuthRepository: No user data found');
      return null;
    } catch (e) {
      print('AuthRepository: getCurrentUser error: $e');
      return null;
    }
  }

  Future<bool> isLoggedIn() async {
    print('AuthRepository: isLoggedIn called');
    final user = await getCurrentUser();
    final result = user != null;
    print('AuthRepository: isLoggedIn result: $result');
    return result;
  }

  Future<void> _saveUserData(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = json.encode(user.toJson());
    print('AuthRepository: Saving user data: $userJson');
    print('AuthRepository: User to save: $user');
    await prefs.setString(AuthConstants.userKey, userJson);

    // Verify the data was saved
    final savedData = prefs.getString(AuthConstants.userKey);
    print('AuthRepository: Verified saved data: $savedData');
  }

  Future<void> _clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AuthConstants.userKey);
    print('AuthRepository: Cleared user data');
  }

  // Method to clear old format data
  Future<void> clearOldFormatData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AuthConstants.userKey);
    print('AuthRepository: Cleared old format data');
  }

  // Method to manually clear all data (for testing)
  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print('AuthRepository: Cleared all data');
  }

  Future<Response> getTransportRequest() async {
    try {
      final response = await _apiService.get(AuthConstants.getRequestEndpoint);

      //print('get Transport response before status code: ${response.data}');

      if (response.statusCode == 200) {
        print('get Transport response: ${response.data}');
        // final user = User.fromJson(response.data['data']);
        // print('Parsed user: $user');
        // await _saveUserData(user);
        //return user;
        return response;
      } else {
        throw Exception('get Transport failed: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('get Transpor: $e');
    }
  }

  Future<void> pushLocationToBackend(Map<String, num> body) async {
    try {
      final response = await _apiService.post(
        AuthConstants.pushToBackendEndPoint,
        data: body,
      );
    } catch (e) {
      print('exception in auth_reposity');
    }
  }

  Future<void> acceptRequest(int transportId) async {
    try {
      final response = await _apiService.post(
        AuthConstants.acceptAdminRequest(transportId),
      );
    } catch (e) {
      print('exception in auth repo accept request $e');
    }
  }

  Future<void> rejectRequest(int transportId) async {
    try {
      final response = await _apiService.post(
        AuthConstants.rejectAdminRequest(transportId),
      );
    } catch (e) {
      print('exception in auth repo accept request $e');
    }
  }

  Future<void> completedAdminRequest(int transportId) async {
    try {
      final response = await _apiService.post(
        AuthConstants.completedAdminRequest(transportId),
      );
    } catch (e) {
      print('exception in auth repo accept request $e');
    }
  }

  Future<void> showTransportHistory(int staffId) async {
    try {
      await _apiService.post(AuthConstants.showTransportHistory(staffId));
    } catch (e) {
      print('exception');
    }
  }
}
