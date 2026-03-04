import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:untitled/core/services/auth_service.dart';
import 'package:untitled/core/services/auth_exceptions.dart';
import 'package:untitled/core/providers/auth_provider.dart';

/// EmailPasswordForm - Login form for teacher/admin authentication
class EmailPasswordForm extends ConsumerStatefulWidget {
  final String? errorMessage;

  const EmailPasswordForm({
    super.key,
    this.errorMessage,
  });

  @override
  ConsumerState<EmailPasswordForm> createState() => _EmailPasswordFormState();
}

class _EmailPasswordFormState extends ConsumerState<EmailPasswordForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter both email and password';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Connect to AuthService.signInWithEmail
    final authService = ref.read(authServiceProvider);

    authService.signInWithEmail(email, password).then((_) {
      // Success - router will handle navigation
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }).catchError((e) {
      if (!mounted) return;

      String errorMsg = 'An error occurred. Please try again.';
      if (e is UserNotFoundException ||
          e is WrongPasswordException ||
          e is AccountInactiveException ||
          e is ThrottleException) {
        errorMsg = e.message;
      }

      setState(() {
        _errorMessage = errorMsg;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          key: const Key('emailField'),
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.email),
            border: OutlineInputBorder(),
          ),
          enabled: !_isLoading,
        ),
        const SizedBox(height: 16),
        TextField(
          key: const Key('passwordField'),
          controller: _passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Password',
            prefixIcon: Icon(Icons.lock),
            border: OutlineInputBorder(),
          ),
          enabled: !_isLoading,
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          key: const Key('loginButton'),
          onPressed: _isLoading ? null : _handleLogin,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: _isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text(
                  'Login',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
        ),
        if (widget.errorMessage != null) ...[
          const SizedBox(height: 16),
          Text(
            widget.errorMessage!,
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
