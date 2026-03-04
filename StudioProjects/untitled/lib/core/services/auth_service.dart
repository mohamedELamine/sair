import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled/core/models/user_model.dart';
import 'package:untitled/core/services/auth_exceptions.dart';
import 'package:untitled/core/utils/phone_utils.dart';

/// Authentication service handling user login, logout, and authentication state
/// 
/// Provides methods for email/password authentication and phone-based authentication
/// with role-based access control and throttling protection
class AuthService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  // Failed attempts tracking: Map<email, count>
  final Map<String, int> _failedAttempts = {};

  // Last attempt timestamp tracking: Map<email, timestamp>
  final Map<String, DateTime> _lastAttemptTime = {};

  AuthService({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  })  : _auth = auth,
        _firestore = firestore;

  /// Sign in user with email and password
  ///
  /// Throws UserNotFoundException if user doesn't exist
  /// Throws WrongPasswordException if password is incorrect
  /// Throws AccountInactiveException if account is inactive
  /// Throws ThrottleException if too many failed attempts
  Future<UserModel> signInWithEmail(String email, String password) async {
    // Check throttling based on failed attempts
    final attempts = _failedAttempts[email] ?? 0;
    final lastAttempt = _lastAttemptTime[email];

    if (attempts > 0 && lastAttempt != null) {
      // Calculate required delay based on number of failed attempts
      // 1 failure = 2s, 2 failures = 5s, 3+ failures = 10s
      final int requiredDelay;
      if (attempts == 1) {
        requiredDelay = 2;
      } else if (attempts == 2) {
        requiredDelay = 5;
      } else {
        requiredDelay = 10;
      }

      final timeSinceLastAttempt = DateTime.now().difference(lastAttempt).inSeconds;
      if (timeSinceLastAttempt < requiredDelay) {
        final remainingTime = requiredDelay - timeSinceLastAttempt;
        throw ThrottleException(
          remainingTime,
          'Too many failed attempts. Please wait $remainingTime seconds.',
        );
      }
    }

    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userData = await fetchUserData(userCredential.user!.uid);

      // Reset failed attempts and timestamp on success
      _failedAttempts[email] = 0;
      _lastAttemptTime.remove(email);

      return userData;
    } on FirebaseAuthException catch (e) {
      // Record failed attempt with timestamp
      _failedAttempts[email] = (attempts + 1);
      _lastAttemptTime[email] = DateTime.now();

      // Map Firebase exceptions to custom exceptions
      switch (e.code) {
        case 'user-not-found':
          throw UserNotFoundException('No user found for that email.');
        case 'wrong-password':
          throw WrongPasswordException('Incorrect password');
        case 'account-disabled':
        case 'account-not-verified':
          throw AccountInactiveException('Account is inactive');
        case 'too-many-requests':
          throw ThrottleException(2, 'Too many failed attempts');
        default:
          throw NetworkException(e.message ?? 'Authentication failed');
      }
    } on UserNotFoundException {
      rethrow;
    } on WrongPasswordException {
      rethrow;
    } on AccountInactiveException {
      rethrow;
    } on ThrottleException {
      rethrow;
    } catch (e) {
      throw NetworkException('An unexpected error occurred');
    }
  }

  /// Sign in user with phone number (for parents)
  /// 
  /// Creates account if it doesn't exist
  Future<UserModel> signInWithPhone(String phoneNumber) async {
    try {
      // Validate phone number
      if (!PhoneUtils.isValidPhone(phoneNumber)) {
        throw InvalidPhoneException('Phone number must be exactly 10 digits');
      }

      final normalizedPhone = PhoneUtils.normalizePhone(phoneNumber);
      final fakeEmail = PhoneUtils.phoneToFakeEmail(phoneNumber);
      final password = PhoneUtils.phoneToPassword(phoneNumber);

      try {
        // Try to sign in with existing account
        final userCredential = await _auth.signInWithEmailAndPassword(
          email: fakeEmail,
          password: password,
        );

        final userData = await fetchUserData(userCredential.user!.uid);
        return userData;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          // Create new account
          final userCredential = await _auth.createUserWithEmailAndPassword(
            email: fakeEmail,
            password: password,
          );

          final userData = await _createParentAccount(
            userCredential.user!,
            normalizedPhone,
          );

          return userData;
        } else {
          rethrow;
        }
      }
    } on InvalidPhoneException {
      rethrow;
    } catch (e) {
      throw NetworkException('Authentication failed');
    }
  }

  /// Sign out current user
  Future<void> signOut() async {
    await _auth.signOut();
    // Clear failed attempts and timestamps on logout
    _failedAttempts.clear();
    _lastAttemptTime.clear();
  }

  /// Stream of authentication state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Get current authenticated user
  User? get currentUser => _auth.currentUser;

  /// Fetch user data from Firestore
  Future<UserModel> fetchUserData(String uid) async {
    try {
      final docSnapshot = await _firestore.collection('users').doc(uid).get();

      if (!docSnapshot.exists) {
        throw UserNotFoundException('User not found');
      }

      final data = docSnapshot.data() as Map<String, dynamic>;

      // Check if account is active
      if (data['active'] == false) {
        throw AccountInactiveException('Account is inactive');
      }

      return UserModel.fromJson(data);
    } catch (e) {
      if (e is UserNotFoundException || e is AccountInactiveException) {
        rethrow;
      }
      throw NetworkException('Failed to fetch user data');
    }
  }

  /// Create a new parent account
  Future<UserModel> _createParentAccount(User user, String phone) async {
    try {
      final now = DateTime.now();

      final userData = UserModel(
        id: user.uid,
        role: 'parent',
        email: user.email!,
        phone: phone,
        madrasaId: 'default',
        active: true,
        createdAt: now,
      );

      await _firestore.collection('users').doc(user.uid).set(userData.toJson());

      return userData;
    } catch (e) {
      // If account creation fails, delete the auth user
      await user.delete();
      throw NetworkException('Failed to create account');
    }
  }
}
