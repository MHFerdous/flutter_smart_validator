import '../models/validation_rule.dart';

/// Validates credit card numbers using the Luhn algorithm.
class CreditCardRule extends ValidationRule {
  /// Creates a credit card validation rule.
  ///
  /// The [errorMessage] defaults to "Invalid credit card number".
  const CreditCardRule([super.errorMessage = 'Invalid credit card number']);

  @override
  String? validate(String? value, [Map<String, dynamic>? context]) {
    if (value == null || value.isEmpty) {
      return null;
    }

    final cleanValue = value.replaceAll(RegExp(r'\D'), '');
    if (cleanValue.isEmpty) return errorMessage;

    int sum = 0;
    bool alternate = false;
    for (int i = cleanValue.length - 1; i >= 0; i--) {
      int n = int.parse(cleanValue[i]);
      if (alternate) {
        n *= 2;
        if (n > 9) {
          n -= 9;
        }
      }
      sum += n;
      alternate = !alternate;
    }

    if (sum % 10 != 0) {
      return errorMessage;
    }

    return null;
  }

  @override
  List<String> getLiveHints(String? value) {
    if (value == null || value.isEmpty) {
      return ['Must be a valid credit card number'];
    }
    return ['Must be a valid credit card number'];
  }
}
