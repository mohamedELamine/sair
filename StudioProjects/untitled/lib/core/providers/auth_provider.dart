import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled/core/models/user_model.dart';
import 'package:untitled/core/services/auth_service.dart';

/// Auth service provider
final authServiceProvider = Provider<AuthService>((ref) {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  return AuthService(auth: auth, firestore: firestore);
});

/// Stream of authentication state changes
final authStateChangesProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

/// Current user provider
/// Fetches UserModel from Firestore when auth state changes
final currentUserProvider = StreamProvider<UserModel?>((ref) {
  final authState = ref.watch(authStateChangesProvider);

  return authState.when(
    data: (user) async* {
      if (user == null) {
        yield null;
        return;
      }

      final authService = ref.read(authServiceProvider);
      try {
        yield await authService.fetchUserData(user.uid);
      } catch (e) {
        yield null;
      }
    },
    loading: () async* {
      yield null;
    },
    error: (_, __) async* {
      yield null;
    },
  );
});

/// Sign in with email provider
final signInWithEmailProvider = FutureProvider.family<UserModel, ({String email, String password})>(
  (ref, args) async {
    final authService = ref.read(authServiceProvider);
    return await authService.signInWithEmail(args.email, args.password);
  },
);

/// Sign in with phone provider
final signInWithPhoneProvider = FutureProvider.family<UserModel, String>((ref, phoneNumber) async {
  final authService = ref.read(authServiceProvider);
  return await authService.signInWithPhone(phoneNumber);
});

/// Sign out provider
final signOutProvider = FutureProvider<void>((ref) async {
  final authService = ref.read(authServiceProvider);
  await authService.signOut();
});
