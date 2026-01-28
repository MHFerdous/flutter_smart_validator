import 'models/validation_rule.dart';
import 'rules/custom_rule.dart';
import 'rules/email_rule.dart';
import 'rules/lowercase_rule.dart';
import 'rules/match_field_rule.dart';
import 'rules/max_length_rule.dart';
import 'rules/min_length_rule.dart';
import 'rules/number_rule.dart';
import 'rules/required_rule.dart';
import 'rules/uppercase_rule.dart';

/// A chainable, developer-friendly form field validator.
///
/// SmartValidator provides a fluent API for building validation rules
/// with minimal boilerplate. It supports built-in rules, custom validation,
/// and works with any input source.
///
/// Example:
/// ```dart
/// final validator = SmartValidator()
///   .required()
///   .email()
///   .minLength(8)
///   .build();
///
/// // Use with TextFormField
/// TextFormField(
///   validator: validator,
/// )
/// ```
class SmartValidator {
  final List<ValidationRule> _rules = [];
  final Map<String, dynamic>? _context;

  /// Creates a new SmartValidator instance.
  ///
  /// Optionally provide a [context] map for context-aware validation
  /// (e.g., field matching).
  SmartValidator([this._context]);

  /// Adds a required field validation.
  ///
  /// The field must not be null, empty, or whitespace only.
  ///
  /// Example:
  /// ```dart
  /// SmartValidator().required(message: 'Email is required')
  /// ```
  SmartValidator required({String message = 'This field is required'}) {
    _rules.add(RequiredRule(message));
    return this;
  }

  /// Adds a minimum length validation.
  ///
  /// The field must have at least [length] characters.
  ///
  /// Example:
  /// ```dart
  /// SmartValidator().minLength(8, message: 'Password must be at least 8 characters')
  /// ```
  SmartValidator minLength(int length, {String? message}) {
    _rules.add(MinLengthRule(length, message));
    return this;
  }

  /// Adds a maximum length validation.
  ///
  /// The field must not exceed [length] characters.
  ///
  /// Example:
  /// ```dart
  /// SmartValidator().maxLength(50)
  /// ```
  SmartValidator maxLength(int length, {String? message}) {
    _rules.add(MaxLengthRule(length, message));
    return this;
  }

  /// Adds an email format validation.
  ///
  /// The field must be a valid email address.
  ///
  /// Example:
  /// ```dart
  /// SmartValidator().email()
  /// ```
  SmartValidator email({String message = 'Must be a valid email address'}) {
    _rules.add(EmailRule(message));
    return this;
  }

  /// Adds a number validation with optional range constraints.
  ///
  /// Set [min] and [max] to enforce range limits.
  /// Set [allowDecimals] to false to only accept integers.
  ///
  /// Example:
  /// ```dart
  /// SmartValidator().number(min: 0, max: 100, allowDecimals: false)
  /// ```
  SmartValidator number({
    num? min,
    num? max,
    bool allowDecimals = true,
    String? message,
  }) {
    _rules.add(
      NumberRule(
        min: min,
        max: max,
        allowDecimals: allowDecimals,
        errorMessage: message,
      ),
    );
    return this;
  }

  /// Adds an uppercase letter validation.
  ///
  /// The field must contain at least [minCount] uppercase letters.
  ///
  /// Example:
  /// ```dart
  /// SmartValidator().uppercase(minCount: 2)
  /// ```
  SmartValidator uppercase({int minCount = 1, String? message}) {
    _rules.add(UppercaseRule(minCount: minCount, errorMessage: message));
    return this;
  }

  /// Adds a lowercase letter validation.
  ///
  /// The field must contain at least [minCount] lowercase letters.
  ///
  /// Example:
  /// ```dart
  /// SmartValidator().lowercase(minCount: 2)
  /// ```
  SmartValidator lowercase({int minCount = 1, String? message}) {
    _rules.add(LowercaseRule(minCount: minCount, errorMessage: message));
    return this;
  }

  /// Adds a field matching validation.
  ///
  /// The field must match the value of another field identified by [fieldKey]
  /// in the validation context.
  ///
  /// Example:
  /// ```dart
  /// // For password confirmation
  /// final context = {'password': passwordController.text};
  /// SmartValidator(context).matchField('password', 'Password')
  /// ```
  SmartValidator matchField(
    String fieldKey,
    String fieldName, {
    String? message,
  }) {
    _rules.add(MatchFieldRule(fieldKey, fieldName, message));
    return this;
  }

  /// Adds a custom validation rule.
  ///
  /// Provide a validation function that returns `null` if valid,
  /// or an error message string if invalid.
  ///
  /// Optionally provide a [hintsGenerator] for live validation feedback.
  ///
  /// Example:
  /// ```dart
  /// SmartValidator().custom(
  ///   (value) => value?.contains('@') == true ? null : 'Must contain @',
  ///   message: 'Custom validation failed',
  /// )
  /// ```
  SmartValidator custom(
    String? Function(String? value) validator, {
    String message = 'Validation failed',
    List<String> Function(String? value)? hintsGenerator,
  }) {
    _rules.add(
      CustomRule(
        validator,
        errorMessage: message,
        hintsGenerator: hintsGenerator,
      ),
    );
    return this;
  }

  /// Builds a synchronous validator function for use with TextFormField.
  ///
  /// Returns a function that takes a String? value and returns String? error.
  ///
  /// Example:
  /// ```dart
  /// TextFormField(
  ///   validator: SmartValidator().required().email().build(),
  /// )
  /// ```
  String? Function(String?) build() {
    return (String? value) {
      for (final rule in _rules) {
        final error = rule.validate(value, _context);
        if (error != null) {
          return error;
        }
      }
      return null;
    };
  }

  /// Validates a value and returns all errors (not just the first).
  ///
  /// Useful for displaying multiple validation errors at once.
  ///
  /// Returns a list of error messages, or an empty list if valid.
  List<String> validateAll(String? value) {
    final errors = <String>[];
    for (final rule in _rules) {
      final error = rule.validate(value, _context);
      if (error != null) {
        errors.add(error);
      }
    }
    return errors;
  }

  /// Gets live validation hints from all rules.
  ///
  /// Useful for progressive validation feedback as the user types.
  ///
  /// Returns a list of hint strings.
  ///
  /// Example:
  /// ```dart
  /// final hints = SmartValidator()
  ///   .required()
  ///   .minLength(8)
  ///   .uppercase()
  ///   .getLiveHints(currentValue);
  /// ```
  List<String> getLiveHints(String? value) {
    final hints = <String>[];
    for (final rule in _rules) {
      hints.addAll(rule.getLiveHints(value));
    }
    return hints;
  }

  /// Creates a copy of this validator with an updated context.
  ///
  /// Useful for dynamic field matching where context values change.
  SmartValidator withContext(Map<String, dynamic> context) {
    final newValidator = SmartValidator(context);
    newValidator._rules.addAll(_rules);
    return newValidator;
  }
}
