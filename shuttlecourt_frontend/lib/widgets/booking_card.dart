import 'package:flutter/material.dart';
import '../models/booking.dart';

class BookingCard extends StatelessWidget {
  final Booking booking;

  const BookingCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text('Sân #${booking.arenaId}'),
        subtitle:
            Text('${booking.date} ${booking.startTime} - ${booking.endTime}'),
        trailing: Chip(
          label: Text(booking.status),
          backgroundColor: booking.status == 'confirmed'
              ? Colors.green.shade100
              : Colors.red.shade100,
        ),
      ),
    );
  }
}
