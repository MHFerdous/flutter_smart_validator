import 'dart:async';
import '../models/validation_result.dart';
import '../models/validation_rule.dart';

/// A validator that supports asynchronous validation.
///
/// Useful for API calls, database lookups, or any validation that requires
/// async operations (e.g., checking username availability).
///
/// Example:
/// ```dart
/// final validator = AsyncValidator(
///   (value) async {
///     final isAvailable = await checkUsernameAvailability(value);
///     return isAvailable
///         ? ValidationResult.valid()
///         : ValidationResult.invalid('Username is taken');
///   },
///   debounceMilliseconds: 500,
/// );
///
/// final result = await validator.validate('john_doe');
/// ```
class AsyncValidator {
  /// The async validation function.
  final Future<ValidationResult> Function(String? value) validator;

  /// Debounce duration in milliseconds to prevent excessive API calls.
  final int debounceMilliseconds;

  /// Optional synchronous rules to run before async validation.
  final List<ValidationRule> syncRules;

  Timer? _debounceTimer;

  /// Creates an async validator.
  ///
  /// Set [debounceMilliseconds] to add a delay before validation executes.
  /// This is useful to prevent excessive API calls while the user is typing.
  ///
  /// Optionally provide [syncRules] to run synchronous validation first
  /// (e.g., required, minLength) before making async calls.
  AsyncValidator(
    this.validator, {
    this.debounceMilliseconds = 300,
    this.syncRules = const [],
  });

  /// Validates the value asynchronously with debouncing.
  ///
  /// If [debounceMilliseconds] > 0, waits before executing the validation.
  /// Subsequent calls within the debounce period cancel previous validations.
  ///
  /// Returns a [ValidationResult] with the validation outcome.
  Future<ValidationResult> validate(
    String? value, [
    Map<String, dynamic>? context,
  ]) async {
    // Run synchronous rules first
    for (final rule in syncRules) {
      final error = rule.validate(value, context);
      if (error != null) {
        return ValidationResult.invalid(error);
      }
    }

    // Handle debouncing
    if (debounceMilliseconds > 0) {
      final completer = Completer<ValidationResult>();

      _debounceTimer?.cancel();
      _debounceTimer = Timer(
        Duration(milliseconds: debounceMilliseconds),
        () async {
          try {
            final result = await validator(value);
            if (!completer.isCompleted) {
              completer.complete(result);
            }
          } catch (e) {
            if (!completer.isCompleted) {
              completer.completeError(e);
            }
          }
        },
      );

      return completer.future;
    }

    // No debouncing, execute immediately
    return validator(value);
  }

  /// Cancels any pending debounced validation.
  void cancel() {
    _debounceTimer?.cancel();
    _debounceTimer = null;
  }

  /// Disposes the validator and cancels any pending operations.
  void dispose() {
    cancel();
  }
}

/// Builder for creating async validators with a fluent API.
///
/// Example:
/// ```dart
/// final validator = AsyncValidatorBuilder()
///   .required()
///   .minLength(3)
///   .async((value) async {
///     return await checkAvailability(value);
///   })
///   .build();
/// ```
class AsyncValidatorBuilder {
  final List<ValidationRule> _syncRules = [];
  Future<ValidationResult> Function(String? value)? _asyncValidator;
  int _debounceMilliseconds = 300;

  /// Adds a synchronous validation rule.
  AsyncValidatorBuilder addRule(ValidationRule rule) {
    _syncRules.add(rule);
    return this;
  }

  /// Sets the async validation function.
  AsyncValidatorBuilder async(
    Future<ValidationResult> Function(String? value) validator,
  ) {
    _asyncValidator = validator;
    return this;
  }

  /// Sets the debounce duration in milliseconds.
  AsyncValidatorBuilder debounce(int milliseconds) {
    _debounceMilliseconds = milliseconds;
    return this;
  }

  /// Builds the async validator.
  ///
  /// Throws if no async validator function was provided.
  AsyncValidator build() {
    if (_asyncValidator == null) {
      throw StateError('Async validator function is required');
    }

    return AsyncValidator(
      _asyncValidator!,
      debounceMilliseconds: _debounceMilliseconds,
      syncRules: _syncRules,
    );
  }
}
