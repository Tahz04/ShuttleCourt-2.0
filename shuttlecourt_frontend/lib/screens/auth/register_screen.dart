import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/loading_indicator.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'user';

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Đăng ký tài khoản',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 32),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Họ tên'),
                validator: (v) => v!.isNotEmpty ? null : 'Không được để trống',
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) =>
                    v!.contains('@') ? null : 'Email không hợp lệ',
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: 'Mật khẩu (tối thiểu 6 ký tự)'),
                validator: (v) =>
                    v!.length >= 6 ? null : 'Mật khẩu phải >=6 ký tự',
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                items: const [
                  DropdownMenuItem(value: 'user', child: Text('Người chơi')),
                  DropdownMenuItem(value: 'owner', child: Text('Chủ sân')),
                ],
                onChanged: (val) => setState(() => _selectedRole = val!),
                decoration: const InputDecoration(labelText: 'Loại tài khoản'),
              ),
              const SizedBox(height: 24),
              if (authProvider.isLoading)
                const LoadingIndicator()
              else
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      bool success = await authProvider.register(
                        _nameController.text,
                        _emailController.text,
                        _passwordController.text,
                        role: _selectedRole,
                      );
                      if (!success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Đăng ký thất bại, email có thể đã tồn tại')),
                        );
                      }
                    }
                  },
                  child: const Text('Đăng ký'),
                ),
              TextButton(
                onPressed: () => context.go('/login'),
                child: const Text('Đã có tài khoản? Đăng nhập'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
