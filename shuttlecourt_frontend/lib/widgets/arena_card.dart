import 'package:flutter/material.dart';
import '../models/arena.dart';

class ArenaCard extends StatelessWidget {
  final Arena arena;
  final VoidCallback onTap;

  const ArenaCard({required this.arena, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: arena.image != null
            ? Image.network(arena.image!,
                width: 50, height: 50, fit: BoxFit.cover)
            : const Icon(Icons.sports_tennis, size: 50),
        title: Text(arena.name),
        subtitle: Text('${arena.location} - ${arena.price} VND/h'),
        onTap: onTap,
      ),
    );
  }
}
