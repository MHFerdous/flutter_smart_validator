import '../models/validation_rule.dart';

/// Validates email format using a comprehensive regex pattern.
class EmailRule extends ValidationRule {
  /// Regular expression for email validation.
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  /// Creates an email validation rule.
  ///
  /// The [errorMessage] defaults to "Must be a valid email address".
  const EmailRule([super.errorMessage = 'Must be a valid email address']);

  @override
  String? validate(String? value, [Map<String, dynamic>? context]) {
    if (value == null || value.isEmpty) {
      return null; // Let RequiredRule handle empty values
    }
    if (!_emailRegex.hasMatch(value)) {
      return errorMessage;
    }
    return null;
  }

  @override
  List<String> getLiveHints(String? value) {
    if (value == null || value.isEmpty) {
      return ['Must be a valid email address'];
    }
    if (_emailRegex.hasMatch(value)) {
      return ['✓ Valid email format'];
    }
    return ['Invalid email format'];
  }
}
