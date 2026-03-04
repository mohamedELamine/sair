import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';
import '../providers/auth_provider.dart';
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/teacher_home/presentation/teacher_home_screen.dart';
import '../../features/parent_portal/presentation/parent_portal_screen.dart';

/// AuthStateNotifier - Manages auth state and triggers router refresh
class AuthStateNotifier extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth;

  AuthStateNotifier(this._firebaseAuth) {
    _firebaseAuth.authStateChanges().listen((user) {
      notifyListeners();
    });
  }

  User? get currentUser => _firebaseAuth.currentUser;
}

/// Redirect function - Determines navigation based on auth state and user role
Future<String?> redirectFunction(
  BuildContext context,
  GoRouterState state,
  AuthService authService,
) async {
  final currentPath = state.uri.path;

  // Allow access to splash and login screens without auth
  if (currentPath == '/splash' || currentPath == '/login') {
    return null;
  }

  // Check if user is authenticated
  final user = authService.currentUser;

  // If no user, redirect to login
  if (user == null) {
    return '/login';
  }

  // Fetch user data to determine role
  try {
    final userData = await authService.fetchUserData(user.uid);
    final role = userData.role;

    // Role-based routing
    if (role == 'parent') {
      // Parents can only access /parent-portal
      if (currentPath == '/teacher-home') {
        return '/parent-portal';
      }
      return null; // Allow current navigation
    } else {
      // Teachers and admins can only access /teacher-home
      if (currentPath == '/parent-portal') {
        return '/teacher-home';
      }
      return null; // Allow current navigation
    }
  } catch (e) {
    // If there's an error fetching user data, redirect to login
    return '/login';
  }
}

/// Router provider - Provides GoRouter instance with route protection
final routerProvider = Provider<GoRouter>((ref) {
  // Get instances from providers
  final authService = ref.watch(authServiceProvider);

  return GoRouter(
    initialLocation: '/splash',
    routes: [
      // Splash screen - shown while auth state is being determined
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      // Login screen
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      // Teacher home - accessible by teachers and admins
      GoRoute(
        path: '/teacher-home',
        builder: (context, state) => const TeacherHomeScreen(),
      ),
      // Parent portal - accessible by parents only
      GoRoute(
        path: '/parent-portal',
        builder: (context, state) => const ParentPortalScreen(),
      ),
    ],
    // Redirect function for route protection
    redirect: (context, state) async {
      return await redirectFunction(context, state, authService);
    },
    // Refresh router when auth state changes
    refreshListenable: AuthStateNotifier(FirebaseAuth.instance),
  );
});
