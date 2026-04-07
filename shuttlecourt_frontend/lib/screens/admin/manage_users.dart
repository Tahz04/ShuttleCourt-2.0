import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../services/api_service.dart';
import '../../config/api_config.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/admin_drawer.dart';

class ManageUsersScreen extends StatefulWidget {
  @override
  _ManageUsersScreenState createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  List<dynamic> _users = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    setState(() => _loading = true);
    try {
      final api = Provider.of<ApiService>(context, listen: false);
      final data = await api.get(ApiConfig.adminUsers);
      setState(() => _users = data);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Lỗi tải users: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _deleteUser(int id) async {
    final api = Provider.of<ApiService>(context, listen: false);
    try {
      await api.delete('${ApiConfig.adminUsers}/$id');
      _fetchUsers();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Đã xóa user')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Xóa thất bại')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý người dùng')),
      drawer: const AdminDrawer(),
      body: _loading
          ? const LoadingIndicator()
          : ListView.builder(
              itemCount: _users.length,
              itemBuilder: (ctx, i) {
                final user = _users[i];
                return ListTile(
                  title: Text(user['name']),
                  subtitle: Text('${user['email']} - ${user['role']}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteUser(user['id']),
                  ),
                );
              },
            ),
    );
  }
}
