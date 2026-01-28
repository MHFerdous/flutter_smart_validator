import '../models/validation_rule.dart';

/// Validates that a string contains lowercase letters.
class LowercaseRule extends ValidationRule {
  /// The minimum number of lowercase letters required.
  final int minCount;

  /// Creates a lowercase validation rule.
  ///
  /// Set [minCount] to require a specific number of lowercase letters.
  /// Defaults to 1.
  LowercaseRule({this.minCount = 1, String? errorMessage})
    : super(
        errorMessage ??
            'Must contain at least $minCount lowercase ${minCount == 1 ? 'letter' : 'letters'}',
      );

  @override
  String? validate(String? value, [Map<String, dynamic>? context]) {
    if (value == null || value.isEmpty) {
      return null; // Let RequiredRule handle empty values
    }

    final lowercaseCount = value
        .split('')
        .where((char) => _isLowercase(char))
        .length;

    if (lowercaseCount < minCount) {
      return errorMessage;
    }

    return null;
  }

  @override
  List<String> getLiveHints(String? value) {
    if (value == null || value.isEmpty) {
      return [
        'Needs $minCount lowercase ${minCount == 1 ? 'letter' : 'letters'}',
      ];
    }

    final lowercaseCount = value
        .split('')
        .where((char) => _isLowercase(char))
        .length;

    if (lowercaseCount >= minCount) {
      return ['✓ Lowercase requirement met'];
    }

    return ['Lowercase: $lowercaseCount/$minCount'];
  }

  bool _isLowercase(String char) {
    return char.toLowerCase() == char && char.toUpperCase() != char;
  }
}
