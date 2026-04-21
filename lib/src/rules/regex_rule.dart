import '../models/validation_rule.dart';

/// Validates that a value matches a specific regular expression.
class RegexRule extends ValidationRule {
  /// The regular expression to match.
  final RegExp pattern;

  /// Creates a regex validation rule.
  ///
  /// The [pattern] is the RegExp to match against.
  /// The [errorMessage] defaults to "Invalid format".
  const RegexRule(this.pattern, [super.errorMessage = 'Invalid format']);

  @override
  String? validate(String? value, [Map<String, dynamic>? context]) {
    if (value == null || value.isEmpty) {
      return null; // Let RequiredRule handle empty values
    }

    if (!pattern.hasMatch(value)) {
      return errorMessage;
    }

    return null;
  }

  @override
  List<String> getLiveHints(String? value) {
    if (value == null || value.isEmpty) {
      return [errorMessage];
    }
    if (pattern.hasMatch(value)) {
      return ['✓ Valid format'];
    }
    return [errorMessage];
  }
}
