import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../services/api_service.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/admin_drawer.dart';

class ManageReviewsScreen extends StatefulWidget {
  @override
  _ManageReviewsScreenState createState() => _ManageReviewsScreenState();
}

class _ManageReviewsScreenState extends State<ManageReviewsScreen> {
  List<dynamic> _reviews = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _fetchAllReviews();
  }

  Future<void> _fetchAllReviews() async {
    setState(() => _loading = true);
    try {
      final api = Provider.of<ApiService>(context, listen: false);
      // Giả sử backend có endpoint /admin/reviews. Nếu chưa có, bạn cần thêm vào backend.
      final data = await api.get('/admin/reviews');
      setState(() => _reviews = data);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Chưa có API lấy tất cả review')));
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _deleteReview(int id) async {
    final api = Provider.of<ApiService>(context, listen: false);
    try {
      await api.delete('/admin/reviews/$id');
      _fetchAllReviews();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Đã xóa review')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Xóa thất bại')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý đánh giá')),
      drawer: const AdminDrawer(),
      body: _loading
          ? const LoadingIndicator()
          : _reviews.isEmpty
              ? const Center(child: Text('Không có đánh giá nào'))
              : ListView.builder(
                  itemCount: _reviews.length,
                  itemBuilder: (ctx, i) {
                    final rev = _reviews[i];
                    return ListTile(
                      title: Text('Rating: ${rev['rating']} ★'),
                      subtitle: Text(rev['comment'] ?? ''),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteReview(rev['id']),
                      ),
                    );
                  },
                ),
    );
  }
}
