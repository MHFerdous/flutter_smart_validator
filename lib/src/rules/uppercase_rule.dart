import '../models/validation_rule.dart';

/// Validates that a string contains uppercase letters.
class UppercaseRule extends ValidationRule {
  /// The minimum number of uppercase letters required.
  final int minCount;

  /// Creates an uppercase validation rule.
  ///
  /// Set [minCount] to require a specific number of uppercase letters.
  /// Defaults to 1.
  UppercaseRule({this.minCount = 1, String? errorMessage})
    : super(
        errorMessage ??
            'Must contain at least $minCount uppercase ${minCount == 1 ? 'letter' : 'letters'}',
      );

  @override
  String? validate(String? value, [Map<String, dynamic>? context]) {
    if (value == null || value.isEmpty) {
      return null; // Let RequiredRule handle empty values
    }

    final uppercaseCount = value
        .split('')
        .where((char) => _isUppercase(char))
        .length;

    if (uppercaseCount < minCount) {
      return errorMessage;
    }

    return null;
  }

  @override
  List<String> getLiveHints(String? value) {
    if (value == null || value.isEmpty) {
      return [
        'Needs $minCount uppercase ${minCount == 1 ? 'letter' : 'letters'}',
      ];
    }

    final uppercaseCount = value
        .split('')
        .where((char) => _isUppercase(char))
        .length;

    if (uppercaseCount >= minCount) {
      return ['✓ Uppercase requirement met'];
    }

    return ['Uppercase: $uppercaseCount/$minCount'];
  }

  bool _isUppercase(String char) {
    return char.toUpperCase() == char && char.toLowerCase() != char;
  }
}
