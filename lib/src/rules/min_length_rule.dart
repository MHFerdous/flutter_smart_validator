import '../models/validation_rule.dart';

/// Validates minimum string length.
class MinLengthRule extends ValidationRule {
  /// The minimum required length.
  final int minLength;

  /// Creates a minimum length validation rule.
  ///
  /// The [errorMessage] can include {min} placeholder which will be replaced
  /// with the actual minimum length value.
  MinLengthRule(this.minLength, [String? errorMessage])
    : super(errorMessage ?? 'Must be at least {min} characters');

  @override
  String? validate(String? value, [Map<String, dynamic>? context]) {
    if (value == null || value.length < minLength) {
      return errorMessage.replaceAll('{min}', minLength.toString());
    }
    return null;
  }

  @override
  List<String> getLiveHints(String? value) {
    final currentLength = value?.length ?? 0;
    if (currentLength < minLength) {
      return ['At least $minLength characters (currently: $currentLength)'];
    }
    return ['✓ Minimum length met'];
  }
}
