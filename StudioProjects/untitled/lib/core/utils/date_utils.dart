/// Date utility functions for dayKey generation and parsing
///
/// dayKey format: YYYY-MM-DD (ISO 8601 date format)
/// This format is used throughout the application for date-based data organization
/// per Constitution § 12.2.

/// Generate dayKey in format YYYY-MM-DD from a DateTime object
///
/// Parameters:
/// - [date]: The DateTime to convert
///
/// Returns a string in "YYYY-MM-DD" format with zero-padded month and day.
/// Example: DateTime(2026, 1, 1) → "2026-01-01"
/// Example: DateTime(2026, 12, 31) → "2026-12-31"
///
/// This function is pure (no side effects) and handles all edge cases including
/// leap years and single-digit months/days.
String dayKey(DateTime date) {
  return "${date.year.toString().padLeft(4, '0')}-"
      "${date.month.toString().padLeft(2, '0')}-"
      "${date.day.toString().padLeft(2, '0')}";
}

/// Parse dayKey string back to DateTime object
///
/// Parameters:
/// - [dayKey]: A string in "YYYY-MM-DD" format
///
/// Returns a DateTime object if the dayKey is valid, null otherwise.
///
/// Validation rules:
/// - Must match format: YYYY-MM-DD (exactly 10 characters)
/// - Year, month, day must be numeric
/// - Month must be between 1 and 12
/// - Day must be valid for the given month and year (handles leap years)
///
/// Examples:
/// - parseDayKey("2026-03-02") → DateTime(2026, 3, 2)
/// - parseDayKey("2026-3-2") → null (invalid format)
/// - parseDayKey("2026-13-01") → null (invalid month)
/// - parseDayKey("invalid") → null (not a date string)
DateTime? parseDayKey(String dayKey) {
  try {
    final parts = dayKey.split('-');
    if (parts.length != 3) return null;

    // Validate format - each part must be exactly 2 digits for month and day
    if (parts[0].length != 4) return null; // YYYY
    if (parts[1].length != 2) return null; // MM
    if (parts[2].length != 2) return null; // DD

    final year = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final day = int.parse(parts[2]);

    // Validate ranges
    if (year < 1 || year > 9999) return null;
    if (month < 1 || month > 12) return null;
    if (day < 1 || day > 31) return null;

    // Validate actual date validity (handles leap years and invalid days)
    final date = DateTime(year, month, day);
    if (date.year != year || date.month != month || date.day != day) {
      return null;
    }

    return date;
  } catch (e) {
    return null;
  }
}
