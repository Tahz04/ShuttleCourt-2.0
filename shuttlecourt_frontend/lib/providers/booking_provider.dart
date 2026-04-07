import 'package:flutter/material.dart';
import '../models/booking.dart';
import '../services/api_service.dart';
import '../config/api_config.dart';

class BookingProvider extends ChangeNotifier {
  final ApiService _apiService;
  List<Booking> _userBookings = [];
  List<Booking> _ownerBookings = [];
  bool _isLoading = false;

  BookingProvider(this._apiService);

  List<Booking> get userBookings => _userBookings;
  List<Booking> get ownerBookings => _ownerBookings;
  bool get isLoading => _isLoading;
  ApiService get apiService => _apiService;

  Future<bool> createBooking(
      int arenaId, String date, String startTime, String endTime) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _apiService.post(ApiConfig.bookings, {
        'arena_id': arenaId,
        'date': date,
        'start_time': startTime,
        'end_time': endTime,
      });
      await fetchUserBookings();
      return true;
    } catch (e) {
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUserBookings() async {
    _isLoading = true;
    notifyListeners();
    try {
      final data = await _apiService.get(ApiConfig.userBookings);
      _userBookings =
          (data as List).map((json) => Booking.fromJson(json)).toList();
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchOwnerBookings() async {
    _isLoading = true;
    notifyListeners();
    try {
      final data = await _apiService.get(ApiConfig.ownerBookings);
      _ownerBookings =
          (data as List).map((json) => Booking.fromJson(json)).toList();
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
