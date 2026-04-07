import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'services/api_service.dart';
import 'services/auth_service.dart';
import 'providers/auth_provider.dart';
import 'providers/arena_provider.dart';
import 'providers/booking_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/user/home_screen.dart';
import 'screens/user/my_booking_screen.dart';
import 'screens/user/booking_screen.dart';
import 'screens/owner/owner_dashboard.dart';
import 'screens/owner/manage_arenas.dart';
import 'screens/owner/manage_bookings.dart';
import 'screens/admin/admin_dashboard.dart';
import 'screens/admin/manage_users.dart';
import 'screens/admin/manage_arenas.dart';
import 'screens/admin/manage_reviews.dart';

void main() {
  final apiService = ApiService();
  final authService = AuthService(apiService);
  runApp(ShuttleCourtApp(apiService: apiService, authService: authService));
}

class ShuttleCourtApp extends StatelessWidget {
  final ApiService apiService;
  final AuthService authService;

  ShuttleCourtApp(
      {super.key, required this.apiService, required this.authService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => AuthProvider(apiService, authService)),
        ChangeNotifierProvider(create: (_) => ArenaProvider(apiService)),
        ChangeNotifierProvider(create: (_) => BookingProvider(apiService)),
      ],
      child: MaterialApp.router(
        title: 'ShuttleCourt',
        theme: ThemeData(primarySwatch: Colors.green),
        routerConfig: _router,
      ),
    );
  }

  final GoRouter _router = GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final isLoggedIn = authProvider.isAuthenticated;
      final role = authProvider.user?.role;
      if (!isLoggedIn) {
        if (state.uri.path == '/login' || state.uri.path == '/register')
          return null;
        return '/login';
      }
      final location = state.uri.path;
      if (role == 'user') {
        if (location == '/' || location == '/login' || location == '/register')
          return '/user/home';
        return null;
      }
      if (role == 'owner') {
        if (location == '/' || location == '/login' || location == '/register')
          return '/owner/dashboard';
        return null;
      }
      if (role == 'admin') {
        if (location == '/' || location == '/login' || location == '/register')
          return '/admin/dashboard';
        return null;
      }
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
      GoRoute(path: '/register', builder: (context, state) => RegisterScreen()),
      // User
      GoRoute(path: '/user/home', builder: (context, state) => HomeScreen()),
      GoRoute(
          path: '/user/my-bookings',
          builder: (context, state) => MyBookingScreen()),
      GoRoute(
          path: '/user/booking/:arenaId',
          builder: (context, state) {
            final arenaId = int.parse(state.pathParameters['arenaId']!);
            return BookingScreen(arenaId: arenaId);
          }),
      // Owner
      GoRoute(
          path: '/owner/dashboard',
          builder: (context, state) => OwnerDashboard()),
      GoRoute(
          path: '/owner/manage-arenas',
          builder: (context, state) => ManageArenasScreen()),
      GoRoute(
          path: '/owner/manage-bookings',
          builder: (context, state) => ManageBookingsScreen()),
      // Admin
      GoRoute(
          path: '/admin/dashboard',
          builder: (context, state) => AdminDashboard()),
      GoRoute(
          path: '/admin/manage-users',
          builder: (context, state) => ManageUsersScreen()),
      GoRoute(
          path: '/admin/manage-arenas',
          builder: (context, state) => AdminManageArenasScreen()),
      GoRoute(
          path: '/admin/manage-reviews',
          builder: (context, state) => ManageReviewsScreen()),
    ],
  );
}
