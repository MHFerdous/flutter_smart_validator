import '../models/validation_rule.dart';

/// Validates international phone numbers.
class PhoneRule extends ValidationRule {
  static final RegExp _phoneRegex = RegExp(
    r'^\+?[1-9]\d{6,14}$',
  );

  /// Creates a phone validation rule.
  ///
  /// The [errorMessage] defaults to "Invalid phone number".
  const PhoneRule([super.errorMessage = 'Invalid phone number']);

  @override
  String? validate(String? value, [Map<String, dynamic>? context]) {
    if (value == null || value.isEmpty) {
      return null;
    }

    final normalized = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    if (!_phoneRegex.hasMatch(normalized)) {
      return errorMessage;
    }
    return null;
  }

  @override
  List<String> getLiveHints(String? value) {
    if (value == null || value.isEmpty) {
      return ['Must be a valid phone number'];
    }
    return ['Must be a valid phone number'];
  }
}
