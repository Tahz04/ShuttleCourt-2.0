import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/admin_drawer.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            onPressed: () =>
                Provider.of<AuthProvider>(context, listen: false).logout(),
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      drawer: const AdminDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Chào mừng Admin', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/admin/manage-users'),
              child: const Text('Quản lý người dùng'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/admin/manage-arenas'),
              child: const Text('Quản lý sân'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/admin/manage-reviews'),
              child: const Text('Quản lý đánh giá'),
            ),
          ],
        ),
      ),
    );
  }
}
