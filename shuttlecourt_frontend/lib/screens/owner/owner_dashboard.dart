import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/owner_drawer.dart';

class OwnerDashboard extends StatelessWidget {
  const OwnerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Owner Dashboard'),
        actions: [
          IconButton(
            onPressed: () =>
                Provider.of<AuthProvider>(context, listen: false).logout(),
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      drawer: const OwnerDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Chào mừng chủ sân', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/owner/manage-arenas'),
              child: const Text('Quản lý sân'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/owner/manage-bookings'),
              child: const Text('Xem lịch đặt'),
            ),
          ],
        ),
      ),
    );
  }
}
