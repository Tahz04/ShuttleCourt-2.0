import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/arena_provider.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/admin_drawer.dart';

class AdminManageArenasScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ArenaProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý sân (Admin)')),
      drawer: const AdminDrawer(),
      body: provider.isLoading
          ? const LoadingIndicator()
          : ListView.builder(
              itemCount: provider.arenas.length,
              itemBuilder: (ctx, i) {
                final arena = provider.arenas[i];
                return ListTile(
                  title: Text(arena.name),
                  subtitle: Text('${arena.location} - ${arena.price} VND'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      if (await provider.deleteArena(arena.id, isAdmin: true)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Đã xóa sân')));
                      }
                    },
                  ),
                );
              },
            ),
    );
  }
}
