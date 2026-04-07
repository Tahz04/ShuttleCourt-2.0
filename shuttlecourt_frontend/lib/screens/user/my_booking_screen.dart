import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/booking_provider.dart';
import '../../widgets/booking_card.dart';
import '../../widgets/loading_indicator.dart';

class MyBookingScreen extends StatefulWidget {
  @override
  _MyBookingScreenState createState() => _MyBookingScreenState();
}

class _MyBookingScreenState extends State<MyBookingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BookingProvider>(context, listen: false).fetchUserBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Lịch đặt của tôi')),
      body: bookingProvider.isLoading
          ? const LoadingIndicator()
          : bookingProvider.userBookings.isEmpty
              ? const Center(child: Text('Bạn chưa có lịch đặt nào'))
              : ListView.builder(
                  itemCount: bookingProvider.userBookings.length,
                  itemBuilder: (ctx, i) =>
                      BookingCard(booking: bookingProvider.userBookings[i]),
                ),
    );
  }
}
