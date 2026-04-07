import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OwnerDrawer extends StatelessWidget {
  const OwnerDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            child: Text('Owner Menu'),
            decoration: BoxDecoration(color: Colors.green),
          ),
          ListTile(
            title: const Text('Quản lý sân'),
            onTap: () => context.go('/owner/manage-arenas'),
          ),
          ListTile(
            title: const Text('Quản lý đặt sân'),
            onTap: () => context.go('/owner/manage-bookings'),
          ),
        ],
      ),
    );
  }
}