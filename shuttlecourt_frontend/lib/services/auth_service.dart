import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_service.dart';

class AuthService {
  static const _tokenKey = 'auth_token';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final ApiService _apiService;

  AuthService(this._apiService);

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
    _apiService.setToken(token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
    _apiService.setToken('');
  }
}
