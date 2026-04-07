import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/arena_provider.dart';
import 'booking_screen.dart';

class ArenaDetailScreen extends StatelessWidget {
  final int arenaId;
  const ArenaDetailScreen({required this.arenaId});

  @override
  Widget build(BuildContext context) {
    final arenaProvider = Provider.of<ArenaProvider>(context);
    final arena = arenaProvider.arenas.firstWhere((a) => a.id == arenaId);
    return Scaffold(
      appBar: AppBar(title: Text(arena.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(arena.name, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('Địa chỉ: ${arena.location}'),
            Text('Giá: ${arena.price} VND/h'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.go('/user/booking/$arenaId');
              },
              child: const Text('Đặt sân'),
            ),
          ],
        ),
      ),
    );
  }
}
