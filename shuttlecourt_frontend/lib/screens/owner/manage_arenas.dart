import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/arena_provider.dart';
import '../../models/arena.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/owner_drawer.dart';

class ManageArenasScreen extends StatefulWidget {
  @override
  _ManageArenasScreenState createState() => _ManageArenasScreenState();
}

class _ManageArenasScreenState extends State<ManageArenasScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageController = TextEditingController();
  int? _editingId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ArenaProvider>(context, listen: false).fetchOwnerArenas();
    });
  }

  void _resetForm() {
    _nameController.clear();
    _locationController.clear();
    _descController.clear();
    _priceController.clear();
    _imageController.clear();
    setState(() => _editingId = null);
  }

  void _editArena(Arena arena) {
    _nameController.text = arena.name;
    _locationController.text = arena.location;
    _descController.text = arena.description ?? '';
    _priceController.text = arena.price.toString();
    _imageController.text = arena.image ?? '';
    setState(() => _editingId = arena.id);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = Provider.of<ArenaProvider>(context, listen: false);
    final arena = Arena(
      id: _editingId ?? 0,
      name: _nameController.text,
      location: _locationController.text,
      description: _descController.text,
      price: double.parse(_priceController.text),
      image: _imageController.text.isNotEmpty ? _imageController.text : null,
      ownerId: 0,
    );
    bool success;
    if (_editingId == null) {
      success = await provider.createArena(arena);
    } else {
      success = await provider.updateArena(_editingId!, arena);
    }
    if (success) {
      _resetForm();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Thành công')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Thất bại')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ArenaProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý sân')),
      drawer: const OwnerDrawer(),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Tên sân'),
                        validator: (v) => v!.isEmpty ? 'Required' : null),
                    TextFormField(
                        controller: _locationController,
                        decoration: const InputDecoration(labelText: 'Địa chỉ'),
                        validator: (v) => v!.isEmpty ? 'Required' : null),
                    TextFormField(
                        controller: _descController,
                        decoration: const InputDecoration(labelText: 'Mô tả')),
                    TextFormField(
                        controller: _priceController,
                        decoration:
                            const InputDecoration(labelText: 'Giá (VND/h)'),
                        keyboardType: TextInputType.number,
                        validator: (v) => v!.isEmpty ? 'Required' : null),
                    TextFormField(
                        controller: _imageController,
                        decoration:
                            const InputDecoration(labelText: 'URL hình ảnh')),
                    const SizedBox(height: 16),
                    ElevatedButton(
                        onPressed: _submit,
                        child:
                            Text(_editingId == null ? 'Thêm sân' : 'Cập nhật')),
                    if (_editingId != null)
                      TextButton(
                          onPressed: _resetForm, child: const Text('Hủy')),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: provider.isLoading
                ? const LoadingIndicator()
                : ListView.builder(
                    itemCount: provider.arenas.length,
                    itemBuilder: (ctx, i) {
                      final arena = provider.arenas[i];
                      return ListTile(
                        title: Text(arena.name),
                        subtitle:
                            Text('${arena.location} - ${arena.price} VND'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _editArena(arena)),
                            IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  if (await provider.deleteArena(arena.id)) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text('Đã xóa')));
                                  }
                                }),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
