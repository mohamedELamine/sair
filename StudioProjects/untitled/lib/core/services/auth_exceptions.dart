/// Custom authentication exceptions
/// 
/// Provides specific exception types for different authentication failures
/// This allows for better error handling and user feedback

/// Exception thrown when a user is not found in the system
class UserNotFoundException implements Exception {
  final String message;
  UserNotFoundException([this.message = 'User not found']);

  @override
  String toString() => 'UserNotFoundException: $message';
}

/// Exception thrown when the provided password is incorrect
class WrongPasswordException implements Exception {
  final String message;
  WrongPasswordException([this.message = 'Incorrect password']);

  @override
  String toString() => 'WrongPasswordException: $message';
}

/// Exception thrown when the phone number is invalid
class InvalidPhoneException implements Exception {
  final String message;
  InvalidPhoneException([this.message = 'Invalid phone number']);

  @override
  String toString() => 'InvalidPhoneException: $message';
}

/// Exception thrown when an account is inactive or disabled
class AccountInactiveException implements Exception {
  final String message;
  AccountInactiveException([this.message = 'Account is inactive']);

  @override
  String toString() => 'AccountInactiveException: $message';
}

/// Exception thrown when there is a network error during authentication
class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = 'Network error']);

  @override
  String toString() => 'NetworkException: $message';
}

/// Exception thrown when login attempts are throttled due to too many failures
class ThrottleException implements Exception {
  final int secondsUntilAllowed;
  final String message;
  ThrottleException(this.secondsUntilAllowed, [this.message = 'Too many failed attempts']);

  @override
  String toString() => 
      'ThrottleException: $message. Please try again in $secondsUntilAllowed seconds.';
}
