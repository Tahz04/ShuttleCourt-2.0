import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            child: Text('Admin'),
            decoration: BoxDecoration(color: Colors.blue),
          ),
          ListTile(
            title: const Text('Quản lý người dùng'),
            onTap: () => context.go('/admin/manage-users'),
          ),
          ListTile(
            title: const Text('Quản lý sân'),
            onTap: () => context.go('/admin/manage-arenas'),
          ),
          ListTile(
            title: const Text('Quản lý đánh giá'),
            onTap: () => context.go('/admin/manage-reviews'),
          ),
        ],
      ),
    );
  }
}