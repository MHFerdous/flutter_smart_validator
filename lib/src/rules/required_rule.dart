import '../models/validation_rule.dart';

/// Validates that a field is not null, empty, or whitespace only.
class RequiredRule extends ValidationRule {
  /// Creates a required validation rule.
  ///
  /// The [errorMessage] defaults to "This field is required".
  const RequiredRule([super.errorMessage = 'This field is required']);

  @override
  String? validate(String? value, [Map<String, dynamic>? context]) {
    if (value == null || value.trim().isEmpty) {
      return errorMessage;
    }
    return null;
  }

  @override
  List<String> getLiveHints(String? value) {
    return ['Required field'];
  }
}
