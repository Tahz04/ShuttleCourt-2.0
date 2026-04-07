import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/arena_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/arena_card.dart';
import 'arena_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final arenaProvider = Provider.of<ArenaProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sân cầu lông'),
        actions: [
          IconButton(
            onPressed: () => context.go('/user/my-bookings'),
            icon: const Icon(Icons.bookmark),
          ),
          IconButton(
            onPressed: () =>
                Provider.of<AuthProvider>(context, listen: false).logout(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: arenaProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: arenaProvider.arenas.length,
              itemBuilder: (ctx, i) => ArenaCard(
                arena: arenaProvider.arenas[i],
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ArenaDetailScreen(
                          arenaId: arenaProvider.arenas[i].id)),
                ),
              ),
            ),
    );
  }
}
