import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/booking_provider.dart';
import '../../widgets/booking_card.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/owner_drawer.dart';

class ManageBookingsScreen extends StatefulWidget {
  @override
  _ManageBookingsScreenState createState() => _ManageBookingsScreenState();
}

class _ManageBookingsScreenState extends State<ManageBookingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BookingProvider>(context, listen: false).fetchOwnerBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BookingProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Lịch đặt của sân')),
      drawer: const OwnerDrawer(),
      body: provider.isLoading
          ? const LoadingIndicator()
          : provider.ownerBookings.isEmpty
              ? const Center(child: Text('Chưa có lịch đặt nào'))
              : ListView.builder(
                  itemCount: provider.ownerBookings.length,
                  itemBuilder: (ctx, i) =>
                      BookingCard(booking: provider.ownerBookings[i]),
                ),
    );
  }
}
