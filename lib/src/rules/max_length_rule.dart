import '../models/validation_rule.dart';

/// Validates maximum string length.
class MaxLengthRule extends ValidationRule {
  /// The maximum allowed length.
  final int maxLength;

  /// Creates a maximum length validation rule.
  ///
  /// The [errorMessage] can include {max} placeholder which will be replaced
  /// with the actual maximum length value.
  MaxLengthRule(this.maxLength, [String? errorMessage])
    : super(errorMessage ?? 'Must not exceed {max} characters');

  @override
  String? validate(String? value, [Map<String, dynamic>? context]) {
    if (value != null && value.length > maxLength) {
      return errorMessage.replaceAll('{max}', maxLength.toString());
    }
    return null;
  }

  @override
  List<String> getLiveHints(String? value) {
    final currentLength = value?.length ?? 0;
    final remaining = maxLength - currentLength;
    if (remaining < 0) {
      return ['✗ Exceeds maximum length by ${-remaining}'];
    } else if (remaining <= 10) {
      return ['$remaining characters remaining'];
    }
    return ['Maximum $maxLength characters'];
  }
}
