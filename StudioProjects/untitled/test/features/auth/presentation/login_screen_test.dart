import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:untitled/features/auth/presentation/login_screen.dart';
import 'package:untitled/core/providers/auth_provider.dart';
import 'package:untitled/core/services/auth_service.dart';

@GenerateMocks([AuthService])
import 'login_screen_test.mocks.dart';

void main() {
  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();
  });

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        authServiceProvider.overrideWithValue(mockAuthService),
        authStateChangesProvider.overrideWith((ref) => Stream.value(null)),
      ],
      child: MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(size: Size(800, 1200)),
          child: const LoginScreen(),
        ),
      ),
    );
  }

  group('LoginScreen - Mode Switching', () {
    testWidgets('default mode is teacher/admin (email + password fields visible)',
        (tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert - Should show teacher/admin login mode by default
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('clicking toggle switches to parent mode (phone field visible)',
        (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Act - Click Parent toggle button
      await tester.tap(find.text('Parent'));
      await tester.pumpAndSettle();

      // Assert - Phone field should be visible, email should not
      expect(find.text('Phone Number'), findsOneWidget);
      expect(find.text('Email'), findsNothing);
    });

    testWidgets('clicking toggle again switches back to teacher/admin mode',
        (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Act - Click toggle to parent mode
      await tester.tap(find.text('Parent'));
      await tester.pumpAndSettle();

      // Act - Click toggle back to teacher/admin mode
      await tester.tap(find.text('Teacher/Admin'));
      await tester.pumpAndSettle();

      // Assert - Email and password fields should be visible again
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Phone Number'), findsNothing);
    });

    testWidgets('mode toggle shows correct segment buttons', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert - Both mode buttons should be visible
      expect(find.text('Teacher/Admin'), findsOneWidget);
      expect(find.text('Parent'), findsOneWidget);
      expect(find.byType(SegmentedButton<String>), findsOneWidget);
    });
  });

  group('LoginScreen - UI Elements', () {
    testWidgets('displays app title and subtitle', (tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Quran Madrasa'), findsOneWidget);
      expect(find.text('Sign in to continue'), findsOneWidget);
    });

    testWidgets('displays app icon', (tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.menu_book), findsOneWidget);
    });
  });
}
