import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:untitled/core/services/auth_service.dart';
import 'package:untitled/core/services/auth_exceptions.dart';
import 'package:untitled/core/providers/auth_provider.dart';

/// PhoneForm - Login form for parent authentication using phone number
class PhoneForm extends ConsumerStatefulWidget {
  final String? errorMessage;

  const PhoneForm({
    super.key,
    this.errorMessage,
  });

  @override
  ConsumerState<PhoneForm> createState() => _PhoneFormState();
}

class _PhoneFormState extends ConsumerState<PhoneForm> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;

  // Phone number input formatter (shows (xxx) xxx-xxxx format)
  final _phoneInputFormatter = FilteringTextInputFormatter.digitsOnly;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final phone = _phoneController.text.trim();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Connect to AuthService.signInWithPhone
    final authService = ref.read(authServiceProvider);

    authService.signInWithPhone(phone).then((_) {
      // Success - router will handle navigation
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }).catchError((e) {
      if (!mounted) return;

      String errorMsg = 'An error occurred. Please try again.';
      if (e is InvalidPhoneException) {
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
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            key: const Key('phoneField'),
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            inputFormatters: [_phoneInputFormatter],
            maxLength: 10,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              hintText: '(123) 456-7890',
              prefixIcon: Icon(Icons.phone),
              border: OutlineInputBorder(),
              counterText: '',
            ),
            enabled: !_isLoading,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Phone number is required';
              }
              if (value.length != 10) {
                return 'Phone number must be exactly 10 digits';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
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
      ),
    );
  }
}
