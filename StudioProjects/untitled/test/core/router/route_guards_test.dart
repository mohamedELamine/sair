import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:untitled/core/models/user_model.dart';
import 'package:untitled/core/services/auth_service.dart';
import 'package:untitled/core/services/auth_exceptions.dart';

@GenerateMocks([FirebaseAuth, FirebaseFirestore, User, QueryDocumentSnapshot])
import 'route_guards_test.mocks.dart';

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockFirebaseFirestore mockFirestore;
  late MockUser mockUser;
  late MockQueryDocumentSnapshot mockUserDoc;
  late AuthService authService;
  late GoRouter router;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockFirestore = MockFirebaseFirestore();
    mockUser = MockUser();
    mockUserDoc = MockQueryDocumentSnapshot();

    // Mock user data
    when(mockUser.uid).thenReturn('test-user-id');
    when(mockUser.email).thenReturn('teacher@test.com');
    when(mockUserDoc.id).thenReturn('test-user-id');
    when(mockUserDoc.data()).thenReturn({
      'id': 'test-user-id',
      'role': 'teacher',
      'email': 'teacher@test.com',
      'phone': null,
      'madrasaId': 'default',
      'active': true,
      'createdAt': DateTime.now().toIso8601String(),
    });
    when(mockFirestore.collection('users').doc('test-user-id')).thenReturn(
      mockUserDoc,
    );

    authService = AuthService(
      firebaseAuth: mockFirebaseAuth,
      firestore: mockFirestore,
    );
  });

  group('Route Guards - Redirect Logic', () {
    test('unauthenticated user accessing protected route redirects to /login',
        () async {
      // Arrange
      when(mockFirebaseAuth.authStateChanges).thenReturn(
        Stream.value(null),
      );

      final options = GoRouterState(
        location: '/teacher-home',
        uri: Uri.parse('/teacher-home'),
      );

      // Act
      final redirectResult = await _redirectFunction(mockFirebaseAuth, authService, options);

      // Assert
      expect(redirectResult, '/login');
    });

    test('teacher logging in redirects to /teacher-home', () async {
      // Arrange
      when(mockFirebaseAuth.authStateChanges).thenReturn(
        Stream.value(mockUser),
      );
      when(mockFirestore.collection('users').doc('test-user-id').get()).thenAnswer(
        (_) async => mockUserDoc,
      );

      final options = GoRouterState(
        location: '/login',
        uri: Uri.parse('/login'),
      );

      // Act
      final redirectResult = await _redirectFunction(mockFirebaseAuth, authService, options);

      // Assert
      expect(redirectResult, '/teacher-home');
    });

    test('parent logging in redirects to /parent-portal', () async {
      // Arrange
      when(mockFirebaseAuth.authStateChanges).thenReturn(
        Stream.value(mockUser),
      );
      when(mockFirestore.collection('users').doc('test-user-id').get()).thenAnswer(
        (_) async => mockUserDoc,
      );

      // Modify mock to return parent role
      when(mockUserDoc.data()).thenReturn({
        'id': 'test-user-id',
        'role': 'parent',
        'email': 'parent@test.com',
        'phone': '+1234567890',
        'madrasaId': 'default',
        'active': true,
        'createdAt': DateTime.now().toIso8601String(),
      });

      final options = GoRouterState(
        location: '/login',
        uri: Uri.parse('/login'),
      );

      // Act
      final redirectResult = await _redirectFunction(mockFirebaseAuth, authService, options);

      // Assert
      expect(redirectResult, '/parent-portal');
    });

    test('parent accessing /teacher-home redirects to /parent-portal', () async {
      // Arrange
      when(mockFirebaseAuth.authStateChanges).thenReturn(
        Stream.value(mockUser),
      );
      when(mockFirestore.collection('users').doc('test-user-id').get()).thenAnswer(
        (_) async => mockUserDoc,
      );

      // Modify mock to return parent role
      when(mockUserDoc.data()).thenReturn({
        'id': 'test-user-id',
        'role': 'parent',
        'email': 'parent@test.com',
        'phone': '+1234567890',
        'madrasaId': 'default',
        'active': true,
        'createdAt': DateTime.now().toIso8601String(),
      });

      final options = GoRouterState(
        location: '/teacher-home',
        uri: Uri.parse('/teacher-home'),
      );

      // Act
      final redirectResult = await _redirectFunction(mockFirebaseAuth, authService, options);

      // Assert
      expect(redirectResult, '/parent-portal');
    });

    test('teacher accessing /parent-portal redirects to /teacher-home', () async {
      // Arrange
      when(mockFirebaseAuth.authStateChanges).thenReturn(
        Stream.value(mockUser),
      );
      when(mockFirestore.collection('users').doc('test-user-id').get()).thenAnswer(
        (_) async => mockUserDoc,
      );

      final options = GoRouterState(
        location: '/parent-portal',
        uri: Uri.parse('/parent-portal'),
      );

      // Act
      final redirectResult = await _redirectFunction(mockFirebaseAuth, authService, options);

      // Assert
      expect(redirectResult, '/teacher-home');
    });

    test('auth state loading shows /splash screen', () async {
      // Arrange
      when(mockFirebaseAuth.authStateChanges).thenReturn(
        Stream.empty(),
      );

      final options = GoRouterState(
        location: '/splash',
        uri: Uri.parse('/splash'),
      );

      // Act
      final redirectResult = await _redirectFunction(mockFirebaseAuth, authService, options);

      // Assert
      expect(redirectResult, null);
    });
  });

  group('Route Guards - Admin Authentication', () {
    test('admin logging in redirects to /teacher-home (same as teacher)', () async {
      // Arrange
      when(mockFirebaseAuth.authStateChanges).thenReturn(
        Stream.value(mockUser),
      );
      when(mockFirestore.collection('users').doc('test-user-id').get()).thenAnswer(
        (_) async => mockUserDoc,
      );

      // Modify mock to return admin role
      when(mockUserDoc.data()).thenReturn({
        'id': 'test-user-id',
        'role': 'admin',
        'email': 'admin@test.com',
        'phone': null,
        'madrasaId': 'default',
        'active': true,
        'createdAt': DateTime.now().toIso8601String(),
      });

      final options = GoRouterState(
        location: '/login',
        uri: Uri.parse('/login'),
      );

      // Act
      final redirectResult = await _redirectFunction(mockFirebaseAuth, authService, options);

      // Assert
      expect(redirectResult, '/teacher-home');
    });

    test('admin accessing /parent-portal redirects to /teacher-home', () async {
      // Arrange
      when(mockFirebaseAuth.authStateChanges).thenReturn(
        Stream.value(mockUser),
      );
      when(mockFirestore.collection('users').doc('test-user-id').get()).thenAnswer(
        (_) async => mockUserDoc,
      );

      // Modify mock to return admin role
      when(mockUserDoc.data()).thenReturn({
        'id': 'test-user-id',
        'role': 'admin',
        'email': 'admin@test.com',
        'phone': null,
        'madrasaId': 'default',
        'active': true,
        'createdAt': DateTime.now().toIso8601String(),
      });

      final options = GoRouterState(
        location: '/parent-portal',
        uri: Uri.parse('/parent-portal'),
      );

      // Act
      final redirectResult = await _redirectFunction(mockFirebaseAuth, authService, options);

      // Assert
      expect(redirectResult, '/teacher-home');
    });
  });

  // Helper function to test redirect logic
  Future<String?> _redirectFunction(
    FirebaseAuth auth,
    AuthService authService,
    GoRouterState options,
  ) async {
    // Simulate redirect logic from research.md
    // 1. Check if auth state is loading (stream empty)
    final authState = auth.authStateChanges();
    await for (final user in authState);
    if (user == null) {
      return '/login';
    }

    // 2. Fetch user data
    final userData = await authService._fetchUserData(user.uid);
    final role = userData.role;

    // 3. Role-based routing
    if (role == 'parent') {
      if (options.uri.path == '/teacher-home') {
        return '/parent-portal';
      }
      return '/parent-portal';
    } else {
      // teacher or admin
      if (options.uri.path == '/parent-portal') {
        return '/teacher-home';
      }
      return '/teacher-home';
    }
  }
}
