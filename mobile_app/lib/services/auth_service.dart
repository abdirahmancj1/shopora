import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/api_constants.dart';

class AuthService {
  final Dio _dio = Dio();
  final _storage = const FlutterSecureStorage();

  Future<bool> login(String username, String password) async {
    try {
      final response = await _dio.post(
        ApiConstants.login,
        data: {'username': username, 'password': password},
      );
      if (response.statusCode == 200) {
        await _storage.write(key: 'access_token', value: response.data['access']);
        await _storage.write(key: 'refresh_token', value: response.data['refresh']);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> register(String username, String email, String password) async {
    try {
      final response = await _dio.post(
        ApiConstants.register,
        data: {
          'username': username,
          'email': email,
          'password': password,
        },
      );
      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
  }

  Future<bool> isLoggedIn() async {
    String? token = await _storage.read(key: 'access_token');
    return token != null;
  }
}
