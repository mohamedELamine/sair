import 'package:untitled/core/services/auth_exceptions.dart';

/// Phone number normalization and utility functions
/// 
/// Provides methods to normalize phone numbers for Firebase Auth
/// and generate fake emails for parent accounts
class PhoneUtils {
  /// Normalize a phone number by removing spaces, dashes, and country codes
  /// 
  /// Examples:
  /// - "123 456 7890" → "1234567890"
  /// - "123-456-7890" → "1234567890"
  /// - "+1 123 456 7890" → "1234567890"
  /// - "01234567890" → "01234567890"
  static String normalizePhone(String phone) {
    // Remove all non-digit characters
    return phone.replaceAll(RegExp(r'[^\d]'), '');
  }

  /// Generate a fake email from a phone number for parent accounts
  /// 
  /// Pattern: parent{digits}@madrasa.local
  /// Examples:
  /// - "1234567890" → "parent1234567890@madrasa.local"
  static String phoneToFakeEmail(String phone) {
    final normalized = normalizePhone(phone);
    return 'parent$normalized@madrasa.local';
  }

  /// Validate that a phone number is exactly 10 digits
  /// 
  /// Returns true if the phone number is valid after normalization
  static bool isValidPhone(String phone) {
    final normalized = normalizePhone(phone);
    return normalized.length == 10;
  }

  /// Convert a phone number to a password for Firebase Auth
  /// 
  /// Uses the last 6 digits of the phone number as password
  /// This allows parents to login with just their phone number
  static String phoneToPassword(String phone) {
    final normalized = normalizePhone(phone);
    if (normalized.length < 6) {
      throw InvalidPhoneException('Phone number must have at least 6 digits');
    }
    return normalized.substring(normalized.length - 6);
  }

  /// Format a phone number for display (xxx) xxx-xxxx
  static String formatPhoneForDisplay(String phone) {
    final normalized = normalizePhone(phone);
    if (normalized.length != 10) {
      return phone;
    }
    return '(${normalized.substring(0, 3)}) ${normalized.substring(3, 6)}-${normalized.substring(6)}';
  }
}

