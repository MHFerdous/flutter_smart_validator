import '../models/validation_rule.dart';

/// Validates numeric input with optional range constraints.
class NumberRule extends ValidationRule {
  /// Minimum allowed value (inclusive).
  final num? min;

  /// Maximum allowed value (inclusive).
  final num? max;

  /// Whether to allow decimal numbers. Defaults to true.
  final bool allowDecimals;

  /// Creates a number validation rule.
  ///
  /// Set [min] and [max] to enforce range constraints.
  /// Set [allowDecimals] to false to only accept integers.
  NumberRule({
    this.min,
    this.max,
    this.allowDecimals = true,
    String? errorMessage,
  }) : super(errorMessage ?? _buildDefaultMessage(min, max, allowDecimals));

  static String _buildDefaultMessage(num? min, num? max, bool allowDecimals) {
    final type = allowDecimals ? 'number' : 'integer';
    if (min != null && max != null) {
      return 'Must be a $type between $min and $max';
    } else if (min != null) {
      return 'Must be a $type greater than or equal to $min';
    } else if (max != null) {
      return 'Must be a $type less than or equal to $max';
    }
    return 'Must be a valid $type';
  }

  @override
  String? validate(String? value, [Map<String, dynamic>? context]) {
    if (value == null || value.isEmpty) {
      return null; // Let RequiredRule handle empty values
    }

    final number = num.tryParse(value);
    if (number == null) {
      return errorMessage;
    }

    if (!allowDecimals && number != number.toInt()) {
      return 'Must be an integer';
    }

    if (min != null && number < min!) {
      return 'Must be greater than or equal to $min';
    }

    if (max != null && number > max!) {
      return 'Must be less than or equal to $max';
    }

    return null;
  }

  @override
  List<String> getLiveHints(String? value) {
    final hints = <String>[];

    if (value == null || value.isEmpty) {
      hints.add(allowDecimals ? 'Enter a number' : 'Enter an integer');
      return hints;
    }

    final number = num.tryParse(value);
    if (number == null) {
      return ['✗ Invalid number format'];
    }

    if (!allowDecimals && number != number.toInt()) {
      return ['✗ Must be an integer'];
    }

    if (min != null && max != null) {
      hints.add('Range: $min to $max');
    } else if (min != null) {
      hints.add('Minimum: $min');
    } else if (max != null) {
      hints.add('Maximum: $max');
    }

    if ((min != null && number < min!) || (max != null && number > max!)) {
      hints.insert(0, '✗ Out of range');
    } else {
      hints.insert(0, '✓ Valid number');
    }

    return hints;
  }
}
