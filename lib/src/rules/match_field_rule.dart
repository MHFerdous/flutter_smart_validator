import '../models/validation_rule.dart';

/// Validates that a field matches another field's value.
///
/// Commonly used for password confirmation fields.
class MatchFieldRule extends ValidationRule {
  /// The key to look up the comparison value in the context.
  final String fieldKey;

  /// The display name of the field to match (for error messages).
  final String fieldName;

  /// Creates a match field validation rule.
  ///
  /// The [fieldKey] is used to retrieve the comparison value from the
  /// validation context. The [fieldName] is used in the error message.
  ///
  /// Example:
  /// ```dart
  /// MatchFieldRule('password', 'Password')
  /// ```
  MatchFieldRule(this.fieldKey, this.fieldName, [String? errorMessage])
    : super(errorMessage ?? 'Must match $fieldName');

  @override
  String? validate(String? value, [Map<String, dynamic>? context]) {
    if (value == null || value.isEmpty) {
      return null; // Let RequiredRule handle empty values
    }

    if (context == null || !context.containsKey(fieldKey)) {
      return 'Unable to compare with $fieldName';
    }

    final compareValue = context[fieldKey];
    if (value != compareValue) {
      return errorMessage.replaceAll('{fieldName}', fieldName);
    }

    return null;
  }

  @override
  List<String> getLiveHints(String? value) {
    return ['Must match $fieldName'];
  }
}
