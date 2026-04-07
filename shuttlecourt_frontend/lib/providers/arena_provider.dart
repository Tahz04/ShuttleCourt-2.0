import 'package:flutter/material.dart';
import '../models/arena.dart';
import '../services/api_service.dart';
import '../config/api_config.dart';

class ArenaProvider extends ChangeNotifier {
  final ApiService _apiService;
  List<Arena> _arenas = [];
  bool _isLoading = false;

  ArenaProvider(this._apiService);

  List<Arena> get arenas => _arenas;
  bool get isLoading => _isLoading;

  Future<void> fetchAllArenas() async {
    _isLoading = true;
    notifyListeners();
    try {
      final data = await _apiService.get(ApiConfig.arenas);
      _arenas = (data as List).map((json) => Arena.fromJson(json)).toList();
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchOwnerArenas() async {
    _isLoading = true;
    notifyListeners();
    try {
      final data = await _apiService.get(ApiConfig.ownerArenas);
      _arenas = (data as List).map((json) => Arena.fromJson(json)).toList();
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Arena?> getArenaById(int id) async {
    try {
      final data = await _apiService.get('${ApiConfig.arenas}/$id');
      return Arena.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  Future<bool> createArena(Arena arena) async {
    try {
      await _apiService.post(ApiConfig.ownerArenas, arena.toJson());
      await fetchOwnerArenas();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateArena(int id, Arena arena) async {
    try {
      await _apiService.put('${ApiConfig.ownerArenas}/$id', arena.toJson());
      await fetchOwnerArenas();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteArena(int id, {bool isAdmin = false}) async {
    try {
      if (isAdmin) {
        await _apiService.delete('${ApiConfig.adminArenas}/$id');
      } else {
        await _apiService.delete('${ApiConfig.ownerArenas}/$id');
      }
      if (isAdmin) {
        await fetchAllArenas();
      } else {
        await fetchOwnerArenas();
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
