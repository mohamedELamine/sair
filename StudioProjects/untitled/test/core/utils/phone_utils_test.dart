import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/core/utils/phone_utils.dart';

void main() {
  group('PhoneUtils Tests', () {
    group('normalizePhone', () {
      test('normalizePhone removes spaces', () {
        final result = normalizePhone('050 123 4567');
        expect(result, '0501234567');
      });

      test('normalizePhone removes dashes and plus', () {
        final result = normalizePhone('+966-50-123-4567');
        expect(result, '966501234567');
      });

      test('normalizePhone removes parentheses', () {
        final result = normalizePhone('(050) 123-4567');
        expect(result, '0501234567');
      });

      test('normalizePhone handles empty string', () {
        final result = normalizePhone('');
        expect(result, '');
      });

      test('normalizePhone removes all non-digit characters', () {
        final result = normalizePhone('050-123-4567 ext. 123');
        expect(result, '0501234567123');
      });

      test('normalizePhone handles phone with dots', () {
        final result = normalizePhone('050.123.4567');
        expect(result, '0501234567');
      });

      test('normalizePhone handles mixed formatting', () {
        final result = normalizePhone('+1 (800) 555-1234');
        expect(result, '18005551234');
      });

      test('normalizePhone handles letters', () {
        final result = normalizePhone('abc123def');
        expect(result, '123');
      });

      test('normalizePhone handles only non-digits', () {
        final result = normalizePhone('abc-def-ghi');
        expect(result, '');
      });

      test('normalizePhone preserves digits only', () {
        final result = normalizePhone('0501234567');
        expect(result, '0501234567');
      });
    });

    group('phoneToFakeEmail', () {
      test('phoneToFakeEmail generates correct format', () {
        final result = phoneToFakeEmail('0501234567');
        expect(result, 'parent0501234567@madrasa.local');
      });

      test('phoneToFakeEmail handles country code', () {
        final result = phoneToFakeEmail('966501234567');
        expect(result, 'parent966501234567@madrasa.local');
      });

      test('phoneToFakeEmail handles short phone number', () {
        final result = phoneToFakeEmail('123');
        expect(result, 'parent123@madrasa.local');
      });

      test('phoneToFakeEmail handles long phone number', () {
        final result = phoneToFakeEmail('123456789012345');
        expect(result, 'parent123456789012345@madrasa.local');
      });

      test('phoneToFakeEmail handles empty string', () {
        final result = phoneToFakeEmail('');
        expect(result, 'parent@madrasa.local');
      });

      test('phoneToFakeEmail preserves leading zeros', () {
        final result = phoneToFakeEmail('0501234567');
        expect(result, 'parent0501234567@madrasa.local');
      });
    });

    group('Integration Tests', () {
      test('normalizePhone and phoneToFakeEmail work together', () {
        final formattedPhone = '050 123 4567';
        final normalized = normalizePhone(formattedPhone);
        final email = phoneToFakeEmail(normalized);
        expect(email, 'parent0501234567@madrasa.local');
      });

      test('normalizePhone and phoneToFakeEmail with country code', () {
        final formattedPhone = '+966-50-123-4567';
        final normalized = normalizePhone(formattedPhone);
        final email = phoneToFakeEmail(normalized);
        expect(email, 'parent966501234567@madrasa.local');
      });

      test('normalizePhone and phoneToFakeEmail with parentheses', () {
        final formattedPhone = '(050) 123-4567';
        final normalized = normalizePhone(formattedPhone);
        final email = phoneToFakeEmail(normalized);
        expect(email, 'parent0501234567@madrasa.local');
      });
    });
  });
}
