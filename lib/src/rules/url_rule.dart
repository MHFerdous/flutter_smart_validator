import '../models/validation_rule.dart';

/// Validates that a value is a valid URL.
class UrlRule extends ValidationRule {
  static final RegExp _urlRegex = RegExp(
    r'^(https?|ftp)://(-\.)?([^\s/?\.#-]+\.?)+(/[^\s]*)?$',
    caseSensitive: false,
  );

  /// Creates a URL validation rule.
  ///
  /// The [errorMessage] defaults to "Must be a valid URL".
  const UrlRule([super.errorMessage = 'Must be a valid URL']);

  @override
  String? validate(String? value, [Map<String, dynamic>? context]) {
    if (value == null || value.isEmpty) {
      return null;
    }
    if (!_urlRegex.hasMatch(value)) {
      return errorMessage;
    }
    return null;
  }

  @override
  List<String> getLiveHints(String? value) {
    if (value == null || value.isEmpty) {
      return ['Must be a valid URL'];
    }
    if (_urlRegex.hasMatch(value)) {
      return ['✓ Valid URL format'];
    }
    return ['Invalid URL format'];
  }
}
