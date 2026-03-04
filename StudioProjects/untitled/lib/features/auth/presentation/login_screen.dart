import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:untitled/core/providers/auth_provider.dart';
import 'package:untitled/features/auth/presentation/widgets/email_password_form.dart';
import 'package:untitled/features/auth/presentation/widgets/phone_form.dart';

/// LoginScreen - Main login screen with mode switching between teacher/admin and parent
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  // Login mode: 'teacher-admin' or 'parent'
  String _loginMode = 'teacher-admin';
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    // Listen to auth state changes to handle auto-login
    ref.listen(authStateChangesProvider, (previous, next) {
      next.when(
        data: (user) {
          if (user != null) {
            // User is authenticated, router will handle navigation
            // This is just to handle any edge cases
          }
        },
        loading: () {},
        error: (error, stack) {
          if (mounted) {
            setState(() {
              _errorMessage = error.toString();
            });
          }
        },
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              // Logo or icon
              Icon(
                Icons.menu_book,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 24),
              // Title
              const Text(
                'Quran Madrasa',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Sign in to continue',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32),
              // Error message display
              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade300),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red.shade700,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        color: Colors.red.shade700,
                        onPressed: () {
                          setState(() {
                            _errorMessage = null;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 32),
              // Mode toggle
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    value: 'teacher-admin',
                    label: Text('Teacher/Admin'),
                    icon: Icon(Icons.person),
                  ),
                  ButtonSegment(
                    value: 'parent',
                    label: Text('Parent'),
                    icon: Icon(Icons.phone),
                  ),
                ],
                selected: {_loginMode},
                onSelectionChanged: (Set<String> selected) {
                  setState(() {
                    _loginMode = selected.first;
                    _errorMessage = null;
                  });
                },
              ),
              const SizedBox(height: 32),
              // Conditional form rendering
              if (_loginMode == 'teacher-admin')
                EmailPasswordForm(
                  errorMessage: _errorMessage,
                )
              else
                PhoneForm(
                  errorMessage: _errorMessage,
                ),
              ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
