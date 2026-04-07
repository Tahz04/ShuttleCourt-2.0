import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/booking_provider.dart';
import '../../widgets/loading_indicator.dart';

class BookingScreen extends StatefulWidget {
  final int arenaId;
  const BookingScreen({required this.arenaId});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime _selectedDate = DateTime.now();
  String? _selectedStartTime;
  String? _selectedEndTime;
  List<Map<String, String>> _availableSlots = [];
  bool _isLoadingSlots = false;

  @override
  void initState() {
    super.initState();
    _fetchAvailableSlots();
  }

  Future<void> _fetchAvailableSlots() async {
    setState(() => _isLoadingSlots = true);
    try {
      final apiService =
          Provider.of<BookingProvider>(context, listen: false).apiService;
      final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
      final response = await apiService
          .get('/arenas/${widget.arenaId}/schedule?date=$dateStr');
      final slots = (response['slots'] as List)
          .where((slot) => slot['is_available'] == true)
          .map((slot) => {
                'start_time': slot['start_time'].toString().substring(0, 5),
                'end_time': slot['end_time'].toString().substring(0, 5),
              })
          .toList();
      setState(() {
        _availableSlots = List<Map<String, String>>.from(slots);
        _selectedStartTime = null;
        _selectedEndTime = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Lỗi tải khung giờ: $e')));
    } finally {
      setState(() => _isLoadingSlots = false);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
      _fetchAvailableSlots();
    }
  }

  Future<void> _bookCourt() async {
    if (_selectedStartTime == null || _selectedEndTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn giờ bắt đầu và kết thúc')),
      );
      return;
    }
    final bookingProvider =
        Provider.of<BookingProvider>(context, listen: false);
    final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
    final success = await bookingProvider.createBooking(
      widget.arenaId,
      dateStr,
      '$_selectedStartTime:00',
      '$_selectedEndTime:00',
    );
    if (success) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Đặt sân thành công!')));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đặt sân thất bại, có thể trùng giờ')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đặt sân')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                  'Ngày: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context),
            ),
            const SizedBox(height: 16),
            const Text('Chọn giờ:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _isLoadingSlots
                ? const LoadingIndicator()
                : _availableSlots.isEmpty
                    ? const Text('Không có khung giờ trống trong ngày này')
                    : Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: _availableSlots.length,
                          itemBuilder: (ctx, index) {
                            final slot = _availableSlots[index];
                            final start = slot['start_time']!;
                            final end = slot['end_time']!;
                            final isSelected = _selectedStartTime == start &&
                                _selectedEndTime == end;
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isSelected
                                    ? Colors.green
                                    : Colors.grey.shade300,
                                foregroundColor:
                                    isSelected ? Colors.white : Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  _selectedStartTime = start;
                                  _selectedEndTime = end;
                                });
                              },
                              child: Text('$start - $end'),
                            );
                          },
                        ),
                      ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed:
                  (_selectedStartTime != null && _selectedEndTime != null)
                      ? _bookCourt
                      : null,
              child: const Text('Xác nhận đặt sân'),
            ),
          ],
        ),
      ),
    );
  }
}
