import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../config/api_config.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService;
  final AuthService _authService;
  User? _user;
  bool _isLoading = false;

  AuthProvider(this._apiService, this._authService);

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _apiService.post(ApiConfig.login, {
        'email': email,
        'password': password,
      });
      final token = response['token'];
      final userData = response['user'];
      await _authService.saveToken(token);
      _user = User.fromJson(userData);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password,
      {String role = 'user'}) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _apiService.post(ApiConfig.register, {
        'name': name,
        'email': email,
        'password': password,
        'role': role,
      });
      final token = response['token'];
      final userData = response['user'];
      await _authService.saveToken(token);
      _user = User.fromJson(userData);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.clearToken();
    _user = null;
    notifyListeners();
  }

  Future<void> loadUserFromToken() async {
    final token = await _authService.getToken();
    if (token != null) {
      _apiService.setToken(token);
      // Optionally fetch user profile
    }
  }
}
