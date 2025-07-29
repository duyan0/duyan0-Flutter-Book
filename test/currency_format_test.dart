import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

// Hàm format tiền tệ Việt Nam
String formatCurrencyVN(double? amount) {
  if (amount == null) return '0 đ';
  
  final formatter = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: 'đ',
    decimalDigits: 0,
  );
  
  return formatter.format(amount);
}

void main() {
  group('Currency Format Tests', () {
    test('should format positive amounts correctly', () {
      expect(formatCurrencyVN(1000), '1.000 đ');
      expect(formatCurrencyVN(10000), '10.000 đ');
      expect(formatCurrencyVN(100000), '100.000 đ');
      expect(formatCurrencyVN(1000000), '1.000.000 đ');
      expect(formatCurrencyVN(1234567), '1.234.567 đ');
    });

    test('should format zero amount correctly', () {
      expect(formatCurrencyVN(0), '0 đ');
      expect(formatCurrencyVN(0.0), '0 đ');
    });

    test('should format decimal amounts correctly', () {
      expect(formatCurrencyVN(1000.5), '1.001 đ'); // Rounds up
      expect(formatCurrencyVN(1000.4), '1.000 đ'); // Rounds down
      expect(formatCurrencyVN(1000.9), '1.001 đ'); // Rounds up
    });

    test('should handle null amount', () {
      expect(formatCurrencyVN(null), '0 đ');
    });

    test('should format large amounts correctly', () {
      expect(formatCurrencyVN(999999999), '999.999.999 đ');
      expect(formatCurrencyVN(1000000000), '1.000.000.000 đ');
    });

    test('should format small amounts correctly', () {
      expect(formatCurrencyVN(1), '1 đ');
      expect(formatCurrencyVN(99), '99 đ');
      expect(formatCurrencyVN(999), '999 đ');
    });

    test('should format amounts with Vietnamese locale', () {
      // Test that the format uses Vietnamese locale (dots as thousand separators)
      final result = formatCurrencyVN(1234567);
      expect(result, '1.234.567 đ');
      
      // Verify it's not using comma as thousand separator (US format)
      expect(result, isNot('1,234,567 đ'));
    });

    test('should use đ symbol correctly', () {
      final result = formatCurrencyVN(1000);
      expect(result, '1.000 đ');
      
      // Verify it uses đ symbol, not VND or other currency symbols
      expect(result, isNot('1.000 VND'));
      expect(result, isNot('1.000 $'));
      expect(result, isNot('1.000 €'));
    });

    test('should not show decimal places', () {
      expect(formatCurrencyVN(1000.99), '1.001 đ'); // Rounds and no decimals
      expect(formatCurrencyVN(1000.01), '1.000 đ'); // Rounds and no decimals
    });

    test('should handle edge cases', () {
      expect(formatCurrencyVN(double.infinity), '0 đ');
      expect(formatCurrencyVN(double.negativeInfinity), '0 đ');
      expect(formatCurrencyVN(double.nan), '0 đ');
    });

    test('should format negative amounts correctly', () {
      expect(formatCurrencyVN(-1000), '-1.000 đ');
      expect(formatCurrencyVN(-100000), '-100.000 đ');
      expect(formatCurrencyVN(-1234567), '-1.234.567 đ');
    });

    test('should format amounts with different precision', () {
      expect(formatCurrencyVN(1000.123), '1.000 đ');
      expect(formatCurrencyVN(1000.456), '1.000 đ');
      expect(formatCurrencyVN(1000.789), '1.001 đ');
    });

    test('should maintain consistency across different amounts', () {
      final amounts = [1000, 10000, 100000, 1000000];
      final results = amounts.map((amount) => formatCurrencyVN(amount.toDouble())).toList();
      
      expect(results[0], '1.000 đ');
      expect(results[1], '10.000 đ');
      expect(results[2], '100.000 đ');
      expect(results[3], '1.000.000 đ');
      
      // Verify all results follow the same pattern
      for (final result in results) {
        expect(result, matches(r'^-?\d{1,3}(\.\d{3})* đ$'));
      }
    });
  });

  group('NumberFormat Integration Tests', () {
    test('should use correct NumberFormat configuration', () {
      final formatter = NumberFormat.currency(
        locale: 'vi_VN',
        symbol: 'đ',
        decimalDigits: 0,
      );
      
      expect(formatter.format(1000), '1.000 đ');
      expect(formatter.format(1000000), '1.000.000 đ');
    });

    test('should handle locale-specific formatting', () {
      // Test that Vietnamese locale is used correctly
      final viFormatter = NumberFormat.currency(
        locale: 'vi_VN',
        symbol: 'đ',
        decimalDigits: 0,
      );
      
      final usFormatter = NumberFormat.currency(
        locale: 'en_US',
        symbol: '\$',
        decimalDigits: 0,
      );
      
      final viResult = viFormatter.format(1234567);
      final usResult = usFormatter.format(1234567);
      
      expect(viResult, '1.234.567 đ');
      expect(usResult, '\$1,234,567');
      
      // Verify different formatting between locales
      expect(viResult, isNot(usResult));
    });
  });

  group('Performance Tests', () {
    test('should format large number of amounts efficiently', () {
      final stopwatch = Stopwatch()..start();
      
      for (int i = 0; i < 10000; i++) {
        formatCurrencyVN(i.toDouble());
      }
      
      stopwatch.stop();
      
      // Should complete within reasonable time (less than 1 second)
      expect(stopwatch.elapsedMilliseconds, lessThan(1000));
    });

    test('should handle repeated formatting of same amount', () {
      final amount = 1234567.0;
      final results = <String>[];
      
      for (int i = 0; i < 1000; i++) {
        results.add(formatCurrencyVN(amount));
      }
      
      // All results should be identical
      final firstResult = results.first;
      for (final result in results) {
        expect(result, firstResult);
      }
      
      expect(firstResult, '1.234.567 đ');
    });
  });
} 