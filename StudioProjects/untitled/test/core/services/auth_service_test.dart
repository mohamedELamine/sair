import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:untitled/core/models/user_model.dart';
import 'package:untitled/core/services/auth_exceptions.dart';
import 'package:untitled/core/services/auth_service.dart';
import 'package:untitled/core/utils/phone_utils.dart';

@GenerateMocks([
  FirebaseAuth,
  FirebaseFirestore,
  User,
  UserCredential,
  CollectionReference,
  DocumentReference,
  DocumentSnapshot,
  QuerySnapshot,
])
import 'auth_service_test.mocks.dart';

void main() {
  late MockFirebaseAuth mockAuth;
  late MockFirebaseFirestore mockFirestore;
  late AuthService authService;

  setUp(() {
    mockAuth = MockFirebaseAuth();
    mockFirestore = MockFirebaseFirestore();
    authService = AuthService(
      auth: mockAuth,
      firestore: mockFirestore,
    );
  });

  group('AuthService - signInWithEmail', () {
    const testEmail = 'teacher@example.com';
    const testPassword = 'password123';

    test('signInWithEmail with valid credentials returns UserModel with role=teacher', () async {
      // Arrange
      const testUid = 'user123';
      const testMadrasaId = 'madrasa1';
      final testCreatedAt = DateTime(2024, 1, 1);

      final mockUser = MockUser();
      final mockUserCredential = MockUserCredential();
      when(mockUser.uid).thenReturn(testUid);
      when(mockUser.email).thenReturn(testEmail);
      when(mockUserCredential.user).thenReturn(mockUser);

      when(mockAuth.signInWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      )).thenAnswer((_) async => mockUserCredential);

      final mockCollectionRef = MockCollectionReference<Map<String, dynamic>>();
      final mockDocRef = MockDocumentReference<Map<String, dynamic>>();
      final mockDocSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();

      when(mockFirestore.collection('users')).thenReturn(mockCollectionRef);
      when(mockCollectionRef.doc(testUid)).thenReturn(mockDocRef);
      when(mockDocRef.get()).thenAnswer((_) async => mockDocSnapshot);
      when(mockDocSnapshot.exists).thenReturn(true);
      when(mockDocSnapshot.data()).thenReturn({
        'id': testUid,
        'role': 'teacher',
        'email': testEmail,
        'phone': '1234567890',
        'madrasaId': testMadrasaId,
        'active': true,
        'createdAt': testCreatedAt.toIso8601String(),
      });

      // Act
      final result = await authService.signInWithEmail(testEmail, testPassword);

      // Assert
      expect(result, isA<UserModel>());
      expect(result.id, testUid);
      expect(result.role, 'teacher');
      expect(result.email, testEmail);
      expect(result.active, true);
    });

    test('signInWithEmail with user-not-found throws UserNotFoundException', () async {
      // Arrange
      when(mockAuth.signInWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      )).thenThrow(
        FirebaseAuthException(
          code: 'user-not-found',
          message: 'No user found for that email.',
        ),
      );

      // Act & Assert
      expect(
        () => authService.signInWithEmail(testEmail, testPassword),
        throwsA(isA<UserNotFoundException>()),
      );
    });

    test('signInWithEmail with wrong-password throws WrongPasswordException', () async {
      // Arrange
      when(mockAuth.signInWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      )).thenThrow(
        FirebaseAuthException(
          code: 'wrong-password',
          message: 'The password is incorrect.',
        ),
      );

      // Act & Assert
      expect(
        () => authService.signInWithEmail(testEmail, testPassword),
        throwsA(isA<WrongPasswordException>()),
      );
    });

    test('signInWithEmail with inactive account throws AccountInactiveException', () async {
      // Arrange
      const testUid = 'user123';
      final testCreatedAt = DateTime(2024, 1, 1);

      final mockUser = MockUser();
      final mockUserCredential = MockUserCredential();
      when(mockUser.uid).thenReturn(testUid);
      when(mockUser.email).thenReturn(testEmail);
      when(mockUserCredential.user).thenReturn(mockUser);

      when(mockAuth.signInWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      )).thenAnswer((_) async => mockUserCredential);

      final mockCollectionRef = MockCollectionReference<Map<String, dynamic>>();
      final mockDocRef = MockDocumentReference<Map<String, dynamic>>();
      final mockDocSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();

      when(mockFirestore.collection('users')).thenReturn(mockCollectionRef);
      when(mockCollectionRef.doc(testUid)).thenReturn(mockDocRef);
      when(mockDocRef.get()).thenAnswer((_) async => mockDocSnapshot);
      when(mockDocSnapshot.exists).thenReturn(true);
      when(mockDocSnapshot.data()).thenReturn({
        'id': testUid,
        'role': 'teacher',
        'email': testEmail,
        'phone': '1234567890',
        'madrasaId': 'madrasa1',
        'active': false, // Inactive account
        'createdAt': testCreatedAt.toIso8601String(),
      });

      // Act & Assert
      expect(
        () => authService.signInWithEmail(testEmail, testPassword),
        throwsA(isA<AccountInactiveException>()),
      );
    });

    test('failed attempts counter increments and throttling delays apply', () async {
      // Arrange
      when(mockAuth.signInWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      )).thenThrow(
        FirebaseAuthException(
          code: 'wrong-password',
          message: 'The password is incorrect.',
        ),
      );

      // Act & Assert - First attempt (no throttle, sets counter to 1)
      await expectLater(
        authService.signInWithEmail(testEmail, testPassword),
        throwsA(isA<WrongPasswordException>()),
      );

      // Second attempt immediately - should throw throttle (requires 2s delay after 1 failure)
      await expectLater(
        authService.signInWithEmail(testEmail, testPassword),
        throwsA(isA<ThrottleException>()),
      );
    });
  });

  group('AuthService - Admin Authentication', () {
    const testEmail = 'admin@example.com';
    const testPassword = 'password123';

    test('signInWithEmail with admin role returns UserModel with role=admin', () async {
      // Arrange
      const testUid = 'admin123';
      const testMadrasaId = 'madrasa1';
      final testCreatedAt = DateTime(2024, 1, 1);

      final mockUser = MockUser();
      final mockUserCredential = MockUserCredential();
      when(mockUser.uid).thenReturn(testUid);
      when(mockUser.email).thenReturn(testEmail);
      when(mockUserCredential.user).thenReturn(mockUser);

      when(mockAuth.signInWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      )).thenAnswer((_) async => mockUserCredential);

      final mockCollectionRef = MockCollectionReference<Map<String, dynamic>>();
      final mockDocRef = MockDocumentReference<Map<String, dynamic>>();
      final mockDocSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();

      when(mockFirestore.collection('users')).thenReturn(mockCollectionRef);
      when(mockCollectionRef.doc(testUid)).thenReturn(mockDocRef);
      when(mockDocRef.get()).thenAnswer((_) async => mockDocSnapshot);
      when(mockDocSnapshot.exists).thenReturn(true);
      when(mockDocSnapshot.data()).thenReturn({
        'id': testUid,
        'role': 'admin',
        'email': testEmail,
        'phone': '1234567890',
        'madrasaId': testMadrasaId,
        'active': true,
        'createdAt': testCreatedAt.toIso8601String(),
      });

      // Act
      final result = await authService.signInWithEmail(testEmail, testPassword);

      // Assert
      expect(result, isA<UserModel>());
      expect(result.id, testUid);
      expect(result.role, 'admin');
      expect(result.email, testEmail);
      expect(result.active, true);
    });
  });

  group('AuthService - signInWithPhone', () {
    const testPhone = '1234567890';
    const testFakeEmail = 'parent1234567890@madrasa.local';
    const testPassword = '567890'; // Last 6 digits of phone

    test('signInWithPhone with new phone creates account and returns UserModel with role=parent',
        () async {
      // Arrange
      const testUid = 'parent123';
      const testMadrasaId = 'default';

      final mockUser = MockUser();
      final mockUserCredential = MockUserCredential();
      when(mockUser.uid).thenReturn(testUid);
      when(mockUser.email).thenReturn(testFakeEmail);
      when(mockUserCredential.user).thenReturn(mockUser);

      // Mock user-not-found error for signInWithEmailAndPassword
      when(mockAuth.signInWithEmailAndPassword(
        email: testFakeEmail,
        password: testPassword,
      )).thenThrow(
        FirebaseAuthException(
          code: 'user-not-found',
          message: 'No user found for that email.',
        ),
      );

      // Mock successful account creation
      when(mockAuth.createUserWithEmailAndPassword(
        email: testFakeEmail,
        password: testPassword,
      )).thenAnswer((_) async => mockUserCredential);

      // Mock Firestore document creation
      final mockCollectionRef = MockCollectionReference<Map<String, dynamic>>();
      final mockDocRef = MockDocumentReference<Map<String, dynamic>>();
      final mockDocSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();

      when(mockFirestore.collection('users')).thenReturn(mockCollectionRef);
      when(mockCollectionRef.doc(testUid)).thenReturn(mockDocRef);
      when(mockDocRef.set(any)).thenAnswer((_) async => {});
      when(mockDocRef.get()).thenAnswer((_) async => mockDocSnapshot);
      when(mockDocSnapshot.exists).thenReturn(true);
      when(mockDocSnapshot.data()).thenReturn({
        'id': testUid,
        'role': 'parent',
        'email': testFakeEmail,
        'phone': testPhone,
        'madrasaId': testMadrasaId,
        'active': true,
        'createdAt': DateTime.now().toIso8601String(),
      });

      // Act
      final result = await authService.signInWithPhone(testPhone);

      // Assert
      expect(result, isA<UserModel>());
      expect(result.id, testUid);
      expect(result.role, 'parent');
      expect(result.email, testFakeEmail);
      expect(result.phone, testPhone);
      expect(result.active, true);
    });

    test('signInWithPhone with existing phone authenticates and returns UserModel',
        () async {
      // Arrange
      const testPhone = '1234567890';
      const testFakeEmail = 'parent1234567890@madrasa.local';
      const testPassword = '567890'; // Last 6 digits of phone

      final mockUser = MockUser();
      final mockUserCredential = MockUserCredential();
      when(mockUser.uid).thenReturn('parent123');
      when(mockUser.email).thenReturn(testFakeEmail);
      when(mockUserCredential.user).thenReturn(mockUser);

      // Mock successful login
      when(mockAuth.signInWithEmailAndPassword(
        email: testFakeEmail,
        password: testPassword,
      )).thenAnswer((_) async => mockUserCredential);

      // Mock Firestore document fetch
      final mockCollectionRef = MockCollectionReference<Map<String, dynamic>>();
      final mockDocRef = MockDocumentReference<Map<String, dynamic>>();
      final mockDocSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();

      when(mockFirestore.collection('users')).thenReturn(mockCollectionRef);
      when(mockCollectionRef.doc('parent123')).thenReturn(mockDocRef);
      when(mockDocRef.get()).thenAnswer((_) async => mockDocSnapshot);
      when(mockDocSnapshot.exists).thenReturn(true);
      when(mockDocSnapshot.data()).thenReturn({
        'id': 'parent123',
        'role': 'parent',
        'email': testFakeEmail,
        'phone': testPhone,
        'madrasaId': 'default',
        'active': true,
        'createdAt': DateTime.now().toIso8601String(),
      });

      // Act
      final result = await authService.signInWithPhone(testPhone);

      // Assert
      expect(result, isA<UserModel>());
      expect(result.id, 'parent123');
      expect(result.role, 'parent');
      expect(result.email, testFakeEmail);
    });

    test('signInWithPhone with invalid phone format (not 10 digits) throws InvalidPhoneException',
        () async {
      // Arrange
      const testPhone = '123'; // Invalid: only 3 digits

      // Act & Assert
      expect(
        () => authService.signInWithPhone(testPhone),
        throwsA(isA<InvalidPhoneException>()),
      );
    });

    test('phone normalization removes spaces, dashes, parentheses', () {
      // Arrange
      const testPhone = '+1 (123) 456-7890';

      // Act
      final normalizedPhone = PhoneUtils.normalizePhone(testPhone);

      // Assert
      expect(normalizedPhone, '11234567890'); // Note: leading 1 is kept
    });
  });
}
