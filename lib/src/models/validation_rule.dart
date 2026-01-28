/// Abstract base class for all validation rules.
///
/// Extend this class to create custom validation rules with support for
/// error messages, live hints, and context-aware validation.
abstract class ValidationRule {
  /// The error message to display when validation fails.
  final String errorMessage;

  const ValidationRule(this.errorMessage);

  /// Validates the given [value] and returns an error message if invalid.
  ///
  /// Returns `null` if the value is valid.
  ///
  /// The optional [context] parameter allows passing additional data
  /// for context-aware validation (e.g., matching fields, API data).
  String? validate(String? value, [Map<String, dynamic>? context]);

  /// Returns live hints for progressive validation feedback.
  ///
  /// These hints help users understand requirements as they type.
  /// For example, password rules might return:
  /// - "At least 8 characters"
  /// - "Contains uppercase letter"
  /// - "Contains number"
  ///
  /// Returns an empty list by default.
  List<String> getLiveHints(String? value) => [];
}
