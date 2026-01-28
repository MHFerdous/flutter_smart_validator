import '../models/validation_rule.dart';

/// A validation rule that wraps a custom validation function.
///
/// This allows developers to define custom validation logic in a single line.
class CustomRule extends ValidationRule {
  /// The custom validation function.
  /// Returns an error message if invalid, null if valid.
  final String? Function(String? value) validator;

  /// Optional function to generate live hints.
  final List<String> Function(String? value)? hintsGenerator;

  /// Creates a custom validation rule.
  ///
  /// The [validator] function should return `null` if the value is valid,
  /// or an error message string if invalid.
  ///
  /// Optionally provide a [hintsGenerator] for live validation feedback.
  ///
  /// Example:
  /// ```dart
  /// CustomRule(
  ///   (value) => value?.contains('@') == true ? null : 'Must contain @',
  /// )
  /// ```
  CustomRule(
    this.validator, {
    this.hintsGenerator,
    String errorMessage = 'Validation failed',
  }) : super(errorMessage);

  @override
  String? validate(String? value, [Map<String, dynamic>? context]) {
    return validator(value);
  }

  @override
  List<String> getLiveHints(String? value) {
    if (hintsGenerator != null) {
      return hintsGenerator!(value);
    }
    return super.getLiveHints(value);
  }
}
