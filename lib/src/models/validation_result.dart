/// Represents the result of a validation operation.
///
/// Contains validation state, error messages, live hints, and optional strength score.
class ValidationResult {
  /// Whether the validation passed.
  final bool isValid;

  /// The error message if validation failed, null otherwise.
  final String? errorMessage;

  /// Live hints for progressive validation feedback.
  /// Useful for showing requirements as the user types.
  final List<String> hints;

  /// Optional strength score (0.0 to 1.0) for password validation.
  /// 0.0 = very weak, 1.0 = very strong.
  final double? strength;

  const ValidationResult({
    required this.isValid,
    this.errorMessage,
    this.hints = const [],
    this.strength,
  });

  /// Creates a valid result with no error.
  const ValidationResult.valid({
    List<String> hints = const [],
    double? strength,
  }) : this(
         isValid: true,
         errorMessage: null,
         hints: hints,
         strength: strength,
       );

  /// Creates an invalid result with an error message.
  const ValidationResult.invalid(
    String errorMessage, {
    List<String> hints = const [],
  }) : this(isValid: false, errorMessage: errorMessage, hints: hints);

  /// Creates a copy with updated hints.
  ValidationResult withHints(List<String> hints) {
    return ValidationResult(
      isValid: isValid,
      errorMessage: errorMessage,
      hints: hints,
      strength: strength,
    );
  }

  /// Creates a copy with updated strength.
  ValidationResult withStrength(double strength) {
    return ValidationResult(
      isValid: isValid,
      errorMessage: errorMessage,
      hints: hints,
      strength: strength,
    );
  }

  @override
  String toString() {
    return 'ValidationResult(isValid: $isValid, errorMessage: $errorMessage, hintsCount: ${hints.length}, strength: $strength)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ValidationResult &&
        other.isValid == isValid &&
        other.errorMessage == errorMessage &&
        _listEquals(other.hints, hints) &&
        other.strength == strength;
  }

  @override
  int get hashCode {
    return isValid.hashCode ^
        errorMessage.hashCode ^
        hints.hashCode ^
        strength.hashCode;
  }

  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
