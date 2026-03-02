/// Phone utility functions for normalization and fake email generation
///
/// These utilities are used for parent authentication per Constitution § 4.2 and
/// phone normalization per Constitution § 12.3.

/// Normalize phone number to digits-only format
///
/// Removes all non-digit characters from the phone number string.
/// This is useful for storing and comparing phone numbers consistently.
///
/// Parameters:
/// - [phone]: The phone number string to normalize
///
/// Returns a string containing only the digits from the input.
/// Returns an empty string if the input is empty.
///
/// Examples:
/// - normalizePhone("050 123 4567") → "0501234567"
/// - normalizePhone("+966-50-123-4567") → "966501234567"
/// - normalizePhone("(050) 123-4567") → "0501234567"
/// - normalizePhone("") → ""
/// - normalizePhone("abc") → ""
///
/// This function is pure (no side effects) and handles empty strings gracefully.
String normalizePhone(String phone) {
  return phone.replaceAll(RegExp(r'[^0-9]'), '');
}

/// Generate a fake email for parent authentication from phone digits
///
/// Per Constitution § 4.2, parents authenticate using their phone number
/// as a fake email address. This allows Firebase Authentication to work
/// without requiring real email addresses for parents.
///
/// Parameters:
/// - [phoneDigits]: The normalized phone number (digits only)
///
/// Returns an email in the format: "parent{digits}@madrasa.local"
///
/// Examples:
/// - phoneToFakeEmail("0501234567") → "parent0501234567@madrasa.local"
/// - phoneToFakeEmail("966501234567") → "parent966501234567@madrasa.local"
///
/// Note: This function expects already-normalized phone digits.
/// Call [normalizePhone] first if you have a formatted phone number.
///
/// This function is pure (no side effects).
String phoneToFakeEmail(String phoneDigits) {
  return 'parent$phoneDigits@madrasa.local';
}
